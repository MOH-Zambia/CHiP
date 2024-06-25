package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.AshaLmpFollowUpDao;
import com.argusoft.imtecho.rch.model.AshaLmpFollowUpMaster;
import com.argusoft.imtecho.rch.service.AshaReportedEventService;
import com.argusoft.imtecho.rch.service.FhwPregnancyConfirmationService;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for FHW pregnancy confirmation.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class FhwPregnancyConfirmationServiceImpl implements FhwPregnancyConfirmationService {

    @Autowired
    private TechoNotificationMasterDao notificationMasterDao;

    @Autowired
    private AshaLmpFollowUpDao ashaLmpFollowUpDao;

    @Autowired
    private AshaReportedEventService ashaReportedEventService;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private EventHandler eventHandler;

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storePregnancyConfirmationForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        if (parsedRecordBean.getNotificationId() != null) {
            TechoNotificationMaster notificationMaster = notificationMasterDao.retrieveById(Integer.valueOf(parsedRecordBean.getNotificationId()));

            if (notificationMaster == null) {
                throw new ImtechoMobileException("Notification not found.", 100);
            }

            notificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
            notificationMaster.setActionBy(user.getId());
            notificationMasterDao.update(notificationMaster);
            Integer ashaLmpVisitId = notificationMaster.getRefCode();
            if (ashaLmpVisitId != null) {
                AshaLmpFollowUpMaster lmpFollowUpMaster = ashaLmpFollowUpDao.retrieveById(ashaLmpVisitId);
                if (keyAndAnswerMap.get("21") != null) {
                    if (keyAndAnswerMap.get("21").equalsIgnoreCase("T")) {
                        lmpFollowUpMaster.setPregConfStatus(RchConstants.PREGNANCY_STATUS_APPROVED);
                        if (keyAndAnswerMap.get("24") != null) {
                            lmpFollowUpMaster.setCurrentGravida(Short.parseShort(keyAndAnswerMap.get("24")));
                        }
                        if (keyAndAnswerMap.get("25") != null) {
                            lmpFollowUpMaster.setCurrentPara(Short.parseShort(keyAndAnswerMap.get("25")));
                        }
                    } else {
                        lmpFollowUpMaster.setPregConfStatus(RchConstants.PREGNANCY_STATUS_REJECTED);
                    }
                }
                ashaLmpFollowUpDao.update(lmpFollowUpMaster);
                ashaLmpFollowUpDao.flush();
                eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_PREG_CONF, lmpFollowUpMaster.getId()));

                boolean isConfirmed = lmpFollowUpMaster.getPregConfStatus() != null && lmpFollowUpMaster.getPregConfStatus().equals(RchConstants.PREGNANCY_STATUS_APPROVED);
                ashaReportedEventService.createReadOnlyNotificationForAsha(isConfirmed, MobileConstantUtil.NOTIFICATION_FHW_PREGNANCY_CONF,
                        memberDao.retrieveById(notificationMaster.getMemberId()), familyDao.retrieveById(notificationMaster.getFamilyId()), user);

                return ashaLmpVisitId;
            }
        }
        return null;
    }
}
