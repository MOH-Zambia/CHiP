package com.argusoft.imtecho.formconfigurator.service.impl;

import com.argusoft.imtecho.event.dao.EventConfigurationDao;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.model.EventConfiguration;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormDataMasterDao;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormMasterDao;
import com.argusoft.imtecho.formconfigurator.dao.MedplatFormVersionHistoryDao;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormDataDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormDataQueryConfigDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormDataQueryDto;
import com.argusoft.imtecho.formconfigurator.dto.MedplatFormDataQueryParamDto;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormDataMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormMaster;
import com.argusoft.imtecho.formconfigurator.models.MedplatFormVersionHistory;
import com.argusoft.imtecho.formconfigurator.service.MedplatFormDataService;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.query.service.QueryMasterService;
import com.google.common.reflect.TypeToken;
import com.google.gson.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Transactional
public class MedplatFormDataServiceImpl implements MedplatFormDataService {

    @Autowired
    private MedplatFormMasterDao medplatFormMasterDao;

    @Autowired
    private MedplatFormVersionHistoryDao medplatFormVersionHistoryDao;

    @Autowired
    private MedplatFormDataMasterDao medplatFormDataMasterDao;

    @Autowired
    private QueryMasterService queryMasterService;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private EventConfigurationDao eventConfigurationDao;

    private MedplatFormDataDto medplatFormDataDto;

    private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX";

    public MedplatFormDataServiceImpl() {
        this.medplatFormDataDto = new MedplatFormDataDto();
    }

    @Override
    public Integer dumpFormData(String formCode, String data) {
        String version = String.valueOf(new Date().getTime());
        MedplatFormDataMaster medplatFormDataMaster = new MedplatFormDataMaster();
        medplatFormDataMaster.setFormCode(formCode);
        medplatFormDataMaster.setData(data);
        medplatFormDataMaster.setVersion(version);
        return medplatFormDataMasterDao.create(medplatFormDataMaster);
    }

    @Override
    public void saveFormData(String formCode, String data, Integer masterId) {
        MedplatFormMaster medplatFormMaster = medplatFormMasterDao.retrieveByFormCode(formCode);
        MedplatFormVersionHistory medplatFormVersionHistory = medplatFormVersionHistoryDao.retrieveMedplatFormByCriteria(medplatFormMaster.getUuid(), medplatFormMaster.getCurrentVersion());
        Type queryConfigType = new TypeToken<List<MedplatFormDataQueryConfigDto>>() {
        }.getType();
        List<MedplatFormDataQueryConfigDto> queryConfigDtos = new Gson().fromJson(medplatFormVersionHistory.getQueryConfig(), queryConfigType);
        JsonElement element = JsonParser.parseString(data);
        medplatFormDataDto.setFormDataElement(element.getAsJsonObject().get("formData"));
        medplatFormDataDto.setFormMetaDataElement(element.getAsJsonObject().get("metaData"));
        queryConfigDtos.forEach(query -> {
            MedplatFormDataQueryDto medplatFormDataQueryDto = new MedplatFormDataQueryDto();
            medplatFormDataDto.getQueries().put(query.getQueryCode(), medplatFormDataQueryDto);
            processFormDataQuery(query, medplatFormDataDto.getFormDataElement());
        });
        if (medplatFormDataDto.getEvent() != null) {
            eventHandler.handle(medplatFormDataDto.getEvent());
        }
    }

    private void processFormDataQuery(MedplatFormDataQueryConfigDto queryConfigDto, JsonElement formDataElement) {
        JsonElement queryElement = extractByPath(
                formDataElement,
                queryConfigDto.getQueryPath()
                        .replace("$formData$", "formData")
                        .split("\\."),
                1
        );
        if (Boolean.TRUE.equals(queryConfigDto.getHasLoop())) {
            JsonArray elementArray = queryElement.getAsJsonArray();
            for (int i = 0; i < elementArray.size(); i++) {
                JsonObject element = elementArray.get(i).getAsJsonObject();
                executeQuery(queryConfigDto, element);
                if (queryConfigDto.getSubQueries() != null && !queryConfigDto.getSubQueries().isEmpty()) {
                    queryConfigDto.getSubQueries().forEach(query -> {
                        MedplatFormDataQueryDto medplatFormDataQueryDto = new MedplatFormDataQueryDto();
                        medplatFormDataDto.getQueries().put(query.getQueryCode(), medplatFormDataQueryDto);
                        processFormDataQuery(query, element);
                    });
                }
            }
        } else {
            JsonObject element = queryElement.getAsJsonObject();
            executeQuery(queryConfigDto, element);
            if (queryConfigDto.getSubQueries() != null && !queryConfigDto.getSubQueries().isEmpty()) {
                queryConfigDto.getSubQueries().forEach(query -> {
                    MedplatFormDataQueryDto medplatFormDataQueryDto = new MedplatFormDataQueryDto();
                    medplatFormDataDto.getQueries().put(query.getQueryCode(), medplatFormDataQueryDto);
                    processFormDataQuery(query, element);
                });
            }
        }
    }

    private void executeQuery(MedplatFormDataQueryConfigDto queryConfigDto, JsonElement element) {
        QueryDto queryDto = new QueryDto();
        queryDto.setCode(queryConfigDto.getQueryCode());
        queryDto.setQuery(queryConfigDto.getQuery());
        queryDto.setParameters(processFormDataQueryParams(queryConfigDto, element));
        List<LinkedHashMap<String, Object>> queryResult = queryMasterService.executeFormConfiguratorQuery(queryDto);
        if (queryResult != null && !queryResult.isEmpty()) {
            LinkedHashMap<String, Object> response = queryResult.get(0);
            medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).setResponse(response);
            if (Boolean.TRUE.equals(queryConfigDto.getIsEventResource())) {
                EventConfiguration event = eventConfigurationDao.retrieveByUUID(queryConfigDto.getEventUUID());
                Integer eventResourceId = (Integer) response.get(queryConfigDto.getEventResourceIdKey());
                medplatFormDataDto.setEvent(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, event.getEventTypeDetailCode(), eventResourceId));
            }
        }
    }

    private LinkedHashMap<String, Object> processFormDataQueryParams(MedplatFormDataQueryConfigDto queryConfigDto, JsonElement element) {
        List<MedplatFormDataQueryParamDto> params = queryConfigDto.getParams();
        JsonObject elementObject = element.getAsJsonObject();
        LinkedHashMap<String, Object> parameters = new LinkedHashMap<>();
        params.forEach(param -> {
            switch (param.getType()) {
                case FIELD -> {
                    JsonElement valueElement = elementObject.get(param.getValueKey());
                    if (valueElement == null) {
                        parameters.put(param.getKey(), null);
                        medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), null);
                    } else if (valueElement.isJsonArray()) {
                        String value = "";
                        if (!valueElement.getAsJsonArray().isEmpty() && valueElement.getAsJsonArray().get(0).isJsonObject()) {
                            value = valueElement.toString();
                        } else {
                            value = convertJsonElementToList(valueElement);
                        }
                        parameters.put(param.getKey(), value);
                        medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), value);
                    } else {
                        Object value = convertJsonElementToObject(valueElement);
                        parameters.put(param.getKey(), value);
                        medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), value);
                    }
                }
                case REFERENCE_QUERY_PARAM -> {
                    Object value = medplatFormDataDto.getQueries().get(param.getReferenceQuery()).getParams().get(param.getReferenceParam());
                    parameters.put(param.getKey(), value);
                    medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), value);
                }
                case REFERENCE_QUERY_RESPONSE -> {
                    Object value = medplatFormDataDto.getQueries().get(param.getReferenceQuery()).getResponse().get(param.getReferenceParam());
                    parameters.put(param.getKey(), value);
                    medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), value);
                }
                case META_DATA -> {
                    Object value = convertJsonElementToObject(medplatFormDataDto.getFormMetaDataElement().getAsJsonObject().get(param.getValueKey()));
                    parameters.put(param.getKey(), value);
                    medplatFormDataDto.getQueries().get(queryConfigDto.getQueryCode()).getParams().put(param.getKey(), value);
                }
                default -> throw new ImtechoSystemException("Error", 500);
            }
        });
        return parameters;
    }

    private JsonElement extractByPath(JsonElement element, String[] paths, int index) {
        if (index == paths.length) {
            return element;
        }
        String path = paths[index];
        JsonElement nextElement = element.getAsJsonObject().get(path);
        return extractByPath(nextElement, paths, index + 1);
    }

    private Object convertJsonElementToObject(JsonElement jsonElement) {
        if (jsonElement.isJsonPrimitive()) {
            JsonPrimitive jsonPrimitive = jsonElement.getAsJsonPrimitive();
            if (jsonPrimitive.isBoolean()) {
                return jsonElement.getAsBoolean();
            } else if (jsonPrimitive.isNumber()) {
                try {
                    return jsonPrimitive.getAsInt();
                } catch (NumberFormatException e1) {
                    try {
                        return jsonPrimitive.getAsDouble();
                    } catch (NumberFormatException e2) {
                        return jsonElement.getAsString();
                    }
                }
            } else if (jsonPrimitive.isString()) {
                Date date = parseDate(jsonElement.getAsString());
                if (date != null) {
                    return date;
                }
                return jsonElement.getAsString();
            }
        }
        return null;
    }

    private Date parseDate(String date) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_FORMAT, Locale.ENGLISH);
        dateFormat.setLenient(false);
        try {
            return dateFormat.parse(date);
        } catch (ParseException e) {
            // Continue to the next format
        }
        return null;
    }

    private String convertJsonElementToList(JsonElement jsonElement) {
        if (jsonElement.isJsonArray()) {
            List<Object> list = new ArrayList<>();
            JsonArray jsonArray = jsonElement.getAsJsonArray();
            for (JsonElement element : jsonArray) {
                list.add(convertJsonElementToObject(element));
            }
            return list.stream().map(Object::toString).collect(Collectors.joining(","));
        }
        return null;
    }
}
