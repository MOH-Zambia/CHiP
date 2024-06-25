package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.model.FamilyAvailabilityDetail;

import java.util.Date;
import java.util.List;

public interface FamilyAvailabilityDetailDao extends GenericDao<FamilyAvailabilityDetail, Integer> {

    List<FamilyAvailabilityDataBean> getFamilyAvailabilityByModifiedOn(Integer userId, Date modifiedOn);
}
