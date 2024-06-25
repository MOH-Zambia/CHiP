package com.argusoft.imtecho.listvalues.service.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.model.MemberEntity;
import com.argusoft.imtecho.listvalues.dao.ListValueFieldValueDetailDao;
import com.argusoft.imtecho.listvalues.model.ListValueFieldValueDetail;
import com.argusoft.imtecho.listvalues.service.ListValueFieldValueDetailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ListValueFieldValueDetailServiceImpl extends GenericDaoImpl<MemberEntity, Integer> implements ListValueFieldValueDetailService {
    @Autowired
    private ListValueFieldValueDetailDao listValueFieldValueDetailDao;

    public String retrieveValueFromId(Integer id) {
        return listValueFieldValueDetailDao.retrieveValueFromId(id);
    }

    @Override
    public Integer retrieveIdOfListValueByConstant(String constant) {
        return listValueFieldValueDetailDao.retrieveIdFromConstant(constant);
    }
}