/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.DateDeserializer;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.notification.dao.NotificationTypeMasterDao;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.rch.service.RimService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;

/**
 * <p>
 * Define services for rim.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class RimServiceImpl implements RimService {

    @Autowired
    private MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private EventHandler eventHandler;
    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;
    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;

    private final Gson gson = new Gson();

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeRimVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Integer memberId = null;
        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        } else {
            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                memberId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
            }
        }
        MemberEntity memberEntity = memberDao.retrieveById(memberId);
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());

        MemberAdditionalInfo memberAdditionalInfo;

        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToMembersEntity(key, answer, keyAndAnswerMap, memberEntity, memberAdditionalInfo);
        }

        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        memberDao.update(memberEntity);
        memberDao.flush();

        if ((memberEntity.getHysterectomyDone() != null && !memberEntity.getHysterectomyDone())
                || (memberEntity.getMenopauseArrived() != null && !memberEntity.getMenopauseArrived())) {
            createFpFollowUpNotifications(user, memberEntity, memberAdditionalInfo, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_RIM, memberId));
        return memberEntity.getId();
    }

    @Override
    public Integer storeRimVisitFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();

        Integer memberId = null;
        if (jsonObject.get("memberId") != null) {
            memberId = jsonObject.get("memberId").getAsInt();
        } else {
            if (jsonObject.get("memberUUID") != null) {
                memberId = memberDao.retrieveMemberByUuid(String.valueOf(jsonObject.get("memberUUID"))).getId();
            }
        }

        Integer familyId;
        FamilyEntity familyEntity;

        if (jsonObject.get("familyId") != null) {
            familyId = jsonObject.get("familyId").getAsInt();
            familyEntity = familyDao.retrieveById(familyId);
        } else {
            familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(memberId).getFamilyId());
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(memberId);

        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (jsonObject.get("familyPlanningStage") != null) {
            memberEntity.setFpStage(jsonObject.get("familyPlanningStage").getAsString());
        }

        if (jsonObject.get("isIecGiven") != null) {
            memberEntity.setIecGiven(jsonObject.get("isIecGiven").getAsBoolean());
        }

        if (jsonObject.get("familyPlanningMethod") != null) {
            memberEntity.setLastMethodOfContraception(jsonObject.get("familyPlanningMethod").getAsString());
            memberEntity.setFamilyPlanningMethod(jsonObject.get("familyPlanningMethod").getAsString());
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        memberDao.update(memberEntity);
        memberDao.flush();

        if ((memberEntity.getHysterectomyDone() != null && !memberEntity.getHysterectomyDone())
                || (memberEntity.getMenopauseArrived() != null && !memberEntity.getMenopauseArrived())) {
            createFpFollowUpNotifications(user, memberEntity, memberAdditionalInfo, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_RIM, memberId));
        return memberEntity.getId();
    }


    @Override
    public Integer storeFpFollowUpVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Integer memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        MemberEntity memberEntity = memberDao.retrieveById(memberId);

        MemberAdditionalInfo memberAdditionalInfo;

        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToMembersEntity(key, answer, keyAndAnswerMap, memberEntity, memberAdditionalInfo);
        }

        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        memberDao.update(memberEntity);
        memberDao.flush();

        if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
            TechoNotificationMaster techoNotificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
            techoNotificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
            techoNotificationMaster.setActionBy(user.getId());
            techoNotificationMasterDao.update(techoNotificationMaster);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_FP_FOLLOW_UP, memberId));
        return memberEntity.getId();
    }

    private void createFpFollowUpNotifications(UserMaster user, MemberEntity memberEntity, MemberAdditionalInfo memberAdditionalInfo, FamilyEntity familyEntity) {
        Calendar instance = Calendar.getInstance();
        instance.add(Calendar.DATE, 30);
        Date dueDate = instance.getTime();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date(memberAdditionalInfo.getFpServiceDate()));
        calendar.add(Calendar.WEEK_OF_YEAR, 6);
        Date scheduleDate = calendar.getTime();

        Integer notificationTypeId = notificationTypeMasterDao.retrieveByCode(MobileConstantUtil.FP_FOLLOW_UP_VISIT).getId();
        TechoNotificationMaster notification = new TechoNotificationMaster();
        //techoNotificationMasterDao.markOlderNotificationAsMissed(memberEntity.getId(), notificationTypeId);
        notification.setNotificationTypeId(notificationTypeId);
        notification.setMemberId(memberEntity.getId());
        notification.setUserId(user.getId());
        notification.setFamilyId(familyEntity.getId());
        notification.setLocationId(familyEntity.getAreaId());
        notification.setScheduleDate(scheduleDate);
        //notification.setScheduleDate(new Date());
        notification.setDueOn(dueDate);
        notification.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMasterDao.create(notification);
    }

    private void setAnswersToMembersEntity(String key, String answer, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity, MemberAdditionalInfo memberAdditionalInfo) {
        switch (key) {
            case "3":
            case "333":
                memberEntity.setLastMethodOfContraception(answer);
                memberEntity.setNotUsingFpReason(null);
                break;
            case "551":
            case "554":
            case "555":
            case "556":
            case "557":
            case "558":
            case "559":
                if (keyAndAnswerMap.get("3") != null) {
                    memberEntity.setFpSubMethod(answer);
                    memberEntity.setNotUsingFpReason(null);
                }
                break;
            case "553":
            case "574":
            case "578":
                if (keyAndAnswerMap.get("3") != null) {
                    memberEntity.setFpAlternativeMainMethod(answer);
                    memberEntity.setNotUsingFpReason(null);
                }
                break;
            case "571":
            case "572":
            case "575":
            case "576":
            case "579":
            case "580":
                if (keyAndAnswerMap.get("3") != null) {
                    memberEntity.setFpAlternativeSubMethod(answer);
                    memberEntity.setNotUsingFpReason(null);
                }
                break;
            case "31":
                memberEntity.setFpInsertOperateDate(new Date(Long.parseLong(answer)));
                break;
            case "4":
                memberEntity.setMenopauseArrived(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7":
                memberEntity.setHysterectomyDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "22":
                memberEntity.setFpStage(answer);
                break;
            case "29":
                memberAdditionalInfo.setFpServiceDate(new Date(Long.parseLong(answer)).getTime());
                break;
            case "225":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setNotUsingFpReason(answer);
                    memberEntity.setFpSubMethod(null);
                    memberEntity.setFpAlternativeMainMethod(null);
                    memberEntity.setFpAlternativeSubMethod(null);
                }
                break;
            case "5":
                memberEntity.setIsIucdRemoved(ImtechoUtil.returnTrueFalseFromInitials(keyAndAnswerMap.get("5")));
                if (Boolean.TRUE.equals(ImtechoUtil.returnTrueFalseFromInitials(keyAndAnswerMap.get("5")))
                        && keyAndAnswerMap.get("6") != null) {
                    memberEntity.setIucdRemovalDate(new Date(Long.parseLong(keyAndAnswerMap.get("6"))));
                }
                break;
            case "222":
                memberEntity.setPlanningForFamily(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "2222":
                memberEntity.setWhyStopFp(answer);
                break;
            case "8989":
                memberEntity.setIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            default:
        }
    }

}
