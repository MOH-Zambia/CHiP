package com.argusoft.sewa.android.app.databean;

import androidx.annotation.NonNull;

import java.util.Arrays;
import java.util.Map;

/**
 * @author kelvin
 */
public class UserInfoDataBean {

    private boolean authenticated;
    private String contactNumber;
    private Long dob;
    private boolean firstTimeLogin;
    private String languageCode;
    private String loginFailureMsg;
    private String password;
    private Long userContactId;
    private String userRole;
    private String username;
    private String fName;
    private String phNoOfPM;
    private Long id;
    private String userToken;
    private Long serverDate;
    private long[] currentVillageCode;
    private String[] currentAssignedVillagesName;
    private boolean isNagarPalikaUser;
    //Example id@#phcName
    private Map<Integer, String> phcNames;
    //Example [phcId][subCenterId@#subcentername]
    private Map<Integer, String> subcenterNames;
    //Example [subcenterId][villageId@#villagename]
    private Map<Integer, String> villageNames;
    private String firstName;
    private String middleName;
    private String lastName;
    private boolean firstTimePasswordChanged;

    private boolean isSmagTrained;

    public boolean isAuthenticated() {
        return authenticated;
    }

    public void setAuthenticated(boolean authenticated) {
        this.authenticated = authenticated;
    }

    public String getContactNumber() {
        return contactNumber;
    }

    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }

    public Long getDob() {
        return dob;
    }

    public void setDob(Long dob) {
        this.dob = dob;
    }

    public boolean isFirstTimeLogin() {
        return firstTimeLogin;
    }

    public void setFirstTimeLogin(boolean firstTimeLogin) {
        this.firstTimeLogin = firstTimeLogin;
    }

    public String getLanguageCode() {
        return languageCode;
    }

    public void setLanguageCode(String languageCode) {
        this.languageCode = languageCode;
    }

    public String getLoginFailureMsg() {
        return loginFailureMsg;
    }

    public void setLoginFailureMsg(String loginFailureMsg) {
        this.loginFailureMsg = loginFailureMsg;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Long getUserContactId() {
        return userContactId;
    }

    public void setUserContactId(Long userContactId) {
        this.userContactId = userContactId;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getfName() {
        return fName;
    }

    public void setfName(String fName) {
        this.fName = fName;
    }

    public String getPhNoOfPM() {
        return phNoOfPM;
    }

    public void setPhNoOfPM(String phNoOfPM) {
        this.phNoOfPM = phNoOfPM;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getUserToken() {
        return userToken;
    }

    public void setUserToken(String userToken) {
        this.userToken = userToken;
    }

    public Long getServerDate() {
        return serverDate;
    }

    public void setServerDate(Long serverDate) {
        this.serverDate = serverDate;
    }

    public long[] getCurrentVillageCode() {
        return currentVillageCode;
    }

    public void setCurrentVillageCode(long[] currentVillageCode) {
        this.currentVillageCode = currentVillageCode;
    }

    public String[] getCurrentAssignedVillagesName() {
        return currentAssignedVillagesName;
    }

    public void setCurrentAssignedVillagesName(String[] currentAssignedVillagesName) {
        this.currentAssignedVillagesName = currentAssignedVillagesName;
    }

    public boolean isNagarPalikaUser() {
        return isNagarPalikaUser;
    }

    public void setNagarPalikaUser(boolean nagarPalikaUser) {
        isNagarPalikaUser = nagarPalikaUser;
    }

    public Map<Integer, String> getPhcNames() {
        return phcNames;
    }

    public void setPhcNames(Map<Integer, String> phcNames) {
        this.phcNames = phcNames;
    }

    public Map<Integer, String> getSubcenterNames() {
        return subcenterNames;
    }

    public void setSubcenterNames(Map<Integer, String> subcenterNames) {
        this.subcenterNames = subcenterNames;
    }

    public Map<Integer, String> getVillageNames() {
        return villageNames;
    }

    public void setVillageNames(Map<Integer, String> villageNames) {
        this.villageNames = villageNames;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public boolean getFirstTimePasswordChanged() {
        return firstTimePasswordChanged;
    }

    public void setFirstTimePasswordChanged(boolean firstTimePasswordChanged) {
        this.firstTimePasswordChanged = firstTimePasswordChanged;
    }

    public boolean getIsSmagTrained() {
        return isSmagTrained;
    }

    public void setIsSmagTrained(boolean isSmagTrained) {
        this.isSmagTrained = isSmagTrained;
    }

    @NonNull
    @Override
    public String toString() {
        return "UserInfoDataBean{" +
                "authenticated=" + authenticated +
                ", contactNumber='" + contactNumber + '\'' +
                ", dob=" + dob +
                ", firstTimeLogin=" + firstTimeLogin +
                ", languageCode='" + languageCode + '\'' +
                ", loginFailureMsg='" + loginFailureMsg + '\'' +
                ", password='" + password + '\'' +
                ", userContactId=" + userContactId +
                ", userRole='" + userRole + '\'' +
                ", username='" + username + '\'' +
                ", fName='" + fName + '\'' +
                ", phNoOfPM='" + phNoOfPM + '\'' +
                ", id=" + id +
                ", userToken='" + userToken + '\'' +
                ", serverDate=" + serverDate +
                ", currentVillageCode=" + Arrays.toString(currentVillageCode) +
                ", currentAssignedVillagesName=" + Arrays.toString(currentAssignedVillagesName) +
                ", isNagarPalikaUser=" + isNagarPalikaUser +
                ", phcNames=" + phcNames +
                ", subcenterNames=" + subcenterNames +
                ", villageNames=" + villageNames +
                '}';
    }
}
