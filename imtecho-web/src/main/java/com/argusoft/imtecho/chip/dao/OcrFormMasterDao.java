package com.argusoft.imtecho.chip.dao;

import com.argusoft.imtecho.chip.model.OcrFormMasterEntity;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.dto.OcrFormDataBean;

import java.util.Date;
import java.util.List;

public interface OcrFormMasterDao extends GenericDao<OcrFormMasterEntity, Integer> {
    List<OcrFormDataBean> retrieveOcrFormBeans(Long userId, Date lastModifiedOn);
}