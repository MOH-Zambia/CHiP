/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.service;

import java.util.LinkedHashMap;
import java.util.List;

/**
 * <p>
 *     Defines methods for query management service
 * </p>
 * @author bhumika
 * @since 03/09/2020 10:30
 */
public interface QueryManagementService {
    /**
     * Executes a given query string
     * @param query A query string
     * @return A created or updated row id
     */
    int execute(String query);

    /**
     * Returns a list of result based on given query string
     * @param query A query string
     * @return A list of result
     */
    List<LinkedHashMap<String, Object>> retrieveQuery(String query);

}
