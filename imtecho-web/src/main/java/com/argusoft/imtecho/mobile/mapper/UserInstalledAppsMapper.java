package com.argusoft.imtecho.mobile.mapper;

import com.argusoft.imtecho.mobile.dto.InstalledAppsInfoBean;
import com.argusoft.imtecho.mobile.model.UserInstalledAppsMaster;

import java.util.Date;

/**
 * @author prateek on 4 Feb, 2019
 */
public class UserInstalledAppsMapper {

    private UserInstalledAppsMapper() {
        throw new IllegalStateException("Utility Class");
    }

    public static UserInstalledAppsMaster convertInstalledAppsInfoToUserInstalledAppsMaster(InstalledAppsInfoBean appsInfoBean, String imei, Integer userId) {
        UserInstalledAppsMaster appsMaster = new UserInstalledAppsMaster();
        appsMaster.setUserId(userId);
        appsMaster.setImei(imei);
        appsMaster.setApplicationName(appsInfoBean.getApplicationName());
        appsMaster.setPackageName(appsInfoBean.getPackageName());
        appsMaster.setUid(appsInfoBean.getUid());
        appsMaster.setVersionCode(appsInfoBean.getVersionCode());
        appsMaster.setVersionName(appsInfoBean.getVersionName());
        if (appsInfoBean.getInstalledDate() != null) {
            appsMaster.setInstalledDate(new Date(appsInfoBean.getInstalledDate()));
        }
        if (appsInfoBean.getLastUpdateDate() != null) {
            appsMaster.setLastUpdateDate(new Date(appsInfoBean.getLastUpdateDate()));
        }
        appsMaster.setUsedDate(appsInfoBean.getUsedDate());
        appsMaster.setSentData(appsInfoBean.getSentData());
        appsMaster.setReceivedData(appsInfoBean.getReceivedData());
        return appsMaster;
    }

    public static InstalledAppsInfoBean convertUserInstalledAppsMasterToInstalledAppsInfo(UserInstalledAppsMaster appsMaster) {
        InstalledAppsInfoBean appsInfoBean = new InstalledAppsInfoBean();
        appsInfoBean.setUserId(appsMaster.getUserId());
        appsInfoBean.setImei(appsMaster.getImei());
        appsInfoBean.setApplicationName(appsMaster.getApplicationName());
        appsInfoBean.setPackageName(appsMaster.getPackageName());
        appsInfoBean.setUid(appsMaster.getUid());
        appsInfoBean.setVersionCode(appsMaster.getVersionCode());
        appsInfoBean.setVersionName(appsMaster.getVersionName());
        if (appsMaster.getInstalledDate() != null) {
            appsInfoBean.setInstalledDate(appsMaster.getInstalledDate().getTime());
        }
        if (appsMaster.getLastUpdateDate() != null) {
            appsInfoBean.setInstalledDate(appsMaster.getLastUpdateDate().getTime());
        }
        appsInfoBean.setUsedDate(appsMaster.getUsedDate());
        appsInfoBean.setSentData(appsMaster.getSentData());
        appsInfoBean.setReceivedData(appsMaster.getReceivedData());
        return appsInfoBean;
    }

}
