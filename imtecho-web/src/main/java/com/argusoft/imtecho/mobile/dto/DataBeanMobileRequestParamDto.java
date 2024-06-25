package com.argusoft.imtecho.mobile.dto;

import com.argusoft.imtecho.course.dto.LmsMobileEventDto;
import lombok.Getter;
import lombok.Setter;

import java.util.Arrays;
import java.util.List;

@Getter
@Setter
public class DataBeanMobileRequestParamDto {
    private String token;
    private Integer userId;
    // For language change
    private String languageCode;
    // For Validate User
    private String userName;
    private String password;
    private String firstName;
    private String lastName;
    private Boolean isFirstTimeLogin;
    // For Upload Uncaught Excption
    private List<UncaughtExceptionBean> uncaughtExceptionBeans;
    //For Aadhar Update Details
    private List<AadharUpdationBean> aadharUpdationBeans;
    //For Search For Family to Assign
    private String searchString;
    private Boolean isSearchByFamilyId;
    //For Assign Family
    private String locationId;
    private String familyId;
    //For Merged Family Information
    private List<MergedFamiliesBean> mergedFamiliesBeans;
    //For Move to Production
    private String formCode;
    //For Record Entry
    private List<ParsedRecordObjectBean> records;
    private String[] userPassMap;
    List<String> userTokens;
    private String mobileNumber;
    private String otp;
    //For User's Attendance Entry
    private String gpsRecords;
    private Integer attendanceId;

    //For OPD Lab Test forms
    private String answerString;
    private Integer labTestDetId;
    private String labTestVersion;

    private String firebaseToken;
    //For Lms Mobile Event
    private List<LmsMobileEventDto> mobileEvents;
    //For RI search
    private String healthIdNumber;

    @Override
    public String toString() {
        return "MobileRequestParamDto{" + "token=" + token + ", userId=" + userId + ", userName=" + userName + ", password=" + password + ", isFirstTimeLogin=" + isFirstTimeLogin + ", aadharUpdationBeans=" + aadharUpdationBeans + ", searchString=" + searchString + ", isSearchByFamilyId=" + isSearchByFamilyId + ", locationId=" + locationId + ", familyId=" + familyId + ", mergedFamiliesBeans=" + mergedFamiliesBeans + ", formCode=" + formCode + ", records=" + records.toString() + ", userPassMap=" + Arrays.toString(userPassMap) + ", userTokens=" + userTokens + '}';
    }
}