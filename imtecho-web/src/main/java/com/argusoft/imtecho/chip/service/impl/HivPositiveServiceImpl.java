package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.EMTCTDao;
import com.argusoft.imtecho.chip.model.EMTCTEntity;
import com.argusoft.imtecho.chip.service.HivPositiveService;
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
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.HivKnownDao;
import com.argusoft.imtecho.rch.dao.HivPositiveDao;
import com.argusoft.imtecho.rch.dao.HivScreeningDao;
import com.argusoft.imtecho.rch.model.HivKnownPositiveEntity;
import com.argusoft.imtecho.rch.model.HivPositiveEntity;
import com.argusoft.imtecho.rch.model.HivScreeningEntity;
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
public class HivPositiveServiceImpl implements HivPositiveService {

    @Autowired
    private HivPositiveDao hivPositiveDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private HivScreeningDao hivScreeningDao;
    @Autowired
    private HivKnownDao hivKnownDao;
    @Autowired
    private EMTCTDao emtctDao;
    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;
    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;
    @Autowired
    private EventHandler eventHandler;

    @Override
    public Integer storeHivPositiveForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        HivPositiveEntity hivPositiveEntity = new HivPositiveEntity();
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

        hivPositiveEntity.setMemberId(memberId);
        hivPositiveEntity.setLocationId(locationId);
        hivPositiveEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivPositiveEntity.getMemberId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToEntity(key, answer, hivPositiveEntity);
        }

        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                hivPositiveEntity.setReferralPlace(keyAndAnswerMap.get("-20"));
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

        hivPositiveDao.create(hivPositiveEntity);
        memberDao.update(memberEntity);

        hivPositiveDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.HIV_POSITIVE, hivPositiveEntity.getId()));
        return hivPositiveEntity.getId();
    }

    @Override
    public Integer storeHivPositiveFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        HivPositiveEntity hivPositiveEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), HivPositiveEntity.class);
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

        hivPositiveEntity.setMemberId(memberId);
        hivPositiveEntity.setLocationId(locationId);
        hivPositiveEntity.setFamilyId(familyId);
        if (hivPositiveEntity.getIsReferralDone() != null && !hivPositiveEntity.getIsReferralDone().isEmpty()) {
            hivPositiveEntity.setIsReferralDone(ImtechoUtil.returnYESorNOFromInitials(hivPositiveEntity.getIsReferralDone()));
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivPositiveEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if ("YES".equalsIgnoreCase(hivPositiveEntity.getIsReferralDone()) && jsonObject.get("referralPlace") != null) {
            hivPositiveEntity.setReferralPlace(jsonObject.get("referralPlace").getAsString());
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        hivPositiveEntity.setMemberStatus("AVAILABLE");

        hivPositiveDao.create(hivPositiveEntity);
        memberDao.update(memberEntity);

        hivPositiveDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.HIV_POSITIVE, hivPositiveEntity.getId()));
        return hivPositiveEntity.getId();
    }

    @Override
    public Integer storeHivScreeningForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        HivScreeningEntity hivScreeningEntity = new HivScreeningEntity();
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

        hivScreeningEntity.setMemberId(memberId);
        hivScreeningEntity.setLocationId(locationId);
        hivScreeningEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivScreeningEntity.getMemberId());
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersForHivScreening(key, answer, hivScreeningEntity, memberEntity);
        }

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                hivScreeningEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        hivScreeningDao.create(hivScreeningEntity);
        hivScreeningDao.flush();

        if (!hivScreeningEntity.isHivTestResult()) {
            createHivNegativeFollowUpNotifications(user, memberEntity, hivScreeningEntity, familyEntity);
        }

        updateMemberInfoFromHivDetails(hivScreeningEntity, memberEntity, keyAndAnswerMap);
        memberDao.update(memberEntity);
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.HIV_SCREENING, hivScreeningEntity.getId()));
        return hivScreeningEntity.getId();
    }

    @Override
    public Integer storeHivScreeningFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        HivScreeningEntity hivScreeningEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), HivScreeningEntity.class);
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

        hivScreeningEntity.setMemberId(memberId);
        hivScreeningEntity.setLocationId(locationId);
        hivScreeningEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivScreeningEntity.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (jsonObject.get("referralPlace") != null) {
            hivScreeningEntity.setReferralPlace(jsonObject.get("referralPlace").getAsInt());
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        hivScreeningEntity.setMemberStatus("AVAILABLE");
        hivScreeningEntity.setCreatedOn(new Date());

        if (!hivScreeningEntity.isHivTestResult()) {
            createHivNegativeFollowUpNotifications(user, memberEntity, hivScreeningEntity, familyEntity);
        }

        hivScreeningDao.create(hivScreeningEntity);
        hivScreeningDao.flush();

        memberDao.update(memberEntity);
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.HIV_POSITIVE, hivScreeningEntity.getId()));
        return hivScreeningEntity.getId();
    }

    @Override
    public Integer storeHivScreeningFUForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        HivScreeningEntity hivScreeningEntity = new HivScreeningEntity();
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

        hivScreeningEntity.setMemberId(memberId);
        hivScreeningEntity.setLocationId(locationId);
        hivScreeningEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivScreeningEntity.getMemberId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersForHivScreening(key, answer, hivScreeningEntity, memberEntity);
        }

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                hivScreeningEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
            TechoNotificationMaster techoNotificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
            techoNotificationMaster.setState(TechoNotificationMaster.State.COMPLETED);
            techoNotificationMaster.setActionBy(user.getId());
            techoNotificationMasterDao.update(techoNotificationMaster);
        }
        hivScreeningDao.create(hivScreeningEntity);
        hivScreeningDao.flush();
        updateMemberInfoFromHivDetails(hivScreeningEntity, memberEntity, keyAndAnswerMap);
        memberDao.update(memberEntity);
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.HIV_SCREENING_FU, hivScreeningEntity.getId()));
        return hivScreeningEntity.getId();
    }

    @Override
    public Integer storeAnswersForKnownPositive(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        HivKnownPositiveEntity hivKnownPositive = new HivKnownPositiveEntity();
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

        hivKnownPositive.setMemberId(memberId);
        hivKnownPositive.setLocationId(locationId);
        hivKnownPositive.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivKnownPositive.getMemberId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersForKnownForm(key, answer, hivKnownPositive);
        }
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

        hivKnownDao.create(hivKnownPositive);
        memberDao.update(memberEntity);

        hivKnownDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.KNOWN_POSITIVE, hivKnownPositive.getId()));
        return hivKnownPositive.getId();
    }

    @Override
    public Integer storeAnswersForKnownPositiveOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        HivKnownPositiveEntity hivKnownPositive = gson.fromJson(parsedRecordBean.getAnswerRecord(), HivKnownPositiveEntity.class);
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

        hivKnownPositive.setMemberId(memberId);
        hivKnownPositive.setLocationId(locationId);
        hivKnownPositive.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(hivKnownPositive.getMemberId());
        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        if (memberEntity.getGender().equalsIgnoreCase("M")) {
            hivKnownPositive.setLmpDate(null);
        }

        hivKnownPositive.setMemberStatus("AVAILABLE");

        hivKnownDao.create(hivKnownPositive);
        memberDao.update(memberEntity);

        hivKnownDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.KNOWN_POSITIVE, hivKnownPositive.getId()));
        return hivKnownPositive.getId();
    }

    @Override
    public Integer storeAnswersForEMTCT(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        EMTCTEntity emtctEntity = new EMTCTEntity();

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

        emtctEntity.setMemberId(memberId);
        emtctEntity.setLocationId(locationId);
        emtctEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(emtctEntity.getMemberId());

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersForEMTCTForm(key, answer, emtctEntity);
        }
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

        emtctDao.create(emtctEntity);
        memberDao.update(memberEntity);

        emtctDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.EMTCT, emtctEntity.getId()));
        return emtctEntity.getId();
    }

    @Override
    public Integer storeAnswersForEMTCTOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        EMTCTEntity emtctEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), EMTCTEntity.class);
        JsonObject jsonObject = JsonParser.parseString(parsedRecordBean.getAnswerRecord()).getAsJsonObject();
        MemberEntity memberEntity = null;
        Integer memberId = null;
        if (jsonObject.get("memberId") != null) {
            memberId = jsonObject.get("memberId").getAsInt();
            memberEntity = memberDao.retrieveMemberById(memberId);
        } else {
            if (jsonObject.get("memberUUID") != null) {
                memberEntity = memberDao.retrieveMemberByUuid(jsonObject.get("memberUUID").getAsString());
            }
        }
        if (memberEntity == null) {
            memberEntity = new MemberEntity();
        }
        Integer familyId = null;
        Integer locationId = null;
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberEntity.getFamilyId());
        familyId = familyEntity.getId();
        locationId = familyEntity.getAreaId() != null ? familyEntity.getAreaId() : familyEntity.getLocationId();

        emtctEntity.setMemberId(memberEntity.getId());
        emtctEntity.setLocationId(locationId);
        emtctEntity.setFamilyId(familyId);

        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        emtctEntity.setMemberStatus("AVAILABLE");

        emtctDao.create(emtctEntity);
        memberDao.update(memberEntity);

        emtctDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.EMTCT, emtctEntity.getId()));
        return emtctEntity.getId();
    }

    private void setAnswersForEMTCTForm(String key, String answer, EMTCTEntity emtctEntity) {
        if (answer != null) {
            switch (key) {
                case "201":
                    emtctEntity.setDbsTestDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "7513":
                    emtctEntity.setServiceDate(new Date(Long.parseLong(answer)));
                    break;
                case "202":
                    emtctEntity.setDbsResult(answer);
                    break;
                case "7514":
                    emtctEntity.setMemberStatus(answer);
                    break;
                default:
            }
        }
    }

    private void setAnswersForHivScreening(String key, String answer, HivScreeningEntity hivScreeningEntity, MemberEntity memberEntity) {
        if (answer != null) {
            switch (key) {
                case "6":
                    hivScreeningEntity.setChildHivTest(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "7513":
                    hivScreeningEntity.setServiceDate(new Date(Long.parseLong(answer)));
                    break;
                case "7", "17", "114", "99":
                    hivScreeningEntity.setHivTestResult(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "8":
                    hivScreeningEntity.setChildCurrentlyOnArt(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "9":
                    hivScreeningEntity.setChildArtEnrollmentNumber(answer);
                    break;
                case "10":
                    hivScreeningEntity.setChildMotherHivPositive(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "11":
                    hivScreeningEntity.setChildParentDead(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "12":
                    hivScreeningEntity.setChildHasTbSymptoms(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "13":
                    hivScreeningEntity.setChildSick(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "14":
                    hivScreeningEntity.setChildRashes(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "15":
                    hivScreeningEntity.setPusNearEar(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "16", "112":
                    hivScreeningEntity.setEligibleForHiv(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "101":
                    hivScreeningEntity.setEverToldHivPositive(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "102":
                    hivScreeningEntity.setReceivingArt(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "103":
                    hivScreeningEntity.setClientArtNumber(answer);
                    break;
                case "105":
                    hivScreeningEntity.setTestedForHivIn12Months(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "106":
                    hivScreeningEntity.setSymptoms(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "107":
                    hivScreeningEntity.setPrivatePartsSymptoms(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "108":
                    hivScreeningEntity.setExposedToHiv(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "109":
                    hivScreeningEntity.setUnprotectedSexInLast6Months(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "8674":
                    hivScreeningEntity.setReferralPlace(Integer.valueOf(answer));
                    break;
                case "111":
                    hivScreeningEntity.setPregnantOrBreastfeeding(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    memberEntity.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    break;
                case "7514":
                    hivScreeningEntity.setMemberStatus(answer);
                    break;
                default:
            }
        }
    }

    private void setAnswersForKnownForm(String key, String answer, HivKnownPositiveEntity hivKnownPositive) {
        switch (key) {
            case "5":
                hivKnownPositive.setSeptrin(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7513":
                hivKnownPositive.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "6":
                hivKnownPositive.setDuration((new Date(Long.parseLong(answer))));
                break;
            case "7", "13":
                hivKnownPositive.setArvTaken(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8":
                hivKnownPositive.setPrepOrPep(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "11":
                hivKnownPositive.setArvDuringPregnancy(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "12":
                hivKnownPositive.setStoppedArt(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "14":
                hivKnownPositive.setWhenStopped(answer);
                break;
            case "15":
                hivKnownPositive.setPlaceReceivedArt(answer);
                break;
            case "60":
                hivKnownPositive.setTakenArt(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "61":
                hivKnownPositive.setOtherMedicationAlong(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "62":
                hivKnownPositive.setEnoughMedication(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "64":
                hivKnownPositive.setViralLoadTest(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "66":
                hivKnownPositive.setViralLoadSuppressed(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "67":
                hivKnownPositive.setUnprotectedSex(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "68":
                hivKnownPositive.setHivStatusOfMemberKnown(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "69":
                hivKnownPositive.setWillingToShareStatus(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "690":
                hivKnownPositive.setName(answer);
                break;
            case "691":
                hivKnownPositive.setPhoneNumber(answer);
                break;
            case "692":
                hivKnownPositive.setAddress(answer);
                break;
            case "90":
                hivKnownPositive.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "7514":
                hivKnownPositive.setMemberStatus(answer);
                break;
            default:
        }

    }

    private void setAnswersToEntity(String key, String answer, HivPositiveEntity hivPositiveEntity) {
        switch (key) {
            case "8":
                hivPositiveEntity.setExpectedDeliveryPlace(answer);
                break;
            case "10":
                hivPositiveEntity.setIsOnArt(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "12":
                switch (answer) {
                    case "1":
                        hivPositiveEntity.setIsReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        hivPositiveEntity.setIsReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        hivPositiveEntity.setIsReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "13":
                hivPositiveEntity.setReferralPlace(answer);
                break;
            case "2222":
                if (!answer.trim().isEmpty()) {
                    hivPositiveEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    hivPositiveEntity.setReferralFor(answer);
                }
                break;
            case "7514":
                hivPositiveEntity.setMemberStatus(answer);
                break;
            default:
        }
    }

    private void updateMemberInfoFromHivDetails(HivScreeningEntity hivScreeningEntity, MemberEntity memberEntity, Map<String, String> keyAndAnswerMap) {
        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }
        if (hivScreeningEntity.isHivTestResult()) {
            memberAdditionalInfo.setHivTest("POSITIVE");
        } else {
            memberAdditionalInfo.setHivTest("NEGATIVE");
        }
        if (keyAndAnswerMap.containsKey("7513")) {
            if (keyAndAnswerMap.get("7513") != null
                    && !keyAndAnswerMap.get("7513").equalsIgnoreCase("null")
                    && !keyAndAnswerMap.get("7513").isEmpty()) {
                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("7513"))).getTime());
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }
        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
    }

    private void createHivNegativeFollowUpNotifications(UserMaster user, MemberEntity memberEntity, HivScreeningEntity hivScreeningEntity, FamilyEntity familyEntity) {
        Calendar instance = Calendar.getInstance();
        Date dueDate = instance.getTime();

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(hivScreeningEntity.getCreatedOn());
        calendar.add(Calendar.MONTH, 3);
        Date scheduleDate = calendar.getTime();

        Integer notificationTypeId = notificationTypeMasterDao.retrieveByCode(MobileConstantUtil.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT).getId();
        TechoNotificationMaster notification = new TechoNotificationMaster();
        //techoNotificationMasterDao.markOlderNotificationAsMissed(memberEntity.getId(), notificationTypeId);
        notification.setNotificationTypeId(notificationTypeId);
        notification.setMemberId(memberEntity.getId());
        notification.setUserId(user.getId());
        notification.setFamilyId(familyEntity.getId());
        notification.setLocationId(familyEntity.getAreaId());
        notification.setScheduleDate(scheduleDate);
//        notification.setScheduleDate(new Date());
        notification.setDueOn(dueDate);
        notification.setState(TechoNotificationMaster.State.PENDING);
        techoNotificationMasterDao.create(notification);
    }
}
