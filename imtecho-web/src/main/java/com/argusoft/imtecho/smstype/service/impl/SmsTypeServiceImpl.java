package com.argusoft.imtecho.smstype.service.impl;

import com.argusoft.imtecho.common.service.SmsService;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import com.argusoft.imtecho.smstype.dao.SmsTypeMasterDao;
import com.argusoft.imtecho.smstype.dto.SmsTypeMasterDto;
import com.argusoft.imtecho.smstype.mapper.SmsTypeMapper;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster.State;
import com.argusoft.imtecho.smstype.service.SmsTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

/**
 * <p>
 * Implement methods of sms type service
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:19 PM
 */
@Service
@Transactional
public class SmsTypeServiceImpl implements SmsTypeService {
    @Autowired
    SmsTypeMasterDao smsTypeMasterDao;

    @Autowired
    private SmsService smsService;

    @Autowired
    private ImtechoSecurityUser user;

//    @Override
//    public List<SmsTypeMasterDto> getAllActiveSmsTypes() {
//        List<SmsTypeMaster> smsTypeMasters = smsTypeMasterDao.getAllActiveSmsTypes();
//        return SmsTypeMapper.entityToDtoList(smsTypeMasters);
//    }

    @Override
    public List<SmsTypeMasterDto> getAllSmsTypes() {
        List<SmsTypeMaster> smsTypeMasters = smsTypeMasterDao.retrieveAll();
        return SmsTypeMapper.entityToDtoList(smsTypeMasters);
    }

    @Override
    public void toggleActive(SmsTypeMasterDto smsTypeDto, Boolean isActive) {
        smsTypeDto.setState(Boolean.TRUE.equals(isActive) ? State.INACTIVE : State.ACTIVE);
        updateSmsType(smsTypeDto);
    }

    @Override
    public void create(SmsTypeMasterDto smsTypeMasterDto) {
        SmsTypeMaster smsTypeMaster = SmsTypeMapper.smsTypeDtoToEntity(smsTypeMasterDto);
        smsTypeMaster.setCreatedOn(new Date());
        smsTypeMaster.setCreatedBy(user.getId());
        smsTypeMaster.setModifiedOn(new Date());
        smsTypeMaster.setModifiedBy(user.getId());
        smsTypeMasterDao.create(smsTypeMaster);
        smsService.updateSmsTypeMap(smsTypeMasterDto.getSmsType(), smsTypeMasterDto.getTemplateId(), smsTypeMaster.getState());
    }

    @Override
    public void updateSmsType(SmsTypeMasterDto smsTypeMasterDto) {
        SmsTypeMaster smsTypeMaster = SmsTypeMapper.smsTypeDtoToEntity(smsTypeMasterDto);
        smsTypeMaster.setModifiedOn(new Date());
        smsTypeMaster.setModifiedBy(user.getId());
        smsTypeMasterDao.update(smsTypeMaster);
        smsService.updateSmsTypeMap(smsTypeMaster.getSmsType(), smsTypeMaster.getTemplateId(), smsTypeMaster.getState());
    }

    @Override
    public SmsTypeMasterDto getSmsTypeByType(String type) {
        SmsTypeMaster smsTypeMaster = smsTypeMasterDao.getSmsTypeMasterByType(type);
        return SmsTypeMapper.smsTypeEntityToDto(smsTypeMaster);
    }
}
