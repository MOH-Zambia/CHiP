package com.argusoft.imtecho.mobile.service.impl;

//import com.argusoft.imtecho.aadhaarvault.common.service.AadhaarVaultCommonUtilService;
import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.mobile.dao.BcgVaccinationSurveyDao;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.mapper.BcgMapper;
import com.argusoft.imtecho.mobile.model.BcgVaccinationSurveyDetails;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.service.BcgVaccineService;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
public class BcgVaccineServiceImpl implements BcgVaccineService {
    @Autowired
    MemberDao memberDao;
    @Autowired
    BcgVaccinationSurveyDao bcgVaccinationSurveyDao;

    @Autowired
    FamilyDao familyDao;

//    @Autowired
//    AadhaarVaultCommonUtilService aadhaarVaultCommonUtilService;

    @Autowired
    MobileUtilService mobileUtilService;


    @Autowired
    UserDao userDao;

    public Integer storeBcgVaccinationSurveyForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        BcgVaccinationSurveyDetails bcgVaccinationSurveyDetails = new BcgVaccinationSurveyDetails();
        Integer memberId = Integer.parseInt(keyAndAnswerMap.get("-4"));
        MemberEntity member = memberDao.retrieveById(memberId);
        FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(member.getFamilyId());
        Integer locationId;
        locationId = familyEntity.getAreaId() != null ? familyEntity.getAreaId() : familyEntity.getLocationId();
        bcgVaccinationSurveyDetails.setCreatedBy(user.getId());
        bcgVaccinationSurveyDetails.setCreatedOn(new Date());
        bcgVaccinationSurveyDetails.setMemberId(memberId);
        bcgVaccinationSurveyDetails.setLocationId(locationId);
        bcgVaccinationSurveyDetails.setFilledFrom("BCG_SURVEY");

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            setAnswersToBcgVaccinationSurveyDetails(key, answer, keyAndAnswerMap, bcgVaccinationSurveyDetails, member, parsedRecordBean);
        }
        if ((bcgVaccinationSurveyDetails.getBmi() != null && bcgVaccinationSurveyDetails.getBmi() < 18f)
                || checkNull(bcgVaccinationSurveyDetails.getOrganTransplant())
                || checkNull(bcgVaccinationSurveyDetails.getIsPregnant())
                || checkNull(bcgVaccinationSurveyDetails.getSignificantWeightLoss())
                || checkNull(bcgVaccinationSurveyDetails.getBcgAllergy())
                || checkNull(bcgVaccinationSurveyDetails.getBedRidden())
                || checkNull(bcgVaccinationSurveyDetails.getBloodInSputum())
                || checkNull(bcgVaccinationSurveyDetails.getBloodTransfusion())
                || checkNull(bcgVaccinationSurveyDetails.getConsentUnavailable())
                || checkNull(bcgVaccinationSurveyDetails.getCoughForTwoWeeks())
                || checkNull(bcgVaccinationSurveyDetails.getFeverForTwoWeeks())
                || checkNull(bcgVaccinationSurveyDetails.getIsCancer())
                || checkNull(bcgVaccinationSurveyDetails.getIsHiv())
                || checkNull(bcgVaccinationSurveyDetails.getOnMedication())
                || checkNull(bcgVaccinationSurveyDetails.getTbTreatment())
                || checkNull(bcgVaccinationSurveyDetails.getTbDiagnosed())
                || checkNull(bcgVaccinationSurveyDetails.getIsHighRisk())
                || checkNull(bcgVaccinationSurveyDetails.getTbPreventTherapy())) {

            bcgVaccinationSurveyDetails.setBcgEligible(true);
        }


        if (bcgVaccinationSurveyDetails.getBcgEligible() == null) {
            bcgVaccinationSurveyDetails.setBcgEligible(false);
        }

        //do not set setBcgEligibleFilled() as true in else block
        if (bcgVaccinationSurveyDetails.getBcgWilling() != null && !bcgVaccinationSurveyDetails.getBcgWilling()) {
            bcgVaccinationSurveyDetails.setBcgEligibleFilled(false);
        }

        bcgVaccinationSurveyDao.create(bcgVaccinationSurveyDetails);
        bcgVaccinationSurveyDao.flush();

        updateMemberInfoFromBcgDetails(bcgVaccinationSurveyDetails, member);

        memberDao.update(member);
        memberDao.flush();

        return bcgVaccinationSurveyDetails.getId();
    }

    private static boolean checkNull(Boolean value) {
        return value != null && value;
    }

    @Override
    public Integer storeBcgEligibleForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Integer memberId = Integer.parseInt(keyAndAnswerMap.get("-4"));
        MemberEntity member = memberDao.retrieveById(memberId);
        BcgVaccinationSurveyDetails bcgVaccinationSurveyDetails = bcgVaccinationSurveyDao.retrieveByMemberId(memberId);
        BcgVaccinationSurveyDetails bcgVaccinationSurveyDetailsCopy = new BcgVaccinationSurveyDetails();
        BcgMapper.bcgMapper(bcgVaccinationSurveyDetails, bcgVaccinationSurveyDetailsCopy);
        bcgVaccinationSurveyDetailsCopy.setFilledFrom("BCG_ELIGIBLE");
        bcgVaccinationSurveyDetailsCopy.setBcgEligibleFilled(true);
        bcgVaccinationSurveyDetailsCopy.setBcgWilling(ImtechoUtil.returnTrueFalseFromInitials(keyAndAnswerMap.get("332")));
        updateMemberInfoFromBcgDetails(bcgVaccinationSurveyDetailsCopy, member);
        return bcgVaccinationSurveyDao.create(bcgVaccinationSurveyDetailsCopy);
    }


    private void setAnswersToBcgVaccinationSurveyDetails(String key, String answer, Map<String, String> keyAndAnswerMap, BcgVaccinationSurveyDetails bcgVaccinationSurveyDetails, MemberEntity member, ParsedRecordBean parsedRecordBean) {
        switch (key) {
            case "4":
                bcgVaccinationSurveyDetails.setTbTreatment(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "5":
                bcgVaccinationSurveyDetails.setTbPreventTherapy(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "6":
                bcgVaccinationSurveyDetails.setTbDiagnosed(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7":
                bcgVaccinationSurveyDetails.setCoughForTwoWeeks(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8":
                bcgVaccinationSurveyDetails.setFeverForTwoWeeks(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "9":
                bcgVaccinationSurveyDetails.setSignificantWeightLoss(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "10":
                bcgVaccinationSurveyDetails.setBloodInSputum(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "11":
                bcgVaccinationSurveyDetails.setConsentUnavailable(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "12":
                bcgVaccinationSurveyDetails.setBedRidden(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "13":
                bcgVaccinationSurveyDetails.setIsPregnant(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "14":
                bcgVaccinationSurveyDetails.setIsHiv(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "15":
                bcgVaccinationSurveyDetails.setIsCancer(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "16":
                bcgVaccinationSurveyDetails.setOnMedication(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "17":
                bcgVaccinationSurveyDetails.setOrganTransplant(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "18":
                bcgVaccinationSurveyDetails.setBloodTransfusion(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "19":
                bcgVaccinationSurveyDetails.setBcgAllergy(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "20":
                bcgVaccinationSurveyDetails.setIsHighRisk(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "666":
                bcgVaccinationSurveyDetails.setBeneficiaryType(answer);
                break;
            case "22":
                bcgVaccinationSurveyDetails.setBcgWilling(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "668":
                bcgVaccinationSurveyDetails.setReasonForNotWilling(answer);
                break;
            case "24":
                bcgVaccinationSurveyDetails.setOtherReason(answer);
                break;
            case "444":
                String[] split = answer.split("/");
                if (split.length == 3) {
                    try {
                        bcgVaccinationSurveyDetails.setHeight(Integer.valueOf(split[0]));
                        bcgVaccinationSurveyDetails.setWeight(Float.valueOf(split[1]));
                        bcgVaccinationSurveyDetails.setBmi(Float.valueOf(split[2]));
                    } catch (NumberFormatException e) {
                        bcgVaccinationSurveyDetails.setWeight(Float.valueOf(split[0]));
                        bcgVaccinationSurveyDetails.setHeight(Integer.valueOf(split[1].split("\\.")[0]));
                        bcgVaccinationSurveyDetails.setBmi(Float.valueOf(split[2]));
                    }
                }
                break;
            case "333":
                if (member.getMobileNumber() == null) {
                    member.setMobileNumber(answer);
                }
                break;
//            case "342":
//                member.setAadharNumber(answer);
//                updateAadharToAadharVault(member, parsedRecordBean.getChecksum());
//                break;

            case "9000":
                bcgVaccinationSurveyDetails.setNikshayId(answer);
                break;
            case "9990":
                bcgVaccinationSurveyDetails.setHic(answer);
                break;

            default:
                break;
        }
    }


    private void updateMemberInfoFromBcgDetails(BcgVaccinationSurveyDetails bcgVaccinationSurveyDetails, MemberEntity memberEntity) {
        MemberAdditionalInfo memberAdditionalInfo;
        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }
        memberAdditionalInfo.setBcgSurveyStatus(true);
        memberAdditionalInfo.setBcgWilling(bcgVaccinationSurveyDetails.getBcgWilling());

        if (bcgVaccinationSurveyDetails.getBcgEligible() != null) {
            memberAdditionalInfo.setBcgEligible(bcgVaccinationSurveyDetails.getBcgEligible());
        }
        if (bcgVaccinationSurveyDetails.getBcgEligibleFilled() != null) {
            memberAdditionalInfo.setBcgEligibleFilled(bcgVaccinationSurveyDetails.getBcgEligibleFilled());
        }
        memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
    }


}
