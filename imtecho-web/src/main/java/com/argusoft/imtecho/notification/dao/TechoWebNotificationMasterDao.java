/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.notification.dao;


import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.notification.model.TechoWebNotificationMaster;

/**
 *
 * <p>
 * Define methods for techo web notification master.
 * </p>
 *
 * @author kunjan
 * @since 26/08/20 10:19 AM
 */
public interface TechoWebNotificationMasterDao extends GenericDao<TechoWebNotificationMaster, Integer> {

    /**
     * Retrieves web task count by user id.
     * @param userId User id.
     * @return Returns list of web tasks master details.
     */
    //List<WebTaskMasterDto> getWebTaskCount(Integer userId);
    void markNotificationAsCompleted(Integer notificationId, Integer userId);

   // boolean checkIfMemberNotificationExists(Integer notificationId, Integer memberId);

}
