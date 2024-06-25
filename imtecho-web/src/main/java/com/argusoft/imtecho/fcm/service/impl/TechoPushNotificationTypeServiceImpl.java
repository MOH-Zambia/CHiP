package com.argusoft.imtecho.fcm.service.impl;

import com.argusoft.imtecho.document.service.DocumentService;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationTypeDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;
import com.argusoft.imtecho.fcm.service.TechoPushNotificationTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;

/**
 * @author nihar
 * @since 12/10/22 6:01 PM
 */
@Service
@Transactional
public class TechoPushNotificationTypeServiceImpl
        implements TechoPushNotificationTypeService {

    @Autowired
    private TechoPushNotificationTypeDao techoPushNotificationTypeDao;

    @Autowired
    private DocumentService documentService;

    @Override
    public void createOrUpdate(TechoPushNotificationType techoPushNotificationType) {
        techoPushNotificationTypeDao.createOrUpdate(techoPushNotificationType);
    }

    @Override
    public List<TechoPushNotificationType> getNotificationTypeList() {
        return techoPushNotificationTypeDao.retrieveAll();
    }

    @Override
    public boolean checkIfTypeExists(String type) {
        return techoPushNotificationTypeDao.getTechoPushNotificationTypeByType(type) != null;
    }

    @Override
    public TechoPushNotificationType getNotificationTypeById(Integer id) {
        return techoPushNotificationTypeDao.retrieveById(id);
    }

    @Override
    public File getPushNotificationFile(Integer id) throws FileNotFoundException {
        if (techoPushNotificationTypeDao.checkFileExists(id)) {
            return documentService.getFile(Long.parseLong(id.toString()));
        }
        return null;
    }
}
