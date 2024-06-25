/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.querymanagement.service;

import com.argusoft.imtecho.querymanagement.dto.QueryHistoryDto;
import java.util.List;

/**
 * <p>
 *     Defines methods for query history service
 * </p>
 * @author Hiren Morzariya
 * @since 03/09/2020 10:30
 */
public interface QueryHistoryService {

    /**
     * Returns a list of query history based on given criteria
     * @param searchString A search string
     * @param orderBy A value for order by
     * @param order A value of order
     * @param limit A value for limit
     * @param offset A value for order
     * @param userId An user id
     * @return A list of QueryHistoryDto
     */
    List<QueryHistoryDto> retrieveByCriteria(Integer userId, Integer offset, Integer limit, String orderBy, String order, String searchString);

}
