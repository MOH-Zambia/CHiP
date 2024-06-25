/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.controller;

import com.argusoft.imtecho.querymanagement.service.QueryManagementService;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * <p>
 *     Defines rest end points for query management
 * </p>
 * @author bhumika
 * @since 03/09/2020 10:30
 */
@RestController
@RequestMapping("/api/querymanagement")
public class QueryManagementController {
 
    @Autowired
    private QueryManagementService queryManagementService;

    /**
     * Executes a given query string
     * @param query A query string
     * @return A list of result
     */
    @PostMapping(value = "/execute")
    public List<LinkedHashMap<String, Integer>> executeQuery(@RequestBody String query) {
        List<LinkedHashMap<String, Integer>> list = new ArrayList<>(1);
        int res = queryManagementService.execute(query);
        LinkedHashMap<String, Integer> map = new LinkedHashMap<>();
        map.put("No of row affected ", res);
        list.add(map);
        return list;
    }

    /**
     * Returns a list of result based on given query string
     * @param query A query string
     * @return A list of result
     */
    @PostMapping(value = "/retrieve")
    public List<LinkedHashMap<String, Object>> retrieveQuery(@RequestBody String query) {
        return queryManagementService.retrieveQuery(query);
    }

}
