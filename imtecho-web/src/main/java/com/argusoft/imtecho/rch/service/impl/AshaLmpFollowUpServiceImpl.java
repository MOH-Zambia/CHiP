package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.AshaLmpFollowUpDao;
import com.argusoft.imtecho.rch.model.AshaLmpFollowUpMaster;
import com.argusoft.imtecho.rch.service.AshaLmpFollowUpService;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;

import com.argusoft.imtecho.rch.service.AshaReportedEventService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for ASHA lmp follow up service.
 * </p>
 * @author prateek
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class AshaLmpFollowUpServiceImpl implements AshaLmpFollowUpService {

    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private AshaLmpFollowUpDao ashaLmpFollowUpDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private AshaReportedEventService ashaReportedEventService;

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeAshaLmpFollowUpForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Integer memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        Integer familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        Integer locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        MemberEntity memberEntity = memberDao.retrieveById(memberId);

        if (memberEntity.getState() != null && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(memberEntity.getState())) {
            throw new ImtechoMobileException("Member is already marked as dead.", 1);
        }
        if (memberEntity.getIsPregnantFlag() != null && memberEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is already marked as pregnant.", 1);
        }

        if (keyAndAnswerMap.get("45") != null && !keyAndAnswerMap.get("45").isEmpty()) {
            memberEntity.setMobileNumber(keyAndAnswerMap.get("45"));
            memberDao.update(memberEntity);
        }

        AshaLmpFollowUpMaster ashaLmpFollowUpMaster = new AshaLmpFollowUpMaster();
        ashaLmpFollowUpMaster.setMemberId(memberId);
        ashaLmpFollowUpMaster.setFamilyId(familyId);
        ashaLmpFollowUpMaster.setLocationId(locationId);
        ashaLmpFollowUpMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
        ashaLmpFollowUpMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        ashaLmpFollowUpMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        ashaLmpFollowUpMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));
        ashaLmpFollowUpMaster.setIsPregnant(Boolean.FALSE);

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToLmpFollowUpVisitEntity(key, answer, ashaLmpFollowUpMaster, keyAndAnswerMap, memberEntity);
        }

        ashaLmpFollowUpDao.create(ashaLmpFollowUpMaster);
        this.updateMemberAdditionalInfo(memberEntity, ashaLmpFollowUpMaster);

        if (ashaLmpFollowUpMaster.getMemberStatus().equals(RchConstants.MEMBER_STATUS_DEATH)) {
            ashaReportedEventService.createNotificationForReportedEventByAsha(ashaLmpFollowUpMaster.getMemberId(),
                    MobileConstantUtil.NOTIFICATION_FHW_DEATH_CONF,
                    ashaLmpFollowUpMaster.getFamilyId(), ashaLmpFollowUpMaster.getLocationId(), ashaLmpFollowUpMaster.getId(),
                    MobileConstantUtil.ASHA_LMPFU_VISIT);
            return ashaLmpFollowUpMaster.getId();
        }

        if (ashaLmpFollowUpMaster.getMemberStatus().equals(RchConstants.MEMBER_STATUS_MIGRATED)) {
            ashaReportedEventService.createNotificationForReportedEventByAsha(ashaLmpFollowUpMaster.getMemberId(),
                    MobileConstantUtil.NOTIFICATION_FHW_MEMBER_MIGRATION,
                    ashaLmpFollowUpMaster.getFamilyId(), ashaLmpFollowUpMaster.getLocationId(), ashaLmpFollowUpMaster.getId(),
                    MobileConstantUtil.ASHA_LMPFU_VISIT);
            return ashaLmpFollowUpMaster.getId();
        }

        ashaLmpFollowUpDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.ASHA_LMPFU, ashaLmpFollowUpMaster.getId()));
        return ashaLmpFollowUpMaster.getId();
    }

    /**
     * Set answer to lmp follow up visit.
     * @param key Key.
     * @param answer Answer for member's lmp follow up visit details.
     * @param ashaLmpFollowUpMaster Asha lmp follow up master details.
     * @param keyAndAnswerMap Contains key and answers.
     * @param memberEntity Child service visit details.
     */
    private void setAnswersToLmpFollowUpVisitEntity(String key, String answer, AshaLmpFollowUpMaster ashaLmpFollowUpMaster, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "-2":
                ashaLmpFollowUpMaster.setLatitude(answer);
                break;
            case "-1":
                ashaLmpFollowUpMaster.setLongitude(answer);
                break;
            case "6":
                Date dob = memberEntity.getDob();
                if (dob != null) {
                    Calendar instance = Calendar.getInstance();
                    instance.setTime(dob);
                    int yob = instance.get(Calendar.YEAR);
                    int yom = yob + Integer.parseInt(answer);
                    ashaLmpFollowUpMaster.setYear(Short.valueOf(Integer.toString(yom)));
                }
                break;
            case "21":
                ashaLmpFollowUpMaster.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "22":
                ashaLmpFollowUpMaster.setMemberStatus(answer);
                break;
            case "24":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ashaLmpFollowUpMaster.setDeathDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "25":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ashaLmpFollowUpMaster.setPlaceOfDeath(answer);
                }
                break;
            case "26":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (answer.equalsIgnoreCase("OTHER")) {
                        ashaLmpFollowUpMaster.setDeathReason("-1");
                    } else if (!answer.equalsIgnoreCase("NONE")) {
                        ashaLmpFollowUpMaster.setDeathReason(answer);
                    }
                }
                break;
            case "28":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)
                        && keyAndAnswerMap.get("26").equalsIgnoreCase("OTHER")) {
                    ashaLmpFollowUpMaster.setOtherDeathReason(answer);
                }
                break;
            case "31":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equals("T")) {
                    ashaLmpFollowUpMaster.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "33":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("T")
                        && keyAndAnswerMap.get("32").equalsIgnoreCase("T")) {
                    ashaLmpFollowUpMaster.setFamilyPlanningMethod(answer);
                }
                break;
            case "34":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("T")
                        && keyAndAnswerMap.get("32").equalsIgnoreCase("T")) {
                    ashaLmpFollowUpMaster.setFpInsertOperateDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "40":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("F")) {
                    switch (answer) {
                        case "T":
                            ashaLmpFollowUpMaster.setPregnancyTestDone(Boolean.TRUE);
                            break;
                        case "F":
                            ashaLmpFollowUpMaster.setPregnancyTestDone(Boolean.FALSE);
                            break;
                        default:
                    }
                }
                break;
            case "41":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("F") && keyAndAnswerMap.get("40").equalsIgnoreCase("T")) {
                    switch (answer) {
                        case "T":
                            ashaLmpFollowUpMaster.setIsPregnant(Boolean.TRUE);
                            ashaLmpFollowUpMaster.setPregConfStatus(RchConstants.PREGNANCY_STATUS_PENDING);
                            break;
                        case "F":
                            ashaLmpFollowUpMaster.setIsPregnant(Boolean.FALSE);
                            break;
                        default:
                    }
                }
                break;
            case "44":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("F")
                        && keyAndAnswerMap.get("40").equalsIgnoreCase("T")
                        && keyAndAnswerMap.get("41").equalsIgnoreCase("T")) {
                    ashaLmpFollowUpMaster.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "45":
                if (keyAndAnswerMap.get("22").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("30").equalsIgnoreCase("F")
                        && keyAndAnswerMap.get("40").equalsIgnoreCase("T")
                        && keyAndAnswerMap.get("41").equalsIgnoreCase("T")) {
                    ashaLmpFollowUpMaster.setPhoneNumber(answer);
                }
                break;
            default:
        }
    }

    /**
     * Update additional info for ASHA follow up.
     * @param memberEntity Member details.
     * @param lmpVisit ASHA lmp follow up details.
     */
    private void updateMemberAdditionalInfo(MemberEntity memberEntity, AshaLmpFollowUpMaster lmpVisit) {
        Gson gson = new Gson();
        MemberAdditionalInfo memberAdditionalInfo;

        if (lmpVisit.getServiceDate() != null) {
            if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
            } else {
                memberAdditionalInfo = new MemberAdditionalInfo();
            }
            memberAdditionalInfo.setLastServiceLongDate(lmpVisit.getServiceDate().getTime());
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            memberDao.update(memberEntity);
        }
    }
}
