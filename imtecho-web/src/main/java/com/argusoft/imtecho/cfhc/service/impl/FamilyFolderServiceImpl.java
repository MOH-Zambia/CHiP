package com.argusoft.imtecho.cfhc.service.impl;

import com.argusoft.imtecho.cfhc.dao.MemberCFHCDao;
import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import com.argusoft.imtecho.cfhc.service.FamilyFolderService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyAvailabilityDetailDao;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyAvailabilityDetail;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.query.service.QueryMasterService;
import com.argusoft.imtecho.rch.dto.AshaReportedEventDataBean;
import com.argusoft.imtecho.rch.service.impl.AshaReportedEventServiceImpl;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.text.SimpleDateFormat;
import java.util.*;

import static com.argusoft.imtecho.fhs.service.impl.FamilyHealthSurveyServiceImpl.*;

/**
 * Defines methods for FamilyFolderServiceImpl
 *
 * @author prateek
 * @since 26/05/23 6:32 pm
 */
@Service
@Transactional
public class FamilyFolderServiceImpl implements FamilyFolderService {

    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private MemberCFHCDao memberCFHCDao;
    @Autowired
    private LocationMasterDao locationMasterDao;
    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;
    @Autowired
    private QueryMasterService queryMasterService;
    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;
    @Autowired
    private FamilyAvailabilityDetailDao familyAvailabilityDao;
    @Autowired
    private MobileUtilService mobileUtilService;
    @Autowired
    private AshaReportedEventServiceImpl ashaReportedEventService;


    private List<String> getKeysForFamilyQuestions() {
        List<String> keys = new ArrayList<>();
        keys.add("4");      //Comments for reverification
        keys.add("10");          //Family Number
        keys.add("11");          //Head of the family
        keys.add("13");          //Is the family available?
        keys.add("20");          //House Number
        keys.add("21");          //Address Line 1
        keys.add("22");          //Address Line 2
        keys.add("24");         //Select area of village
        keys.add("30");         //Family Religion
        keys.add("31");         //Family Caste
        keys.add("40");         // Type of house
        keys.add("410");         // other type of house
        keys.add("41");          // Owner of house
        keys.add("42");          // Availability of toilet
        keys.add("420");          // Availability of other toilet
        keys.add("43");          // Source of drinking water
        keys.add("430");          // Other Source of drinking water
        keys.add("44");           // Electricity availability
        keys.add("45");         // Vehicle Details
        keys.add("48");         // Other Vehicle Details
        keys.add("46");          // Type of fuel
        keys.add("50");         //Does family have ration card
        keys.add("51");         //Color of ration card
        keys.add("52");         //PMJAY or Health Insurance
        keys.add("53");         //Any Member travelled to foreign
        keys.add("60");         //Residence Status
        keys.add("61");         //Native State


        keys.add("59");         //Please select mother for these members
        keys.add("60");         //Please select husband for these members
        keys.add("9997");       //Do you want to submit or review the data?
        keys.add("9999");       //Family Folder form is complete.
        keys.add("-3");         //Location ID
        keys.add("-8");         //Mobile Start Date
        keys.add("-9");         //Mobile End Date
        keys.add("-1");         //Longitude
        keys.add("-2");         //Latitude
        keys.add("-10");        //Family Availability ID
        return keys;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, String> storeFamilyFolderForm(ParsedRecordBean parsedRecordBean, UserMaster user) {
        Map<String, String> returnMap = new LinkedHashMap<>();
        List<String> keysForFamilyQuestions = this.getKeysForFamilyQuestions();

        Map<String, String> keyAndAnswerMap = new LinkedHashMap<>();
        Map<String, String> familyKeyAndAnswerMap = new LinkedHashMap<>();
        Map<String, String> memberKeyAndAnswerMap = new LinkedHashMap<>();

        Map<String, String> memberAbhaConsentMap = new LinkedHashMap<>();

        boolean isNewFamily = false;
        String familyId;
        String recordString = parsedRecordBean.getAnswerRecord();
        String[] keyAndAnswerSet = recordString.split(MobileConstantUtil.ANSWER_STRING_FIRST_SEPARATER);
        List<String> keyAndAnswerSetList = new ArrayList<>(Arrays.asList(keyAndAnswerSet));
        Set<MemberEntity> membersToBeArchived = new HashSet<>();
        Set<MemberEntity> membersToBeMarkedDead = new HashSet<>();
        MemberEntity maleHofMember = null;
        MemberEntity femaleHofMember = null;
        MemberEntity hofHusbandOrWifeMember = null;

        for (String aKeyAndAnswer : keyAndAnswerSetList) {
            String[] keyAnswerSplit = aKeyAndAnswer.split(MobileConstantUtil.ANSWER_STRING_SECOND_SEPARATER);
            if (keyAnswerSplit.length != 2) {
                continue;
            }
            keyAndAnswerMap.put(keyAnswerSplit[0], keyAnswerSplit[1]);
        }

        //If Family Availability - Temporary Locked or permanently Locked
        if (keyAndAnswerMap.get("25") != null && !keyAndAnswerMap.get("25").equalsIgnoreCase("OPEN")) {
            FamilyAvailabilityDetail familyAvailabilityDetail;
            if (keyAndAnswerMap.containsKey("-10") && !keyAndAnswerMap.get("-10").equals("null")) {
                familyAvailabilityDetail = familyAvailabilityDao.retrieveById(Integer.parseInt(keyAndAnswerMap.get("-10")));
            } else {
                familyAvailabilityDetail = new FamilyAvailabilityDetail();
            }

            familyAvailabilityDetail.setUserId(user.getId());
            familyAvailabilityDetail.setHouseNumber(keyAndAnswerMap.get("20"));
            familyAvailabilityDetail.setAddress1(keyAndAnswerMap.get("21"));
            familyAvailabilityDetail.setAddress2(keyAndAnswerMap.get("22"));
            familyAvailabilityDetail.setAvailabilityStatus(keyAndAnswerMap.get("25"));
            if (keyAndAnswerMap.containsKey("-3")) {
                familyAvailabilityDetail.setLocationId(Integer.parseInt(keyAndAnswerMap.get("-3")));
            }
            familyAvailabilityDao.createOrUpdate(familyAvailabilityDetail);

            StringBuilder message = new StringBuilder();
            if (keyAndAnswerMap.get("25").equalsIgnoreCase("TEMP_LOCKED")) {
                message.append("Temporarily Locked Family");
            } else if (keyAndAnswerMap.get("25").equalsIgnoreCase("PERM_LOCKED")) {
                message.append("Permanently Locked Family");
            }
            returnMap.put("familyId", message.toString());
            returnMap.put("createdInstanceId", familyAvailabilityDetail.getId().toString());
            return returnMap;
        }

        familyId = keyAndAnswerMap.get("10");

        FamilyEntity familyEntity;
        if (familyId == null || familyId.equals("Not available")) {
            familyEntity = new FamilyEntity();
        } else {
            familyEntity = familyDao.retrieveFamilyByFamilyId(familyId);
        }

        //The family is not available
        if (familyEntity.getId() != null && keyAndAnswerMap.containsKey("13") && keyAndAnswerMap.get("13").equals("2")) {
            returnMap.put("createdInstanceId", familyEntity.getId().toString());
            return returnMap;
        }

        if (familyEntity.getId() != null && keyAndAnswerMap.containsKey("13") && keyAndAnswerMap.get("13").equals("3")) {
            //Archive this family
            familyEntity.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_ARCHIVED);
            familyDao.updateFamily(familyEntity);
            returnMap.put("familyId", familyEntity.getFamilyId());
            returnMap.put("createdInstanceId", familyEntity.getId().toString());
            return returnMap;
        }

        List<MemberEntity> membersInTheFamily = memberDao.retrieveMemberEntitiesByFamilyId(familyEntity.getFamilyId());
        List<MemberCFHCEntity> memberCFHCEntities = memberCFHCDao.retrieveMemberCFHCEntitiesByFamilyId(familyEntity.getId());
        Map<String, MemberEntity> mapOfMemberWithHealthIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfNewMemberWithLoopIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfMemberWithLoopIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfDeadMemberWithLoopIsAsKey = new LinkedHashMap<>();

        Map<Integer, MemberCFHCEntity> mapOfMemberCFHCWithMemberIdAsKey = new LinkedHashMap<>();
        Map<String, MemberCFHCEntity> mapOfNewMemberCFHCWithLoopIdAsKey = new LinkedHashMap<>();

        String motherChildRelationString = keyAndAnswerMap.get("1011");
        String husbandWifeRelationString = keyAndAnswerMap.get("1013");


        for (MemberEntity memberEntity : membersInTheFamily) {
            mapOfMemberWithHealthIdAsKey.put(memberEntity.getUniqueHealthId(), memberEntity);
        }

        for (MemberCFHCEntity memberCFHCEntity : memberCFHCEntities) {
            mapOfMemberCFHCWithMemberIdAsKey.put(memberCFHCEntity.getMemberId(), memberCFHCEntity);
        }

        if (familyEntity.getFamilyId() == null) {
            familyEntity.setFamilyId(familyHealthSurveyService.generateFamilyId());
            isNewFamily = true;
        }

        for (Map.Entry<String, String> keyAnswerSet : keyAndAnswerMap.entrySet()) {
            String key = keyAnswerSet.getKey();
            String answer = keyAnswerSet.getValue();
            if (keysForFamilyQuestions.contains(key)) {
                familyKeyAndAnswerMap.put(key, answer);
            } else {
                memberKeyAndAnswerMap.put(key, answer);
            }
        }

        for (Map.Entry<String, String> entrySet : familyKeyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToFamilyEntity(key, answer, familyEntity);
        }

        String longitude = keyAndAnswerMap.get("-1");
        String latitude = keyAndAnswerMap.get("-2");
        familyEntity.setLongitude(longitude);
        familyEntity.setLatitude(latitude);

        if (familyEntity.getLocationId() == null) {
            if (familyEntity.getAreaId() != null) {
                familyEntity.setLocationId(locationMasterDao.retrieveById(familyEntity.getAreaId()).getParent());
            } else {
                throw new ImtechoMobileException("Please refresh and try again", 1);
            }
        }

        for (Map.Entry<String, String> entrySet : memberKeyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            MemberEntity memberEntity;
            MemberCFHCEntity memberCFHCEntity;

            if (key.contains(".")) {
                String[] splitKey = key.split("\\.");
                String uniqueHealthId = memberKeyAndAnswerMap.get("110" + "." + splitKey[1]);
                memberEntity = mapOfMemberWithHealthIdAsKey.get(uniqueHealthId);

                if (uniqueHealthId != null && memberEntity == null) {
                    continue;
                }

                if (memberEntity == null) {
                    memberEntity = mapOfNewMemberWithLoopIdAsKey.get(splitKey[1]);
                    memberCFHCEntity = mapOfNewMemberCFHCWithLoopIdAsKey.get(splitKey[1]);
                    if (memberEntity == null) {
                        memberEntity = new MemberEntity();
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberEntity.setFamilyId(familyEntity.getFamilyId());
                        memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                        mapOfNewMemberWithLoopIdAsKey.put(splitKey[1], memberEntity);
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfNewMemberCFHCWithLoopIdAsKey.put(splitKey[1], memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                } else {
                    memberCFHCEntity = mapOfMemberCFHCWithMemberIdAsKey.get(memberEntity.getId());
                    memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    if (memberCFHCEntity == null) {
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfMemberCFHCWithMemberIdAsKey.put(memberEntity.getId(), memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                }

                mapOfMemberWithLoopIdAsKey.putIfAbsent(splitKey[1], memberEntity);

                if (memberKeyAndAnswerMap.get("120" + "." + splitKey[1]) != null && memberKeyAndAnswerMap.get("120" + "." + splitKey[1]).equals("2")) {
                    membersToBeMarkedDead.add(memberEntity);
                    mapOfDeadMemberWithLoopIsAsKey.put(splitKey[1], memberEntity);
                } else {
                    this.setAnswersToMemberEntity(splitKey[0], answer, memberEntity, memberCFHCEntity, memberKeyAndAnswerMap, splitKey[1], memberAbhaConsentMap);
                }

                if (memberKeyAndAnswerMap.get("132" + "." + splitKey[1]) != null && memberKeyAndAnswerMap.get("132" + "." + splitKey[1]).equals("1")) {
                    if (memberKeyAndAnswerMap.get("143" + "." + splitKey[1]) != null && memberKeyAndAnswerMap.get("143" + "." + splitKey[1]).equals("1")) {
                        maleHofMember = memberEntity;
                    } else if (memberKeyAndAnswerMap.get("143" + "." + splitKey[1]) != null && memberKeyAndAnswerMap.get("143" + "." + splitKey[1]).equals("2")) {
                        femaleHofMember = memberEntity;
                    }
                }
                if (memberKeyAndAnswerMap.get("133" + "." + splitKey[1]) != null &&
                        (memberKeyAndAnswerMap.get("133" + "." + splitKey[1]).equals("WIFE")
                                || memberKeyAndAnswerMap.get("133" + "." + splitKey[1]).equals("HUSBAND"))) {
                    hofHusbandOrWifeMember = memberEntity;
                }
            } else {
                String uniqueHealthId = memberKeyAndAnswerMap.get("110");
                memberEntity = mapOfMemberWithHealthIdAsKey.get(uniqueHealthId);

                if (uniqueHealthId != null && memberEntity == null) {
                    continue;
                }

                if (memberEntity == null) {
                    memberEntity = mapOfNewMemberWithLoopIdAsKey.get("0");
                    memberCFHCEntity = mapOfNewMemberCFHCWithLoopIdAsKey.get("0");
                    if (memberEntity == null) {
                        memberEntity = new MemberEntity();
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberEntity.setFamilyId(familyEntity.getFamilyId());
                        memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                        mapOfNewMemberWithLoopIdAsKey.put("0", memberEntity);
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfNewMemberCFHCWithLoopIdAsKey.put("0", memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                } else {
                    memberCFHCEntity = mapOfMemberCFHCWithMemberIdAsKey.get(memberEntity.getId());
                    memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    if (memberCFHCEntity == null) {
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfMemberCFHCWithMemberIdAsKey.put(memberEntity.getId(), memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                }

                mapOfMemberWithLoopIdAsKey.putIfAbsent("0", memberEntity);

                if ((memberKeyAndAnswerMap.get("120") != null && memberKeyAndAnswerMap.get("120").equals("2"))) {
                    membersToBeMarkedDead.add(memberEntity);
                    mapOfDeadMemberWithLoopIsAsKey.put("0", memberEntity);
                } else {
                    this.setAnswersToMemberEntity(key, answer, memberEntity, memberCFHCEntity, memberKeyAndAnswerMap, null, memberAbhaConsentMap);
                }

                if (memberKeyAndAnswerMap.get("132") != null && memberKeyAndAnswerMap.get("132").equals("1")) {
                    if (memberKeyAndAnswerMap.get("143") != null && memberKeyAndAnswerMap.get("143").equals("1")) {
                        maleHofMember = memberEntity;
                    } else if (memberKeyAndAnswerMap.get("143") != null && memberKeyAndAnswerMap.get("143").equals("2")) {
                        femaleHofMember = memberEntity;
                    }
                }
                if (memberKeyAndAnswerMap.get("133") != null &&
                        (memberKeyAndAnswerMap.get("133").equals("WIFE")
                                || memberKeyAndAnswerMap.get("133").equals("HUSBAND"))) {
                    hofHusbandOrWifeMember = memberEntity;
                }
            }
        }

        Set<MemberEntity> membersToBeAdded = new HashSet<>(mapOfNewMemberWithLoopIdAsKey.values());
        Set<MemberEntity> membersToBeUpdated = new HashSet<>(mapOfMemberWithLoopIdAsKey.values());
        membersToBeUpdated.removeAll(membersToBeMarkedDead);
        membersToBeUpdated.removeAll(membersToBeAdded);

        if (familyEntity.getId() != null) {
            familyEntity.setModifiedBy(user.getId());
            familyEntity.setModifiedOn(new Date());
        }

        Map<Integer, String> failedOfflineAbhaMessageMap = new HashMap<>();

        if ("ASHA".equalsIgnoreCase(user.getRole().getCode())) {
            familyHealthSurveyService.persistFamilyCFHC(parsedRecordBean.getChecksum(), familyEntity, membersToBeAdded, membersToBeArchived, membersToBeUpdated,
                    String.valueOf(user.getId()), Collections.emptySet(), mapOfMemberWithLoopIdAsKey,
                    motherChildRelationString, husbandWifeRelationString, failedOfflineAbhaMessageMap);

            for (AshaReportedEventDataBean death : getDeathsReportedByAsha(membersToBeMarkedDead, familyEntity)) {
                ashaReportedEventService.storeAshaReportedEvent(null, death, user);
            }
        } else {
            familyHealthSurveyService.persistFamilyCFHC(parsedRecordBean.getChecksum(), familyEntity,
                    membersToBeAdded, membersToBeArchived, membersToBeUpdated,
                    String.valueOf(user.getId()), membersToBeMarkedDead, mapOfMemberWithLoopIdAsKey,
                    motherChildRelationString, husbandWifeRelationString, failedOfflineAbhaMessageMap);

            for (Map.Entry<String, MemberEntity> entry : mapOfDeadMemberWithLoopIsAsKey.entrySet()) {
                String key = entry.getKey();
                MemberEntity memberEntity = entry.getValue();
                Boolean abBoolean = memberDao.checkIfMemberAlreadyMarkedDead(memberEntity.getId());
                if (Boolean.TRUE.equals(abBoolean)) {
                    throw new ImtechoMobileException("Member with Health ID " + memberEntity.getUniqueHealthId() + " is already marked DEAD. "
                            + "You cannot mark a DEAD member DEAD again.", 1);
                } else {
                    memberDao.deleteDiseaseRelationsOfMember(memberEntity.getId());
                    memberEntity.setModifiedBy(user.getId());
                    memberEntity.setModifiedOn(new Date());
                    memberEntity.setFamilyHeadFlag(Boolean.FALSE);
                    familyHealthSurveyService.updateMember(memberEntity, memberEntity.getState(), FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_DEAD);
                    memberDao.flush();
                    markMemberAsDeath(memberEntity, familyEntity, memberKeyAndAnswerMap, key, user);
                }
            }
        }

        if (keyAndAnswerMap.containsKey("-10") && !keyAndAnswerMap.get("-10").equals("null")) {
            FamilyAvailabilityDetail familyAvailability = familyAvailabilityDao.retrieveById(Integer.parseInt(keyAndAnswerMap.get("-10")));
            familyAvailability.setFamilyId(familyEntity.getId());
            familyAvailabilityDao.update(familyAvailability);
        }

        if (femaleHofMember != null && hofHusbandOrWifeMember != null) {
            femaleHofMember.setHusbandId(hofHusbandOrWifeMember.getId());
            memberDao.update(femaleHofMember);
        }

        if (maleHofMember != null && hofHusbandOrWifeMember != null) {
            hofHusbandOrWifeMember.setHusbandId(maleHofMember.getId());
            memberDao.update(maleHofMember);
        }
        memberDao.flush();

        returnMap.put("createdInstanceId", familyEntity.getId().toString());

        if (isNewFamily) {
            newFamilyMsg(familyEntity, mapOfMemberWithLoopIdAsKey, returnMap, failedOfflineAbhaMessageMap, parsedRecordBean);
        }
        return returnMap;
    }

    public Map<String, String> storeFamilyFolderForm2(ParsedRecordBean parsedRecordBean, UserMaster user) {
        Map<String, String> returnMap = new LinkedHashMap<>();
        List<String> keysForFamilyQuestions = this.getKeysForFamilyQuestions();

        Map<String, String> keyAndAnswerMap = new LinkedHashMap<>();
        Map<String, String> familyKeyAndAnswerMap = new LinkedHashMap<>();
        Map<String, String> memberKeyAndAnswerMap = new LinkedHashMap<>();

        Map<String, String> memberAbhaConsentMap = new LinkedHashMap<>();

        boolean isNewFamily = false;
        String familyId;
        String recordString = parsedRecordBean.getAnswerRecord();
        String[] keyAndAnswerSet = recordString.split(MobileConstantUtil.ANSWER_STRING_FIRST_SEPARATER);
        List<String> keyAndAnswerSetList = new ArrayList<>(Arrays.asList(keyAndAnswerSet));
        Set<MemberEntity> membersToBeArchived = new HashSet<>();
        Set<MemberEntity> membersToBeMarkedDead = new HashSet<>();

        for (String aKeyAndAnswer : keyAndAnswerSetList) {
            String[] keyAnswerSplit = aKeyAndAnswer.split(MobileConstantUtil.ANSWER_STRING_SECOND_SEPARATER);
            if (keyAnswerSplit.length != 2) {
                continue;
            }
            keyAndAnswerMap.put(keyAnswerSplit[0], keyAnswerSplit[1]);
        }


        familyId = keyAndAnswerMap.get("10");

        FamilyEntity familyEntity;
        if (familyId == null || familyId.equals("Not available")) {
            familyEntity = new FamilyEntity();
        } else {
            familyEntity = familyDao.retrieveFamilyByFamilyId(familyId);
        }

        //The family is not available
        if (familyEntity.getId() != null && keyAndAnswerMap.containsKey("13") && keyAndAnswerMap.get("13").equals("2")) {
            returnMap.put("createdInstanceId", familyEntity.getId().toString());
            return returnMap;
        }

        if (familyEntity.getId() != null && keyAndAnswerMap.containsKey("13") && keyAndAnswerMap.get("13").equals("3")) {
            //Archive this family
            familyEntity.setState(FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_ARCHIVED);
            familyDao.updateFamily(familyEntity);
            returnMap.put("familyId", familyEntity.getFamilyId());
            returnMap.put("createdInstanceId", familyEntity.getId().toString());
            return returnMap;
        }

        List<MemberEntity> membersInTheFamily = memberDao.retrieveMemberEntitiesByFamilyId(familyEntity.getFamilyId());
        List<MemberCFHCEntity> memberCFHCEntities = memberCFHCDao.retrieveMemberCFHCEntitiesByFamilyId(familyEntity.getId());
        Map<String, MemberEntity> mapOfMemberWithHealthIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfNewMemberWithLoopIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfMemberWithLoopIdAsKey = new LinkedHashMap<>();
        Map<String, MemberEntity> mapOfDeadMemberWithLoopIsAsKey = new LinkedHashMap<>();

        Map<Integer, MemberCFHCEntity> mapOfMemberCFHCWithMemberIdAsKey = new LinkedHashMap<>();
        Map<String, MemberCFHCEntity> mapOfNewMemberCFHCWithLoopIdAsKey = new LinkedHashMap<>();

        String motherChildRelationString = keyAndAnswerMap.get("1011");
        String husbandWifeRelationString = keyAndAnswerMap.get("1013");


        for (MemberEntity memberEntity : membersInTheFamily) {
            mapOfMemberWithHealthIdAsKey.put(memberEntity.getUniqueHealthId(), memberEntity);
        }

        for (MemberCFHCEntity memberCFHCEntity : memberCFHCEntities) {
            mapOfMemberCFHCWithMemberIdAsKey.put(memberCFHCEntity.getMemberId(), memberCFHCEntity);
        }

        if (familyEntity.getFamilyId() == null) {
            familyEntity.setFamilyId(familyHealthSurveyService.generateFamilyId());
            isNewFamily = true;
        }

        for (Map.Entry<String, String> keyAnswerSet : keyAndAnswerMap.entrySet()) {
            String key = keyAnswerSet.getKey();
            String answer = keyAnswerSet.getValue();
            if (keysForFamilyQuestions.contains(key)) {
                familyKeyAndAnswerMap.put(key, answer);
            } else {
                memberKeyAndAnswerMap.put(key, answer);
            }
        }

        for (Map.Entry<String, String> entrySet : familyKeyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToFamilyEntity2(key, answer, familyEntity);
        }

        String longitude = keyAndAnswerMap.get("-1");
        String latitude = keyAndAnswerMap.get("-2");
        familyEntity.setLongitude(longitude);
        familyEntity.setLatitude(latitude);

        if (familyEntity.getLocationId() == null) {
            if (familyEntity.getAreaId() != null) {
                familyEntity.setLocationId(locationMasterDao.retrieveById(familyEntity.getAreaId()).getParent());
            } else {
                throw new ImtechoMobileException("Please refresh and try again", 1);
            }
        }

        for (Map.Entry<String, String> entrySet : memberKeyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            MemberEntity memberEntity;
            MemberCFHCEntity memberCFHCEntity;

            if (key.contains(".")) {
                String[] splitKey = key.split("\\.");
                String uniqueHealthId = memberKeyAndAnswerMap.get("110" + "." + splitKey[1]);
                memberEntity = mapOfMemberWithHealthIdAsKey.get(uniqueHealthId);

                if (uniqueHealthId != null && memberEntity == null) {
                    continue;
                }

                if (memberEntity == null) {
                    memberEntity = mapOfNewMemberWithLoopIdAsKey.get(splitKey[1]);
                    memberCFHCEntity = mapOfNewMemberCFHCWithLoopIdAsKey.get(splitKey[1]);
                    if (memberEntity == null) {
                        memberEntity = new MemberEntity();
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberEntity.setFamilyId(familyEntity.getFamilyId());
                        memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                        mapOfNewMemberWithLoopIdAsKey.put(splitKey[1], memberEntity);
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfNewMemberCFHCWithLoopIdAsKey.put(splitKey[1], memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                } else {
                    memberCFHCEntity = mapOfMemberCFHCWithMemberIdAsKey.get(memberEntity.getId());
                    memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    if (memberCFHCEntity == null) {
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfMemberCFHCWithMemberIdAsKey.put(memberEntity.getId(), memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                }

                mapOfMemberWithLoopIdAsKey.putIfAbsent(splitKey[1], memberEntity);

                if (memberKeyAndAnswerMap.get("120" + "." + splitKey[1]) != null && memberKeyAndAnswerMap.get("120" + "." + splitKey[1]).equals("2")) {
                    membersToBeMarkedDead.add(memberEntity);
                    mapOfDeadMemberWithLoopIsAsKey.put(splitKey[1], memberEntity);
                } else {
                    this.setAnswersToMemberEntity2(splitKey[0], answer, memberEntity, memberCFHCEntity, memberKeyAndAnswerMap, splitKey[1], memberAbhaConsentMap);
                }
            } else {
                String uniqueHealthId = memberKeyAndAnswerMap.get("110");
                memberEntity = mapOfMemberWithHealthIdAsKey.get(uniqueHealthId);

                if (uniqueHealthId != null && memberEntity == null) {
                    continue;
                }

                if (memberEntity == null) {
                    memberEntity = mapOfNewMemberWithLoopIdAsKey.get("0");
                    memberCFHCEntity = mapOfNewMemberCFHCWithLoopIdAsKey.get("0");
                    if (memberEntity == null) {
                        memberEntity = new MemberEntity();
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberEntity.setFamilyId(familyEntity.getFamilyId());
                        memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                        mapOfNewMemberWithLoopIdAsKey.put("0", memberEntity);
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfNewMemberCFHCWithLoopIdAsKey.put("0", memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                } else {
                    memberCFHCEntity = mapOfMemberCFHCWithMemberIdAsKey.get(memberEntity.getId());
                    memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    if (memberCFHCEntity == null) {
                        memberCFHCEntity = new MemberCFHCEntity();
                        memberCFHCEntity.setMemberId(memberEntity.getId());
                        mapOfMemberCFHCWithMemberIdAsKey.put(memberEntity.getId(), memberCFHCEntity);
                        memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                    }
                }

                mapOfMemberWithLoopIdAsKey.putIfAbsent("0", memberEntity);

                if ((memberKeyAndAnswerMap.get("120") != null && memberKeyAndAnswerMap.get("120").equals("2"))) {
                    membersToBeMarkedDead.add(memberEntity);
                    mapOfDeadMemberWithLoopIsAsKey.put("0", memberEntity);
                } else {
                    this.setAnswersToMemberEntity2(key, answer, memberEntity, memberCFHCEntity, memberKeyAndAnswerMap, null, memberAbhaConsentMap);
                }
            }
        }

        Set<MemberEntity> membersToBeAdded = new HashSet<>(mapOfNewMemberWithLoopIdAsKey.values());
        Set<MemberEntity> membersToBeUpdated = new HashSet<>(mapOfMemberWithLoopIdAsKey.values());
        membersToBeUpdated.removeAll(membersToBeMarkedDead);
        membersToBeUpdated.removeAll(membersToBeAdded);

        if (familyEntity.getId() != null) {
            familyEntity.setModifiedBy(user.getId());
            familyEntity.setModifiedOn(new Date());
        }

        Map<Integer, String> failedOfflineAbhaMessageMap = new HashMap<>();

        if ("ASHA".equalsIgnoreCase(user.getRole().getCode())) {
            familyHealthSurveyService.persistFamilyCFHC(parsedRecordBean.getChecksum(), familyEntity, membersToBeAdded, membersToBeArchived, membersToBeUpdated,
                    String.valueOf(user.getId()), Collections.emptySet(), mapOfMemberWithLoopIdAsKey,
                    motherChildRelationString, husbandWifeRelationString, failedOfflineAbhaMessageMap);

            for (AshaReportedEventDataBean death : getDeathsReportedByAsha(membersToBeMarkedDead, familyEntity)) {
                ashaReportedEventService.storeAshaReportedEvent(null, death, user);
            }
        } else {
            familyHealthSurveyService.persistFamilyCFHC(parsedRecordBean.getChecksum(), familyEntity,
                    membersToBeAdded, membersToBeArchived, membersToBeUpdated,
                    String.valueOf(user.getId()), membersToBeMarkedDead, mapOfMemberWithLoopIdAsKey,
                    motherChildRelationString, husbandWifeRelationString, failedOfflineAbhaMessageMap);

            for (Map.Entry<String, MemberEntity> entry : mapOfDeadMemberWithLoopIsAsKey.entrySet()) {
                String key = entry.getKey();
                MemberEntity memberEntity = entry.getValue();
                Boolean abBoolean = memberDao.checkIfMemberAlreadyMarkedDead(memberEntity.getId());
                if (Boolean.TRUE.equals(abBoolean)) {
                    throw new ImtechoMobileException("Member with Health ID " + memberEntity.getUniqueHealthId() + " is already marked DEAD. "
                            + "You cannot mark a DEAD member DEAD again.", 1);
                } else {
                    memberDao.deleteDiseaseRelationsOfMember(memberEntity.getId());
                    memberEntity.setModifiedBy(user.getId());
                    memberEntity.setModifiedOn(new Date());
                    memberEntity.setFamilyHeadFlag(Boolean.FALSE);
                    familyHealthSurveyService.updateMember(memberEntity, memberEntity.getState(), FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_DEAD);
                    memberDao.flush();
                    markMemberAsDeath(memberEntity, familyEntity, memberKeyAndAnswerMap, key, user);
                }
            }
        }

        if (keyAndAnswerMap.containsKey("-10") && !keyAndAnswerMap.get("-10").equals("null")) {
            FamilyAvailabilityDetail familyAvailability = familyAvailabilityDao.retrieveById(Integer.parseInt(keyAndAnswerMap.get("-10")));
            familyAvailability.setFamilyId(familyEntity.getId());
            familyAvailabilityDao.update(familyAvailability);
        }

        returnMap.put("createdInstanceId", familyEntity.getId().toString());

        if (isNewFamily) {
            newFamilyMsg(familyEntity, mapOfMemberWithLoopIdAsKey, returnMap, failedOfflineAbhaMessageMap, parsedRecordBean);
        }
        return returnMap;
    }

    private static List<AshaReportedEventDataBean> getDeathsReportedByAsha(Set<MemberEntity> membersToBeMarkedDead, FamilyEntity familyEntity) {
        List<AshaReportedEventDataBean> deathsReported = new ArrayList<>();
        for (MemberEntity member : membersToBeMarkedDead) {
            AshaReportedEventDataBean reportDeath = new AshaReportedEventDataBean();
            reportDeath.setEventType(MobileConstantUtil.ASHA_REPORT_MEMBER_DEATH);
            reportDeath.setFamilyId(familyEntity.getId());
            reportDeath.setMemberId(member.getId());
            reportDeath.setReportedOn(new Date().getTime());
            reportDeath.setLocationId(familyEntity.getLocationId());
            deathsReported.add(reportDeath);
        }
        return deathsReported;
    }

    @Override
    public Map<String, String> familyFolderMemberUpdateForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswersMap, UserMaster user) {
        Map<String, String> returnMap = new LinkedHashMap<>();
        returnMap.put("createdInstanceId", "1");
        String uniqueHealthId = keyAndAnswersMap.get("110");
        String familyId = keyAndAnswersMap.get("10");
        Map<String, String> memberAbhaConsentMap = new LinkedHashMap<>();

        FamilyEntity familyEntity = null;
        if (familyId != null) {
            familyEntity = familyDao.retrieveFamilyByFamilyId(familyId);
        }
        Map<Integer, String> failedAbhaCreationMessageMap = new HashMap<>();
        MemberEntity memberEntity;
        MemberCFHCEntity memberCFHCEntity;
        if (uniqueHealthId != null) {
            memberEntity = memberDao.getMemberByUniqueHealthIdAndFamilyId(uniqueHealthId, null);
            memberCFHCEntity = memberCFHCDao.retrieveMemberCFHCEntitiesByMemberId(memberEntity.getId());
            if (keyAndAnswersMap.get("120") != null && (keyAndAnswersMap.get("120").equals("2"))) {
                Boolean abBoolean = memberDao.checkIfMemberAlreadyMarkedDead(memberEntity.getId());
                if (abBoolean != null && abBoolean) {
                    throw new ImtechoMobileException("Member with Health ID " + memberEntity.getUniqueHealthId() + " is already marked DEAD. "
                            + "You cannot mark a DEAD member DEAD again.", 1);
                } else {
                    long dateOfDeath = Long.parseLong(keyAndAnswersMap.get("501"));
                    SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
                    String deathPlace = keyAndAnswersMap.get("502");
                    String deathReason = keyAndAnswersMap.get("510");
                    String otherDeathreason = keyAndAnswersMap.get("513");
                    QueryDto queryDto = new QueryDto();
                    queryDto.setCode(CODE_FOR_DEATH);
                    LinkedHashMap<String, Object> parameters = new LinkedHashMap<>();
                    parameters.put(MEMBER_ID, memberEntity.getId());
                    if (familyEntity.getAreaId() != null) {
                        parameters.put(LOCATION_ID, familyEntity.getAreaId());
                        parameters.put(LOCATION_HIERARCHY_ID, locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getAreaId()).getId());
                    } else {
                        parameters.put(LOCATION_ID, familyEntity.getLocationId());
                        parameters.put(LOCATION_HIERARCHY_ID, locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getLocationId()).getId());
                    }
                    parameters.put(ACTION_BY, user.getId());
                    parameters.put(FAMILY_ID, familyEntity.getId());
                    parameters.put(DEATH_DATE, sdf.format(new Date(dateOfDeath)));
                    parameters.put(PLACE_OF_DEATH, deathPlace);
                    parameters.put(DEATH_REASON, deathReason);
                    parameters.put(OTHER_DEATH_REASON, otherDeathreason);
                    parameters.put(SERVICE_TYPE, "MEMBER_UPDATE");
                    parameters.put(REFERENCE_ID, memberEntity.getId());
                    parameters.put("member_death_mark_state", FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_DEAD);
                    queryDto.setParameters(parameters);
                    List<QueryDto> queryDtos = new LinkedList<>();
                    queryDtos.add(queryDto);
                    queryMasterService.executeQuery(queryDtos, true);
                }
            } else if (keyAndAnswersMap.get("120") != null && keyAndAnswersMap.get("120").equals("3")) {
                memberDao.deleteDiseaseRelationsOfMember(memberEntity.getId());
                this.updateMember(memberEntity, memberEntity.getState(), FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_ARCHIVED, user.getId());
                return returnMap;
            } else if (keyAndAnswersMap.get("120") != null && keyAndAnswersMap.get("120").equals("4")) {
                return returnMap;
            } else {
                if (memberCFHCEntity == null) {
                    memberCFHCEntity = new MemberCFHCEntity();
                    memberCFHCEntity.setMemberId(memberEntity.getId());
                    memberEntity.setMemberCFHCEntity(memberCFHCEntity);
                }
                for (Map.Entry<String, String> entry : keyAndAnswersMap.entrySet()) {
                    String key = entry.getKey();
                    String answer = entry.getValue();
                    setAnswersToMemberEntity(key, answer, memberEntity, memberCFHCEntity, keyAndAnswersMap, null, memberAbhaConsentMap);
                }
                if (keyAndAnswersMap.get("9992") != null && !keyAndAnswersMap.get("9992").equals("0")) {
                    //Setting Mother ID for this Child
                    Calendar instance = Calendar.getInstance();
                    instance.add(Calendar.YEAR, -20);
                    if (memberEntity.getDob().after(instance.getTime())) {
                        memberEntity.setMotherId(Integer.valueOf(keyAndAnswersMap.get("9992")));
                    }
                } else {
                    memberEntity.setMotherId(null);
                }
                if (keyAndAnswersMap.get("1304") != null && !keyAndAnswersMap.get("1304").equals("0")) {
                    //Setting Husband ID for this Member
                    memberEntity.setHusbandId(Integer.valueOf(keyAndAnswersMap.get("1304")));
                } else {
                    memberEntity.setHusbandId(null);
                }
                memberEntity.setModifiedBy(user.getId());
                memberEntity.setModifiedOn(new Date());
                memberCFHCEntity.setModifiedBy(user.getId());
                memberCFHCEntity.setModifiedOn(new Date());
                if (memberEntity.getMobileNumber() == null && memberEntity.getAlternateNumber() != null) {
                    memberEntity.setMobileNumber(memberEntity.getAlternateNumber());
                    memberEntity.setAlternateNumber(null);
                }
                memberDao.update(memberEntity);
                familyHealthSurveyService.insertDiseasesInformationForMember(memberEntity);
                memberCFHCDao.createOrUpdate(memberCFHCEntity);
                if (keyAndAnswersMap.get("9996") != null) {
                    //Setting Childs for this Mother
                    String answer = keyAndAnswersMap.get("9996");
                    List<Integer> childIds = new ArrayList<>();
                    if (answer.contains(",")) {
                        String[] split = answer.split(",");
                        for (String s : split) {
                            childIds.add(Integer.valueOf(s));
                        }
                    } else {
                        childIds.add(Integer.valueOf(answer));
                    }
                    memberDao.updateMotherIdInChildren(memberEntity.getId(), childIds);
                }
            }
        } else {
            memberEntity = new MemberEntity();
            memberCFHCEntity = new MemberCFHCEntity();
            memberCFHCEntity.setMemberId(memberEntity.getId());
            memberCFHCEntity.setCreatedBy(user.getId());
            memberCFHCEntity.setCreatedOn(new Date());
            memberEntity.setFamilyId(familyEntity.getFamilyId());
            memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
            memberEntity.setMemberCFHCEntity(memberCFHCEntity);
            memberEntity.setCreatedBy(user.getId());
            memberEntity.setCreatedOn(new Date());
            memberEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
            memberEntity.setState(FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_NEW);
            for (Map.Entry<String, String> entry : keyAndAnswersMap.entrySet()) {
                String key = entry.getKey();
                String answer = entry.getValue();
                setAnswersToMemberEntity(key, answer, memberEntity, memberCFHCEntity, keyAndAnswersMap, null, memberAbhaConsentMap);
            }
            if (keyAndAnswersMap.get("9992") != null && !keyAndAnswersMap.get("9992").equals("0")) {
                //Setting Mother ID for this Child
                Calendar instance = Calendar.getInstance();
                instance.add(Calendar.YEAR, -20);
                if (memberEntity.getDob().after(instance.getTime())) {
                    memberEntity.setMotherId(Integer.valueOf(keyAndAnswersMap.get("9992")));
                }
            }
            if (keyAndAnswersMap.get("1304") != null && !keyAndAnswersMap.get("1304").equals("0")) {
                //Setting Husband ID for this Member
                memberEntity.setHusbandId(Integer.valueOf(keyAndAnswersMap.get("1304")));
            }
            if (memberEntity.getMobileNumber() == null && memberEntity.getAlternateNumber() != null) {
                memberEntity.setMobileNumber(memberEntity.getAlternateNumber());
                memberEntity.setAlternateNumber(null);
            }
            MemberEntity createdMember = memberDao.createMember(memberEntity);
            familyHealthSurveyService.insertDiseasesInformationForMember(createdMember);
            memberCFHCDao.create(memberCFHCEntity);
            if (keyAndAnswersMap.get("9996") != null) {
                //Setting Childs for this Mother
                String answer = keyAndAnswersMap.get("9996");
                List<Integer> childIds = new ArrayList<>();
                if (answer.contains(",")) {
                    String[] split = answer.split(",");
                    for (String s : split) {
                        childIds.add(Integer.valueOf(s));
                    }
                } else {
                    childIds.add(Integer.valueOf(answer));
                }
                memberDao.updateMotherIdInChildren(memberEntity.getId(), childIds);
            }
        }

        if (uniqueHealthId == null) {
            StringBuilder sb = new StringBuilder();
            sb.append(memberEntity.getUniqueHealthId());
            sb.append("-");
            sb.append(memberEntity.getFirstName());
            sb.append(" ");
            sb.append(memberEntity.getMiddleName());
            sb.append(" ");
            sb.append(memberEntity.getLastName());
            returnMap.put("memberId", sb.toString());

            sb = new StringBuilder();
            sb.append("New Member Added");
            sb.append("\n");
            sb.append("\n");
            sb.append("Family ID : ");
            sb.append(memberEntity.getFamilyId());
            sb.append("\n");
            sb.append("Member ID : ");
            sb.append(memberEntity.getUniqueHealthId());
            sb.append("\n");
            sb.append("Member Name : ");
            sb.append(memberEntity.getFirstName());
            sb.append(" ");
            sb.append(memberEntity.getMiddleName());
            sb.append(" ");
            sb.append(memberEntity.getLastName());
            if (!failedAbhaCreationMessageMap.isEmpty()) {
                returnMap.put("createdInstanceId", "-10");
                String message = failedAbhaCreationMessageMap.get(memberEntity.getId());
                if (message != null && !message.isBlank()) {
                    sb.append("\n");
                    sb.append(message);
                    sb.append("\n");
                }
            }
            returnMap.put("message", sb.toString());
        }
        return returnMap;
    }


    public void updateMember(MemberEntity memberEntity, String fromState, String toState, Integer principleId) {
        if (toState != null && !memberEntity.getState().equals(toState)) {
            memberEntity.setState(toState);
        }
        memberEntity.setModifiedBy(principleId);
        memberEntity.setModifiedOn(new Date());
        memberDao.update(memberEntity);
    }

    /**
     * Executes query mark_member_as_death for given member
     *
     * @param memberEntity          Instance of MemberEntity
     * @param familyEntity          Instance of familyEntity
     * @param memberKeyAndAnswerMap Map of family question and answer
     * @param key                   String of family question
     * @param user                  Instance of UserMaster
     */
    private void markMemberAsDeath(MemberEntity memberEntity, FamilyEntity familyEntity, Map<String, String> memberKeyAndAnswerMap, String key, UserMaster user) {
        String dateOfDeath;
        String placeOfDeath;
        String deathReason;
        String otherDeathReason;

        if (key.equals("0") && memberKeyAndAnswerMap.get("500").equals("1")) {
            dateOfDeath = memberKeyAndAnswerMap.get("501");
            placeOfDeath = memberKeyAndAnswerMap.get("502");
            deathReason = memberKeyAndAnswerMap.get("510");
            otherDeathReason = memberKeyAndAnswerMap.get("513");
        } else if (!key.equals("0") && memberKeyAndAnswerMap.get("500." + key).equals("1")) {
            dateOfDeath = memberKeyAndAnswerMap.get("501" + "." + key);
            placeOfDeath = memberKeyAndAnswerMap.get("502" + "." + key);
            deathReason = memberKeyAndAnswerMap.get("510" + "." + key);
            otherDeathReason = memberKeyAndAnswerMap.get("513" + "." + key);
        } else {
            return;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");

        QueryDto queryDto = new QueryDto();
        queryDto.setCode("mark_member_as_death");
        LinkedHashMap<String, Object> parameters = new LinkedHashMap<>();
        parameters.put("member_id", memberEntity.getId());
        if (familyEntity.getAreaId() != null) {
            parameters.put("location_id", familyEntity.getAreaId());
            parameters.put("location_hierarchy_id", locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getAreaId()).getId());
        } else {
            parameters.put("location_id", familyEntity.getLocationId());
            parameters.put("location_hierarchy_id", locationLevelHierarchyDao.retrieveByLocationId(familyEntity.getLocationId()).getId());
        }
        parameters.put("action_by", user.getId());
        parameters.put("family_id", familyEntity.getId());
        if (dateOfDeath != null) {
            parameters.put("death_date", sdf.format(new Date(Long.parseLong(dateOfDeath))));
        } else {
            parameters.put("death_date", null);
        }
        parameters.put("place_of_death", placeOfDeath);
        parameters.put("death_reason", deathReason);
        parameters.put("other_death_reason", otherDeathReason);
        parameters.put("service_type", "FAMILY_FOLDER");
        parameters.put("reference_id", memberEntity.getId());
        parameters.put("member_death_mark_state", FamilyHealthSurveyServiceConstants.CFHC_MEMBER_STATE_DEAD);
        queryDto.setParameters(parameters);
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        queryMasterService.executeQuery(queryDtos, true);
    }

    /**
     * Generates string message for new family
     *
     * @param familyEntity               Instance of familyEntity
     * @param mapOfMemberWithLoopIdAsKey Map of member with loop as key
     * @param returnMap                  Map of string
     */
    private void newFamilyMsg(FamilyEntity familyEntity, Map<String, MemberEntity> mapOfMemberWithLoopIdAsKey, Map<String, String> returnMap, Map<Integer, String> failedOfflineAbhaMessageMap, ParsedRecordBean parsedRecordBean) {
        StringBuilder sb = new StringBuilder();
        sb.append("Family ID : ");
        sb.append(familyEntity.getFamilyId());
        sb.append("\n");
        sb.append("\n");
        int count = 1;
        for (Map.Entry<String, MemberEntity> entry : mapOfMemberWithLoopIdAsKey.entrySet()) {
            MemberEntity member = entry.getValue();
            if (Boolean.TRUE.equals(member.getFamilyHeadFlag())) {
                StringBuilder familyTitle = new StringBuilder();
                familyTitle.append(familyEntity.getFamilyId())
                        .append(" - ").append(member.getFirstName());
                if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                    familyTitle.append(" ").append(member.getMiddleName());
                }
                familyTitle.append(" ").append(member.getLastName());
                returnMap.put("familyId", familyTitle.toString());
            }
            sb.append(member.getUniqueHealthId());
            sb.append(" - ");
            sb.append(member.getFirstName());
            sb.append(" ");
            if (member.getMiddleName() != null && !member.getMiddleName().isEmpty()) {
                sb.append(" ");
                sb.append(member.getMiddleName());
                sb.append(" ");
            }
            sb.append(member.getLastName());
            if (!failedOfflineAbhaMessageMap.isEmpty()) {
                parsedRecordBean.setAbhaFailed(Boolean.TRUE);
                String message = failedOfflineAbhaMessageMap.get(member.getId());
                if (message != null && !message.isBlank()) {
                    sb.append("\n");
                    sb.append(message);
                    sb.append("\n");
                }
            }
            if (count < mapOfMemberWithLoopIdAsKey.size()) {
                sb.append("\n");
            }
            count++;
        }
        if (sb.length() > 0) {
            returnMap.put("message", sb.toString());
        }
    }

    /**
     * Set value in familyEntity
     *
     * @param key          Question string
     * @param answer       Answer string
     * @param familyEntity Instance of FamilyEntity
     */
    private void setAnswersToFamilyEntity(String key, String answer, FamilyEntity familyEntity) {
        switch (key) {
            case "-3":
                familyEntity.setLocationId(Integer.parseInt(answer));
                familyEntity.setAreaId(Integer.parseInt(answer));
                break;
            case "20":
                if (answer.trim().length() > 0) {
                    familyEntity.setHouseNumber(answer.trim());
                }
                break;
            case "21":
                if (answer.trim().length() > 0) {
                    familyEntity.setAddress1(answer.trim());
                }
                break;
            case "22":
                if (answer.trim().length() > 0) {
                    familyEntity.setAddress2(answer.trim());
                }
                break;
            case "24":
                if (answer.trim().length() > 0) {
                    familyEntity.setAreaId(Integer.valueOf(answer.trim()));
                }
                break;
            case "30":
                if (answer.trim().length() > 0) {
                    familyEntity.setReligion(answer.trim());
                }
                break;
            case "40":
                familyEntity.setTypeOfHouse(answer);
                break;
            case "410":
                familyEntity.setOtherTypeOfHouse(answer);
                break;
            case "41":
                familyEntity.setHouseOwnershipStatus(answer);
                break;
            case "42":
                familyEntity.setTypeOfToilet(answer);
                break;
            case "420":
                familyEntity.setOtherToilet(answer);
                break;
            case "43":
                familyEntity.setDrinkingWaterSource(answer);
                break;
            case "430":
                familyEntity.setOtherWaterSource(answer);
                break;
            case "44":
                familyEntity.setElectricityAvailability(answer);
                break;
            case "45":
                String[] vehiclesArray = answer.split(",");
                Set<String> vehiclesSet = new HashSet<>(Arrays.asList(vehiclesArray));
                familyEntity.setVehicleDetails(vehiclesSet);
                break;
            case "48":
                familyEntity.setOtherMotorizedVehicle(answer);
                break;
            case "46":
                familyEntity.setFuelForCooking(answer);
                break;
            case "47":
                familyEntity.setVehicleAvailabilityFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "53":
                familyEntity.setAnyoneTravelledForeign(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "60":
                familyEntity.setResidenceStatus(answer);
                break;
            case "61":
                familyEntity.setNativeState(answer);
                break;
            default:
        }
    }


    private void setAnswersToFamilyEntity2(String key, String answer, FamilyEntity familyEntity) {
        switch (key) {
            case "-3":
                familyEntity.setLocationId(Integer.parseInt(answer));
                familyEntity.setAreaId(Integer.parseInt(answer));
                break;
            case "20":
                if (answer.trim().length() > 0) {
                    familyEntity.setHouseNumber(answer.trim());
                }
                break;
            case "21":
                if (answer.trim().length() > 0) {
                    familyEntity.setAddress1(answer.trim());
                }
                break;
            case "22":
                if (answer.trim().length() > 0) {
                    familyEntity.setAddress2(answer.trim());
                }
                break;
            case "24":
                if (answer.trim().length() > 0) {
                    familyEntity.setAreaId(Integer.valueOf(answer.trim()));
                }
                break;
            case "30":
                if (answer.trim().length() > 0) {
                    familyEntity.setReligion(answer.trim());
                }
                break;
            case "32":
                familyEntity.setTypeOfToilet(answer);
                break;
            case "420":
                familyEntity.setOtherToilet(answer);
                break;
            case "37":
                familyEntity.setDrinkingWaterSource(answer);
                break;
            case "430":
                familyEntity.setOtherWaterSource(answer);
                break;
            default:
        }
    }

    /**
     * Set value to memberEntity
     *
     * @param key                   Question string
     * @param answer                Answer string
     * @param memberEntity          Instance of MemberEntity
     * @param memberCFHCEntity      Instance of MemberCFHCEntity
     * @param memberKeyAndAnswerMap Map of question and answer
     * @param memberCount           Counts of member
     */
    private void setAnswersToMemberEntity(String key, String answer, MemberEntity memberEntity, MemberCFHCEntity memberCFHCEntity, Map<String, String> memberKeyAndAnswerMap, String memberCount, Map<String, String> memberAbhaConsentMap) {
        switch (key) {
            case "132":
                memberEntity.setFamilyHeadFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "133":
                memberEntity.setRelationWithHof(answer);
                break;
            case "134":
                memberEntity.setOtherHofRelation(answer);
                break;
            case "140":
                if (answer.trim().length() > 0) {
                    memberEntity.setFirstName(answer.trim());
                }
                break;
            case "141":
                if (answer.trim().length() > 0 && !answer.equals("1")) {
                    memberEntity.setMiddleName(answer.trim());
                }
                break;
            case "142":
                if (answer.trim().length() > 0) {
                    memberEntity.setLastName(answer.trim());
                }
                break;
            case "143":
                memberEntity.setGender(ImtechoUtil.getGenderValueFromKey(answer));
                break;
            case "144":
                if (answer.trim().length() > 0) {
                    memberEntity.setMaritalStatus(Integer.parseInt(answer));
                }
                break;
            case "156":
                memberCFHCEntity.setPmjayNumber(answer);
                break;
            case "166":
            case "167":
                memberEntity.setDob(new Date(Long.parseLong(answer)));
                break;
            case "171":
                if (!answer.equals("T")) {
                    memberEntity.setMobileNumber(answer.replace("F/", ""));
                }
                break;
            case "172":
                if (answer.trim().length() > 0) {
                    memberEntity.setAlternateNumber(answer.trim());
                }
                break;
            case "189":
                if (answer.startsWith("T")) {
                    memberEntity.setIsMobileNumberVerified(Boolean.TRUE);
                    if (answer.endsWith("T")) {
                        MemberAdditionalInfo memberAdditionalInfo;
                        Gson gson = new Gson();
                        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                        } else {
                            memberAdditionalInfo = new MemberAdditionalInfo();
                        }
                        memberAdditionalInfo.setWhatsappConsentOn(new Date().getTime());
                        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                    }
                } else {
                    memberEntity.setIsMobileNumberVerified(Boolean.FALSE);
                }
                break;
            case "201":
                memberEntity.setEducationStatus(answer != null ? Integer.parseInt(answer) : null);
                break;
            case "202":
                memberCFHCEntity.setIsChildGoingSchool(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberEntity.setIsChildGoingSchool(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "203":
                memberCFHCEntity.setCurrentStudyingStandard(answer);
                memberEntity.setCurrentStudyingStandard(answer);
                break;
            case "204":
                memberEntity.setOccupation(answer);
                break;
            case "212":
                Set<Integer> anomalyRelEntitys = new HashSet<>();
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        anomalyRelEntitys.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setCongenitalAnomalyDetails(anomalyRelEntitys);
                break;
            case "214":
                memberEntity.setPhysicalDisability(answer);
                break;
            case "2141":
                memberEntity.setOtherDisability(answer);
                break;
            case "216":
                Set<Integer> chronicDiseaseRelEntitys = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        chronicDiseaseRelEntitys.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setChronicDiseaseDetails(chronicDiseaseRelEntitys);
                memberEntity.setOtherChronic(null);
                break;
            case "224":
                if (memberKeyAndAnswerMap.get("216").contains("OTHER"))
                    memberEntity.setOtherChronic(answer);
                else
                    memberEntity.setOtherChronic(null);
                break;
            case "226":
                memberEntity.setUnderTreatmentChronic(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "218":
                Set<Integer> eyeRelEntities = new HashSet<>();
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        eyeRelEntities.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setEyeIssueDetails(eyeRelEntities);
                memberEntity.setOtherEyeIssue(null);
                break;
            case "2181":
                if (memberKeyAndAnswerMap.get("218").contains("OTHER"))
                    memberEntity.setOtherEyeIssue(answer);
                else
                    memberEntity.setOtherEyeIssue(null);
                break;
            case "220":
                memberEntity.setCataractSurgery(answer);
                break;
            case "222":
                memberEntity.setSickleCellStatus(answer);
                break;
            case "234":
                memberEntity.setMenopauseArrived(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "235":
                memberEntity.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "236":
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "240":
                memberCFHCEntity.setReadyForMoreChild(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "241":
                memberCFHCEntity.setCurrentlyUsingFpMethod(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "243":
                memberEntity.setLastMethodOfContraception(answer);
                break;
            case "244":
                memberEntity.setFpInsertOperateDate(new Date(Long.parseLong(answer)));
                break;
//            case "251":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("WIDOW")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "WIDOW");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("WIDOW");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("WIDOW", ""));
//                    }
//                }
//                break;
//            case "253":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("SENIOR_CITIZEN")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "SENIOR_CITIZEN");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("SENIOR_CITIZEN");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("SENIOR_CITIZEN", ""));
//                    }
//                }
//                break;
//            case "255":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("DISABILITY")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "DISABILITY");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("DISABILITY");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("DISABILITY", ""));
//                    }
//                }
//                break;
//            case "300":
//                memberEntity.setAbhaStatus(answer);
//                break;
            case "302":
                memberEntity.setHealthIdNumber(answer);
                break;
            default:
        }
    }


    private void setAnswersToMemberEntity2(String key, String answer, MemberEntity memberEntity, MemberCFHCEntity memberCFHCEntity, Map<String, String> memberKeyAndAnswerMap, String memberCount, Map<String, String> memberAbhaConsentMap) {
        switch (key) {
            case "132":
                memberEntity.setFamilyHeadFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "133":
                memberEntity.setRelationWithHof(answer);
                break;
            case "134":
                memberEntity.setOtherHofRelation(answer);
                break;
            case "140":
                if (answer.trim().length() > 0) {
                    memberEntity.setFirstName(answer.trim());
                }
                break;
            case "141":
                if (answer.trim().length() > 0 && !answer.equals("1")) {
                    memberEntity.setMiddleName(answer.trim());
                }
                break;
            case "142":
                if (answer.trim().length() > 0) {
                    memberEntity.setLastName(answer.trim());
                }
                break;
            case "143":
                memberEntity.setGender(ImtechoUtil.getGenderValueFromKey(answer));
                break;
            case "144":
                if (answer.trim().length() > 0) {
                    memberEntity.setMaritalStatus(Integer.parseInt(answer));
                }
                break;
            case "156":
                memberCFHCEntity.setPmjayNumber(answer);
                break;
            case "166":
            case "167":
                memberEntity.setDob(new Date(Long.parseLong(answer)));
                break;
            case "171":
                if (!answer.equals("T")) {
                    memberEntity.setMobileNumber(answer.replace("F/", ""));
                }
                break;
            case "172":
                if (answer.trim().length() > 0) {
                    memberEntity.setAlternateNumber(answer.trim());
                }
                break;
            case "189":
                if (answer.startsWith("T")) {
                    memberEntity.setIsMobileNumberVerified(Boolean.TRUE);
                    if (answer.endsWith("T")) {
                        MemberAdditionalInfo memberAdditionalInfo;
                        Gson gson = new Gson();
                        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                        } else {
                            memberAdditionalInfo = new MemberAdditionalInfo();
                        }
                        memberAdditionalInfo.setWhatsappConsentOn(new Date().getTime());
                        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                    }
                } else {
                    memberEntity.setIsMobileNumberVerified(Boolean.FALSE);
                }
                break;
            case "201":
                memberEntity.setEducationStatus(answer != null ? Integer.parseInt(answer) : null);
                break;
            case "202":
                memberCFHCEntity.setIsChildGoingSchool(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberEntity.setIsChildGoingSchool(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "203":
                memberCFHCEntity.setCurrentStudyingStandard(answer);
                memberEntity.setCurrentStudyingStandard(answer);
                break;
            case "204":
                memberEntity.setOccupation(answer);
                break;
            case "212":
                Set<Integer> anomalyRelEntitys = new HashSet<>();
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        anomalyRelEntitys.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setCongenitalAnomalyDetails(anomalyRelEntitys);
                break;
            case "214":
                memberEntity.setPhysicalDisability(answer);
                break;
            case "2141":
                memberEntity.setOtherDisability(answer);
                break;
            case "216":
                Set<Integer> chronicDiseaseRelEntitys = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        chronicDiseaseRelEntitys.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setChronicDiseaseDetails(chronicDiseaseRelEntitys);
                memberEntity.setOtherChronic(null);
                break;
            case "224":
                if (memberKeyAndAnswerMap.get("216").contains("OTHER"))
                    memberEntity.setOtherChronic(answer);
                else
                    memberEntity.setOtherChronic(null);
                break;
            case "226":
                memberEntity.setUnderTreatmentChronic(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "218":
                Set<Integer> eyeRelEntities = new HashSet<>();
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        eyeRelEntities.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setEyeIssueDetails(eyeRelEntities);
                memberEntity.setOtherEyeIssue(null);
                break;
            case "2181":
                if (memberKeyAndAnswerMap.get("218").contains("OTHER"))
                    memberEntity.setOtherEyeIssue(answer);
                else
                    memberEntity.setOtherEyeIssue(null);
                break;
            case "220":
                memberEntity.setCataractSurgery(answer);
                break;
            case "222":
                memberEntity.setSickleCellStatus(answer);
                break;
            case "234":
                memberEntity.setMenopauseArrived(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "235":
            case "4501":
                memberEntity.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "236":
            case "4502":
                memberEntity.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "240":
                memberCFHCEntity.setReadyForMoreChild(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "241":
                memberCFHCEntity.setCurrentlyUsingFpMethod(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "243":
                memberEntity.setLastMethodOfContraception(answer);
                break;
            case "244":
                memberEntity.setFpInsertOperateDate(new Date(Long.parseLong(answer)));
                break;
//            case "251":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("WIDOW")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "WIDOW");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("WIDOW");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("WIDOW", ""));
//                    }
//                }
//                break;
//            case "253":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("SENIOR_CITIZEN")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "SENIOR_CITIZEN");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("SENIOR_CITIZEN");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("SENIOR_CITIZEN", ""));
//                    }
//                }
//                break;
//            case "255":
//                if (answer != null && ImtechoUtil.returnTrueFalseFromInitials(answer)) {
//                    if (memberEntity.getPensionScheme() != null) {
//                        if (!memberEntity.getPensionScheme().contains("DISABILITY")) {
//                            memberEntity.setPensionScheme(memberEntity.getPensionScheme() + "," + "DISABILITY");
//                        }
//                    } else {
//                        memberEntity.setPensionScheme("DISABILITY");
//                    }
//                } else {
//                    if (memberEntity.getPensionScheme() != null) {
//                        memberEntity.setPensionScheme(memberEntity.getPensionScheme().replaceAll("DISABILITY", ""));
//                    }
//                }
//                break;
//            case "300":
//                memberEntity.setAbhaStatus(answer);
//                break;
            case "302":
                memberEntity.setHealthIdNumber(answer);
                break;
            default:
        }
    }
}
