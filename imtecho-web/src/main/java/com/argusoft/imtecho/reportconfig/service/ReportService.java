/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.reportconfig.service;

import com.argusoft.imtecho.reportconfig.dto.ReportConfigDto;
import com.argusoft.imtecho.reportconfig.dto.ReprotExcelDto;
import com.argusoft.imtecho.reportconfig.model.ReportMaster;
import com.argusoft.imtecho.reportconfig.model.ReportOfflineDetails;
import com.fasterxml.jackson.core.JsonProcessingException;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 *
 * <p>
 *     Define services for report.
 * </p>
 * @author vaishali
 * @since 26/08/20 11:00 AM
 *
 */
public interface ReportService {
    /**
     * Retrieves dynamic report details by report id and report code.
     * @param code Report code.
     * @param uuid Report UUID.
     * @param fetchQuery Fetch query option.
     * @return Returns dynamic report details.
     */
    ReportMaster retrieveReportMasterByUUIDOrCode(UUID uuid, String code, Boolean fetchQuery);

    /**
     * Retrieves dynamic report details by report id and report code.
     * @param uuid Report uuid.
     * @param code Report code.
     * @param fetchQueryOptions Fetch query option.
     * @return Returns dynamic report details.
     */
    ReportConfigDto getDynamicReportDetailByUUIDOrCode(UUID uuid, String code, Boolean fetchQueryOptions);

    /**
     * Retrieves dynamic report.
     * @param reportConfigDto Report config details.
     * @return Returns report config details.
     */
    ReportConfigDto getDynamicReport(ReportConfigDto reportConfigDto);

    /**
     * Save dynamic configuration of report.
     * @param reportConfigDto Report configuration dto.
     * @param isMetodCallBySyncFunction Is method called by sync function.
     */
    void saveDynamicReport(ReportConfigDto reportConfigDto, boolean isMetodCallBySyncFunction);

    /**
     * Retrieves list of active records by report name, parent group id, sub group id.
     * @param reportName Report name.
     * @param offset The number of data to skip before starting to fetch details.
     * @param limit The number of data need to fetch.
     * @param groupAssociated Parent group id.
     * @param subGroupAssociated Sub group id.
     * @param groupdId Group id.
     * @param subGroupId Sub group id.
     * @param userId User id.
     * @param menuType Type of menu.
     * @param sortBy Sort by field name.
     * @param sortOrder Sort on field name.
     * @return Returns list of reports details.
     */
    List<ReportMaster> retrieveAllActiveReportMasters(String reportName, Integer offset, Integer limit, Boolean groupAssociated, Boolean subGroupAssociated, Integer groupdId, Integer subGroupId, String userId, String menuType, String sortBy, String sortOrder);

    /**
     * Delete report by report uuid.
     * @param uuid Report uuid.
     */
    void deleteReportByUUID(UUID uuid);

    /**
     * Retrieves data by query id.
     * @param id Query id.
     * @param parameterMap Map of parameters.
     * @return Returns map of result.
     */
    List<LinkedHashMap<String, Object>> retrieveDataByQueryId(Integer id, Map<String, String> parameterMap);

    /**
     * Retrieves combo data by query id.
     * @param id Query id.
     * @param parameterMap Map of parameters.
     * @return Returns map of result.
     */
    List<Map<String, Object>> retrieveComboDataByQueryId(Integer id, Map<String, String> parameterMap);

    /**
     * Download excel file.
     * @param id Report id.
     * @param uuid Report uuid.
     * @param reportExcelDto Report excel details.
     * @return Returns excel file of report.
     * @throws IOException If an I/O error occurs when reading or writing.
     */
    ByteArrayOutputStream downLoadExcelForReport(Integer id, UUID uuid, ReprotExcelDto reportExcelDto) throws IOException;
    
    public ByteArrayOutputStream downLoadPdfForReport(Integer id, UUID uuid, ReprotExcelDto reportExcelDto) throws IOException, InterruptedException;

    /**
     * Stores report offline request to database
     *
     * @param id A report id
     * @param reportExcelDto An instance of ReprotExcelDto
     */
    void offlineReportRequest(Integer id,
                              ReprotExcelDto reportExcelDto);

    /**
     * Returns a list of ReportOfflineDetails of given user id
     * @param userId A user id
     * @return A list of ReportOfflineDetails
     */
    List<ReportOfflineDetails> retrieveOfflineReportsByUserId(Integer userId);

    /**
     * Returns a ReportOfflineDetails of given id
     *
     * @param id A offline report id
     * @return An instance of ReportOfflineDetails
     */
    ReportOfflineDetails retrieveOfflineReportById(Integer id);

    /**
     * Retrieves data by query uuid.
     * @param uuid Query uuid.
     * @param parameterMap Map of parameters.
     * @return Returns map of result.
     */
    List<LinkedHashMap<String, Object>> retrieveDataByQueryUUID(UUID uuid, Map<String, String> parameterMap);

    /**
     * Retrieves combo data by query uuid.
     * @param uuid Query uuid.
     * @param parameterMap Map of parameters.
     * @return Returns map of result.
     */
    List<Map<String, Object>> retrieveComboDataByQueryUUID(UUID uuid, Map<String, String> parameterMap);
//    /**
//     * Retrieve summary by uuid string.
//     *
//     * @param uuid         the uuid
//     * @param parameterMap the parameter map
//     * @return the string
//     */
//    String retrieveSummaryByUUID(UUID uuid, Map<String, String> parameterMap) throws JsonProcessingException;



}