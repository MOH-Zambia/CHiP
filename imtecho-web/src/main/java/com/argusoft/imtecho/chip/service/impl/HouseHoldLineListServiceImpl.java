package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.cfhc.dao.MemberCFHCDao;
import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import com.argusoft.imtecho.chip.service.HouseHoldLineListService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
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

@Service
@Transactional
public class HouseHoldLineListServiceImpl implements HouseHoldLineListService {

    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private MemberCFHCDao memberCFHCDao;
    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;
    @Autowired
    private QueryMasterService queryMasterService;
    @Autowired
    private LocationMasterDao locationMasterDao;
    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;
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
        keys.add("21");          //Landmark
        keys.add("32");          // Availability of toilet
        keys.add("420");         // Availability of other toilet
        keys.add("8989");         // iec given
        keys.add("33");         //Outdoor Cooking Practices?
        keys.add("34");         //Waste disposal facility available?
        keys.add("47");          // waste disposal method type
        keys.add("35");         //Handwash available?
        keys.add("36");         //Water safety meets standards?
        keys.add("37");          // Source of drinking water
        keys.add("430");          // Other Source of drinking water
        keys.add("38");          // Storage and Handling meets standards?
        keys.add("39");          // Dishrack Available?
        keys.add("40");          // Complaint of insects?
        keys.add("41");          // Complaint of rodents?
        keys.add("42");          // Separate livestock shelter?
        keys.add("43");          // mosquito nets in household
        keys.add("-10");          // Family uuid
        keys.add("59");         //Please select mother for these members
        keys.add("60");         //Please select husband for these members
        keys.add("9997");       //Do you want to submit or review the data?
        keys.add("9999");       //Household Line List form is complete.
        keys.add("-3");         //Location ID
        keys.add("-8");         //Mobile Start Date
        keys.add("-9");         //Mobile End Date
        keys.add("-1");         //Longitude
        keys.add("-2");         //Latitude
        return keys;
    }

    public Map<String, String> storeHouseHoldLineListForm(ParsedRecordBean parsedRecordBean, UserMaster user) {
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

        returnMap.put("createdInstanceId", familyEntity.getId().toString());


        if (isNewFamily) {
            newFamilyMsg(familyEntity, mapOfMemberWithLoopIdAsKey, returnMap, failedOfflineAbhaMessageMap, parsedRecordBean);
        }
        return returnMap;
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
                if (!answer.trim().isEmpty()) {
                    familyEntity.setHouseNumber(answer.trim());
                }
                break;
            case "21":
                if (!answer.trim().isEmpty()) {
                    familyEntity.setAddress1(answer.trim());
                }
                break;
            case "22":
                if (!answer.trim().isEmpty()) {
                    familyEntity.setAddress2(answer.trim());
                }
                break;
            case "24":
                if (!answer.trim().isEmpty()) {
                    familyEntity.setAreaId(Integer.valueOf(answer.trim()));
                }
                break;
            case "30":
                if (!answer.trim().isEmpty()) {
                    familyEntity.setReligion(answer.trim());
                }
                break;
            case "32":
                familyEntity.setTypeOfToilet(answer);
                break;
            case "420":
                familyEntity.setOtherToilet(answer);
                break;
            case "33":
                familyEntity.setOutdoorCookingPractices(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "34":
                familyEntity.setWasteDisposalAvailable(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "35":
                familyEntity.setHandwashAvailable(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "36":
                familyEntity.setWaterSafetyMeetsStandard(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "37":
                familyEntity.setDrinkingWaterSource(answer);
                break;
            case "430":
                familyEntity.setOtherWaterSource(answer);
                break;
            case "38":
                familyEntity.setStorageMeetsStandard(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "39":
                familyEntity.setDishrackAvailable(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "40":
                familyEntity.setComplaintOfInsects(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "41":
                familyEntity.setComplaintOfRodents(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "42":
                familyEntity.setSeparateLivestockShelter(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "43":
                familyEntity.setNoOfMosquitoNetsAvailable(Integer.valueOf(answer.trim()));
                break;
            case "-10":
                familyEntity.setFamilyUuid(answer);
                break;
            case "8989":
                familyEntity.setIsIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "47":
                Set<Integer> wasteDisposalEntities = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        wasteDisposalEntities.add(Integer.parseInt(id));
                    }
                }
                familyEntity.setWasteDisposalDetails(wasteDisposalEntities);
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
                if (!answer.trim().isEmpty()) {
                    memberEntity.setFirstName(answer.trim());
                }
                break;
            case "141":
                if (!answer.trim().isEmpty() && !answer.equals("1")) {
                    memberEntity.setMiddleName(answer.trim());
                }
                break;
            case "142":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setLastName(answer.trim());
                }
                break;
            case "1401":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setMotherName(answer);
                }
                break;
            case "1403":
                if (answer != null) {
                    MemberAdditionalInfo memberAdditionalInfo;
                    if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                        memberAdditionalInfo = new Gson().fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                    } else {
                        memberAdditionalInfo = new MemberAdditionalInfo();
                    }
                    memberAdditionalInfo.setNhimaCard(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;

            case "1444":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setNextOfKin(answer);
                }
                break;
            case "1402":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSameNrcExists(answer)) {
                        memberEntity.setNrcNumber(answer);
                    } else {
                        memberEntity.setDuplicateNrc(true);
                        memberEntity.setDuplicateNrcNumber(answer);
                    }
                }
                break;
            case "1446":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSamePassportExists(answer.toUpperCase(Locale.ROOT))) {
                        memberEntity.setPassportNumber(answer.toUpperCase(Locale.ROOT));
                    } else {
                        memberEntity.setDuplicatePassport(true);
                        memberEntity.setDuplicatePassportNumber(answer);
                    }
                }
                break;
            case "1447":
                if (!answer.trim().isEmpty()) {
                    if (!memberDao.checkSameBirthCertificateExists(answer)) {
                        memberEntity.setBirthCertificateNumber(answer);
                    } else {
                        memberEntity.setDuplicateBirthCert(true);
                        memberEntity.setDuplicateBirthCertNumber(answer);
                    }
                }
                break;
            case "30":
                if (!answer.trim().isEmpty()) {
                    memberEntity.setMemberReligion(answer);
                }
                break;
            case "143":
                memberEntity.setGender(ImtechoUtil.getGenderValueFromKey(answer));
                break;
            case "144":
                if (!answer.trim().isEmpty()) {
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
                if (!answer.trim().isEmpty()) {
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
                Set<Integer> chronicDiseaseRelEntities = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                        chronicDiseaseRelEntities.add(Integer.parseInt(id));
                    }
                    MemberAdditionalInfo memberAdditionalInfo;
                    Gson gson = new Gson();
                    if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                        memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                    } else {
                        memberAdditionalInfo = new MemberAdditionalInfo();
                    }
                    switch (id) {
                        case "2678":
                            memberAdditionalInfo.setHivTest("POSITIVE");
                            break;
                        case "2679":
                            memberAdditionalInfo.setTbCured(false);
                            memberAdditionalInfo.setTbSuspected(true);
                            break;
                        default:

                    }
                    memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                }
                memberEntity.setChronicDiseaseDetails(chronicDiseaseRelEntities);
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
            case "251":
                Set<Integer> chronicDiseaseTreatmentRelEntitys = new HashSet<>();
                answer = answer.replace("OTHER", "");
                for (String id : answer.split(",")) {
                    if (!"OTHER".contains(id) && !id.equals("null")) {
                        chronicDiseaseTreatmentRelEntitys.add(Integer.parseInt(id));
                    }
                }
                memberEntity.setChronicDiseaseTreatmentDetails(chronicDiseaseTreatmentRelEntitys);
                memberEntity.setOtherChronicDiseaseTreatment(null);
                break;
            case "253":
                if (memberKeyAndAnswerMap.get("251").contains("OTHER"))
                    memberEntity.setOtherChronicDiseaseTreatment(answer);
                else
                    memberEntity.setOtherChronicDiseaseTreatment(null);
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
            case "444":
                memberEntity.setMenopauseArrived(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "777":
                memberEntity.setHysterectomyDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "235":
                memberEntity.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
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
            case "4504":
                // for chip the date of wedding will be referred as period for living with partner/spouse in live in relationship
                memberEntity.setDateOfWedding(new Date(Long.parseLong(answer)));
                break;
            case "4501":
                memberEntity.setStartedMenstruating(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7501":
                boolean alreadyPregnant = memberEntity.getIsPregnantFlag() != null && memberEntity.getIsPregnantFlag();
                memberEntity.setIsPregnantFlag(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberEntity.setMarkedPregnant(!alreadyPregnant && Boolean.TRUE.equals(memberEntity.getIsPregnantFlag()));
                break;
            case "2704":
                MemberAdditionalInfo memberAdditionalInfo;
                Gson gson = new Gson();
                if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                    memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                } else {
                    memberAdditionalInfo = new MemberAdditionalInfo();
                }
                memberAdditionalInfo.setPersonallyUsingFp(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                memberEntity.setPersonallyUsingFp(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            default:
        }
    }


    private static List<AshaReportedEventDataBean> getDeathsReportedByAsha
            (Set<MemberEntity> membersToBeMarkedDead, FamilyEntity familyEntity) {
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


    /**
     * Executes query mark_member_as_death for given member
     *
     * @param memberEntity          Instance of MemberEntity
     * @param familyEntity          Instance of familyEntity
     * @param memberKeyAndAnswerMap Map of family question and answer
     * @param key                   String of family question
     * @param user                  Instance of UserMaster
     */
    private void markMemberAsDeath(MemberEntity memberEntity, FamilyEntity
            familyEntity, Map<String, String> memberKeyAndAnswerMap, String key, UserMaster user) {
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
    private void newFamilyMsg(FamilyEntity
                                      familyEntity, Map<String, MemberEntity> mapOfMemberWithLoopIdAsKey, Map<String, String> returnMap, Map<Integer, String> failedOfflineAbhaMessageMap, ParsedRecordBean
                                      parsedRecordBean) {
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
            if (member.isDuplicateNrc()) {
                sb.append(" ");
                sb.append(String.format("( Entered NRC number %s already exists in the system for this member please update member from health services )", member.getDuplicateNrcNumber()));
                sb.append(" ");
                sb.append("\n");
            }
            if (member.isDuplicatePassport()) {
                sb.append(" ");
                sb.append(String.format("( Entered passport number %s already exists in the system for this member please update member from health services )", member.getDuplicatePassportNumber()));
                sb.append(" ");
                sb.append("\n");
            }
            if (member.isDuplicateBirthCert()) {
                sb.append(" ");
                sb.append(String.format("( Entered birth certificate number %s already exists in the system for this member please update member from health services )", member.getDuplicateBirthCertNumber()));
                sb.append(" ");
                sb.append("\n");
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

}
