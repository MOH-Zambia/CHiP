/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.controller;

import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.querymanagement.dto.QueryHistoryDto;
import com.argusoft.imtecho.querymanagement.service.QueryHistoryService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * <p>
 *     Defines rest end points for query history
 * </p>
 * @author vaishali
 * @since 03/09/2020 10:30
 */
@RestController
@RequestMapping("/api/query")
public class QueryHistoryController {

    @Autowired
    private QueryHistoryService queryHistoryService;

    @Autowired
    private ImtechoSecurityUser imtechoSecurityUser;

    /**
     * Returns a list of query history based on given criteria
     * @param searchString A search string
     * @param orderBy A value for order by
     * @param order A value of order
     * @param limit A value for limit
     * @param offset A value for order
     * @return A list of QueryHistoryDto
     */
    @GetMapping(value = "/user/retrievebycriteria")
    public List<QueryHistoryDto> retrieveByCriteria(
            @RequestParam(name = "searchString", required = false) String searchString,
            @RequestParam(name = "orderby", required = false) String orderBy,
            @RequestParam(name = "order", required = false) String order,
            @RequestParam(name = "limit", required = false) Integer limit,
            @RequestParam(name = "offset", required = false) Integer offset) {

        return queryHistoryService.retrieveByCriteria(imtechoSecurityUser.getId(), offset, limit, orderBy, order, searchString);
    }

}
