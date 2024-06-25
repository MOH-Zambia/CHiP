package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.dao.UserHealthInfrastructureDao;
import com.argusoft.imtecho.common.model.UserHealthInfrastructure;
import com.argusoft.imtecho.common.service.UserHealthInfrastructureService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

@Service
@Transactional
public class UserHealthInfrastructureServiceImpl implements UserHealthInfrastructureService {

    @Autowired
    private UserHealthInfrastructureDao userHealthInfrastructureDao;

    @Override
    public List<UserHealthInfrastructure> retrieveByUserId(Integer userId, Long modifiedOn) {
        Date lastModifiedDate = null;
        if (modifiedOn != null && modifiedOn != 0L) {
            lastModifiedDate = new Date(modifiedOn);
        }
        return userHealthInfrastructureDao.retrieveByUserId(userId, lastModifiedDate);
    }
}
