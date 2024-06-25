package com.argusoft.sewa.android.app.core.impl;

import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_AUTHENTICATION;
import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_CONFIRM_AADHAAR_OTP;
import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_CONFIRM_MOBILE_OTP;
import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_CONFIRM_PASSWORD;
import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_RESEND_OTP;
import static com.argusoft.sewa.android.app.util.WSConstants.ApiCalls.TECHO_NDHM_STATES;

import com.argusoft.sewa.android.app.core.SewaServiceRestClient;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.LanguageMasterDto;
import com.argusoft.sewa.android.app.databean.LoggedInUserPrincipleDataBean;
import com.argusoft.sewa.android.app.databean.LoginRequestParamDetailDataBean;
import com.argusoft.sewa.android.app.databean.MobileRequestParamDto;
import com.argusoft.sewa.android.app.databean.QueryMobDataBean;
import com.argusoft.sewa.android.app.databean.RecordStatusBean;
import com.argusoft.sewa.android.app.databean.StockManagementDataBean;
import com.argusoft.sewa.android.app.databean.UserInfoDataBean;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.FormAccessibilityBean;
import com.argusoft.sewa.android.app.model.LmsEventBean;
import com.argusoft.sewa.android.app.model.MergedFamiliesBean;
import com.argusoft.sewa.android.app.model.UncaughtExceptionBean;
import com.argusoft.sewa.android.app.model.UploadFileDataBean;
import com.argusoft.sewa.android.app.model.VersionBean;
import com.argusoft.sewa.android.app.restclient.RestHttpException;
import com.argusoft.sewa.android.app.restclient.impl.ApiManager;
import com.argusoft.sewa.android.app.restclient.impl.RestConstantMsg;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.FileUtilsNewKt;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.WSConstants;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.RequestBody;
import retrofit2.Call;
import retrofit2.Response;

/**
 * @author Alpesh
 */
@EBean(scope = EBean.Scope.Singleton)
public class SewaServiceRestClientImpl implements SewaServiceRestClient {

    @Bean
    ApiManager apiManager;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<VersionBean, Integer> versionBeanDao;

    private static final List<Call> listOfCalls = new ArrayList<>();

    public static List<Call> getListOfCalls() {
        return listOfCalls;
    }

    private String getRelativeUrl(String relativePath) {

        switch (relativePath) {
            case WSConstants.ApiCalls.GET_ANDROID_VERSION:
            case WSConstants.ApiCalls.GET_FONT_SIZE:
            case WSConstants.ApiCalls.TECHO_IS_USER_IN_PRODUCTION:
            case WSConstants.ApiCalls.TECHO_VALIDATE_USER_NEW:
            case WSConstants.ApiCalls.TECHO_UPLOAD_UNCAUGHT_EXCEPTION_DETAIL:
            case WSConstants.ApiCalls.TECHO_RECORD_ENTRY_MOBILE_TO_DB_SERVER:
            case WSConstants.ApiCalls.TECHO_POST_AADHAR_UPDATE_DETAILS:
            case WSConstants.ApiCalls.TECHO_POST_MERGED_FAMILIES_INFORMATION:
            case WSConstants.ApiCalls.TECHO_GET_FAMILY_TO_BE_ASSIGNED_BY_SEARCH_STRING:
            case WSConstants.ApiCalls.TECHO_POST_ASSIGN_FAMILY_TO_USER:
            case WSConstants.ApiCalls.TECHO_GET_USER_FORM_ACCESS_DETAIL:
            case WSConstants.ApiCalls.TECHO_POST_USER_READY_TO_MOVE_PRODUCTION:
            case WSConstants.ApiCalls.TECHO_POST_SYNC_MIGRATION_DETAILS:
            case WSConstants.ApiCalls.TECHO_GET_TOKEN_VALIDITY:
            case WSConstants.ApiCalls.TECHO_REVALIDATE_TOKEN:
            case WSConstants.ApiCalls.TECHO_GET_USER_FROM_TOKEN:
            case WSConstants.ApiCalls.GET_DETAILS_FHW:
            case WSConstants.ApiCalls.GET_DETAILS_ASHA:
            case WSConstants.ApiCalls.GET_DETAILS_FHSR:
            case WSConstants.ApiCalls.GET_FAMILIES_BY_LOCATION:
            case WSConstants.ApiCalls.TECHO_OTP_REQUEST:
            case WSConstants.ApiCalls.TECHO_OTP_VERIFICATION:
            case WSConstants.ApiCalls.SYNC_DATA:
            case WSConstants.ApiCalls.GET_METADATA:
                try {
                    VersionBean versionBean = versionBeanDao.queryBuilder().where().eq("key", GlobalTypes.VERSION_SSL_FLAG).queryForFirst();
                    if (versionBean != null && Boolean.parseBoolean(versionBean.getValue())) {
                        String url = WSConstants.REST_TECHO_SERVICE_URL + relativePath;
                        return url.replace("http:", "https:");
                    }
                } catch (SQLException e) {
                    Log.e(getClass().getSimpleName(), null, e);
                }
                return WSConstants.REST_TECHO_SERVICE_URL + relativePath;

            case WSConstants.ApiCalls.TECHO_NDHM_GENERATE_AADHAAR_OTP:
            case WSConstants.ApiCalls.TECHO_NDHM_CREATE_USING_AADHAAR_OTP:
            case WSConstants.ApiCalls.TECHO_NDHM_CREATE_USING_AADHAAR_DEMO:
            case WSConstants.ApiCalls.TECHO_NDHM_HEALTH_ID_CARD:
            case WSConstants.ApiCalls.TECHO_NDHM_SEARCH:
            case TECHO_NDHM_AUTHENTICATION:
            case WSConstants.ApiCalls.TECHO_NDHM_CONFIRM_AADHAAR_DEMO:
            case TECHO_NDHM_CONFIRM_AADHAAR_OTP:
            case TECHO_NDHM_CONFIRM_MOBILE_OTP:
            case TECHO_NDHM_CONFIRM_PASSWORD:
            case TECHO_NDHM_RESEND_OTP:
            case TECHO_NDHM_STATES:
            case WSConstants.ApiCalls.TECHO_NDHM_LINK_BENEFIT:
                return WSConstants.REST_TECHO_NDHM_SERVICE_URL + relativePath;

            default:
        }
        return WSConstants.REST_TECHO_SERVICE_URL + relativePath;
    }

    @Override
    public String retrieveAndroidVersionFromServer() throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().retrieveAndroidVersionFromServer());
    }

    @Override
    public boolean retrieveServerIsAlive() throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().retrieveServerIsAlive());
    }

    @Override
    public Boolean retrieveUserInProductionFromServer(String userName) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setUserName(userName);

        return apiManager.execute(apiManager.getInstance().retrieveUserInProductionFromServer(mobileRequestParamDto));
    }

    @Override
    public Boolean retrieveUserInTrainingFromServer(String userName) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setUserName(userName);

        String url = WSConstants.CONTEXT_URL_TECHO_TRAINING + "api/mobile/" + WSConstants.ApiCalls.TECHO_IS_USER_IN_PRODUCTION;

        return apiManager.execute(apiManager.getInstance().retrieveUserInTrainingFromServer(url, mobileRequestParamDto));
    }

    @Override
    public UserInfoDataBean getUser(String username, String password, String firebaseToken, Boolean firstTimeLoggedIn) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setUserName(username);
        mobileRequestParamDto.setPassword(password);
        mobileRequestParamDto.setFirebaseToken(firebaseToken);
        mobileRequestParamDto.setFirstTimeLogin(firstTimeLoggedIn);
        return apiManager.execute(apiManager.getInstance().getUser(mobileRequestParamDto));
    }

    @Override
    public String uploadUncaughtExceptionToServer(Long userId, List<UncaughtExceptionBean> exceptionBeans) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setUserId(userId);
        mobileRequestParamDto.setUncaughtExceptionBeans(exceptionBeans);

        return apiManager.execute(apiManager.getInstance().uploadUncaughtExceptionToServer(mobileRequestParamDto));
    }

    @Override
    public RecordStatusBean[] recordEntryFromMobileToServer(String token, String[] records) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(token);
        mobileRequestParamDto.setRecords(records);

        return apiManager.execute(apiManager.getInstance().recordEntryFromMobileToServer(mobileRequestParamDto));
    }

    @Override
    public Boolean syncMergedFamiliesInformationWithServer(List<MergedFamiliesBean> mergedFamiliesBeans) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setMergedFamiliesBeans(mergedFamiliesBeans);

        return apiManager.execute(apiManager.getInstance().syncMergedFamiliesInformationWithServer(mobileRequestParamDto));
    }

    @Override
    public Map<String, FamilyDataBean> getFamilyToBeAssignedBySearchString(String searchString, Boolean searchByFamilyId) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setSearchString(searchString);
        mobileRequestParamDto.setSearchByFamilyId(searchByFamilyId);

        return apiManager.execute(apiManager.getInstance().getFamilyToBeAssignedBySearchString(mobileRequestParamDto));
    }

    @Override
    public FamilyDataBean assignFamilyToUser(String locationId, String familyId) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setLocationId(locationId);
        mobileRequestParamDto.setFamilyId(familyId);

        return apiManager.execute(apiManager.getInstance().assignFamilyToUser(mobileRequestParamDto));
    }

    @Override
    public List<FormAccessibilityBean> getUserFormAccessDetailFromServer() throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());

        return apiManager.execute(apiManager.getInstance().getUserFormAccessDetailFromServer(mobileRequestParamDto));
    }

    @Override
    public void postUserReadyToMoveProduction(String formType) throws RestHttpException {
        if (!SewaUtil.isUserInTraining) {
            return;
        }

        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setFormCode(formType);

        apiManager.execute(apiManager.getInstance().postUserReadyToMoveProduction(mobileRequestParamDto));
    }

    @Override
    public LoggedInUserPrincipleDataBean getDetails(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getDetails(loginRequestParamDetailDataBean));
    }

    @Override
    public LoggedInUserPrincipleDataBean getDetailsForAsha(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getDetailsForAsha(loginRequestParamDetailDataBean));
    }

    @Override
    public LoggedInUserPrincipleDataBean getDetailsForAww(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getDetailsForAww(loginRequestParamDetailDataBean));
    }

    @Override
    public LoggedInUserPrincipleDataBean getDetailsForRbsk(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getDetailsForRbsk(loginRequestParamDetailDataBean));
    }

    @Override
    public LoggedInUserPrincipleDataBean getDetailsForFHSR(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getDetailsForFHSR(loginRequestParamDetailDataBean));
    }

    @Override
    public List<FamilyDataBean> getFamiliesByLocationId(Long locationId, String lastUpdateDate) throws RestHttpException {
        LoginRequestParamDetailDataBean requestParam = new LoginRequestParamDetailDataBean();
        requestParam.setToken(SewaTransformer.loginBean.getUserToken());
        requestParam.setLocationId(locationId);
        requestParam.setLastUpdateDateForFamily(lastUpdateDate);

        return apiManager.execute(apiManager.getInstance().getFamiliesByLocationId(requestParam));
    }

    @Override
    public Boolean getTokenValidity(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getTokenValidity(mobileRequestParamDto));
    }

    @Override
    public LoggedInUserPrincipleDataBean revalidateUserToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().revalidateUserToken(mobileRequestParamDto));
    }

    @Override
    public Map<String, String[]> getUserIdAndTokenFromToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getUserIdAndTokenFromToken(mobileRequestParamDto));
    }

    @Override
    public QueryMobDataBean executeQuery(QueryMobDataBean queryMobDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().executeQuery(queryMobDataBean));
    }

    @Override
    public void sendOtpRequest(String mobileNumber) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setMobileNumber(mobileNumber);

        apiManager.execute(apiManager.getInstance().sendOtpRequest(mobileRequestParamDto));
    }

    @Override
    public Boolean verifyOtp(String mobileNumber, String otp) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setMobileNumber(mobileNumber);
        mobileRequestParamDto.setOtp(otp);

        return apiManager.execute(apiManager.getInstance().verifyOtp(mobileRequestParamDto));
    }

    @Override
    public Map<String, Object> checkIfDeviceIsBlockedOrDeleteDatabase(String imei) throws RestHttpException {
        Map<String, Object> requestParams = new HashMap<>();
        requestParams.put("imei", imei);

        return apiManager.execute(apiManager.getInstance().checkIfDeviceIsBlockedOrDeleteDatabase(requestParams));
    }

    @Override
    public void removeEntryForDeviceOfIMEI(String imei) throws RestHttpException {
        Map<String, Object> requestParams = new HashMap<>();
        requestParams.put("imei", imei);

        apiManager.execute(apiManager.getInstance().removeEntryForDeviceOfIMEI(requestParams));
    }

    @Override
    public String storeOpdLabFormDetails(String answerString, Integer labTestDetId, String labTestVersion) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setLabTestDetId(labTestDetId);
        mobileRequestParamDto.setAnswerString(answerString);
        mobileRequestParamDto.setLabTestVersion(labTestVersion);

        return apiManager.execute(apiManager.getInstance().storeOpdLabFormDetails(mobileRequestParamDto));
    }

    @Override
    public LoggedInUserPrincipleDataBean syncData(LoginRequestParamDetailDataBean loginRequestParamDetailDataBean) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().syncData(loginRequestParamDetailDataBean));
    }

    @Override
    public Map<String, Boolean> getMetadata() throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());

        return apiManager.execute(apiManager.getInstance().getMetadata(mobileRequestParamDto));
    }

    @Override
    public void addFireBaseToken(MobileRequestParamDto mobileRequestParamDto) throws RestHttpException {
        apiManager.execute(apiManager.getInstance().addFireBaseToken(mobileRequestParamDto));
    }

    @Override
    public Map<String, Integer> getAnnouncementsUnreadCountByHealthInfra(Integer healthInfraId) throws RestHttpException {
        Map<String, Object> requestParams = new HashMap<>();
        if (healthInfraId != null) {
            requestParams.put("healthInfraId", healthInfraId);
        }
        return apiManager.execute(apiManager.getInstance().getAnnouncementsUnreadCountByHealthInfra(requestParams));
    }

    @Override
    public String getSystemConfigurationByKey(String key) throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getSystemConfigurationByKey(key)).get(key);
    }

    @Override
    public List<LanguageMasterDto> getAllActiveLanguage() throws RestHttpException {
        return apiManager.execute(apiManager.getInstance().getAllActiveLanguage());
    }

    public RecordStatusBean uploadMediaToServer(UploadFileDataBean bean, File file) throws IOException {
        Call<RecordStatusBean> call = apiManager.getInstance().uploadMediaToServer(MultipartBody.Part.createFormData("file", file.getName(), RequestBody.create(file, MediaType.parse(FileUtilsNewKt.getMimeType(file)))), bean);
        Response<RecordStatusBean> response = call.execute();
        if (response.isSuccessful()) {
            return response.body();
        } else {
            throw new IOException(RestConstantMsg.MSG_INTERNAL_SERVER_ERROR, new Throwable());
        }
    }

    @Override
    public List<StockManagementDataBean> getStockManagementDataBeans(Long userId, Boolean isApproved) throws RestHttpException {
        Map<String, Object> requestParams = new HashMap<>();
        requestParams.put("requestedBy", userId);
        requestParams.put("getApproved", isApproved);
        return apiManager.execute(apiManager.getInstance().getStockManagementDataBeans(requestParams));
    }

    @Override
    public void markStockStatusAsDelivered(Integer stockReqId, Integer medicineId, Long userId) throws RestHttpException {
        Map<String, Object> requestParams = new HashMap<>();
        requestParams.put("stockReqId", stockReqId);
        requestParams.put("medicineId", medicineId);
        requestParams.put("userId", userId);
        apiManager.execute(apiManager.getInstance().markStockStatusAsDelivered(requestParams));
    }

    @Override
    public List<RecordStatusBean> lmsEventEntryFromMobileToDBeans(List<LmsEventBean> lmsEventBeans) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setMobileEvents(lmsEventBeans);
        return apiManager.execute(apiManager.getInstance().lmsEventEntryFromMobileToDBeans(mobileRequestParamDto));
    }

    @Override
    public void updateLanguagePreference(String preferredLanguage) throws RestHttpException {
        MobileRequestParamDto mobileRequestParamDto = new MobileRequestParamDto();
        mobileRequestParamDto.setToken(SewaTransformer.loginBean.getUserToken());
        mobileRequestParamDto.setLanguageCode(preferredLanguage);
        apiManager.execute(apiManager.getInstance().updateLanguagePreference(mobileRequestParamDto));
    }
}
