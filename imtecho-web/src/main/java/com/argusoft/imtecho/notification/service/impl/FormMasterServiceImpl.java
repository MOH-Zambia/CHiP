/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.notification.service.impl;

import com.argusoft.imtecho.notification.dao.FormMasterDao;
import com.argusoft.imtecho.notification.dto.FormMasterDto;
import com.argusoft.imtecho.notification.mapper.FormMasterMapper;
import com.argusoft.imtecho.notification.service.FormMasterService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * <p>
 *     Define services for form master.
 * </p>
 * @author vaishali
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class FormMasterServiceImpl implements FormMasterService {

    @Autowired
    FormMasterDao formMasterDao;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<FormMasterDto> retrieveAll(Boolean isActive) {
        return FormMasterMapper.convertListMasterToDtoList(formMasterDao.retrieveAll(isActive));
    }

}
