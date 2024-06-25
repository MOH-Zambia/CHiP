package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.mobile.dao.MobileFormMasterDao;
import com.argusoft.imtecho.mobile.dto.ComponentTagDto;
import com.argusoft.imtecho.mobile.mapper.MobileFormMasterMapper;
import com.argusoft.imtecho.mobile.model.MobileFormMaster;
import com.argusoft.imtecho.mobile.service.MobileFormMasterService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;

@Service
@Transactional
public class MobileFormMasterServiceImpl implements MobileFormMasterService {

    @Autowired
    private MobileFormMasterDao mobileFormMasterDao;

    @Override
    public void createMobileFormMaster(List<ComponentTagDto> dtos, String formName) {
        List<MobileFormMaster> masters = MobileFormMasterMapper.convertComponentTagDtoToMobileFormMaster(dtos, formName);
        mobileFormMasterDao.createOrUpdateAll(masters);
    }

    @Override
    public List<ComponentTagDto> retrieveMobileFormBySheet(String sheet) {
        return mobileFormMasterDao.retrieveComponentTagDtoBySheet(sheet);
    }


}
