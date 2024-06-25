package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * <p>
 *     Defines methods for MobileBeanMasterDao
 * </p>
 *
 * @author rahul
 * @since 21/05/21 3:30 PM
 */
public interface MobileBeanMasterDao extends GenericDao<SohElementModuleMaster, Integer> {

    /**
     * return list of beans for role
     * @param roleId user role id
     * @param dependsOnLastSync is depends on last sync time
     * @return list of string
     */
    List<String> retrieveBeansListForUserRole(Integer roleId, Boolean dependsOnLastSync);

    List<LinkedHashMap<String, Object>> retrieveAllBeansForUserRole(Integer roleId, Boolean dependsOnLastSync);
}
