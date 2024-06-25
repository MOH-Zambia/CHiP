/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.timer.service.impl;

import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.caughtexception.service.CaughtExceptionService;
import com.argusoft.imtecho.common.dto.AnnouncementPushNotificationDto;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.common.service.*;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.dto.EventConfigurationDto;
import com.argusoft.imtecho.event.service.EventConfigurationService;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.event.util.EventFunctionUtil;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationDao;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationTypeDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationMaster;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;
import com.argusoft.imtecho.fcm.service.TechoPushNotificationService;
import com.argusoft.imtecho.query.service.TableService;
import com.argusoft.imtecho.timer.dao.TimerEventDao;
import com.argusoft.imtecho.timer.dto.TimerEventDto;
import com.argusoft.imtecho.timer.mapper.TimerEventMapper;
import com.argusoft.imtecho.timer.model.TimerEvent;
import com.argusoft.imtecho.timer.service.TimerEventHadlerService;
import com.argusoft.imtecho.timer.service.TimerEventService;
import com.argusoft.imtecho.translation.dao.TranslatorDao;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;

import javax.transaction.Transactional;
import java.util.*;

import static com.argusoft.imtecho.timer.model.TimerEvent.TYPE.*;

/**
 * <p>
 * Define services for timer event handler.
 * </p>
 *
 * @author Harshit
 * @since 26/08/20 11:00 AM
 */
@Service
public class TimerEventHandlerServiceImpl implements TimerEventHadlerService {

    @Autowired
    private TimerEventDao timerEventsDao;

    @Autowired
    private SmsService smsService;

    @Autowired
    private EmailService emailService;

    @Autowired
    private TableService tableService;

    @Autowired
    private EventConfigurationService eventConfigurationService;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    @Lazy
    @Qualifier("timerEventServiceDefault")
    private TimerEventService timerEventService;

    @Autowired
    private UserService userService;

    @Autowired
    private EmailUtil emailUtil;

    @Autowired
    private SystemConfigurationService systemConfigurationService;

    @Autowired
    private TechoPushNotificationService techoPushNotificationService;

    @Autowired
    private AnnouncementService announcementService;

    @Autowired
    private TechoPushNotificationTypeDao techoPushNotificationTypeDao;

    @Autowired
    private TechoPushNotificationDao techoPushNotificationDao;

    @Autowired
    private TranslatorDao translatorDao;


    @Autowired
    CaughtExceptionService caughtExceptionService;

    /**
     * Retrieves all timer events.
     *
     * @param toTime Time details.
     * @return Returns list of timer events.
     */
    @Transactional
    public List<TimerEventDto> retrieveTimerEvents(Date toTime) {
        List<TimerEvent> timerEvents = timerEventsDao.retrieveTimerEvents(toTime);
        if (!CollectionUtils.isEmpty(timerEvents)) {
            return TimerEventMapper.convertTimerEventsToTimerEventsDtos(timerEvents);
        } else {
            return Collections.emptyList();
        }
    }

    /**
     * Update status of sms queue to processed
     *
     * @param id An id of sms queue
     */
    @Transactional
    public void markAsProcessed(Integer id) {
        //Need to refactor this code
        timerEventsDao.changeTimeEventsStatus(Collections.singletonList(id), TimerEvent.STATUS.PROCESSED);
    }

    /**
     * Mark as exception in event.
     *
     * @param id       Timer event id.
     * @param excetion Exception message.
     */
    @Transactional
    public void markAsExcetion(Integer id, String excetion) {
        //Need to refactor this code
        timerEventsDao.markAsExcetion(id, excetion);
    }

    /**
     * Mark event as complete.
     *
     * @param id Timer event id.
     */
    @Transactional
    public void markAsComplete(Integer id) {
        //Need to refactor this code
        timerEventsDao.markAsComplete(id);
    }

    /**
     * Update status of sms queue to processed
     *
     * @param timerEventIds List of timer events ids.
     */
    @Transactional
    public void markAsProcessed(Collection<Integer> timerEventIds) {
        timerEventsDao.changeTimeEventsStatus(timerEventIds, TimerEvent.STATUS.PROCESSED);
    }

    /**
     * Set is processed true.
     *
     * @param id Timer event id.
     */
    @Transactional
    public void setIsProccessedTrue(Integer id) {
        timerEventsDao.setIsProcessedTrue(id);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    @Async("timerEventTaskExecutor")
    public void handleTimerEvent(TimerEventDto timerEventDto) {

        try {
            switch (timerEventDto.getType()) {
                case EMAIL:
                    emailService.handle(
                            eventConfigurationService.retrieveNotificationConfigTypeDtoById(timerEventDto.getNotificationConfigId()),
                            timerEventDto.getQueryDataLists());
                    break;
                case SMS:
                    smsService.handle(eventConfigurationService.retrieveNotificationConfigTypeDtoById(timerEventDto.getNotificationConfigId()),
                            timerEventDto.getQueryDataLists());
                    break;
                case TIMER_EVENT:
                    Event event = new Event(Event.EVENT_TYPE.TIMER_EVENT, timerEventDto.getEventConfigId(), null, null);
                    EventConfigurationDto eventConfigurationDtos
                            = eventHandler.fetchEventConfig(event).get(0);
                    setIsProccessedTrue(timerEventDto.getId());
                    if (eventConfigurationDtos.getTrigerWhen() != null) {
                        switch (eventConfigurationDtos.getTrigerWhen()) {
                            case MONTHLY:
                            case DAILY:
                            case HOURLY:
                            case MINUTE:
                                Date nextDate = EventFunctionUtil.getNextDate(eventConfigurationDtos.getTrigerWhen(), eventConfigurationDtos);
                                timerEventService.scheduleTimerEvent(new TimerEventDto(null,
                                        TimerEvent.TYPE.TIMER_EVENT, nextDate, eventConfigurationDtos.getId(), null, null, eventConfigurationDtos.getUuid()));

                                break;
                            default:
                        }
                    }
                    eventHandler.processEventConfigs(event, eventConfigurationDtos);

                    break;
                case QUERY:
                    tableService.queryHandler(eventConfigurationService.retrieveNotificationConfigTypeDtoById(timerEventDto.getNotificationConfigId()),
                            timerEventDto.getQueryDataLists());
                    break;
                case UNLOCK_USER:
                    userService.activateAccount(timerEventDto.getRefId());
                    break;
                case CONFIG_PUSH_NOTIFY:
                    techoPushNotificationService.sendPushNotification(timerEventDto);
                    break;
                case PUSH_NOTIFICATION:
                    techoPushNotificationService.handle(
                            eventConfigurationService.retrieveNotificationConfigTypeDtoById(timerEventDto.getNotificationConfigId()),
                            timerEventDto.getQueryDataLists());
                    break;
                case ANNOUNCEMENT_PUSH_NOTIFICATION:
                    List<TechoPushNotificationMaster> techoPushNotificationMasters = new ArrayList<>();
                    AnnouncementPushNotificationDto announcementPushNotificationDto = announcementService.getAnnouncementDetailsForPushNotification(timerEventDto.getRefId());
                    TechoPushNotificationType techoPushNotificationType = techoPushNotificationTypeDao.getTechoPushNotificationTypeByType("NEW_ANNOUNCEMENT");
                    for (Integer userId : announcementPushNotificationDto.getUsers()) {
                        TechoPushNotificationMaster techoPushNotificationMaster = new TechoPushNotificationMaster();
                        techoPushNotificationMaster.setUserId(userId);
                        techoPushNotificationMaster.setType(techoPushNotificationType.getType());
                        techoPushNotificationMaster.setMessage(announcementPushNotificationDto.getAnnouncementMaster().getSubject());
                        techoPushNotificationMaster.setHeading("New Announcement");
                        techoPushNotificationMasters.add(techoPushNotificationMaster);
                    }
                    techoPushNotificationService.createOrUpdateAll(techoPushNotificationMasters);
                    markAsComplete(timerEventDto.getId());
                    break;
                case ADD_LANGUAGE:
                    translatorDao.translateForNewLanguage(timerEventDto.getRefId());

                default:

            }
            this.markAsComplete(timerEventDto.getId());
        } catch (Exception e) {
//          For Timer Event (Event config) specific email sending
            if (timerEventDto.getType() == TIMER_EVENT) {
                SystemConfiguration systemConfiguration
                        = systemConfigurationService.retrieveSystemConfigurationByKey(ConstantUtil.EVENT_CONFIG_FAILED_EXECUTION_EXCEPTION_MAIL);
                if (systemConfiguration != null && "true".equalsIgnoreCase(systemConfiguration.getKeyValue())) {
                    String msg = "Event Configuration Failed !!!  Timer Event Id : " + timerEventDto.getId() + " Event config Id :" + timerEventDto.getEventConfigId();
                    e = new Exception(msg, e);
//                    emailUtil.sendExceptionEmail(e, null);
                    saveException(e);
                }

            }
            this.markAsExcetion(timerEventDto.getId(), org.apache.commons.lang.exception.ExceptionUtils.getStackTrace(e));
            e.printStackTrace();
        }
    }

    private void saveException(Exception e) {
        CaughtExceptionEntity exception = new CaughtExceptionEntity();
        exception.setExceptionMsg(e.getMessage());
        exception.setExceptionStackTrace(ExceptionUtils.getStackTrace(e));
        exception.setExceptionType("Timer Event");
        caughtExceptionService.saveCaughtException(exception);
    }

}
