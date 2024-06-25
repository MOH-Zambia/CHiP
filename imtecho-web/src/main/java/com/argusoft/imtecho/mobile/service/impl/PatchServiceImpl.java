/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.dto.MemberAdditionalInfo;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.SyncStatusDao;
import com.argusoft.imtecho.mobile.dto.MemberServiceDateDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.argusoft.imtecho.mobile.service.PatchService;
import com.argusoft.imtecho.mobile.service.PatchServiceTwo;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import com.argusoft.imtecho.rch.dao.AncVisitDao;
import com.argusoft.imtecho.rch.dao.ChildServiceDao;
import com.argusoft.imtecho.rch.dao.LmpFollowUpVisitDao;
import com.argusoft.imtecho.rch.dao.PncMasterDao;
import com.argusoft.imtecho.rch.dao.WpdChildDao;
import com.argusoft.imtecho.rch.dao.WpdMotherDao;
import com.argusoft.imtecho.rch.model.WpdMotherMaster;
import com.google.gson.Gson;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.GsonBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author kunjan
 */
@Service
public class PatchServiceImpl implements PatchService {

    @Autowired
    private SyncStatusDao syncStatusDao;

    @Autowired
    private MobileUtilService mobileUtilService;

    @Autowired
    private PatchServiceTwo patchServiceTwo;

    @Autowired
    private UserDao userDao;

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
    LmpFollowUpVisitDao lmpFollowUpVisitDao;

    @Autowired
    AncVisitDao ancVisitDao;

    @Autowired
    PncMasterDao pncMasterDao;

    @Autowired
    ChildServiceDao childServiceDao;

    public static int createChildCounter = 0;

    public static int createWpdLiveCounter = 0;

    public static int createWpdStillCounter = 0;

    @Override
    @Async
    public void patchForChildEntryNotDone() {

        Date from = new Date(119, 0, 7, 0, 0, 0);
        List<SyncStatus> syncStatuses = mobileUtilService.retrieveSyncStatusByCriteria(from, null, "|FHW_WPD|", null, "S");
//        syncStatuses.add(mobileUtilService.retrieveSyncStatusById("acpatel11547479445190"));//retrieveSyncStatusByCriteria(from, null, "|FHW_WPD|", null, "S");
        System.out.println("Size:" + syncStatuses.size());
        int count = 0;
        for (SyncStatus syncStatus : syncStatuses) {
            count++;
            System.out.println("*****************************************");
            System.out.println("Processing record:" + count);
            System.out.println("Sync status id:" + syncStatus.getId());
            ParsedRecordBean parsedRecordBean = parseRecordStringToBean(syncStatus.getRecordString());
            String[] keyAndAnswerSet = parsedRecordBean.getAnswerRecord().split(MobileConstantUtil.ANSWER_STRING_FIRST_SEPARATER);
            Map<String, String> keyAndAnswerMap = new HashMap();
            List<String> keyAndAnswerSetList = new ArrayList(Arrays.asList(keyAndAnswerSet));
            for (String aKeyAndAnswer : keyAndAnswerSetList) {
                String[] keyAnswerSplit = aKeyAndAnswer.split(MobileConstantUtil.ANSWER_STRING_SECOND_SEPARATER);
                if (keyAnswerSplit.length != 2) {
                    continue;
                }
                keyAndAnswerMap.put(keyAnswerSplit[0], keyAnswerSplit[1]);
            }
            UserMaster user = userDao.retrieveById(syncStatus.getUserId());
            String result = patchServiceTwo.storeWpdVisitForm(parsedRecordBean, keyAndAnswerMap, user);
            System.out.println("Result:" + result);
        }
        System.out.println("=================================================================================");
        System.out.println("createChildCounter created:" + createChildCounter);
        System.out.println("createWpdLiveCounter created:" + createWpdLiveCounter);
        System.out.println("createWpdStillCounter created:" + createWpdStillCounter);

    }

    private Map<String, String> getKeyAndAnswersMapFromAnswerRecord(String answerString) {
        String[] keyAndAnswerSet = answerString.split(MobileConstantUtil.ANSWER_STRING_FIRST_SEPARATER);
        Map<String, String> keyAndAnswerMap = new HashMap<>();
        List<String> keyAndAnswerSetList = new ArrayList<>(Arrays.asList(keyAndAnswerSet));
        for (String aKeyAndAnswer : keyAndAnswerSetList) {
            String[] keyAnswerSplit = aKeyAndAnswer.split(MobileConstantUtil.ANSWER_STRING_SECOND_SEPARATER);
            if (keyAnswerSplit.length != 2) {
                continue;
            }
            keyAndAnswerMap.put(keyAnswerSplit[0], keyAnswerSplit[1]);
        }
        return  keyAndAnswerMap;
    }

    @Override
    public ParsedRecordBean parseRecordStringToBean(String record) {
        String checksum;
        String mobileDate;
        String answerEntity;
        String customType;
        String relativeId;
        String formFillUpTime;
        String notificationId;
        String morbidityFrame;
        String answerRecord;

        int frameSize = record.split(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER).length;

        //  Parse Checksum
        int start = 0, end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER);
        checksum = record.substring(start, end);

        if (frameSize >= 9) {
            //  Mobile Date
            start = end + 1;
            end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
            mobileDate = record.substring(start, end);
        } else {
            mobileDate = String.valueOf(new Date().getTime());
        }

        //  Parse Answer Entiry (Record Type e.g. EDP, ANC etc)
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        answerEntity = record.substring(start, end);

        //  Parse customType (Record is of e.g. Mother, Child or Other etc)
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        customType = record.substring(start, end);

        //  Parse Related Instance ID
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        relativeId = record.substring(start, end);

        //  Parse Form Creation Time
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        formFillUpTime = record.substring(start, end);

        //  Notification Id        
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        notificationId = record.substring(start, end);

        //  morbidityFrame
        start = end + 1;
        end = record.indexOf(MobileConstantUtil.CHECKSUM_AND_ENTITY_TYPE_SEPARATER, start);
        morbidityFrame = record.substring(start, end);

        //  Parse Actual Record data
        start = end + 1;
        end = record.length();
        answerRecord = record.substring(start, end);

        ParsedRecordBean parsedRecordBean = new ParsedRecordBean();
        parsedRecordBean.setChecksum(checksum);
        parsedRecordBean.setMobileDate(mobileDate);
        parsedRecordBean.setAnswerEntity(answerEntity);
        parsedRecordBean.setCustomType(customType);
        parsedRecordBean.setRelativeId(relativeId);
        parsedRecordBean.setFormFillTime(formFillUpTime);
        parsedRecordBean.setNotificationId(notificationId);
        parsedRecordBean.setMorbidityFrame(morbidityFrame);
        parsedRecordBean.setAnswerRecord(answerRecord);
        return parsedRecordBean;
    }

    @Override
    @Transactional
    public void patchToUpdateLastServiceDateOfMember() {
        Gson gson = new Gson();

        List<MemberServiceDateDto> memberServiceDateDtosLmpFollowUp = lmpFollowUpVisitDao.retrieveMembersWithServiceDateAsFuture();
        System.out.println("Total Members retrieved in Lmp Follow Up Visit : " + memberServiceDateDtosLmpFollowUp.size());

        List<MemberServiceDateDto> memberServiceDateDtosAnc = ancVisitDao.retrieveMembersWithServiceDateAsFuture();
        System.out.println("Total Members retrieved in Anc Visit : " + memberServiceDateDtosAnc.size());

        List<MemberServiceDateDto> memberServiceDateDtosPnc = pncMasterDao.retrieveMembersWithServiceDateAsFuture();
        System.out.println("Total Members retrieved in Pnc Visit : " + memberServiceDateDtosPnc.size());

        List<MemberServiceDateDto> memberServiceDateDtosChild = childServiceDao.retrieveMembersWithServiceDateAsFuture();
        System.out.println("Total Members retrieved in Child Visit : " + memberServiceDateDtosChild.size());

        List<MemberServiceDateDto> memberServiceDateDtos = new ArrayList<>();
        memberServiceDateDtos.addAll(memberServiceDateDtosLmpFollowUp);
        memberServiceDateDtos.addAll(memberServiceDateDtosAnc);
        memberServiceDateDtos.addAll(memberServiceDateDtosPnc);
        memberServiceDateDtos.addAll(memberServiceDateDtosChild);

        Map<Integer, Date> serviceDateMap = new HashMap<>();
        for (MemberServiceDateDto memberServiceDateDto : memberServiceDateDtos) {
            if (!serviceDateMap.containsKey(memberServiceDateDto.getMemberId())
                    || serviceDateMap.get(memberServiceDateDto.getMemberId()).before(memberServiceDateDto.getServiceDate())) {
                serviceDateMap.put(memberServiceDateDto.getMemberId(), memberServiceDateDto.getServiceDate());
            }
        }
        System.out.println("Total Members to be updated : " + serviceDateMap.size());

        List<Integer> memberIds = new ArrayList<>(serviceDateMap.keySet());
        List<MemberEntity> memberEntitys = memberDao.retriveByIds("id", memberIds);

        for (MemberEntity memberEntity : memberEntitys) {
            if (memberEntity.getAdditionalInfo() != null) {
                MemberAdditionalInfo memberAdditionalInfo = gson.fromJson(memberEntity.getAdditionalInfo(), MemberAdditionalInfo.class);
                Long lastServiceLongDate = memberAdditionalInfo.getLastServiceLongDate();

                if (lastServiceLongDate != null && lastServiceLongDate > new Date().getTime()) {
                    memberAdditionalInfo.setLastServiceLongDate(serviceDateMap.get(memberEntity.getId()).getTime());
                    memberEntity.setAdditionalInfo(gson.toJson(memberAdditionalInfo));
                }
            }
        }
        memberDao.updateAll(memberEntitys);
    }

    @Override
    @Transactional
    public List<SyncStatus> retrieveSyncStatusForUpdatingBreastFeedingForWPD() {
        return syncStatusDao.retrieveSyncStatusForUpdatingBreastFeedingForWPD();
//        List<SyncStatus> syncStatuses = new ArrayList<>();
//        syncStatuses.add(syncStatusDao.retrieveById("chandrika1555578853692"));
//        return syncStatuses;
    }

    @Override
    @Transactional
    public void updateProcessedSyncStatusId(String syncStatusId) {
//        System.out.println("Processing SyncStatus  : " + syncStatusId);
        syncStatusDao.updateSyncedWpdMotherMaster(syncStatusId);
    }

    @Override
    @Transactional
    public int updateWpdMotherMasterForBreastFeeding(Map<String, String> keyAndAnswerMap, SyncStatus syncStatus, Boolean breastFeeding, int updatedCount) {
        Integer memberId = Integer.valueOf(keyAndAnswerMap.get("-4"));
        WpdMotherMaster motherMaster = null;

        try {
            motherMaster = wpdMotherDao.getWpdMotherMasterForBreastFeedingUpdate(syncStatus.getActionDate(), memberId);
        } catch (Exception e) {
            System.out.println("WPD Mother Master not found for member : " + memberId);
        }

        if (motherMaster != null) {
            motherMaster.setBreastFeedingInOneHour(breastFeeding);
            wpdMotherDao.update(motherMaster);
            updatedCount++;
//            System.out.println("Updated WPD Mother id : " + motherMaster.getId());
        }

        return updatedCount;
    }
}
