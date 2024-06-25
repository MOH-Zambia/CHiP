                                        
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.ServerManagementDao;
import com.argusoft.imtecho.common.dto.ServerManagementDto;
import com.argusoft.imtecho.common.dto.SyncServerDto;
import com.argusoft.imtecho.common.dto.SyncWithServerDto;
import com.argusoft.imtecho.common.model.FileDetails;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.common.service.ServerManagementService;
import com.argusoft.imtecho.common.service.SystemConfigurationService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.event.dto.EventConfigurationDto;
import com.argusoft.imtecho.event.service.EventConfigurationService;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.notification.dto.EscalationLevelMasterDto;
import com.argusoft.imtecho.notification.dto.NotificationTypeMasterDto;
import com.argusoft.imtecho.notification.service.NotificationMasterService;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.query.dto.QueryMasterDto;
import com.argusoft.imtecho.query.service.QueryMasterService;
import com.argusoft.imtecho.reportconfig.dto.ReportConfigDto;
import com.argusoft.imtecho.reportconfig.service.ReportService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.TreeTraversingParser;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.jcraft.jsch.*;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

/**
 * Implements methods of ServerManagementService
 * @author vivek
 * @since 28/08/2020 4:30
 */
@Service
public class ServerManagementServiceImpl implements ServerManagementService {

    @Autowired
    private ImtechoSecurityUser currentUser;

    @Autowired
    private ServerManagementDao serverManagementDao;

    @Autowired
    NotificationMasterService notificationMasterService;

    @Autowired
    private EventConfigurationService eventConfigurationService;

    @Autowired
    QueryMasterService queryMasterService;

    @Autowired
    ReportService reportService;

    @Autowired
    SystemConfigurationService systemConfigurationService;


    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public ServerManagementDto retrieveFilesByFolderPath(String folderPath) {
        final File folder = new File(folderPath);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
        ServerManagementDto serverManagementDto = new ServerManagementDto();
        List<FileDetails> fileList = new ArrayList<>();
        File[] files = folder.listFiles();

        Arrays.sort(files, (f1, f2) -> Long.compare(f2.lastModified(), f1.lastModified()));

        //For latest 5 modified files
        int count = 0;
        for (File file : files) {
            if (!(file.isDirectory()) && count < 5) {
                FileDetails fileDetails = new FileDetails();
                fileDetails.setFileName(file.getName());
                fileDetails.setLastModifiedDate(sdf.format(file.lastModified()));
                fileList.add(fileDetails);
                count++;

            }
        }

        serverManagementDto.setFileList(fileList);
        return serverManagementDto;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public ResponseEntity downloadFile(String filePath) {
        File file = new File(filePath);
        return ResponseEntity.ok()
                // Content-Disposition
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + file.getName())
                // Content-Type
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                // Contet-Length
                .contentLength(file.length()) //
                .body(new FileSystemResource(file));

    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public String executeCommand(String command, String host, String userName, String password) {
        StringBuilder result = new StringBuilder();
        String currentUserName = currentUser.getUserName();
        if (currentUserName.equalsIgnoreCase("slamba") || currentUserName.equalsIgnoreCase("hshah")
                || currentUserName.equalsIgnoreCase("kkpatel") || currentUserName.equalsIgnoreCase("hshah_t")
                || currentUserName.equalsIgnoreCase("kkpatel_t")
                || currentUserName.equalsIgnoreCase("slamba_t")) {

            try {

                java.util.Properties config = new java.util.Properties();
                config.put("StrictHostKeyChecking", "no");
                JSch jsch = new JSch();
                Session session = jsch.getSession(userName, host, 22);

                session.setPassword(password);
                session.setConfig(config);
                session.connect();

                Channel channel = session.openChannel("exec");

                ((ChannelExec) channel).setCommand(command);
                channel.setInputStream(null);
                ((ChannelExec) channel).setErrStream(System.err);
                handelCommand(channel,result);


            } catch (Exception e) {
                Logger.getLogger(ServerManagementServiceImpl.class.getName()).log(Level.SEVERE, e.getMessage(), e);
            }
        }
        return result.toString();
    }

    /**
     * Handle command.
     * @param channel Define channel.
     * @param result Define result.
     * @throws IOException If an I/O error occurs when reading or writing.
     * @throws JSchException Define JSchException.
     */
    private void handelCommand(Channel channel,StringBuilder result) throws IOException, JSchException {
        InputStream in = channel.getInputStream();
        channel.connect();
        while (true) {
            if (in.available() >= 0) {
                BufferedReader reader
                        = new BufferedReader(new InputStreamReader(in));
                String line;
                while ((line = reader.readLine()) != null) {
                    result.append(line);
                    result.append("\n");
                }
                break;
            }
            if (channel.isClosed()) {
                result.append("exit-status: " + channel.getExitStatus());
                result.append("\n");
                break;
            }
            try {
                Thread.sleep(1000);
            } catch (Exception ee) {
                Logger.getLogger(ServerManagementServiceImpl.class.getName()).log(Level.SEVERE, ee.getMessage(), ee);
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void fetchAndInsertConfiguration() {
        SystemConfiguration systemConfigurationForServerUrl = systemConfigurationService.retrieveSystemConfigurationByKey("SERVER_URL_FROM_WHERE_NEED_TO_FETCH_CONFIG_JSON_FOR_SYS_SYNC");
        if (systemConfigurationForServerUrl.getKeyValue() != null) {
            SystemConfiguration systemConfiguration = systemConfigurationService.retrieveSystemConfigurationByKey("LAST_ID_TILL_JSON_CONFIG_PROCESSED_FOR_SYSTEM_SYNC");
            SystemConfiguration systemConfigurationServerName = systemConfigurationService.retrieveSystemConfigurationByKey("SERVER_NAME");
            SystemConfiguration systemConfigurationServerPassword = systemConfigurationService.retrieveSystemConfigurationByKey("SERVER_PASSWORD");
            try {
                
                JsonNode configJson = serverManagementDao.getRemoteConfigurations(
                        Integer.parseInt(systemConfiguration.getKeyValue()),
                        systemConfigurationServerName.getKeyValue(),
                        systemConfigurationServerPassword.getKeyValue(),
                        systemConfigurationForServerUrl.getKeyValue());
                if (configJson != null && configJson.size() != 0) {
                   setConfigurationAndProcess(configJson);
                }
            } catch (Exception e) {
                Logger.getLogger(ServerManagementServiceImpl.class.getName()).log(Level.SEVERE, e.getMessage(), e);
            }
        }
    }

    /**
     * Updates given last processed id
     * @param id A id of process
     */
    public void  updateLastProcessedId(Integer id) {
        if (id != 0) {
            SystemConfiguration systemConfiguration = systemConfigurationService.retrieveSystemConfigurationByKey("LAST_ID_TILL_JSON_CONFIG_PROCESSED_FOR_SYSTEM_SYNC");
            if (Integer.parseInt(systemConfiguration.getKeyValue()) != id) {
                systemConfiguration.setKeyValue(id.toString());
                systemConfigurationService.updateSystemConfiguration(systemConfiguration);
            }
        }
    }


    /**
     * Sets configuration and process
     * @param configJson An instance of JsonNode
     * @throws IOException If an I/O error occurs when reading or writing
     */
    public void setConfigurationAndProcess(JsonNode configJson) throws IOException {

        for (JsonNode container : configJson) {
            try {

                if (container.get(SystemConfiguration.Fields.FEATURE_TYPE).textValue().equalsIgnoreCase(ConstantUtil.SYNC_QUERY_BUILDER)) {
                    QueryMasterDto queryMasterDto = new GsonBuilder()
                            .registerTypeAdapter(Date.class, ImtechoUtil.jsonDateDeserializerStringFormat)
                            .create()
                            .fromJson(container.get(SystemConfiguration.Fields.CONFIG_JSON).textValue(), QueryMasterDto.class);

                    queryMasterDto.setCreatedOn(new Date());
                    queryMasterService.createOrUpdate(queryMasterDto,true);
                    handleProcessId(container);

                } else if (container.get(SystemConfiguration.Fields.FEATURE_TYPE).textValue().equalsIgnoreCase(ConstantUtil.SYNC_NOTIFICATION)) {
                    NotificationTypeMasterDto dto = new GsonBuilder()
                            .registerTypeAdapter(Date.class, ImtechoUtil.jsonDateDeserializerStringFormat)
                            .create()
                            .fromJson(container.get(SystemConfiguration.Fields.CONFIG_JSON).textValue(), NotificationTypeMasterDto.class);

                    dto.setId(null);
                    for (EscalationLevelMasterDto escalationLevel : dto.getEscalationLevels()) {
                        escalationLevel.setIsFromOtherServer(Boolean.TRUE);
                        escalationLevel.setId(null);
                    }

                    notificationMasterService.createOrUpdate(dto, true);
//                  After each successful Transaction will store the Last processed ID
                    if (!container.get("id").toString().equalsIgnoreCase("null") ||
                            !container.get("id").toString().equalsIgnoreCase(null)) {
                        updateLastProcessedId(Integer.parseInt(container.get("id").toString()));
                    }


                } else if (container.get(SystemConfiguration.Fields.FEATURE_TYPE).textValue().equalsIgnoreCase(ConstantUtil.SYNC_EVENT)) {
                    EventConfigurationDto dto = new GsonBuilder()
                            .registerTypeAdapter(Date.class, ImtechoUtil.jsonDateDeserializerStringFormat)
                            .create()
                            .fromJson(container.get(SystemConfiguration.Fields.CONFIG_JSON).textValue(), EventConfigurationDto.class);

                    dto.setCreatedBy(-1);
                    dto.setCreatedOn(new Date());
                    dto.setId(null);
                    eventConfigurationService.saveOrUpdate(dto, true);
//                  After each successful Transaction will store the Last processed ID
                    handleProcessId(container);

                } else if (container.get(SystemConfiguration.Fields.FEATURE_TYPE).textValue().equalsIgnoreCase(ConstantUtil.SYNC_REPORT_MASTER)) {

                    JsonNode jsonNode = ImtechoUtil.convertStringToJson(container.get(SystemConfiguration.Fields.CONFIG_JSON).textValue());
                    ObjectMapper mapper = new ObjectMapper();
                    ReportConfigDto reportConfigDto = mapper.readValue(new TreeTraversingParser(jsonNode), ReportConfigDto.class);
                    reportConfigDto.setCreatedBy(-1);
                    reportConfigDto.setCreatedOn(new Date());
                    reportService.saveDynamicReport(reportConfigDto,true);
//                  After each successful Transaction will store the Last processed ID
                    handleProcessId(container);
                }



            } catch (JsonSyntaxException e) {
                throw new ImtechoUserException("Failed : while saving config to system using Json: ", e);
            }

        }

    }

    /**
     * Handle process id.
     * @param container Json node container.
     */
    private void handleProcessId(JsonNode container){
        if (!container.get("id").toString().equalsIgnoreCase("null") ||
                !container.get("id").toString().equalsIgnoreCase(null)) {
            updateLastProcessedId(Integer.parseInt(container.get("id").toString()));
        }
    }

    /**
     * Creates mapper record of given server
     * @param syncWithServerDto An instance of SyncWithServerDto
     */
    @Transactional
    public void insertRecordInMapper(SyncWithServerDto syncWithServerDto) {
//      Delete Non Active Server Entry
        serverManagementDao.deleteNoNSyncServerEntry(syncWithServerDto.getServerlist(), syncWithServerDto.getFeatureUUID());
//      Insert newly active server entry
        for (Integer serverId : syncWithServerDto.getServerlist()) {
            serverManagementDao.createMapperRecord(syncWithServerDto, serverId);
        }

    }

    /**
     * Deletes non active server record
     * @param syncWithServerDto An instance of SyncWithServerDto
     */
    @Transactional
    public void deleteNonSyncNonActiveServerRecord(SyncWithServerDto syncWithServerDto) {
//      Delete Non sync and Non Active server's prev entry
        serverManagementDao.deleteNoNSyncNonActiveServerEntry(syncWithServerDto.getServerlist(),syncWithServerDto.getFeatureUUID());
    }

    /**
     * Delete an active server record of given server
     * @param syncWithServerDto An instance of SyncWithServerDto
     */
    @Transactional
    public void deleteActiveServerRecord(SyncWithServerDto syncWithServerDto) {
//        Delete all the entries which are in access table and feature mapper
        serverManagementDao.deleteActiveServerRecord(syncWithServerDto.getServerlist(),syncWithServerDto.getFeatureUUID());
    }


    /**
     * Returns a list of server configuration id based on given criteria
     * @param serverId An id of server
     * @param featureUuid An uuid of feature
     * @param syncWithServerDto An instance of SyncWithServerDto
     * @return A list of server configuration id
     */
    @Transactional
    public List<Integer> retrieveConfigId (Integer serverId,UUID featureUuid,SyncWithServerDto syncWithServerDto) {
//      Retreive Remaining ConfigID for respective server and Feature
        List<Integer> configIds = new ArrayList<>();
        QueryDto queryDto = new QueryDto();
        queryDto.setCode("get_system_sync_configuration_id_from_feature_uuid");
        LinkedHashMap<String, Object> parameters = new LinkedHashMap<>();
        parameters.put("server_id", serverId);
        parameters.put("featureUUID", featureUuid.toString());
        queryDto.setParameters(parameters);
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        List<QueryDto> resultDtos = queryMasterService.executeQuery(queryDtos, true);
        for(LinkedHashMap<String, Object> entry : resultDtos.get(0).getResult()) {
            configIds.add((Integer)entry.get("id"));
        }
        return configIds;

    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public void saveSyncWithServer(SyncWithServerDto syncWithServerDto) {
//      Delete previously non active and non sync entries from access table
        deleteNonSyncNonActiveServerRecord(syncWithServerDto);

        for (Integer serverId : syncWithServerDto.getServerlist()) {
            if (serverId != null && serverId != -1 ) {
//              Retrieve Remaining ConfigID for inserting into access table
                List<Integer> configIds = retrieveConfigId(serverId, syncWithServerDto.getFeatureUUID(), syncWithServerDto);
                syncWithServerDto.setConfigIds(configIds);
                if (!syncWithServerDto.getConfigIds().isEmpty()) {
                    for (Integer configId : syncWithServerDto.getConfigIds()) {
                        serverManagementDao.insertSystemSyncWith(serverId, configId);
                    }
                }

            }

        }
//      delete the previous non active server entry and add newly added active server's entry
        insertRecordInMapper(syncWithServerDto);
    }


    public List<SyncWithServerDto> configureDtosForSelectAllAction(List<SyncWithServerDto> syncWithServerDtos,String actionType) {
        List<SyncWithServerDto> allDataDtos = new ArrayList<>();

        for (SyncWithServerDto syncWithServerDto : syncWithServerDtos) {
            if (syncWithServerDto.isSelectAll()) {

                QueryDto queryDto = new QueryDto();
                queryDto.setCode("get_feature_name_with_uuid");
                LinkedHashMap<String, Object> parameters = new LinkedHashMap<>();
                parameters.put(SystemConfiguration.Fields.FEATURE_TYPE, syncWithServerDto.getType());
                parameters.put("searchText", null);
                parameters.put("limit", null);
                parameters.put("offset", null);

                queryDto.setParameters(parameters);
                List<QueryDto> queryDtos = new LinkedList<>();
                queryDtos.add(queryDto);
                List<QueryDto> resultDtos = queryMasterService.execute(queryDtos, true);

                if (!resultDtos.isEmpty()) {
                    for (int i = 0; i < resultDtos.get(0).getResult().size(); i++) {
                        SyncWithServerDto listDto = new SyncWithServerDto();
                        List<Integer> serverIds = handleServerIds(syncWithServerDto,actionType,resultDtos,i);
                        listDto.setFeatureUUID(UUID.fromString(resultDtos.get(0).getResult().get(i).get("feature_uuid").toString()));
                        listDto.setServerlist(serverIds);
                        listDto.setType(resultDtos.get(0).getResult().get(i).get("feature_type").toString());
                        allDataDtos.add(listDto);

                    }

                }


            }
        }

        if (allDataDtos.isEmpty()) {
            return syncWithServerDtos;
        }
        else{
            return allDataDtos;
        }

    }

    /**
     * Retrieves server ids.
     * @param syncWithServerDto An instance of SyncWithServerDto.
     * @param actionType Action type.
     * @param resultDtos List of result details.
     * @param i Index of for loop.
     * @return Retunrs list of server ids.
     */
    private List<Integer> handleServerIds(SyncWithServerDto syncWithServerDto,String actionType,List<QueryDto> resultDtos,int i){
        List<Integer> serverIds = new ArrayList<>();
        serverIds.addAll(0,syncWithServerDto.getServerlist());

        if ("Sync".equals(actionType) && resultDtos.get(0).getResult().get(i).get("server_ids") != null) {
            String[] split = resultDtos.get(0).getResult().get(i).get("server_ids").toString().split(",");
            for (String str : split) {
                if (!serverIds.contains(Integer.parseInt(str))) {
                    serverIds.add(Integer.parseInt(str));
                }
            }
        }
        return serverIds;
    }


    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public void bulkSaveSyncWithServer(List<SyncWithServerDto> syncWithServerDtos) {

        syncWithServerDtos = configureDtosForSelectAllAction(syncWithServerDtos,"Sync");

        for (SyncWithServerDto syncWithServerDto : syncWithServerDtos) {


//          Delete previously non active and non sync entries from access table
            deleteNonSyncNonActiveServerRecord(syncWithServerDto);

            for (Integer serverId : syncWithServerDto.getServerlist()) {
                if (serverId != null) {
//                  Retreive Remaining ConfigID for Inserting into access table
                    List<Integer> configIds = retrieveConfigId(serverId, syncWithServerDto.getFeatureUUID(), syncWithServerDto);
                    syncWithServerDto.setConfigIds(configIds);
                    if (!syncWithServerDto.getConfigIds().isEmpty()) {
                        for (Integer configId : syncWithServerDto.getConfigIds()) {
                            serverManagementDao.insertSystemSyncWith(serverId, configId);
                        }
                    }

                }

            }
//          delete the previous non active server entry and add newly added active server's entry
            insertRecordInMapper(syncWithServerDto);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public void bulkASyncWithServer(List<SyncWithServerDto> syncWithServerDtos) {
        syncWithServerDtos = configureDtosForSelectAllAction(syncWithServerDtos,"Async");
        for (SyncWithServerDto syncWithServerDto : syncWithServerDtos) {
            deleteActiveServerRecord(syncWithServerDto);
        }

    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Transactional
    public void createOrUpdate(SyncServerDto syncServerDto) {
        serverManagementDao.addOrUpdateServer(syncServerDto);
    }

}
