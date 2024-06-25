package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.HealthInfrastructureDetailsDao;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.notification.dao.NotificationTypeMasterDao;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.notification.model.NotificationTypeMaster;
import com.argusoft.imtecho.notification.model.TechoNotificationMaster;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.AshaReportedEventDao;
import com.argusoft.imtecho.rch.dao.WpdChildDao;
import com.argusoft.imtecho.rch.dao.WpdMotherDao;
import com.argusoft.imtecho.rch.model.AshaReportedEventMaster;
import com.argusoft.imtecho.rch.model.ImmunisationMaster;
import com.argusoft.imtecho.rch.model.WpdChildMaster;
import com.argusoft.imtecho.rch.model.WpdMotherMaster;
import com.argusoft.imtecho.rch.service.AshaReportedEventService;
import com.argusoft.imtecho.rch.service.IMomCareWpdService;
import com.argusoft.imtecho.rch.service.ImmunisationService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Transactional
public class IMomCareWpdServiceImpl implements IMomCareWpdService {

    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;

    @Autowired
    private NotificationTypeMasterDao notificationTypeMasterDao;

    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private WpdChildDao wpdChildDao;

    @Autowired
    private WpdMotherDao wpdMotherDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private ImmunisationService immunisationService;

    @Autowired
    private MobileFhsService mobileFhsService;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;


    @Autowired
    private AshaReportedEventService ashaReportedEventService;

    @Autowired
    private AshaReportedEventDao ashaReportedEventDao;

    @Autowired
    private HealthInfrastructureDetailsDao healthInfrastructureDetailsDao;

    @Override
    public Integer storeWpdVisitForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
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

//        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        MemberEntity motherEntity = memberDao.retrieveById(memberId);
        Integer pregnancyRegDetId = null;

        if (keyAndAnswerMap.get("-7") != null && !keyAndAnswerMap.get("-7").equals("null")) {
            pregnancyRegDetId = Integer.valueOf(keyAndAnswerMap.get("-7"));
        }

        if (motherEntity.getState() != null && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(motherEntity.getState())) {
            throw new ImtechoMobileException("Mother is already marked as dead.", 1);
        }
        if (motherEntity.getIsPregnantFlag() == null || !motherEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is not marked as pregnant.", 1);
        }

        if (motherEntity.getCurPregRegDetId() != null) {
            pregnancyRegDetId = motherEntity.getCurPregRegDetId();
        }
        if (pregnancyRegDetId == null && ConstantUtil.DROP_TYPE.equals("P")) {
            if (motherEntity.getState().equals(FamilyHealthSurveyServiceConstants.FHS_MEMBER_STATE_UNVERIFIED) || FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_ARCHIVED.contains(motherEntity.getState())) {
                throw new ImtechoMobileException("Member is not verified. Please Verified thru FHS.", 1);
            }
            throw new ImtechoUserException("Pregnancy Registration Details has not been generated yet.", 1);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String phone = keyAndAnswerMap.get("9002");
        String aadharMap = null;
        String aadharNumber = null;

        mobileFhsService.updateMemberDetailsFromRchForms(phone, aadharMap, aadharNumber, null, null, motherEntity);

        WpdMotherMaster wpdMotherMaster = new WpdMotherMaster();
        wpdMotherMaster.setMemberId(memberId);
        wpdMotherMaster.setFamilyId(familyId);
        wpdMotherMaster.setLocationId(locationId);
        wpdMotherMaster.setPregnancyRegDetId(pregnancyRegDetId);
        wpdMotherMaster.setLocationHierarchyId(-1);
        if (keyAndAnswerMap.get("-8") != null && !keyAndAnswerMap.get("-8").equals("null")) {
            wpdMotherMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            wpdMotherMaster.setMobileStartDate(new Date(0L));
        }
        if (keyAndAnswerMap.get("-9") != null && !keyAndAnswerMap.get("-9").equals("null")) {
            wpdMotherMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            wpdMotherMaster.setMobileEndDate(new Date(0L));
        }
        wpdMotherMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));

        if (keyAndAnswerMap.get("7") != null && keyAndAnswerMap.get("7").equalsIgnoreCase("2")) {
            if (keyAndAnswerMap.get("-1") != null) {
                wpdMotherMaster.setLongitude(keyAndAnswerMap.get("-1"));
            }
            if (keyAndAnswerMap.get("-2") != null) {
                wpdMotherMaster.setLatitude(keyAndAnswerMap.get("-2"));
            }
            if (keyAndAnswerMap.get("6") != null) {
                wpdMotherMaster.setMemberStatus(keyAndAnswerMap.get("6"));
            }
            wpdMotherMaster.setHasDeliveryHappened(false);

            if (Boolean.FALSE.equals(wpdMotherMaster.getMotherAlive())) {
                mobileFhsService.checkIfMemberDeathEntryExists(memberId);
            }
            wpdMotherDao.create(wpdMotherMaster);
            wpdMotherDao.flush();
            this.updateMemberAdditionalInfo(motherEntity, wpdMotherMaster, keyAndAnswerMap);
            eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_WPD, wpdMotherMaster.getId()));
            return wpdMotherMaster.getId();
        }

        List<String> keysForWpdMotherMasterQuestions = this.getKeysForWpdMotherMasterQuestions();
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

        for (Map.Entry<String, String> entrySet : motherKeyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToWpdMotherMaster(key, answer, wpdMotherMaster, keyAndAnswerMap);
        }

        if (keyAndAnswerMap.get("14") != null) {
            wpdMotherMaster.setPregnancyOutcome(keyAndAnswerMap.get("14"));
        }

        if (keyAndAnswerMap.get("19") != null) {
            wpdMotherMaster.setTypeOfDelivery(keyAndAnswerMap.get("19"));
        }

        if (wpdMotherMaster.getMotherAlive() != null && !wpdMotherMaster.getMotherAlive()
                && wpdMotherMaster.getDeliveryPlace() != null
                && wpdMotherMaster.getDeliveryPlace().equals(RchConstants.DELIVERY_PLACE_HOSPITAL)
                && wpdMotherMaster.getDeathDate() != null) {
            wpdMotherMaster.setIsDischarged(Boolean.TRUE);
            wpdMotherMaster.setDischargeDate(wpdMotherMaster.getDeathDate());
        }

        if (wpdMotherMaster.getReferralDone() != null
                && wpdMotherMaster.getReferralDone().equals(RchConstants.REFFERAL_DONE_YES)
                && wpdMotherMaster.getDeliveryPlace() != null
                && wpdMotherMaster.getDeliveryPlace().equals(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
            wpdMotherMaster.setIsDischarged(Boolean.TRUE);
            wpdMotherMaster.setDischargeDate(wpdMotherMaster.getDateOfDelivery());
        }

        wpdMotherDao.create(wpdMotherMaster);
        this.updateMemberAdditionalInfo(motherEntity, wpdMotherMaster, keyAndAnswerMap);

        if (parsedRecordBean.getNotificationId() != null && !parsedRecordBean.getNotificationId().equals("-1")) {
            TechoNotificationMaster notificationMaster = techoNotificationMasterDao.retrieveById(Integer.parseInt(parsedRecordBean.getNotificationId()));
            if (notificationMaster != null) {
                NotificationTypeMaster notificationTypeMaster = notificationTypeMasterDao.retrieveById(notificationMaster.getNotificationTypeId());
                if (notificationTypeMaster != null && notificationTypeMaster.getCode() != null
                        && notificationTypeMaster.getCode().equals(MobileConstantUtil.NOTIFICATION_FHW_DELIVERY_CONF)) {
                    ashaReportedEventService.createReadOnlyNotificationForAsha(true, MobileConstantUtil.NOTIFICATION_FHW_DELIVERY_CONF,
                            motherEntity, familyDao.retrieveById(familyId), user);
                }

                if (notificationMaster.getRelatedId() != null && notificationMaster.getOtherDetails() != null
                        && notificationMaster.getOtherDetails().equals(MobileConstantUtil.ASHA_REPORT_MEMBER_DELIVERY)) {
                    AshaReportedEventMaster eventMaster = ashaReportedEventDao.retrieveById(notificationMaster.getRelatedId());
                    eventMaster.setAction(RchConstants.ASHA_REPORTED_EVENT_CONFIRMED);
                    eventMaster.setActionOn(new Date(Long.parseLong(parsedRecordBean.getMobileDate())));
                    eventMaster.setActionBy(user.getId());
                    ashaReportedEventDao.update(eventMaster);
                }
            }
        }

        if (wpdMotherMaster.getHasDeliveryHappened() != null && !wpdMotherMaster.getHasDeliveryHappened()) {
            motherEntity.setModifiedOn(new Date());
        }

        Map<String, WpdChildMaster> mapOfChildWithLoopIdAsKey = new HashMap<>();
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
                    wpdChildMaster.setLocationHierarchyId(-1);
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
                    wpdChildMaster.setBreastFeedingInOneHour(wpdMotherMaster.getBreastFeedingInOneHour());
                    mapOfChildWithLoopIdAsKey.put(splitKey[1], wpdChildMaster);
                }
                this.setAnswersToWpdChildMaster(splitKey[0], answer, wpdChildMaster, keyAndAnswerMap, splitKey[1]);
            } else {
                wpdChildMaster = mapOfChildWithLoopIdAsKey.get("0");
                if (wpdChildMaster == null) {
                    wpdChildMaster = new WpdChildMaster();
                    wpdChildMaster.setFamilyId(familyId);
                    wpdChildMaster.setLocationId(locationId);
                    wpdChildMaster.setLocationHierarchyId(-1);
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
                    wpdMotherMaster.setTypeOfDelivery(keyAndAnswerMap.get("19"));
                    wpdChildMaster.setMemberStatus(wpdMotherMaster.getMemberStatus());
                    wpdChildMaster.setBreastFeedingInOneHour(wpdMotherMaster.getBreastFeedingInOneHour());
                    mapOfChildWithLoopIdAsKey.put("0", wpdChildMaster);
                }
                this.setAnswersToWpdChildMaster(key, answer, wpdChildMaster, keyAndAnswerMap, null);
            }
        }

        for (Map.Entry<String, WpdChildMaster> entrySet : mapOfChildWithLoopIdAsKey.entrySet()) {
            String loopId = entrySet.getKey();
            WpdChildMaster wpdChildMaster = entrySet.getValue();

            if (wpdChildMaster.getPregnancyOutcome() != null
                    && (wpdChildMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                    || wpdChildMaster.getPregnancyOutcome().equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE))) {

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
                childEntity.setIsHighRiskCase(this.identifyHighRiskForChildRchWpd(wpdChildMaster, wpdMotherMaster));
                childEntity.setMaritalStatus(ConstantUtil.LIST_VALUE_UNMARRIED);

                memberDao.createMember(childEntity);

                wpdChildMaster.setMemberId(childEntity.getId());
                wpdChildMaster.setIsHighRiskCase(childEntity.getIsHighRiskCase());
                wpdChildMaster.setName(childEntity.getFirstName());
                wpdChildDao.create(wpdChildMaster);
                if (!wpdMotherMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || !wpdMotherMaster.getPregnancyOutcome().equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    wpdMotherMaster.setPregnancyOutcome(wpdChildMaster.getPregnancyOutcome());
                    wpdMotherDao.update(wpdMotherMaster);
                }
            } else if (wpdChildMaster.getPregnancyOutcome() != null
                    && wpdChildMaster.getPregnancyOutcome().equals(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)) {
                wpdChildMaster.setMemberId(-1);
                wpdChildDao.create(wpdChildMaster);
            }
        }
        wpdChildDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_WPD, wpdMotherMaster.getId()));
        return wpdMotherMaster.getId();
    }

    private void setAnswersToWpdMotherMaster(String key, String answer, WpdMotherMaster wpdMotherMaster, Map<String, String> keyAndAnswerMap) {
        switch (key) {
            case "-2":
                wpdMotherMaster.setLatitude(answer);
                break;
            case "-1":
                wpdMotherMaster.setLongitude(answer);
                break;
            case "6":
                wpdMotherMaster.setMemberStatus(answer);
                break;
            case "7":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    wpdMotherMaster.setHasDeliveryHappened(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "8":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTime(new Date(Long.parseLong(answer)));
                    calendar.set(Calendar.HOUR_OF_DAY, 0);
                    calendar.set(Calendar.MINUTE, 0);
                    calendar.set(Calendar.SECOND, 0);
                    wpdMotherMaster.setDateOfDelivery(calendar.getTime());
                }
                break;
            case "102":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    wpdMotherMaster.setCorticoSteroidGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "11":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    wpdMotherMaster.setDeliveryPlace(answer);
                    if (answer.equals(RchConstants.DELIVERY_PLACE_PRIVATE_HOSPITAL)) {
                        wpdMotherMaster.setDeliveryPlace(RchConstants.DELIVERY_PLACE_HOSPITAL);
                        wpdMotherMaster.setTypeOfHospital(893);
                    }
                }
                break;
            case "72"://Health Infra Id
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    if (answer.equals("-1")) {
                        wpdMotherMaster.setHealthInfrastructureId(-1);
                        wpdMotherMaster.setTypeOfHospital(1013);// 1013 is the Health Infra Type ID for Private Hospital.
                    } else {
                        HealthInfrastructureDetails infra = healthInfrastructureDetailsDao.retrieveById(Integer.valueOf(answer));
                        wpdMotherMaster.setHealthInfrastructureId(infra.getId());
                        wpdMotherMaster.setTypeOfHospital(infra.getType());
                    }
                }
                break;
            case "81":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    wpdMotherMaster.setDeliveryDoneBy(answer);
                }
                break;
            case "12":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    wpdMotherMaster.setMotherAlive(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "140":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equalsIgnoreCase("2")) {
                    wpdMotherMaster.setDeathDate(new Date(Long.parseLong(answer)));
                }
                break;

            case "15":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equalsIgnoreCase("2")) {
                    wpdMotherMaster.setPlaceOfDeath(answer);
                }
                break;

            case "16":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equals("2")) {
                    if (answer.equals("OTHER")) {
                        wpdMotherMaster.setDeathReason("-1");
                    } else if (!answer.equals("NONE")) {
                        wpdMotherMaster.setDeathReason(answer);
                    }
                }
                break;
            case "2607":
                wpdMotherMaster.setDeathInfrastructureId(Integer.valueOf(answer));
                break;
            case "1605":
                wpdMotherMaster.setOtherDeathReason(answer);
                break;
            case "17":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equals("1")) {
                    if (!answer.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                        Set<Integer> motherDangerSignsSet = new HashSet<>();
                        String[] motherDangerSignsArray = answer.split(",");
                        for (String motherDangerSignsId : motherDangerSignsArray) {
                            if (motherDangerSignsId.equals(RchConstants.DANGEROUS_SIGN_OTHER)) {
                                wpdMotherMaster.setOtherDangerSigns(keyAndAnswerMap.get("1703"));
                            } else {
                                motherDangerSignsSet.add(Integer.valueOf(motherDangerSignsId));
                            }
                        }
                        wpdMotherMaster.setMotherDangerSigns(motherDangerSignsSet);
                        wpdMotherMaster.setIsHighRiskCase(Boolean.TRUE);
                    } else {
                        wpdMotherMaster.setIsHighRiskCase(Boolean.FALSE);
                    }
                }
                break;
            case "18":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equals("1")) {
                    switch (answer) {
                        case "1":
                            wpdMotherMaster.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                            break;
                        case "2":
                            wpdMotherMaster.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                            break;
                        case "3":
                            wpdMotherMaster.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                            break;
                        default:
                    }
                }
            case "8001":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("12").equals("1")
                        && keyAndAnswerMap.get("18").equals("1")) {
                    wpdMotherMaster.setReferralInfraId(Integer.valueOf(answer));
                }
                break;
            case "19":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && keyAndAnswerMap.get("11").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    wpdMotherMaster.setTypeOfDelivery(answer);
                }
                break;
            case "2100":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")){
                    wpdMotherMaster.setBreastFeedingInOneHour(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "104":
            case "106":
                wpdMotherMaster.setPregnancyOutcome(answer);
                switch (answer) {
                    case "SPONT_ABORTION":
                        wpdMotherMaster.setDeliveryPlace(RchConstants.DELIVERY_PLACE_HOME);
                        break;
                    case "ABORTION":
                    case "MTP":
                        wpdMotherMaster.setDeliveryPlace(RchConstants.DELIVERY_PLACE_HOSPITAL);
                        break;
                    default:
                }
            case "1902":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")) {
                    wpdMotherMaster.setIsDischarged(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "1903":
                if (keyAndAnswerMap.get("6").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("7").equalsIgnoreCase("1")
                        && (keyAndAnswerMap.get("1902") == null || keyAndAnswerMap.get("1902").equalsIgnoreCase("1"))) {
                    wpdMotherMaster.setDischargeDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "74":
                wpdMotherMaster.setMisoprostolGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            default:
        }
    }

    private void setAnswersToWpdChildMaster(String key, String answer, WpdChildMaster wpdChildMaster, Map<String, String> keyAndAnswerMap, String childCount) {
        switch (key) {
            case "14":
                wpdChildMaster.setPregnancyOutcome(answer);
                break;

            case "19":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH) ||
                        keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    wpdChildMaster.setTypeOfDelivery(answer);
                }
                break;

            case "20":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    wpdChildMaster.setGender(answer);
                }
                break;
            case "8003":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    switch (answer) {
                        case "1":
                            wpdChildMaster.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                            break;
                        case "2":
                            wpdChildMaster.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                            break;
                        case "3":
                            wpdChildMaster.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                            break;
                        default:
                    }
                }
                break;
            case "8004":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        && keyAndAnswerMap.get("8003").equals("1")) {
                    wpdChildMaster.setReferralInfraId(Integer.valueOf(answer));
                }
                break;
            case "21":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    wpdChildMaster.setBirthWeight(Float.valueOf(answer));
                }
                break;
            case "24":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    if (!answer.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                        Set<Integer> congentialDeformitySet = new HashSet<>();
                        String[] congentialDeformityArray = answer.split(",");
                        for (String congentialDeformityArray1 : congentialDeformityArray) {
                            if (congentialDeformityArray1.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_OTHER)) {
                                if (childCount != null) {
                                    wpdChildMaster.setOtherCongentialDeformity(keyAndAnswerMap.get("242" + "." + childCount));
                                } else {
                                    wpdChildMaster.setOtherCongentialDeformity(keyAndAnswerMap.get("242"));
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

            case "22":
                if (keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_LIVE_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_STILL_BIRTH)
                        || keyAndAnswerMap.get("14").equalsIgnoreCase(RchConstants.PREGNANCY_OUTCOME_PREMATURE)) {
                    wpdChildMaster.setBabyCriedAtBirth(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "27":
                if (keyAndAnswerMap.get("7").equalsIgnoreCase(RchConstants.MEMBER_STATUS_AVAILABLE))
                {
                    if (!answer.equalsIgnoreCase(RchConstants.DANGEROUS_SIGN_NONE)) {
                        Set<Integer> childDangerSignsSet = new HashSet<>();
                        String[] childDangerSignsArray = answer.split(",");
                        for (String childDangerSignsId : childDangerSignsArray) {
                            if (childDangerSignsId.equals(RchConstants.DANGEROUS_SIGN_OTHER)) {
                                wpdChildMaster.setOtherDangerSign(keyAndAnswerMap.get("2703"));
                            } else {
                                childDangerSignsSet.add(Integer.valueOf(childDangerSignsId));
                            }
                        }
                        wpdChildMaster.setDangerSigns(childDangerSignsSet);
                        wpdChildMaster.setIsHighRiskCase(Boolean.TRUE);
                    } else {
                        wpdChildMaster.setIsHighRiskCase(Boolean.FALSE);
                    }
                }
                break;
            default:
        }
    }
    private void updateMemberAdditionalInfo(MemberEntity memberEntity, WpdMotherMaster wpdMother, Map<String, String> keyAndAnswerMap) {

        Gson gson = new Gson();
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            boolean isUpdate = false;
            MemberAdditionalInfo memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);

            if (wpdMother.getDateOfDelivery() != null) {
                memberAdditionalInfo.setLastServiceLongDate(wpdMother.getDateOfDelivery().getTime());
                isUpdate = true;
            }

            if (isUpdate) {
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }

        } else {
            MemberAdditionalInfo memberAdditionalInfo = new MemberAdditionalInfo();
            boolean isUpdate = false;

            if (wpdMother.getDateOfDelivery() != null) {
                memberAdditionalInfo.setLastServiceLongDate(wpdMother.getDateOfDelivery().getTime());
                isUpdate = true;
            }

            if (keyAndAnswerMap != null && keyAndAnswerMap.containsKey("29")) {
                if (keyAndAnswerMap.get("29") != null
                        && !keyAndAnswerMap.get("29").equalsIgnoreCase("null")
                        && !keyAndAnswerMap.get("29").isEmpty()) {
                    memberAdditionalInfo.setLastServiceLongDate(wpdMother.getDateOfDelivery().getTime());
                    isUpdate = true;
                }
            }

            if (isUpdate) {
                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            }
        }

    }

    private List<String> getKeysForWpdMotherMasterQuestions() {
        List<String> keys = new ArrayList<>();
        keys.add("-1");         //Longitude
        keys.add("-2");         //Latitude
        keys.add("-4");         //Member ID
        keys.add("-5");         //Family ID
        keys.add("-6");         //Location ID
        keys.add("-7");         //Curr Preg ID
        keys.add("-8");         //Mobile Start Date
        keys.add("-9");         //Mobile End Date
        keys.add("1");          //Member Unique Health Id
        keys.add("2");          //Member Name
        keys.add("3");          //Age
        keys.add("5");          //Total weeks of pregnancy
        keys.add("4");          //Address
        keys.add("283");        //Phone number of family
        keys.add("284");        //Number of living children
        keys.add("286");        //Date of pregnancy registration
        keys.add("287");        //Is early registration?
        keys.add("288");        //Immunisation Details
        keys.add("289");        //ANC Visit Detail
        keys.add("290");        //Blood Group
        keys.add("291");        //Last weight information
        keys.add("292");        //LMP
        keys.add("293");        //EDD
        keys.add("294");        //Previous Illness
        keys.add("295");        //High Risk Conditions
        keys.add("296");        //Bank Account Number
        keys.add("297");        //Is JSY Beneficiary?
        keys.add("298");        //Is JSY payment done?
        keys.add("299");        //Services during last visit
        keys.add("9001");       //Asha name and phone number
        keys.add("9050");       //Hidden to check Anganwadi Available
        keys.add("9051");       //Anganwadi Area
        keys.add("9052");       //Hidden to check if anganwadi is to be updated
        keys.add("9052");       //Hidden to check if anganwadi is to be updated
        keys.add("9053");       //Is the anganwadi correct?
        keys.add("6");          //Member Status
        keys.add("7");          //Has Delivery Happened
        keys.add("8");          //Date of Delivery
        keys.add("9");          //Time of Delivery
        keys.add("9054");       //Hidden to check Anganwadi Available
        keys.add("9055");       //Hidden to check if anganwadi question to ask
        keys.add("9056");       //Select Sub-Centre For Anganwadi
        keys.add("9057");       //Anganwadi ID
        keys.add("9002");       //Phone Number
        keys.add("9006");       //Hidden to check if Aadhar is available
        keys.add("9003");       //Scan Aadhar
        keys.add("9004");       //QRS Data
        keys.add("9005");       //Aadhar Number
        keys.add("101");        //Hidden to check preterm birth
        keys.add("102");        //Cortico Asteroid Given
        keys.add("103");        //hidden to check term
        keys.add("104");        //Pregnancy Outcome
        keys.add("641");        //Hidden to reset property Pregnancy outcome
        keys.add("105");        //hidden to check term
        keys.add("106");        //Pregnancy Outcome
        keys.add("29");         //Service Date
        keys.add("651");        //Hidden to reset property Pregnancy outcome
        keys.add("11");         //Delivery Place
        keys.add("71");         //Type of Hospital
        keys.add("72");         //Health Infrastructure
        keys.add("73");         //Hidden to check misoprostol
        keys.add("74");         //Misoprotol Given
        keys.add("75");         //Hidden to check chiranjeevi eligibility
        keys.add("76");         //Is beneficiary eligible for Chirajeevi?
        keys.add("81");         //Delivery Done By
        keys.add("12");         //Mother Alive
        keys.add("13");         //Are you sure beneficiary is dead?
        keys.add("140");        //Death Date
        keys.add("15");         //Place Of Death
        keys.add("2705");       //Other Place Of Death
        keys.add("2607");       //Death Infrastructure
        keys.add("16");         //Death Reason
        keys.add("1604");       //Hidden to check if other death reason is selected
        keys.add("1605");       //Other Death Reason
        keys.add("17");         //Danger Signs
        keys.add("1701");       //Hidden to check if other danger sign is selected
        keys.add("1703");       //Other Danger Sign
        keys.add("1704");       //Hidden to check if there are danger signs.
        keys.add("18");         //Referral Done
        keys.add("8001");       //Referral Place
        keys.add("1801");       //MTP Done at
        keys.add("1802");       //MTP Performed by
        keys.add("1901");       //Hidden to check if institutional delivery
        keys.add("1902");       //Is discharged
        keys.add("1903");       //Discharge Date
        keys.add("190");        //Hidden to check pregnancyOutcome
        keys.add("191");        //Hidden to check if mother is alive
        keys.add("2100");       //Breastfeeding in one hour
        keys.add("2000");       //hidden to check term
        keys.add("2001");       //Pregnancy Outcome
        keys.add("1299");       //Hidden to check pregnancyOutcome
        keys.add("1703");       //other danger sign
        keys.add("9998");       //Submit or Review
        keys.add("9999");       //Form Complete
        return keys;
    }

    public Boolean identifyHighRiskForChildRchWpd(WpdChildMaster wpdChildMaster, WpdMotherMaster wpdMotherMaster) {
        return (wpdChildMaster.getBirthWeight() != null && wpdChildMaster.getBirthWeight() < 2500f)
                || (!CollectionUtils.isEmpty(wpdChildMaster.getCongentialDeformity()))
                || (!CollectionUtils.isEmpty(wpdChildMaster.getDangerSigns()))
                || (wpdMotherMaster.getMotherAlive() != null && !wpdMotherMaster.getMotherAlive());
    }
}
