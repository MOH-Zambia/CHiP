/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.util;

import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.caughtexception.service.CaughtExceptionService;
import com.argusoft.imtecho.common.controller.UserUsageAnalyticsController;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.common.service.Dhis2DataService;
import com.argusoft.imtecho.common.service.ServerManagementService;
import com.argusoft.imtecho.common.service.SystemConfigurationService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.config.RequestResponseLoggingFilter;
import com.argusoft.imtecho.config.requestresponsefilter.service.RequestResponseDetailsService;
import com.argusoft.imtecho.document.service.DocumentService;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.dao.LocationWiseAnalyticsDao;
import com.argusoft.imtecho.location.service.LocationService;
import com.argusoft.imtecho.migration.service.MigrationService;
import com.argusoft.imtecho.mobile.controller.MobileController;
import com.argusoft.imtecho.mobile.dao.UserFormAccessDao;
import com.argusoft.imtecho.reportconfig.service.ReportQueueService;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * <p>
 * Define cron service for fhs.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class CroneService {

    @Autowired
    private SystemConfigurationService systemConfigurationService;

//    @Autowired
//    private VerificationListService verificationListService;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private LocationWiseAnalyticsDao locationWiseAnalyticsDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private Dhis2DataService dhis2DataService;

//    @Autowired
//    private AbsentVerificationListDao absentVerificationListDao;

    @Autowired
    private UserFormAccessDao userFormAccessDao;

    @Autowired
    private EmailUtil emailUtil;

    @Autowired
    private LocationService locationService;

    @Autowired
    private MigrationService migrationService;

    @Autowired
    DocumentService documentService;

    @Autowired
    private RequestResponseDetailsService requestResponseDetailsService;

    @Autowired
    private ServerManagementService serverManagementService;

    @Autowired
    private ReportQueueService reportQueueService;

    @Autowired
    private CaughtExceptionService caughtExceptionService;

    //Every 5 mins - 0 */5 * * * *
    //Every 1 hour - 0 0 */1 * * *
    //Every day - 0 0 0 * * *
    //  @Scheduled(cron = "0 0 0 * * *")
//    public synchronized void familiesVerificationScheduler() {
//        String ip = getIP();
//        emailUtil.sendEmail("familiesVerificationScheduler Has Started for - " + ip);
//        Logger.getLogger(CroneService.class.getName()).log(Level.INFO, "Crone Service started for family verification list ==>{}", new Date());
//        SystemConfiguration labelModel = systemConfigurationService.retrieveSystemConfigurationByKey(SystemConstantUtil.CRONE_FLAG);
//        if (labelModel != null && labelModel.getKeyValue() != null && labelModel.getKeyValue().equalsIgnoreCase("true")) {
//
//            //Verified List
//            List<GvkVerificationDisplayObject> verifiedFamilies = familyDao.getVerifiedFamilies();
//            Logger.getLogger(CroneService.class.getName()).log(Level.INFO, "No of verified Families: {}", verifiedFamilies.size());
//            for (GvkVerificationDisplayObject family : verifiedFamilies) {
//                FamilyDto familyDto = FamilyMapper.getFamilyDto(familyDao.retrieveFamilyByFamilyId(family.getFamilyId()));
//                VerificationListDto familyVerificationListDto = new VerificationListDto();
//                familyVerificationListDto.setState(familyDto.getState());
//                familyVerificationListDto.setGvkCallState(GvkVerificationServiceConstant.CALL_TO_BE_PROCESSED);
//                familyVerificationListDto.setLocationId(family.getLocationId());
//                familyVerificationListDto.setFamilyId(family.getFamilyId());
//                familyVerificationListDto.setType(family.getType());
//                familyVerificationListDto.setCallAttempt(0);
//                familyVerificationListDto.setScheduleDate(new Date());
//                familyHealthSurveyService.updateFamily(familyDto, familyDto.getState(), FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_EMRI_IN_VERIFICATION_POOL_VERIFIED);
//                verificationListService.createVerificationList(familyVerificationListDto);
//
//            }
//
//            //Archived List
//            List<GvkVerificationDisplayObject> archivedFamilies = familyDao.getFamiliesWithArchivedMembers();
//            Logger.getLogger(CroneService.class.getName()).log(Level.INFO, "No of archived Families: {}", archivedFamilies.size());
//            for (GvkVerificationDisplayObject family : archivedFamilies) {
//                FamilyDto familyDto = FamilyMapper.getFamilyDto(familyDao.retrieveFamilyByFamilyId(family.getFamilyId()));
//                VerificationListDto familyVerificationListDto = new VerificationListDto();
//                familyVerificationListDto.setState(familyDto.getState());
//                familyVerificationListDto.setGvkCallState(GvkVerificationServiceConstant.CALL_TO_BE_PROCESSED);
//                familyVerificationListDto.setLocationId(family.getLocationId());
//                familyVerificationListDto.setFamilyId(family.getFamilyId());
//                familyVerificationListDto.setType(family.getType());
//                familyVerificationListDto.setCallAttempt(0);
//                familyVerificationListDto.setScheduleDate(new Date());
//                familyHealthSurveyService.updateFamily(familyDto, familyDto.getState(), FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_EMRI_IN_VERIFICATION_POOL_ARCHIVED);
//                verificationListService.createVerificationList(familyVerificationListDto);
//
//            }
//
//            //Dead List
//            List<GvkVerificationDisplayObject> deadFamilies = familyDao.getFamiliesWithDeadMembers();
//            Logger.getLogger(CroneService.class.getName()).log(Level.INFO, "No of dead Families: {}", deadFamilies.size());
//            for (GvkVerificationDisplayObject family : deadFamilies) {
//                FamilyDto familyDto = FamilyMapper.getFamilyDto(familyDao.retrieveFamilyByFamilyId(family.getFamilyId()));
//                VerificationListDto familyVerificationListDto = new VerificationListDto();
//                familyVerificationListDto.setState(familyDto.getState());
//                familyVerificationListDto.setGvkCallState(GvkVerificationServiceConstant.CALL_TO_BE_PROCESSED);
//                familyVerificationListDto.setLocationId(family.getLocationId());
//                familyVerificationListDto.setFamilyId(family.getFamilyId());
//                familyVerificationListDto.setType(family.getType());
//                familyVerificationListDto.setCallAttempt(0);
//                familyVerificationListDto.setScheduleDate(new Date());
//                familyHealthSurveyService.updateFamily(familyDto, familyDto.getState(), FamilyHealthSurveyServiceConstants.FHS_FAMILY_STATE_EMRI_IN_VERIFICATION_POOL_DEAD);
//                verificationListService.createVerificationList(familyVerificationListDto);
//
//            }
//
//            //absent verification list
//            List<AbsentVerificationListDto> absentUserList = absentVerificationListDao.getAbsentUsersList();
//            Logger.getLogger(CroneService.class.getName()).log(Level.INFO, "No of absent users: {}", absentUserList.size());
//            List<AbsentUserVerificationEntity> entityList = new ArrayList<>();
//            for (AbsentVerificationListDto user : absentUserList) {
//                AbsentUserVerificationEntity entity = AbsentVerificationListMapper.getAbsentVerificationListEntity(user);
//                entity.setGvkCallState(GvkVerificationServiceConstant.CALL_TO_BE_PROCESSED);
//                entity.setScheduleDate(new Date());
//                entity.setCallAttempt(0);
//                entity.setRoleId(user.getRoleId());
//                entityList.add(entity);
//            }
//            absentVerificationListDao.createOrUpdateAll(entityList);
//
//        }
//        emailUtil.sendEmail("familiesVerificationScheduler Has completed for - " + ip);
//    }

    //@Scheduled(cron = "0 0 8 * * *")
    public synchronized void updateLocationWiseAnalyticsScheduler8am() {
        String ip = getIP();
        emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler 8 AM Has Started for - " + ip);
        try {
            locationWiseAnalyticsDao.updateFHSDetail();
            SystemConfiguration configuration = systemConfigurationService.retrieveSystemConfigurationByKey(ConstantUtil.FHS_LAST_UPDATE_TIME_SYSTEM_KEY);
            configuration.setKeyValue(String.valueOf(new Date().getTime()));
            systemConfigurationService.updateSystemConfiguration(configuration);
        } catch (Exception e) {
            emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler Has Got EXCEPTION");
//            emailUtil.sendExceptionEmail(e, null);
            saveException(e);
        }
        emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler 8 AM Has Completed for - " + ip);
    }

    //@Scheduled(cron = "0 0 19 * * *")
    public synchronized void updateLocationWiseAnalyticsScheduler7Pm() {
        String ip = getIP();
        emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler Has Started for - " + ip);
        try {
            locationWiseAnalyticsDao.updateFHSDetail();
            SystemConfiguration configuration = systemConfigurationService.retrieveSystemConfigurationByKey(ConstantUtil.FHS_LAST_UPDATE_TIME_SYSTEM_KEY);
            configuration.setKeyValue(String.valueOf(new Date().getTime()));
            systemConfigurationService.updateSystemConfiguration(configuration);
            locationWiseAnalyticsDao.insertFHSProgressData();
        } catch (Exception e) {
            emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler Has Got EXCEPTION");
//            emailUtil.sendExceptionEmail(e, null);
            saveException(e);
        }
        emailUtil.sendEmail("UpdateLocationWiseAnalyticsScheduler Has Completed for ip - " + ip);
    }

    // @Scheduled(cron = "0 */2 * * * *")
    public synchronized void updateUserFormAccess() {
        if (ConstantUtil.DROP_TYPE.equals("P")) {
            userFormAccessDao.updateUserFormAccess();
        }
    }

    @Scheduled(cron = "*/2 * * * * *")
    public void updateMaxRefreshCount() {
        if (!ConstantUtil.SERVER_TYPE.equals("RCH")) {
            SystemConfiguration mobileMaxRefreshCount = systemConfigurationService.retrieveSystemConfigurationByKey("MOBILE_MAX_REFRESH_COUNT");
            if (mobileMaxRefreshCount == null) {
                SystemConfiguration systemConfiguration = new SystemConfiguration();
                systemConfiguration.setIsActive(Boolean.TRUE);
                systemConfiguration.setSystemKey("MOBILE_MAX_REFRESH_COUNT");
                systemConfiguration.setKeyValue(ConstantUtil.MAX_REFRESH_MOBILE.toString());
                systemConfigurationService.createSystemConfiguration(systemConfiguration);
            } else {
                if (mobileMaxRefreshCount.getKeyValue() != null && !mobileMaxRefreshCount.getKeyValue().isEmpty()) {
                    ConstantUtil.MAX_REFRESH_MOBILE = Integer.parseInt(mobileMaxRefreshCount.getKeyValue());
                }
            }

            SystemConfiguration mobileCurrentRefreshCount = systemConfigurationService.retrieveSystemConfigurationByKey("MOBILE_CURRENT_REFRESH_COUNT");
            if (mobileCurrentRefreshCount == null) {
                SystemConfiguration systemConfiguration = new SystemConfiguration();
                systemConfiguration.setIsActive(Boolean.TRUE);
                systemConfiguration.setSystemKey("MOBILE_CURRENT_REFRESH_COUNT");
                systemConfiguration.setKeyValue(MobileController.currentCount.toString());
                systemConfigurationService.createSystemConfiguration(systemConfiguration);
            } else {
                mobileCurrentRefreshCount.setKeyValue(MobileController.currentCount.toString());
            }
        }
    }

    public String getIP() {
        InetAddress localhost = null;
        String ip = "No IP";
        try {
            localhost = InetAddress.getLocalHost();
        } catch (UnknownHostException ex) {
            Logger.getLogger(CroneService.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (localhost != null && localhost.getHostAddress() != null) {
            ip = localhost.getHostAddress();
        }
        return ip;
    }

    //@Scheduled(cron = "0 */1 * * * *")
    public synchronized void updateLocationWiseAnalyticsForEmamtaReport() {
        locationWiseAnalyticsDao.updateFHSDataForReport();
        locationWiseAnalyticsDao.updateSickleCellDataForReport();
        locationWiseAnalyticsDao.updateDiseaseDataForReport();
        locationWiseAnalyticsDao.updateWomenSurveyData();
        locationWiseAnalyticsDao.updateFamilyAndMemberData();
        locationWiseAnalyticsDao.updateChildDataForReport();

    }

    @Scheduled(cron = "0 0 4 * * *")
    public void updateAllActiveLocationsWithWorkerInfo() {
        if (ConstantUtil.SERVER_TYPE.equals("LIVE") && ConstantUtil.DROP_TYPE.equals("P")) {
            locationService.updateAllActiveLocationsWithWorkerInfo();
        }

    }

//    @Scheduled(cron = "0 0 2 * * *")
//    public void checkIfChildIsDefaulter() {
//        if (ConstantUtil.SERVER_TYPE.equals("LIVE") && ConstantUtil.DROP_TYPE.equals("P")) {
//            childCmtcNrcScreeningDao.markChildAsDefaulterCronJob();
//            childCmtcNrcScreeningDao.markChildAsDefaulterByFollowUpVisitsCronJob();
//        }
//        childCmtcNrcScreeningDao.moVerifyCronJob();
//    }

//    @Scheduled(cron = "0 0 23 * * *")

    @Scheduled(cron = "0 0 3 * * *")
    public void createTemporaryMemberForMigrationIn() {
        if (ConstantUtil.SERVER_TYPE.equals("LIVE") && ConstantUtil.DROP_TYPE.equals("P")) {
            emailUtil.sendEmail("CRON FOR MIGRATION OUT WITH NO RESPONSE STARTS");
            try {
                migrationService.cronForMigrationOutWithNoResponse();
            } catch (Exception e) {
                emailUtil.sendEmail("ERROR IN CRON FOR MIGRATION OUT WITH NO RESPONSE");
//                emailUtil.sendExceptionEmail(e, null);
                saveException(e);
            }
            emailUtil.sendEmail("CRON FOR MIGRATION OUT WITH NO RESPONSE ENDS");
        }
    }

    // @Scheduled(cron = "0 0 1 * * *")
    public void deleteTemporaryDocument() {
        try {
            documentService.cronForRemoveTemporaryDocument();
        } catch (Exception e) {
            Logger.getLogger(CroneService.class.getName()).log(Level.INFO, e.getMessage(), e);
        }

    }

    @Scheduled(fixedDelay = 2000)
    public void checkRequestResponseList() {
        SystemConfiguration labelModel = systemConfigurationService.retrieveSysConfigurationByKey("IS_FILter_APPLIED_ON_EACH_REQUEST");
        RequestResponseLoggingFilter.isFilterStarted = Boolean.parseBoolean(labelModel.getKeyValue());
        requestResponseDetailsService.checkRequestResponse();
        labelModel = systemConfigurationService.retrieveSysConfigurationByKey("IS_USER_USAGE_ANALYTICS_ACTIVE");
        UserUsageAnalyticsController.isUserAnalyticsActive = Boolean.parseBoolean(labelModel.getKeyValue());
        requestResponseDetailsService.checkUserUsageList();
    }

    //    @Scheduled(cron = "0 0 */1 * * *")
    public void setSystemSyncConfig() {
        serverManagementService.fetchAndInsertConfiguration();
    }

    /**
     * This method will be called by timer event to delete old offline reports
     */
    public void deleteOfflineReport() {
        SystemConfiguration systemConfiguration = systemConfigurationService.retrieveSysConfigurationByKey("NUMBER_OF_DAYS_TO_DELETE_FILE_IN_OFFLINE_REPORT");
        int numberOfDays = Integer.parseInt(systemConfiguration.getKeyValue());
        if (numberOfDays > 0) {
            reportQueueService.deleteOldReports(numberOfDays);
        }
    }

    private void saveException(Exception e) {
        CaughtExceptionEntity exception = new CaughtExceptionEntity();
        exception.setExceptionMsg(e.getMessage());
        exception.setExceptionStackTrace(ExceptionUtils.getStackTrace(e));
        exception.setExceptionType("Cron Service");
        caughtExceptionService.saveCaughtException(exception);
    }

    private void syncDataForDhis2(){
        List<Integer> facilityIds = dhis2DataService.getEnabledFacilities();
        Date currentDate = new Date();
        for(Integer facilityId : facilityIds){
            dhis2DataService.sendData(currentDate, facilityId);
        }
    }
}
