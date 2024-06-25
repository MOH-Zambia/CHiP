package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.ChipCovidDao;
import com.argusoft.imtecho.chip.model.CovidScreeningEntity;
import com.argusoft.imtecho.chip.service.ChipCovidScreeningService;
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
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Map;

@Service
@Transactional
public class ChipCovidScreeningServiceImpl implements ChipCovidScreeningService {

    @Autowired
    private ChipCovidDao chipCovidDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;
    @Autowired
    private EventHandler eventHandler;

    @Override
    public Integer storeCovidForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        CovidScreeningEntity covidScreeningEntity = new CovidScreeningEntity();
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

        covidScreeningEntity.setMemberId(memberId);
        covidScreeningEntity.setLocationId(locationId);
        covidScreeningEntity.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(covidScreeningEntity.getMemberId());
        keyAndAnswerMap.forEach((key, answer) -> setAnswersToCovidForm(key, answer, covidScreeningEntity, keyAndAnswerMap));

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

        if (keyAndAnswerMap.containsKey("8672")) {
            if (keyAndAnswerMap.get("-20") != null && !keyAndAnswerMap.get("-20").equalsIgnoreCase("null")) {
                covidScreeningEntity.setReferralPlace(Integer.valueOf(keyAndAnswerMap.get("-20")));
            }
        }

        chipCovidDao.create(covidScreeningEntity);
        memberDao.update(memberEntity);

        chipCovidDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_COVID_SCREENING, covidScreeningEntity.getId()));
        return covidScreeningEntity.getId();
    }

    @Override
    public Integer storeCovidFormOCR(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        Gson gson = new GsonBuilder().registerTypeAdapter(Date.class, new DateDeserializer()).create();
        CovidScreeningEntity covidScreeningEntity = gson.fromJson(parsedRecordBean.getAnswerRecord(), CovidScreeningEntity.class);
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

        covidScreeningEntity.setMemberId(memberId);
        covidScreeningEntity.setLocationId(locationId);
        covidScreeningEntity.setFamilyId(familyId);

        if (covidScreeningEntity.getReferralDone() != null && !covidScreeningEntity.getReferralDone().isEmpty()) {
            covidScreeningEntity.setReferralDone(ImtechoUtil.returnYESorNOFromInitials(covidScreeningEntity.getReferralDone()));
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(covidScreeningEntity.getMemberId());
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

        covidScreeningEntity.setMemberStatus("AVAILABLE");

        chipCovidDao.create(covidScreeningEntity);
        memberDao.update(memberEntity);

        chipCovidDao.flush();
        memberDao.flush();

        eventHandler.handle(new Event(Event.EVENT_TYPE.FORM_SUBMITTED, null, SystemConstantUtil.CHIP_COVID_SCREENING, covidScreeningEntity.getId()));
        return covidScreeningEntity.getId();
    }

    private void setAnswersToCovidForm(String key, String answer, CovidScreeningEntity covidScreeningEntity, Map<String, String> keyAndAnswerMap) {
        switch (key) {
            case "4":
                covidScreeningEntity.setDoseOneTaken(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "5":
                covidScreeningEntity.setDoseOneName(answer);
                break;
            case "6":
                covidScreeningEntity.setDoseOneDate(new Date(Long.parseLong(answer)));
                break;
            case "7":
                covidScreeningEntity.setDoseTwoTaken(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8":
                covidScreeningEntity.setDoseTwoName(answer);
                break;
            case "9":
                covidScreeningEntity.setDoseTwoDate(new Date(Long.parseLong(answer)));
                break;
            case "10":
                covidScreeningEntity.setWillingForBoosterVaccine(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "11":
                covidScreeningEntity.setBoosterDoseGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "12":
                covidScreeningEntity.setBoosterName(answer);
                break;
            case "13":
                covidScreeningEntity.setBoosterDate(new Date(Long.parseLong(answer)));
                break;
            case "14":
                covidScreeningEntity.setDoseOneScheduleDate(new Date(Long.parseLong(answer)));
                break;
            case "15":
                covidScreeningEntity.setDoseTwoScheduleDate(new Date(Long.parseLong(answer)));
                break;
            case "16":
                covidScreeningEntity.setBoosterDoseScheduleDate(new Date(Long.parseLong(answer)));
                break;
            case "17":
                covidScreeningEntity.setAnyReactions(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8989":
                covidScreeningEntity.setIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "7514":
                covidScreeningEntity.setMemberStatus(answer);
                break;
            case "8181":
                covidScreeningEntity.setReactionAndEffects(answer);
                break;
            case "8183":
                if (answer != null && !answer.isEmpty()) {
                    covidScreeningEntity.setOtherEffects(answer.trim());
                }
                break;
            case "21":
                switch (answer) {
                    case "1":
                        covidScreeningEntity.setReferralDone(RchConstants.REFFERAL_DONE_YES);
                        break;
                    case "2":
                        covidScreeningEntity.setReferralDone(RchConstants.REFFERAL_DONE_NO);
                        break;
                    case "3":
                        covidScreeningEntity.setReferralDone(RchConstants.REFFERAL_DONE_NOT_REQUIRED);
                        break;
                    default:
                }
                break;
            case "26":
                if (!answer.trim().isEmpty()) {
                    covidScreeningEntity.setReferralReason(answer);
                }
                break;
            case "3333":
                if (!answer.trim().isEmpty()) {
                    covidScreeningEntity.setReferralFor(answer);
                }
                break;
            case "8673":
                covidScreeningEntity.setReferralPlace(Integer.valueOf(answer));
                break;
            case "40":
                covidScreeningEntity.setVaccinationStatus(answer);
                break;

            default:
        }
    }
}
