/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.SyncStatusDao;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.service.PatchServiceTwo;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.query.service.QueryMasterService;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.WpdChildDao;
import com.argusoft.imtecho.rch.dao.WpdMotherDao;
import com.argusoft.imtecho.rch.model.ImmunisationMaster;
import com.argusoft.imtecho.rch.model.WpdChildMaster;
import com.argusoft.imtecho.rch.model.WpdMotherMaster;
import com.argusoft.imtecho.rch.service.ImmunisationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.*;

import static com.argusoft.imtecho.mobile.service.impl.PatchServiceImpl.*;

/**
 * @author kunjan
 */

@Service
@Transactional
public class PatchServiceTwoImpl implements PatchServiceTwo {

    @Autowired
    private ImmunisationService immunisationService;

    @Autowired
    MemberDao memberDao;

    @Autowired
    FamilyDao familyDao;

    @Autowired
    WpdChildDao wpdChildDao;

    @Autowired
    WpdMotherDao wpdMotherDao;

    @Autowired
    TechoNotificationMasterDao techoNotificationMasterDao;

    @Autowired
    LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private QueryMasterService queryMasterService;

    @Autowired
    private SyncStatusDao syncStatusDao;

    @Override
    public String storeWpdVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
        Integer memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        Integer familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        Integer locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        Integer pregnancyRegDetId = null;

        if (keyAndAnswerMap.get("-7") != null && !keyAndAnswerMap.get("-7").equals("null")) {
            pregnancyRegDetId = Integer.valueOf(keyAndAnswerMap.get("-7"));
        }

        if (pregnancyRegDetId == null) {
            return "PregRegDetId IS NULL";
        }

        List<WpdMotherMaster> wpdMotherMasters = wpdMotherDao.getWpdMotherMasterByCriteria(pregnancyRegDetId, memberId);
        System.out.println("wpdMotherMasters:" + wpdMotherMasters.size());
        WpdMotherMaster wpdMotherMaster = null;
        for (WpdMotherMaster motherMaster : wpdMotherMasters) {
            if (!wpdChildDao.getWpdChildExistsByWpdMotherId(motherMaster.getId())
                    && motherMaster.getMemberStatus().equals("AVAILABLE")
                    && motherMaster.getHasDeliveryHappened() && motherMaster.getCreatedBy() > 0L
                    && (motherMaster.getPregnancyOutcome().equals("SBIRTH") || motherMaster.getPregnancyOutcome().equals("LBIRTH"))) {
                System.out.println("Assigning Mother WPD");
                wpdMotherMaster = motherMaster;
                break;
            }
        }

        if (wpdMotherMaster == null) {
            return "WPD ID DOES NOT EXIST";
        }

        if (wpdMotherMaster != null && wpdMotherMaster.getMemberStatus().equals("AVAILABLE")
                && wpdMotherMaster.getHasDeliveryHappened() && wpdMotherMaster.getCreatedBy() > 0L
                && (wpdMotherMaster.getPregnancyOutcome().equals("SBIRTH") || wpdMotherMaster.getPregnancyOutcome().equals("LBIRTH"))) {

            MemberEntity motherEntity = memberDao.retrieveById(memberId);
            LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            List<String> keysForWpdMotherMasterQuestions = this.getKeysForWpdMotherMasterQuestions();
            List<String> keysForWpdChildMasterQuestions = this.getKeysForWpdChildMasterQuestions();
            Map<String, String> motherKeyAndAnswerMap = new HashMap<>();
            Map<String, String> childKeyAndAnswerMap = new HashMap<>();

            for (Map.Entry<String, String> keyAnswerSet : keyAndAnswerMap.entrySet()) {
                String key = keyAnswerSet.getKey();
                String answer = keyAnswerSet.getValue();
                if (keysForWpdMotherMasterQuestions.contains(key)) {
                    motherKeyAndAnswerMap.put(key, answer);
                } else {
                    childKeyAndAnswerMap.put(key, answer);
                }
            }

            Map<String, WpdChildMaster> mapOfChildWithLoopIdAsKey = new HashMap();
            for (Map.Entry<String, String> entrySet : childKeyAndAnswerMap.entrySet()) {
                String key = entrySet.getKey();
                String answer = entrySet.getValue();
                WpdChildMaster wpdChildMaster;
                if (key.contains(".")) {
                    String[] splitKey = key.split("\\.");
                    wpdChildMaster = mapOfChildWithLoopIdAsKey.get(splitKey[1]);
                    if (wpdChildMaster == null) {
                        wpdChildMaster = new WpdChildMaster();
                        wpdChildMaster.setFamilyId(familyId);
                        wpdChildMaster.setLocationId(locationId);
                        wpdChildMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
                        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
                            wpdChildMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
                        } else {
                            wpdChildMaster.setMobileStartDate(new Date(0L));
                        }
                        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-9").equals("null")) {
                            wpdChildMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
                        } else {
                            wpdChildMaster.setMobileEndDate(new Date(0L));
                        }
                        wpdChildMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));
                        wpdChildMaster.setWpdMotherId(wpdMotherMaster.getId());
                        wpdChildMaster.setMotherId(memberId);
                        wpdChildMaster.setLatitude(keyAndAnswerMap.get("-2"));
                        wpdChildMaster.setLongitude(keyAndAnswerMap.get("-1"));
                        wpdChildMaster.setDateOfDelivery(wpdMotherMaster.getDateOfDelivery());
                        wpdChildMaster.setMemberStatus(wpdMotherMaster.getMemberStatus());
                        mapOfChildWithLoopIdAsKey.put(splitKey[1], wpdChildMaster);
                    }
                    this.setAnswersToWpdChildMaster(splitKey[0], answer, wpdChildMaster, keyAndAnswerMap, splitKey[1]);
                } else {
                    wpdChildMaster = mapOfChildWithLoopIdAsKey.get("0");
                    if (wpdChildMaster == null) {
                        wpdChildMaster = new WpdChildMaster();
                        wpdChildMaster.setFamilyId(familyId);
                        wpdChildMaster.setLocationId(locationId);
                        wpdChildMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
                        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
                            wpdChildMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
                        } else {
                            wpdChildMaster.setMobileStartDate(new Date(0L));
                        }
                        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
                            wpdChildMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
                        } else {
                            wpdChildMaster.setMobileEndDate(new Date(0L));
                        }
                        wpdChildMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));
                        wpdChildMaster.setWpdMotherId(wpdMotherMaster.getId());
                        wpdChildMaster.setMotherId(memberId);
                        wpdChildMaster.setLatitude(keyAndAnswerMap.get("-2"));
                        wpdChildMaster.setLongitude(keyAndAnswerMap.get("-1"));
                        wpdChildMaster.setDateOfDelivery(wpdMotherMaster.getDateOfDelivery());
                        wpdChildMaster.setMemberStatus(wpdMotherMaster.getMemberStatus());
                        mapOfChildWithLoopIdAsKey.put("0", wpdChildMaster);
                    }
                    this.setAnswersToWpdChildMaster(key, answer, wpdChildMaster, keyAndAnswerMap, null);
                }
            }

            for (Map.Entry<String, WpdChildMaster> entrySet : mapOfChildWithLoopIdAsKey.entrySet()) {
                String loopId = entrySet.getKey();
                WpdChildMaster wpdChildMaster = entrySet.getValue();

                if (wpdChildMaster.getPregnancyOutcome() != null
                        && wpdChildMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)) {

                    MemberEntity childEntity = new MemberEntity();
                    childEntity.setFamilyId(motherEntity.getFamilyId());
                    childEntity.setFirstName("B/o " + motherEntity.getFirstName());
                    childEntity.setMiddleName(motherEntity.getMiddleName());
                    childEntity.setLastName(motherEntity.getLastName());
                    childEntity.setGender(wpdChildMaster.getGender());
                    childEntity.setDob(wpdMotherMaster.getDateOfDelivery());
                    childEntity.setState(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_NEW);
                    childEntity.setUniqueHealthId(familyHealthSurveyService.generateMemberUniqueHealthId());
                    childEntity.setMotherId(memberId);
                    childEntity.setPlaceOfBirth(wpdMotherMaster.getDeliveryPlace());
                    childEntity.setBirthWeight(wpdChildMaster.getBirthWeight());
                    createChildCounter++;
                    memberDao.createMember(childEntity);

                    wpdChildMaster.setMemberId(childEntity.getId());
                    wpdChildMaster.setIsHighRiskCase(this.identifyHighRiskForChildRchWpd(wpdChildMaster));
                    createWpdLiveCounter++;
                    wpdChildDao.create(wpdChildMaster);
                    if (!wpdMotherMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)) {
                        wpdMotherMaster.setPregnancyOutcome(wpdChildMaster.getPregnancyOutcome());
                    }

//                wpdChildMasterWithFieldNameAsKeyMaps.add(this.generateMapWithFieldNameAsKeyForWpdChildMaster(wpdChildMaster));
                    if (!loopId.equals("0")) {
                        if (keyAndAnswerMap.containsKey("85" + "." + loopId)) {
                            StringBuilder immunisationGiven = new StringBuilder();
                            String answer = keyAndAnswerMap.get("85" + "." + loopId).trim();
                            String[] split = answer.split("-");
                            for (String split1 : split) {
                                String[] immunisation = split1.split("/");
                                if (immunisation[1].equalsIgnoreCase("T")) {
                                    ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(), MobileConstantUtil.CHILD_BENEFICIARY,
                                            MobileConstantUtil.WPD_VISIT, wpdChildMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                                            immunisation[0].trim(), new Date(Long.parseLong(immunisation[2])), user.getId(), locationId, locationLevelHierarchy.getId(), null);
                                    if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                                        immunisationService.createImmunisationMaster(immunisationMaster);
                                        immunisationGiven.append(immunisation[0].trim());
                                        immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                                        immunisationGiven.append(sdf.format(new Date(Long.parseLong(immunisation[2]))));
                                        immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                                    }
                                }
                            }

                            if (immunisationGiven.length() > 1) {
                                immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                                if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                                    StringBuilder sb = new StringBuilder(childEntity.getImmunisationGiven());
                                    sb.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                                    sb.append(immunisationGiven);
                                    String immunisation = sb.toString().replace(" ", "");
                                    childEntity.setImmunisationGiven(immunisation);
                                } else {
                                    String immunisation = immunisationGiven.toString().replace(" ", "");
                                    childEntity.setImmunisationGiven(immunisation);
                                }
                                memberDao.update(childEntity);
                            }
                        }
                    } else if (keyAndAnswerMap.containsKey("85")) {
                        StringBuilder immunisationGiven = new StringBuilder();
                        String answer = keyAndAnswerMap.get("85").trim();
                        String[] split = answer.split("-");
                        for (String split1 : split) {
                            String[] immunisation = split1.split("/");
                            if (immunisation[1].equalsIgnoreCase("T")) {
                                ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(), MobileConstantUtil.CHILD_BENEFICIARY,
                                        MobileConstantUtil.WPD_VISIT, wpdChildMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                                        immunisation[0], new Date(Long.parseLong(immunisation[2])), user.getId(), locationId, locationLevelHierarchy.getId(), null);
                                if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                                    immunisationService.createImmunisationMaster(immunisationMaster);
                                    immunisationGiven.append(immunisation[0]);
                                    immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                                    immunisationGiven.append(sdf.format(new Date(Long.parseLong(immunisation[2]))));
                                    immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                                }
                            }
                        }

                        if (immunisationGiven.length() > 1) {
                            immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                            if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                                StringBuilder sb = new StringBuilder(childEntity.getImmunisationGiven());
                                sb.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                                sb.append(immunisationGiven);
                                String immunisation = sb.toString().replace(" ", "");
                                childEntity.setImmunisationGiven(immunisation);
                            } else {
                                String immunisation = immunisationGiven.toString().replace(" ", "");
                                childEntity.setImmunisationGiven(immunisation);
                            }
                            memberDao.update(childEntity);
                        }
                    }

                    //INSERT QUERY FOR SYNCING CHILD NOTIFICATIONS
                    wpdChildDao.insertQueryForPatchNotification(childEntity.getId(), familyId, childEntity.getDob());

                } else if (wpdChildMaster.getPregnancyOutcome() != null
                        && wpdChildMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                    wpdChildMaster.setMemberId(-1);
                    createWpdStillCounter++;
                    wpdChildDao.create(wpdChildMaster);
                }
            }
            wpdChildDao.flush();
            return "SUCCESS";
        }
        return "WPD DOES NOT FALL IN CRITERIA";
    }

    private List<String> getKeysForWpdMotherMasterQuestions() {
        List<String> keys = new ArrayList();
        keys.add("-2");
        keys.add("-1");
        keys.add("1");
        keys.add("2");
        keys.add("3");
        keys.add("51");
        keys.add("511");
        keys.add("4");
        keys.add("41");
        keys.add("9002");
        keys.add("9003");
        keys.add("9004");
        keys.add("9005");
        keys.add("62");
        keys.add("7");
        keys.add("71");
        keys.add("8");
        keys.add("20");
        keys.add("2602");
        keys.add("2603");
        keys.add("26");
        keys.add("11");
        keys.add("93");
        keys.add("12");
        keys.add("13");
        keys.add("1801");
        keys.add("1802");
        keys.add("1902");
        keys.add("19");
        keys.add("9998");
        keys.add("9999");
        return keys;
    }

    private List<String> getKeysForWpdChildMasterQuestions() {
        List<String> keys = new ArrayList();
        keys.add("14");         //Pregnancy Outcome
        keys.add("141");        //Type of delivery
        keys.add("15");         //Gender
        keys.add("16");         //Birth weight
        keys.add("17");         //Congenital deformity present
        keys.add("172");        //Other congential deformity
        keys.add("85");         //Immunization
        keys.add("80");         //Did baby cry at the time of birth?
        keys.add("9994");       //High Risk Case
        return keys;
    }

    public Boolean identifyHighRiskForChildRchWpd(WpdChildMaster wpdChildMaster) {
        return wpdChildMaster.getBirthWeight() != null && wpdChildMaster.getBirthWeight() < 2.6f;
    }


    private void setAnswersToWpdChildMaster(String key, String answer, WpdChildMaster wpdChildMaster, Map<String, String> keyAndAnswerMap, String childCount) {
        switch (key) {
            case "14":
                wpdChildMaster.setPregnancyOutcome(answer);
                break;

            case "141":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH) || keyAndAnswerMap.get("14").equalsIgnoreCase("SBIRTH")) {
                    wpdChildMaster.setTypeOfDelivery(answer);
                }
                break;

            case "15":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                    wpdChildMaster.setGender(answer);
                }
                break;

            case "16":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                    wpdChildMaster.setBirthWeight(Float.valueOf(answer));
                }
                break;

            case "17":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                    if (!answer.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                        Set<Integer> congentialDeformitySet = new HashSet<>();
                        String[] congentialDeformityArray = answer.split(",");
                        for (String congentialDeformityArray1 : congentialDeformityArray) {
                            if (congentialDeformityArray1.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_OTHER)) {
                                if (childCount != null) {
                                    wpdChildMaster.setOtherCongentialDeformity(keyAndAnswerMap.get("172" + "." + childCount));
                                } else {
                                    wpdChildMaster.setOtherCongentialDeformity(keyAndAnswerMap.get("172"));
                                }
                            } else {
                                congentialDeformitySet.add(Integer.valueOf(congentialDeformityArray1));
                            }
                        }
                        wpdChildMaster.setCongentialDeformity(congentialDeformitySet);
                        wpdChildMaster.setIsHighRiskCase(Boolean.TRUE);
                    } else {
                        wpdChildMaster.setIsHighRiskCase(Boolean.FALSE);
                    }
                }
                break;

            case "80":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                    switch (answer) {
                        case "1":
                            wpdChildMaster.setBabyCriedAtBirth(Boolean.TRUE);
                            break;
                        case "2":
                            wpdChildMaster.setBabyCriedAtBirth(Boolean.FALSE);
                            break;
                    }
                }
                break;
        }
    }
}
