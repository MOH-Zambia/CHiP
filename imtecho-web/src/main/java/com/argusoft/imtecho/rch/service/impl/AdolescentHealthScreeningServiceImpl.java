package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.cfhc.dao.MemberCFHCDao;
import com.argusoft.imtecho.cfhc.model.MemberCFHCEntity;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.model.OfflineHealthIdEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.mobile.dto.OfflineHealthIdResponseDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.dao.AdolescentDao;
import com.argusoft.imtecho.rch.model.AdolescentScreeningEntity;
import com.argusoft.imtecho.rch.service.AdolescentHealthScreeningService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

import static com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_TEMPORARY;
import static com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_TEMPORARY;

@Service
@Transactional
public class AdolescentHealthScreeningServiceImpl implements AdolescentHealthScreeningService {

    @Autowired
    private MemberDao memberDao;
    @Autowired
    private MemberCFHCDao cfhcDao;
    @Autowired
    private AdolescentDao adolescentDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    private final Gson gson = new Gson();

    private List<String> getKeysForHeadOfTheFamily() {
        List<String> keys = new ArrayList<>();
        //For child form
        keys.add("1000");         //First Name
        keys.add("1001");         //Middle Name
        keys.add("1002");         //Last Name
        keys.add("1003");         //Grandfather Name
        keys.add("1004");         //Mobile Number
        keys.add("1005");         //Gender
        keys.add("1006");         //Dob
        keys.add("1007");         //Health Id
        return keys;
    }

    private List<String> getKeysForMother() {
        List<String> keys = new ArrayList<>();
        keys.add("1010");          //First Name
        keys.add("1011");          //Middle Name
        keys.add("1012");          //Last Name
        keys.add("1013");          //RCH ID
        keys.add("1014");          //Dob
        keys.add("1015");          //Health Id
        return keys;
    }

    private List<String> getKeysForChild() {
        List<String> keys = new ArrayList<>();
        keys.add("1020");         //First Name
        keys.add("1021");         //Middle Name
        keys.add("1022");         //Last Name
        keys.add("1023");         //RCH ID
        keys.add("1025");         //Dob
        keys.add("1026");         //Age
        keys.add("1027");         //Health ID
        keys.add("1028");         //gender
        return keys;
    }

    private FamilyEntity createFamily(Map<String, String> keyAndAnswerMap, UserMaster user) {
        FamilyEntity familyEntity = new FamilyEntity();
        String longitude = keyAndAnswerMap.get("-1");
        String latitude = keyAndAnswerMap.get("-2");
        familyEntity.setLongitude(longitude);
        familyEntity.setLatitude(latitude);
        familyEntity.setCreatedOn(new Date());
        if (keyAndAnswerMap.containsKey("-3")) {
            familyEntity.setLocationId(Integer.parseInt(keyAndAnswerMap.get("-3")));
            familyEntity.setAreaId(Integer.parseInt(keyAndAnswerMap.get("-3")));
        } else {
            familyEntity.setLocationId(Integer.parseInt(keyAndAnswerMap.get("-6")));
            familyEntity.setAreaId(Integer.parseInt(keyAndAnswerMap.get("-6")));
        }
        familyEntity.setCreatedBy(user.getId());
        familyEntity.setState(FHS_FAMILY_STATE_TEMPORARY);
        familyEntity.setFamilyId(familyHealthSurveyService.generateFamilyId());
        familyEntity.setId(familyDao.create(familyEntity));
        return familyEntity;
    }

    private void createHOF(Map<String, String> hofKeyAndAnswerMap, UserMaster user, FamilyEntity familyEntity) {
        MemberEntity hofMember;
        if (!hofKeyAndAnswerMap.isEmpty()) {
            hofMember = new MemberEntity();
            hofMember.setFamilyId(familyEntity.getFamilyId());
            hofMember.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
            hofMember.setCreatedOn(new Date());
            hofMember.setCreatedBy(user.getId());
            hofMember.setFamilyHeadFlag(Boolean.TRUE);
            hofMember.setState(FHS_MEMBER_STATE_TEMPORARY);
            for (Map.Entry<String, String> entrySet : hofKeyAndAnswerMap.entrySet()) {
                String key = entrySet.getKey();
                String answer = entrySet.getValue();
                this.setAnswerToMemberEntity(key, answer, hofKeyAndAnswerMap, hofMember);
            }
            memberDao.createMember(hofMember);
            familyEntity.setHeadOfFamily(hofMember.getId());
            familyEntity.setContactPersonId(hofMember.getId());
            familyDao.updateFamily(familyEntity);
        }
    }

    private MemberEntity createMother(Map<String, String> motherKeyAndAnswerMap, UserMaster user, FamilyEntity familyEntity) {
        MemberEntity motherEntity;
        if (!motherKeyAndAnswerMap.isEmpty()) {
            motherEntity = new MemberEntity();
            motherEntity.setFamilyId(familyEntity.getFamilyId());
            motherEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
            motherEntity.setCreatedOn(new Date());
            motherEntity.setCreatedBy(user.getId());
            motherEntity.setState(FHS_MEMBER_STATE_TEMPORARY);
            motherEntity.setGender("F");
            for (Map.Entry<String, String> entrySet : motherKeyAndAnswerMap.entrySet()) {
                String key = entrySet.getKey();
                String answer = entrySet.getValue();
                this.setAnswerToMemberEntity(key, answer, motherKeyAndAnswerMap, motherEntity);
            }
            memberDao.createMember(motherEntity);
            return motherEntity;
        }
        return null;
    }

    private MemberEntity createChild(Map<String, String> childKeyAndAnswerMap, UserMaster user, FamilyEntity familyEntity, MemberEntity motherEntity) {
        MemberEntity childEntity;
        if (!childKeyAndAnswerMap.isEmpty()) {
            childEntity = new MemberEntity();
            childEntity.setFamilyId(familyEntity.getFamilyId());
            childEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
            childEntity.setCreatedOn(new Date());
            childEntity.setCreatedBy(user.getId());
            childEntity.setState(FHS_MEMBER_STATE_TEMPORARY);
            if (motherEntity != null) {
                childEntity.setMotherId(motherEntity.getId());
            }
            for (Map.Entry<String, String> entrySet : childKeyAndAnswerMap.entrySet()) {
                String key = entrySet.getKey();
                String answer = entrySet.getValue();
                this.setAnswerToMemberEntity(key, answer, childKeyAndAnswerMap, childEntity);
            }
            memberDao.createMember(childEntity);
            return childEntity;
        }
        return null;
    }

    @Override
    public Integer storeQuestionSetAnswerForMobile(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        boolean isNewTemporaryMember;
        List<String> keysForHOFQuestions = this.getKeysForHeadOfTheFamily();
        List<String> keysForMotherQuestions = this.getKeysForMother();
        List<String> keysForChildQuestions = this.getKeysForChild();

        FamilyEntity familyEntity;
        MemberEntity childEntity;
        if (keyAndAnswerMap.containsKey("81")) {
            isNewTemporaryMember = false;
            childEntity = memberDao.retrieveMemberByUniqueHealthId(keyAndAnswerMap.get("81"));
            familyEntity = familyDao.retrieveFamilyByFamilyId(childEntity.getFamilyId());
        } else {
            familyEntity = createFamily(keyAndAnswerMap, user);
            Map<String, String> hofKeyAndAnswerMap = new LinkedHashMap<>();
            Map<String, String> motherKeyAndAnswerMap = new LinkedHashMap<>();
            Map<String, String> childKeyAndAnswerMap = new LinkedHashMap<>();
            isNewTemporaryMember = true;
            for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
                String key = entrySet.getKey();
                String answer = entrySet.getValue();
                if (keysForHOFQuestions.contains(key)) {
                    hofKeyAndAnswerMap.put(key, answer);
                }
                if (keysForMotherQuestions.contains(key)) {
                    motherKeyAndAnswerMap.put(key, answer);
                }
                if (keysForChildQuestions.contains(key) ||
                        (key.contains(".") && keysForChildQuestions.contains(key.split("\\.")[0]))) {
                    childKeyAndAnswerMap.put(key, answer);
                }
            }
            createHOF(hofKeyAndAnswerMap, user, familyEntity);
            MemberEntity mother = createMother(motherKeyAndAnswerMap, user, familyEntity);
            childEntity = createChild(childKeyAndAnswerMap, user, familyEntity, mother);
        }

        if (childEntity == null) {
            throw new ImtechoMobileException("Child details not found", 500);
        }

        AdolescentScreeningEntity adolescentScreeningEntity;
        if (adolescentDao.retrieveMemberByUniqueHealthId(keyAndAnswerMap.get("81")) != null) {
            adolescentScreeningEntity = adolescentDao.retrieveMemberByUniqueHealthId(keyAndAnswerMap.get("81"));
        } else {
            adolescentScreeningEntity = new AdolescentScreeningEntity();
        }

        adolescentScreeningEntity.setUniqueHealthId(childEntity.getUniqueHealthId());
        adolescentScreeningEntity.setMemberId(childEntity.getId());
        adolescentScreeningEntity.setMemberNewlyAdded(isNewTemporaryMember);

        if (familyEntity.getAreaId() != null){
            adolescentScreeningEntity.setLocationId(familyEntity.getAreaId());
        } else {
            adolescentScreeningEntity.setLocationId(familyEntity.getLocationId());
        }

        MemberAdditionalInfo memberAdditionalInfo;

        if (childEntity.getAdditionalInfo() != null && !childEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(childEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        adolescentScreeningEntity.setAdolescentScreeningDate(new Date());
        memberAdditionalInfo.setAdolescentScreeningDate(new Date().getTime());

        MemberCFHCEntity cfhcEntity = cfhcDao.retrieveMemberCFHCEntitiesByMemberId(childEntity.getId());
        if (cfhcEntity != null) {
            if (cfhcEntity.getCurrentSchool() != null && cfhcEntity.getCurrentStudyingStandard() != null){
                adolescentScreeningEntity.setSchoolActualId(cfhcEntity.getCurrentSchool().toString());
                adolescentScreeningEntity.setCurrentStudyingStandard(cfhcEntity.getCurrentStudyingStandard());
            }
        } else {
            cfhcEntity = new MemberCFHCEntity();
            cfhcEntity.setMemberId(childEntity.getId());
            cfhcEntity.setFamilyId(familyEntity.getId());
        }

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToMemberEntity(key, answer, memberAdditionalInfo, adolescentScreeningEntity);
        }

        if (adolescentScreeningEntity.getSchoolActualId() != null && adolescentScreeningEntity.getCurrentStudyingStandard() != null){
            cfhcEntity.setCurrentSchool(Integer.parseInt(adolescentScreeningEntity.getSchoolActualId()));
            cfhcEntity.setCurrentStudyingStandard(adolescentScreeningEntity.getCurrentStudyingStandard());
        }

        childEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        adolescentDao.createMember(adolescentScreeningEntity);
        cfhcDao.saveOrUpdate(cfhcEntity);
        memberDao.updateMember(childEntity);
        return adolescentScreeningEntity.getId();
    }

    @Override
    public List<MemberDto> getMembersOfSchool(Long schoolActualId, Integer standard) {
        return adolescentDao.getMembersOfSchool(schoolActualId, standard);
    }

    @Override
    public List<MemberDto> getMembersByAdvanceSearch(Integer parentId, String searchText, Integer standard) {
        return adolescentDao.getMembersByAdvanceSearch(parentId, searchText, standard);
    }

    private void setAnswersToMemberEntity(String key,
                                          String answer,
                                          MemberAdditionalInfo memberAdditionalInfo,
                                          AdolescentScreeningEntity adolescentScreeningEntity) {
        switch (key) {
            case "1":
                adolescentScreeningEntity.setServiceLocation(answer);
                memberAdditionalInfo.setServiceLocation(answer);
                break;
            case "2":
            case "57":
                if (!answer.contains("NOTDONE")) {
                    Set<String> counsellingEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        counsellingEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setCounsellingDoneDetails(counsellingEntities);
                    memberAdditionalInfo.setCounsellingDoneDetails(counsellingEntities);
                }
                break;
            case "3":
                memberAdditionalInfo.setHeight(Integer.parseInt(answer.trim()));
                adolescentScreeningEntity.setHeight(Float.parseFloat(answer.trim()));
                break;
            case "4":
                memberAdditionalInfo.setWeight(Float.parseFloat(answer.trim()));
                adolescentScreeningEntity.setWeight(Float.parseFloat(answer.trim()));
                break;

            case "403":
                String[] split = answer.split("/");
                if (split.length == 3) {
                    memberAdditionalInfo.setHeight(Integer.valueOf(split[0]));
                    adolescentScreeningEntity.setHeight(Float.parseFloat(split[0]));
                    memberAdditionalInfo.setWeight(Float.valueOf(split[1]));
                    adolescentScreeningEntity.setWeight(Float.valueOf(split[1]));
                }
                break;

            case "5":
                adolescentScreeningEntity.setHaemoglobinMeasured(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setHaemoglobinMeasured(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "404":
                adolescentScreeningEntity.setClinicalDiagnosisHb(answer);
                memberAdditionalInfo.setClinicalDiagnosisHb(answer);
                break;

            case "405":
                adolescentScreeningEntity.setHealthInfraId(answer);
                memberAdditionalInfo.setHealthInfraId(answer);
                break;

            case "6":
                memberAdditionalInfo.setHaemoglobin(Float.parseFloat(answer.trim()));
                adolescentScreeningEntity.setHaemoglobin(Float.parseFloat(answer.trim()));
                break;

            case "7":
                adolescentScreeningEntity.setIfaTabTakenLastMonth(Integer.parseInt(answer));
                memberAdditionalInfo.setIfaTabTakenLastMonth(Integer.parseInt(answer));
                break;

            case "8":
                adolescentScreeningEntity.setIfaTabTakenNow(Integer.parseInt(answer));
                memberAdditionalInfo.setIfaTabTakenNow(Integer.parseInt(answer));
                break;

            case "9":
                memberAdditionalInfo.setPeriodStarted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setPeriodStarted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "10":
                if (!answer.contains("NONE")) {
                    Set<String> absorbentEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        absorbentEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setAbsorbentMaterialUsedDetails(absorbentEntities);
                    memberAdditionalInfo.setAbsorbentMaterialUsedDetails(absorbentEntities);
                }
                break;

            case "11":
                adolescentScreeningEntity.setSanitaryPadGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setSanitaryPadGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "12":
                adolescentScreeningEntity.setNumberOfSanitaryPadsGiven(Integer.parseInt(answer));
                memberAdditionalInfo.setNumberOfSanitaryPadsGiven(Integer.parseInt(answer));
                break;

            case "13":
                adolescentScreeningEntity.setHavingMenstrualProblem(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setHavingMenstrualProblem(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "14":
                if (!answer.contains("NONE")) {
                    Set<String> issueEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        issueEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setIssueWithMenstruationDetails(issueEntities);
                    memberAdditionalInfo.setIssueWithMenstruationDetails(issueEntities);
                }
                break;

            case "15":
                adolescentScreeningEntity.setTDInjectionGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setTDInjectionGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "16":
                adolescentScreeningEntity.setTdInjectionDate(new Date(Long.parseLong(answer)));
                memberAdditionalInfo.setTdInjectionDate(new Date(Long.parseLong(answer)).getTime());
                break;

            case "17":
                adolescentScreeningEntity.setAlbandazoleGivenInLastSixMonths(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setAlbandazoleGivenInLastSixMonths(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;

            case "555":
                adolescentScreeningEntity.setLmpDate(new Date(Long.parseLong(answer)));
                memberAdditionalInfo.setLmpDate(new Date(Long.parseLong(answer)));
                break;
            case "18":
                if (!answer.contains("NONE")) {
                    Set<String> addictionEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        addictionEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setAddictionDetails(addictionEntities);
                    memberAdditionalInfo.setAddictionDetails(addictionEntities);
                }
                break;
            case "19":
                if (!answer.contains("NONE")) {
                    Set<String> majorIllnessEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        majorIllnessEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setMajorIllnessDetails(majorIllnessEntities);
                    memberAdditionalInfo.setMajorIllnessDetails(majorIllnessEntities);
                }
                break;
            case "22":
                adolescentScreeningEntity.setHavingJuvenileDiabetes(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setHavingJuvenileDiabetes(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "23":
                adolescentScreeningEntity.setInterestedInStudying(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setInterestedInStudying(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "24":
                adolescentScreeningEntity.setBehaviourDifferentFromOthers(ImtechoUtil.returnTrueFalseFromInitials(answer));
                memberAdditionalInfo.setBehaviourDifferentFromOthers(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "445":
                memberAdditionalInfo.setSufferingFromRtiSti(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setSufferingFromRtiSti(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "446":
                memberAdditionalInfo.setHavingSkinDisease(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setHavingSkinDisease(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "447":
                memberAdditionalInfo.setHadPeriodThisMonth(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setHadPeriodThisMonth(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "448":
                memberAdditionalInfo.setUptDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setUptDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "488":
                memberAdditionalInfo.setKnowingAboutFamilyPlanning(ImtechoUtil.returnTrueFalseFromInitials(answer));
                adolescentScreeningEntity.setKnowingAboutFamilyPlanning(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "450":
                if (!answer.contains("NONE")) {
                    Set<String> contraceptiveMethodEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        contraceptiveMethodEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setContraceptiveMethodUsedDetails(contraceptiveMethodEntities);
                    memberAdditionalInfo.setContraceptiveMethodUsedDetails(contraceptiveMethodEntities);
                }
                break;
            case "451":
                if (!answer.contains("NONE")) {
                    Set<String> mentalConditionsEntities = new HashSet<>();
                    for (String id : answer.split(",")) {
                        mentalConditionsEntities.add(String.valueOf(id));
                    }
                    adolescentScreeningEntity.setMentalHealthConditionsDetails(mentalConditionsEntities);
                    memberAdditionalInfo.setMentalHealthConditionsDetails(mentalConditionsEntities);
                }
                break;

            case "457":
                adolescentScreeningEntity.setOtherDiseases(answer);
                memberAdditionalInfo.setOtherDiseases(answer);
                break;

            case "460":
            case "468":
                if (answer != null && !answer.isEmpty() && !answer.equalsIgnoreCase("null")) {
                    adolescentScreeningEntity.setSchoolActualId(answer);
                    memberAdditionalInfo.setSchoolActualId(answer);
                }
                break;

            case "463":
            case "469":
                if (answer != null && !answer.isEmpty() && !answer.equalsIgnoreCase("null")) {
                    adolescentScreeningEntity.setCurrentStudyingStandard(answer);
                    memberAdditionalInfo.setCurrentStudyingStandard(answer);
                }
                break;

            default:
        }
    }


    private void setAnswerToMemberEntity(String key, String answer, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "1000":
            case "1010":
            case "1020":
                if (answer.trim().length() > 0) {
                    memberEntity.setFirstName(answer.trim());
                }
                break;
            case "1001":
            case "1011":
            case "1021":
                if (answer.trim().length() > 0) {
                    memberEntity.setMiddleName(answer.trim());
                }
                break;
            case "1002":
            case "1012":
            case "1022":
                if (answer.trim().length() > 0) {
                    memberEntity.setLastName(answer.trim());
                }
                break;
            case "1003":
                if (answer.trim().length() > 0) {
                    memberEntity.setGrandfatherName(answer.trim());
                }
                break;
            case "1005":
            case "1028":
                switch (answer) {
                    case "1":
                        memberEntity.setGender("M");
                        break;
                    case "2":
                        memberEntity.setGender("F");
                        break;
                    case "3":
                        memberEntity.setGender("T");
                        break;
                    default:
                        memberEntity.setGender(answer);
                        break;
                }
                break;
            case "1006":
            case "1014":
            case "1025":
            case "1026":
                memberEntity.setDob(new Date(Long.parseLong(answer)));
                break;
            case "1004":
            case "1013":
                System.out.println(key);
                memberEntity.setMobileNumber(answer);
                break;
            case "1007":
            case "1015":
            case "1027":
                memberEntity.setNdhmHealthId(answer);
                break;
            default:
        }
    }
}
