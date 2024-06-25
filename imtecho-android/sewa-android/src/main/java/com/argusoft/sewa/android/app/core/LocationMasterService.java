package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.LocationMasterBean;

import java.util.List;
import java.util.Map;

public interface LocationMasterService {

    void clearLocationMasterTable();

    Integer getLocationLevelByType(String type);

    LocationMasterBean getLocationMasterBeanByActualId(Integer actualId);

    List<LocationMasterBean> retrieveLocationMasterBeansByLevelAndParent(Integer level, Long parent);

    List<LocationBean> retrieveLocationBeansByLevelAndParent(Integer level, Long parent);

    List<LocationBean> retrieveSubCenterListForFHSR();

    String retrieveLocationHierarchyByLocationId(Long locationId);

    LocationBean getLocationBeanByActualId(String actualId);

    String getLocationTypeNameByType(String type);

    List<LocationMasterBean> retrieveLocationMastersAssignedToUser();

    List<LocationMasterBean> getLocationWithNoParent();

    List<LocationMasterBean> retrieveLocationMasterBeansBySearchAndType(CharSequence s, List<String> types);

    Map<Integer, String> retrieveHierarchyMapWithLocation(LocationMasterBean locationMasterBean);

    List<LocationMasterBean> retrieveLocationMasterBeansByParent(Integer parent);

    List<LocationMasterBean> retrieveLocationMasterBeansByParentList(List<Integer> parentList);
    List<Integer> getLocationIdsInsideDistrictOfUser();
    LocationMasterBean getPhcLocationFromSelectedLocationId(Integer locationId);
}
