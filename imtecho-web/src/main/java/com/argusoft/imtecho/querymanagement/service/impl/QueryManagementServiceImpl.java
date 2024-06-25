/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.service.impl;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.querymanagement.dao.QueryHistoryDao;
import com.argusoft.imtecho.querymanagement.model.QueryHistory;
import com.argusoft.imtecho.querymanagement.constants.QueryManagementConstants;
import com.argusoft.imtecho.querymanagement.dao.QueryManagementDao;
import com.argusoft.imtecho.querymanagement.service.QueryManagementService;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *     Implements methods of QueryManagementService
 * </p>
 * @author bhumika
 * @since 03/09/2020 10:30
 */
@Service
@Transactional
public class QueryManagementServiceImpl implements QueryManagementService {
    
    @Autowired
    QueryManagementDao queryManagementDao;

    @Autowired
    ImtechoSecurityUser securityUser;
    
    @Autowired
    QueryHistoryDao queryHistoryDao;
    /**
     * {@inheritDoc}
     */
    @Override
    public int execute(String query) {
        
        QueryHistory qH = new QueryHistory();
        qH.setQuery(query);
        qH.setReturnsResultSet(Boolean.FALSE);
        int res;
        if(Objects.nonNull(securityUser)) {
            qH.setUserId(securityUser.getId());
            if (QueryManagementConstants.QUERY_MANAGEMENT_RIGHT_IDS.contains(securityUser.getUserName())) {
                res = queryManagementDao.execute(query);
                qH.setExecutedState(QueryHistory.State.SUCCESS.toString());
                queryHistoryDao.save(qH);
            } else {
                qH.setExecutedState(QueryHistory.State.FAIL.toString());
                queryHistoryDao.save(qH);
                throw new ImtechoUserException(securityUser.getUserName() + " does not have rights to perform this action", 1);
            }
        }else{
            throw new ImtechoUserException("No loggedIn user found", 1);
        }
        return res;
    }
    /**
     * {@inheritDoc}
     */
    @Override
    public List<LinkedHashMap<String, Object>> retrieveQuery(String query) {

        QueryHistory qH = new QueryHistory();
        qH.setQuery(query);
        qH.setReturnsResultSet(Boolean.FALSE);
        qH.setUserId(securityUser.getId());

        List<LinkedHashMap<String, Object>> result = queryManagementDao.retrieveQuery(query);

        qH.setExecutedState(QueryHistory.State.SUCCESS.toString());
        queryHistoryDao.save(qH);
        
        return result;
    }

}
