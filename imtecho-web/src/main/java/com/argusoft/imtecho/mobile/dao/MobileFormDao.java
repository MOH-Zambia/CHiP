package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;

import java.util.List;

public interface MobileFormDao extends GenericDao<SohElementModuleMaster, Integer> {

    List<String> getFileNames();

    List<String> getFileNamesByFeature(Integer roleId);
}
