/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.mapper;

import com.argusoft.imtecho.event.util.EventFunctionUtil;
import com.argusoft.imtecho.querymanagement.dto.QueryHistoryDto;
import com.argusoft.imtecho.querymanagement.model.QueryHistory;

/**
 * <p>
 *     An util class for query history to convert dto to modal or modal to dto
 * </p>
 * @author Hiren Morzariya
 * @since 03/09/2020 10:30
 */
public class QueryHistoryMapper {

    private QueryHistoryMapper(){
    }

    /**
     * Converts query history dto to modal
     * @param queryHistoryDto An instance of QueryHistoryDto
     * @return An instance of QueryHistory
     */
    public static QueryHistory convertDtoToMaster(QueryHistoryDto queryHistoryDto) {
        QueryHistory queryMaster = new QueryHistory();

        queryMaster.setQuery(queryHistoryDto.getQuery());
        String findParamsFromTemplate = EventFunctionUtil.findParamsFromTemplate(queryHistoryDto.getQuery());
        queryMaster.setParams(findParamsFromTemplate);
        queryMaster.setId(queryHistoryDto.getId());
        queryMaster.setReturnsResultSet(queryHistoryDto.getReturnsResultSet());
        queryMaster.setExecutedState(queryHistoryDto.getExecutedState());

        return queryMaster;

    }

    /**
     * Converts query history modal to dto
     * @param queryMaster An instance of QueryHistory
     * @param userName A name of the user
     * @param userFullName A full name of the user
     * @return An instance of QueryHistoryDto
     */
    public static QueryHistoryDto convertMasterToDto(QueryHistory queryMaster, String userName,String userFullName) {
        QueryHistoryDto queryMasterDto = new QueryHistoryDto();
        queryMasterDto.setId(queryMaster.getId());
        queryMasterDto.setQuery(queryMaster.getQuery());
        queryMasterDto.setExecutedState(queryMaster.getExecutedState());
        queryMasterDto.setReturnsResultSet(queryMaster.getReturnsResultSet());
        queryMasterDto.setParams(queryMaster.getParams());
        queryMasterDto.setUserName(userName);
        queryMasterDto.setUserFullName(userFullName);
        return queryMasterDto;

    }

}
