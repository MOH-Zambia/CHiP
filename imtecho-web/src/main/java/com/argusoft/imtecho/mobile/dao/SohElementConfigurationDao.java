package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.SohElementConfiguration;

import java.util.List;

public interface SohElementConfigurationDao extends GenericDao<SohElementConfiguration, Integer> {

    List<SohElementConfiguration> getAllElements();

    List<SohElementConfiguration> getAllElementsBasedOnPermission(Integer userId);
}
