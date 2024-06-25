/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.service.impl;

import com.argusoft.imtecho.querymanagement.dao.QueryHistoryDao;
import com.argusoft.imtecho.querymanagement.dto.QueryHistoryDto;
import com.argusoft.imtecho.querymanagement.mapper.QueryHistoryMapper;
import com.argusoft.imtecho.querymanagement.model.QueryHistory;
import com.argusoft.imtecho.querymanagement.service.QueryHistoryService;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 *     Implements methods of QueryHistoryService
 * </p>
 * @author vaishali
 * @since 03/09/2020 10:30
 */
@Transactional
@Service
public class QueryHistoryServiceImpl implements QueryHistoryService {

    @Autowired
    private QueryHistoryDao queryHistoryDao;


    /**
     * {@inheritDoc}
     */
    @Override
    public List<QueryHistoryDto> retrieveByCriteria(Integer userId, Integer offset, Integer limit, String orderBy, String order, String searchString) {
        List<QueryHistory> list = queryHistoryDao.retrieveByCriteria(userId, offset, limit, orderBy, order, searchString);

        return list.stream().map(qm ->
            QueryHistoryMapper.convertMasterToDto(qm, null,null)
        ).collect(Collectors.toList());
    }

}
