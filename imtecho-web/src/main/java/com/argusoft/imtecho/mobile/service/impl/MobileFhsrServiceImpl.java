package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dao.UserTokenDao;
import com.argusoft.imtecho.common.dto.UserTokenDto;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.dashboard.fhs.constants.FamilyHealthSurveyServiceConstants;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.argusoft.imtecho.fhs.dao.MemberDao;
import com.argusoft.imtecho.fhs.model.FamilyEntity;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.location.dao.LocationHierchyCloserDetailDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.mobile.dto.FamilyDataBean;
import com.argusoft.imtecho.mobile.dto.LogInRequestParamDetailDto;
import com.argusoft.imtecho.mobile.dto.LoggedInUserPrincipleDto;
import com.argusoft.imtecho.mobile.dto.MemberDataBean;
import com.argusoft.imtecho.mobile.dto.SurveyLocationMobDataBean;
import com.argusoft.imtecho.mobile.mapper.FamilyDataBeanMapper;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import com.argusoft.imtecho.mobile.service.MobileFhsrService;
import com.argusoft.imtecho.mobile.service.MobileLibraryService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author prateek on Jul 11, 2019
 */
@Service
@Transactional
public class MobileFhsrServiceImpl implements MobileFhsrService {

    @Autowired
    private UserTokenDao userTokenDao;

    @Autowired
    private MobileFhsService mobileFhsService;

    @Autowired
    private MobileLibraryService mobileLibraryService;

    @Autowired
    private UserDao userDao;

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private FamilyDao familyDao;

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private LocationHierchyCloserDetailDao locationHierchyCloserDetailDao;

    @Override
    public LoggedInUserPrincipleDto getDetailsForFhsr(LogInRequestParamDetailDto paramDetailDto, Integer apkVersion) {

        if (ConstantUtil.DROP_TYPE == null) {
            Properties props = new Properties();
            try {
                props.load(getClass().getResourceAsStream("/build.properties"));
                ConstantUtil.DROP_TYPE = props.getProperty("deployType").trim();
            } catch (IOException ex) {
                Logger.getLogger(getClass().getName()).log(Level.SEVERE, null, ex);
            }
        }

        UserTokenDto userTokenDto = userTokenDao.retrieveDtoByUserToken(paramDetailDto.getToken());
        if (userTokenDto != null) {
            UserMaster user = mobileFhsService.isUserTokenValid(userTokenDto.getUserToken());
            if (user != null) {

                Integer sheetVersion = null;
                user.setTechoPhoneNumber(paramDetailDto.getPhoneNumber());
                user.setImeiNumber(paramDetailDto.getImeiNumber());
                user.setSdkVersion(paramDetailDto.getSdkVersion());
                user.setFreeSpaceMB(paramDetailDto.getFreeSpaceMB());
                if (paramDetailDto.getLatitude() != null && paramDetailDto.getLongitude() != null) {
                    user.setLatitude(paramDetailDto.getLatitude());
                    user.setLongitude(paramDetailDto.getLongitude());
                }
                userDao.update(user);

                if (paramDetailDto.getInstalledApps() != null && !paramDetailDto.getInstalledApps().isEmpty()) {
                    mobileFhsService.storeUserInstalledAppsInfo(user.getId(),
                            paramDetailDto.getImeiNumber(),
                            paramDetailDto.getInstalledApps()
                    );
                }

                LoggedInUserPrincipleDto loggedInUserPrincipleDto = new LoggedInUserPrincipleDto();

                if (paramDetailDto.getUserId() != null) {
                    loggedInUserPrincipleDto.setRetrievedVillageAndChildLocations(
                            this.retrievePhcAndChildLocations(
                                    paramDetailDto.getUserId()));
                }

                loggedInUserPrincipleDto.setMobileLibraryDataBeans(
                        mobileLibraryService.retrieveMobileLibraryDataBeans(
                                user.getRoleId(),
                                paramDetailDto.getLastUpdateDateForLibrary())
                );

                if (user.getPrefferedLanguage() != null) {
                    loggedInUserPrincipleDto.setRetrievedLabels(
                            mobileFhsService.retrieveLabels(
                                    paramDetailDto.getCreatedOnDateForLabel(),
                                    user.getPrefferedLanguage()));
                }

                loggedInUserPrincipleDto.setRetrievedListValues(
                        mobileFhsService.retrieveListValues(
                                paramDetailDto.getLastUpdateDateForListValue(),
                                user));

                loggedInUserPrincipleDto.setRetrievedAnnouncements(
                        mobileFhsService.retrieveAnnouncements(
                                user,
                                paramDetailDto.getRoleType(),
                                paramDetailDto.getLastUpdateOfAnnouncements(),
                                user.getPrefferedLanguage()));

                loggedInUserPrincipleDto.setLocationMasterBeans(
                        mobileFhsService.getLocationMasterDetails(paramDetailDto));

                loggedInUserPrincipleDto.setHealthInfrastructures(
                        mobileFhsService.getHealthInfrastructureDetails(paramDetailDto));

                if (paramDetailDto.getMobileFormVersion() != null) {
                    sheetVersion = paramDetailDto.getMobileFormVersion();
                }
                // make entry in user data access request table
                mobileFhsService.userDataRequestInsertion(user.getId(), apkVersion, paramDetailDto.getImeiNumber(), sheetVersion);
                return loggedInUserPrincipleDto;
            }
        }
        return null;
    }

    private Map<Integer, List<SurveyLocationMobDataBean>> retrievePhcAndChildLocations(Integer userId) {
        if (userId != null) {
            Map<Integer, List<SurveyLocationMobDataBean>> mapOfLocationsWithParentIdAsKey = new HashMap<>();
            List<SurveyLocationMobDataBean> surveyLocationMobDataBeans = new ArrayList<>(locationMasterDao.retrieveAllLocationsAssignedToFhsrForMobileByUserId(userId));

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

    @Override
    public List<FamilyDataBean> retrieveAssignedFamiliesByLocationId(LogInRequestParamDetailDto logInRequestParamDetailDto) {
        UserTokenDto userTokenDto = userTokenDao.retrieveDtoByUserToken(logInRequestParamDetailDto.getToken());
        if (userTokenDto != null) {
            UserMaster user = mobileFhsService.isUserTokenValid(userTokenDto.getUserToken());
            if (user != null) {
                List<FamilyDataBean> familyDataBeans = new LinkedList<>();
                Integer locationId = logInRequestParamDetailDto.getLocationId();
                String lastUpdateDate = logInRequestParamDetailDto.getLastUpdateDateForFamily();

                List<String> validStates = new LinkedList<>();
                validStates.addAll(FamilyHealthSurveyServiceConstants.FHS_VERIFIED_CRITERIA_FAMILY_STATES);
                validStates.addAll(FamilyHealthSurveyServiceConstants.FHS_NEW_CRITERIA_FAMILY_STATES);

                List<Integer> locationIds = locationHierchyCloserDetailDao.retrieveChildLocationIds(locationId);
                Map<Integer, FamilyEntity> familyMapWithFamilyIdAsKey = new HashMap<>();

                List<FamilyEntity> families;
                if (lastUpdateDate != null && !lastUpdateDate.equals("0") && !lastUpdateDate.equals("0L")) {
                    families = familyDao.getFamilies(null, null, locationIds, validStates, new Date(Long.parseLong(lastUpdateDate)));
                } else {
                    families = familyDao.getFamilies(null, null, locationIds, validStates, null);
                }

                List<String> familyIds = new ArrayList<>();
                for (FamilyEntity family : families) {
                    familyMapWithFamilyIdAsKey.put(family.getId(), family);
                    familyIds.add(family.getFamilyId());
                }

                Map<String, List<MemberDataBean>> membersListMapWithFamilyIdAsKey = new HashMap<>();
                for (MemberEntity memberEntity : memberDao.retrieveMembersByFamilyList(familyIds)) {
                    List<MemberDataBean> membersList = membersListMapWithFamilyIdAsKey.get(memberEntity.getFamilyId());
                    if (membersList == null) {
                        membersList = new ArrayList<>();
                    }
                    membersList.add(MemberDataBeanMapper.convertMemberEntityToMemberDataBean(memberEntity));
                    membersListMapWithFamilyIdAsKey.put(memberEntity.getFamilyId(), membersList);
                }

                for (Map.Entry<Integer, FamilyEntity> entry1 : familyMapWithFamilyIdAsKey.entrySet()) {
                    familyDataBeans.add(
                            FamilyDataBeanMapper.convertFamilyEntityToFamilyDataBean(
                                    entry1.getValue(), membersListMapWithFamilyIdAsKey.get(entry1.getValue().getFamilyId())
                            )
                    );
                }
                return familyDataBeans;
            }
        }
        return new ArrayList<>();
    }
}
