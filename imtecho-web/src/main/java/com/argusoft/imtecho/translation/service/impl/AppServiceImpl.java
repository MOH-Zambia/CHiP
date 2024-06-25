package com.argusoft.imtecho.translation.service.impl;

import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.translation.dao.AppDao;
import com.argusoft.imtecho.translation.dto.AppDto;
import com.argusoft.imtecho.translation.mapper.AppMapper;
import com.argusoft.imtecho.translation.model.App;
import com.argusoft.imtecho.translation.service.AppService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collections;
import java.util.List;

@Service
@Transactional
public class AppServiceImpl implements AppService {

    @Autowired
    AppDao appDao;

    @Override
    public void createOrUpdate(AppDto appDto) {
        if (appDto.getId() != null) {
            App existingApp = appDao.retrieveById(appDto.getId());
            if (existingApp != null) {
                App app = AppMapper.convertDtoToMaster(appDto, existingApp);
                appDao.update(app);
            } else {
                throw new ImtechoSystemException("App not found", 500);
            }
        } else {
            App app = AppMapper.convertDtoToMaster(appDto, null);
            appDao.createOrUpdate(app);
        }
    }

    @Override
    public List<App> getAllApp() {
        return appDao.retrieveAll();
    }




}
