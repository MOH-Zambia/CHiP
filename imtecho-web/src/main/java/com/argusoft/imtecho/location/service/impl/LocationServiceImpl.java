/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.location.service.impl;

import com.argusoft.imtecho.common.dao.UserLocationDao;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.location.constants.LocationConstants;
import com.argusoft.imtecho.location.dao.*;
import com.argusoft.imtecho.location.dto.*;
import com.argusoft.imtecho.location.mapper.HealthInfrastructureWardDetailsMapper;
import com.argusoft.imtecho.location.mapper.LocationDetailMapper;
import com.argusoft.imtecho.location.mapper.LocationMasterMapper;
import com.argusoft.imtecho.location.model.*;
import com.argusoft.imtecho.location.service.LocationService;
import com.argusoft.imtecho.mobile.dao.LocationMobileFeatureDao;
import com.argusoft.imtecho.mobile.dto.LocationMasterDataBean;
import com.argusoft.imtecho.mobile.model.LocationMobileFeature;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * <p>
 * Define services for location.
 * </p>
 *
 * @author Harshit
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class LocationServiceImpl implements LocationService {

    private static final org.slf4j.Logger LOGGER = LoggerFactory.getLogger(LocationServiceImpl.class);

    @Autowired
    private ImtechoSecurityUser user;
    @Autowired
    private LocationMasterDao locationMasterDao;
    @Autowired
    private UserLocationDao userLocationDao;
    @Autowired
    private LocationLevelHierarchyDao locationLevelHierarchyDao;
    @Autowired
    private LocationHierchyCloserDetailDao locationHierchyCloserDetailDao;
    @Autowired
    private LocationWiseAnalyticsDao locationWiseAnalyticsDao;
    @Autowired
    private LocationMobileFeatureDao locationMobileFeatureDao;
    @Autowired
    private LocationWardsMappingDao locationWardsMappingDao;
    @Autowired
    private HealthInfrastructureWardDetailsDao healthInfrastructureWardDetailsDao;
    @Autowired
    private HealthInfrastructureWardDetailsHisotryDao healthInfrastructureWardDetailsHisotryDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LocationHierchyDto> retrieveLocationHierarchyDetailByCriteria(Integer userId, List<Integer> locationIds, Integer level, Boolean fetchAccordingToUserAOI, String languagePreference) {
        List<LocationMaster> locationMasters = null;
        LocationHierchyDto locationHierchyDto = new LocationHierchyDto();
        List<LocationDetailDto> locationDetailDtos = new LinkedList<>();
        if (Boolean.TRUE.equals(fetchAccordingToUserAOI)) {
            if (locationIds == null) {
                if (level == null) {
                    level = userLocationDao.getUserMinLevel(userId);
                }
                locationMasters = locationMasterDao.retrieveUserLocationByLevel(userId, level);
            } else {
                locationDetailDtos = locationMasterDao.retrieveUserLocationByParentLocation(userId, locationIds, level, languagePreference);
            }
        } else {
            if (level == null) {
                level = 1;
            }
            if (locationIds == null) {
                locationMasters = locationMasterDao.retrieveLocationByLevel(level);
            } else {
                locationDetailDtos = locationMasterDao.retrieveLocationByParentLocation(locationIds, level, languagePreference);

            }
        }
        if (!CollectionUtils.isEmpty(locationMasters)) {
            List<String> locationTypes = new LinkedList<>();
            for (LocationMaster locationMaster : locationMasters) {
                if (!locationTypes.contains(locationMaster.getHierarchyType().getName())) {
                    locationTypes.add(locationMaster.getHierarchyType().getName());
                }
                LocationDetailDto locationDetailDto = new LocationDetailDto();
                locationDetailDto.setId(locationMaster.getId());
                if (ConstantUtil.LAN_EN.equalsIgnoreCase(languagePreference)) {
                    locationDetailDto.setName(locationMaster.getEnglishName());
                } else {
                    locationDetailDto.setName(locationMaster.getName());
                }
                locationDetailDto.setType(locationMaster.getType());
                locationDetailDtos.add(locationDetailDto);
            }
            locationHierchyDto.setLevel(level);
            locationHierchyDto.setLocationDetails(locationDetailDtos);
            locationHierchyDto.setLocationLabel(String.join("/", locationTypes));
            List<LocationHierchyDto> locationHierchyDtos = new LinkedList<>();
            locationHierchyDtos.add(locationHierchyDto);
            return locationHierchyDtos;
        } else if (!CollectionUtils.isEmpty(locationDetailDtos)) {
            List<String> locationTypes = new LinkedList<>();
            for (LocationDetailDto locationDetailDto : locationDetailDtos) {
                if (!locationTypes.contains(locationDetailDto.getLocType())) {
                    locationTypes.add(locationDetailDto.getLocType());
                }
            }
            locationHierchyDto.setLevel(level);
            locationHierchyDto.setLocationDetails(locationDetailDtos);
            locationHierchyDto.setLocationLabel(String.join("/", locationTypes));
            List<LocationHierchyDto> locationHierchyDtos = new LinkedList<>();
            locationHierchyDtos.add(locationHierchyDto);
            return locationHierchyDtos;
        }
        return Collections.emptyList();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LocationDetailDto> getLocationsByIds(Set<Integer> locationIds) {
        return LocationDetailMapper.entityToDtoLocationDetailList(locationMasterDao.getLocationsByIds(new LinkedList<>(locationIds)));
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void createOrUpdate(LocationMasterDto locationMasterDto, Integer userId) {

        LocationMaster locationMaster = null;
        LocationMaster parentLocation = locationMasterDao.retrieveById(locationMasterDto.getParent());

        LocationMaster sameLocationDetail = locationMasterDao.retrieveLocationByParentIdAndName(locationMasterDto.getParent(), locationMasterDto.getName());
        if (sameLocationDetail != null && (locationMasterDto.getId() == null || !locationMasterDto.getId().equals(sameLocationDetail.getId()))) {
            throw new ImtechoUserException(locationMasterDto.getName() + " location already present under parent location " + parentLocation.getName() + ".", 101);
        }

        if (Boolean.FALSE.equals(locationMasterDao.isParentLocationIsCorrect(locationMasterDto.getParent(), locationMasterDto.getType()))) {
            throw new ImtechoSystemException("Parent location is not selected properly.", "locationMaster_Id : " + locationMasterDto.getId()
                    + ",Location Type : " + locationMasterDto.getType()
                    + ",Parent location Id : " + parentLocation.getId()
                    + ",Parent location Type : " + parentLocation.getType(),
                    null);
        }

        if (locationMasterDto.getId() != null) {
            locationMaster = locationMasterDao.retrieveById(locationMasterDto.getId());
        }
        LocationMaster locationMaster1 = LocationMasterMapper.getLocationMasterEntity(locationMasterDto, locationMaster, userId);
        locationMaster1.setParentMaster(parentLocation);
        locationMasterDao.createOrUpdate(locationMaster1);
        LocationMobileFeature retrievedLocationMobileFeature = locationMobileFeatureDao.retrieveByLocationId(locationMaster1.getId());
        if (retrievedLocationMobileFeature != null) {
            if (retrievedLocationMobileFeature.getFeature().equals(ConstantUtil.CEREBRAL_PALSY_SCREENING)) {
                if (Boolean.FALSE.equals(locationMaster1.getCerebralPalsyModule())) {
                    locationMobileFeatureDao.delete(retrievedLocationMobileFeature);
                }
            } else {
                if (Boolean.FALSE.equals(locationMaster1.getGeoFencing())) {
                    locationMobileFeatureDao.delete(retrievedLocationMobileFeature);
                }
            }
        } else {
            if (Boolean.TRUE.equals(locationMaster1.getCerebralPalsyModule())) {
                LocationMobileFeature locationMobileFeature = new LocationMobileFeature();
                locationMobileFeature.setFeature(ConstantUtil.CEREBRAL_PALSY_SCREENING);
                locationMobileFeature.setLocationId(locationMaster1.getId());
                locationMobileFeatureDao.create(locationMobileFeature);
            }
            if (Boolean.TRUE.equals(locationMaster1.getGeoFencing())) {
                LocationMobileFeature locationMobileFeature = new LocationMobileFeature();
                locationMobileFeature.setFeature(ConstantUtil.GEO_FENCING);
                locationMobileFeature.setLocationId(locationMaster1.getId());
                locationMobileFeatureDao.create(locationMobileFeature);
            }
        }

//        LocationLevelHierarchy locationLevelHierarchy = this.createOrUpdateLocationLevelHierarchy(locationMaster1);
//        updateLocationMaster(locationMasterDto, locationLevelHierarchy, locationMaster1);
    }

//    /**
//     * Update location master details.
//     *
//     * @param locationMasterDto      Location master details.
//     * @param locationLevelHierarchy Location hierarchy details.
//     * @param locationMaster1        Location master entity.
//     */
//    private void updateLocationMaster(LocationMasterDto locationMasterDto, LocationLevelHierarchy locationLevelHierarchy,
//                                      LocationMaster locationMaster1) {
//        if (locationMasterDto.getId() == null) {
//            locationMaster1.setLocationHierarchy(locationLevelHierarchy);
//            locationMasterDao.update(locationMaster1);
//        }
//    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LocationMasterDto> retrieveChildLocationsByLocationId(Integer locationId) {
        List<LocationMaster> childLocationMasters = locationMasterDao.retrieveLocationByParentLocation(locationId);
        List<LocationMasterDto> childLocationMasterDtos = LocationMasterMapper.getLocationMasterDtoList(childLocationMasters);
        String parentString;
        if (locationId == -1) {
            parentString = "Gujarat";
        } else {
            parentString = locationHierchyCloserDetailDao.getLocationHierarchyStringByLocationId(locationId);
        }
        for (LocationMasterDto locationMasterDto : childLocationMasterDtos) {
            locationMasterDto.setLocationHierarchy(parentString.concat(">").concat(locationMasterDto.getName()));
        }
        return childLocationMasterDtos;
    }

    private LocationLevelHierarchy createOrUpdateLocationLevelHierarchy(LocationMaster locationMaster) {
        LocationLevelHierarchy locationLevelHierarchy;
        List<Integer> locationIds = locationHierchyCloserDetailDao.getParentLocationIds(locationMaster.getParent());
        if (locationMaster.getLocationHierarchyId() == null) {
            locationLevelHierarchy = new LocationLevelHierarchy();
            locationLevelHierarchy.setLocationId(locationMaster.getId());
            locationLevelHierarchy.setIsActive(true);
            locationLevelHierarchy.setLocationType(locationMaster.getType());
        } else {
            locationLevelHierarchy = locationMaster.getLocationHierarchy();
        }
        if (locationIds != null) {
            int i;
            int level;
            String propertyName;
            String setterName;
            for (i = locationIds.size() - 1, level = 1; i >= 0; i--, level++) {
                propertyName = "level" + level;
                setterName = "set" + propertyName.substring(0, 1).toUpperCase() + propertyName.substring(1);
                try {
                    locationLevelHierarchy.getClass().getMethod(setterName, Integer.class).invoke(locationLevelHierarchy, locationIds.get(i));
                } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException |
                         InvocationTargetException ex) {
                    Logger.getLogger(LocationServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
            level++;
            propertyName = "level" + level;
            setterName = "set" + propertyName.substring(0, 1).toUpperCase() + propertyName.substring(1);
            try {
                locationLevelHierarchy.getClass().getMethod(setterName, Integer.class).invoke(locationLevelHierarchy, locationMaster.getId());
            } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException |
                     InvocationTargetException ex) {
                Logger.getLogger(LocationServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        locationLevelHierarchyDao.createOrUpdate(locationLevelHierarchy);
        return locationLevelHierarchy;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public LocationMasterDto retrieveById(Integer id) {
        List<LocationMasterDto> result = LocationMasterMapper.getLocationMasterDtoList(Arrays.asList(locationMasterDao.retrieveById(id)));
        if (!result.isEmpty()) {
            return result.get(0);
        }
        return new LocationMasterDto();
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateAllActiveLocationsWithWorkerInfo() {
        LOGGER.info("Updating Cache Of Location Master Beans For Mobile");
        List<LocationMasterDataBean> allLocations = locationMasterDao.retrieveAllActiveLocationsWithWorkerInfo(null);
        LocationConstants.allLocationMasterDataBeans = allLocations;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public LocationMasterDto retrieveLocationHierarchyById(Integer locationId) {
        LocationMasterDto locationMasterDto = new LocationMasterDto();
        locationMasterDto.setName(locationMasterDao.retrieveLocationHierarchyById(locationId));
        locationMasterDto.setId(locationId);
        return locationMasterDto;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public LocationMasterDto retrieveEngLocationHierarchyById(Integer locationId) {
        LocationMasterDto locationMasterDto = new LocationMasterDto();
        locationMasterDto.setName(locationMasterDao.retrieveEngLocationHierarchyById(locationId));
        locationMasterDto.setId(locationId);
        return locationMasterDto;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LocationMaster> getLocationsByLocationType(List<String> locationLevel, Boolean isActive) {
        return locationMasterDao.getLocationsByLocationType(locationLevel, isActive);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LocationMaster> getAllLocationsOfGujarat() {
        List<Integer> parentIds = new LinkedList<>();
        List<String> childLocationsType = new LinkedList<>();
        childLocationsType.add(LocationConstants.LocationType.STATE);
        childLocationsType.add(LocationConstants.LocationType.DISTRICT);
        childLocationsType.add(LocationConstants.LocationType.CORPORATION);
        childLocationsType.add(LocationConstants.LocationType.BLOCK);
        childLocationsType.add(LocationConstants.LocationType.ZONE);
        childLocationsType.add(LocationConstants.LocationType.PHC);
        childLocationsType.add(LocationConstants.LocationType.UHC);
        childLocationsType.add(LocationConstants.LocationType.SUBCENTER);
        childLocationsType.add(LocationConstants.LocationType.ANM_AREA);
        childLocationsType.add(LocationConstants.LocationType.VILLAGE);
        childLocationsType.add(LocationConstants.LocationType.ANGANWADI_AREA);
        parentIds.add(2);
        return locationMasterDao.retrieveLocationsByParentIdAndType(parentIds, childLocationsType);
    }

    @Override
    public List<LocationMaster> getAllLocationsOfState() {
        List<Integer> parentIds = new LinkedList<>();
        List<String> childLocationsType = new LinkedList<>();
        childLocationsType.add(LocationConstants.LocationType.STATE);
        childLocationsType.add(LocationConstants.LocationType.DISTRICT);
        childLocationsType.add(LocationConstants.LocationType.CORPORATION);
        childLocationsType.add(LocationConstants.LocationType.BLOCK);
        childLocationsType.add(LocationConstants.LocationType.ZONE);
        childLocationsType.add(LocationConstants.LocationType.PHC);
        childLocationsType.add(LocationConstants.LocationType.UHC);
        childLocationsType.add(LocationConstants.LocationType.SUBCENTER);
        childLocationsType.add(LocationConstants.LocationType.ANM_AREA);
        childLocationsType.add(LocationConstants.LocationType.VILLAGE);
        childLocationsType.add(LocationConstants.LocationType.ANGANWADI_AREA);

        List<Integer> stateLocations=locationMasterDao.getParentStateLevelLocationId();
        Integer stateLocation;
        if(stateLocations.size()>=0){
            stateLocation=stateLocations.get(0);
        }else{
            stateLocation = 556188;
        }
        parentIds.add(stateLocation);
        return locationMasterDao.retrieveLocationsByParentIdAndType(parentIds, childLocationsType);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public LocationDetailDto retrieveParentLocationDetail(Integer locationId, String languagePreference) {
        return locationMasterDao.getParentLocationDetail(locationId, languagePreference);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void createWardUphcMapping(List<LocationWardsMapping> locationWardsMappings) {
        if (CollectionUtils.isEmpty(locationWardsMappings)) {
            return;
        }
        for (LocationWardsMapping locationWardsMapping : locationWardsMappings) {
            locationWardsMappingDao.create(locationWardsMapping);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void updateWardUphcMapping(Integer wardId, List<LocationWardsMapping> locationWardsMappings) {
        locationWardsMappingDao.deleteByWardId(wardId);
        if (CollectionUtils.isEmpty(locationWardsMappings)) {
            return;
        }
        for (LocationWardsMapping locationWardsMapping : locationWardsMappings) {
            locationWardsMappingDao.create(locationWardsMapping);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void createOrUpdateHospitalWardDetails(HealthInfrastructureWardDetailsPayloadDto healthInfrastructureWardDetailsPayloadDto) {
        List<HealthInfrastructureWardDetails> healthInfrastructureWardDetails = new ArrayList<>();
        List<HealthInfrastructureWardDetailsHistory> healthInfrastructureWardDetailsHistories = new ArrayList<>();
        if (CollectionUtils.isEmpty(healthInfrastructureWardDetailsPayloadDto.getHealthInfrastructureWardDetails())) {
            return;
        }
        for (HealthInfrastructureWardDetailsDto healthInfrastructureWardDetailsDto : healthInfrastructureWardDetailsPayloadDto.getHealthInfrastructureWardDetails()) {
            healthInfrastructureWardDetailsDto.setHealthInfraId(healthInfrastructureWardDetailsPayloadDto.getHealthInfraId());
            healthInfrastructureWardDetails.add(HealthInfrastructureWardDetailsMapper.dtoToEntity(healthInfrastructureWardDetailsDto, user.getId()));
        }
        for (HealthInfrastructureWardDetails healthInfrastructureWardDetail : healthInfrastructureWardDetails) {
            if (healthInfrastructureWardDetail.getId() == null) {
                Integer id = healthInfrastructureWardDetailsDao.create(healthInfrastructureWardDetail);
                healthInfrastructureWardDetailsHistories.add(HealthInfrastructureWardDetailsMapper.entityToHistoryEntity(healthInfrastructureWardDetail, id, user.getId(), "CREATE"));
            } else {
                healthInfrastructureWardDetailsDao.update(healthInfrastructureWardDetail);
                healthInfrastructureWardDetailsHistories.add(HealthInfrastructureWardDetailsMapper.entityToHistoryEntity(healthInfrastructureWardDetail, healthInfrastructureWardDetail.getId(), user.getId(), "UPDATE"));
            }
        }
        for (HealthInfrastructureWardDetailsHistory healthInfrastructureWardDetailsHistory : healthInfrastructureWardDetailsHistories) {
            healthInfrastructureWardDetailsHisotryDao.create(healthInfrastructureWardDetailsHistory);
        }
    }
}
