/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.rch.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.rch.constants.RchConstants;
import com.argusoft.imtecho.rch.dao.VaccineAdverseEffectDao;
import com.argusoft.imtecho.rch.model.VaccineAdverseEffectMaster;
import com.argusoft.imtecho.rch.service.VaccineAdverseEffectService;
import com.google.gson.Gson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.Map;

/**
 * <p>
 * Define services for vaccine adverse effect.
 * </p>
 *
 * @author prateek
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class VaccineAdverseEffectServiceImpl implements VaccineAdverseEffectService {

    @Autowired
    LocationLevelHierarchyDao locationLevelHierarchyDao;

    @Autowired
    VaccineAdverseEffectDao vaccineAdverseEffectDao;
    @Autowired
    MemberDao memberDao;
    @Autowired
    private FamilyDao familyDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public Integer storeVaccineAdverseEffectForm(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {

        if (keyAndAnswerMap.get("3") != null && keyAndAnswerMap.get("3").equals("NO")) {
            return -1;
        }

        Integer childId = null;
        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
            childId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        } else {
            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
                childId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
            }
        }

        Integer familyId;
        Integer locationId = null;
        if (!keyAndAnswerMap.get("-5").equals("null")) {
            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
        } else {
            FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(childId).getFamilyId());
            familyId = familyEntity.getId();
            if (keyAndAnswerMap.get("-6").equals("null")) {
                locationId = familyEntity.getLocationId();
            }
        }

        if (locationId == null) {
            locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
        }
        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
        VaccineAdverseEffectMaster vaccineAdverseEffectMaster = new VaccineAdverseEffectMaster();
        vaccineAdverseEffectMaster.setMemberId(childId);
        vaccineAdverseEffectMaster.setFamilyId(familyId);
        vaccineAdverseEffectMaster.setLocationId(locationId);
        vaccineAdverseEffectMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
        vaccineAdverseEffectMaster.setLatitude(keyAndAnswerMap.get("-2"));
        vaccineAdverseEffectMaster.setLongitude(keyAndAnswerMap.get("-1"));
        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
            vaccineAdverseEffectMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
        } else {
            vaccineAdverseEffectMaster.setMobileStartDate(new Date(0L));
        }
        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-9").equals("null")) {
            vaccineAdverseEffectMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
        } else {
            vaccineAdverseEffectMaster.setMobileEndDate(new Date(0L));
        }
        vaccineAdverseEffectMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));

        for (Map.Entry<String, String> entry : keyAndAnswerMap.entrySet()) {
            String key = entry.getKey();
            String value = entry.getValue();
            storeAnswersToVaccineAdverseEffectMaster(key, value, vaccineAdverseEffectMaster);
        }

        MemberEntity memberEntity = memberDao.retrieveMemberById(vaccineAdverseEffectMaster.getMemberId());
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

        memberDao.update(memberEntity);
        memberDao.flush();

        vaccineAdverseEffectDao.create(vaccineAdverseEffectMaster);
        vaccineAdverseEffectDao.flush();

        return vaccineAdverseEffectMaster.getId();
    }

//    @Override
//    public Integer storeVaccineAdverseEffectFormForDnhdd(ParsedRecordBean parsedRecordBean, Map<String, String> keyAndAnswerMap, UserMaster user) {
//        Integer childId = null;
//        if (keyAndAnswerMap.get("-4") != null && !keyAndAnswerMap.get("-4").equalsIgnoreCase("null")) {
//            childId = Integer.valueOf(keyAndAnswerMap.get("-4"));
//        } else {
//            if (keyAndAnswerMap.containsKey("-44") && keyAndAnswerMap.get("-44") != null
//                    && !keyAndAnswerMap.get("-44").equalsIgnoreCase("null")) {
//                childId = memberDao.retrieveMemberByUuid(keyAndAnswerMap.get("-44")).getId();
//            }
//        }
//        Integer familyId;
//        Integer locationId = null;
//        if (!keyAndAnswerMap.get("-5").equals("null")) {
//            familyId = Integer.valueOf(keyAndAnswerMap.get("-5"));
//        } else {
//            FamilyEntity familyEntity = familyDao.retrieveFamilyByFamilyId(memberDao.retrieveById(childId).getFamilyId());
//            familyId = familyEntity.getId();
//            if (keyAndAnswerMap.get("-6").equals("null")) {
//                locationId = familyEntity.getLocationId();
//            }
//        }
//
//        if (locationId == null) {
//            locationId = Integer.valueOf(keyAndAnswerMap.get("-6"));
//        }
//        LocationLevelHierarchy locationLevelHierarchy = locationLevelHierarchyDao.retrieveByLocationId(locationId);
//        VaccineAdverseEffectMaster vaccineAdverseEffectMaster = new VaccineAdverseEffectMaster();
//        vaccineAdverseEffectMaster.setMemberId(childId);
//        vaccineAdverseEffectMaster.setFamilyId(familyId);
//        vaccineAdverseEffectMaster.setLocationId(locationId);
//        vaccineAdverseEffectMaster.setLocationHierarchyId(locationLevelHierarchy.getId());
//        vaccineAdverseEffectMaster.setLatitude(keyAndAnswerMap.get("-2"));
//        vaccineAdverseEffectMaster.setLongitude(keyAndAnswerMap.get("-1"));
//        if ((keyAndAnswerMap.get("-8")) != null && !keyAndAnswerMap.get("-8").equals("null")) {
//            vaccineAdverseEffectMaster.setMobileStartDate(new Date(Long.parseLong(keyAndAnswerMap.get("-8"))));
//        } else {
//            vaccineAdverseEffectMaster.setMobileStartDate(new Date(0L));
//        }
//        if ((keyAndAnswerMap.get("-9")) != null && !keyAndAnswerMap.get("-9").equals("null")) {
//            vaccineAdverseEffectMaster.setMobileEndDate(new Date(Long.parseLong(keyAndAnswerMap.get("-9"))));
//        } else {
//            vaccineAdverseEffectMaster.setMobileEndDate(new Date(0L));
//        }
//        vaccineAdverseEffectMaster.setNotificationId(Integer.valueOf(parsedRecordBean.getNotificationId()));
//
//        for (Map.Entry<String, String> entry : keyAndAnswerMap.entrySet()) {
//            String key = entry.getKey();
//            String value = entry.getValue();
//            storeAnswersToVaccineAdverseEffectMasterDnhdd(keyAndAnswerMap, key, value, vaccineAdverseEffectMaster);
//        }
//        if (vaccineAdverseEffectMaster.getExpiryDate() == null) {
//            vaccineAdverseEffectMaster.setExpiryDate(new Date());
//        }
//
//        MemberEntity memberEntity = memberDao.retrieveMemberById(vaccineAdverseEffectMaster.getMemberId());
//        MemberAdditionalInfo memberAdditionalInfo;
//        Gson gson = new Gson();
//        if (memberEntity.getAdditionalInfo() != null && !memberEntity.getAdditionalInfo().isEmpty()) {
//            memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
//        } else {
//            memberAdditionalInfo = new MemberAdditionalInfo();
//        }
//
//        if (keyAndAnswerMap.containsKey("6")) {
//            if (keyAndAnswerMap.get("6") != null
//                    && !keyAndAnswerMap.get("6").equalsIgnoreCase("null")
//                    && !keyAndAnswerMap.get("5").isEmpty()) {
//                memberAdditionalInfo.setLastServiceLongDate(new Date(Long.parseLong(keyAndAnswerMap.get("6"))).getTime());
//                memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
//            }
//        }
//
//        memberDao.update(memberEntity);
//        memberDao.flush();
//
//        vaccineAdverseEffectDao.create(vaccineAdverseEffectMaster);
//        vaccineAdverseEffectDao.flush();
//        return vaccineAdverseEffectMaster.getId();
//    }

    /**
     * Set answers to vaccine adverse effect details.
     *
     * @param key                        Key.
     * @param answer                     Answer for vaccine adverse effect details.
     * @param vaccineAdverseEffectMaster Vaccine adverse effect details.
     */
    private void storeAnswersToVaccineAdverseEffectMaster(String key, String answer, VaccineAdverseEffectMaster vaccineAdverseEffectMaster) {
        switch (key) {
            case "3":
                vaccineAdverseEffectMaster.setAdverseEffect(answer);
                break;
            case "4":
                vaccineAdverseEffectMaster.setVaccineName(answer);
                break;
            case "5":
                vaccineAdverseEffectMaster.setBatchNumber(answer);
                break;
            case "6":
                vaccineAdverseEffectMaster.setExpiryDate(new Date(Long.parseLong(answer)));
                break;
            case "7":
                vaccineAdverseEffectMaster.setManufacturer(answer);
                break;
            case "7513":
                vaccineAdverseEffectMaster.setServiceDate(new Date(Long.parseLong(answer)));
                break;
            default:
        }
    }

    private void storeAnswersToVaccineAdverseEffectMasterDnhdd(Map<String, String> keyAndAnswerMap, String key, String answer, VaccineAdverseEffectMaster vaccineAdverseEffectMaster) {
        switch (key) {
            case "6":
                vaccineAdverseEffectMaster.setNotificationDate(new Date(Long.parseLong(answer)));
                break;
            case "8":
                vaccineAdverseEffectMaster.setVaccinationPlace(answer);
                break;
            case "81":
                if (keyAndAnswerMap.containsKey("8") &&
                        keyAndAnswerMap.get("8").equalsIgnoreCase(RchConstants.DELIVERY_PLACE_HOSPITAL)) {
                    if (answer.equals("-1")) {
                        vaccineAdverseEffectMaster.setVaccinationInfraId(-1);
                    } else {
                        vaccineAdverseEffectMaster.setVaccinationInfraId(Integer.valueOf(answer));
                    }
                }
                break;
            case "9":
                vaccineAdverseEffectMaster.setVaccinationDate(new Date(Long.parseLong(answer)));
                break;
            case "10":
                if (answer.equalsIgnoreCase("OTHER")) {
                    vaccineAdverseEffectMaster.setVaccinationIn(keyAndAnswerMap.get("102"));
                } else {
                    vaccineAdverseEffectMaster.setVaccinationIn(answer);
                }
                break;
            case "11":
                if (answer.equalsIgnoreCase("OTHER")) {
                    vaccineAdverseEffectMaster.setSessionSite(keyAndAnswerMap.get("110"));
                    break;
                }
                vaccineAdverseEffectMaster.setSessionSite(answer);
                break;
            case "12":
                vaccineAdverseEffectMaster.setVaccineName(answer);
                break;
            case "120":
                vaccineAdverseEffectMaster.setAdverseEffectType(answer);
                break;
            case "13":
                if (keyAndAnswerMap.get("120") != null && keyAndAnswerMap.get("120").equalsIgnoreCase("SERIOUS")) {
                    vaccineAdverseEffectMaster.setAdverseEffect(answer);
                }
                break;
            case "14":
                if (keyAndAnswerMap.get("120") != null && keyAndAnswerMap.get("120").equalsIgnoreCase("SERIOUS")) {
                    if (answer.equalsIgnoreCase("UNKNOWN")) {
                        vaccineAdverseEffectMaster.setCluster(null);
                    } else {
                        vaccineAdverseEffectMaster.setCluster(ImtechoUtil.returnTrueFalseFromInitials(answer));
                    }
                }
                break;
            case "15":
                if (keyAndAnswerMap.get("120") != null && keyAndAnswerMap.get("120").equalsIgnoreCase("SERIOUS")) {
                    vaccineAdverseEffectMaster.setNumberOfCluster(Integer.valueOf(answer));
                }
                break;
            case "16":
                if (keyAndAnswerMap.get("120") != null && keyAndAnswerMap.get("120").equalsIgnoreCase("SERIOUS")) {
                    vaccineAdverseEffectMaster.setClusterId(Integer.valueOf(answer));
                }
                break;

        }
    }
}
