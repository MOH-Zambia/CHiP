package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.LanguageMasterDto;
import com.argusoft.sewa.android.app.databean.LoggedInUserPrincipleDataBean;
import com.argusoft.sewa.android.app.databean.LoginRequestParamDetailDataBean;
import com.argusoft.sewa.android.app.databean.MobileRequestParamDto;
import com.argusoft.sewa.android.app.databean.QueryMobDataBean;
import com.argusoft.sewa.android.app.databean.RecordStatusBean;
import com.argusoft.sewa.android.app.databean.StockManagementDataBean;
import com.argusoft.sewa.android.app.databean.UserInfoDataBean;
import com.argusoft.sewa.android.app.model.FormAccessibilityBean;
import com.argusoft.sewa.android.app.model.LmsEventBean;
import com.argusoft.sewa.android.app.model.MergedFamiliesBean;
import com.argusoft.sewa.android.app.model.UncaughtExceptionBean;
import com.argusoft.sewa.android.app.model.UploadFileDataBean;
import com.argusoft.sewa.android.app.restclient.RestHttpException;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * @author Alpesh
 */

public interface SewaServiceRestClient {

    UserInfoDataBean getUser(String username, String password, String firebaseToken, Boolean firstTimeLoggedIn) throws RestHttpException;

    RecordStatusBean[] recordEntryFromMobileToServer(String token, String[] records) throws RestHttpException;

    String uploadUncaughtExceptionToServer(Long userId, List<UncaughtExceptionBean> exceptionBeans) throws RestHttpException;

    String retrieveAndroidVersionFromServer() throws RestHttpException;

    boolean retrieveServerIsAlive() throws RestHttpException;

    Boolean retrieveUserInProductionFromServer(String userName) throws RestHttpException;

    Boolean retrieveUserInTrainingFromServer(String userName) throws RestHttpException;

    Boolean syncMergedFamiliesInformationWithServer(List<MergedFamiliesBean> mergedFamiliesBeans) throws RestHttpException;

    Map<String, FamilyDataBean> getFamilyToBeAssignedBySearchString(String searchString, Boolean searchByFamilyId) throws RestHttpException;

    FamilyDataBean assignFamilyToUser(String locationId, String familyId) throws RestHttpException;

    List<FormAccessibilityBean> getUserFormAccessDetailFromServer() throws RestHttpException;

    void postUserReadyToMoveProduction(String formType) throws RestHttpException;

    LoggedInUserPrincipleDataBean getDetails(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    LoggedInUserPrincipleDataBean getDetailsForAsha(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    LoggedInUserPrincipleDataBean getDetailsForAww(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    LoggedInUserPrincipleDataBean getDetailsForRbsk(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    LoggedInUserPrincipleDataBean getDetailsForFHSR(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    List<FamilyDataBean> getFamiliesByLocationId(Long locationId, String lastUpdateDate) throws RestHttpException;

    Boolean getTokenValidity(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException;

    LoggedInUserPrincipleDataBean revalidateUserToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException;

    Map<String, String[]> getUserIdAndTokenFromToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException;

    QueryMobDataBean executeQuery(QueryMobDataBean queryMobDataBean) throws RestHttpException;
    void sendOtpRequest(String mobileNumber) throws RestHttpException;

    Boolean verifyOtp(String mobileNumber, String otp) throws RestHttpException;

    Map<String, Object> checkIfDeviceIsBlockedOrDeleteDatabase(String imei) throws RestHttpException;

    void removeEntryForDeviceOfIMEI(String imei) throws RestHttpException;

    String storeOpdLabFormDetails(String answerString, Integer labTestDetId, String labTestVersion) throws RestHttpException;

    LoggedInUserPrincipleDataBean syncData(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException;

    Map<String, Boolean> getMetadata() throws RestHttpException;

    List<RecordStatusBean> lmsEventEntryFromMobileToDBeans(List<LmsEventBean> lmsEventBeans) throws RestHttpException;

    void updateLanguagePreference(String preferredLanguage) throws RestHttpException;

    void addFireBaseToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException;

    Map<String, Integer> getAnnouncementsUnreadCountByHealthInfra(Integer healthInfraId) throws RestHttpException;

    String getSystemConfigurationByKey(String key) throws RestHttpException;

    List<LanguageMasterDto> getAllActiveLanguage() throws RestHttpException;

    RecordStatusBean uploadMediaToServer(UploadFileDataBean bean, File file) throws IOException;

    List<StockManagementDataBean> getStockManagementDataBeans(Long requestedBy, Boolean isApproved) throws RestHttpException;

    void markStockStatusAsDelivered(Integer stockReqId, Integer medicineId, Long userId) throws RestHttpException;
}
