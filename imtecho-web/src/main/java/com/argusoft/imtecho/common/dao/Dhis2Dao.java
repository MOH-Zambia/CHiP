package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.Dhis2CallLog;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.Date;
import java.util.List;

public interface Dhis2Dao extends GenericDao<Dhis2CallLog,Long> {

    String getData(Date monthEnd, Integer facilityId);

    List<Integer> getEnabledFacilities();
}
