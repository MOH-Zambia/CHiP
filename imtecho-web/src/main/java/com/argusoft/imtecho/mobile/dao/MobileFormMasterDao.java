package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.dto.ComponentTagDto;
import com.argusoft.imtecho.mobile.model.MobileFormMaster;

import java.util.List;

public interface MobileFormMasterDao extends GenericDao<MobileFormMaster, Integer> {

    List<ComponentTagDto> retrieveComponentTagDtoBySheet(String sheet);
}
