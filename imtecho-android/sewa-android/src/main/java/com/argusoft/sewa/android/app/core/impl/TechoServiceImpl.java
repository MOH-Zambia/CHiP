package com.argusoft.sewa.android.app.core.impl;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.provider.Settings;

import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.core.TechoService;
import com.argusoft.sewa.android.app.databean.AnnouncementMobDataBean;
import com.argusoft.sewa.android.app.databean.ComponentTagBean;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.LoggedInUserPrincipleDataBean;
import com.argusoft.sewa.android.app.databean.LoginRequestParamDetailDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.MigratedFamilyDataBean;
import com.argusoft.sewa.android.app.databean.MigratedMembersDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.databean.QueryMobDataBean;
import com.argusoft.sewa.android.app.databean.RchVillageProfileDataBean;
import com.argusoft.sewa.android.app.databean.SurveyLocationMobDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.AnnouncementBean;
import com.argusoft.sewa.android.app.model.AnswerBean;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.FhwServiceDetailBean;
import com.argusoft.sewa.android.app.model.FormAccessibilityBean;
import com.argusoft.sewa.android.app.model.HealthInfrastructureBean;
import com.argusoft.sewa.android.app.model.LabelBean;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.LocationCoordinatesBean;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.model.LocationTypeBean;
import com.argusoft.sewa.android.app.model.LoginBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.MemberPregnancyStatusBean;
import com.argusoft.sewa.android.app.model.MenuBean;
import com.argusoft.sewa.android.app.model.MergedFamiliesBean;
import com.argusoft.sewa.android.app.model.MigratedFamilyBean;
import com.argusoft.sewa.android.app.model.MigratedMembersBean;
import com.argusoft.sewa.android.app.model.NotificationBean;
import com.argusoft.sewa.android.app.model.QuestionBean;
import com.argusoft.sewa.android.app.model.RchVillageProfileBean;
import com.argusoft.sewa.android.app.model.ReadNotificationsBean;
import com.argusoft.sewa.android.app.model.StoreAnswerBean;
import com.argusoft.sewa.android.app.model.VersionBean;
import com.argusoft.sewa.android.app.restclient.RestHttpException;
import com.argusoft.sewa.android.app.restclient.impl.ApiManager;
import com.argusoft.sewa.android.app.service.GPSTracker;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.argusoft.sewa.android.app.util.WSConstants;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.j256.ormlite.dao.Dao;
import com.j256.ormlite.stmt.DeleteBuilder;
import com.j256.ormlite.stmt.PreparedDelete;
import com.j256.ormlite.stmt.UpdateBuilder;
import com.j256.ormlite.table.TableUtils;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;
import org.androidannotations.annotations.RootContext;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import okhttp3.ResponseBody;

@EBean(scope = Singleton)
public class TechoServiceImpl implements TechoService {

    private SewaTransformer sewaTransformer = SewaTransformer.getInstance();
    private static final String TAG = "TechoServiceImpl";

    @RootContext
    Context context;

    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaServiceRestClientImpl sewaServiceRestClient;
    @Bean
    LocationMasterServiceImpl locationService;
    @Bean
    NotificationServiceImpl notificationService;
    @Bean
    ApiManager apiManager;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<VersionBean, Integer> versionBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<FamilyBean, Integer> familyBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberBean, Integer> memberBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationBean, Integer> locationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<FhwServiceDetailBean, Integer> fhwServiceDetailBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MergedFamiliesBean, Integer> mergedFamiliesBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<FormAccessibilityBean, Integer> formAccessibilityBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<NotificationBean, Integer> notificationBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<QuestionBean, Integer> questionBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<AnswerBean, Integer> answerBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LabelBean, Integer> labelBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LoginBean, Integer> loginBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<ListValueBean, Integer> listValueBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<AnnouncementBean, Integer> announcementBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<RchVillageProfileBean, Integer> rchVillageProfileBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationMasterBean, Integer> locationMasterBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MigratedMembersBean, Integer> migratedMembersBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<ReadNotificationsBean, Integer> readNotificationsBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<HealthInfrastructureBean, Integer> healthInfrastructureBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationCoordinatesBean, Integer> locationCoordinatesBeansDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<StoreAnswerBean, Integer> storeAnswerBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberPregnancyStatusBean, Integer> pregnancyStatusBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationTypeBean, Integer> locationTypeBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MenuBean, Integer> menuBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MigratedFamilyBean, Integer> migratedFamilyBeanDao;

    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.getDefault());
    private static final String MAX_UPDATED_ON = "MAX(updatedOn)";
    private static final String MAX_MODIFIED_ON = "MAX(modifiedOn)";

    @Override
    public Map<String, Boolean> checkIfDeviceIsBlockedOrDeleteDatabase(Context context) {
        String isBlocked = "isBlocked";
        String isDatabaseDeleted = "isDatabaseDeleted";
        Map<String, Boolean> deviceState = new HashMap<>();
        deviceState.put(isBlocked, false);
        deviceState.put(isDatabaseDeleted, false);
        try {
            String imei = Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID);
            if (imei == null || imei.isEmpty()) {
                return deviceState;
            }

            if (sewaService.isOnline()) {
                Map<String, Object> blockedDevice = sewaServiceRestClient.checkIfDeviceIsBlockedOrDeleteDatabase(imei);

                if (blockedDevice != null && !blockedDevice.isEmpty()) {
                    Object blockDevice = blockedDevice.get(GlobalTypes.BLOCKED_DEVICE_IS_BLOCK_DEVICE);
                    Object deleteDataBase = blockedDevice.get(GlobalTypes.BLOCKED_DEVICE_IS_DELETE_DATABASE);
                    if (blockDevice != null
                            && Boolean.TRUE.equals(Boolean.valueOf(blockDevice.toString()))) {
                        deviceState.put(isBlocked, true);
                        storeVersionBeanForBlockedImei(true);
                        deleteDatabaseFileFromLocal(context);
                    } else if (deleteDataBase != null
                            && Boolean.TRUE.equals(Boolean.valueOf(deleteDataBase.toString()))) {
                        deviceState.put(isDatabaseDeleted, true);
                        deleteDatabaseFileFromLocal(context);
                        sewaServiceRestClient.removeEntryForDeviceOfIMEI(imei);
                    } else {
                        storeVersionBeanForBlockedImei(false);
                    }
                } else {
                    storeVersionBeanForBlockedImei(false);
                }
            } else {
                List<VersionBean> versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_IMEI_BLOCKED);
                if (versionBeans != null && !versionBeans.isEmpty() && versionBeans.get(0).getValue().equals("1")) {
                    deviceState.put(isBlocked, true);
                }
            }
        } catch (SQLException | SecurityException | RestHttpException e) {
            Log.e(TAG, e.getMessage(), e);
        }
        return deviceState;
    }

    private void storeVersionBeanForBlockedImei(boolean isBlocked) {
        try {
            List<VersionBean> versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_IMEI_BLOCKED);

            if (versionBeans != null && !versionBeans.isEmpty()) {
                VersionBean versionBean = versionBeans.get(0);
                if (isBlocked) {
                    versionBean.setValue("1");
                } else {
                    versionBean.setValue("0");
                }
                versionBeanDao.update(versionBean);
            } else {
                VersionBean versionBean = new VersionBean();
                versionBean.setKey(GlobalTypes.VERSION_IMEI_BLOCKED);
                if (isBlocked) {
                    versionBean.setValue("1");
                } else {
                    versionBean.setValue("0");
                }
                versionBeanDao.create(versionBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void deleteDatabaseFileFromLocal(Context context) {
        try {
            File dir = new File(SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DATABASE));
            if (dir.isDirectory()) {
                String[] children = dir.list();
                for (String child : children) {
                    new File(dir, child).delete();
                }
            }
        } catch (Exception e) {
            Log.e(TAG, null, e);
        }
    }

    @Override
    public Boolean syncMergedFamiliesInformationWithServer() {
        String isSyncedWithServer = "isSyncedWithServer";
        try {
            List<MergedFamiliesBean> mergedFamiliesList = mergedFamiliesBeanDao.queryBuilder().where().eq(isSyncedWithServer, false).query();
            if (mergedFamiliesList != null && !mergedFamiliesList.isEmpty()) {
                Boolean status = sewaServiceRestClient.syncMergedFamiliesInformationWithServer(mergedFamiliesList);
                if (Boolean.TRUE.equals(status)) {
                    UpdateBuilder<MergedFamiliesBean, Integer> mergedFamiliesBeanIntegerUpdateBuilder = mergedFamiliesBeanDao.updateBuilder();
                    mergedFamiliesBeanIntegerUpdateBuilder.where().eq(isSyncedWithServer, false);
                    mergedFamiliesBeanIntegerUpdateBuilder.updateColumnValue(isSyncedWithServer, true);
                    mergedFamiliesBeanIntegerUpdateBuilder.update();
                }
            }
            return true;
        } catch (SQLException | RestHttpException e) {
            Log.e(TAG, e.getMessage(), e);
            return false;
        }
    }

    private void setImeiAndPhoneNumberInLoginParam(LoginRequestParamDetailDataBean param) {
        try {
            param.setImeiNumber(Settings.Secure.getString(context.getContentResolver(), Settings.Secure.ANDROID_ID));
        } catch (SecurityException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getDataForFHW() {
        try {
            List<VersionBean> versionBeans;
            LoginRequestParamDetailDataBean loginRequestParamDetailDataBean = new LoginRequestParamDetailDataBean();
            loginRequestParamDetailDataBean.setToken(SewaTransformer.loginBean.getUserToken());
            loginRequestParamDetailDataBean.setUserId(SewaTransformer.loginBean.getUserID());
            loginRequestParamDetailDataBean.setRoleType(GlobalTypes.ANNOUNCE_FOR_FHW);
            loginRequestParamDetailDataBean.setVillageCode(SewaTransformer.loginBean.getVillageCode());
            loginRequestParamDetailDataBean.setSdkVersion(Build.VERSION.SDK_INT);
            setImeiAndPhoneNumberInLoginParam(loginRequestParamDetailDataBean);

            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                loginRequestParamDetailDataBean.setLongitude(String.valueOf(GPSTracker.latitude));
                loginRequestParamDetailDataBean.setLatitude(String.valueOf(GPSTracker.longitude));
            }

            //For getting Free Space
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            long bytesAvailable = stat.getBlockSizeLong() * stat.getAvailableBlocksLong();
            long megAvailable = bytesAvailable / (1024 * 1024);
            Log.i(TAG, LabelConstants.AVAILABLE_SPACE_IN_MB + megAvailable);
            loginRequestParamDetailDataBean.setFreeSpaceMB(megAvailable);

            if (familyBeanDao.countOf() > 0 && memberBeanDao.countOf() > 0) {
                String string = familyBeanDao.queryBuilder().selectRaw(MAX_UPDATED_ON).prepareStatementString();
                String[] result = familyBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null)
                    loginRequestParamDetailDataBean.setLastUpdateDateForFamily(String.valueOf(sdf.parse(result[0]).getTime()));
            }

            if (notificationBeanDao.countOf() > 0) {
                String string = notificationBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = notificationBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(0L);
                }
            }

            if (migratedMembersBeanDao.countOf() > 0) {
                String string = migratedMembersBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = migratedMembersBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForMigrationDetails(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForMigrationDetails(0L);
                }
            }

            if (readNotificationsBeanDao.countOf() > 0) {
                List<Long> list = new ArrayList<>();
                List<ReadNotificationsBean> readNotificationsBeans = readNotificationsBeanDao.queryForAll();
                for (ReadNotificationsBean readNotificationsBean : readNotificationsBeans) {
                    list.add(readNotificationsBean.getNotificationId());
                }
                loginRequestParamDetailDataBean.setReadNotifications(list);
            }

            if (announcementBeanDao.countOf() > 0) {
                String string = announcementBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = announcementBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateOfAnnouncements(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateOfAnnouncements(0L);
                }
            }

            if (listValueBeanDao.countOf() > 0) {
                String string = listValueBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = listValueBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
            }

            if (pregnancyStatusBeanDao.countOf() > 0) {
                versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_PREGNANCY_STATUS);
                if (versionBeans != null && !versionBeans.isEmpty()) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForPregnancyStatus(Long.valueOf(versionBeans.get(0).getValue()));
                }
            }

            if (labelBeanDao.countOf() > 0) {
                String string = labelBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = labelBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.FHW_SHEET_VERSION);
            Map<String, Integer> sheetNameVersionMap = new HashMap<>();
            if (versionBeans != null && !versionBeans.isEmpty()) {
                sheetNameVersionMap.put(GlobalTypes.FHW_SHEET_VERSION, Integer.valueOf(versionBeans.get(0).getVersion()));
            } else {
                sheetNameVersionMap.put(GlobalTypes.FHW_SHEET_VERSION, 0);
            }
            loginRequestParamDetailDataBean.setSheetNameVersionMap(sheetNameVersionMap);

            if (locationMasterBeanDao.countOf() > 0) {
                String string = locationMasterBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationMasterBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(String.valueOf(sdf.parse(result[0]).getTime()));
                }
            }

            if (healthInfrastructureBeanDao.countOf() > 0) {
                versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
                if (versionBeans != null && !versionBeans.isEmpty()) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(Long.valueOf(versionBeans.get(0).getValue()));
                }
            }

            if (locationTypeBeanDao.countOf() > 0) {
                String string = locationTypeBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationTypeBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocationTypeMaster(sdf.parse(result[0]).getTime());
                }
            }


            if (menuBeanDao.countOf() > 0) {
                Date modifiedOn = menuBeanDao.queryBuilder().queryForFirst().getModifiedOn();
                if (modifiedOn != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForMenuMaster(modifiedOn.getTime());
                }
            }

            //MAIN API CALL TO SERVER FOR BRINGING ALL THE DATA
            Date apiStartDate = new Date();
            Log.i(TAG, LabelConstants.CALLING_MAIN_API_FOR_BRINGING_DATA);
            LoggedInUserPrincipleDataBean loggedInUserPrincipleDataBean = sewaServiceRestClient.getDetails(loginRequestParamDetailDataBean);
            Log.i(TAG, LabelConstants.DATA_FROM_MAIN_API_RETRIEVED + UtilBean.getDifferenceBetweenTwoDates(apiStartDate, new Date()));

            if (loggedInUserPrincipleDataBean == null) {
                return;
            }

            //Delete Families
            if (loggedInUserPrincipleDataBean.getDeletedFamilies() != null && !loggedInUserPrincipleDataBean.getDeletedFamilies().isEmpty()) {
                Log.i(TAG, LabelConstants.DELETE_FAMILIES_COUNT + loggedInUserPrincipleDataBean.getDeletedFamilies().size());
                this.deleteFamiliesFromDatabaseFHW(loggedInUserPrincipleDataBean.getDeletedFamilies());
            }

            //For storeAllAssignedFamilies
            if (loggedInUserPrincipleDataBean.getAssignedFamilies() != null && !loggedInUserPrincipleDataBean.getAssignedFamilies().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_FAMILIES_COUNT + loggedInUserPrincipleDataBean.getAssignedFamilies().size());
                this.storeAllAssignedFamilies(loggedInUserPrincipleDataBean.getAssignedFamilies());
            }

            //For storeUpdatedFamilyData
            boolean updateVersionBeanForFamilyData = true;
            if (loggedInUserPrincipleDataBean.getUpdatedFamilyByDate() != null && !loggedInUserPrincipleDataBean.getUpdatedFamilyByDate().isEmpty()) {
                Log.i(TAG, LabelConstants.UPDATED_FAMILIES_COUNT + loggedInUserPrincipleDataBean.getUpdatedFamilyByDate().size());
                updateVersionBeanForFamilyData = this.storeUpdatedFamilyData(loggedInUserPrincipleDataBean.getUpdatedFamilyByDate());
            }

            if (loggedInUserPrincipleDataBean.getLocationsForFamilyDataDeletion() != null && !loggedInUserPrincipleDataBean.getLocationsForFamilyDataDeletion().isEmpty()
                    && updateVersionBeanForFamilyData) {
                Log.i(TAG, LabelConstants.DELETE_FAMILIES_BY_LOCATION_COUNT + loggedInUserPrincipleDataBean.getLocationsForFamilyDataDeletion().size());
                this.deleteFamiliesByLocationFHW(loggedInUserPrincipleDataBean.getLocationsForFamilyDataDeletion());
            }

            //For storeFhwServiceDetailBeans
            if (loggedInUserPrincipleDataBean.getFhwServiceStatusDtos() != null && !loggedInUserPrincipleDataBean.getFhwServiceStatusDtos().isEmpty()) {
                Log.i(TAG, LabelConstants.FHW_SERVICE_STATUS_COUNT + loggedInUserPrincipleDataBean.getFhwServiceStatusDtos().size());
                this.storeFhwServiceDetailBeans(loggedInUserPrincipleDataBean.getFhwServiceStatusDtos());
            } else {
                TableUtils.clearTable(fhwServiceDetailBeanDao.getConnectionSource(), FhwServiceDetailBean.class);
            }

            //For retrieveOrphanedOrReverificationFamiliesForFHS
            if (loggedInUserPrincipleDataBean.getOrphanedAndReverificationFamilies() != null && !loggedInUserPrincipleDataBean.getOrphanedAndReverificationFamilies().isEmpty()) {
                Log.i(TAG, LabelConstants.ORPHANED_AND_REVERIFICATION_FAMILIES_COUNT + loggedInUserPrincipleDataBean.getOrphanedAndReverificationFamilies().size());
                this.storeOrphanedAndReverificationFamiliesForFHW(loggedInUserPrincipleDataBean.getOrphanedAndReverificationFamilies());
            }

            //For storeLocationBeansAssignedToUser
            if (loggedInUserPrincipleDataBean.getRetrievedVillageAndChildLocations() != null && !loggedInUserPrincipleDataBean.getRetrievedVillageAndChildLocations().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_LOCATIONS_AND_CHILD_LOCATIONS_COUNT + loggedInUserPrincipleDataBean.getRetrievedVillageAndChildLocations().size());
                this.storeLocationBeansAssignedToUser(loggedInUserPrincipleDataBean.getRetrievedVillageAndChildLocations());
            }

            if (loggedInUserPrincipleDataBean.getCsvCoordinates() != null) {
                this.storeLocationCoordinates(loggedInUserPrincipleDataBean.getCsvCoordinates());
            }

            //For storeNotificationsForUser
            if (loginRequestParamDetailDataBean.getLastUpdateDateForNotifications() != null) {
                if (loggedInUserPrincipleDataBean.getDeletedNotifications() != null && !loggedInUserPrincipleDataBean.getDeletedNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.DELETED_NOTIFICATIONS_COUNT + loggedInUserPrincipleDataBean.getDeletedNotifications().size());
                    this.deleteNotificationsForUser(loggedInUserPrincipleDataBean.getDeletedNotifications());
                }
                if (loggedInUserPrincipleDataBean.getNotifications() != null && !loggedInUserPrincipleDataBean.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + loggedInUserPrincipleDataBean.getNotifications().size());
                    this.storeNotificationsForUser(loggedInUserPrincipleDataBean.getNotifications(), new Date(loginRequestParamDetailDataBean.getLastUpdateDateForNotifications()));
                }
            } else {
                if (loggedInUserPrincipleDataBean.getNotifications() != null && !loggedInUserPrincipleDataBean.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + loggedInUserPrincipleDataBean.getNotifications().size());
                    this.storeNotificationsForUser(loggedInUserPrincipleDataBean.getNotifications(), null);
                } else {
                    TableUtils.clearTable(notificationBeanDao.getConnectionSource(), NotificationBean.class);
                }
            }

            //For retrieving Village Profile
            if (loggedInUserPrincipleDataBean.getRchVillageProfileDataBeans() != null && !loggedInUserPrincipleDataBean.getRchVillageProfileDataBeans().isEmpty()) {
                Log.i(TAG, LabelConstants.RCH_VILLAGE_PROFILES_COUNT + loggedInUserPrincipleDataBean.getRchVillageProfileDataBeans().size());
                this.storeRchVillageProfileBeanFromServer(loggedInUserPrincipleDataBean.getRchVillageProfileDataBeans());
            }

            //For storing MigratedMemberData
            if (loggedInUserPrincipleDataBean.getMigratedMembersDataBeans() != null && !loggedInUserPrincipleDataBean.getMigratedMembersDataBeans().isEmpty()) {
                Log.i(TAG, LabelConstants.MIGRATED_MEMBERS_COUNT + loggedInUserPrincipleDataBean.getMigratedMembersDataBeans().size());
                this.storeMigrationDetails(loggedInUserPrincipleDataBean.getMigratedMembersDataBeans());
            }

            //For storing MigratedFamilyData
            if (loggedInUserPrincipleDataBean.getMigratedFamilyDataBeans() != null && !loggedInUserPrincipleDataBean.getMigratedFamilyDataBeans().isEmpty()) {
                Log.i(TAG, LabelConstants.MIGRATED_FAMILY_COUNT + loggedInUserPrincipleDataBean.getMigratedFamilyDataBeans().size());
                this.storeMigrationFamilyDetails(loggedInUserPrincipleDataBean.getMigratedFamilyDataBeans());
            }

            //For storeLabelsDetailsToDatabase
            if (loggedInUserPrincipleDataBean.getRetrievedLabels() != null) {
                Log.i(TAG, LabelConstants.LABELS_COUNT + loggedInUserPrincipleDataBean.getRetrievedLabels().getResult().size());
                this.storeLabelsDetailsToDatabase(loggedInUserPrincipleDataBean.getRetrievedLabels());
            }

            //For storeXlsDataToDatabaseForFHW
            if (loggedInUserPrincipleDataBean.getRetrievedXlsData() != null && !loggedInUserPrincipleDataBean.getRetrievedXlsData().isEmpty()) {
                Log.i(TAG, LabelConstants.XLS_DATA_COUNT + loggedInUserPrincipleDataBean.getRetrievedXlsData().size());
                this.storeXlsDataToDatabaseForFHW(loggedInUserPrincipleDataBean.getRetrievedXlsData(), loggedInUserPrincipleDataBean.getCurrentSheetVersion());
            }

            //Storing List Values
            if (loggedInUserPrincipleDataBean.getRetrievedListValues() != null && !loggedInUserPrincipleDataBean.getRetrievedListValues().isEmpty()) {
                Log.i(TAG, LabelConstants.LIST_VALUES_COUNT + loggedInUserPrincipleDataBean.getRetrievedListValues().size());
                this.storeAllListValues(loggedInUserPrincipleDataBean.getRetrievedListValues());
            }

            //Storing Pregnancy Status
            this.storePregnancyStatusBeans(loggedInUserPrincipleDataBean);

            //For retrieving Announcements
            if (loggedInUserPrincipleDataBean.getRetrievedAnnouncements() != null && !loggedInUserPrincipleDataBean.getRetrievedAnnouncements().isEmpty()) {
                Log.i(TAG, LabelConstants.ANNOUNCEMENTS_COUNT + loggedInUserPrincipleDataBean.getRetrievedAnnouncements().size());
                this.storeAllAnnouncement(loggedInUserPrincipleDataBean.getRetrievedAnnouncements());
            } else {
                downloadAnnouncementFileFromServer();
            }

            if (loggedInUserPrincipleDataBean.getFeatures() != null && !loggedInUserPrincipleDataBean.getFeatures().isEmpty()) {
                List<VersionBean> featureVersionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_FEATURES_LIST);
                VersionBean versionBean;
                if (featureVersionBeans == null || featureVersionBeans.isEmpty()) {
                    VersionBean versionBean1 = new VersionBean();
                    versionBean1.setKey(GlobalTypes.VERSION_FEATURES_LIST);
                    versionBean1.setValue(UtilBean.stringListJoin(loggedInUserPrincipleDataBean.getFeatures(), ","));
                    versionBeanDao.create(versionBean1);
                } else {
                    versionBean = featureVersionBeans.get(0);
                    versionBean.setValue(UtilBean.stringListJoin(loggedInUserPrincipleDataBean.getFeatures(), ","));
                    versionBeanDao.update(versionBean);
                }
            } else {
                DeleteBuilder<VersionBean, Integer> deleteBuilder = versionBeanDao.deleteBuilder();
                deleteBuilder.where().eq(FieldNameConstants.KEY, GlobalTypes.VERSION_FEATURES_LIST);
                deleteBuilder.delete();
            }

            //For storing location master information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForLocation() == null) {
                Log.i(TAG, LabelConstants.ALL_LOCATION_MASTER_COUNT + loggedInUserPrincipleDataBean.getLocationMasterBeans().size());
                TableUtils.clearTable(locationMasterBeanDao.getConnectionSource(), LocationMasterBean.class);
                this.storeLocationMasterBeans(loggedInUserPrincipleDataBean.getLocationMasterBeans(), true);
            } else {
                this.storeLocationMasterBeans(loggedInUserPrincipleDataBean.getLocationMasterBeans(), false);
            }

            //For storing health infrastructure information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForHealthInfrastructure() == null) {
                TableUtils.clearTable(healthInfrastructureBeanDao.getConnectionSource(), HealthInfrastructureBean.class);
                Log.i(TAG, LabelConstants.ALL_HEALTH_INFRASTRUCTURES_COUNT + loggedInUserPrincipleDataBean.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(loggedInUserPrincipleDataBean.getHealthInfrastructures(), true);
            } else {
                Log.i(TAG, LabelConstants.HEALTH_INFRASTRUCTURES_COUNT + loggedInUserPrincipleDataBean.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(loggedInUserPrincipleDataBean.getHealthInfrastructures(), false);
            }

            //For storing location types
            this.storeLocationTypeBeans(loggedInUserPrincipleDataBean.getLocationTypeMasters(), loginRequestParamDetailDataBean.getLastUpdateDateForLocationTypeMaster());

            //For storing menu information
            this.storeMenuDetails(loggedInUserPrincipleDataBean.getMobileMenus());

        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
            SharedStructureData.NETWORK_MESSAGE = SewaConstants.SQL_EXCEPTION;
            SharedStructureData.sewaService.storeException(e, GlobalTypes.EXCEPTION_TYPE_SQL);
        } catch (Exception e) {
            SharedStructureData.NETWORK_MESSAGE = SewaConstants.EXCEPTION_FETCHING_DATA_FOR_USER;
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getDataForASHA() {
        try {
            List<VersionBean> versionBeans;
            LoginRequestParamDetailDataBean loginRequestParamDetailDataBean = new LoginRequestParamDetailDataBean();
            loginRequestParamDetailDataBean.setToken(SewaTransformer.loginBean.getUserToken());
            loginRequestParamDetailDataBean.setUserId(SewaTransformer.loginBean.getUserID());
            loginRequestParamDetailDataBean.setRoleType(GlobalTypes.ANNOUNCE_FOR_ASHA);
            loginRequestParamDetailDataBean.setVillageCode(SewaTransformer.loginBean.getVillageCode());
            loginRequestParamDetailDataBean.setSdkVersion(Build.VERSION.SDK_INT);
            setImeiAndPhoneNumberInLoginParam(loginRequestParamDetailDataBean);

            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                loginRequestParamDetailDataBean.setLongitude(String.valueOf(GPSTracker.latitude));
                loginRequestParamDetailDataBean.setLatitude(String.valueOf(GPSTracker.longitude));
            }

            //For getting Free Space
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            long bytesAvailable = stat.getBlockSizeLong() * stat.getAvailableBlocksLong();
            long megAvailable = bytesAvailable / (1024 * 1024);
            Log.i(TAG, LabelConstants.AVAILABLE_SPACE_IN_MB + megAvailable);
            loginRequestParamDetailDataBean.setFreeSpaceMB(megAvailable);

            if (familyBeanDao.countOf() > 0) {
                String string = familyBeanDao.queryBuilder().selectRaw(MAX_UPDATED_ON).prepareStatementString();
                String[] result = familyBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForFamily(String.valueOf(sdf.parse(result[0]).getTime()));
                }
            }

            if (listValueBeanDao.countOf() > 0) {
                String string = listValueBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = listValueBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
            }

            if (labelBeanDao.countOf() > 0) {
                String string = labelBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = labelBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
            }

            if (notificationBeanDao.countOf() > 0) {
                String string = notificationBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = notificationBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(0L);
                }
            }

            if (readNotificationsBeanDao.countOf() > 0) {
                List<Long> list = new ArrayList<>();
                List<ReadNotificationsBean> readNotificationsBeans = readNotificationsBeanDao.queryForAll();
                for (ReadNotificationsBean readNotificationsBean : readNotificationsBeans) {
                    list.add(readNotificationsBean.getNotificationId());
                }
                loginRequestParamDetailDataBean.setReadNotifications(list);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.ASHA_SHEET_VERSION);
            Map<String, Integer> sheetNameVersionMap = new HashMap<>();
            if (versionBeans != null && !versionBeans.isEmpty()) {
                sheetNameVersionMap.put(GlobalTypes.ASHA_SHEET_VERSION, Integer.valueOf(versionBeans.get(0).getVersion()));
            } else {
                sheetNameVersionMap.put(GlobalTypes.ASHA_SHEET_VERSION, 0);
            }
            loginRequestParamDetailDataBean.setSheetNameVersionMap(sheetNameVersionMap);

            if (locationMasterBeanDao.countOf() > 0) {
                String string = locationMasterBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationMasterBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(String.valueOf(sdf.parse(result[0]).getTime()));
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
            if (versionBeans != null && !versionBeans.isEmpty()) {
                loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(Long.valueOf(versionBeans.get(0).getValue()));
                if (healthInfrastructureBeanDao.countOf() == 0) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(null);
                }
            }

            //MAIN API CALL TO SERVER FOR BRINGING ALL THE DATA
            Log.i(TAG, LabelConstants.CALLING_MAIN_API_FOR_BRINGING_DATA + new Date());
            LoggedInUserPrincipleDataBean details = sewaServiceRestClient.getDetailsForAsha(loginRequestParamDetailDataBean);
            Log.i(TAG, LabelConstants.DATA_FROM_MAIN_API_RETRIEVED + new Date());

            // Storing Assigned Families
            if (details.getAssignedFamilies() != null && !details.getAssignedFamilies().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_FAMILIES_COUNT + details.getAssignedFamilies().size());
                this.storeAllAssignedFamilies(details.getAssignedFamilies());
            }

            // Storing Updated Families
            if (details.getUpdatedFamilyByDate() != null && !details.getUpdatedFamilyByDate().isEmpty()) {
                Log.i(TAG, LabelConstants.UPDATED_FAMILIES_COUNT + details.getUpdatedFamilyByDate().size());
                this.storeUpdatedFamilyData(details.getUpdatedFamilyByDate());
            }

            //For storeNotificationsForUser
            if (loginRequestParamDetailDataBean.getLastUpdateDateForNotifications() != null) {
                if (details.getDeletedNotifications() != null && !details.getDeletedNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.DELETED_NOTIFICATIONS_COUNT + details.getDeletedNotifications().size());
                    this.deleteNotificationsForUser(details.getDeletedNotifications());
                }
                if (details.getNotifications() != null && !details.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + details.getNotifications().size());
                    this.storeNotificationsForUser(details.getNotifications(), new Date(loginRequestParamDetailDataBean.getLastUpdateDateForNotifications()));
                }
            } else {
                if (details.getNotifications() != null && !details.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + details.getNotifications().size());
                    this.storeNotificationsForUser(details.getNotifications(), null);
                } else {
                    TableUtils.clearTable(notificationBeanDao.getConnectionSource(), NotificationBean.class);
                }
            }

            //Storing Labels
            if (details.getRetrievedLabels() != null) {
                Log.i(TAG, LabelConstants.LABELS_COUNT + details.getRetrievedLabels().getResult().size());
                this.storeLabelsDetailsToDatabase(details.getRetrievedLabels());
            }

            //Storing List Values
            if (details.getRetrievedListValues() != null && !details.getRetrievedListValues().isEmpty()) {
                Log.i(TAG, LabelConstants.LIST_VALUES_COUNT + details.getRetrievedListValues().size());
                this.storeAllListValues(details.getRetrievedListValues());
            }

            //Storing Announcements
            if (details.getRetrievedAnnouncements() != null && !details.getRetrievedAnnouncements().isEmpty()) {
                Log.i(TAG, LabelConstants.ANNOUNCEMENTS_COUNT + details.getRetrievedAnnouncements().size());
                this.storeAllAnnouncement(details.getRetrievedAnnouncements());
            } else {
                this.downloadAnnouncementFileFromServer();
            }

            //Storing XLS Data
            if (details.getRetrievedXlsData() != null && !details.getRetrievedXlsData().isEmpty()) {
                Log.i(TAG, LabelConstants.XLS_DATA_COUNT + details.getRetrievedXlsData().size());
                this.storeXlsDataToDatabaseForASHA(details.getRetrievedXlsData(), details.getCurrentSheetVersion());
            }

            //Storing Asha Area & Child Locations
            if (details.getRetrievedVillageAndChildLocations() != null && !details.getRetrievedVillageAndChildLocations().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_LOCATIONS_AND_CHILD_LOCATIONS_COUNT + details.getRetrievedVillageAndChildLocations().size());
                this.storeLocationBeansAssignedToUser(details.getRetrievedVillageAndChildLocations());
            }

            //For storing location master information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForLocation() == null) {
                Log.i(TAG, LabelConstants.ALL_LOCATION_MASTER_COUNT + details.getLocationMasterBeans().size());
                TableUtils.clearTable(locationMasterBeanDao.getConnectionSource(), LocationMasterBean.class);
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), true);
            } else {
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), false);
            }

            //For storing health infrastructure information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForHealthInfrastructure() == null) {
                TableUtils.clearTable(healthInfrastructureBeanDao.getConnectionSource(), HealthInfrastructureBean.class);
                Log.i(TAG, LabelConstants.ALL_HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), true);
            } else {
                Log.i(TAG, LabelConstants.HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), false);
            }

        } catch (SQLException | ParseException | RestHttpException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getDataForFHSR() {
        try {
            List<VersionBean> versionBeans;
            LoginRequestParamDetailDataBean loginRequestParamDetailDataBean = new LoginRequestParamDetailDataBean();
            loginRequestParamDetailDataBean.setToken(SewaTransformer.loginBean.getUserToken());
            loginRequestParamDetailDataBean.setUserId(SewaTransformer.loginBean.getUserID());
            loginRequestParamDetailDataBean.setRoleType(GlobalTypes.ANNOUNCE_FOR_ASHA);
            loginRequestParamDetailDataBean.setVillageCode(SewaTransformer.loginBean.getVillageCode());
            loginRequestParamDetailDataBean.setSdkVersion(Build.VERSION.SDK_INT);
            setImeiAndPhoneNumberInLoginParam(loginRequestParamDetailDataBean);

            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                loginRequestParamDetailDataBean.setLongitude(String.valueOf(GPSTracker.latitude));
                loginRequestParamDetailDataBean.setLatitude(String.valueOf(GPSTracker.longitude));
            }

            //For getting Free Space
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            long bytesAvailable = stat.getBlockSizeLong() * stat.getAvailableBlocksLong();
            long megAvailable = bytesAvailable / (1024 * 1024);
            Log.i(TAG, LabelConstants.AVAILABLE_SPACE_IN_MB + megAvailable);
            loginRequestParamDetailDataBean.setFreeSpaceMB(megAvailable);

            if (labelBeanDao.countOf() > 0) {
                String string = labelBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = labelBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
            }

            if (listValueBeanDao.countOf() > 0) {
                String string = listValueBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = listValueBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
            }

            if (locationMasterBeanDao.countOf() > 0) {
                String string = locationMasterBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationMasterBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(String.valueOf(sdf.parse(result[0]).getTime()));
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
            if (versionBeans != null && !versionBeans.isEmpty()) {
                loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(Long.valueOf(versionBeans.get(0).getValue()));
                if (healthInfrastructureBeanDao.countOf() == 0) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(null);
                }
            }

            //MAIN API CALL TO SERVER FOR BRINGING ALL THE DATA
            Log.i(TAG, LabelConstants.CALLING_MAIN_API_FOR_BRINGING_DATA + new Date());
            LoggedInUserPrincipleDataBean details = sewaServiceRestClient.getDetailsForFHSR(loginRequestParamDetailDataBean);
            Log.i(TAG, LabelConstants.DATA_FROM_MAIN_API_RETRIEVED + new Date());

            //Storing List Values
            if (details.getRetrievedListValues() != null && !details.getRetrievedListValues().isEmpty()) {
                Log.i(TAG, LabelConstants.LIST_VALUES_COUNT + details.getRetrievedListValues().size());
                this.storeAllListValues(details.getRetrievedListValues());
            }

            //Storing PHC & Child Locations
            if (details.getRetrievedVillageAndChildLocations() != null && !details.getRetrievedVillageAndChildLocations().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_LOCATIONS_AND_CHILD_LOCATIONS_COUNT + details.getRetrievedVillageAndChildLocations().size());
                this.storeLocationBeansAssignedToUser(details.getRetrievedVillageAndChildLocations());
            }

            //Storing Labels
            if (details.getRetrievedLabels() != null) {
                Log.i(TAG, LabelConstants.LABELS_COUNT + details.getRetrievedLabels().getResult().size());
                this.storeLabelsDetailsToDatabase(details.getRetrievedLabels());
            }

            //Storing Announcements
            if (details.getRetrievedAnnouncements() != null && !details.getRetrievedAnnouncements().isEmpty()) {
                Log.i(TAG, LabelConstants.ANNOUNCEMENTS_COUNT + details.getRetrievedAnnouncements().size());
                this.storeAllAnnouncement(details.getRetrievedAnnouncements());
            } else {
                this.downloadAnnouncementFileFromServer();
            }

            //For storing location master information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForLocation() == null) {
                Log.i(TAG, LabelConstants.ALL_LOCATION_MASTER_COUNT + details.getLocationMasterBeans().size());
                TableUtils.clearTable(locationMasterBeanDao.getConnectionSource(), LocationMasterBean.class);
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), true);
            } else {
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), false);
            }

            //For storing health infrastructure information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForHealthInfrastructure() == null) {
                TableUtils.clearTable(healthInfrastructureBeanDao.getConnectionSource(), HealthInfrastructureBean.class);
                Log.i(TAG, LabelConstants.ALL_HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), true);
            } else {
                Log.i(TAG, LabelConstants.HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), false);
            }

            if (Boolean.FALSE.equals(SharedStructureData.currentlyDownloadingFamilyData)) {
                SharedStructureData.currentlyDownloadingFamilyData = true;
                AsyncTask.execute(this::retrieveFamiliesForFHSR);
            }
        } catch (SQLException | ParseException | RestHttpException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getDataForRbsk() {
        try {
            List<VersionBean> versionBeans;
            LoginRequestParamDetailDataBean loginRequestParamDetailDataBean = new LoginRequestParamDetailDataBean();
            loginRequestParamDetailDataBean.setToken(SewaTransformer.loginBean.getUserToken());
            loginRequestParamDetailDataBean.setUserId(SewaTransformer.loginBean.getUserID());
            loginRequestParamDetailDataBean.setRoleType(GlobalTypes.ANNOUNCE_FOR_ASHA);
            loginRequestParamDetailDataBean.setVillageCode(SewaTransformer.loginBean.getVillageCode());
            loginRequestParamDetailDataBean.setSdkVersion(Build.VERSION.SDK_INT);
            setImeiAndPhoneNumberInLoginParam(loginRequestParamDetailDataBean);

            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                loginRequestParamDetailDataBean.setLongitude(String.valueOf(GPSTracker.latitude));
                loginRequestParamDetailDataBean.setLatitude(String.valueOf(GPSTracker.longitude));
            }

            //For getting Free Space
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            long bytesAvailable = stat.getBlockSizeLong() * stat.getAvailableBlocksLong();
            long megAvailable = bytesAvailable / (1024 * 1024);
            Log.i(TAG, LabelConstants.AVAILABLE_SPACE_IN_MB + megAvailable);
            loginRequestParamDetailDataBean.setFreeSpaceMB(megAvailable);

            if (locationMasterBeanDao.countOf() > 0) {
                String string = locationMasterBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationMasterBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(String.valueOf(sdf.parse(result[0]).getTime()));
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
            if (versionBeans != null && !versionBeans.isEmpty()) {
                loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(Long.valueOf(versionBeans.get(0).getValue()));
                if (healthInfrastructureBeanDao.countOf() == 0) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(null);
                }
            }

            //MAIN API CALL TO SERVER FOR BRINGING ALL THE DATA
            Log.i(TAG, LabelConstants.CALLING_MAIN_API_FOR_BRINGING_DATA + new Date());
            LoggedInUserPrincipleDataBean details = sewaServiceRestClient.getDetailsForRbsk(loginRequestParamDetailDataBean);
            Log.i(TAG, LabelConstants.DATA_FROM_MAIN_API_RETRIEVED + new Date());

            //For storing location master information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForLocation() == null) {
                Log.i(TAG, LabelConstants.ALL_LOCATION_MASTER_COUNT + details.getLocationMasterBeans().size());
                TableUtils.clearTable(locationMasterBeanDao.getConnectionSource(), LocationMasterBean.class);
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), true);
            } else {
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), false);
            }

            //For storing health infrastructure information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForHealthInfrastructure() == null) {
                TableUtils.clearTable(healthInfrastructureBeanDao.getConnectionSource(), HealthInfrastructureBean.class);
                Log.i(TAG, LabelConstants.ALL_HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), true);
            } else {
                Log.i(TAG, LabelConstants.HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), false);
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getDataForAWW() {
        try {
            List<VersionBean> versionBeans;
            LoginRequestParamDetailDataBean loginRequestParamDetailDataBean = new LoginRequestParamDetailDataBean();
            loginRequestParamDetailDataBean.setToken(SewaTransformer.loginBean.getUserToken());
            loginRequestParamDetailDataBean.setUserId(SewaTransformer.loginBean.getUserID());
            loginRequestParamDetailDataBean.setRoleType(GlobalTypes.ANNOUNCE_FOR_ASHA);
            loginRequestParamDetailDataBean.setVillageCode(SewaTransformer.loginBean.getVillageCode());
            loginRequestParamDetailDataBean.setSdkVersion(Build.VERSION.SDK_INT);
            setImeiAndPhoneNumberInLoginParam(loginRequestParamDetailDataBean);

            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                loginRequestParamDetailDataBean.setLongitude(String.valueOf(GPSTracker.latitude));
                loginRequestParamDetailDataBean.setLatitude(String.valueOf(GPSTracker.longitude));
            }

            //For getting Free Space
            StatFs stat = new StatFs(Environment.getExternalStorageDirectory().getPath());
            long bytesAvailable = stat.getBlockSizeLong() * stat.getAvailableBlocksLong();
            long megAvailable = bytesAvailable / (1024 * 1024);
            Log.i(TAG, LabelConstants.AVAILABLE_SPACE_IN_MB + megAvailable);
            loginRequestParamDetailDataBean.setFreeSpaceMB(megAvailable);

            if (familyBeanDao.countOf() > 0) {
                String string = familyBeanDao.queryBuilder().selectRaw(MAX_UPDATED_ON).prepareStatementString();
                String[] result = familyBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForFamily(String.valueOf(sdf.parse(result[0]).getTime()));
                }
            }

            if (notificationBeanDao.countOf() > 0) {
                String string = notificationBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = notificationBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForNotifications(0L);
                }
            }

            if (listValueBeanDao.countOf() > 0) {
                String string = listValueBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = listValueBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForListValue(0L);
            }

            if (labelBeanDao.countOf() > 0) {
                String string = labelBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = labelBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(sdf.parse(result[0]).getTime());
                } else {
                    loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
                }
            } else {
                loginRequestParamDetailDataBean.setCreatedOnDateForLabel(0L);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.AWW_SHEET_VERSION);
            Map<String, Integer> sheetNameVersionMap = new HashMap<>();
            if (versionBeans != null && !versionBeans.isEmpty()) {
                sheetNameVersionMap.put(GlobalTypes.AWW_SHEET_VERSION, Integer.valueOf(versionBeans.get(0).getVersion()));
            } else {
                sheetNameVersionMap.put(GlobalTypes.AWW_SHEET_VERSION, 0);
            }
            loginRequestParamDetailDataBean.setSheetNameVersionMap(sheetNameVersionMap);

            if (locationMasterBeanDao.countOf() > 0) {
                String string = locationMasterBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = locationMasterBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(String.valueOf(sdf.parse(result[0]).getTime()));
                } else {
                    loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
                }
            } else {
                loginRequestParamDetailDataBean.setLastUpdateDateForLocation(null);
            }

            versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
            if (versionBeans != null && !versionBeans.isEmpty()) {
                loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(Long.valueOf(versionBeans.get(0).getValue()));
                if (healthInfrastructureBeanDao.countOf() == 0) {
                    loginRequestParamDetailDataBean.setLastUpdateDateForHealthInfrastructure(null);
                }
            }

            //MAIN API CALL TO SERVER FOR BRINGING ALL THE DATA
            Log.i(TAG, LabelConstants.CALLING_MAIN_API_FOR_BRINGING_DATA + new Date());
            LoggedInUserPrincipleDataBean details = sewaServiceRestClient.getDetailsForAww(loginRequestParamDetailDataBean);
            Log.i(TAG, LabelConstants.DATA_FROM_MAIN_API_RETRIEVED + new Date());

            // Storing Assigned Families
            if (details.getAssignedFamilies() != null && !details.getAssignedFamilies().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_FAMILIES_COUNT + details.getAssignedFamilies().size());
                this.storeAllAssignedFamilies(details.getAssignedFamilies());
            }

            // Storing Updated Families
            if (details.getUpdatedFamilyByDate() != null && !details.getUpdatedFamilyByDate().isEmpty()) {
                Log.i(TAG, LabelConstants.UPDATED_FAMILIES_COUNT + details.getUpdatedFamilyByDate().size());
                this.storeUpdatedFamilyData(details.getUpdatedFamilyByDate());
            }

            // Storing Updated Notifications
            if (loginRequestParamDetailDataBean.getLastUpdateDateForNotifications() != null) {
                if (details.getDeletedNotifications() != null && !details.getDeletedNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.DELETED_NOTIFICATIONS_COUNT + details.getDeletedNotifications().size());
                    this.deleteNotificationsForUser(details.getDeletedNotifications());
                }
                if (details.getNotifications() != null && !details.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + details.getNotifications().size());
                    this.storeNotificationsForUser(details.getNotifications(), new Date(loginRequestParamDetailDataBean.getLastUpdateDateForNotifications()));
                }
            } else {
                if (details.getNotifications() != null && !details.getNotifications().isEmpty()) {
                    Log.i(TAG, LabelConstants.NOTIFICATIONS_COUNT + details.getNotifications().size());
                    this.storeNotificationsForUser(details.getNotifications(), null);
                } else {
                    TableUtils.clearTable(notificationBeanDao.getConnectionSource(), NotificationBean.class);
                }
            }

            //Storing Labels
            if (details.getRetrievedLabels() != null) {
                Log.i(TAG, LabelConstants.LABELS_COUNT + details.getRetrievedLabels().getResult().size());
                this.storeLabelsDetailsToDatabase(details.getRetrievedLabels());
            }

            //Storing List Values
            if (details.getRetrievedListValues() != null && !details.getRetrievedListValues().isEmpty()) {
                Log.i(TAG, LabelConstants.LIST_VALUES_COUNT + details.getRetrievedListValues().size());
                this.storeAllListValues(details.getRetrievedListValues());
            }

            //Storing Announcements
            if (details.getRetrievedAnnouncements() != null && !details.getRetrievedAnnouncements().isEmpty()) {
                Log.i(TAG, LabelConstants.ANNOUNCEMENTS_COUNT + details.getRetrievedAnnouncements().size());
                this.storeAllAnnouncement(details.getRetrievedAnnouncements());
            } else {
                this.downloadAnnouncementFileFromServer();
            }

            //Storing XLS Data
            if (details.getRetrievedXlsData() != null && !details.getRetrievedXlsData().isEmpty()) {
                Log.i(TAG, LabelConstants.XLS_DATA_COUNT + details.getRetrievedXlsData().size());
                this.storeXlsDataToDatabaseForAWW(details.getRetrievedXlsData(), details.getCurrentSheetVersion());
            }

            //Storing Asha Area & Child Locations
            if (details.getRetrievedVillageAndChildLocations() != null && !details.getRetrievedVillageAndChildLocations().isEmpty()) {
                Log.i(TAG, LabelConstants.ASSIGNED_LOCATIONS_AND_CHILD_LOCATIONS_COUNT + details.getRetrievedVillageAndChildLocations().size());
                this.storeLocationBeansAssignedToUser(details.getRetrievedVillageAndChildLocations());
            }

            //For storing location master information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForLocation() == null) {
                Log.i(TAG, LabelConstants.ALL_LOCATION_MASTER_COUNT + details.getLocationMasterBeans().size());
                TableUtils.clearTable(locationMasterBeanDao.getConnectionSource(), LocationMasterBean.class);
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), true);
            } else {
                this.storeLocationMasterBeans(details.getLocationMasterBeans(), false);
            }

            //For storing health infrastructure information (Whole state!)
            if (loginRequestParamDetailDataBean.getLastUpdateDateForHealthInfrastructure() == null) {
                TableUtils.clearTable(healthInfrastructureBeanDao.getConnectionSource(), HealthInfrastructureBean.class);
                Log.i(TAG, LabelConstants.ALL_HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), true);
            } else {
                Log.i(TAG, LabelConstants.HEALTH_INFRASTRUCTURES_COUNT + details.getHealthInfrastructures().size());
                this.storeHealthInfrastructureDetails(details.getHealthInfrastructures(), false);
            }
        } catch (SQLException | ParseException | RestHttpException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void retrieveFamiliesForFHSR() {
        if (SewaTransformer.loginBean.getVillageCode() == null || SewaTransformer.loginBean.getVillageCode().isEmpty()) {
            return;
        }

        List<Integer> allVillages = new ArrayList<>();
        for (String id : SewaTransformer.loginBean.getVillageCode().split(":")) {
            List<LocationBean> locationBeans = locationService.retrieveLocationBeansByLevelAndParent(5, Long.valueOf(id));
            for (LocationBean locationBean : locationBeans) {
                Long locationId = locationBean.getActualID().longValue();
                String lastUpdateDate = null;
                try {
                    List<LocationBean> villages = locationService.retrieveLocationBeansByLevelAndParent(6, Long.valueOf(locationBean.getActualID()));
                    List<Integer> villageIds = new ArrayList<>();
                    for (LocationBean loc : villages) {
                        villageIds.add(loc.getActualID());
                        allVillages.add(loc.getActualID());
                    }

                    if (familyBeanDao.countOf() > 0) {
                        String[] result = familyBeanDao.queryBuilder().selectRaw(MAX_UPDATED_ON)
                                .where().in(FieldNameConstants.LOCATION_ID, villageIds).queryRawFirst();

                        if (result != null && result[0] != null) {
                            lastUpdateDate = String.valueOf(sdf.parse(result[0]).getTime());
                        }
                    }

                    List<FamilyDataBean> families = sewaServiceRestClient.getFamiliesByLocationId(locationId, lastUpdateDate);

                    if (lastUpdateDate != null) {
                        List<String> familyIds = new ArrayList<>();
                        for (FamilyDataBean familyDataBean : families) {
                            familyIds.add(familyDataBean.getFamilyId());
                        }

                        DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
                        familyBeanDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
                        familyBeanDeleteBuilder.delete();
                        DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();
                        memberBeanDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
                        memberBeanDeleteBuilder.delete();
                    }

                    List<FamilyBean> familyBeansToCreate = new ArrayList<>();
                    List<MemberBean> memberBeansToCreate = new ArrayList<>();
                    for (FamilyDataBean familyDataBean : families) {
                        List<MemberDataBean> memberDataBeans = familyDataBean.getMembers();
                        if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                            for (MemberDataBean memberDataBean : memberDataBeans) {
                                memberBeansToCreate.add(new MemberBean(memberDataBean));
                            }
                        }
                        familyBeansToCreate.add(new FamilyBean(familyDataBean));
                    }

                    familyBeanDao.create(familyBeansToCreate);
                    memberBeanDao.create(memberBeansToCreate);

                } catch (SQLException | ParseException | RestHttpException e) {
                    Log.e(TAG, e.getMessage(), e);
                }
            }
        }

        if (!allVillages.isEmpty()) {
            try {
                List<String> familyIds = new ArrayList<>();
                List<FamilyBean> query = familyBeanDao.queryBuilder().selectColumns(FieldNameConstants.FAMILY_ID).where().notIn(FieldNameConstants.LOCATION_ID, allVillages).query();
                for (FamilyBean bean : query) {
                    familyIds.add(bean.getFamilyId());
                }

                DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
                familyBeanDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
                familyBeanDeleteBuilder.delete();
                DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();
                memberBeanDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
                memberBeanDeleteBuilder.delete();
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }

        SharedStructureData.currentlyDownloadingFamilyData = false;
    }

    private void storeLocationBeansAssignedToUser(Map<Long, List<SurveyLocationMobDataBean>> allSurveyLocation) {
        try {
            TableUtils.clearTable(locationBeanDao.getConnectionSource(), LocationBean.class);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
        try {
            if (allSurveyLocation != null) {
                for (Map.Entry<Long, List<SurveyLocationMobDataBean>> entrySet : allSurveyLocation.entrySet()) {
                    List<SurveyLocationMobDataBean> locMobDataBeans = entrySet.getValue();
                    List<LocationBean> locationModels = sewaTransformer.convertLocationDataBeanToLocationModel(locMobDataBeans, null);
                    for (LocationBean loc : locationModels) {
                        locationBeanDao.createOrUpdate(loc);
                    }
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeLocationCoordinates(QueryMobDataBean queryDataFromServer) throws SQLException {
        TableUtils.clearTable(locationCoordinatesBeansDao.getConnectionSource(), LocationCoordinatesBean.class);
        List<LinkedHashMap<String, Object>> result = queryDataFromServer.getResult();

        if (result.isEmpty()) {
            return;
        }

        Object lgdCode;
        Object coordinates;
        List<LocationCoordinatesBean> beansToBeCreated = new LinkedList<>();
        for (LinkedHashMap<String, Object> aRow : result) {
            lgdCode = aRow.get("lgd_code");
            coordinates = aRow.get("coordinates_csv");
            if (lgdCode != null && coordinates != null) {
                LocationCoordinatesBean locationCoordinatesBean = new LocationCoordinatesBean();
                locationCoordinatesBean.setLgdCode(lgdCode.toString());
                locationCoordinatesBean.setCoordinates(coordinates.toString());
                beansToBeCreated.add(locationCoordinatesBean);
            }
        }
        locationCoordinatesBeansDao.create(beansToBeCreated);
    }

    private void deleteFamiliesFromDatabaseFHW(List<String> deletedFamilyIds) {
        for (String familyId : deletedFamilyIds) {
            DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
            DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();

            try {
                familyBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyId);
                familyBeanDeleteBuilder.delete();
                memberBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyId);
                memberBeanDeleteBuilder.delete();
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }
    }


    private void deleteFamiliesByLocationFHW(List<Long> locationIds) {
        try {
            List<String> familyIds = new LinkedList<>();
            List<FamilyBean> familyBeanList = familyBeanDao.queryBuilder()
                    .selectColumns(FieldNameConstants.FAMILY_ID).where()
                    .in(FieldNameConstants.LOCATION_ID, locationIds).query();

            for (FamilyBean familyBean : familyBeanList) {
                familyIds.add(familyBean.getFamilyId());
            }

            DeleteBuilder<MemberBean, Integer> memberBeanIntegerDeleteBuilder = memberBeanDao.deleteBuilder();
            memberBeanIntegerDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
            memberBeanIntegerDeleteBuilder.delete();

            DeleteBuilder<FamilyBean, Integer> familyBeanIntegerDeleteBuilder = familyBeanDao.deleteBuilder();
            familyBeanIntegerDeleteBuilder.where().in(FieldNameConstants.FAMILY_ID, familyIds);
            familyBeanIntegerDeleteBuilder.delete();
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeAllAssignedFamilies(List<FamilyDataBean> familyDataBeans) {
        List<FamilyBean> familyBeansToCreate = new ArrayList<>();
        List<MemberBean> memberBeansToCreate = new ArrayList<>();
        int pendingAbhaCount = 0;
        try {
            TableUtils.clearTable(memberBeanDao.getConnectionSource(), MemberBean.class);
            TableUtils.clearTable(familyBeanDao.getConnectionSource(), FamilyBean.class);
            for (FamilyDataBean familyDataBean : familyDataBeans) {
                List<MemberDataBean> memberDataBeans = familyDataBean.getMembers();
                if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                    for (MemberDataBean memberDataBean : memberDataBeans) {
                        memberBeansToCreate.add(new MemberBean(memberDataBean));
                        if (memberDataBean.getHealthIdNumber() == null && !FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberDataBean.getState())) {
                            pendingAbhaCount++;
                        }
                    }
                }
                familyDataBean.setPendingAbhaCount(pendingAbhaCount);
                pendingAbhaCount = 0;
                FamilyBean familyBean = new FamilyBean(familyDataBean);
                familyBean.setAssignedTo(SewaTransformer.loginBean.getUserID());
                familyBeansToCreate.add(familyBean);
            }
            memberBeanDao.create(memberBeansToCreate);
            familyBeanDao.create(familyBeansToCreate);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }
    }

    private boolean storeUpdatedFamilyData(List<FamilyDataBean> familyDataBeans) {
        List<FamilyBean> familyBeansToCreate = new ArrayList<>();
        List<MemberBean> memberBeansToCreate = new ArrayList<>();
        int pendingAbhaCount = 0;
        try {
            for (FamilyDataBean familyDataBean : familyDataBeans) {
                DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
                DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();

                familyBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean.getFamilyId());
                familyBeanDeleteBuilder.delete();
                memberBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean.getFamilyId());
                memberBeanDeleteBuilder.delete();

                List<MemberDataBean> memberDataBeans = familyDataBean.getMembers();

                if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                    for (MemberDataBean memberDataBean : memberDataBeans) {
                        memberBeansToCreate.add(new MemberBean(memberDataBean));
                        if (memberDataBean.getHealthIdNumber() == null && !FhsConstants.FHS_INACTIVE_CRITERIA_MEMBER_STATES.contains(memberDataBean.getState())) {
                            pendingAbhaCount++;
                        }
                    }
                }
                familyDataBean.setPendingAbhaCount(pendingAbhaCount);
                pendingAbhaCount = 0;

                FamilyBean familyBean = new FamilyBean(familyDataBean);
                familyBean.setAssignedTo(SewaTransformer.loginBean.getUserID());
                familyBeansToCreate.add(familyBean);
            }
            memberBeanDao.create(memberBeansToCreate);
            familyBeanDao.create(familyBeansToCreate);
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
            return false;
        }
        return true;
    }

    private void storeFhwServiceDetailBeans(List<FhwServiceDetailBean> fhwServiceDetailBeans) {
        try {
            TableUtils.clearTable(fhwServiceDetailBeanDao.getConnectionSource(), FhwServiceDetailBean.class);
            for (FhwServiceDetailBean fhwServiceDetailBean : fhwServiceDetailBeans) {
                fhwServiceDetailBeanDao.create(fhwServiceDetailBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, "SQL Exception While Inserting FHW Service Details", e);
        }
    }

    private void storeOrphanedAndReverificationFamiliesForFHW(List<FamilyDataBean> orphanedOrReverificationFamilies) {
        List<FamilyDataBean> orphanedFamilies = new ArrayList<>();
        List<FamilyDataBean> reverificationFamilies = new ArrayList<>();
        if (orphanedOrReverificationFamilies == null || orphanedOrReverificationFamilies.isEmpty()) {
            return;
        }

        for (FamilyDataBean familyDataBean : orphanedOrReverificationFamilies) {
            if (familyDataBean.getState().equals(FhsConstants.FHS_FAMILY_STATE_ORPHAN)) {
                orphanedFamilies.add(familyDataBean);
            } else {
                reverificationFamilies.add(familyDataBean);
            }
        }
        try {
            for (FamilyDataBean familyDataBean : orphanedFamilies) {
                DeleteBuilder<FamilyBean, Integer> familyBeanDeleteBuilder = familyBeanDao.deleteBuilder();
                DeleteBuilder<MemberBean, Integer> memberBeanDeleteBuilder = memberBeanDao.deleteBuilder();
                familyBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean.getFamilyId());
                familyBeanDeleteBuilder.delete();
                memberBeanDeleteBuilder.where().eq(FieldNameConstants.FAMILY_ID, familyDataBean.getFamilyId());
                memberBeanDeleteBuilder.delete();

                List<MemberDataBean> memberDataBeans = familyDataBean.getMembers();
                if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                    for (MemberDataBean memberDataBean : memberDataBeans) {
                        memberBeanDao.create(new MemberBean(memberDataBean));
                    }
                }
                FamilyBean familyBean = new FamilyBean(familyDataBean);
                familyBean.setAssignedTo(SewaTransformer.loginBean.getUserID());
                familyBeanDao.create(familyBean);
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            SharedStructureData.NETWORK_MESSAGE = "Issue During Inserting Orphaned Family FHS Data";
        }

        try {
            for (FamilyDataBean familyDataBean : reverificationFamilies) {
                List<FamilyBean> query = familyBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyDataBean.getFamilyId()).query();
                if (query != null && !query.isEmpty()) {
                    for (FamilyBean familyBean : query) {
                        familyBeanDao.delete(familyBean);
                        List<MemberBean> members = memberBeanDao.queryBuilder().where().eq(FieldNameConstants.FAMILY_ID, familyBean.getFamilyId()).query();
                        if (members != null && !members.isEmpty()) {
                            for (MemberBean memberBean : members) {
                                memberBeanDao.delete(memberBean);
                            }
                        }

                    }
                }

                List<MemberDataBean> memberDataBeans = familyDataBean.getMembers();
                if (memberDataBeans != null && !memberDataBeans.isEmpty()) {
                    for (MemberDataBean memberDataBean : memberDataBeans) {
                        memberBeanDao.create(new MemberBean(memberDataBean));
                    }
                }
                FamilyBean familyBean = new FamilyBean(familyDataBean);
                familyBean.setReverificationFlag(Boolean.TRUE);
                familyBean.setAssignedTo(SewaTransformer.loginBean.getUserID());
                familyBeanDao.create(familyBean);
            }
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            SharedStructureData.NETWORK_MESSAGE = "Issue During Inserting Orphaned Family FHS Data";
        }
    }

    private void storeNotificationsForUser(List<NotificationMobDataBean> notificationMobDataBeans, Date lastModifiedOn) throws SQLException {
        if (lastModifiedOn != null) {
            if (notificationMobDataBeans != null && !notificationMobDataBeans.isEmpty()) {
                List<Long> notificationIds = new ArrayList<>();
                for (NotificationMobDataBean notificationMobDataBean : notificationMobDataBeans) {
                    notificationIds.add(notificationMobDataBean.getId());
                }

                DeleteBuilder<NotificationBean, Integer> notificationBeanDeleteBuilder = notificationBeanDao.deleteBuilder();
                notificationBeanDeleteBuilder.where().in(FieldNameConstants.NOTIFICATION_ID, notificationIds);
                notificationBeanDeleteBuilder.delete();

                List<NotificationBean> notificationBeans = new LinkedList<>();
                notificationBeans = SewaTransformer.getInstance().convertNotificationDataBeanToNotificationBeanModel(notificationBeans, notificationMobDataBeans);
                notificationBeanDao.create(notificationBeans);
            }
        } else {
            TableUtils.clearTable(notificationBeanDao.getConnectionSource(), NotificationBean.class);

            List<NotificationBean> notificationBeans = new LinkedList<>();
            if (notificationMobDataBeans != null && !notificationMobDataBeans.isEmpty()) {
                notificationBeans = SewaTransformer.getInstance().convertNotificationDataBeanToNotificationBeanModel(notificationBeans, notificationMobDataBeans);
                notificationBeanDao.create(notificationBeans);
            }
        }
    }

    private void deleteNotificationsForUser(List<Long> notificationIds) throws SQLException {
        if (notificationIds != null && !notificationIds.isEmpty()) {
            DeleteBuilder<NotificationBean, Integer> notificationBeanDeleteBuilder = notificationBeanDao.deleteBuilder();
            notificationBeanDeleteBuilder.where().in(FieldNameConstants.NOTIFICATION_ID, notificationIds);
            notificationBeanDeleteBuilder.delete();
        }
    }

    private void storeRchVillageProfileBeanFromServer(List<RchVillageProfileDataBean> rchVillageProfileDataBeans) {
        try {
            List<RchVillageProfileBean> rchVillageProfileBeans = new ArrayList<>();
            for (RchVillageProfileDataBean rchVillageProfileDataBean : rchVillageProfileDataBeans) {
                RchVillageProfileBean rchVillageProfileBean = new RchVillageProfileBean();
                rchVillageProfileBean.setVillageId(rchVillageProfileDataBean.getVillage().getId());
                rchVillageProfileBean.setRchVillageProfileDto(new Gson().toJson(rchVillageProfileDataBean));
                rchVillageProfileBeans.add(rchVillageProfileBean);
            }
            if (!rchVillageProfileBeans.isEmpty()) {
                TableUtils.clearTable(rchVillageProfileBeanDao.getConnectionSource(), RchVillageProfileBean.class);
                rchVillageProfileBeanDao.create(rchVillageProfileBeans);
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeMigrationDetails(List<MigratedMembersDataBean> migratedMembersDataBeans) {
        List<MigratedMembersBean> migratedMembersBeans = new ArrayList<>();

        for (MigratedMembersDataBean migratedMembersDataBean : migratedMembersDataBeans) {
            MigratedMembersBean migratedMembersBean = sewaTransformer.convertMigratedMembersDataBeanToBean(migratedMembersDataBean);
            migratedMembersBeans.add(migratedMembersBean);
        }

        try {
            TableUtils.clearTable(migratedMembersBeanDao.getConnectionSource(), MigratedMembersBean.class);
            migratedMembersBeanDao.create(migratedMembersBeans);
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeMigrationFamilyDetails(List<MigratedFamilyDataBean> migratedFamilyDataBeans) {
        List<MigratedFamilyBean> migratedFamilyBeans = new ArrayList<>();

        for (MigratedFamilyDataBean migratedFamilyDataBean : migratedFamilyDataBeans) {
            MigratedFamilyBean migratedFamilyBean = sewaTransformer.convertMigratedFamilyDataBeanToBean(migratedFamilyDataBean);
            migratedFamilyBeans.add(migratedFamilyBean);
        }

        try {
            TableUtils.clearTable(migratedFamilyBeanDao.getConnectionSource(), MigratedFamilyBean.class);
            migratedFamilyBeanDao.create(migratedFamilyBeans);
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeLabelsDetailsToDatabase(QueryMobDataBean queryMobDataBean) {

        List<LabelBean> labelBeans = sewaTransformer.convertQueryMobDataBeanToLabelModel(queryMobDataBean);
        for (LabelBean labelBean : labelBeans) {
            try {
                if (SharedStructureData.listLabelBeans != null) {
                    LabelBean get = SharedStructureData.listLabelBeans.get(labelBean.getMapIndex());
                    if (get != null) {
                        labelBean.setId(get.getId());
                        labelBeanDao.createOrUpdate(labelBean);
                    } else {
                        labelBeanDao.create(labelBean);
                    }
                } else {
                    labelBeanDao.create(labelBean);
                }
            } catch (SQLException ex) {
                Log.e(TAG, null, ex);
            }
        }
    }

    private void storeXlsDataToDatabaseForFHW(Map<String, List<ComponentTagBean>> xlsDataMap, Map<String, Integer> currentSheetVersionMap) {
        boolean isFormUpdate = Boolean.TRUE;
        for (Map.Entry<String, List<ComponentTagBean>> entry : xlsDataMap.entrySet()) {
            String sheetName = entry.getKey();
            List<ComponentTagBean> componentTagBeans = entry.getValue();

            if (componentTagBeans != null && !componentTagBeans.isEmpty()) {
                List<AnswerBean> answerBeans;
                List<QuestionBean> questionBeans;
                questionBeans = sewaTransformer.convertComponentDataBeanToQuestionBeanModel(null, componentTagBeans, sheetName);
                answerBeans = sewaTransformer.convertComponentDataBeanToAnswerBeanModel(null, componentTagBeans, sheetName);

                try {
                    DeleteBuilder<QuestionBean, Integer> deleteQueBuilder = questionBeanDao.deleteBuilder();
                    deleteQueBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<QuestionBean> prepare = deleteQueBuilder.prepare();
                    if (prepare != null) {
                        questionBeanDao.delete(prepare);
                    }
                    for (QuestionBean questionBean : questionBeans) {
                        questionBeanDao.createOrUpdate(questionBean);
                    }

                    DeleteBuilder<AnswerBean, Integer> deleteAnsBuilder = answerBeanDao.deleteBuilder();
                    deleteAnsBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<AnswerBean> prepare1 = deleteAnsBuilder.prepare();
                    if (prepare1 != null) {
                        answerBeanDao.delete(prepare1);
                    }
                    for (AnswerBean answerBean : answerBeans) {
                        answerBeanDao.createOrUpdate(answerBean);
                    }
                } catch (SQLException ex) {
                    Log.d(TAG, "Error in download sheet : " + sheetName);
                    Log.e(TAG, null, ex);
                    isFormUpdate = Boolean.FALSE;
                }
            }
        }
        if (isFormUpdate) {
            try {
                VersionBean versionBean = versionBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.KEY, GlobalTypes.FHW_SHEET_VERSION).queryForFirst();
                if (versionBean == null) {
                    versionBean = new VersionBean();
                    versionBean.setKey(GlobalTypes.FHW_SHEET_VERSION);
                }
                versionBean.setVersion(String.valueOf(currentSheetVersionMap.get(GlobalTypes.FHW_SHEET_VERSION)));
                versionBeanDao.createOrUpdate(versionBean);
                Log.d(TAG, "Sheet Version is set to  : " + versionBean);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }
    }

    private void storeXlsDataToDatabaseForASHA(Map<String, List<ComponentTagBean>> xlsDataMap, Map<String, Integer> currentSheetVersionMap) {
        boolean isFormUpdate = Boolean.TRUE;
        for (Map.Entry<String, List<ComponentTagBean>> entry : xlsDataMap.entrySet()) {
            String sheetName = entry.getKey();
            List<ComponentTagBean> componentTagBeans = entry.getValue();

            if (componentTagBeans != null && !componentTagBeans.isEmpty()) {
                List<AnswerBean> answerBeans;
                List<QuestionBean> questionBeans;
                questionBeans = sewaTransformer.convertComponentDataBeanToQuestionBeanModel(null, componentTagBeans, sheetName);
                answerBeans = sewaTransformer.convertComponentDataBeanToAnswerBeanModel(null, componentTagBeans, sheetName);

                try {
                    DeleteBuilder<QuestionBean, Integer> deleteQueBuilder = questionBeanDao.deleteBuilder();
                    deleteQueBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<QuestionBean> prepare = deleteQueBuilder.prepare();
                    if (prepare != null) {
                        questionBeanDao.delete(prepare);
                    }
                    for (QuestionBean questionBean : questionBeans) {
                        questionBeanDao.createOrUpdate(questionBean);
                    }

                    DeleteBuilder<AnswerBean, Integer> deleteAnsBuilder = answerBeanDao.deleteBuilder();
                    deleteAnsBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<AnswerBean> prepare1 = deleteAnsBuilder.prepare();
                    if (prepare1 != null) {
                        answerBeanDao.delete(prepare1);
                    }
                    for (AnswerBean answerBean : answerBeans) {
                        answerBeanDao.createOrUpdate(answerBean);
                    }
                } catch (SQLException ex) {
                    Log.e(TAG, null, ex);
                    isFormUpdate = Boolean.FALSE;
                }
            }
        }

        if (isFormUpdate) {
            try {
                VersionBean versionBean = versionBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.KEY, GlobalTypes.ASHA_SHEET_VERSION).queryForFirst();
                if (versionBean == null) {
                    versionBean = new VersionBean();
                    versionBean.setKey(GlobalTypes.ASHA_SHEET_VERSION);
                }
                versionBean.setVersion(String.valueOf(currentSheetVersionMap.get(GlobalTypes.ASHA_SHEET_VERSION)));
                versionBeanDao.createOrUpdate(versionBean);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }
    }

    private void storeXlsDataToDatabaseForAWW(Map<String, List<ComponentTagBean>> xlsDataMap, Map<String, Integer> currentSheetVersionMap) {
        boolean isFormUpdate = Boolean.TRUE;
        for (Map.Entry<String, List<ComponentTagBean>> entry : xlsDataMap.entrySet()) {
            String sheetName = entry.getKey();
            List<ComponentTagBean> componentTagBeans = entry.getValue();

            if (componentTagBeans != null && !componentTagBeans.isEmpty()) {
                List<AnswerBean> answerBeans;
                List<QuestionBean> questionBeans;
                questionBeans = sewaTransformer.convertComponentDataBeanToQuestionBeanModel(null, componentTagBeans, sheetName);
                answerBeans = sewaTransformer.convertComponentDataBeanToAnswerBeanModel(null, componentTagBeans, sheetName);

                try {
                    DeleteBuilder<QuestionBean, Integer> deleteQueBuilder = questionBeanDao.deleteBuilder();
                    deleteQueBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<QuestionBean> prepare = deleteQueBuilder.prepare();
                    if (prepare != null) {
                        questionBeanDao.delete(prepare);
                    }
                    for (QuestionBean questionBean : questionBeans) {
                        questionBeanDao.createOrUpdate(questionBean);
                    }

                    DeleteBuilder<AnswerBean, Integer> deleteAnsBuilder = answerBeanDao.deleteBuilder();
                    deleteAnsBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, sheetName);
                    PreparedDelete<AnswerBean> prepare1 = deleteAnsBuilder.prepare();
                    if (prepare1 != null) {
                        answerBeanDao.delete(prepare1);
                    }
                    for (AnswerBean answerBean : answerBeans) {
                        answerBeanDao.createOrUpdate(answerBean);
                    }
                } catch (SQLException ex) {
                    Log.e(TAG, null, ex);
                    isFormUpdate = Boolean.FALSE;
                }
            }
        }

        if (isFormUpdate) {
            try {
                VersionBean versionBean = versionBeanDao.queryBuilder().where()
                        .eq(FieldNameConstants.KEY, GlobalTypes.AWW_SHEET_VERSION).queryForFirst();
                if (versionBean == null) {
                    versionBean = new VersionBean();
                    versionBean.setKey(GlobalTypes.AWW_SHEET_VERSION);
                }
                versionBean.setVersion(String.valueOf(currentSheetVersionMap.get(GlobalTypes.AWW_SHEET_VERSION)));
                versionBeanDao.createOrUpdate(versionBean);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }
    }

    private void storeAllListValues(List<FieldValueMobDataBean> fieldValueMobDataBeans) {
        if (SewaTransformer.loginBean == null) {
            return;
        }

        if (fieldValueMobDataBeans != null && !fieldValueMobDataBeans.isEmpty()) {
            // remove state list first
            try {
                List<ListValueBean> listValueBeans = listValueBeanDao.queryForEq(SewaConstants.LIST_VALUE_BEAN_FIELD, "stateList");
                listValueBeanDao.delete(listValueBeans);
            } catch (SQLException ex) {
                Log.e(TAG, null, ex);
            }

            for (FieldValueMobDataBean fieldValueMobDataBean : fieldValueMobDataBeans) {
                ListValueBean listValueBean = null;
                try {
                    List<ListValueBean> listValueBeans = listValueBeanDao.queryForEq(SewaConstants.LIST_VALUE_BEAN_ID_OF_VALUE, fieldValueMobDataBean.getIdOfValue());
                    if (listValueBeans != null && !listValueBeans.isEmpty()) {
                        listValueBean = listValueBeans.get(0);

                        if (Boolean.FALSE.equals(fieldValueMobDataBean.getActive())) {
                            listValueBeanDao.delete(listValueBean);
                        }
                    }
                } catch (SQLException ex) {
                    Log.e(TAG, null, ex);
                }

                if (Boolean.TRUE.equals(fieldValueMobDataBean.getActive())) {
                    if (listValueBean == null) {
                        listValueBean = new ListValueBean();
                        listValueBean.setIdOfValue(fieldValueMobDataBean.getIdOfValue());
                        listValueBean.setFormCode(fieldValueMobDataBean.getFormCode());
                        listValueBean.setField(fieldValueMobDataBean.getField());
                        listValueBean.setFieldType(fieldValueMobDataBean.getFieldType());
                        listValueBean.setValue(fieldValueMobDataBean.getValue());
                        listValueBean.setModifiedOn(new Date(fieldValueMobDataBean.getLastUpdateOfFieldValue()));

                        if (listValueBean.getFieldType().equals(GlobalTypes.TEXTUAL_LIST_VALUE)) { // T for Text and M for Multimedia
                            listValueBean.setIsDownloaded(GlobalTypes.TRUE); // text is direct available
                        } else {
                            listValueBean.setIsDownloaded(GlobalTypes.FALSE); // is multimedia than is should be download
                        }
                        try {
                            listValueBeanDao.create(listValueBean);
                        } catch (SQLException ex) {
                            Log.e(TAG, null, ex);
                        }
                    } else {
                        listValueBean.setFormCode(fieldValueMobDataBean.getFormCode());
                        listValueBean.setField(fieldValueMobDataBean.getField());
                        listValueBean.setFieldType(fieldValueMobDataBean.getFieldType());
                        listValueBean.setValue(fieldValueMobDataBean.getValue());
                        listValueBean.setModifiedOn(new Date(fieldValueMobDataBean.getLastUpdateOfFieldValue()));
                        if (listValueBean.getFieldType().equalsIgnoreCase(GlobalTypes.MULTIMEDIA_LIST_VALUE)) {
                            String path = SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DOWNLOADED) + listValueBean.getValue();
                            if (!UtilBean.isFileExists(path)) {
                                listValueBean.setIsDownloaded(GlobalTypes.FALSE);
                            } else {
                                listValueBean.setIsDownloaded(GlobalTypes.TRUE);
                            }
                        } else {
                            listValueBean.setIsDownloaded(GlobalTypes.TRUE);
                        }

                        // do update if File not available
                        try {
                            listValueBeanDao.update(listValueBean);
                        } catch (SQLException ex) {
                            Log.e(TAG, null, ex);
                        }
                    }
                }
            }
        }// end of if constraints

        // generate parameter for query
        Map<String, Object> mapQueryFields = new HashMap<>();
        mapQueryFields.put(SewaConstants.LIST_VALUE_BEAN_FIELD_TYPE, GlobalTypes.MULTIMEDIA_LIST_VALUE);
        List<ListValueBean> listValueBeans = null;

        try {
            listValueBeans = listValueBeanDao.queryForFieldValues(mapQueryFields);
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        } // fire query and find not downloaded list

        if (listValueBeans != null && !listValueBeans.isEmpty()) {
            for (ListValueBean listValueBean : listValueBeans) {
                String filename = listValueBean.getValue();
                if (filename != null && filename.trim().length() > 0) {
                    String filePath = SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DOWNLOADED) + filename;
                    if (!UtilBean.isFileExists(filePath)) {
                        Log.i(TAG, "File Not Exists for List Value : " + filePath + " :: id :: " + listValueBean.getIdOfValue());
                        try {
                            if (this.downloadFileFromServer(listValueBean.getValue())) {
                                listValueBean.setIsDownloaded(GlobalTypes.TRUE);
                            } else {
                                listValueBean.setIsDownloaded(GlobalTypes.FALSE);
                            }
                            listValueBeanDao.update(listValueBean);
                        } catch (Exception ex) {
                            Log.e(TAG, null, ex);
                            break;
                        }
                    } else {
                        Log.i(TAG, "File Exists for List value : " + filePath);
                    }
                }
            }
        }
    }

    private boolean downloadFileFromServer(String fileNameToDownLoad) {
        try {
            if (fileNameToDownLoad != null) {
                String token = SewaTransformer.loginBean.getUserToken();
                try {
                    token = URLEncoder.encode(token, "UTF-8");
                    fileNameToDownLoad = URLEncoder.encode(fileNameToDownLoad, "UTF-8");
                } catch (UnsupportedEncodingException e) {
                    e.printStackTrace();
                }
                String url = WSConstants.REST_TECHO_SERVICE_URL + "getFile?token=" + token + "&fileName=" + fileNameToDownLoad;
                ResponseBody responseBody = apiManager.execute(apiManager.getInstance().getFile(url));
                if (responseBody == null)
                    return false;
                long startTime = System.currentTimeMillis();
                String filePath = SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DOWNLOADED) + fileNameToDownLoad;
                try (FileOutputStream fos = new FileOutputStream(filePath)) {
                    fos.write(responseBody.bytes());
                }
                long secOfDownload = ((System.currentTimeMillis() - startTime) / 1000);
                Log.i(TAG, "Downloaded file : " + filePath + "\n in " + secOfDownload + "sec");
                return true;
            }
            return false;
        } catch (Exception ex) {
            Log.e(TAG, null, ex);
            return false;
        }
    }

    private void storeAllAnnouncement(List<AnnouncementMobDataBean> announcementMobDataBeans) {
        for (AnnouncementMobDataBean announcementMobDataBean : announcementMobDataBeans) {
            AnnouncementBean announcementBean = null;
            try {
                List<AnnouncementBean> announcementBeans = announcementBeanDao.queryForEq(SewaConstants.ANNOUNCEMENT_BEAN_ANNOUNCEMENT_ID, announcementMobDataBean.getAnnouncementId());
                if (announcementBeans != null && !announcementBeans.isEmpty()) {
                    announcementBean = announcementBeans.get(0);
                }
            } catch (SQLException ex) {
                Log.e(TAG, null, ex);
            }

            if (announcementBean == null) {
                if (announcementMobDataBean.isIsActive()) {
                    announcementBean = new AnnouncementBean();
                    announcementBean.setAnnouncementId(announcementMobDataBean.getAnnouncementId());
                    announcementBean.setDefaultLanguage(announcementMobDataBean.getDefaultLanguage());
                    if (announcementMobDataBean.getSubject() != null) {
                        announcementBean.setSubject(announcementMobDataBean.getSubject().trim());
                    }
                    announcementBean.setPublishedOn(announcementMobDataBean.getPublishedOn());
                    announcementBean.setIsDownloaded(GlobalTypes.FALSE);
                    announcementBean.setIsPlayedAnnouncement(0);
                    announcementBean.setFileName(announcementMobDataBean.getFileName());
                    if (announcementMobDataBean.getModifiedOn() != null) {
                        announcementBean.setModifiedOn(announcementMobDataBean.getModifiedOn());
                    }
                    try {
                        announcementBeanDao.create(announcementBean);
                    } catch (SQLException ex) {
                        Log.e(TAG, null, ex);
                    }
                }
            } else {
                if (announcementMobDataBean.isIsActive()) {
                    announcementBean.setDefaultLanguage(announcementMobDataBean.getDefaultLanguage());
                    if (announcementMobDataBean.getSubject() != null) {
                        byte[] bytes = announcementMobDataBean.getSubject().getBytes();
                        String string = new String(bytes, StandardCharsets.UTF_8);
                        announcementBean.setSubject(string.trim());

                    }
                    announcementBean.setPublishedOn(announcementMobDataBean.getPublishedOn());
                    announcementBean.setIsDownloaded(GlobalTypes.FALSE);
                    announcementBean.setFileName(announcementMobDataBean.getFileName());
                    if (announcementMobDataBean.getModifiedOn() != null) {
                        announcementBean.setModifiedOn(announcementMobDataBean.getModifiedOn());
                    }
                    try {
                        announcementBeanDao.update(announcementBean);
                    } catch (SQLException ex) {
                        Log.e(TAG, null, ex);
                    }
                } else {
                    File file = new File(SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DOWNLOADED) + announcementBean.getFileName());
                    if (file.exists()) {
                        file.delete();
                    }

                    try {
                        announcementBeanDao.delete(announcementBean);

                    } catch (SQLException ex) {
                        Log.e(TAG, null, ex);
                    }
                }
            }
        } // done all announcement
        downloadAnnouncementFileFromServer();
    }

    private void downloadAnnouncementFileFromServer() {
        List<AnnouncementBean> announcementBeans = null;
        try {
            announcementBeans = announcementBeanDao.queryForAll();
        } catch (SQLException ex) {
            Log.e(TAG, null, ex);
        }

        if (announcementBeans != null && !announcementBeans.isEmpty()) {
            for (AnnouncementBean announcementBean : announcementBeans) {
                String filename = announcementBean.getFileName();
                if (filename != null && filename.trim().length() > 0) {
                    try {
                        String file = SewaConstants.getDirectoryPath(context, SewaConstants.DIR_DOWNLOADED) + "/" + filename;
                        if (!UtilBean.isFileExists(file)) {
                            this.downloadFileFromServer(filename);
                            announcementBean.setIsPlayedAnnouncement(0);
                        }
                        announcementBean.setIsDownloaded(GlobalTypes.TRUE);
                        announcementBeanDao.update(announcementBean);
                    } catch (Exception ex) {
                        Log.e(TAG, null, ex);
                    }
                }
            }
        }
    }

    private void storeLocationMasterBeans(List<LocationMasterBean> locationMasterBeans, boolean allClear) {
        if (locationMasterBeans != null && !locationMasterBeans.isEmpty()) {
            Log.i(TAG, LabelConstants.LOCATION_MASTER_COUNT + locationMasterBeans.size());
            try {
                if (!allClear) {
                    for (LocationMasterBean locationMasterBean : locationMasterBeans) {
                        DeleteBuilder<LocationMasterBean, Integer> deleteBuilder = locationMasterBeanDao.deleteBuilder();
                        deleteBuilder.where().eq(FieldNameConstants.ACTUAL_I_D, locationMasterBean.getActualID());
                        deleteBuilder.delete();
                    }
                }
                locationMasterBeanDao.create(locationMasterBeans);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
                return;
            }
        }

        try {
            VersionBean versionBean;
            List<VersionBean> versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_LOCATION_MASTER);
            if (versionBeans == null || versionBeans.isEmpty()) {
                VersionBean versionBean1 = new VersionBean();
                versionBean1.setKey(GlobalTypes.VERSION_LAST_UPDATED_LOCATION_MASTER);
                versionBean1.setValue(Long.toString(new Date().getTime()));
                versionBeanDao.create(versionBean1);
            } else {
                versionBean = versionBeans.get(0);
                versionBean.setValue(Long.toString(new Date().getTime()));
                versionBeanDao.update(versionBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    private void storeHealthInfrastructureDetails(List<HealthInfrastructureBean> healthInfrastructureBeans, boolean allClear) {
        if (healthInfrastructureBeans != null && !healthInfrastructureBeans.isEmpty()) {
            try {
                if (!allClear) {
                    for (HealthInfrastructureBean bean : healthInfrastructureBeans) {
                        DeleteBuilder<HealthInfrastructureBean, Integer> deleteBuilder = healthInfrastructureBeanDao.deleteBuilder();
                        deleteBuilder.where().eq(FieldNameConstants.ACTUAL_ID, bean.getActualId());
                        deleteBuilder.delete();
                    }
                }
                healthInfrastructureBeanDao.create(healthInfrastructureBeans);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
                return;
            }
        }

        try {
            VersionBean versionBean;
            List<VersionBean> versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);

            String maxDate = null;
            if (healthInfrastructureBeanDao.countOf() > 0) {
                String string = healthInfrastructureBeanDao.queryBuilder().selectRaw(MAX_MODIFIED_ON).prepareStatementString();
                String[] result = healthInfrastructureBeanDao.queryRaw(string).getFirstResult();
                if (result != null && result[0] != null) {
                    maxDate = result[0];
                }
            }

            if (versionBeans == null || versionBeans.isEmpty()) {
                VersionBean versionBean1 = new VersionBean();
                versionBean1.setKey(GlobalTypes.VERSION_LAST_UPDATED_HEALTH_INFRASTRUCTURE);
                versionBean1.setValue(maxDate);
                versionBeanDao.create(versionBean1);
            } else {
                versionBean = versionBeans.get(0);
                versionBean.setValue(maxDate);
                versionBeanDao.update(versionBean);
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
    }

    @Override
    public void getLgdCodeWiseCoordinates() {
        Map<String, Map<String, List<Double>>> map = new HashMap<>();
        try {
            Gson gson = new Gson();
            List<LocationCoordinatesBean> locationCoordinatesBeans = locationCoordinatesBeansDao.queryForAll();
            for (LocationCoordinatesBean locationCoordinatesBean : locationCoordinatesBeans) {
                Map<String, List<Double>> mapOfLatLongArray = new HashMap<>();
                List<Double> latArray = new ArrayList<>();
                List<Double> longArray = new ArrayList<>();
                List<Double[]> coordinates = gson.fromJson(locationCoordinatesBean.getCoordinates(), new TypeToken<List<Double[]>>() {
                }.getType());

                for (Double[] aCoordinate : coordinates) {
                    longArray.add(aCoordinate[0]);
                    latArray.add(aCoordinate[1]);
                }
                mapOfLatLongArray.put("longArray", longArray);
                mapOfLatLongArray.put("latArray", latArray);
                map.put(locationCoordinatesBean.getLgdCode(), mapOfLatLongArray);
            }
            SharedStructureData.mapOfLatLongWithLGDCode = map;
        } catch (Exception e) {
            Log.e(TAG, e.getMessage(), e);
            SharedStructureData.mapOfLatLongWithLGDCode = null;
        }
    }

    @Override
    public boolean checkIfFeatureIsReleased() {
        try {
            List<VersionBean> featureVersionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_FEATURES_LIST);
            if (featureVersionBeans != null && !featureVersionBeans.isEmpty()) {
                VersionBean versionBean = featureVersionBeans.get(0);
                return versionBean.getValue().contains(GlobalTypes.MOB_FEATURE_GEO_FENCING);
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }
        return false;
    }

    @Override
    public Boolean checkIfOfflineAnyFormFilledForMember(Long memberId) {
        if (memberId == null) {
            return false;
        }

        try {
            List<StoreAnswerBean> storeAnswerBeans = storeAnswerBeanDao.queryForAll();
            for (StoreAnswerBean bean : storeAnswerBeans) {
                if (memberId.equals(bean.getMemberId())) {
                    return true;
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, e.getMessage(), e);
        }

        return false;
    }

    private void storePregnancyStatusBeans(LoggedInUserPrincipleDataBean data) {
        try {
            if (data.getPregnancyStatus() != null && !data.getPregnancyStatus().isEmpty()) {
                TableUtils.clearTable(pregnancyStatusBeanDao.getConnectionSource(), MemberPregnancyStatusBean.class);
                pregnancyStatusBeanDao.create(data.getPregnancyStatus());

                VersionBean versionBean;
                List<VersionBean> versionBeans = versionBeanDao.queryForEq(FieldNameConstants.KEY, GlobalTypes.VERSION_LAST_UPDATED_PREGNANCY_STATUS);

                if (versionBeans == null || versionBeans.isEmpty()) {
                    VersionBean versionBean1 = new VersionBean();
                    versionBean1.setKey(GlobalTypes.VERSION_LAST_UPDATED_PREGNANCY_STATUS);
                    versionBean1.setValue(data.getLastPregnancyStatusDate().toString());
                    versionBeanDao.create(versionBean1);
                } else {
                    versionBean = versionBeans.get(0);
                    versionBean.setValue(data.getLastPregnancyStatusDate().toString());
                    versionBeanDao.update(versionBean);
                }
            }
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }

    public void deleteQuestionAndAnswersByFormCode(String formCode) {
        try {
            DeleteBuilder<QuestionBean, Integer> deleteQueBuilder = questionBeanDao.deleteBuilder();
            deleteQueBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, formCode);
            PreparedDelete<QuestionBean> prepare = deleteQueBuilder.prepare();
            if (prepare != null) {
                questionBeanDao.delete(prepare);
            }

            DeleteBuilder<AnswerBean, Integer> deleteAnsBuilder = answerBeanDao.deleteBuilder();
            deleteAnsBuilder.where().eq(SewaConstants.QUESTION_BEAN_ENTITY, formCode);
            PreparedDelete<AnswerBean> prepare1 = deleteAnsBuilder.prepare();
            if (prepare1 != null) {
                answerBeanDao.delete(prepare1);
            }
        } catch (SQLException ex) {
            Log.e(getClass().getSimpleName(), null, ex);
        }
    }

    private void storeLocationTypeBeans(List<LocationTypeBean> locationTypeBeans, Long lastUpdateDate) {
        try {
            if (lastUpdateDate == null) {
                TableUtils.clearTable(locationTypeBeanDao.getConnectionSource(), LocationTypeBean.class);
            }
            if (locationTypeBeans == null || locationTypeBeans.isEmpty()) {
                return;
            }

            if (lastUpdateDate != null) {
                for (LocationTypeBean bean : locationTypeBeans) {
                    DeleteBuilder<LocationTypeBean, Integer> deleteBuilder = locationTypeBeanDao.deleteBuilder();
                    deleteBuilder.where().eq(SewaConstants.LOCATION_TYPE_BEAN_TYPE, bean.getType());
                    deleteBuilder.delete();
                }
            }
            locationTypeBeanDao.create(locationTypeBeans);
        } catch (SQLException e) {
            Log.e(TAG, null, e);
        }
    }


    private void storeMenuDetails(List<MenuBean> menuBeans) {
        if (menuBeans != null && !menuBeans.isEmpty()) {
            System.out.println("#### All menus : " + menuBeans.size());
            try {
                TableUtils.clearTable(menuBeanDao.getConnectionSource(), MenuBean.class);
                menuBeanDao.create(menuBeans);
            } catch (SQLException e) {
                Log.e(TAG, e.getMessage(), e);
            }
        }
    }

//    @Override
//    public boolean isNewNotification() {
//        try {
//            List<AnnouncementBean> announcementBeans = announcementBeanDao.queryBuilder().where().eq("isPlayedAnnouncement", 0).query();
//            return announcementBeans.size() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
}
