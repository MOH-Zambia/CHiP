package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.*;
import com.argusoft.imtecho.chip.model.*;
import com.argusoft.imtecho.chip.service.ChipMalariaScreeningService;
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
import com.argusoft.imtecho.listvalues.service.ListValueFieldValueDetailService;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.notification.dao.NotificationTypeMasterDao;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class ChipMalariaScreeningServiceImpl implements ChipMalariaScreeningService {

    @Autowired
    private ChipMalariaDao chipMalariaDao;
    @Autowired
    private ChipMalariaNonIndexDao chipMalariaNonIndexDao;
    @Autowired
    private ChipMalariaIndexDao chipMalariaIndexDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;
    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;
    @Autowired
    private EventHandler eventHandler;
    @Autowired
    private MalariaInvestigationMasterDao investigationMasterDao;
    @Autowired
    private ListValueFieldValueDetailService listValueFieldValueDetailService;
    @Autowired
    private StockInventoryDao stockInventoryDao;
    UserMaster userMaster;

    @Override
    public Integer storeActiveMalariaForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        userMaster = user;
        ChipMalariaEntity chipMalariaEntity = new ChipMalariaEntity();
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
        FamilyEntity familyEntity;

        if (!keyAndAnswerMap.get("-5").equals("null")) {
            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
            familyEntity = familyDao.retrieveById(familyId);
        } else {
            familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(memberId).getFamilyId());
            familyId = familyEntity.getId();
            if (keyAndAnswerMap.get("-6").equals("null")) {
                locationId = familyEntity.getLocationId();
            }
        }

        if (locationId == null) {
            locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        }

        chipMalariaEntity.setMemberId(memberId);
        chipMalariaEntity.setLocationId(locationId);
        chipMalariaEntity.setFamilyId(familyId);
        chipMalariaEntity.setServiceDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))));
        chipMalariaEntity.setMalariaType(keyAndAnswerMap.get("-15"));

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipMalariaEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }
        keyAndAnswerMap.forEach((key, answer) -> setAnswersToActiveMalariaForm(key, answer, chipMalariaEntity, memberEntity, memberAdditionalInfo));

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                chipMalariaEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        chipMalariaDao.create(chipMalariaEntity);
        memberDao.update(memberEntity);

        chipMalariaDao.flush();
        memberDao.flush();

        if (chipMalariaEntity.getRdtTestStatus() != null && chipMalariaEntity.getRdtTestStatus().equalsIgnoreCase("POSITIVE")) {
            createActiveMalariaFollowUpNotifications(user, chipMalariaEntity, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.ACTIVE_MALARIA, memberEntity.getId()));
        return chipMalariaEntity.getId();
    }

    @Override
    public Integer storeActiveMalariaFormFromOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        ChipMalariaEntity chipMalariaEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), ChipMalariaEntity.class);
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

        chipMalariaEntity.setMemberId(memberId);
        chipMalariaEntity.setLocationId(locationId);
        chipMalariaEntity.setFamilyId(familyId);

        if (jsonObject.get("malariaType") != null) {
            chipMalariaEntity.setMalariaType(jsonObject.get("malariaType").getAsString());
        }

        if (chipMalariaEntity.getReferralDone() != null && !chipMalariaEntity.getReferralDone().isEmpty()) {
            chipMalariaEntity.setReferralDone(ImtechoUtil.returnYESorNOFromInitials(chipMalariaEntity.getReferralDone()));
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipMalariaEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if ("YES".equalsIgnoreCase(chipMalariaEntity.getReferralDone()) && jsonObject.get("referralPlace") != null) {
            chipMalariaEntity.setReferralPlace(jsonObject.get("referralPlace").getAsInt());
        }

        if (memberEntity.getGender().equalsIgnoreCase("M")) {
            chipMalariaEntity.setLmpDate(null);
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        chipMalariaDao.create(chipMalariaEntity);
        memberDao.update(memberEntity);

        chipMalariaDao.flush();
        memberDao.flush();

        if (chipMalariaEntity.getRdtTestStatus() != null && chipMalariaEntity.getRdtTestStatus().equalsIgnoreCase("POSITIVE")) {
            createActiveMalariaFollowUpNotifications(user, chipMalariaEntity, familyEntity);
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.OCR_ACTIVE_MALARIA, memberEntity.getId()));
        return chipMalariaEntity.getId();
    }

    @Override
    public Integer storePassiveMalariaFormOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        ChipMalariaEntity chipMalariaEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), ChipMalariaEntity.class);
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

        chipMalariaEntity.setMemberId(memberId);
        chipMalariaEntity.setLocationId(locationId);
        chipMalariaEntity.setFamilyId(familyId);

        if (jsonObject.get("malariaType") != null) {
            chipMalariaEntity.setMalariaType(jsonObject.get("malariaType").getAsString());
        }

        if (chipMalariaEntity.getReferralDone() != null && !chipMalariaEntity.getReferralDone().isEmpty()) {
            chipMalariaEntity.setReferralDone(ImtechoUtil.returnYESorNOFromInitials(chipMalariaEntity.getReferralDone()));
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipMalariaEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if ("YES".equalsIgnoreCase(chipMalariaEntity.getReferralDone()) && jsonObject.get("referralPlace") != null) {
            chipMalariaEntity.setReferralPlace(jsonObject.get("referralPlace").getAsInt());
        }

        if (memberEntity.getGender().equalsIgnoreCase("M")) {
            chipMalariaEntity.setLmpDate(null);
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        chipMalariaEntity.setMemberStatus("AVAILABLE");

        chipMalariaDao.create(chipMalariaEntity);
        memberDao.update(memberEntity);

        chipMalariaDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.PASSIVE_MALARIA, memberEntity.getId()));
        return chipMalariaEntity.getId();
    }

    @Override
    public Integer storeActiveMalariaFormFollowUp(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {

        ChipMalariaEntity chipMalariaEntity = new ChipMalariaEntity();
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

        chipMalariaEntity.setMemberId(memberId);
        chipMalariaEntity.setLocationId(locationId);
        chipMalariaEntity.setFamilyId(familyId);
        chipMalariaEntity.setMalariaType(keyAndAnswerMap.get("-15"));

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipMalariaEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }
        keyAndAnswerMap.forEach((key, answer) -> setAnswersToActiveMalariaForm(key, answer, chipMalariaEntity, memberEntity, memberAdditionalInfo));

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                chipMalariaEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        chipMalariaDao.create(chipMalariaEntity);
        memberDao.update(memberEntity);

        chipMalariaDao.flush();
        memberDao.flush();

        if (chipMalariaEntity.getRdtTestStatus() != null && chipMalariaEntity.getRdtTestStatus().equalsIgnoreCase("NEGATIVE")) {
            if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
                TechoNotificationMaster techoNotificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
                techoNotificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
                techoNotificationMaster.setActionBy(user.getId());
                techoNotificationMasterDao.update(techoNotificationMaster);
            }
        }

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.ACTIVE_MALARIA_FOLLOW_UP, memberEntity.getId()));
        return chipMalariaEntity.getId();
    }

    @Override
    public Integer storeMalariaIndexCaseForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        MalariaIndexCaseEntity malariaIndexCaseEntity = new MalariaIndexCaseEntity();
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

        malariaIndexCaseEntity.setMemberId(memberId);
        malariaIndexCaseEntity.setLocationId(locationId);
        malariaIndexCaseEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(malariaIndexCaseEntity.getMemberId());
        keyAndAnswerMap.forEach((key, answer) -> setAnsToMalariaIndexForm(key, answer, malariaIndexCaseEntity, keyAndAnswerMap, memberEntity));

        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (keyAndAnswerMap.containsKey("8")) {
            if (keyAndAnswerMap.get("-21") != null && !keyAndAnswerMap.get("-21").equalsIgnoreCase("null")) {
                malariaIndexCaseEntity.setGpsLocation(keyAndAnswerMap.get("-21"));
            }
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        chipMalariaIndexDao.create(malariaIndexCaseEntity);
        memberDao.update(memberEntity);

        chipMalariaIndexDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MALARIA_INDEX, memberEntity.getId()));
        return malariaIndexCaseEntity.getId();
    }

    @Override
    public Integer storeMalariaIndexCaseOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();
        MalariaIndexCaseEntity malariaIndexCaseEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), MalariaIndexCaseEntity.class);
        malariaIndexCaseEntity.setDaysPassedOfDiagnosis(Integer.valueOf(jsonObject.get("daysSincePatientDiagnosed").getAsString()));
        malariaIndexCaseEntity.setPatientAdheredToTreatment(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("patientAdheredToTreatment").getAsString()));
        if (jsonObject.has("treatmentDay")) {
            malariaIndexCaseEntity.setDayOfTreatment(jsonObject.get("treatmentDay").getAsString());
        }
        malariaIndexCaseEntity.setPatientShowingSigns(jsonObject.get("signShown").getAsString());
        malariaIndexCaseEntity.setWasDbsCollected(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("dbsCollected").getAsString()));
        if (jsonObject.has("dbsResultAvailable")) {
            if (ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("dbsResultAvailable").getAsString())) {
                malariaIndexCaseEntity.setBloodSpotResult(RchConstants.MEMBER_STATUS_AVAILABLE);
            } else {
                malariaIndexCaseEntity.setBloodSpotResult(RchConstants.MALARIA_DBS_ANALYSIS);
            }
        }
        malariaIndexCaseEntity.setBloodSplotValue(jsonObject.get("dbsValue").getAsString());
        chipMalariaIndexDao.create(malariaIndexCaseEntity);

        return 0;
    }

    public Integer storeMalariaIndexInvestigationForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        MalariaInvestigationMaster investigationMaster = new MalariaInvestigationMaster();
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

        investigationMaster.setMemberId(memberId);
        investigationMaster.setLocationId(locationId);
        investigationMaster.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(investigationMaster.getMemberId());
        keyAndAnswerMap.forEach((key, answer) -> setAnsToMalariaIndexInvestigationForm(key, answer, investigationMaster, keyAndAnswerMap, memberEntity));

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

        investigationMasterDao.create(investigationMaster);
        memberDao.update(memberEntity);

        investigationMasterDao.flush();
        memberDao.flush();

        return investigationMaster.getId();
    }

    @Override
    public Integer storeMalariaNonIndexForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        MalariaNonIndexEntity malariaNonIndexEntity = new MalariaNonIndexEntity();
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

        malariaNonIndexEntity.setMemberId(memberId);
        malariaNonIndexEntity.setLocationId(locationId);
        malariaNonIndexEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(malariaNonIndexEntity.getMemberId());
        keyAndAnswerMap.forEach((key, answer) -> setAnsToMalariaNonIndexForm(key, answer, malariaNonIndexEntity, keyAndAnswerMap, memberEntity));

        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (keyAndAnswerMap.containsKey("11")) {
            if (keyAndAnswerMap.get("-21") != null && !keyAndAnswerMap.get("-21").equalsIgnoreCase("null")) {
                malariaNonIndexEntity.setGpsLocation(keyAndAnswerMap.get("-21"));
            }
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        chipMalariaNonIndexDao.create(malariaNonIndexEntity);
        memberDao.update(memberEntity);

        chipMalariaNonIndexDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.MALARIA_NON_INDEX, memberEntity.getId()));
        return malariaNonIndexEntity.getId();
    }

    @Override
    public Integer storeMalariaNonIndexOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();
        MalariaNonIndexEntity malariaNonIndexEntity = new MalariaNonIndexEntity();
        malariaNonIndexEntity.setDateOfLastSpray(new Date(Long.parseLong(jsonObject.get("lastDateOfSpray").getAsString())));
        malariaNonIndexEntity.setIndividualsLiving(Integer.valueOf(jsonObject.get("numberOfIndividual").getAsString()));
        malariaNonIndexEntity.setNonSprayableSurface(jsonObject.get("nonSprayableSurface").getAsString());
        malariaNonIndexEntity.setSprayableSurface(jsonObject.get("sprayableSurface").getAsString());
        malariaNonIndexEntity.setPeopleRcdPositive(Integer.valueOf(jsonObject.get("numberOfPeopleTestedPositive").getAsString()));
        malariaNonIndexEntity.setPeopleTestedInHousehold(Integer.valueOf(jsonObject.get("numberOfPeopleTested").getAsString()));
        malariaNonIndexEntity.setNumberOfLlinsHanging(Integer.valueOf(jsonObject.get("numberOfLlinInHouse").getAsString()));
        malariaNonIndexEntity.setTookMedForMalariaPrevention(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("medicineToPreventMalaria").getAsString()));
        malariaNonIndexEntity.setReceivedAnyOtherPrevention(ImtechoUtil.returnTrueFalseFromInitials(jsonObject.get("preventiveMeasureTaken").getAsString()));
        return chipMalariaNonIndexDao.create(malariaNonIndexEntity);
    }

    @Override
    public Integer storePassiveMalariaForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        ChipMalariaEntity chipMalariaEntity = new ChipMalariaEntity();
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

        chipMalariaEntity.setMemberId(memberId);
        chipMalariaEntity.setLocationId(locationId);
        chipMalariaEntity.setFamilyId(familyId);
        chipMalariaEntity.setMalariaType(keyAndAnswerMap.get("-15"));

        MemberEntity memberEntity = memberDao.retrieveMemberById(chipMalariaEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        keyAndAnswerMap.forEach((key, answer) -> setAnswersToPassiveMalariaForm(key, answer, chipMalariaEntity, memberEntity, memberAdditionalInfo));

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                chipMalariaEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

        chipMalariaDao.create(chipMalariaEntity);
        memberDao.update(memberEntity);

        chipMalariaDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.PASSIVE_MALARIA, memberEntity.getId()));
        return chipMalariaEntity.getId();
    }

    private void setAnsToMalariaIndexForm(String key, String answer, MalariaIndexCaseEntity malariaIndexCaseEntity, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "6":
                malariaIndexCaseEntity.setWasVisitConducted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7513":
                malariaIndexCaseEntity.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "60":
                malariaIndexCaseEntity.setReasonForNoVisit(answer);
                break;
            case "7":
                malariaIndexCaseEntity.setIndividualsLiving(Integer.valueOf(answer));
                break;
            case "9":
                malariaIndexCaseEntity.setSprayableSurface(answer);
                break;
            case "10":
                malariaIndexCaseEntity.setNonSprayableSurface(answer);
                break;
            case "11":
                malariaIndexCaseEntity.setWasIrsConducted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "110":
                malariaIndexCaseEntity.setDateOfLastSpray(new Date(Long.parseLong(answer)));
                break;
            case "12":
                malariaIndexCaseEntity.setHavingLlin(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "120":
                malariaIndexCaseEntity.setAreLlinHanging(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "121":
                malariaIndexCaseEntity.setNumberOfLlinsHanging(Integer.valueOf(answer));
                break;
            case "13":
                malariaIndexCaseEntity.setSleepUnderLlin(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "14":
                malariaIndexCaseEntity.setSleepingInSprayedRoom(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "15":
                malariaIndexCaseEntity.setDaysPassedOfDiagnosis(Integer.valueOf(answer));
                break;
            case "16":
                malariaIndexCaseEntity.setPatientAdheredToTreatment(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "160":
                malariaIndexCaseEntity.setDayOfTreatment(answer);
                break;
            case "18":
                malariaIndexCaseEntity.setWhereEvidenceIsSeen(answer);
                break;
            case "180":
                malariaIndexCaseEntity.setTemperature(answer);
                break;
            case "19":
                malariaIndexCaseEntity.setWereYouReferred(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "190":
                malariaIndexCaseEntity.setWentToReferralPlace(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "20":
                if (answer.equalsIgnoreCase("NONE")) {
                    break;
                }
                if (answer.contains("OTHER")) {
                    answer = ImtechoUtil.convertAnswersWithOther(answer);
                }
                malariaIndexCaseEntity.setPatientShowingSigns(answer);
                break;
            case "21":
                if (answer.equalsIgnoreCase("NONE")) {
                    break;
                }
                if (answer.contains("OTHER")) {
                    answer = ImtechoUtil.convertAnswersWithOther(answer);
                }
                malariaIndexCaseEntity.setPatientExperiencingSigns(answer);
                break;
            case "211":
                if (answer != null && !answer.trim().isEmpty()) {
                    malariaIndexCaseEntity.setOtherExpSigns(answer);
                }
                break;
            case "223":
                if (answer != null && !answer.trim().isEmpty()) {
                    malariaIndexCaseEntity.setOtherShowingSigns(answer);
                }
                break;
            case "219":
                malariaIndexCaseEntity.setWasDbsCollected(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "220":
                malariaIndexCaseEntity.setBloodSpotResult(answer);
                break;
            case "221":
                malariaIndexCaseEntity.setBloodSplotValue(answer);
                break;
            case "7514":
                malariaIndexCaseEntity.setMemberStatus(answer);
                break;
            case "7561":
                if (answer != null && !answer.isEmpty()) {
                    malariaIndexCaseEntity.setLatitude(answer);
                }
                break;
            case "7562":
                if (answer != null && !answer.isEmpty()) {
                    malariaIndexCaseEntity.setLongitude(answer);
                }
                break;
            default:
        }
    }

    private void setAnsToMalariaIndexInvestigationForm(String key, String answer, MalariaInvestigationMaster investigationMaster, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "7513":
                investigationMaster.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "6":
                investigationMaster.setBreedingSiteFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7":
                investigationMaster.setBreedingSiteLocation(answer);
                break;
            case "8":
                investigationMaster.setAnophelesDetected(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "9":
                investigationMaster.setAnophelesStage(answer);
                break;
            case "11":
                investigationMaster.setSitePermanence(answer);
                break;
            case "12":
                if (answer.equalsIgnoreCase("NONE")) {
                    break;
                }
                if (answer.contains("OTHER")) {
                    answer = ImtechoUtil.convertAnswersWithOther(answer);
                }
                investigationMaster.setSiteType(answer);
                break;
            case "223":
                investigationMaster.setOtherSiteType(answer);
                break;
            case "13":
                if (answer.equalsIgnoreCase("NONE")) {
                    break;
                }
                if (answer.contains("OTHER")) {
                    answer = ImtechoUtil.convertAnswersWithOther(answer);
                }
                investigationMaster.setRecommendedActions(answer);
                break;
            case "323":
                investigationMaster.setOtherRecommendedActions(answer);
                break;
            case "14":
                if (answer.equalsIgnoreCase("NONE")) {
                    break;
                }
                if (answer.contains("OTHER")) {
                    answer = ImtechoUtil.convertAnswersWithOther(answer);
                }
                investigationMaster.setActionsTaken(answer);
                break;
            case "423":
                investigationMaster.setOtherActionsTaken(answer);
                break;
            case "15":
                investigationMaster.setStructuresFound(Integer.valueOf(answer));
                break;
            case "16":
                investigationMaster.setEligibleStructures(Integer.valueOf(answer));
                break;
            case "17":
                investigationMaster.setStrSprayedLast12Month(Integer.valueOf(answer));
                break;
            case "18":
                investigationMaster.setTotalPeople(Integer.valueOf(answer));
                break;
            case "19":
                investigationMaster.setLlinDistLast12Month(Integer.valueOf(answer));
                break;
            case "20":
                investigationMaster.setLlinPeopleSlept(Integer.valueOf(answer));
                break;
            case "7561":
                if (answer != null && !answer.isEmpty()) {
                    investigationMaster.setLatitude(answer);
                }
                break;
            case "7562":
                if (answer != null && !answer.isEmpty()) {
                    investigationMaster.setLongitude(answer);
                }
                break;
            default:
        }
    }

    private void setAnsToMalariaNonIndexForm(String key, String answer, MalariaNonIndexEntity malariaNonIndexEntity, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "7":
                malariaNonIndexEntity.setHasConsentSought(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7513":
                malariaNonIndexEntity.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "6":

            case "8":
                malariaNonIndexEntity.setReasonForNoConsent(answer);
                break;
            case "9":
                malariaNonIndexEntity.setIndividualsLiving(Integer.valueOf(answer));
                break;
            case "10":
                malariaNonIndexEntity.setIndividualsOnLastNight(Integer.valueOf(answer));
                break;
            case "12":
                malariaNonIndexEntity.setPeopleTestedInHousehold(Integer.valueOf(answer));
                break;
            case "13":
                malariaNonIndexEntity.setPeopleRcdPositive(Integer.valueOf(answer));
                break;
            case "15":
                malariaNonIndexEntity.setSprayableSurface(answer);
                break;
            case "16":
                malariaNonIndexEntity.setNonSprayableSurface(answer);
                break;
            case "17":
                malariaNonIndexEntity.setWasIrsConducted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "18":
                malariaNonIndexEntity.setDateOfLastSpray(new Date(Long.parseLong(answer)));
                break;
            case "19":
                malariaNonIndexEntity.setHavingLlinInHouse(answer);
                break;
            case "20":
                malariaNonIndexEntity.setNumberOfLlinsHanging(Integer.valueOf(answer));
                break;
            case "22":
                malariaNonIndexEntity.setSleepUnderLlin(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "23":
                malariaNonIndexEntity.setTookDhap(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "24":
                malariaNonIndexEntity.setTookMedForMalariaPrevention(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "25":
                malariaNonIndexEntity.setReceivedAnyOtherPrevention(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "26":
                if (answer != null && !answer.trim().isEmpty()) {
                    malariaNonIndexEntity.setOtherPreventiveMeasure(answer);
                }
                break;
            case "7514":
                malariaNonIndexEntity.setMemberStatus(answer);
                break;
            case "7561":
                if (answer != null && !answer.isEmpty()) {
                    malariaNonIndexEntity.setLatitude(answer);
                }
                break;
            case "7562":
                if (answer != null && !answer.isEmpty()) {
                    malariaNonIndexEntity.setLongitude(answer);
                }
                break;
            default:
        }
    }

    private void setAnswersToActiveMalariaForm(String key, String answer, ChipMalariaEntity chipMalariaEntity, MemberEntity memberEntity, MemberAdditionalInfo memberAdditionalInfo) {
        switch (key) {
            case "4":
                Set<Integer> chipMalariaEntities = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        chipMalariaEntities.add(Integer.parseInt(id));
                    }
                }
                chipMalariaEntity.setActiveMalariaSDetails(chipMalariaEntities);
                break;
            case "6":
                chipMalariaEntity.setOtherMalariaSymtoms(answer);
                break;
            case "7":
                chipMalariaEntity.setRdtTestStatus(answer);
                memberAdditionalInfo.setRdtStatus(chipMalariaEntity.getRdtTestStatus());
                memberEntity.setAdditionalInfo(new Gson().toJson(memberAdditionalInfo));
                break;
            case "695":
                chipMalariaEntity.setIsIndexCase(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setIndexCase(chipMalariaEntity.getIsIndexCase());
                memberEntity.setAdditionalInfo(new Gson().toJson(memberAdditionalInfo));
                break;
            case "8":
                chipMalariaEntity.setHavingTravelHistory(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "9":
                chipMalariaEntity.setMalariaTreatmentHistory(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "10":
                chipMalariaEntity.setIsTreatmentBeingGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "11":
                chipMalariaEntity.setReferralPlace(Integer.valueOf(answer));
                break;
            case "21":
                switch (answer) {
                    case "1":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "26":
                if (!answer.trim().isEmpty()) {
                    chipMalariaEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    chipMalariaEntity.setReferralFor(answer);
                }
                break;
            case "8989":
                chipMalariaEntity.setIsIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4501":
                chipMalariaEntity.setStartedMenstruating(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4502":
                chipMalariaEntity.setLmpDate(new Date(Long.parseLong(answer)));
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "7514":
                chipMalariaEntity.setMemberStatus(answer);
                break;
            case "100":
                chipMalariaEntity.setTreatmentGiven(answer);
                if (answer == null) {
                    break;
                }
                if (answer.equalsIgnoreCase("AMD")) {
                    int amdId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.AMD);
                    StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(userMaster.getId()), amdId);
                    if (stockInventoryEntity != null) {
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                } else if (answer.equalsIgnoreCase("PAIN_KILLER")) {
                    int painKillerId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.PAIN_KILLER);
                    StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(userMaster.getId()), painKillerId);
                    if (stockInventoryEntity != null) {
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                } else if (answer.equalsIgnoreCase("ORS")) {
                    int orsId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.ORS);
                    StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(userMaster.getId()), orsId);
                    if (stockInventoryEntity != null) {
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                }
                break;
            default:
        }
    }

    private void setAnswersToPassiveMalariaForm(String key, String answer, ChipMalariaEntity chipMalariaEntity, MemberEntity memberEntity, MemberAdditionalInfo memberAdditionalInfo) {
        switch (key) {
            case "4":
                Set<Integer> chipMalariaEntities = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        chipMalariaEntities.add(Integer.parseInt(id));
                    }
                }
                chipMalariaEntity.setActiveMalariaSDetails(chipMalariaEntities);
                break;
            case "6":
                chipMalariaEntity.setOtherMalariaSymtoms(answer);
                break;
            case "7":
                chipMalariaEntity.setRdtTestStatus(answer);
                memberAdditionalInfo.setRdtStatus(chipMalariaEntity.getRdtTestStatus());
                memberEntity.setAdditionalInfo(new Gson().toJson(memberAdditionalInfo));
                break;
            case "8":
                chipMalariaEntity.setHavingTravelHistory(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "9":
                chipMalariaEntity.setMalariaTreatmentHistory(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "10":
                chipMalariaEntity.setIsTreatmentBeingGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "11":
                chipMalariaEntity.setReferralPlace(Integer.valueOf(answer));
                break;
            case "21":
                switch (answer) {
                    case "1":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        chipMalariaEntity.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "26":
                if (!answer.trim().isEmpty()) {
                    chipMalariaEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    chipMalariaEntity.setReferralFor(answer);
                }
                break;
            case "4501":
                chipMalariaEntity.setStartedMenstruating(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8989":
                chipMalariaEntity.setIsIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "4502":
                chipMalariaEntity.setLmpDate(new Date(Long.parseLong(answer)));
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "7514":
                chipMalariaEntity.setMemberStatus(answer);
                break;
            default:
        }
    }

    private void createActiveMalariaFollowUpNotifications(UserMaster user, ChipMalariaEntity chipMalariaEntity, FamilyEntity familyEntity) {
        Calendar instance = Calendar.getInstance();
        instance.add(Calendar.DATE, 30);
        Date dueDate = instance.getTime();

        TechoNotificationMaster notification = new TechoNotificationMaster();
        notification.setNotificationTypeId(notificationTypeMasterDao.retrieveByCode(MobileConstantUtil.ACTIVE_MALARIA_FOLLOW_UP_VISIT).getId());
        notification.setMemberId(chipMalariaEntity.getMemberId());
        notification.setUserId(user.getId());
        notification.setFamilyId(familyEntity.getId());
        notification.setLocationId(chipMalariaEntity.getLocationId());
        notification.setScheduleDate(new Date());
        notification.setDueOn(dueDate);
        notification.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMasterDao.create(notification);
    }
}
