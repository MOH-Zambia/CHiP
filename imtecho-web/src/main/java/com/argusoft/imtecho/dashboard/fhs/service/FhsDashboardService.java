/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.dashboard.fhs.service;

import com.argusoft.imtecho.dashboard.fhs.view.DisplayObject;
import com.argusoft.imtecho.fhs.dto.FhsVillagesDto;
import com.argusoft.imtecho.fhs.dto.StarPerformersOfTheDayDto;
import java.util.List;

/**
 * <p>Method Signature Family dashboard service</p>
 * @author kunjan
 * @since 27/08/20 1:00 PM
 *
 */
public interface FhsDashboardService {
    
    /**
     * Returns family and members detail for the given location id
     * @param locationId Location id
     * @return List of display objects
     */
    List<DisplayObject> familiesAndMembers(Integer locationId);

    /**
     * Returns family and members detail by location id
     * @param locationId Location id
     * @return List of DisplayObject
     */
    List<DisplayObject> familiesAndMembersByLocationId(Integer locationId);
    
    /**
     * Returns list of fhs villages
     * @param userId user id
     * @return List of FhsVillagesDto
     */
    List<FhsVillagesDto> getFhsVillagesByUserId(Integer userId) ;
    
    /**
     * Returns star performers of the day
     * @return list of StarPerformersOfTheDayDto
     */
    List<StarPerformersOfTheDayDto> starPerformersOfTheDay() ;

    /**
     * Modify last update time
     * @return last update time string
     */
    String getLastUpdateTime();
    
}
