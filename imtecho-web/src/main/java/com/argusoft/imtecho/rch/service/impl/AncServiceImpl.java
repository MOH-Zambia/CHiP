/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.chip.dao.StockInventoryDao;
import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.chip.model.StockInventoryEntity;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.DateDeserializer;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.listvalues.service.ListValueFieldValueDetailService;
import com.argusoft.imtecho.location.dao.HealthInfrastructureDetailsDao;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.AncVisitDao;
import com.argusoft.imtecho.rch.dto.AncMasterDto;
import com.argusoft.imtecho.rch.dto.ImmunisationDto;
import com.argusoft.imtecho.rch.mapper.AncMapper;
import com.argusoft.imtecho.rch.model.AncVisit;
import com.argusoft.imtecho.rch.model.ImmunisationMaster;
import com.argusoft.imtecho.rch.service.AncService;
import com.argusoft.imtecho.rch.service.ImmunisationService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>
 * Define services for anc.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class AncServiceImpl implements AncService {

    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private AncVisitDao ancVisitDao;

    @Autowired
    private ImmunisationService immunisationService;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private MobileFhsService mobileFhsService;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private ImtechoSecurityUser user;

    @Autowired
    private HealthInfrastructureDetailsDao healthInfrastructureDetailsDao;

    @Autowired
    private StockInventoryDao stockInventoryDao;

    @Autowired
    private ListValueFieldValueDetailService listValueFieldValueDetailService;

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeAncVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
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
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        MemberEntity motherEntity = memberDao.retrieveById(memberId);
        Integer pregnancyRegDetId = null;

        if (keyAndAnswerMap.get("-7") != null && !keyAndAnswerMap.get("-7").equals("null")) {
            pregnancyRegDetId = Integer.valueOf(keyAndAnswerMap.get("-7"));
        }

        if (motherEntity.getState() != null
                && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(motherEntity.getState())) {
            throw new ImtechoMobileException("Member is already marked as dead.", 1);
        }

        if (motherEntity.getIsPregnantFlag() == null || !motherEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is not marked as pregnant.", 1);
        }

        if (motherEntity.getCurPregRegDetId() != null) {
            pregnancyRegDetId = motherEntity.getCurPregRegDetId();
        }

        if (pregnancyRegDetId == null && ConstantUtil.DROP_TYPE.equals("P")) {
            if (motherEntity.getState().equals(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_UNVERIFIED)
                    || FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_ARCHIVED.contains(motherEntity.getState())) {
                throw new ImtechoMobileException("Member is not verified. Please Verified thru FHS.", 1);
            }
            throw new ImtechoUserException("Pregnancy Registration Details has not been generated yet.", 1);
        }

        if (motherEntity.getLmpDate() != null && keyAndAnswerMap.get("301") != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(motherEntity.getLmpDate());
            calendar.add(Calendar.DATE, 91);
            Date newLmp = new Date(Long.parseLong(keyAndAnswerMap.get("301")));
            if (newLmp.after(calendar.getTime())) {
                throw new ImtechoMobileException("Sorry, LMP Date in ANC Form should be changed only till 91 days.", 1);
            }
        }

//        if (keyAndAnswerMap.get("801") != null && !keyAndAnswerMap.get("801").isEmpty()) {
//            FamilyEntity family = familyDao.retrieveById(familyId);
////            family.setAnganwadiId(Integer.valueOf(keyAndAnswerMap.get("801")));
//            family.setAnganwadiUpdateFlag(Boolean.FALSE);
//            familyDao.update(family);
//        } else if (keyAndAnswerMap.get("9057") != null && !keyAndAnswerMap.get("9057").isEmpty()) {
//            FamilyEntity family = familyDao.retrieveById(familyId);
////            family.setAnganwadiId(Integer.valueOf(keyAndAnswerMap.get("9057")));
//            family.setAnganwadiUpdateFlag(Boolean.FALSE);
//            familyDao.update(family);
//        }

        if (keyAndAnswerMap.get("511") != null && keyAndAnswerMap.get("511").equalsIgnoreCase("2")) {
            List<String> split = Arrays.asList(keyAndAnswerMap.get("512").split(","));

            List<MemberEntity> childMembers = memberDao.getChildMembersByMotherId(memberId, null);
            if (!childMembers.isEmpty()) {
                for (MemberEntity memberEntity : childMembers) {
                    memberEntity.setMotherId(null);
                    memberDao.update(memberEntity);
                }
            }

            for (String childId : split) {
                if (!childId.equals("ADDNEW") && !childId.isEmpty()) {
                    MemberEntity childMember = memberDao.retrieveById(Integer.valueOf(childId));
                    childMember.setMotherId(memberId);
                }
            }

            if (split.contains("ADDNEW")) {
                Map<String, String> newChildKeyAndAnswerMap = new HashMap<>();
                List<String> keysForNewChildMembers = this.getKeysForNewChildMembers();
                for (Map.Entry<String, String> entry : keyAndAnswerMap.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();

                    if (key.contains(".")) {
                        String[] split1 = key.split("\\.");
                        if (keysForNewChildMembers.contains(split1[0])) {
                            newChildKeyAndAnswerMap.put(key, value);
                        }
                    }
                    if (keysForNewChildMembers.contains(key)) {
                        newChildKeyAndAnswerMap.put(key, value);
                    }
                }
                Map<String, MemberEntity> mapOfNewChildWithLoopIdAsKey = new HashMap<>();

                for (Map.Entry<String, String> entry : newChildKeyAndAnswerMap.entrySet()) {
                    String key = entry.getKey();
                    String value = entry.getValue();
                    MemberEntity memberEntity;
                    if (key.contains(".")) {
                        String[] splitKey = key.split("\\.");
                        memberEntity = mapOfNewChildWithLoopIdAsKey.get(splitKey[1]);
                        if (memberEntity == null) {
                            memberEntity = new MemberEntity();
                            memberEntity.setMotherId(memberId);
                            memberEntity.setFamilyId(memberDao.retrieveById(memberId).getFamilyId());
                            memberEntity.setState(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_NEW);
                            memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                            mapOfNewChildWithLoopIdAsKey.put(splitKey[1], memberEntity);
                        }
                        this.setAnswersToNewChildMembers(splitKey[0], value, memberEntity);
                    } else {
                        memberEntity = mapOfNewChildWithLoopIdAsKey.get("0");
                        if (memberEntity == null) {
                            memberEntity = new MemberEntity();
                            memberEntity.setMotherId(memberId);
                            memberEntity.setFamilyId(memberDao.retrieveById(memberId).getFamilyId());
                            memberEntity.setState(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_NEW);
                            memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                            mapOfNewChildWithLoopIdAsKey.put("0", memberEntity);
                        }
                        this.setAnswersToNewChildMembers(key, value, memberEntity);
                    }
                }

                for (Map.Entry<String, MemberEntity> entry : mapOfNewChildWithLoopIdAsKey.entrySet()) {
                    MemberEntity value = entry.getValue();
                    memberDao.create(value);
                }
            }
        }

        AncVisit ancVisit = new AncVisit();
        ancVisit.setMemberId(memberId);
        ancVisit.setFamilyId(familyId);
        ancVisit.setLocationId(locationId);
        ancVisit.setPregnancyRegDetId(pregnancyRegDetId);
        ancVisit.setLocationHierarchyId(locationLevelHierarchy.getId());
        if (keyAndAnswerMap.get("-8") != null && !keyAndAnswerMap.get("-8").equals("null")) {
            ancVisit.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            ancVisit.setMobileStartDate(new Date(0L));
        }
        if (keyAndAnswerMap.get("-9") != null && !keyAndAnswerMap.get("-9").equals("null")) {
            ancVisit.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            ancVisit.setMobileEndDate(new Date(0L));
        }
        ancVisit.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToAncVisitEntity(key, answer, ancVisit, keyAndAnswerMap, user.getId());
        }

        if (keyAndAnswerMap.containsKey("8672") && keyAndAnswerMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                ancVisit.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        ancVisit.setIsHighRiskCase(this.identifyHighRiskForRchAnc(ancVisit));
        motherEntity.setIsHighRiskCase(ancVisit.getIsHighRiskCase());

        if (ancVisit.getMemberStatus().equals(RchConstants.MEMBER_STATUS_DEATH)) {
            mobileFhsService.checkIfMemberDeathEntryExists(memberId);
        }
        ancVisitDao.create(ancVisit);

        StringBuilder immunisationGiven = new StringBuilder();

        if (keyAndAnswerMap.containsKey("2207") && keyAndAnswerMap.get("2207").equals("1")) {
            Date givenDate = new Date(Long.parseLong(keyAndAnswerMap.get("2208")));
            if (ConstantUtil.IMPLEMENTATION_TYPE.equalsIgnoreCase("chip")) {
                int ttVaccineId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.TT_VACCINE);
                StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user.getId()), ttVaccineId);
                stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                stockInventoryDao.update(stockInventoryEntity);
            }
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, memberId, MobileConstantUtil.MOTHER_BENEFICIARY,
                    MobileConstantUtil.ANC_VISIT, ancVisit.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                    MobileConstantUtil.IMMUNISATION_TT_BOOSTER, givenDate, user.getId(), locationId, locationLevelHierarchy.getId(), pregnancyRegDetId);
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_TT_BOOSTER);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(givenDate));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }
        }

        if (keyAndAnswerMap.containsKey("2204") && keyAndAnswerMap.get("2204").equals("1")) {
            Date givenDate = new Date(Long.parseLong(keyAndAnswerMap.get("2205")));
            if (ConstantUtil.IMPLEMENTATION_TYPE.equalsIgnoreCase("chip")) {
                int ttTwoVaccineId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.TT_TWO_VACCINE);
                StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user.getId()), ttTwoVaccineId);
                stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                stockInventoryDao.update(stockInventoryEntity);
            }
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, memberId, MobileConstantUtil.MOTHER_BENEFICIARY,
                    MobileConstantUtil.ANC_VISIT, ancVisit.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                    MobileConstantUtil.IMMUNISATION_TT_2, givenDate, user.getId(), locationId, locationLevelHierarchy.getId(), pregnancyRegDetId);
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_TT_2);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(givenDate));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }
        }

        if (keyAndAnswerMap.containsKey("22") && keyAndAnswerMap.get("22").equals("1")) {
            Date givenDate = new Date(Long.parseLong(keyAndAnswerMap.get("221")));
            if (ConstantUtil.IMPLEMENTATION_TYPE.equalsIgnoreCase("chip")) {
                int ttOneVaccineId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.TT_ONE_VACCINE);
                StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user.getId()), ttOneVaccineId);
                stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                stockInventoryDao.update(stockInventoryEntity);
            }
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, memberId, MobileConstantUtil.MOTHER_BENEFICIARY,
                    MobileConstantUtil.ANC_VISIT, ancVisit.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                    MobileConstantUtil.IMMUNISATION_TT_1, givenDate, user.getId(), locationId, locationLevelHierarchy.getId(), pregnancyRegDetId);
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_TT_1);
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(givenDate));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }
        }

        if (immunisationGiven.length() > 1) {
            immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
            if (motherEntity.getImmunisationGiven() != null && !motherEntity.getImmunisationGiven().isEmpty()) {
                String sb = motherEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                motherEntity.setImmunisationGiven(sb.replace(" ", ""));
            } else {
                String immunisation = immunisationGiven.toString().replace(" ", "");
                motherEntity.setImmunisationGiven(immunisation);
            }
        }

        String isAadharScanned = keyAndAnswerMap.get("9003");
        String aadharMap = null;
        String aadharNumber = null;
        if (isAadharScanned != null) {
            if (isAadharScanned.equals("1")) {
                aadharMap = keyAndAnswerMap.get("9004");
            } else {
                String answer = keyAndAnswerMap.get("9005");
                if (answer != null && !answer.equals("T")) {
                    aadharNumber = answer.replace("F/", "");
                }
            }
        }

        this.updateMemberAdditionalInfoFromAnc(motherEntity, ancVisit, keyAndAnswerMap);
        mobileFhsService.updateMemberDetailsFromRchForms(keyAndAnswerMap.get("9002"), aadharMap, aadharNumber,
                keyAndAnswerMap.get("9008"), keyAndAnswerMap.get("9010"), motherEntity);
        ancVisitDao.flush();
        eventHandler.handle(
                new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_ANC, ancVisit.getId()));
        return ancVisit.getId();
    }


    public Integer storeAncVisitFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        AncVisit ancVisit = gson.fromJson(parsedRecordBean.getAnswerRecord(), AncVisit.class);
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
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        Integer pregnancyRegDetId = null;
        MemberEntity motherEntity = memberDao.retrieveById(memberId);
        MemberAdditionalInfo memberAdditionalInfo;
        if (motherEntity.getAdditionalInfo() != null && !motherEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(motherEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (motherEntity.getState() != null
                && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(motherEntity.getState())) {
            throw new ImtechoMobileException("Member is already marked as dead.", 1);
        }

        if (motherEntity.getIsPregnantFlag() == null || !motherEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is not marked as pregnant.", 1);
        }

        if (motherEntity.getCurPregRegDetId() != null) {
            pregnancyRegDetId = motherEntity.getCurPregRegDetId();
        }

        if (pregnancyRegDetId == null && ConstantUtil.DROP_TYPE.equals("P")) {
            if (motherEntity.getState().equals(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_UNVERIFIED)
                    || FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_ARCHIVED.contains(motherEntity.getState())) {
                throw new ImtechoMobileException("Member is not verified. Please Verified thru FHS.", 1);
            }
            throw new ImtechoUserException("Pregnancy Registration Details has not been generated yet.", 1);
        }

        if (motherEntity.getLmpDate() != null && keyAndAnswerMap.get("301") != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(motherEntity.getLmpDate());
            calendar.add(Calendar.DATE, 91);
            Date newLmp = new Date(Long.parseLong(keyAndAnswerMap.get("301")));
            if (newLmp.after(calendar.getTime())) {
                throw new ImtechoMobileException("Sorry, LMP Date in ANC Form should be changed only till 91 days.", 1);
            }
        }

        ancVisit.setMemberId(memberId);
        ancVisit.setFamilyId(familyId);
        ancVisit.setLocationId(locationId);
        ancVisit.setPregnancyRegDetId(pregnancyRegDetId);
        ancVisit.setLocationHierarchyId(locationLevelHierarchy.getId());
        ancVisit.setIsHighRiskCase(this.identifyHighRiskForRchAnc(ancVisit));
        motherEntity.setIsHighRiskCase(ancVisit.getIsHighRiskCase());

        if ("YES".equalsIgnoreCase(ancVisit.getReferralDone()) && jsonObject.get("referralPlace") != null) {
            ancVisit.setReferralPlace(jsonObject.get("referralPlace").getAsInt());
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            motherEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        ancVisit.setMemberStatus("AVAILABLE");

        ancVisitDao.create(ancVisit);
        memberDao.update(motherEntity);

        ancVisitDao.flush();
        memberDao.flush();

        eventHandler.handle(
                new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_ANC, ancVisit.getId()));
        return ancVisit.getId();
    }

    /**
     * Set answer to anc visit entity.
     *
     * @param key              Key.
     * @param answer           Answer for member's anc visit details.
     * @param ancVisit         Anc visit details.
     * @param keyAndAnswersMap Contains key and answers.
     */
    private void setAnswersToAncVisitEntity(String key, String answer, AncVisit ancVisit, Map<String, String> keyAndAnswersMap, Integer user) {
        switch (key) {
            case "-2":
                ancVisit.setLatitude(answer);
                break;
            case "-1":
                ancVisit.setLongitude(answer);
                break;
            case "29":
                ancVisit.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "30":
                ancVisit.setMemberStatus(answer);
                break;
            case "301":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "304":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setBloodGroup(answer);
                }
                break;
            case "503":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setLastDeliveryOutcome(answer);
                }
                break;
            case "501":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    Set<String> previousPregnancyComplicationIdsSet = new HashSet<>();
                    String[] previousPregnancyComplicationIdsArray = answer.split(",");
                    for (String previousPregnancyComplicationId : previousPregnancyComplicationIdsArray) {
                        if (!previousPregnancyComplicationId.equalsIgnoreCase(RchConstants.PREVIOUS_PREGNANCY_COMPLICATION_NONE)) {
                            if (previousPregnancyComplicationId.equalsIgnoreCase(RchConstants.PREVIOUS_PREGNANCY_COMPLICATION_OTHER)) {
                                ancVisit.setOtherPreviousPregnancyComplication(keyAndAnswersMap.get("505"));
                            } else {
                                previousPregnancyComplicationIdsSet.add(previousPregnancyComplicationId);
                            }
                        }
                    }
                    ancVisit.setPreviousPregnancyComplication(previousPregnancyComplicationIdsSet);
                }
                break;
            case "31":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setJsyBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "313":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setJsyPaymentDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "32":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setKpsyBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "33":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setIayBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "34":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setChiranjeeviYojnaBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "1523":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHavingBirthPlan(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "4":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAncPlace(Integer.valueOf(answer));
                }
                break;
            case "41":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setDeliveryPlace(answer);
                    if (answer.equals(RchConstants.DELIVERY_PLACE_PRIVATE_HOSPITAL)) {
                        ancVisit.setDeliveryPlace(RchConstants.DELIVERY_PLACE_HOSPITAL);
                        ancVisit.setTypeOfHospital(893);
                    }
                }
                break;
            case "42":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswersMap.get("41").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    if (answer.equals("-1")) {
                        ancVisit.setHealthInfrastructureId(-1);
                        ancVisit.setTypeOfHospital(1013);// 1013 is the Health Infra Type ID for Private Hospital.
                    } else {
                        HealthInfrastructureDetails infra = healthInfrastructureDetailsDao.retrieveById(Integer.valueOf(answer));
                        ancVisit.setHealthInfrastructureId(infra.getId());
                        ancVisit.setTypeOfHospital(infra.getType());
                    }
                }
                break;
            case "43":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setPvtFacilityState(answer);
                }
                break;
            case "6":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setWeight(Float.valueOf(answer));
                }
                break;
            case "7":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHaemoglobinCount(Float.valueOf(answer));
                }
                break;
            case "8":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    String[] arr = answer.split("-");
                    if (arr.length > 1) {
                        ancVisit.setSystolicBp(Integer.valueOf(arr[1].split("\\.")[0]));
                        ancVisit.setDiastolicBp(Integer.valueOf(arr[2].split("\\.")[0]));
                    }
                }
                break;
            case "81":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setMemberHeight(Integer.valueOf(answer.split("\\.")[0]));
                }
                break;
            case "9":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFoetalMovement(answer);
                }
                break;
            case "10":
                ancVisit.setFoetalHeight(Integer.valueOf(answer.split("\\.")[0]));
                break;
            case "11":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFoetalHeartSound(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "12":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFoetalPosition(answer);
                }
                break;
            case "13":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setIfaTabletsGiven(Integer.valueOf(answer.split("\\.")[0]));
                    if (listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.IFA) != null) {
                        int ifaId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.IFA);
                        StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user), ifaId);
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + Integer.parseInt(answer.split("\\.")[0]));
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                }
                break;
            case "14":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFaTabletsGiven(Integer.valueOf(answer.split("\\.")[0]));
                    if (listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.FA) != null) {
                        int faId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.FA);
                        StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user), faId);
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + Integer.parseInt(answer.split("\\.")[0]));
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                }
                break;
            case "15":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setCalciumTabletsGiven(Integer.valueOf(answer.split("\\.")[0]));
                    if (listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.CALCIUM) != null) {
                        int calciumId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.CALCIUM);
                        StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user), calciumId);
                        stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + Integer.parseInt(answer.split("\\.")[0]));
                        stockInventoryDao.update(stockInventoryEntity);
                    }
                }
                break;
            case "16":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHbsagTest(answer);
                }
                break;
            case "17":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setBloodSugarTest(answer);
                }
                break;
            case "18":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    if (keyAndAnswersMap.get("17").equalsIgnoreCase(RchConstants.BLOOD_SUGAR_TEST_EMPTY)) {
                        ancVisit.setSugarTestBeforeFoodValue(Integer.valueOf(answer.split("\\.")[0]));
                    } else if (keyAndAnswersMap.get("17").equalsIgnoreCase(RchConstants.BLOOD_SUGAR_TEST_NON_EMPTY)) {
                        ancVisit.setSugarTestAfterFoodValue(Integer.valueOf(answer.split("\\.")[0]));
                    }
                }
                break;
            case "19":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setUrineTestDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "20":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE) &&
                        keyAndAnswersMap.get("19").equalsIgnoreCase(RchConstants.TRUE)) {
                    ancVisit.setUrineAlbumin(answer);
                }
                break;
            case "201":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE) &&
                        keyAndAnswersMap.get("19").equalsIgnoreCase(RchConstants.TRUE)) {
                    ancVisit.setUrineSugar(answer);
                }
                break;
            case "202":
                //RPR Syphilis test result are stored in this for CHiP implementation
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setVdrlTest(answer);
                }
                break;
            case "203":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHivTest(answer);
                }
                break;
            case "21":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAlbendazoleGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    if (answer.equalsIgnoreCase("1")) {
                        if (listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.ALBENDAZOLE) != null) {
                            int albendazoleId = listValueFieldValueDetailService.retrieveIdOfListValueByConstant(MobileConstantUtil.ALBENDAZOLE);
                            StockInventoryEntity stockInventoryEntity = stockInventoryDao.retrieveByUserIdAndMedicineId(Long.valueOf(user), albendazoleId);
                            stockInventoryEntity.setUsed(stockInventoryEntity.getUsed() + 1);
                            stockInventoryDao.update(stockInventoryEntity);
                        }
                    }
                }
                break;
            case "23":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE) &&
                        !answer.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                    Set<Integer> dangerousSignIdsSet = new HashSet<>();
                    String[] dangerousSignIdsArray = answer.split(",");
                    for (String dangerousSignId : dangerousSignIdsArray) {
                        if (dangerousSignId.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_OTHER)) {
                            ancVisit.setOtherDangerousSign(keyAndAnswersMap.get("92"));
                        } else {
                            dangerousSignIdsSet.add(Integer.valueOf(dangerousSignId));
                        }
                    }
                    ancVisit.setDangerousSignIds(dangerousSignIdsSet);
                }
                break;
            case "9997":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    if (!answer.equalsIgnoreCase(RchConstants.NO_RISK_FOUND)) {
                        ancVisit.setIsHighRiskCase(Boolean.TRUE);
                    } else {
                        ancVisit.setIsHighRiskCase(Boolean.FALSE);
                    }
                }
                break;
            case "24":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE) &&
                        !keyAndAnswersMap.get("23").equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                    switch (answer) {
                        case "1":
                            ancVisit.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                            break;
                        case "2":
                            ancVisit.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                            break;
                        case "3":
                            ancVisit.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                            break;
                        default:
                    }
                }
                break;
            case "25":
                if (ConstantUtil.IMPLEMENTATION_TYPE.equals("chip")) {
                    if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                        ancVisit.setReferralPlace(Integer.valueOf(answer));
                    }
                } else {
                    if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE) &&
                            keyAndAnswersMap.get("24").equalsIgnoreCase("1")) {
                        ancVisit.setReferralPlace(Integer.valueOf(answer));
                    }
                }
                break;
            case "2222":
                if (!answer.trim().isEmpty() && keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty() && keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setReferralFor(answer);
                }
                break;
            case "2501":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setExpectedDeliveryPlace(answer);
                }
                break;
            case "3501":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswersMap.get("2501").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    if (answer.equals("-1")) {
                        ancVisit.setPreferredPlaceInfraId(-1);
                    } else {
                        ancVisit.setPreferredPlaceInfraId(Integer.valueOf(answer));
                    }
                }
                break;
            case "2502":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFamilyPlanningMethod(answer);
                }
                break;
            case "2601":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ancVisit.setDeadFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "2666":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ancVisit.setChildAlive(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;

            case "2602":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ancVisit.setDeathDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "2603":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ancVisit.setPlaceOfDeath(answer);
                }
                break;
            case "2705":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (!answer.isEmpty()) {
                        ancVisit.setOtherDeathPlace(answer);
                    }
                }
                break;
            case "2607":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    ancVisit.setDeathInfrastructureId(Integer.valueOf(answer));
                }
                break;
            case "26":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (answer.equals("OTHER")) {
                        ancVisit.setDeathReason("-1");
                    } else if (!answer.equals("NONE")) {
                        ancVisit.setDeathReason(answer);
                    }
                }
                break;
            case "2605":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH) &&
                        keyAndAnswersMap.get("26").equals("OTHER")) {
                    ancVisit.setOtherDeathReason(answer);
                }
                break;
            case "2801":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_WRONGLY_REGISTERED)) {
                    ancVisit.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "204":
                ancVisit.setSickleCellTest(answer);
                break;
            case "1331":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setCdFourLevel(Integer.valueOf(answer));
                }
                break;
            case "1332":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setViralLoad(Integer.valueOf(answer));
                }
                break;
            case "1333":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    if (!answer.equalsIgnoreCase(RchConstants.PREVIOUS_PREGNANCY_COMPLICATION_NONE)) {
                        ancVisit.setCoinfections(answer);
                    }
                }
                break;
            case "1334":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHivCounsellingDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "1335":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setArtStarted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "1336":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setPartnerTestedPositiveForHiv(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "551":
            case "554":
            case "555":
            case "556":
            case "557":
            case "558":
            case "559":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFpSubMethod(answer);
                }
                break;
            case "553":
            case "574":
            case "578":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFpAlternativeMainMethod(answer);
                }
                break;
            case "571":
            case "572":
            case "575":
            case "576":
            case "579":
            case "580":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFpAlternativeSubMethod(answer);
                }
                break;
            case "2001":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setNoOfPreg(Integer.valueOf(answer));
                }
                break;
            case "2002":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAnyTwin(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "2003":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAnyPrematureBirth(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "8989":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "1521":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setTransportArranged(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "205":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setHepatitisCTest(answer);
                }
                break;
            case "212":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setT3Reading(Float.parseFloat(answer));
                }
                break;
            case "213":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setT4Reading(Float.parseFloat(answer));
                }
                break;
            case "214":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setTshReading(Float.parseFloat(answer));
                }
                break;
            case "215":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setUsgReportDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "216":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setGestationalAgeFromLmp(answer);
                }
                break;
            case "217":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setGestationalAgeFromUsg(Long.parseLong(answer));
                }
                break;
            case "218":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setGestationType(answer);
                }
                break;
            case "219":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAnomalyPresentFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "220":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAnomalyPresent(answer);
                }
                break;
            case "223":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setSingleMultipleGestation(answer);
                }
                break;
            case "206":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setShortnessOfBreath(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "207":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setTwoWeeksCoughing(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "208":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setBloodInSputum(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "209":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setTwoWeeksFever(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "210":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setLossOfWeight(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "211":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setNightSweats(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "322":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setPmmvyBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "333":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setPmsmaBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "344":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setDikariBeneficiary(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "910":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setCordAroundNeck(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "911":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setAmnioticFluidIndex(Short.valueOf(answer));
                }
                break;
            case "120":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setPlacentaPosition(answer);
                }
                break;
            case "121":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setFoetalWeight(Float.valueOf(answer));
                }
                break;
            case "122":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setCervixLength(Short.valueOf(answer));
                }
                break;
            case "5555":
                if (keyAndAnswersMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    ancVisit.setUsgDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            default:
        }
    }

    /**
     * Set answer to new child members entity.
     *
     * @param key          Key.
     * @param answer       Answer for member's new child details.
     * @param memberEntity New child member entity.
     */
    private void setAnswersToNewChildMembers(String key, String answer, MemberEntity memberEntity) {
        switch (key) {
            case "514":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setFirstName(answer);
                }
                break;
            case "516":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setMiddleName(answer);
                }
                break;
            case "517":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setLastName(answer);
                }
                break;
            case "5181":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setGender(answer);
                }
                break;
            case "519":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setDob(new Date(Long.parseLong(answer)));
                }
                break;
            case "3111":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setMemberReligion(answer);
                }

                break;
            case "1402":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSameNrcExists(answer)) {
                        memberEntity.setNrcNumber(answer);
                    }
                }
                break;
            case "1446":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSamePassportExists(answer.toUpperCase(Locale.ROOT))) {
                        memberEntity.setPassportNumber(answer.toUpperCase(Locale.ROOT));
                    }
                }
                break;
            case "1447":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSameBirthCertificateExists(answer)) {
                        memberEntity.setBirthCertificateNumber(answer);
                    }
                }
                break;
            case "1448":
                memberEntity.setEducationStatus(answer != null ? Integer.parseInt(answer) : null);
                break;
            default:
        }

    }

    /**
     * Retrieves keys for new child members.
     *
     * @return Returns keys.
     */
    private List<String> getKeysForNewChildMembers() {
        List<String> keys = new ArrayList<>();
        keys.add("514");
        keys.add("516");
        keys.add("517");
        keys.add("5181");
        keys.add("519");
        keys.add("3111");
        keys.add("1402");
        keys.add("1446");
        keys.add("1448");
        return keys;
    }

    /**
     * Check for high risk in rch anc members.
     *
     * @param ancVisit Anc visit details.
     * @return Returns true/false based on high risk.
     */
    private Boolean identifyHighRiskForRchAnc(AncVisit ancVisit) {
        return (ancVisit.getSystolicBp() != null && ancVisit.getSystolicBp() > 139)
                || (ancVisit.getDiastolicBp() != null && ancVisit.getDiastolicBp() > 89)
                || (ancVisit.getHaemoglobinCount() != null && ancVisit.getHaemoglobinCount() <= 7f)
                || (ancVisit.getWeight() != null && ancVisit.getWeight() < 45f)
                || (ancVisit.getUrineAlbumin() != null && !ancVisit.getUrineAlbumin().equals("0"))
                || (ancVisit.getUrineSugar() != null && !ancVisit.getUrineSugar().equals("0"))
                || ancVisit.getDangerousSignIds() != null
                || ancVisit.getHivTest() != null && ancVisit.getHivTest().equalsIgnoreCase("POSITIVE")
                || ancVisit.getMemberHeight() != null && ancVisit.getMemberHeight() < 145
                || ancVisit.getHbsagTest() != null && ancVisit.getHbsagTest().equalsIgnoreCase("REACTIVE")
                || ancVisit.getVdrlTest() != null && ancVisit.getVdrlTest().equalsIgnoreCase("POSITIVE")
                || ancVisit.getSickleCellTest() != null && ancVisit.getSickleCellTest().equalsIgnoreCase("SICKLE_CELL")
                || ancVisit.getPreviousPregnancyComplication() != null && !ancVisit.getPreviousPregnancyComplication().isEmpty()
                || ancVisit.getOtherDangerousSign() != null
                || ancVisit.getHepatitisCTest() != null && ancVisit.getHepatitisCTest().equalsIgnoreCase("POSITIVE")
                || ancVisit.getTshReading() != null && ancVisit.getTshReading() > 3f
                || ancVisit.getCordAroundNeck() != null && ancVisit.getCordAroundNeck()
                || ancVisit.getSingleMultipleGestation() != null && !ancVisit.getSingleMultipleGestation().equalsIgnoreCase("SINGLE")
                || ancVisit.getCervixLength() != null && ancVisit.getCervixLength() < 2
                || ancVisit.getAmnioticFluidIndex() != null && (ancVisit.getAmnioticFluidIndex() < 8 || ancVisit.getAmnioticFluidIndex() > 20);
    }

    /**
     * Update additional info for anc.
     *
     * @param memberEntity Member details.
     * @param ancVisit     Anc details.
     */
    private void updateMemberAdditionalInfoFromAnc(MemberEntity memberEntity, AncVisit ancVisit, Map<String, String> keyAndAnswerMap) {
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            boolean isUpdate = false;
            MemberAdditionalInfo memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);

            if (ancVisit.getMemberHeight() != null) {
                memberAdditionalInfo.setHeight(ancVisit.getMemberHeight());
                isUpdate = true;
            }

            if (ancVisit.getWeight() != null) {
                memberAdditionalInfo.setWeight(ancVisit.getWeight());
                isUpdate = true;
            }

            if (ancVisit.getHaemoglobinCount() != null) {
                memberAdditionalInfo.setHaemoglobin(ancVisit.getHaemoglobinCount());
                isUpdate = true;
            }

            if (ancVisit.getSystolicBp() != null) {
                memberAdditionalInfo.setSystolicBp(ancVisit.getSystolicBp());
                isUpdate = true;
            }

            if (ancVisit.getDiastolicBp() != null) {
                memberAdditionalInfo.setDiastolicBp(ancVisit.getDiastolicBp());
                isUpdate = true;
            }

            if (ancVisit.getBloodSugarTest() != null) {
                memberAdditionalInfo.setAncBloodSugarTest(ancVisit.getBloodSugarTest());
                isUpdate = true;
            }

            if (ancVisit.getSugarTestAfterFoodValue() != null) {
                memberAdditionalInfo.setSugarTestAfterFoodValue(ancVisit.getSugarTestAfterFoodValue());
                isUpdate = true;
            }

            if (ancVisit.getSugarTestBeforeFoodValue() != null) {
                memberAdditionalInfo.setSugarTestBeforeFoodValue(ancVisit.getSugarTestBeforeFoodValue());
                isUpdate = true;
            }

            if (ancVisit.getHbsagTest() != null) {
                memberAdditionalInfo.setHbsagTest(ancVisit.getHbsagTest());
                isUpdate = true;
            }
            if (ancVisit.getHivTest() != null) {
                memberAdditionalInfo.setHivTest(ancVisit.getHivTest());
                isUpdate = true;
            }

            if (ancVisit.getVdrlTest() != null) {
                memberAdditionalInfo.setVdrlTest(ancVisit.getVdrlTest());
                isUpdate = true;
            }

            if (ancVisit.getSickleCellTest() != null) {
                memberAdditionalInfo.setSickleCellTest(ancVisit.getSickleCellTest());
                isUpdate = true;
            }

            if (ancVisit.getAlbendazoleGiven() != null) {
                memberAdditionalInfo.setAlbendanzoleGiven(ancVisit.getAlbendazoleGiven());
                isUpdate = true;
            }
            if (ancVisit.getMebendazole1Given() != null) {
                memberAdditionalInfo.setMebendazole1Given(ancVisit.getMebendazole1Given());
                isUpdate = true;
            }
            if (ancVisit.getMebendazole1Date() != null) {
                memberAdditionalInfo.setMebendazole1Date(ancVisit.getMebendazole1Date());
                isUpdate = true;
            }
            if (ancVisit.getMebendazole2Given() != null) {
                memberAdditionalInfo.setMebendazole2Given(ancVisit.getMebendazole2Given());
                isUpdate = true;
            }
            if (ancVisit.getMebendazole2Date() != null) {
                memberAdditionalInfo.setMebendazole2Date(ancVisit.getMebendazole2Date());
                isUpdate = true;
            }
            if (ancVisit.getMalariaTest() != null) {
                memberAdditionalInfo.setMalariaTest(ancVisit.getMalariaTest());
                isUpdate = true;
            }
            if (ancVisit.getAppointmentDate() != null) {
                memberAdditionalInfo.setAppointmentDate(ancVisit.getAppointmentDate());
                isUpdate = true;
            }
            if (ancVisit.getHivResultDate() != null) {
                memberAdditionalInfo.setHivResultDate(ancVisit.getHivResultDate());
                isUpdate = true;
            }
            if (ancVisit.getHivStatus() != null) {
                memberAdditionalInfo.setHivStatus(ancVisit.getHivStatus());
                isUpdate = true;
            }
            if (ancVisit.getHivTestResult() != null) {
                memberAdditionalInfo.setHivTestResult(ancVisit.getHivTestResult());
                isUpdate = true;
            }
            if (ancVisit.getOther() != null) {
                memberAdditionalInfo.setOther(ancVisit.getOther());
                isUpdate = true;
            }

            if (ancVisit.getIfaTabletsGiven() != null && ancVisit.getIfaTabletsGiven() > 0) {
                memberAdditionalInfo.setAncIfa(ancVisit.getIfaTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getFaTabletsGiven() != null && ancVisit.getFaTabletsGiven() > 0) {
                memberAdditionalInfo.setAncFa(ancVisit.getFaTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getCalciumTabletsGiven() != null && ancVisit.getCalciumTabletsGiven() > 0) {
                memberAdditionalInfo.setAncCalcium(ancVisit.getCalciumTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getExpectedDeliveryPlace() != null) {
                memberAdditionalInfo.setExpectedDeliveryPlace(ancVisit.getExpectedDeliveryPlace());
                isUpdate = true;
            }

            if (ancVisit.getPreviousPregnancyComplication() != null) {
                memberAdditionalInfo.setPreviousPregnancyComplication(ancVisit.getPreviousPregnancyComplication());
                isUpdate = true;
            }

            if (ancVisit.getServiceDate() != null) {
                memberAdditionalInfo.setLastServiceLongDate(ancVisit.getServiceDate().getTime());
                isUpdate = true;
            }

            if (ancVisit.getHavingBirthPlan() != null) {
                memberAdditionalInfo.setHavingBirthPlan(ancVisit.getHavingBirthPlan());
                isUpdate = true;
            }

            if (keyAndAnswerMap != null && keyAndAnswerMap.containsKey("1623") &&
                    keyAndAnswerMap.get("1623") != null) {
                memberAdditionalInfo.setHivTest(keyAndAnswerMap.get("1623"));
                isUpdate = true;
            }

            if (ancVisit.getPmmvyBeneficiary() != null) {
                memberAdditionalInfo.setPmmvyBeneficiary(ancVisit.getPmmvyBeneficiary());
                isUpdate = true;
            }

            if (ancVisit.getPmsmaBeneficiary() != null) {
                memberAdditionalInfo.setPmsmaBeneficiary(ancVisit.getPmsmaBeneficiary());
                isUpdate = true;
            }

            if (ancVisit.getDikariBeneficiary() != null) {
                memberAdditionalInfo.setDikariBeneficiary(ancVisit.getDikariBeneficiary());
                isUpdate = true;
            }
            if (keyAndAnswerMap != null && keyAndAnswerMap.containsKey("9058")
                    && keyAndAnswerMap.get("9058") != null) {
                memberAdditionalInfo.setMemberRegisteredForAnganwadi(
                        ImtechoUtil.returnTrueFalseFromInitials(keyAndAnswerMap.get("9058"))
                );
                isUpdate = true;
            }

            String highRiskReasonString = getHighRiskReasonString(ancVisit);
            if (highRiskReasonString != null) {
                memberAdditionalInfo.setHighRiskReasons(highRiskReasonString);
                isUpdate = true;
            }

            if (isUpdate) {
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        } else {
            MemberAdditionalInfo memberAdditionalInfo = new MemberAdditionalInfo();
            boolean isUpdate = false;
            if (ancVisit.getMemberHeight() != null) {
                memberAdditionalInfo.setHeight(ancVisit.getMemberHeight());
                isUpdate = true;
            }

            if (ancVisit.getWeight() != null) {
                memberAdditionalInfo.setWeight(ancVisit.getWeight());
                isUpdate = true;
            }

            if (ancVisit.getHaemoglobinCount() != null) {
                memberAdditionalInfo.setHaemoglobin(ancVisit.getHaemoglobinCount());
                isUpdate = true;
            }

            if (ancVisit.getSystolicBp() != null) {
                memberAdditionalInfo.setSystolicBp(ancVisit.getSystolicBp());
                isUpdate = true;
            }

            if (ancVisit.getDiastolicBp() != null) {
                memberAdditionalInfo.setDiastolicBp(ancVisit.getDiastolicBp());
                isUpdate = true;
            }

            if (ancVisit.getBloodSugarTest() != null) {
                memberAdditionalInfo.setAncBloodSugarTest(ancVisit.getBloodSugarTest());
                isUpdate = true;
            }

            if (ancVisit.getSugarTestAfterFoodValue() != null) {
                memberAdditionalInfo.setSugarTestAfterFoodValue(ancVisit.getSugarTestAfterFoodValue());
                isUpdate = true;
            }

            if (ancVisit.getSugarTestBeforeFoodValue() != null) {
                memberAdditionalInfo.setSugarTestBeforeFoodValue(ancVisit.getSugarTestBeforeFoodValue());
                isUpdate = true;
            }

            if (ancVisit.getHbsagTest() != null) {
                memberAdditionalInfo.setHbsagTest(ancVisit.getHbsagTest());
                isUpdate = true;
            }
            if (ancVisit.getHivTest() != null) {
                memberAdditionalInfo.setHivTest(ancVisit.getHivTest());
                isUpdate = true;
            }

            if (ancVisit.getVdrlTest() != null) {
                memberAdditionalInfo.setVdrlTest(ancVisit.getVdrlTest());
                isUpdate = true;
            }

            if (ancVisit.getSickleCellTest() != null) {
                memberAdditionalInfo.setSickleCellTest(ancVisit.getSickleCellTest());
                isUpdate = true;
            }

            if (ancVisit.getAlbendazoleGiven() != null) {
                memberAdditionalInfo.setAlbendanzoleGiven(ancVisit.getAlbendazoleGiven());
                isUpdate = true;
            }

            if (ancVisit.getIfaTabletsGiven() != null && ancVisit.getIfaTabletsGiven() > 0) {
                memberAdditionalInfo.setAncIfa(ancVisit.getIfaTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getFaTabletsGiven() != null && ancVisit.getFaTabletsGiven() > 0) {
                memberAdditionalInfo.setAncFa(ancVisit.getFaTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getCalciumTabletsGiven() != null && ancVisit.getCalciumTabletsGiven() > 0) {
                memberAdditionalInfo.setAncCalcium(ancVisit.getCalciumTabletsGiven());
                isUpdate = true;
            }

            if (ancVisit.getExpectedDeliveryPlace() != null) {
                memberAdditionalInfo.setExpectedDeliveryPlace(ancVisit.getExpectedDeliveryPlace());
                isUpdate = true;
            }

            if (ancVisit.getPreviousPregnancyComplication() != null) {
                memberAdditionalInfo.setPreviousPregnancyComplication(ancVisit.getPreviousPregnancyComplication());
                isUpdate = true;
            }

            if (ancVisit.getHavingBirthPlan() != null) {
                memberAdditionalInfo.setHavingBirthPlan(ancVisit.getHavingBirthPlan());
                isUpdate = true;
            }

            if (ancVisit.getPmmvyBeneficiary() != null) {
                memberAdditionalInfo.setPmmvyBeneficiary(ancVisit.getPmmvyBeneficiary());
                isUpdate = true;
            }

            if (ancVisit.getPmsmaBeneficiary() != null) {
                memberAdditionalInfo.setPmsmaBeneficiary(ancVisit.getPmsmaBeneficiary());
                isUpdate = true;
            }

            if (ancVisit.getDikariBeneficiary() != null) {
                memberAdditionalInfo.setDikariBeneficiary(ancVisit.getDikariBeneficiary());
                isUpdate = true;
            }

            if (ancVisit.getServiceDate() != null) {
                memberAdditionalInfo.setLastServiceLongDate(ancVisit.getServiceDate().getTime());
                isUpdate = true;
            }

            if (keyAndAnswerMap != null && keyAndAnswerMap.containsKey("9058")
                    && keyAndAnswerMap.get("9058") != null) {
                memberAdditionalInfo.setMemberRegisteredForAnganwadi(
                        ImtechoUtil.returnTrueFalseFromInitials(keyAndAnswerMap.get("9058"))
                );
                isUpdate = true;
            }

            String highRiskReasonString = getHighRiskReasonString(ancVisit);
            if (highRiskReasonString != null) {
                memberAdditionalInfo.setHighRiskReasons(highRiskReasonString);
                isUpdate = true;
            }

            if (isUpdate) {
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }
    }

    private String getHighRiskReasonString(AncVisit ancVisit) {
        StringBuilder sb = new StringBuilder();
        if ((ancVisit.getSystolicBp() != null && ancVisit.getSystolicBp() > 139) || (ancVisit.getDiastolicBp() != null && ancVisit.getDiastolicBp() > 89)) {
            sb.append("High Blood Pressure");
        }

        if (ancVisit.getHaemoglobinCount() != null && ancVisit.getHaemoglobinCount() < 7) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Low Haemoglobin");
        }
        if (ancVisit.getMemberHeight() != null && ancVisit.getMemberHeight() < 145) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Low Height");
        }
        if (ancVisit.getWeight() != null && ancVisit.getWeight() < 45f) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Very Low Weight");
        }
        if (ancVisit.getUrineAlbumin() != null && !ancVisit.getUrineAlbumin().equals("0")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Urine Albumin");
        }
        if (ancVisit.getUrineSugar() != null && !ancVisit.getUrineSugar().equals("0")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Urine Sugar");
        }
        if (ancVisit.getDangerousSignIds() != null) {
            for (Integer dSign : ancVisit.getDangerousSignIds()) {
                if (!sb.isEmpty()) {
                    sb.append(",");
                }
                sb.append(listValueFieldValueDetailService.retrieveValueFromId(dSign));
            }
        }
        if (ancVisit.getOtherDangerousSign() != null) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append(ancVisit.getOtherDangerousSign());
        }
        if (ancVisit.getHivTest() != null && ancVisit.getHivTest().equalsIgnoreCase("POSITIVE")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("HIV Positive");
        }
        if (ancVisit.getHbsagTest() != null && ancVisit.getHbsagTest().equalsIgnoreCase("REACTIVE")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("HBsAg Reactive");
        }
        if (ancVisit.getVdrlTest() != null && ancVisit.getVdrlTest().equalsIgnoreCase("POSITIVE")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("VDRL Positive");
        }
        if (ancVisit.getSickleCellTest() != null && ancVisit.getSickleCellTest().equalsIgnoreCase("SICKLE_CELL")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Sickle cell Anemia");
        }
        if (ancVisit.getPreviousPregnancyComplication() != null && !ancVisit.getPreviousPregnancyComplication().isEmpty()) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append(ancVisit.getPreviousPregnancyComplication().toString()
                    .replace("[", "").replace("]", ""));
        }
        if (ancVisit.getHepatitisCTest() != null && ancVisit.getHepatitisCTest().equalsIgnoreCase("POSITIVE")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Hepatitis Positive");
        }
        if (ancVisit.getTshReading() != null && ancVisit.getTshReading() > 3) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Thyroid");
        }
        if (ancVisit.getCordAroundNeck() != null && ancVisit.getCordAroundNeck()) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Cord around neck");
        }
        if (ancVisit.getSingleMultipleGestation() != null && !ancVisit.getSingleMultipleGestation().equalsIgnoreCase("SINGLE")) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Multiple birth");
        }
        if (ancVisit.getCervixLength() != null && ancVisit.getCervixLength() < 2) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Lower cervix length");
        }
        if (ancVisit.getAmnioticFluidIndex() != null && (ancVisit.getAmnioticFluidIndex() < 8
                || ancVisit.getAmnioticFluidIndex() > 20)) {
            if (!sb.isEmpty()) {
                sb.append(",");
            }
            sb.append("Oligohydramnios or Polyhydramnios");
        }
        if (!sb.isEmpty()) {
            return sb.toString();
        }
        return null;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer create(AncMasterDto ancMasterDto) {
        Integer ancServiceId;
        MemberEntity memberEntity = memberDao.retrieveMemberById(ancMasterDto.getMemberId());

        if (memberEntity.getIsPregnantFlag() != null && !memberEntity.getIsPregnantFlag()) {
            throw new ImtechoUserException("Member is not marked as pregnant.", 1);
        }

        if (memberEntity.getCurPregRegDetId() != null) {
            ancMasterDto.setPregnancyRegDetId(memberEntity.getCurPregRegDetId());
        } else {
            throw new ImtechoUserException("Pregnancy Registration Details has not been generated yet.", 1);
        }

        if (ancMasterDto.getLocationId() != null) {
            ancMasterDto.setLocationHierarchyId(locationLevelHierarchyDao.retrieveByLocationId(ancMasterDto.getLocationId()).getId());
        }

        if (!Objects.isNull(ancMasterDto.getTypeOfHospital())) {
            HealthInfrastructureDetails healthInfrastructureDetails = healthInfrastructureDetailsDao.retrieveById(ancMasterDto.getHealthInfrastructureId());
            ancMasterDto.setTypeOfHospital(healthInfrastructureDetails.getType());
        }

        AncVisit ancVisit = AncMapper.convertAncMasterDtoToAncMaster(ancMasterDto);
        ancVisit.setIsHighRiskCase(this.identifyHighRiskForRchAnc(ancVisit));
        ancVisit.setIsFromWeb(Boolean.TRUE);
        ancServiceId = ancVisitDao.create(ancVisit);

        StringBuilder immunisationGiven = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        for (ImmunisationDto immunisationDto : ancMasterDto.getImmunisationDetails()) {
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(ancVisit.getFamilyId(), ancVisit.getMemberId(), MobileConstantUtil.MOTHER_BENEFICIARY,
                    MobileConstantUtil.ANC_VISIT, ancVisit.getId(), null,
                    immunisationDto.getImmunisationGiven().trim(), immunisationDto.getImmunisationDate(), user.getId(),
                    ancVisit.getLocationId(), ancVisit.getLocationHierarchyId(), ancVisit.getPregnancyRegDetId());
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(immunisationDto.getImmunisationGiven().trim());
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(immunisationDto.getImmunisationDate()));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }
        }

        if (immunisationGiven.length() > 1) {
            immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
            if (memberEntity.getImmunisationGiven() != null && !memberEntity.getImmunisationGiven().isEmpty()) {
                String sb = memberEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                memberEntity.setImmunisationGiven(sb.replace(" ", ""));
            } else {
                String immunisation = immunisationGiven.toString().replace(" ", "");
                memberEntity.setImmunisationGiven(immunisation);
            }
        }
        this.updateMemberAdditionalInfoFromAnc(memberEntity, ancVisit, null);
        mobileFhsService.updateMemberDetailsFromRchForms(ancMasterDto.getMobileNumber(), null, null,
                ancMasterDto.getAccountNumber(), ancMasterDto.getIfsc(), memberEntity);
        ancVisitDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_ANC, ancVisit.getId()));
        return ancServiceId;
    }

    @Override
    public List<MemberDto> retrieveAncMembers(Boolean byId, Boolean byMemberId, Boolean byFamilyId, Boolean byMobileNumber, Boolean byName, Boolean byLmp, Boolean byEdd, Boolean byOrganizationUnit, Integer locationId, String searchString, Boolean byFamilyMobileNumber, Integer limit, Integer offSet) {
        return ancVisitDao.retrieveAncMembers(byId, byMemberId, byFamilyId, byMobileNumber, byName, byLmp, byEdd, byOrganizationUnit, locationId, searchString, byFamilyMobileNumber, limit, offSet);
    }

}
