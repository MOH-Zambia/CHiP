/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.common.service.impl;

import com.argusoft.imtecho.common.service.ThirdPartyApiRequestLogService;
import com.argusoft.imtecho.common.model.ThirdPartyRequestLogModel;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.argusoft.imtecho.common.dao.ThirdPartyRequestLogDao;
import com.argusoft.imtecho.common.dto.ThirdPartyApiRequestLogDto;
import com.argusoft.imtecho.common.mapper.ThirdPartyApiRequestLogMapper;

/**
 *
 * <p>
 * Defines service logic for ThirdPartyRequestLog
 * </p>
 *
 * @author ashish
 * @since 02/09/2020 04:40
 *
 */
@Service
@Transactional
public class ThirdPartyApiRequestLogServiceImpl implements ThirdPartyApiRequestLogService {

    @Autowired
    private ThirdPartyRequestLogDao thirdPartyRequestLogDao;

    /**
        {@inheritDoc }
     */
    @Override
    public Integer insertRequestLogForThirdPartyAPI(ThirdPartyApiRequestLogDto dto) {
        ThirdPartyRequestLogModel model = ThirdPartyApiRequestLogMapper.convertDtoToModel(dto);
        return thirdPartyRequestLogDao.create(model);
    }

}
