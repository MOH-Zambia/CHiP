package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.common.dao.SystemConfigurationDao;
import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dao.UserLocationDao;
import com.argusoft.imtecho.common.dao.UserTokenDao;
import com.argusoft.imtecho.common.dto.UserTokenDto;
import com.argusoft.imtecho.common.model.UserLocation;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.fhs.service.FamilyHealthSurveyService;
import com.argusoft.imtecho.location.constants.LocationConstants;
import com.argusoft.imtecho.location.dao.LocationHierchyCloserDetailDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.mobile.dto.*;
import com.argusoft.imtecho.mobile.mapper.FamilyDataBeanMapper;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;
import com.argusoft.imtecho.mobile.service.MobileAwwService;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.mobile.service.MobileLibraryService;
import com.argusoft.imtecho.mobile.util.XlsToDtoConversion;
import com.argusoft.imtecho.notification.dao.TechoNotificationMasterDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.io.IOException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@Service
@Transactional
public class MobileAwwServiceImpl implements MobileAwwService {

    @Autowired
    private MobileFhsService mobileFhsService;

    @Autowired
    private UserService userService;

    @Autowired
    private UserDao userDao;

    @Autowired
    private UserTokenDao userTokenDao;

    @Autowired
    private FamilyHealthSurveyService familyHealthSurveyService;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private LocationHierchyCloserDetailDao locationHierchyCloserDetailDao;

    @Autowired
    private UserLocationDao userLocationDao;

    @Autowired
    private SystemConfigurationDao systemConfigurationDao;

    @Autowired
    private XlsToDtoConversion xlsToDtoConversion;

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private MobileLibraryService mobileLibraryService;

    @Autowired
    private TechoNotificationMasterDao techoNotificationMasterDao;


    @Override
    public LoggedInUserPrincipleDto getDetails(LogInRequestParamDetailDto paramDetailDto, Integer apkVersion) {
        LoggedInUserPrincipleDto loggedInUserPrincipleDto = new LoggedInUserPrincipleDto();
        UserTokenDto userTokenDto = userTokenDao.retrieveDtoByUserToken(paramDetailDto.getToken());
        if (userTokenDto != null) {
            UserMaster user = userService.getUserByValidToken(userTokenDto.getUserToken());
            if (user != null) {
                Integer sheetVersion = null;
                if (ConstantUtil.DROP_TYPE == null) {
                    Properties props = new Properties();
                    try {
                        props.load(getClass().getResourceAsStream("/build.properties"));
                        ConstantUtil.DROP_TYPE = props.getProperty("deployType").trim();
                    } catch (IOException ex) {
                        Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
                    }
                }

                user.setTechoPhoneNumber(paramDetailDto.getPhoneNumber());
                user.setImeiNumber(paramDetailDto.getImeiNumber());
                user.setSdkVersion(paramDetailDto.getSdkVersion());
                user.setFreeSpaceMB(paramDetailDto.getFreeSpaceMB());
                user.setLatitude(paramDetailDto.getLatitude());
                user.setLongitude(paramDetailDto.getLongitude());
                userDao.update(user);
                if (paramDetailDto.getInstalledApps() != null && !paramDetailDto.getInstalledApps().isEmpty()) {
                    mobileFhsService.storeUserInstalledAppsInfo(user.getId(),
                            paramDetailDto.getImeiNumber(),
                            paramDetailDto.getInstalledApps()
                    );
                }

                loggedInUserPrincipleDto.setRetrievedListValues(mobileFhsService.retrieveListValues(paramDetailDto.getLastUpdateDateForListValue(), user));
                loggedInUserPrincipleDto.setRetrievedAnnouncements(mobileFhsService.retrieveAnnouncements(user, paramDetailDto.getRoleType(), paramDetailDto.getLastUpdateOfAnnouncements(), user.getPrefferedLanguage()));
                loggedInUserPrincipleDto.setRetrievedLabels(mobileFhsService.retrieveLabels(paramDetailDto.getCreatedOnDateForLabel(), user.getPrefferedLanguage()));
                this.retrieveAssignedFamilies(user, loggedInUserPrincipleDto, paramDetailDto);
                if (paramDetailDto.getUserId() != null) {
                    loggedInUserPrincipleDto.setRetrievedVillageAndChildLocations(this.retrieveVillagesAndChildLocations(paramDetailDto.getUserId()));
                }

                if (paramDetailDto.getLastUpdateDateForNotifications() != null) {
                    List<TechoNotificationDataBean> toBeRemovedNotificationDataBeans = new LinkedList<>();
                    List<TechoNotificationDataBean> updatedNotificationByUser;
                    List<Integer> deletedNotificationIds;
                    deletedNotificationIds = techoNotificationMasterDao.getDeletedNotificationsForUserByLastModifiedOn(
                            userTokenDto.getUserId(),
                            new Date(paramDetailDto.getLastUpdateDateForNotifications()));
                    updatedNotificationByUser = techoNotificationMasterDao.retrieveNotificationsForUserByLastModifiedOn(
                            userTokenDto.getUserId(), userTokenDto.getRoleId(),
                            new Date(paramDetailDto.getLastUpdateDateForNotifications()));
                    for (TechoNotificationDataBean techoNotificationDataBean : updatedNotificationByUser) {
                        if (!techoNotificationDataBean.getState().equals("PENDING")
                                && !techoNotificationDataBean.getState().equals("RESCHEDULE")) {
                            deletedNotificationIds.add(techoNotificationDataBean.getId());
                            toBeRemovedNotificationDataBeans.add(techoNotificationDataBean);
                        }
                    }
                    updatedNotificationByUser.removeAll(toBeRemovedNotificationDataBeans);
                    loggedInUserPrincipleDto.setNotifications(updatedNotificationByUser);
                    loggedInUserPrincipleDto.setDeletedNotifications(deletedNotificationIds);
                } else {
                    loggedInUserPrincipleDto.setNotifications(
                            techoNotificationMasterDao.retrieveAllNotificationsForUser(userTokenDto.getUserId(), userTokenDto.getRoleId()));
                }

                mobileFhsService.getXlsSheetDataForMobile(paramDetailDto.getSheetNameVersionMap(), loggedInUserPrincipleDto);

                loggedInUserPrincipleDto.setMobileLibraryDataBeans(
                        mobileLibraryService.retrieveMobileLibraryDataBeans(
                                user.getRoleId(), paramDetailDto.getLastUpdateDateForLibrary()));

                loggedInUserPrincipleDto.setLocationMasterBeans(
                        mobileFhsService.getLocationMasterDetails(paramDetailDto));

                loggedInUserPrincipleDto.setHealthInfrastructures(
                        mobileFhsService.getHealthInfrastructureDetails(paramDetailDto));

                if (paramDetailDto.getMobileFormVersion() != null) {
                    sheetVersion = paramDetailDto.getMobileFormVersion();
                }
                mobileFhsService.userDataRequestInsertion(user.getId(), apkVersion, paramDetailDto.getImeiNumber(), sheetVersion);

                return loggedInUserPrincipleDto;
            }
        }
        return null;
    }

    private void retrieveAssignedFamilies(UserMaster user, LoggedInUserPrincipleDto loggedInUserPrincipleDto, LogInRequestParamDetailDto logInRequestParamDetailDto) {
        if (user != null) {
            List<FamilyDataBean> familyDataBeans = new LinkedList<>();

            Map<Integer, FamilyEntity> familyMapWithFamilyIdAsKey = new HashMap<>();
            Map<String, List<MemberDataBean>> membersListMapWithFamilyIdAsKey = new HashMap<>();
            Map<String, List<Integer>> locationMap = this.retrieveAreaLocationByUserId(user.getId(), loggedInUserPrincipleDto, null);
            List<Integer> assignedLocationIds = new LinkedList<>();

            if (locationMap.get("OLD") != null) {
                assignedLocationIds.addAll(locationMap.get("OLD"));
            }

            if (CollectionUtils.isEmpty(assignedLocationIds)) {
                loggedInUserPrincipleDto.setAssignedFamilies(null);
                loggedInUserPrincipleDto.setOrphanedAndReverificationFamilies(null);
                return;
            }
            List<String> validStates = new LinkedList<>();
            validStates.addAll(FamilyHealthSurveyServiceConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
            validStates.addAll(FamilyHealthSurveyServiceConstants.FHS_NEW_CRITERIA_FAMILY_STATES);

            Date lastUpdateDateForFamily = null;
            if (logInRequestParamDetailDto.getLastUpdateDateForFamily() != null && !logInRequestParamDetailDto.getLastUpdateDateForFamily().equals("OL")) {
                lastUpdateDateForFamily = new Date(Long.parseLong(logInRequestParamDetailDto.getLastUpdateDateForFamily()));
            }

            for (FamilyEntity family : familyDao.retrieveFamiliesByAreaIds(assignedLocationIds, validStates, lastUpdateDateForFamily)) {
                familyMapWithFamilyIdAsKey.put(family.getId(), family);
            }

            for (MemberEntity member : familyHealthSurveyService.getMembersForAsha(null, null, assignedLocationIds)) {
                List<MemberDataBean> membersList = membersListMapWithFamilyIdAsKey.get(member.getFamilyId());
                if (membersList == null) {
                    membersList = new ArrayList<>();
                }
                membersList.add(MemberDataBeanMapper.convertMemberEntityToMemberDataBean(member));
                membersListMapWithFamilyIdAsKey.put(member.getFamilyId(), membersList);
            }

            for (Map.Entry<Integer, FamilyEntity> entry : familyMapWithFamilyIdAsKey.entrySet()) {
                familyDataBeans.add(FamilyDataBeanMapper.convertFamilyEntityToFamilyDataBean(entry.getValue(), membersListMapWithFamilyIdAsKey.get(entry.getValue().getFamilyId())));
            }

            if (lastUpdateDateForFamily != null) {
                loggedInUserPrincipleDto.setUpdatedFamilyByDate(familyDataBeans);
            } else {
                loggedInUserPrincipleDto.setAssignedFamilies(familyDataBeans);
            }
        }
    }

    public Map<String, List<Integer>> retrieveAreaLocationByUserId(Integer userId, LoggedInUserPrincipleDto loggedInUserPrincipleDto, Date lastUpdatedOn) {
        Map<String, List<Integer>> mapOfLocations = new HashMap<>();
        List<UserLocation> userLocations = userLocationDao.retrieveAllLocationsByUserId(userId);
        List<Integer> alreadyAssignedUserLocations = new LinkedList<>();
        List<Integer> newlyAssignedUserLocations = new LinkedList<>();
        List<Integer> newlyRemovedUserLocations = new LinkedList<>();
        List<String> childLocationTypes = new LinkedList<>();
        if (lastUpdatedOn != null) {
            for (UserLocation userLocation : userLocations) {
                if (userLocation.getModifiedOn().after(lastUpdatedOn) && userLocation.getState().equals(UserLocation.State.ACTIVE)) {
                    newlyAssignedUserLocations.add(userLocation.getLocationId());
                } else if (userLocation.getModifiedOn().after(lastUpdatedOn) && userLocation.getState().equals(UserLocation.State.INACTIVE)) {
                    newlyRemovedUserLocations.add(userLocation.getLocationId());
                } else if (userLocation.getState().equals(UserLocation.State.ACTIVE)) {
                    alreadyAssignedUserLocations.add(userLocation.getLocationId());
                }
            }
        } else {
            for (UserLocation userLocation : userLocations) {
                if (userLocation.getState().equals(UserLocation.State.ACTIVE)) {
                    alreadyAssignedUserLocations.add(userLocation.getLocationId());
                }
            }
        }

        childLocationTypes.add(LocationConstants.LocationType.AREA);
        childLocationTypes.add(LocationConstants.LocationType.ASHA_AREA);
        if (!CollectionUtils.isEmpty(newlyAssignedUserLocations)) {
            mapOfLocations.put("NEW", locationHierchyCloserDetailDao.retrieveChildLocationIdsFromParentList(newlyAssignedUserLocations, childLocationTypes));
        }

        if (!CollectionUtils.isEmpty(alreadyAssignedUserLocations)) {
            mapOfLocations.put("OLD", locationHierchyCloserDetailDao.retrieveChildLocationIdsFromParentList(alreadyAssignedUserLocations, childLocationTypes));
        }

        if (!CollectionUtils.isEmpty(newlyRemovedUserLocations)) {
            loggedInUserPrincipleDto.setLocationsForFamilyDataDeletion(locationHierchyCloserDetailDao.retrieveChildLocationIdsFromParentList(newlyRemovedUserLocations, childLocationTypes));
        }
        return mapOfLocations;
    }

    public Map<Integer, List<SurveyLocationMobDataBean>> retrieveVillagesAndChildLocations(Integer userId) {
        if (userId != null) {
            Map<Integer, List<SurveyLocationMobDataBean>> mapOfLocationsWithParentIdAsKey = new HashMap<>();
            List<SurveyLocationMobDataBean> surveyLocationMobDataBeans = new ArrayList<>(locationMasterDao.retrieveAllAreasAssignedToAshaForMobileByUserId(userId));

            for (SurveyLocationMobDataBean surveyLocationMobDataBean : surveyLocationMobDataBeans) {
                List<SurveyLocationMobDataBean> areas = mapOfLocationsWithParentIdAsKey.get(surveyLocationMobDataBean.getParent());
                if (areas == null) {
                    areas = new ArrayList<>();
                }
                areas.add(surveyLocationMobDataBean);
                mapOfLocationsWithParentIdAsKey.put(surveyLocationMobDataBean.getParent(), areas);
            }
            return mapOfLocationsWithParentIdAsKey;
        } else {
            return null;
        }
    }

}
