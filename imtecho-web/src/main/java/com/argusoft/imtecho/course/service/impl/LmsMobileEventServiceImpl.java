package com.argusoft.imtecho.course.service.impl;

import com.argusoft.imtecho.course.dao.LmsMobileEventDao;
import com.argusoft.imtecho.course.model.LmsMobileEventMaster;
import com.argusoft.imtecho.course.service.LmsMobileEventService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@Transactional
public class LmsMobileEventServiceImpl implements LmsMobileEventService {

    @Autowired
    private LmsMobileEventDao mobileEventDao;

    @Override
    public LmsMobileEventMaster retrieveMobileEventMaster(String checksum) {
        return mobileEventDao.retrieveById(checksum);
    }

    @Override
    public void createOrUpdateLmsMobileEventMaster(LmsMobileEventMaster lmsMobileEventMaster) {
        mobileEventDao.createOrUpdate(lmsMobileEventMaster);
    }
}
