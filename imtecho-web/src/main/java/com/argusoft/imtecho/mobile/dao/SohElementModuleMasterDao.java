package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;

import java.util.List;

public interface SohElementModuleMasterDao extends GenericDao<SohElementModuleMaster, Integer> {

    List<SohElementModuleMaster> getAllModules(Boolean retrieveActiveOnly);
}
