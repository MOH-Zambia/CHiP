package com.argusoft.imtecho.fcm.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fcm.dto.TechoPushNotificationDisplayDto;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationConfig;

import java.math.BigInteger;
import java.util.List;

/**
 * @author nihar
 * @since 14/10/22 3:53 PM
 */
public interface TechoPushNotificationConfigDao extends
        GenericDao<TechoPushNotificationConfig, Integer> {

    List<TechoPushNotificationDisplayDto> getNotificationConfig(BigInteger limit, Integer offset);
}
