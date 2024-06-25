package com.argusoft.imtecho.listvalues.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.listvalues.model.ListValueFieldValueDetail;

public interface ListValueFieldValueDetailDao extends GenericDao<ListValueFieldValueDetail, Integer> {
    String retrieveValueFromId(Integer id);
    Integer retrieveIdFromConstant(String constant);
}