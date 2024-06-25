package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.DateDeserializer;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.event.dto.Event;
import com.argusoft.imtecho.event.service.EventHandler;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.LmpFollowUpVisitDao;
import com.argusoft.imtecho.rch.model.LmpFollowUpVisit;
import com.argusoft.imtecho.rch.service.LmpFollowUpService;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * <p>
 * Define services for lmp follow up.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class LmpFollowUpServiceImpl implements LmpFollowUpService {

    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;

    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private LmpFollowUpVisitDao lmpFollowUpVisitDao;

    @Autowired
    private EventHandler eventHandler;

    @Autowired
    private MobileFhsService mobileFhsService;

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeLmpFollowUpForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap) {
        LmpFollowUpVisit lmpFollowUpVisit = new LmpFollowUpVisit();
        Integer memberId = null;
        Integer familyId = null;

        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        }

        if (keyAndAnswerMap.get("-5") != null && !keyAndAnswerMap.get("-5").equalsIgnoreCase("null")) {
            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        }

        Integer locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        lmpFollowUpVisit.setLocationId(locationId);

        if (!ConstantUtil.IMPLEMENTATION_TYPE.equalsIgnoreCase("imomcare")) {
            LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
            lmpFollowUpVisit.setLocationHierarchyId(locationLevelHierarchy.getId());
        }
        MemberEntity memberEntity;

        if (memberId == null && keyAndAnswerMap.containsKey("-44")
                && keyAndAnswerMap.get("-44") != null
                && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
            memberEntity = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44"));
        } else {
            memberEntity = memberDao.retrieveMemberById(memberId);
        }
        lmpFollowUpVisit.setMemberId(memberEntity.getId());

        if (memberEntity.getState() != null && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(memberEntity.getState())) {
            throw new ImtechoMobileException("Member is already marked as dead.", 1);
        }

        if (memberEntity.getIsPregnantFlag() != null && memberEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is already marked as pregnant.", 1);
        }


        FamilyEntity family;
        if (familyId == null && keyAndAnswerMap.containsKey("-55")
                && keyAndAnswerMap.get("-55") != null
                && !keyAndAnswerMap.get("-55").equalsIgnoreCase("null")) {
            family = familyDao.retrieveFamilyByUuid(keyAndAnswerMap.get("-55"));
        } else {
            family = familyDao.retrieveById(familyId);
        }
        lmpFollowUpVisit.setFamilyId(family.getId());

        if (keyAndAnswerMap.get("65") != null && !keyAndAnswerMap.get("65").isEmpty()) {
            memberEntity.setMobileNumber(keyAndAnswerMap.get("65"));
            memberDao.update(memberEntity);
        }

        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
            lmpFollowUpVisit.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            lmpFollowUpVisit.setMobileStartDate(new Date(0L));
        }
        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-9").equals("null")) {
            lmpFollowUpVisit.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            lmpFollowUpVisit.setMobileEndDate(new Date(0L));
        }

        lmpFollowUpVisit.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));
        lmpFollowUpVisit.setIsPregnant(Boolean.FALSE);

        for (Map.Entry<String, String> entrySet : keyAndAnswerMap.entrySet()) {
            String key = entrySet.getKey();
            String answer = entrySet.getValue();
            this.setAnswersToLmpFollowUpVisitEntity(key, answer, lmpFollowUpVisit, keyAndAnswerMap, memberEntity);
        }

        if (lmpFollowUpVisit.getMemberStatus().equals(RchConstants.MEMBER_STATUS_DEATH)) {
            mobileFhsService.checkIfMemberDeathEntryExists(memberId);
        }

        if (lmpFollowUpVisit.getServiceDate() != null && lmpFollowUpVisit.getLmp() != null && Boolean.TRUE.equals(lmpFollowUpVisit.getIsPregnant())) {
            Calendar instance = Calendar.getInstance();
            instance.setTime(lmpFollowUpVisit.getServiceDate());
            instance.add(Calendar.MONTH, -9);
            if (ImtechoUtil.clearTimeFromDate(lmpFollowUpVisit.getLmp()).before(ImtechoUtil.clearTimeFromDate(instance.getTime()))) {
                throw new ImtechoMobileException("LMP date can’t be before 9 months from service date", 100);
            }

            instance.setTime(lmpFollowUpVisit.getServiceDate());
            instance.add(Calendar.DATE, -28);
            if (ImtechoUtil.clearTimeFromDate(lmpFollowUpVisit.getLmp()).after(ImtechoUtil.clearTimeFromDate(instance.getTime()))) {
                throw new ImtechoMobileException("LMP date can’t be within last 28 days from service date", 100);
            }
        }

        lmpFollowUpVisitDao.create(lmpFollowUpVisit);
        this.updateMemberAdditionalInfo(memberEntity, lmpFollowUpVisit);
        if (keyAndAnswerMap.get("9996") != null) {
            //Setting Children for this Mother
            String answer = keyAndAnswerMap.get("9996");
            List<Integer> childIds = new ArrayList<>();
            if (answer.contains(",")) {
                String[] split = answer.split(",");
                for (String s : split) {
                    if (!s.contains("UN")) {
                        childIds.add(Integer.valueOf(s));
                    }
                }
            } else {
                if (!answer.contains("UN")) {
                    childIds.add(Integer.valueOf(answer));
                }
            }
            memberDao.updateMotherIdInChildren(memberEntity.getId(), childIds);
        }
        lmpFollowUpVisitDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_LMPFU, lmpFollowUpVisit.getId()));
        return lmpFollowUpVisit.getId();
    }

    @Override
    public Integer storeLmpFollowUpFormOCR(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        LmpFollowUpVisit lmpFollowUpVisit = gson.fromJson(parsedRecordBean.getAnswerRecord(), LmpFollowUpVisit.class);
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

        lmpFollowUpVisit.setMemberId(memberId);
        lmpFollowUpVisit.setLocationId(locationId);
        lmpFollowUpVisit.setFamilyId(familyId);
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        lmpFollowUpVisit.setLocationHierarchyId(locationLevelHierarchy.getId());

        MemberEntity memberEntity;
        if (memberId == null && jsonObject.get("memberUUID") != null) {
            memberEntity = memberDao.retrieveMemberByUuid(String.valueOf(jsonObject.get("memberUUID")));
        } else {
            memberEntity = memberDao.retrieveMemberById(memberId);
        }

        MemberAdditionalInfo memberAdditionalInfo;
        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
        } else {
            memberAdditionalInfo = new MemberAdditionalInfo();
        }

        if (memberEntity.getState() != null && FamilyHealthSurveyServiceConstants.FHS_MEMBER_VERIFICATION_STATE_DEAD.contains(memberEntity.getState())) {
            throw new ImtechoMobileException("Member is already marked as dead.", 1);
        }

        if (memberEntity.getIsPregnantFlag() != null && memberEntity.getIsPregnantFlag()) {
            throw new ImtechoMobileException("Member is already marked as pregnant.", 1);
        }

        if (jsonObject.get("latitude") != null) {
            lmpFollowUpVisit.setLatitude(jsonObject.get("latitude").getAsString());
        }

        if (jsonObject.get("longitude") != null) {
            lmpFollowUpVisit.setLongitude(jsonObject.get("longitude").getAsString());
        }

        if (jsonObject.get("serviceDate") != null) {
            long serviceDate = jsonObject.get("serviceDate").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(serviceDate);
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
        }

        if (jsonObject.get("startDateOfLivingWithPartner") != null) {
            long startDateOfLivingWithPartner = jsonObject.get("startDateOfLivingWithPartner").getAsLong();
            memberAdditionalInfo.setLastServiceLongDate(startDateOfLivingWithPartner);
            memberEntity.setDateOfWedding(new Date(startDateOfLivingWithPartner));
        }

        if (jsonObject.get("currentGravida") != null) {
            lmpFollowUpVisit.setCurrentGravida(jsonObject.get("currentGravida").getAsShort());
        }

        if (jsonObject.get("currentPara") != null) {
            lmpFollowUpVisit.setCurrentGravida(jsonObject.get("currentPara").getAsShort());
        }

        lmpFollowUpVisit.setMemberStatus("AVAILABLE");

        lmpFollowUpVisitDao.create(lmpFollowUpVisit);
        lmpFollowUpVisitDao.flush();
        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.FHW_LMPFU, lmpFollowUpVisit.getId()));
        return lmpFollowUpVisit.getId();
    }

    /**
     * Set answer to lmp follow up visit details.
     *
     * @param key              Key.
     * @param answer           Answer for member's lmp follow details.
     * @param keyAndAnswerMap  Contains key and answers.
     * @param lmpFollowUpVisit Lmp follow up visit details.
     * @param memberEntity     Member details.
     */
    private void setAnswersToLmpFollowUpVisitEntity(String key, String answer, LmpFollowUpVisit lmpFollowUpVisit, Map<String, String> keyAndAnswerMap, MemberEntity memberEntity) {
        switch (key) {
            case "-2":
                lmpFollowUpVisit.setLatitude(answer);
                break;
            case "-1":
                lmpFollowUpVisit.setLongitude(answer);
                break;
            case "29":
                lmpFollowUpVisit.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "22":
                if (answer.length() == 2) {
                    Date dob = memberEntity.getDob();
                    if (dob != null) {
                        Calendar instance = Calendar.getInstance();
                        instance.setTime(dob);
                        int yob = instance.get(Calendar.YEAR);
                        int yom = yob + Integer.parseInt(answer);
                        lmpFollowUpVisit.setYear(Short.valueOf(Integer.toString(yom)));
                    }
                }
                if (answer.length() == 4) {
                    lmpFollowUpVisit.setYear(Short.valueOf(answer));
                }
                break;
            case "222":
            case "4504": //4504 is date from which live in relationship started
                lmpFollowUpVisit.setDateOfWedding(new Date(Long.parseLong(answer)));
                memberEntity.setDateOfWedding(new Date(Long.parseLong(answer)));
                break;
            case "220":
                Date dob = memberEntity.getDob();
                if (dob != null) {
                    Calendar instance = Calendar.getInstance();
                    instance.setTime(dob);
                    int yob = instance.get(Calendar.YEAR);
                    int yom = yob + Integer.parseInt(answer);
                    lmpFollowUpVisit.setYear(Short.valueOf(Integer.toString(yom)));
                }
                break;
            case "30":
                lmpFollowUpVisit.setMemberStatus(answer);
                break;
            case "4":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("1")) {
                    lmpFollowUpVisit.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "42":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("1") && keyAndAnswerMap.get("41").equals("1")) {
                    lmpFollowUpVisit.setFamilyPlanningMethod(answer);
                }
                break;
            case "551":
            case "554":
            case "555":
            case "556":
            case "557":
            case "558":
            case "559":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("1") && keyAndAnswerMap.get("41").equals("1")) {
                    lmpFollowUpVisit.setFpSubMethod(answer);
                }
                break;
            case "553":
            case "574":
            case "578":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("1") && keyAndAnswerMap.get("41").equals("1")) {
                    lmpFollowUpVisit.setFpAlternativeMainMethod(answer);
                }
                break;
            case "571":
            case "572":
            case "575":
            case "576":
            case "579":
            case "580":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("1") && keyAndAnswerMap.get("41").equals("1")) {
                    lmpFollowUpVisit.setFpAlternativeSubMethod(answer);
                }
                break;
            case "421":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)) {
                    lmpFollowUpVisit.setFpInsertOperateDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "5":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2")) {
                    lmpFollowUpVisit.setPregnancyTestDone(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "6":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")) {
                    lmpFollowUpVisit.setIsPregnant(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "63":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setLmp(new Date(Long.parseLong(answer)));
                }
                break;
            case "65":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1") && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setPhoneNumber(answer);
                }
                break;
            case "7":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1") && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setRegisterNowForPregnancy(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "2602":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    lmpFollowUpVisit.setDeathDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "2603":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    lmpFollowUpVisit.setPlaceOfDeath(answer);
                }
                break;
            case "2705":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    lmpFollowUpVisit.setOtherDeathPlace(answer);
                }
                break;
            case "26":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_DEATH)) {
                    if (answer.equals("OTHER")) {
                        lmpFollowUpVisit.setDeathReason("-1");
                    } else if (!answer.equals("NONE")) {
                        lmpFollowUpVisit.setDeathReason(answer);
                    }
                }
                break;
            case "2605":
                if (keyAndAnswerMap.get("30").equalsIgnoreCase(RchConstants.MEMBER_STATUS_DEATH)
                        && keyAndAnswerMap.get("26") != null && keyAndAnswerMap.get("26").equals("OTHER")) {
                    lmpFollowUpVisit.setOtherDeathReason(answer);
                }
                break;
            case "2607":
                lmpFollowUpVisit.setDeathInfrastructureId(Integer.valueOf(answer));
                break;

            case "69":
                lmpFollowUpVisit.setCurrentGravida(Short.parseShort(answer));
                break;

            case "70":
                lmpFollowUpVisit.setCurrentPara(Short.parseShort(answer));
                break;
            case "628":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setAbortionCount(Short.parseShort(answer));
                }
                break;
            case "630":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setLastPregnancyDate(new Date(Long.parseLong((answer))));
                }
                break;
            case "631":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setFatherBloodGroup(answer);
                }
                break;
            case "632":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setFatherSickleCellStatus(answer);
                }
                break;
            case "6330":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setLateRegReason(answer);
                }
                break;
            case "634":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setReceivedAncFromOtherPlace(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "636":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setOtherAncServicePlace(answer);
                }
                break;
            case "6360":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1") && keyAndAnswerMap.get("636").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    lmpFollowUpVisit.setPrevAncInfraId(Integer.valueOf(answer));
                }
                break;
            case "6361":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1") && keyAndAnswerMap.get("636").equalsIgnoreCase(RchConstants.OUT_OF_UT)) {
                    lmpFollowUpVisit.setPrevAncState(answer);
                }
                break;
            case "639":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setPrevAncDate(new Date(Long.parseLong(answer)));
                }
                break;
            case "637":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    lmpFollowUpVisit.setHaveCardForDetails(ImtechoUtil.returnTrueFalseFromInitials(answer));
                }
                break;
            case "638":
                if (keyAndAnswerMap.get("30").equals(RchConstants.MEMBER_STATUS_AVAILABLE)
                        && keyAndAnswerMap.get("3").equals("2") && keyAndAnswerMap.get("5").equals("1")
                        && keyAndAnswerMap.get("6").equals("1")) {
                    memberEntity.setRchId(answer);
                }
                break;
            default:
        }
    }

    /**
     * Update additional info for anc.
     *
     * @param memberEntity Member details.
     * @param lmpVisit     Lmp visit details.
     */
    private void updateMemberAdditionalInfo(MemberEntity memberEntity, LmpFollowUpVisit lmpVisit) {
        Gson gson = new Gson();
        MemberAdditionalInfo memberAdditionalInfo;

        if (lmpVisit.getServiceDate() != null) {
            if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
                memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
            } else {
                memberAdditionalInfo = new MemberAdditionalInfo();
            }
            if (lmpVisit.getAbortionCount() != null) {
                memberAdditionalInfo.setAbortionCount(lmpVisit.getAbortionCount());
            }
            memberAdditionalInfo.setLastServiceLongDate(lmpVisit.getServiceDate().getTime());
            memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
            memberDao.update(memberEntity);
        }
    }
}
