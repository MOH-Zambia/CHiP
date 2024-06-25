/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.event.service.impl;

import com.argusoft.imtecho.common.service.SystemConfigSyncService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.event.dao.EventConfigurationDao;
import com.argusoft.imtecho.event.dao.EventConfigurationTypeDao;
import com.argusoft.imtecho.event.dao.MobileEventConfigDao;
import com.argusoft.imtecho.event.dto.EventConditionDetailDto;
import com.argusoft.imtecho.event.dto.EventConfigTypeDto;
import com.argusoft.imtecho.event.dto.EventConfigurationDetailDto;
import com.argusoft.imtecho.event.dto.EventConfigurationDto;
import com.argusoft.imtecho.event.dto.MobileEventConfigDto;
import com.argusoft.imtecho.event.mapper.EventConfigurationMapper;
import com.argusoft.imtecho.event.model.EventConfiguration;
import com.argusoft.imtecho.event.model.EventConfigurationType;
import com.argusoft.imtecho.event.service.EventConfigurationService;
import com.argusoft.imtecho.event.util.EventFunctionUtil;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.notification.dao.NotificationTypeMasterDao;
import com.argusoft.imtecho.timer.dao.TimerEventDao;
import com.argusoft.imtecho.timer.dto.TimerEventDto;
import com.argusoft.imtecho.timer.model.TimerEvent;
import com.argusoft.imtecho.timer.service.TimerEventService;
import java.io.IOException;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.fasterxml.jackson.core.JsonProcessingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for event configuration.
 * </p>
 * @author vaishali
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class EventConfigurationServiceImpl implements EventConfigurationService {

    @Autowired
    private EventConfigurationDao eventConfigurationDao;
    @Autowired
    private EventConfigurationTypeDao eventConfigurationTypeDao;
    @Autowired
    private MobileEventConfigDao mobileNotificationConfigDao;
    @Autowired
    private TimerEventService timerEventService;
    @Autowired
    private TimerEventDao timerEventDao;
    @Autowired
    private SystemConfigSyncService systemConfigSyncService;
    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public void saveOrUpdate(EventConfigurationDto eventConfigurationDto,boolean isMetodCallBySyncFunction) throws IOException {

        EventConfiguration eventConfiguration = retrieveEventConfiguration(isMetodCallBySyncFunction,eventConfigurationDto);

        eventConfiguration = EventConfigurationMapper.convertDtoToMaster(eventConfigurationDto, eventConfiguration,isMetodCallBySyncFunction);
        this.convertEventNotificationEventConfigDetail(eventConfigurationDto, eventConfiguration,isMetodCallBySyncFunction);

        if (eventConfiguration.getUuid() == null) {
            eventConfiguration.setUuid(UUID.randomUUID());
        }

        if (isMetodCallBySyncFunction) {
            eventConfiguration.setCreatedBy(-1);
        }

        eventConfigurationDao.createOrUpdate(eventConfiguration);

        if (eventConfigurationDto.getEventType().equals("TIMMER_BASED")) {
            if (eventConfigurationDto.getId() != null) {
                if (eventConfigurationDto.getTrigerWhen().equals(EventConfiguration.TriggerWhen.IMMEDIATELY)) {
                    Date nextDate = EventFunctionUtil.getNextDate(eventConfigurationDto.getTrigerWhen(), eventConfigurationDto);
                    timerEventService.scheduleTimerEvent(new TimerEventDto(null,
                            TimerEvent.TYPE.TIMER_EVENT, nextDate, eventConfiguration.getId(), null, null, eventConfiguration.getUuid()));
                }
            } else {
                Date nextDate = EventFunctionUtil.getNextDate(eventConfigurationDto.getTrigerWhen(), eventConfigurationDto);
                timerEventService.scheduleTimerEvent(new TimerEventDto(null,
                        TimerEvent.TYPE.TIMER_EVENT, nextDate, eventConfiguration.getId(), null, null, eventConfiguration.getUuid()));
            }
        }
        setNotificationConfigDetails(eventConfigurationDto,eventConfiguration);

        if (!isMetodCallBySyncFunction) {
            EventConfigurationDto dto = this.retrieveByUUID(eventConfiguration.getUuid());
            systemConfigSyncService.createOrUpdate(dto, ConstantUtil.SYNC_EVENT);

        }
    }

    private EventConfiguration retrieveEventConfiguration(boolean isMetodCallBySyncFunction,EventConfigurationDto eventConfigurationDto){
        EventConfiguration eventConfiguration = null;

        if (!isMetodCallBySyncFunction) {
            if (eventConfigurationDto.getId() != null) {
                eventConfiguration = eventConfigurationDao.retrieveById(eventConfigurationDto.getId());
            }
        } else {
            if (eventConfigurationDto.getUuid() != null) {
                EventConfiguration temp = eventConfigurationDao.retrieveByUUID(eventConfigurationDto.getUuid());
                if (temp != null) {
                    eventConfiguration = temp;
                }
            }
        }
        return eventConfiguration;
    }

    private void setNotificationConfigDetails(EventConfigurationDto eventConfigurationDto,EventConfiguration eventConfiguration) throws JsonProcessingException {
        if (eventConfigurationDto.getNotificationConfigDetails() != null) {
            for (EventConfigurationDetailDto notificationConfigDetail : eventConfigurationDto.getNotificationConfigDetails()) {
                if (notificationConfigDetail.getConditions() != null) {
                    saveNotificationConfigDetails(notificationConfigDetail,eventConfiguration);
                }
            }

        }
    }

    private void saveNotificationConfigDetails(EventConfigurationDetailDto notificationConfigDetail,EventConfiguration eventConfiguration) throws JsonProcessingException{
        for (EventConditionDetailDto notificationConditionDetailDto : notificationConfigDetail.getConditions()) {
            if (notificationConditionDetailDto.getNotificaitonConfigsType() != null) {
                for (EventConfigTypeDto notificationConfigTypeDto : notificationConditionDetailDto.getNotificaitonConfigsType()) {
                    notificationConfigTypeDto.setConfigId(eventConfiguration.getId());
                    notificationConfigTypeDto.setEventConfigUUID(eventConfiguration.getUuid());

                    eventConfigurationTypeDao.createOrUpdate(EventConfigurationMapper.convertToConfigurationTypeMaster(notificationConfigTypeDto));
                    if (notificationConfigTypeDto.getMobileNotificationConfigs() != null) {
                        for (MobileEventConfigDto mobileNotificationConfigDto : notificationConfigTypeDto.getMobileNotificationConfigs()) {
                            mobileNotificationConfigDto.setNotificationTypeConfigId(notificationConfigTypeDto.getId());
                            mobileNotificationConfigDao.createOrUpdate(EventConfigurationMapper.convertToMobileNotificationConfigMaster(mobileNotificationConfigDto));
                        }
                    }

                }
            }
        }
    }

    /**
     * Convert event notification dto into entity.
     * @param configurationDto Event configuration details.
     * @param eventConfiguration Entity of event configuration.
     * @param isMetodCallBySyncFunction Is method called by sync function.
     * @throws IOException If an I/O error occurs when reading or writing.
     */
    private void convertEventNotificationEventConfigDetail(EventConfigurationDto configurationDto, EventConfiguration eventConfiguration,boolean isMetodCallBySyncFunction) throws IOException {
        if (configurationDto.getNotificationConfigDetails() != null) {
            for (EventConfigurationDetailDto notificationConfigDetail : configurationDto.getNotificationConfigDetails()) {
                notificationConfigDetail.setQueryParam(EventFunctionUtil.findParamsFromTemplate(notificationConfigDetail.getQuery()));
                if (notificationConfigDetail.getConditions() != null) {
                    setEventConditionDetails(notificationConfigDetail,isMetodCallBySyncFunction,configurationDto);
                }
            }
            eventConfiguration.setNotificationConfigurationDetailJson(ImtechoUtil.convertNotificationConfigListToJson(configurationDto.getNotificationConfigDetails()));
        }
    }

    /**
     * Set event condition details.
     * @param notificationConfigDetail Notification config details.
     * @param isMetodCallBySyncFunction Is method call by sync function.
     * @param configurationDto Configuration details.
     */
    private void setEventConditionDetails(EventConfigurationDetailDto notificationConfigDetail,boolean isMetodCallBySyncFunction,EventConfigurationDto configurationDto){
        for (EventConditionDetailDto condition : notificationConfigDetail.getConditions()) {
            condition.setConditionParam(EventFunctionUtil.findParamsFromTemplate(condition.getCondition()));
            if (condition.getNotificaitonConfigsType() != null) {
                for (EventConfigTypeDto notificationConfigTypeDto : condition.getNotificaitonConfigsType()) {
                    setMobileNotificationTypeUUIDForMobile(isMetodCallBySyncFunction,notificationConfigTypeDto);
                    notificationConfigTypeDto.setTemplateParameter(EventFunctionUtil.findParamsFromTemplate(notificationConfigTypeDto.getTemplate()));
                    notificationConfigTypeDto.setEmailSubjectParameter(EventFunctionUtil.findParamsFromTemplate(notificationConfigTypeDto.getEmailSubject()));
                    notificationConfigTypeDto.setConfigId(configurationDto.getId());
                    if (notificationConfigTypeDto.getId() == null) {
                        notificationConfigTypeDto.setId(UUID.randomUUID().toString());
                    }
                    setMobileNotificationId(notificationConfigTypeDto);
                    setNotificationTypeConfigIdForMobile(notificationConfigTypeDto);
                }
            }
        }
    }

    /**
     * Set mobile notification type UUID for mobile.
     * @param isMetodCallBySyncFunction Is method call by sync function.
     * @param notificationConfigTypeDto Notification config type.
     */
    private void setMobileNotificationTypeUUIDForMobile(boolean isMetodCallBySyncFunction,EventConfigTypeDto notificationConfigTypeDto){
        if (!isMetodCallBySyncFunction) {
            if (notificationConfigTypeDto.getMobileNotificationType() != null) {
                notificationConfigTypeDto.setMobileNotificationTypeUUID(notificationTypeMasterDao.retrieveById(notificationConfigTypeDto.getMobileNotificationType()).getUuid());
            }
        } else {
            if (notificationConfigTypeDto.getMobileNotificationTypeUUID() != null) {
                notificationConfigTypeDto.setMobileNotificationType(notificationTypeMasterDao.retrieveByUUID(notificationConfigTypeDto.getMobileNotificationTypeUUID()).getId());
            }
        }
    }

    /**
     * Set mobile notification id.
     * @param notificationConfigTypeDto Notification config type.
     */
    private void setMobileNotificationId(EventConfigTypeDto notificationConfigTypeDto){
        if (notificationConfigTypeDto.getMobileNotificationConfigs() != null) {
            for (MobileEventConfigDto mobileNotification : notificationConfigTypeDto.getMobileNotificationConfigs()) {
                if (mobileNotification.getId() == null) {
                    mobileNotification.setId(UUID.randomUUID().toString());
                }
            }
        }
    }

    /**
     * Set notification type config id for mobile.
     * @param notificationConfigTypeDto Notification config type details.
     */
    private void setNotificationTypeConfigIdForMobile(EventConfigTypeDto notificationConfigTypeDto){
        if (notificationConfigTypeDto.getMobileNotificationConfigs() != null) {
            for (MobileEventConfigDto mobileNotification : notificationConfigTypeDto.getMobileNotificationConfigs()) {
                mobileNotification.setNotificationTypeConfigId(notificationConfigTypeDto.getId());
                if (mobileNotification.getId() == null) {
                    mobileNotification.setId(UUID.randomUUID().toString());
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void runEvent(UUID notificationConfigUUID) {
        EventConfigurationDto event = this.retrieveByUUID(notificationConfigUUID);
        if (event == null) {
            throw new ImtechoSystemException("Event does not exist", 503);
        } else {
            if (event.getEventType().equals("TIMMER_BASED")) {
                List<TimerEvent> list = timerEventDao.retrieveTimerEventsByConfig(notificationConfigUUID);
                if (!list.isEmpty()) {
                    for (TimerEvent timerEvent : list) {
                        timerEvent.setSystemTriggerOn(Calendar.getInstance().getTime());
                        timerEventDao.createUpdate(timerEvent);
                    }
                } else {
                    timerEventService.scheduleTimerEvent(new TimerEventDto(null, TimerEvent.TYPE.TIMER_EVENT, Calendar.getInstance().getTime(), event.getId(), null, null, event.getUuid()));
                }
            } else {
                throw new ImtechoSystemException("Only TIMMER_BASED Event can run manually", 503);

            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<EventConfigurationDto> retrieveAll(Boolean isActive) {
        return eventConfigurationDao.retrieveAll(isActive);
    }

    @Override
    public EventConfigurationDto retrieveById(Integer id) {
        try {
            return EventConfigurationMapper.convertMasterToDto(eventConfigurationDao.retrieveById(id));
        } catch (IOException ex) {
            Logger.getLogger(EventConfigurationServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public EventConfigurationDto retrieveByUUID(UUID uuid) {
        try {
            return EventConfigurationMapper.convertMasterToDto(eventConfigurationDao.retrieveByUUID(uuid));
        } catch (IOException ex) {
            Logger.getLogger(EventConfigurationServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public EventConfigTypeDto retrieveNotificationConfigTypeDtoById(String id) {
        EventConfigurationType notificationConfigurationType = eventConfigurationTypeDao.retrieveById(id);
        return EventConfigurationMapper.convertToConfigurationTypeDto(notificationConfigurationType);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<EventConfigurationDto> retrieveEventConfigsByEventTypeAndEventTypeDetailCode(String eventType, String eventTypeDetailCode) throws IOException {
        return EventConfigurationMapper.convertMasterListToDtoList(
                eventConfigurationDao.retrieveEventConfigsByEventTypeAndEventTypeDetailCode(eventType, eventTypeDetailCode)
        );
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void toggleState(EventConfigurationDto notificationConfigurationDto) {
        EventConfiguration eventConfiguration = eventConfigurationDao.retrieveById(notificationConfigurationDto.getId());
        eventConfiguration.setState(eventConfiguration.getState() == EventConfiguration.State.INACTIVE ? EventConfiguration.State.ACTIVE : EventConfiguration.State.INACTIVE);
        eventConfigurationDao.update(eventConfiguration);

        List<TimerEvent> list = timerEventDao.retrieveTimerEventsByConfig(notificationConfigurationDto.getUuid());
        if(eventConfiguration.getState() == EventConfiguration.State.ACTIVE) {
            if (notificationConfigurationDto.getEventType().equals("TIMMER_BASED")) {
                if (notificationConfigurationDto.getId() != null && list.isEmpty()) {
                    Date nextDate = EventFunctionUtil.getNextDate(notificationConfigurationDto.getTrigerWhen(), notificationConfigurationDto);
                    timerEventService.scheduleTimerEvent(new TimerEventDto(null,
                            TimerEvent.TYPE.TIMER_EVENT, nextDate, eventConfiguration.getId(), null, null, eventConfiguration.getUuid()));
                }
            }
        } else {
            if(!list.isEmpty()) {
                timerEventDao.deleteAll(list);
            }
        }

        EventConfigurationDto dto = this.retrieveById(eventConfiguration.getId());
        systemConfigSyncService.createOrUpdate(dto, ConstantUtil.SYNC_EVENT);
    }
}
