package com.argusoft.imtecho.fcm.service;

import com.argusoft.imtecho.event.dto.EventConfigTypeDto;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationMaster;
import com.argusoft.imtecho.timer.dto.TimerEventDto;

import java.util.LinkedHashMap;
import java.util.List;

/**
 * @author nihar
 * @since 02/08/22 2:24 PM
 */
public interface TechoPushNotificationService {

    //void sendNotification();

    void sendPushNotification(TimerEventDto timerEventDto);

    void createOrUpdateAll(List<TechoPushNotificationMaster> techoPushNotificationMasters);

    void handle(EventConfigTypeDto eventConfigTypeDto, List<LinkedHashMap<String, Object>> queryDataLists);
}
