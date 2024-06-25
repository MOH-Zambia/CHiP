package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.HealthInfrastructureDetailsDao;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.LocationMobileFeatureDao;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.ChildCerebralPalsyMasterDao;
import com.argusoft.imtecho.rch.dao.ChildServiceDao;
import com.argusoft.imtecho.rch.dto.ChildCerebralPalsyMasterDto;
import com.argusoft.imtecho.rch.dto.ChildServiceMasterDto;
import com.argusoft.imtecho.rch.dto.ImmunisationDto;
import com.argusoft.imtecho.rch.mapper.ChildCerebralPalsyMasterMapper;
import com.argusoft.imtecho.rch.mapper.ChildServiceMapper;
import com.argusoft.imtecho.rch.model.ChildCerebralPalsyMaster;
import com.argusoft.imtecho.rch.model.ChildServiceMaster;
import com.argusoft.imtecho.rch.model.ImmunisationMaster;
import com.argusoft.imtecho.rch.service.ChildService;
import com.argusoft.imtecho.rch.service.ImmunisationService;
import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.*;

/**
 * <p>
 * Define services for child visit.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class ChildServiceImpl implements ChildService {

    @Autowired
    LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    MemberDao memberDao;

    @Autowired
    FamilyDao familyDao;

    @Autowired
    ChildServiceDao childServiceDao;

    @Autowired
    ChildCerebralPalsyMasterDao childCerebralPalsyMasterDao;

    @Autowired
    ImmunisationService immunisationService;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    MobileFhsService mobileFhsService;

    @Autowired
    ImtechoSecurityUser user;

    @Autowired
    private ChildCerebralPalsyMasterDao cerebralPalsyMasterDao;

    @Autowired
    private LocationMobileFeatureDao locationMobileFeatureDao;

    @Autowired
    private HealthInfrastructureDetailsDao healthInfrastructureDetailsDao;

    Set<String> negativeQuestions = new HashSet<>();

    protected static final Map<String, String> cerebralPalsyQuestionIdsMap = new HashMap<>();

    static {
        cerebralPalsyQuestionIdsMap.put("705", "CP1");
        cerebralPalsyQuestionIdsMap.put("707", "CP2");
        cerebralPalsyQuestionIdsMap.put("709", "CP3");
        cerebralPalsyQuestionIdsMap.put("711", "CP4");
        cerebralPalsyQuestionIdsMap.put("713", "CP5");
        cerebralPalsyQuestionIdsMap.put("715", "CP6");
        cerebralPalsyQuestionIdsMap.put("717", "CP7");
        cerebralPalsyQuestionIdsMap.put("719", "CP8");
        cerebralPalsyQuestionIdsMap.put("721", "CP9");
        cerebralPalsyQuestionIdsMap.put("723", "CP10");
        cerebralPalsyQuestionIdsMap.put("725", "CP11");
        cerebralPalsyQuestionIdsMap.put("727", "CP12");
        cerebralPalsyQuestionIdsMap.put("729", "CP13");
        cerebralPalsyQuestionIdsMap.put("731", "CP14");
        cerebralPalsyQuestionIdsMap.put("733", "CP15");
        cerebralPalsyQuestionIdsMap.put("735", "CP16");
        cerebralPalsyQuestionIdsMap.put("737", "CP17");
        cerebralPalsyQuestionIdsMap.put("739", "CP18");
        cerebralPalsyQuestionIdsMap.put("741", "CP19");
        cerebralPalsyQuestionIdsMap.put("743", "CP20");
        cerebralPalsyQuestionIdsMap.put("745", "CP21");
        cerebralPalsyQuestionIdsMap.put("747", "CP22");
        cerebralPalsyQuestionIdsMap.put("749", "CP23");
        cerebralPalsyQuestionIdsMap.put("751", "CP24");
        cerebralPalsyQuestionIdsMap.put("753", "CP25");
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeChildServiceForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {

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

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        MemberEntity childEntity = memberDao.retrieveById(memberId);

        if (childEntity.getState() != null
                && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(childEntity.getState())) {
            throw new ImtechoMobileException("Child is already marked as dead.", 1);
        }
        if (keyAndAnswerMap.get("4") != null) {
            childEntity.setFirstName(keyAndAnswerMap.get("4"));
        }

        if (keyAndAnswerMap.get("5181") != null) {
            childEntity.setGender(keyAndAnswerMap.get("5181"));
        }

        String phone = keyAndAnswerMap.get("9002");
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
        if (phone != null && childEntity.getMotherId() != null) {
            mobileFhsService.updateMemberDetailsFromRchForms(phone, null, null, null, null, memberDao.retrieveById(childEntity.getMotherId()));
        }
        mobileFhsService.updateMemberDetailsFromRchForms(null, aadharMap, aadharNumber, null, null, childEntity);

        ChildServiceMaster childServiceMaster = new ChildServiceMaster();
        childServiceMaster.setMemberId(memberId);
        childServiceMaster.setFamilyId(familyId);
        childServiceMaster.setLocationId(locationId);
        if (locationLevelHierarchy != null) {
            childServiceMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
        }

        ChildCerebralPalsyMaster cerebralPalsyMaster = new ChildCerebralPalsyMaster();
        cerebralPalsyMaster.setMemberId(memberId);
        cerebralPalsyMaster.setDob(childEntity.getDob());

        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
            childServiceMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            childServiceMaster.setMobileStartDate(new Date(0L));
        }
        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-9").equals("null")) {
            childServiceMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            childServiceMaster.setMobileEndDate(new Date(0L));
        }
        childServiceMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));

        boolean createCpEntry = false;
        negativeQuestions.clear();
        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            if (cerebralPalsyQuestionIdsMap.containsKey(key)) {
                createCpEntry = true;
                this.setAnswersToChildCerebralPalsyMaster(key, answer, cerebralPalsyMaster);
            } else {
                this.setAnswersToChildServiceMaster(key, answer, keyAndAnswerMap, childServiceMaster);
            }
        }

        if (keyAndAnswerMap.containsKey("8672") && keyAndAnswerMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                childServiceMaster.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        if (identifyHighRiskForChild(childServiceMaster)) {
            childServiceMaster.setIsHighRiskCase(Boolean.TRUE);
            if (childEntity.getIsHighRiskCase() == null
                    || (childEntity.getIsHighRiskCase() != null && !childEntity.getIsHighRiskCase())) {
                childEntity.setIsHighRiskCase(Boolean.TRUE);
            }
        }

        if (Boolean.FALSE.equals(childServiceMaster.getIsAlive())) {
            mobileFhsService.checkIfMemberDeathEntryExists(memberId);
        }
        childServiceDao.create(childServiceMaster);

        if (createCpEntry) {
            cerebralPalsyMaster.setChildServiceId(childServiceMaster.getId());
            cerebralPalsyMasterDao.create(cerebralPalsyMaster);
        }
        this.updateMemberAdditionalInfo(childEntity, childServiceMaster, user.getId(), keyAndAnswerMap);
        memberDao.update(childEntity);

        List<Integer> immunisationMasterId = new ArrayList<>();

        if (keyAndAnswerMap.containsKey("85")) {
            StringBuilder immunisationGiven = new StringBuilder();
            String answer = keyAndAnswerMap.get("85").replace(" ", "");
            String[] split = answer.split("-");
            for (String split1 : split) {
                String[] immunisation = split1.split("/");
                if (immunisation[1].equalsIgnoreCase("T")) {
                    ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(),
                            MobileConstantUtil.CHILD_BENEFICIARY, MobileConstantUtil.CHILD_SERVICES_VISIT,
                            childServiceMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                            immunisation[0].trim(), new Date(Long.parseLong(immunisation[2])), user.getId(),
                            locationId, locationLevelHierarchy != null ? locationLevelHierarchy.getId() : null,
                            null);
                    if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                        immunisationService.createImmunisationMaster(immunisationMaster);
                        immunisationGiven.append(immunisation[0].trim());
                        immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                        immunisationGiven.append(sdf.format(new Date(Long.parseLong(immunisation[2]))));
                        immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                        immunisationMasterId.add(immunisationMaster.getId());
                    }
                } else {
                    childServiceMaster.setAnyVaccinationPending(Boolean.TRUE);
                    childServiceDao.update(childServiceMaster);
                }
            }

            if (immunisationGiven.length() > 1) {
                immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                    String sb = childEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                    childEntity.setImmunisationGiven(sb);
                } else {
                    childEntity.setImmunisationGiven(immunisationGiven.toString());
                }
            }
        }

        Map<String, String> immMap = new HashMap<>();
        if (keyAndAnswerMap.containsKey("2224")) {
            String ans = keyAndAnswerMap.get("2224");
            if (ans != null && !ans.isEmpty()) {
                Map<String, String> map = new Gson().fromJson(ans, new TypeToken<Map<String, String>>() {
                }.getType());
                immMap.putAll(map);
            }

            if (!immMap.isEmpty()) {
                StringBuilder immunisationGiven = new StringBuilder();
                for (Map.Entry<String, String> entrySet : immMap.entrySet()) {
                    ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(),
                            MobileConstantUtil.CHILD_BENEFICIARY, MobileConstantUtil.CHILD_SERVICES_VISIT,
                            childServiceMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                            entrySet.getKey().trim().toUpperCase(Locale.ROOT), new Date(Long.parseLong(entrySet.getValue())), user.getId(),
                            locationId, locationLevelHierarchy != null ? locationLevelHierarchy.getId() : null, null);
                    immunisationService.createImmunisationMaster(immunisationMaster);
                    immunisationGiven.append(entrySet.getKey().trim().toUpperCase(Locale.ROOT));
                    immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                    immunisationGiven.append(sdf.format(new Date(Long.parseLong(entrySet.getValue()))));
                    immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
                }
                if (immunisationGiven.length() > 1) {
                    immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                    if (childEntity.getImmunisationGiven() != null && !childEntity.getImmunisationGiven().isEmpty()) {
                        String sb = childEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                        childEntity.setImmunisationGiven(sb);
                    } else {
                        childEntity.setImmunisationGiven(immunisationGiven.toString());
                    }
                }
            }
        }

        if (keyAndAnswerMap.get("87") != null && !keyAndAnswerMap.get("87").equals("NONE")) {
            String vaccineGiven = keyAndAnswerMap.get("87");
            Date givenOn = new Date(Long.parseLong(keyAndAnswerMap.get("88")));
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(),
                    MobileConstantUtil.CHILD_BENEFICIARY, MobileConstantUtil.CHILD_SERVICES_VISIT,
                    childServiceMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                    vaccineGiven.trim(), givenOn, user.getId(),
                    locationId, locationLevelHierarchy != null ? locationLevelHierarchy.getId() : null,
                    null);
            StringBuilder immunisationGiven = new StringBuilder();
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(vaccineGiven.trim());
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(givenOn));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }

            if (immunisationGiven.length() > 1) {
                immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                    String sb = childEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                    childEntity.setImmunisationGiven(sb);
                } else {
                    childEntity.setImmunisationGiven(immunisationGiven.toString());
                }
            }
        }

        if (keyAndAnswerMap.get("114") != null && !keyAndAnswerMap.get("114").equals("NONE")) {
            String vaccineGiven = keyAndAnswerMap.get("114");
            Date givenOn = new Date(Long.parseLong(keyAndAnswerMap.get("115")));
            ImmunisationMaster immunisationMaster = new ImmunisationMaster(familyId, childEntity.getId(),
                    MobileConstantUtil.CHILD_BENEFICIARY, MobileConstantUtil.CHILD_SERVICES_VISIT,
                    childServiceMaster.getId(), Integer.valueOf(parsedRecordBean.getNotificationId()),
                    vaccineGiven.trim(), givenOn, user.getId(),
                    locationId, locationLevelHierarchy != null ? locationLevelHierarchy.getId() : null,
                    null);
            StringBuilder immunisationGiven = new StringBuilder();
            if (immunisationService.checkImmunisationEntry(immunisationMaster)) {
                immunisationService.createImmunisationMaster(immunisationMaster);
                immunisationGiven.append(vaccineGiven.trim());
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_DATE_SEPARATOR);
                immunisationGiven.append(sdf.format(givenOn));
                immunisationGiven.append(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR);
            }

            if (immunisationGiven.length() > 1) {
                immunisationGiven.deleteCharAt(immunisationGiven.lastIndexOf(MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR));
                if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                    String sb = childEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                    childEntity.setImmunisationGiven(sb);
                } else {
                    childEntity.setImmunisationGiven(immunisationGiven.toString());
                }
            }
        }

        childServiceDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_CHILD_SERVICE, childServiceMaster.getId()));
        return childServiceMaster.getId();
    }

    /**
     * Identify high risk for child.
     *
     * @param childServiceMaster Child service details.
     * @return Returns true/false based on high risk for child.
     */
    private boolean identifyHighRiskForChild(ChildServiceMaster childServiceMaster) {
        return !CollectionUtils.isEmpty(childServiceMaster.getDieseases())
                || (childServiceMaster.getOtherDiseases() != null && !childServiceMaster.getOtherDiseases().isEmpty())
                || (childServiceMaster.getHavePedalEdema() != null && childServiceMaster.getHavePedalEdema())
                || (childServiceMaster.getMidArmCircumference() != null && childServiceMaster.getMidArmCircumference() < 12.5f) //SAM AND MAM BOTH
                || (childServiceMaster.getSdScore() != null && (childServiceMaster.getSdScore().equals("SD2")
                || childServiceMaster.getSdScore().equals("SD3") || childServiceMaster.getSdScore().equals("SD4")));
    }

    /**
     * Set answer to child service master.
     *
     * @param key              Key.
     * @param answer           Answer for member's child service details.
     * @param keyAndAnswersMap Contains key and answers.
     */
    private void setAnswersToChildServiceMaster(String key, String answer, Map<String, String> keyAndAnswersMap, ChildServiceMaster childServiceMaster) {
        switch (key) {
            case "-2":
                childServiceMaster.setLatitude(answer);
                break;
            case "-1":
                childServiceMaster.setLongitude(answer);
                break;
            case "29":
                childServiceMaster.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "12":
                childServiceMaster.setMemberStatus(answer);
                if (answer.equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    childServiceMaster.setIsAlive(Boolean.FALSE);
                }
                if (answer.equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setIsAlive(Boolean.TRUE);
                }
                break;
            case "120":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    childServiceMaster.setDeathDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "121":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    childServiceMaster.setPlaceOfDeath(answer);
                }
                break;
            case "2705":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (!answer.isEmpty()) {
                        childServiceMaster.setOtherDeathPlace(answer);
                    }
                }
                break;
            case "13":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (answer.equalsIgnoreCase("OTHER")) {
                        childServiceMaster.setDeathReason("-1");
                        childServiceMaster.setOtherDeathReason(keyAndAnswersMap.get("931"));
                    } else if (!answer.equalsIgnoreCase("NONE")) {
                        childServiceMaster.setDeathReason(answer);
                    }
                }
                break;
            case "131":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    childServiceMaster.setDeathInfrastructureId(Integer.valueOf(answer));
                }
                break;
            case "41":
                if (keyAndAnswersMap.get("12").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setDeliveryPlace(answer);
                    if (answer.equals(RchConstants.DELIVERY_PLACE_PRIVATE_HOSPITAL)) {
                        childServiceMaster.setDeliveryPlace(RchConstants.DELIVERY_PLACE_HOSPITAL);
                        childServiceMaster.setTypeOfHospital(893);
                    }
                }
                break;
            case "42":
                if (keyAndAnswersMap.get("12").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswersMap.get("41").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    if (answer.equals("-1")) {
                        childServiceMaster.setHealthInfrastructureId(-1);
                        childServiceMaster.setTypeOfHospital(1013);// 1013 is the Health Infra Type ID for Private Hospital.
                    } else {
                        HealthInfrastructureDetails infra = healthInfrastructureDetailsDao.retrieveById(Integer.valueOf(answer));
                        childServiceMaster.setHealthInfrastructureId(infra.getId());
                        childServiceMaster.setTypeOfHospital(infra.getType());
                    }
                }
                break;
            case "8673":
                if (keyAndAnswersMap.get("12").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswersMap.get("41").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    if (keyAndAnswersMap.get("-20") != null && !keyAndAnswersMap.get("-20").equalsIgnoreCase("null")) {
                        childServiceMaster.setHealthInfrastructureId(Integer.valueOf(keyAndAnswersMap.get("-20")));
                    }
                }
                break;
            case "7":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    String weight = null;
                    if (answer.contains("F/")) {
                        weight = answer.replace("F/", "");
                    }
                    if (answer.contains("T")) {
                        weight = answer.replace("T", "");
                    }
                    if (weight != null && !weight.trim().equalsIgnoreCase("null")
                            && !weight.trim().equalsIgnoreCase("")) {
                        childServiceMaster.setWeight(Float.valueOf(weight));
                    }
                }
                break;
            case "8":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setIfaSyrupGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "9":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setComplementaryFeedingStarted(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "91":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setComplementaryFeedingStartPeriod(answer);
                }
                break;
            case "10":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    Set<Integer> diseasesSet = new HashSet<>();
                    String[] diseasesArray = answer.split(",");
                    for (String s : diseasesArray) {
                        if (s.equalsIgnoreCase("OTHER")) {
                            childServiceMaster.setOtherDiseases(keyAndAnswersMap.get("93"));
                        } else if (!s.equalsIgnoreCase("NONE")) {
                            diseasesSet.add(Integer.valueOf(s));
                        }
                        childServiceMaster.setDieseases(diseasesSet);
                    }
                }
                break;
            case "11":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    switch (answer) {
                        case "1":
                            childServiceMaster.setIsTreatementDone("YES");
                            break;
                        case "2":
                            childServiceMaster.setIsTreatementDone("NO");
                            break;
                        case "3":
                            childServiceMaster.setIsTreatementDone("NOT_REQUIRED");
                            break;
                        default:
                    }
                }
                break;
            case "852":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setMidArmCircumference(Float.valueOf(answer));
                }
                break;
            case "853":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setHeight(Integer.valueOf(answer.split("\\.")[0]));
                }
                break;
            case "854":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setHavePedalEdema(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "857":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setExclusivelyBreastfeded(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "2222":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setGuardianOneMobileNumber(answer);
                }
                break;
            case "2223":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setGuardianTwoMobileNumber(answer);
                }
                break;
            case "7555":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    Set<Integer> symptomsSet = new HashSet<>();
                    String[] diseasesArray = answer.split(",");
                    for (String s : diseasesArray) {
                        if (s.equalsIgnoreCase("OTHER")) {
                            childServiceMaster.setOtherSymptoms(keyAndAnswersMap.get("7558"));
                        } else if (!s.equalsIgnoreCase("NONE")) {
                            symptomsSet.add(Integer.valueOf(s));
                        }
                        childServiceMaster.setSymptoms(symptomsSet);
                    }
                }
                break;
            case "7702":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setDelaysObserved(answer);
                }
                break;
            case "8989":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "25":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setReferralPlace(Integer.valueOf(answer));
                }
                break;
            case "3333":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setReferralFor(answer);
                }
                break;
            case "3335":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setReferralReason(answer);
                }
                break;
            case "2229":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    Set<Integer> disabilities = new HashSet<>();
                    answer = answer.replace("OTHER", "");
                    for (String id : answer.split(",")) {
                        if (!"NONE".equals(id) && !"OTHER".contains(id) && !id.equals("null")) {
                            disabilities.add(Integer.parseInt(id));
                        }
                    }
                    childServiceMaster.setDisabilitiesDetails(disabilities);
                }
                break;
            case "2231":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setOtherDisability(answer);
                }
                break;
            case "2221":
                if (keyAndAnswersMap.get("12").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    childServiceMaster.setDelayInDevelopmental(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            default:
        }
    }

    /**
     * Set answer to child cerebral palsy master.
     *
     * @param key                 Key.
     * @param stringAnswer        Answer for member's child cerebral palsy master.
     * @param cerebralPalsyMaster Child cerebral palsy master details.
     */
    private void setAnswersToChildCerebralPalsyMaster(String key, String stringAnswer, ChildCerebralPalsyMaster cerebralPalsyMaster) {
        boolean answer = false;
        if (stringAnswer.equals("T")) {
            answer = true;
        }
        switch (key) {
            case "705": //CP1
                cerebralPalsyMaster.setHoldHeadStraight(answer);
                break;
            case "707": //CP2
                cerebralPalsyMaster.setHandsInMouth(answer);
                break;
            case "709": //CP3
                cerebralPalsyMaster.setLookWhenSpeak(answer);
                break;
            case "711": //CP4
                cerebralPalsyMaster.setMakeNoiseWhenSpeak(answer);
                break;
            case "713": //CP5
                cerebralPalsyMaster.setLookInDirectionOfSound(answer);
                break;
            case "715": //CP6
                cerebralPalsyMaster.setSitWithoutHelp(answer);
                break;
            case "717": //CP7
                cerebralPalsyMaster.setKneelDown(answer);
                break;
            case "719": //CP8
                cerebralPalsyMaster.setAvoidStrangers(answer);
                break;
            case "721": //CP9
                cerebralPalsyMaster.setUnderstandNo(answer);
                break;
            case "723": //CP10
                cerebralPalsyMaster.setEnjoyPeekaboo(answer);
                break;
            case "725": //CP11
                cerebralPalsyMaster.setRespondsOnNameCalling(answer);
                break;
            case "727": //CP12
                cerebralPalsyMaster.setLiftToys(answer);
                break;
            case "729": //CP13
                cerebralPalsyMaster.setMimicOthers(answer);
                break;
            case "731": //CP14
                cerebralPalsyMaster.setDrinkFromGlass(answer);
                break;
            case "733": //CP15
                cerebralPalsyMaster.setRunIndependently(answer);
                break;
            case "735": //CP16
                cerebralPalsyMaster.setHoldThingsWithFinger(answer);
                break;
            case "737": //CP17
                cerebralPalsyMaster.setLookWhenNameCalled(answer);
                break;
            case "739": //CP18
                cerebralPalsyMaster.setSpeakSimpleWords(answer);
                break;
            case "741": //CP19
                cerebralPalsyMaster.setUnderstandInstructions(answer);
                break;
            case "743": //CP20
                cerebralPalsyMaster.setTellNameOfThings(answer);
                break;
            case "745": //CP21
                cerebralPalsyMaster.setFlipPages(answer);
                break;
            case "747": //CP22
                cerebralPalsyMaster.setKickBall(answer);
                break;
            case "749": //CP23
                cerebralPalsyMaster.setClimbUpDownStairs(answer);
                break;
            case "751": //CP24
                cerebralPalsyMaster.setSpeakTwoSentences(answer);
                break;
            case "753": //CP25
                cerebralPalsyMaster.setLikePlayingWithOtherChildren(answer);
                break;
            default:
        }
        if (!answer) {
            negativeQuestions.add(key);
        } else {
            negativeQuestions.remove(key);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String retrieveMedicalComplications(Integer memberId) {
        return childServiceDao.retrieveMedicalComplications(memberId);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void create(ChildServiceMasterDto childServiceMasterDto) {
        MemberEntity childEntity = memberDao.retrieveById(childServiceMasterDto.getMemberId());

        ChildServiceMaster childServiceMaster = ChildServiceMapper.convertDtoToEntity(childServiceMasterDto);

        if (childServiceMaster.getLocationHierarchyId() == null) {
            childServiceMaster.setLocationHierarchyId(locationLevelHierarchyDao.retrieveByLocationId(childServiceMaster.getLocationId()).getId());
        }

        if (childServiceMasterDto.getContactNumber() != null) {
            childEntity.setMobileNumber(childServiceMasterDto.getContactNumber());
        }

        if (childServiceMaster.getTypeOfHospital() == null) {
            HealthInfrastructureDetails healthInfrastructureDetails = healthInfrastructureDetailsDao.retrieveById(childServiceMaster.getHealthInfrastructureId());
            childServiceMaster.setTypeOfHospital(healthInfrastructureDetails.getType());
        }

        childServiceDao.create(childServiceMaster);
        if (childServiceMasterDto.getCerebralDetails() != null) {
            checkForNegativeAnswersInChildCelebral(childServiceMasterDto.getCerebralDetails());
            ChildCerebralPalsyMaster childCerebralPalsyMaster = ChildCerebralPalsyMasterMapper.convertDtoToEntity(childServiceMasterDto.getCerebralDetails());
            childCerebralPalsyMaster.setMemberId(childServiceMasterDto.getMemberId());
            childCerebralPalsyMaster.setChildServiceId(childServiceMaster.getId());
            childCerebralPalsyMaster.setDob(childEntity.getDob());
            childCerebralPalsyMasterDao.create(childCerebralPalsyMaster);
            updateMemberAdditionalInfo(childEntity, childServiceMaster, user.getId(), null);
        }

        updateImmunisationGivenInChild(childServiceMasterDto, childServiceMaster, childEntity);
        memberDao.update(childEntity);

        childServiceDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_CHILD_SERVICE, childServiceMaster.getId()));
    }

    private void updateImmunisationGivenInChild(ChildServiceMasterDto childServiceMasterDto, ChildServiceMaster childServiceMaster, MemberEntity childEntity) {
        if (childServiceMasterDto.getImmunisationDtos() != null) {
            StringBuilder immunisationGiven = new StringBuilder();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            for (ImmunisationDto immunisationDto : childServiceMasterDto.getImmunisationDtos()) {
                ImmunisationMaster immunisationMaster = new ImmunisationMaster(childServiceMaster.getFamilyId(), childServiceMaster.getMemberId(),
                        MobileConstantUtil.CHILD_BENEFICIARY,
                        MobileConstantUtil.CHILD_SERVICES_VISIT, childServiceMaster.getId(), null,
                        immunisationDto.getImmunisationGiven().trim(), immunisationDto.getImmunisationDate(), user.getId(),
                        childServiceMaster.getLocationId(), childServiceMaster.getLocationHierarchyId(), null);
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
                if (childEntity.getImmunisationGiven() != null && childEntity.getImmunisationGiven().length() > 0) {
                    String sb = childEntity.getImmunisationGiven() + MobileConstantUtil.IMMUNISATION_NAME_SEPARATOR + immunisationGiven;
                    String immunisation = sb.replace(" ", "");
                    childEntity.setImmunisationGiven(immunisation);
                } else {
                    String immunisation = immunisationGiven.toString().replace(" ", "");
                    childEntity.setImmunisationGiven(immunisation);
                }
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public ChildServiceMasterDto getLastChildVisit(Integer memberId) {
        ChildServiceMaster lastChildVisit = childServiceDao.getLastChildVisit(memberId);
        if (lastChildVisit != null) {
            return ChildServiceMapper.convertEntityToDto(lastChildVisit);
        } else {
            return null;
        }
    }

    /**
     * Check for negatives answers in child cerebral question.
     *
     * @param childCerebralPalsyMasterDto Child cerebral palsy questions details.
     */
    private void checkForNegativeAnswersInChildCelebral(ChildCerebralPalsyMasterDto childCerebralPalsyMasterDto) {
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getHoldHeadStraight())) {
            negativeQuestions.add("705");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getHandsInMouth())) {
            negativeQuestions.add("707");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getLookWhenSpeak())) {
            negativeQuestions.add("709");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getMakeNoiseWhenSpeak())) {
            negativeQuestions.add("711");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getLookInDirectionOfSound())) {
            negativeQuestions.add("713");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getSitWithoutHelp())) {
            negativeQuestions.add("715");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getKneelDown())) {
            negativeQuestions.add("717");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getAvoidStrangers())) {
            negativeQuestions.add("719");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getUnderstandNo())) {
            negativeQuestions.add("721");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getEnjoyPeekaboo())) {
            negativeQuestions.add("723");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getRespondsOnNameCalling())) {
            negativeQuestions.add("725");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getLiftToys())) {
            negativeQuestions.add("727");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getMimicOthers())) {
            negativeQuestions.add("729");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getDrinkFromGlass())) {
            negativeQuestions.add("731");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getRunIndependently())) {
            negativeQuestions.add("733");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getHoldThingsWithFinger())) {
            negativeQuestions.add("735");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getLookWhenNameCalled())) {
            negativeQuestions.add("737");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getSpeakSimpleWords())) {
            negativeQuestions.add("739");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getUnderstandInstructions())) {
            negativeQuestions.add("741");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getTellNameOfThings())) {
            negativeQuestions.add("743");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getFlipPages())) {
            negativeQuestions.add("745");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getKickBall())) {
            negativeQuestions.add("747");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getClimbUpDownStairs())) {
            negativeQuestions.add("749");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getSpeakTwoSentences())) {
            negativeQuestions.add("751");
        }
        if (Boolean.FALSE.equals(childCerebralPalsyMasterDto.getLikePlayingWithOtherChildren())) {
            negativeQuestions.add("753");
        }
    }

    /**
     * Update additional info for child service visit.
     *
     * @param childEntity        Child details.
     * @param childServiceMaster Child service master details.
     */
    private void updateMemberAdditionalInfo(MemberEntity childEntity, ChildServiceMaster childServiceMaster,
                                            Integer userId, Map<String, String> keyAndAnswerMap) {
        Gson gson = new Gson();
        MemberAdditionalInfo additionalInfo;
        if (childEntity.getAdditionalInfo() != null && !childEntity.getAdditionalInfo().isEmpty()) {
            additionalInfo = gson.fromJson(childEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            additionalInfo = new MemberAdditionalInfo();
        }
        if (!CollectionUtils.isEmpty(negativeQuestions)) {
            if (!CollectionUtils.isEmpty(additionalInfo.getCpNegativeQues())) {
                additionalInfo.getCpNegativeQues().addAll(negativeQuestions);
                childEntity.setAdditionalInfo(gson.toJson(additionalInfo));
            } else {
                additionalInfo.setCpNegativeQues(negativeQuestions);
            }
            childServiceDao.createSuspectedCpEntry(childEntity.getId(), familyDao.retrieveFamilyByFamilyId(childEntity.getFamilyId()).getLocationId(), childServiceMaster.getId(), userId);
            childEntity.setSuspectedCp(Boolean.TRUE);
        } else {
            additionalInfo.setCpNegativeQues(null);
        }
        if (childServiceMaster.getServiceDate() != null) {
            additionalInfo.setLastServiceLongDate(childServiceMaster.getServiceDate().getTime());
        }
        if (childServiceMaster.getDelayInDevelopmental() != null && childServiceMaster.getDelayInDevelopmental()) {
            additionalInfo.setDevelopmentDelays(childServiceMaster.getDelayInDevelopmental());
        }
        if (childServiceMaster.getWeight() != null) {
            childEntity.setWeight(childServiceMaster.getWeight());
            if (additionalInfo.getWeightMap() != null && childServiceMaster.getWeight() != null) {
                additionalInfo.getWeightMap().put(childServiceMaster.getServiceDate().getTime(), childServiceMaster.getWeight());
            } else {
                LinkedHashMap<Long, Float> weightMap = new LinkedHashMap<>();
                weightMap.put(childServiceMaster.getServiceDate().getTime(), childServiceMaster.getWeight());
                additionalInfo.setWeightMap(weightMap);
            }
        }
        if (keyAndAnswerMap != null && keyAndAnswerMap.containsKey("7007")
                && keyAndAnswerMap.get("7007") != null) {
            childEntity.setRchId(keyAndAnswerMap.get("7007"));
            additionalInfo.setRchId(keyAndAnswerMap.get("7007"));
        }
        childEntity.setAdditionalInfo(gson.toJson(additionalInfo));
    }
}
