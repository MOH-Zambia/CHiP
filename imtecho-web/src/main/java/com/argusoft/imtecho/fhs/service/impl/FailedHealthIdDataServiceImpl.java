/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.service.impl;

import com.argusoft.imtecho.fhs.dao.FailedHealthIdDataDao;
import com.argusoft.imtecho.fhs.model.FailedHealthIdDataEntity;
import com.argusoft.imtecho.fhs.service.FailedHealthIdDataService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@Transactional
public class FailedHealthIdDataServiceImpl implements FailedHealthIdDataService {

    @Autowired
    private FailedHealthIdDataDao failedHealthIdDataDao;

    @Override
    public void failedHealthIdData(FailedHealthIdDataEntity failedHealthIdDataEntity) {
        failedHealthIdDataDao.createFailedHealthIdData(failedHealthIdDataEntity);
    }
}
