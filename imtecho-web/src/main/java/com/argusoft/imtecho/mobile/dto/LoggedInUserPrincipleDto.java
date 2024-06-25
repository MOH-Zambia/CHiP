/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dto;

import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;
import com.argusoft.imtecho.common.model.UserHealthInfrastructure;
import com.argusoft.imtecho.course.model.LmsUserMetaData;
import com.argusoft.imtecho.fhs.dto.FhwServiceStatusDto;
import com.argusoft.imtecho.location.model.LocationTypeMaster;
import com.argusoft.imtecho.migration.dto.MigratedFamilyDataBean;
import com.argusoft.imtecho.migration.dto.MigratedMembersDataBean;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.rch.dto.MemberPregnancyStatusBean;
import com.argusoft.imtecho.rch.dto.RchVillageProfileDto;
import lombok.Getter;
import lombok.Setter;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author vaishali
 */
public class LoggedInUserPrincipleDto {

    private List<FamilyDataBean> assignedFamilies;
    private List<SickleCellFamilyDataBean> sickleCellSurveyFamilies;
    private Map<Integer, List<SurveyLocationMobDataBean>> retrievedVillageAndChildLocations;
    private List<FamilyDataBean> orphanedAndReverificationFamilies;
    private List<FhwServiceStatusDto> fhwServiceStatusDtos;
    private List<FamilyDataBean> updatedFamilyByDate;
    private List<SickleCellFamilyDataBean> updatedSickleCellFamilyByDate;
    private List<TechoNotificationDataBean> notifications;
    private List<Integer> deletedNotifications;
    private QueryDto retrievedLabels;
    private QueryDto csvCoordinates;
    private Map<String, List<ComponentTagDto>> retrievedXlsData;
    private Map<String, Integer> currentSheetVersion;
    private Integer currentMobileFormVersion;
    private List<LinkedHashMap<String, Object>> retrievedListValues;
    private List<LinkedHashMap<String, Object>> dataQualityBeans;
    private List<AnnouncementMobDataBean> retrievedAnnouncements;
    private List<String> deletedFamilies;
    private List<RchVillageProfileDto> rchVillageProfileDtos;
    private List<LocationMasterDataBean> locationMasterBeans;
    private List<Integer> locationsForFamilyDataDeletion;
    private String newToken;
    private List<String> features;
    private List<MobileLibraryDataBean> mobileLibraryDataBeans;
    private List<MigratedMembersDataBean> migratedMembersDataBeans;
    private List<HealthInfrastructureBean> healthInfrastructures;
    private List<MemberPregnancyStatusBean> pregnancyStatus;
    private Long lastPregnancyStatusDate;
    private List<LocationTypeMaster> locationTypeMasters;
    private List<MenuDataBean> mobileMenus;
    private List<MigratedFamilyDataBean> migratedFamilyDataBeans;
    private List<CourseDataBean> courseDataBeans;
    private List<LmsUserMetaData> lmsUserMetaData;
    private String lmsFileDownloadUrl;
    private List<UserHealthInfrastructure> userHealthInfrastructures;
    private Map<String, String> systemConfigurations;
    private List<FamilyAvailabilityDataBean> familyAvailabilities;
    private List<HealthInfraTypeLocationBean> healthInfraTypeLocationBeanList;
    private List<NcdMemberDataBean> ncdMemberBeans;
    private List<AnemiaMemberDataBean> anemiaMemberDataBeans;
    private List<StockInventoryDataBean> stockInventoryDataBeans;
    private List<OcrFormDataBean> ocrFormDataBeans;
    private List<SurveillanceFamilyDataBean> surveillanceFamilies;
    private List<SurveillanceFamilyDataBean> updatedSurveillanceFamilyByDate;

    @Getter
    @Setter
    private List<HUMemberDataBean> huMemberDataBeans;

    public List<FamilyDataBean> getAssignedFamilies() {
        return assignedFamilies;
    }

    public void setAssignedFamilies(List<FamilyDataBean> assignedFamilies) {
        this.assignedFamilies = assignedFamilies;
    }

    public Map<Integer, List<SurveyLocationMobDataBean>> getRetrievedVillageAndChildLocations() {
        return retrievedVillageAndChildLocations;
    }

    public void setRetrievedVillageAndChildLocations(Map<Integer, List<SurveyLocationMobDataBean>> retrievedVillageAndChildLocations) {
        this.retrievedVillageAndChildLocations = retrievedVillageAndChildLocations;
    }

    public List<FamilyDataBean> getOrphanedAndReverificationFamilies() {
        return orphanedAndReverificationFamilies;
    }

    public void setOrphanedAndReverificationFamilies(List<FamilyDataBean> orphanedAndReverificationFamilies) {
        this.orphanedAndReverificationFamilies = orphanedAndReverificationFamilies;
    }

    public List<FhwServiceStatusDto> getFhwServiceStatusDtos() {
        return fhwServiceStatusDtos;
    }

    public void setFhwServiceStatusDtos(List<FhwServiceStatusDto> fhwServiceStatusDtos) {
        this.fhwServiceStatusDtos = fhwServiceStatusDtos;
    }

    public List<FamilyDataBean> getUpdatedFamilyByDate() {
        return updatedFamilyByDate;
    }

    public void setUpdatedFamilyByDate(List<FamilyDataBean> updatedFamilyByDate) {
        this.updatedFamilyByDate = updatedFamilyByDate;
    }

    public List<TechoNotificationDataBean> getNotifications() {
        return notifications;
    }

    public void setNotifications(List<TechoNotificationDataBean> notifications) {
        this.notifications = notifications;
    }

    public List<Integer> getDeletedNotifications() {
        return deletedNotifications;
    }

    public void setDeletedNotifications(List<Integer> deletedNotifications) {
        this.deletedNotifications = deletedNotifications;
    }

    public QueryDto getRetrievedLabels() {
        return retrievedLabels;
    }

    public void setRetrievedLabels(QueryDto retrievedLabels) {
        this.retrievedLabels = retrievedLabels;
    }

    public QueryDto getCsvCoordinates() {
        return csvCoordinates;
    }

    public void setCsvCoordinates(QueryDto csvCoordinates) {
        this.csvCoordinates = csvCoordinates;
    }

    public Map<String, List<ComponentTagDto>> getRetrievedXlsData() {
        return retrievedXlsData;
    }

    public void setRetrievedXlsData(Map<String, List<ComponentTagDto>> retrievedXlsData) {
        this.retrievedXlsData = retrievedXlsData;
    }

    public Map<String, Integer> getCurrentSheetVersion() {
        return currentSheetVersion;
    }

    public void setCurrentSheetVersion(Map<String, Integer> currentSheetVersion) {
        this.currentSheetVersion = currentSheetVersion;
    }

    public Integer getCurrentMobileFormVersion() {
        return currentMobileFormVersion;
    }

    public void setCurrentMobileFormVersion(Integer currentMobileFormVersion) {
        this.currentMobileFormVersion = currentMobileFormVersion;
    }

    public List<LinkedHashMap<String, Object>> getRetrievedListValues() {
        return retrievedListValues;
    }

    public void setRetrievedListValues(List<LinkedHashMap<String, Object>> retrievedListValues) {
        this.retrievedListValues = retrievedListValues;
    }

    public List<LinkedHashMap<String, Object>> getDataQualityBeans() {
        return dataQualityBeans;
    }

    public void setDataQualityBeans(List<LinkedHashMap<String, Object>> dataQualityBeans) {
        this.dataQualityBeans = dataQualityBeans;
    }

    public List<AnnouncementMobDataBean> getRetrievedAnnouncements() {
        return retrievedAnnouncements;
    }

    public void setRetrievedAnnouncements(List<AnnouncementMobDataBean> retrievedAnnouncements) {
        this.retrievedAnnouncements = retrievedAnnouncements;
    }

    public List<String> getDeletedFamilies() {
        return deletedFamilies;
    }

    public void setDeletedFamilies(List<String> deletedFamilies) {
        this.deletedFamilies = deletedFamilies;
    }

    public List<RchVillageProfileDto> getRchVillageProfileDtos() {
        return rchVillageProfileDtos;
    }

    public void setRchVillageProfileDtos(List<RchVillageProfileDto> rchVillageProfileDtos) {
        this.rchVillageProfileDtos = rchVillageProfileDtos;
    }

    public List<LocationMasterDataBean> getLocationMasterBeans() {
        return locationMasterBeans;
    }

    public void setLocationMasterBeans(List<LocationMasterDataBean> locationMasterBeans) {
        this.locationMasterBeans = locationMasterBeans;
    }

    public List<Integer> getLocationsForFamilyDataDeletion() {
        return locationsForFamilyDataDeletion;
    }

    public void setLocationsForFamilyDataDeletion(List<Integer> locationsForFamilyDataDeletion) {
        this.locationsForFamilyDataDeletion = locationsForFamilyDataDeletion;
    }

    public String getNewToken() {
        return newToken;
    }

    public void setNewToken(String newToken) {
        this.newToken = newToken;
    }

    public List<String> getFeatures() {
        return features;
    }

    public void setFeatures(List<String> features) {
        this.features = features;
    }

    public List<MobileLibraryDataBean> getMobileLibraryDataBeans() {
        return mobileLibraryDataBeans;
    }

    public void setMobileLibraryDataBeans(List<MobileLibraryDataBean> mobileLibraryDataBeans) {
        this.mobileLibraryDataBeans = mobileLibraryDataBeans;
    }

    public List<MigratedMembersDataBean> getMigratedMembersDataBeans() {
        return migratedMembersDataBeans;
    }

    public void setMigratedMembersDataBeans(List<MigratedMembersDataBean> migratedMembersDataBeans) {
        this.migratedMembersDataBeans = migratedMembersDataBeans;
    }

    public List<HealthInfrastructureBean> getHealthInfrastructures() {
        return healthInfrastructures;
    }

    public void setHealthInfrastructures(List<HealthInfrastructureBean> healthInfrastructures) {
        this.healthInfrastructures = healthInfrastructures;
    }

    public List<MemberPregnancyStatusBean> getPregnancyStatus() {
        return pregnancyStatus;
    }

    public void setPregnancyStatus(List<MemberPregnancyStatusBean> pregnancyStatus) {
        this.pregnancyStatus = pregnancyStatus;
    }

    public Long getLastPregnancyStatusDate() {
        return lastPregnancyStatusDate;
    }

    public void setLastPregnancyStatusDate(Long lastPregnancyStatusDate) {
        this.lastPregnancyStatusDate = lastPregnancyStatusDate;
    }

    public List<LocationTypeMaster> getLocationTypeMasters() {
        return locationTypeMasters;
    }

    public void setLocationTypeMasters(List<LocationTypeMaster> locationTypeMasters) {
        this.locationTypeMasters = locationTypeMasters;
    }

    public List<MenuDataBean> getMobileMenus() {
        return mobileMenus;
    }

    public void setMobileMenus(List<MenuDataBean> mobileMenus) {
        this.mobileMenus = mobileMenus;
    }

    public List<MigratedFamilyDataBean> getMigratedFamilyDataBeans() {
        return migratedFamilyDataBeans;
    }

    public void setMigratedFamilyDataBeans(List<MigratedFamilyDataBean> migratedFamilyDataBeans) {
        this.migratedFamilyDataBeans = migratedFamilyDataBeans;
    }

    public List<CourseDataBean> getCourseDataBeans() {
        return courseDataBeans;
    }

    public void setCourseDataBeans(List<CourseDataBean> courseDataBeans) {
        this.courseDataBeans = courseDataBeans;
    }

    public List<LmsUserMetaData> getLmsUserMetaData() {
        return lmsUserMetaData;
    }

    public void setLmsUserMetaData(List<LmsUserMetaData> lmsUserMetaData) {
        this.lmsUserMetaData = lmsUserMetaData;
    }

    public String getLmsFileDownloadUrl() {
        return lmsFileDownloadUrl;
    }

    public void setLmsFileDownloadUrl(String lmsFileDownloadUrl) {
        this.lmsFileDownloadUrl = lmsFileDownloadUrl;
    }

    public List<UserHealthInfrastructure> getUserHealthInfrastructures() {
        return userHealthInfrastructures;
    }

    public void setUserHealthInfrastructures(List<UserHealthInfrastructure> userHealthInfrastructures) {
        this.userHealthInfrastructures = userHealthInfrastructures;
    }

    public Map<String, String> getSystemConfigurations() {
        return systemConfigurations;
    }

    public void setSystemConfigurations(Map<String, String> systemConfigurations) {
        this.systemConfigurations = systemConfigurations;
    }

    public List<FamilyAvailabilityDataBean> getFamilyAvailabilities() {
        return familyAvailabilities;
    }

    public void setFamilyAvailabilities(List<FamilyAvailabilityDataBean> familyAvailabilities) {
        this.familyAvailabilities = familyAvailabilities;
    }

    public List<NcdMemberDataBean> getNcdMemberBeans() {
        return ncdMemberBeans;
    }

    public void setNcdMemberBeans(List<NcdMemberDataBean> ncdMemberBeans) {
        this.ncdMemberBeans = ncdMemberBeans;
    }

    public List<HealthInfraTypeLocationBean> getHealthInfraTypeLocationBeanList() {
        return healthInfraTypeLocationBeanList;
    }

    public void setHealthInfraTypeLocationBeanList(List<HealthInfraTypeLocationBean> healthInfraTypeLocationBeanList) {
        this.healthInfraTypeLocationBeanList = healthInfraTypeLocationBeanList;
    }

    public List<AnemiaMemberDataBean> getAnemiaMemberDataBeans() {
        return anemiaMemberDataBeans;
    }

    public void setAnemiaMemberDataBeans(List<AnemiaMemberDataBean> anemiaMemberDataBeans) {
        this.anemiaMemberDataBeans = anemiaMemberDataBeans;
    }

    public List<SickleCellFamilyDataBean> getSickleCellSurveyFamilies() {
        return sickleCellSurveyFamilies;
    }

    public void setSickleCellSurveyFamilies(List<SickleCellFamilyDataBean> sickleCellSurveyFamilies) {
        this.sickleCellSurveyFamilies = sickleCellSurveyFamilies;
    }

    public List<SickleCellFamilyDataBean> getUpdatedSickleCellFamilyByDate() {
        return updatedSickleCellFamilyByDate;
    }

    public void setUpdatedSickleCellFamilyByDate(List<SickleCellFamilyDataBean> updatedSickleCellFamilyFamilyByDate) {
        this.updatedSickleCellFamilyByDate = updatedSickleCellFamilyFamilyByDate;
    }

    public List<SurveillanceFamilyDataBean> getSurveillanceFamilies() {
        return surveillanceFamilies;
    }

    public void setSurveillanceFamilies(List<SurveillanceFamilyDataBean> surveillanceFamilies) {
        this.surveillanceFamilies = surveillanceFamilies;
    }

    public List<SurveillanceFamilyDataBean> getUpdatedSurveillanceFamilyByDate() {
        return updatedSurveillanceFamilyByDate;
    }

    public void setUpdatedSurveillanceFamilyByDate(List<SurveillanceFamilyDataBean> updatedSurveillanceFamilyByDate) {
        this.updatedSurveillanceFamilyByDate = updatedSurveillanceFamilyByDate;
    }

    public List<StockInventoryDataBean> getStockInventoryDataBeans() {
        return stockInventoryDataBeans;
    }

    public void setStockInventoryDataBeans(List<StockInventoryDataBean> stockInventoryDataBeans) {
        this.stockInventoryDataBeans = stockInventoryDataBeans;
    }

    public List<OcrFormDataBean> getOcrFormDataBeans() {
        return ocrFormDataBeans;
    }

    public void setOcrFormDataBeans(List<OcrFormDataBean> ocrFormDataBeans) {
        this.ocrFormDataBeans = ocrFormDataBeans;
    }
}
