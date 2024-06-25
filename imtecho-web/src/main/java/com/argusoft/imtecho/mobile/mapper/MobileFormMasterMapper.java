package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.mobile.dto.ComponentTagDto;
import com.argusoft.imtecho.mobile.model.MobileFormMaster;
import com.argusoft.imtecho.mobile.model.MobileFormMasterPKey;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

public class MobileFormMasterMapper {

    private MobileFormMasterMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static List<MobileFormMaster> convertComponentTagDtoToMobileFormMaster(List<ComponentTagDto> dtos, String formCode) {
        if (dtos == null || dtos.isEmpty())
            return new ArrayList<>();

        if (formCode == null || formCode.isEmpty())
            throw new ImtechoSystemException("Form Code cannot be empty", 100);

        Gson gson = new Gson();
        List<MobileFormMaster> masters = new ArrayList<>();
        for (ComponentTagDto dto : dtos) {
            MobileFormMaster master = new MobileFormMaster();
            master.setMobileFormMasterPKey(new MobileFormMasterPKey(dto.getId(), formCode));
            if (dto.getTitle() != null && !dto.getTitle().isEmpty())
                master.setTitle(dto.getTitle());
            if (dto.getSubtitle() != null && !dto.getSubtitle().isEmpty())
                master.setSubtitle(dto.getSubtitle());
            if (dto.getInstruction() != null && !dto.getInstruction().isEmpty())
                master.setInstruction(dto.getInstruction());
            if (dto.getQuestion() != null && !dto.getQuestion().isEmpty())
                master.setQuestion(dto.getQuestion());
            if (dto.getType() != null && !dto.getType().isEmpty())
                master.setType(dto.getType());
            if (dto.getIsmandatory() != null && !dto.getIsmandatory().isEmpty())
                master.setMandatory(ImtechoUtil.returnTrueFalseFromInitials(dto.getIsmandatory()));
            if (dto.getMandatorymessage() != null && !dto.getMandatorymessage().isEmpty())
                master.setMandatoryMessage(dto.getMandatorymessage());
            if (dto.getValidations() != null && !dto.getValidations().isEmpty())
                master.setValidation(gson.toJson(dto.getValidations()));
            if (dto.getFormulas() != null && !dto.getFormulas().isEmpty())
                master.setFormula(gson.toJson(dto.getFormulas()));
            if (dto.getDatamap() != null && !dto.getDatamap().isEmpty())
                master.setDatamap(dto.getDatamap());
            if (dto.getOptions() != null && !dto.getOptions().isEmpty())
                master.setOptions(gson.toJson(dto.getOptions()));
            if (dto.getNext() != null && !dto.getNext().isEmpty())
                master.setNext(Float.valueOf(dto.getNext()).intValue());
            if (dto.getSubform() != null && !dto.getSubform().isEmpty())
                master.setSubform(dto.getSubform());
            if (dto.getRelatedpropertyname() != null && !dto.getRelatedpropertyname().isEmpty())
                master.setRelatedPropertyName(dto.getRelatedpropertyname());
            if (dto.getIshidden() != null && !dto.getIshidden().isEmpty())
                master.setHidden(ImtechoUtil.returnTrueFalseFromInitials(dto.getIshidden()));
            if (dto.getEvent() != null && !dto.getEvent().isEmpty())
                master.setEvent(dto.getEvent());
            if (dto.getBinding() != null && !dto.getBinding().isEmpty())
                master.setBinding(Float.valueOf(dto.getBinding()).intValue());
            if (dto.getPage() != null && !dto.getPage().isEmpty())
                master.setPage(Float.valueOf(dto.getPage()).intValue());
            if (dto.getHint() != null && !dto.getHint().isEmpty())
                master.setHint(dto.getHint());
            if (dto.getHelpvideofield() != null && !dto.getHelpvideofield().isEmpty())
                master.setHelpVideo(dto.getHelpvideofield());
//            if (dto.getListValueFieldKey() != null && !dto.getListValueFieldKey().isEmpty())
//                master.setListValueFieldKey(dto.getListValueFieldKey());

            master.setLength(dto.getLength());
            master.setRow(dto.getRow());
            masters.add(master);
        }
        return masters;
    }
}

