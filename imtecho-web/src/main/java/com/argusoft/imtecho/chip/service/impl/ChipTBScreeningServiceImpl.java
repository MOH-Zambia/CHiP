package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.ChipTBDao;
import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.chip.model.ChipTBEntity;
import com.argusoft.imtecho.chip.service.ChipTBScreeningService;
import com.argusoft.imtecho.common.model.UserMaster;
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
import com.argusoft.imtecho.notification.service.TechoNotificationService;
import com.argusoft.imtecho.rch.constants.RchConstants;
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

@Service
@Transactional
public class ChipTBScreeningServiceImpl implements ChipTBScreeningService {

    @Autowired
    private ChipTBDao chipTBDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private EventHandler eventHandler;
    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;
    @Autowired
    private TechoNotificationService techoNotificationService;
    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;

    @Override
    public Integer storeTBForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        ChipTBEntity chipTBEntity = new ChipTBEntity();
        Integer memberId = null;
        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        } else {
            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                memberId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
            }
        }

        Integer familyId;
        Integer locationId = null;

        if (!keyAndAnswerMap.get("-5").equals("null")) {
            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        } else {
            FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(memberId).getFamilyId());
            familyId = familyEntity.getId();
            if (keyAndAnswerMap.get("-6").equals("null")) {
                locationId = familyEntity.getLocationId();
            }
        }

        if (locationId == null) {
            locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        }

        chipTBEntity.setMemberId(memberId);
        chipTBEntity.setLocationId(locationId);
        chipTBEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipTBEntity.getMemberId());
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());

        if (keyAndAnswerMap.get("-16") != null) {
            chipTBEntity.setFormType(keyAndAnswerMap.get("-16"));
        }

        keyAndAnswerMap.forEach((key, answer) -> setAnswersToTBForm(key, answer, chipTBEntity, memberEntity));

        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                chipTBEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        chipTBDao.create(chipTBEntity);
        memberDao.update(memberEntity);

        chipTBDao.flush();
        memberDao.flush();


        if (chipTBEntity.getTbSuspected() != null && chipTBEntity.getTbSuspected()) {
            createTbSuspectedNotification(user, chipTBEntity, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_TB, chipTBEntity.getId()));
        return chipTBEntity.getId();
    }

    @Override
    public Integer storeTBFormOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        ChipTBEntity chipTBEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), ChipTBEntity.class);
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();

        Integer memberId = null;
        if (jsonObject.get("memberId") != null) {
            memberId = jsonObject.get("memberId").getAsInt();
        } else {
            if (jsonObject.get("memberUUID")  != null) {
                memberId = memberDao.retrieveMemberByUuid(String.valueOf(jsonObject.get("memberUUID"))).getId();
            }
        }

        Integer familyId;
        Integer locationId = null;
        FamilyEntity familyEntity;

        if (jsonObject.get("familyId") != null) {
            familyId = jsonObject.get("familyId").getAsInt();
            familyEntity = familyDao.retrieveById(familyId);
        } else {
            familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(memberId).getFamilyId());
            familyId = familyEntity.getId();
            locationId = familyEntity.getAreaId();
        }

        if (locationId == null) {
            locationId = familyEntity.getAreaId();
        }

        chipTBEntity.setMemberId(memberId);
        chipTBEntity.setLocationId(locationId);
        chipTBEntity.setFamilyId(familyId);

        if (chipTBEntity.getReferralDone() != null && !chipTBEntity.getReferralDone().isEmpty()) {
            chipTBEntity.setReferralDone(ImtechoUtil.returnYESorNOFromInitials(chipTBEntity.getReferralDone()));
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipTBEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if ("YES".equalsIgnoreCase(chipTBEntity.getReferralDone()) && jsonObject.get("referralPlace") != null) {
            chipTBEntity.setReferralPlace(jsonObject.get("referralPlace").getAsInt());
        }

        if (memberEntity.getGender().equalsIgnoreCase("M")) {
            chipTBEntity.setLmpDate(null);
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        chipTBEntity.setFormType("TB_SCREENING");
        chipTBEntity.setMemberStatus("AVAILABLE");

        chipTBDao.create(chipTBEntity);
        memberDao.update(memberEntity);

        chipTBDao.flush();
        memberDao.flush();


        if (chipTBEntity.getTbSuspected() != null && chipTBEntity.getTbSuspected()) {
            createTbSuspectedNotification(user, chipTBEntity, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_TB, chipTBEntity.getId()));
        return chipTBEntity.getId();
    }

    @Override
    public Integer storeTBFollowUpForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        ChipTBEntity chipTBEntity = new ChipTBEntity();
        Integer memberId = null;
        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        } else {
            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                memberId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
            }
        }

        Integer familyId;
        Integer locationId = null;

        if (!keyAndAnswerMap.get("-5").equals("null")) {
            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        } else {
            FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(memberId).getFamilyId());
            familyId = familyEntity.getId();
            if (keyAndAnswerMap.get("-6").equals("null")) {
                locationId = familyEntity.getLocationId();
            }
        }

        if (locationId == null) {
            locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        }

        chipTBEntity.setMemberId(memberId);
        chipTBEntity.setLocationId(locationId);
        chipTBEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipTBEntity.getMemberId());

        if (keyAndAnswerMap.get("-16") != null) {
            chipTBEntity.setFormType(keyAndAnswerMap.get("-16"));
        }

        keyAndAnswerMap.forEach((key, answer) -> setAnswersToTBFollowUpForm(key, answer, chipTBEntity, memberEntity));

        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                chipTBEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        chipTBDao.create(chipTBEntity);
        memberDao.update(memberEntity);

        chipTBDao.flush();
        memberDao.flush();


        if (chipTBEntity.getTbCured() != null && chipTBEntity.getTbCured()) {
            if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
                TechoNotificationMaster techoNotificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
                techoNotificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
                techoNotificationMaster.setActionBy(user.getId());
                techoNotificationMasterDao.update(techoNotificationMaster);
            }
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_TB_FOLLOW_UP, chipTBEntity.getId()));
        return chipTBEntity.getId();
    }

    private void setAnswersToTBForm(String key, String answer, ChipTBEntity chipTBEntity, MemberEntity memberEntity) {
        switch (key) {
            case "4":
                if (!answer.equals("NONE")) {
                    chipTBEntity.setTuberculosisSymptoms(answer);
                }
                break;
            case "6":
                chipTBEntity.setOtherTbSymptoms(answer);
                break;
            case "7":
                chipTBEntity.setTbTestingDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8":
                chipTBEntity.setTbTestType(answer);
                break;
            case "9":
                chipTBEntity.setTbSuspected(ImtechoUtil.returnTrueFalseFromInitials(answer));
                MemberAdditionalInfo memberAdditionalInfo;
                Gson gson = new Gson();

                if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                    memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                } else {
                    memberAdditionalInfo = new MemberAdditionalInfo();
                }

                if (chipTBEntity.getTbSuspected() != null) {
                    memberAdditionalInfo.setTbSuspected(chipTBEntity.getTbSuspected());
                }

                if (chipTBEntity.getTbSuspected() != null && chipTBEntity.getTbSuspected()) {
                    memberAdditionalInfo.setTbCured(false);
                }
                memberEntity.setModifiedOn(new Date());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                break;
            case "10":
                chipTBEntity.setReferralPlace(Integer.valueOf(answer));
                break;
            case "21":
                switch (answer) {
                    case "1":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "26":
                if (!answer.trim().isEmpty()) {
                    chipTBEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    chipTBEntity.setReferralFor(answer);
                }
                break;
            case "8989":
                chipTBEntity.setIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4501":
                chipTBEntity.setStartedMenstruating(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4502":
                chipTBEntity.setLmpDate(new Date(Long.parseLong(answer)));
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "7514":
                chipTBEntity.setMemberStatus(answer);
                break;
            default:
        }
    }

    private void setAnswersToTBFollowUpForm(String key, String answer, ChipTBEntity chipTBEntity, MemberEntity memberEntity) {
        switch (key) {
            case "4":
                chipTBEntity.setTbCured(ImtechoUtil.returnTrueFalseFromInitials(answer));
                MemberAdditionalInfo memberAdditionalInfo;
                Gson gson = new Gson();
                if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                    memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                } else {
                    memberAdditionalInfo = new MemberAdditionalInfo();
                }

                if (chipTBEntity.getTbCured() != null) {
                    memberAdditionalInfo.setTbCured(chipTBEntity.getTbCured());
                }

                if (chipTBEntity.getTbCured() != null && chipTBEntity.getTbCured()) {
                    memberAdditionalInfo.setTbSuspected(false);
                }
                memberEntity.setModifiedOn(new Date());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                break;
            case "5":
                chipTBEntity.setPatientTakingMedicines(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "6":
                chipTBEntity.setAnyReactionOrSideEffect(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7":
                chipTBEntity.setReferralPlace(Integer.valueOf(answer));
                break;
            case "21":
                switch (answer) {
                    case "1":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        chipTBEntity.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "26":
                if (!answer.trim().isEmpty()) {
                    chipTBEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    chipTBEntity.setReferralFor(answer);
                }
                break;
            case "4501":
                chipTBEntity.setStartedMenstruating(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4502":
                chipTBEntity.setLmpDate(new Date(Long.parseLong(answer)));
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "7514":
                chipTBEntity.setMemberStatus(answer);
                break;
            default:
        }
    }

    private void createTbSuspectedNotification(UserMaster user, ChipTBEntity chipTBEntity, FamilyEntity familyEntity) {
        Calendar instance = Calendar.getInstance();
        instance.add(Calendar.DATE, 30);
        Date dueDate = instance.getTime();

        TechoNotificationMaster notification = new TechoNotificationMaster();
        notification.setNotificationTypeId(notificationTypeMasterDao.retrieveByCode(MobileConstantUtil.TB_FOLLOW_UP_VISIT).getId());
        notification.setMemberId(chipTBEntity.getMemberId());
        notification.setUserId(user.getId());
        notification.setFamilyId(familyEntity.getId());
        notification.setLocationId(chipTBEntity.getLocationId());
        notification.setScheduleDate(new Date());
        notification.setDueOn(dueDate);
        notification.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMasterDao.create(notification);
    }

}
