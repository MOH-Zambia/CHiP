/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.LocationMobileFeatureDao;
import com.argusoft.imtecho.mobile.dao.SyncStatusDao;
import com.argusoft.imtecho.mobile.dao.UncaughtExceptionMobileDao;
import com.argusoft.imtecho.mobile.dao.UserInputDurationDao;
import com.argusoft.imtecho.mobile.dto.UncaughtExceptionBean;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.model.UncaughtExceptionMobile;
import com.argusoft.imtecho.mobile.model.UserInputDuration;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.query.service.QueryMasterService;

import java.util.Date;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author prateek
 */
@Service
@Transactional
public class MobileUtilServiceImpl implements MobileUtilService {

    @Autowired
    private SyncStatusDao syncStatusDao;

    @Autowired
    private UserInputDurationDao userInputDurationDao;

    @Autowired
    private UncaughtExceptionMobileDao uncaughtExceptionMobileDao;

    @Autowired
    private LocationMobileFeatureDao locationMobileFeatureDao;

    @Autowired
    private QueryMasterService queryMasterService;

    public MobileUtilServiceImpl() {
    }

    @Override
    public void createSyncStatus(SyncStatus syncStatus) {
        syncStatusDao.create(syncStatus);
    }

    @Override
    public void updateSyncStatus(SyncStatus syncStatus) {
        syncStatusDao.createOrUpdate(syncStatus);
    }

    @Override
    public SyncStatus retrieveSyncStatusById(String id) {
        return syncStatusDao.retrieveById(id);
    }

    @Override
    public Integer createUserInputDuration(UserInputDuration userInputDuration) {
        return userInputDurationDao.create(userInputDuration);
    }

    @Override
    public void updateUserInputDuration(UserInputDuration userInputDuration) {
        userInputDurationDao.update(userInputDuration);
    }

    @Override
    public UserInputDuration retrieveUserInputDurationById(Integer id) {
        return userInputDurationDao.retrieveById(id);
    }

    @Override
    public String storeUncaughtExceptionDetails(List<UncaughtExceptionBean> allExceptionDetails, Integer userId) {
        UncaughtExceptionMobile uncaughtExceptionModel;
        List<UncaughtExceptionMobile> uncaughtExceptionsMobile = new LinkedList();

        for (UncaughtExceptionBean uncaughtExceptionBean : allExceptionDetails) {
            uncaughtExceptionModel = convertUncaughtExceptionBeanToModel(uncaughtExceptionBean, userId);
            uncaughtExceptionsMobile.add(uncaughtExceptionModel);
        }

        try {
            uncaughtExceptionMobileDao.createOrUpdateAll(uncaughtExceptionsMobile);
        } catch (Exception e) {
            Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, e);
            return MobileConstantUtil.FAILURE;
        }
        return MobileConstantUtil.SUCCESS;
    }

    @Override
    public void updateProcessingStringsToPendingOnServerStartup() {
        syncStatusDao.updateProcessingStringsToPendingOnServerStartup();
    }

    private UncaughtExceptionMobile convertUncaughtExceptionBeanToModel(UncaughtExceptionBean uncaughtExceptionBean, Integer userId) {
        UncaughtExceptionMobile uncaughtExceptionModel = new UncaughtExceptionMobile();
        uncaughtExceptionModel.setUserName(uncaughtExceptionBean.getUsername());
        uncaughtExceptionModel.setManufacturer(uncaughtExceptionBean.getManufacturer());
        uncaughtExceptionModel.setStackTrace(uncaughtExceptionBean.getStackTrace());
        uncaughtExceptionModel.setModel(uncaughtExceptionBean.getModel());
        uncaughtExceptionModel.setAndroidVersion(uncaughtExceptionBean.getAndroidVersion());
        uncaughtExceptionModel.setOnDate(uncaughtExceptionBean.getOnDate());
        uncaughtExceptionModel.setRevisionNumber(uncaughtExceptionBean.getRevisionNumber());
        uncaughtExceptionModel.setUserId(userId);
        uncaughtExceptionModel.setIsActive(Boolean.TRUE);
        uncaughtExceptionModel.setExceptionType(uncaughtExceptionBean.getExceptionType());
        return uncaughtExceptionModel;
    }

    @Override
    public List<SyncStatus> retrieveSyncStatusBetweenActionDates(Date from, Date to) {
        return syncStatusDao.retrieveSyncStatusBetweenActionDates(from, to);
    }

    @Override
    public List<SyncStatus> retrieveSyncStatusByCriteria(Date from, Date to, String recordString, Integer userId, String status) {
        return syncStatusDao.retrieveSyncStatusBetweenActionDatesLikeRecordString(from, to, recordString, userId, status);
    }

    @Override
    public LinkedHashMap<String,Object> getTechoPlusUserCount() {
        QueryDto dto = new QueryDto();
        dto.setCode("techo_plus_user_count");
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(dto);
        List<QueryDto> executeQueryByCode = queryMasterService.executeQuery(queryDtos, true);
        if (executeQueryByCode.size() > 0) {
            return executeQueryByCode.get(0).getResult().get(0);
        }
        return new LinkedHashMap<>();
    }

    @Override
    public List<String> retrieveFeaturesAssignedToTheAoi(Integer userId) {
        return locationMobileFeatureDao.retrieveFeaturesAssignedToTheAoi(userId);
    }

}
