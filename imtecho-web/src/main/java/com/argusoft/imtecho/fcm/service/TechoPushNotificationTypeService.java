package com.argusoft.imtecho.fcm.service;

import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;

/**
 * @author nihar
 * @since 12/10/22 6:01 PM
 */
public interface TechoPushNotificationTypeService {

    void createOrUpdate(TechoPushNotificationType techoPushNotificationType);

    List<TechoPushNotificationType> getNotificationTypeList();

    boolean checkIfTypeExists(String type);

    TechoPushNotificationType getNotificationTypeById(Integer id);

    File getPushNotificationFile(Integer id) throws FileNotFoundException;
}
