package com.argusoft.imtecho.fcm.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;

/**
 * @author nihar
 * @since 02/08/22 3:46 PM
 */
public interface TechoPushNotificationTypeDao extends GenericDao<TechoPushNotificationType, Integer> {

    TechoPushNotificationType getTechoPushNotificationTypeByType(String type);

    boolean checkFileExists(Integer id);
}
