package com.argusoft.sewa.android.app.restclient;

import com.argusoft.sewa.android.app.databean.AnnouncementMobDataBean;
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
import com.argusoft.sewa.android.app.model.UploadFileDataBean;

import java.util.List;
import java.util.Map;

import okhttp3.MultipartBody;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.Multipart;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Part;
import retrofit2.http.Query;
import retrofit2.http.QueryMap;
import retrofit2.http.Streaming;
import retrofit2.http.Url;

public interface ApiService {

    @GET("api/mobile/retrieveAndroidVersion")
    Call<String> retrieveAndroidVersionFromServer();

    @GET("api/mobile/getserverisalive")
    Call<Boolean> retrieveServerIsAlive();

    @POST("api/mobile/techoisuserinproduction")
    Call<Boolean> retrieveUserInProductionFromServer(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST
    Call<Boolean> retrieveUserInTrainingFromServer(@Url String url, @Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techovalidateusernew")
    Call<UserInfoDataBean> getUser(@Body MobileRequestParamDto mobileRequestParamDto);

    @PUT("api/mobile/techouploaduncaughtexceptiondetail")
    Call<String> uploadUncaughtExceptionToServer(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techorecordentryfrommobiletodbservernew")
    Call<RecordStatusBean[]> recordEntryFromMobileToServer(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techopostmergedfamiliesinformation")
    Call<Boolean> syncMergedFamiliesInformationWithServer(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techogetfamilybysearchstring")
    Call<Map<String, FamilyDataBean>> getFamilyToBeAssignedBySearchString(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techopostassignfamilytouser")
    Call<FamilyDataBean> assignFamilyToUser(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techogetuserformaccessdetail")
    Call<List<FormAccessibilityBean>> getUserFormAccessDetailFromServer(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techopostuserreadytomoveproduction")
    Call<List<FormAccessibilityBean>> postUserReadyToMoveProduction(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/getDetails")
    Call<LoggedInUserPrincipleDataBean> getDetails(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getdetailsasha")
    Call<LoggedInUserPrincipleDataBean> getDetailsForAsha(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getdetailsaww")
    Call<LoggedInUserPrincipleDataBean> getDetailsForAww(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getdetailsrbsk")
    Call<LoggedInUserPrincipleDataBean> getDetailsForRbsk(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getdetailsfhsr")
    Call<LoggedInUserPrincipleDataBean> getDetailsForFHSR(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getfamiliesbylocation")
    Call<List<FamilyDataBean>> getFamiliesByLocationId(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/techogettokenvalidity")
    Call<Boolean> getTokenValidity(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techorevalidatetoken")
    Call<LoggedInUserPrincipleDataBean> revalidateUserToken(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/techogetuserfromtoken")
    Call<Map<String, String[]>> getUserIdAndTokenFromToken(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/getdata")
    Call<QueryMobDataBean> executeQuery(@Body QueryMobDataBean queryMobDataBean);

    @POST("api/mobile/generateotptecho")
    Call<ResponseBody> sendOtpRequest(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/verifyotptecho")
    Call<Boolean> verifyOtp(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/markattendance")
    Call<Integer> markAttendanceForTheDay(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/storeattendance")
    Call<ResponseBody> storeAttendanceForTheDay(@Body MobileRequestParamDto mobileRequestParamDto);

    @GET("api/mobile/getimeiblockedordeletedatabase")
    Call<Map<String, Object>> checkIfDeviceIsBlockedOrDeleteDatabase(@QueryMap Map<String, Object> stringObjectMap);

    @GET("api/mobile/removeimeiblockedentry")
    Call<ResponseBody> removeEntryForDeviceOfIMEI(@QueryMap Map<String, Object> stringObjectMap);

    @POST("api/mobile/storeOpdLabTest")
    Call<String> storeOpdLabFormDetails(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/syncData")
    Call<LoggedInUserPrincipleDataBean> syncData(@Body LoginRequestParamDetailDataBean loginRequestParamDetailDataBean);

    @POST("api/mobile/getMetadata")
    Call<Map<String, Boolean>> getMetadata(@Body MobileRequestParamDto mobileRequestParamDto);

    @POST("api/mobile/lmsevententry")
    Call<List<RecordStatusBean>> lmsEventEntryFromMobileToDBeans(@Body MobileRequestParamDto mobileRequestParamDto);

    @Streaming
    @GET
    Call<ResponseBody> getFile(@Url String url);

    @POST("api/mobile/firebaseToken")
    Call<ResponseBody> addFireBaseToken(@Body MobileRequestParamDto mobileRequestParamDto);

    @GET("api/mobile/announcements/byhealthinfra")
    Call<List<AnnouncementMobDataBean>> getAnnouncementsByHealthInfra(@QueryMap Map<String, Object> stringObjectMap);

    @GET("api/mobile/announcements/unreadcount")
    Call<Map<String, Integer>> getAnnouncementsUnreadCountByHealthInfra(@QueryMap Map<String, Object> stringObjectMap);

    @GET("api/mobile/systemConfiguration")
    Call<Map<String, String>> getSystemConfigurationByKey(@Query("key") String key);

    @GET("api/mobile/activeLanguages")
    Call<List<LanguageMasterDto>> getAllActiveLanguage();

    @Multipart
    @POST("api/mobile/uploadMedia")
    Call<RecordStatusBean> uploadMediaToServer(@Part MultipartBody.Part filePart,
                                               @Part("uploadFileDataBean") UploadFileDataBean uploadFileDataBean);
    @GET("/api/stockmanagement/getStockManagementDataBeans")
    Call<List<StockManagementDataBean>> getStockManagementDataBeans(@QueryMap Map<String, Object> stringObjectMap);
    @POST("/api/stockmanagement/markStockStatusAsDelivered")
    Call<Integer> markStockStatusAsDelivered(@QueryMap Map<String, Object> stringObjectMap);

    @POST("api/mobile/user/changeLanguage")
    Call<ResponseBody> updateLanguagePreference(@Body MobileRequestParamDto mobileRequestParamDto);
}
