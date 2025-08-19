package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.EventBasedCareDao;
import com.argusoft.imtecho.chip.model.EventBasedCareModule;
import com.argusoft.imtecho.chip.service.EventBasedCareService;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.listvalues.service.ListValueFieldValueDetailService;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.dao.SyncStatusDao;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;

import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class EventBasedCareServiceImpl implements EventBasedCareService {
    @Autowired
    MemberDao memberDao;
    @Autowired
    FamilyDao familyDao;
    @Autowired
    LocationLevelHierarchyDao locationLevelHierarchyDao;
    @Autowired
    SyncStatusDao syncStatusDao;

    @Autowired
    private EventBasedCareDao eventBasedCareDao;

    @Autowired
    private ListValueFieldValueDetailService listValueFieldValueDetailService;


    @Override
    public Integer storeEventBasedCareForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap) {
        EventBasedCareModule eventBasedCareModule = new EventBasedCareModule();

        Integer memberId = null;
        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        } else {
            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                memberId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
            }
        }

        if (keyAndAnswerMap.get("-1") != null) {
            eventBasedCareModule.setLongitude(keyAndAnswerMap.get("-1"));
        }
        if (keyAndAnswerMap.get("-2") != null) {
            eventBasedCareModule.setLatitude(keyAndAnswerMap.get("-2"));
        }

        if (keyAndAnswerMap.get("-8") != null && !keyAndAnswerMap.get("-8").equals("null")) {
            eventBasedCareModule.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            eventBasedCareModule.setMobileStartDate(new Date(0L));
        }
        if (keyAndAnswerMap.get("-9") != null && !keyAndAnswerMap.get("-9").equals("null")) {
            eventBasedCareModule.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            eventBasedCareModule.setMobileEndDate(new Date(0L));
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
        eventBasedCareModule.setLocationHierarchyId(locationLevelHierarchy.getId());
        eventBasedCareModule.setMemberId(memberId);
        eventBasedCareModule.setLocationId(locationId);
        eventBasedCareModule.setFamilyId(familyId);

        MemberEntity memberEntity = memberDao.retrieveMemberById(eventBasedCareModule.getMemberId());

        keyAndAnswerMap.forEach((key, answer) -> setAnsToEventBasedCareForm(key, answer, eventBasedCareModule));

        StringBuilder sb = new StringBuilder();

        String reportedEventIdsStr = eventBasedCareModule.getEventsReported();
        if (reportedEventIdsStr != null && !reportedEventIdsStr.trim().isEmpty()) {
            String[] idArray = reportedEventIdsStr.split(",");
            for (String idStr : idArray) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    String value = listValueFieldValueDetailService.retrieveValueFromId(id);
                    if (value != null && !value.trim().isEmpty()) {
                        if (!sb.isEmpty()) {
                            sb.append(",");
                        }
                        sb.append(value);
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            eventBasedCareModule.setEventsReported(sb.toString());
        }


        if(eventBasedCareModule.getFacility()!= null){
            eventBasedCareModule.setNotifyFacility(Boolean.TRUE);
        }

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

        eventBasedCareDao.create(eventBasedCareModule);
        memberDao.update(memberEntity);

        eventBasedCareDao.flush();
        memberDao.flush();

        return eventBasedCareModule.getId();
    }


    private void setAnsToEventBasedCareForm(String key, String answer, EventBasedCareModule eventBasedCareModule) {
        switch (key) {
            case "7514":
                eventBasedCareModule.setMemberStatus(answer);
                break;
            case "7513":
                eventBasedCareModule.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            case "4":
                eventBasedCareModule.setEventsReported(answer);
                break;
            case "6":
                eventBasedCareModule.setOtherEventsReported(answer);
                break;
            case "7":
                eventBasedCareModule.setSimilarSymptomsHousehold(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "43":
                eventBasedCareModule.setNotifyFacility(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            case "8669":
            case "8672":
                eventBasedCareModule.setFacility(answer);
                break;
            case "8989":
                eventBasedCareModule.setIsIecGiven(ImtechoUtil.returnTrueFalseFromInitials(answer));
                break;
            default:
        }
    }
}
