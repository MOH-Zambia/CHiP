package com.argusoft.imtecho.fcm.service;

import com.argusoft.imtecho.fcm.dto.TechoPushNotificationConfigDto;
import com.argusoft.imtecho.fcm.dto.TechoPushNotificationDisplayDto;

import java.math.BigInteger;
import java.util.List;

/**
 * @author nihar
 * @since 13/10/22 2:19 PM
 */
public interface TechoPushNotificationConfigService {

    void createOrUpdateNotificationConfig(TechoPushNotificationConfigDto
                                                  techoPushNotificationConfigDto);


    List<TechoPushNotificationDisplayDto> getPushNotificationConfigs(BigInteger limit, Integer offset);

    TechoPushNotificationConfigDto getNotificationConfigById(Integer id);

    void toggleNotificationConfigState(Integer id);
}
