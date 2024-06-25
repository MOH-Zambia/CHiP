package com.argusoft.imtecho.listvalues.service.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.service.SystemConfigurationService;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.SystemConstantUtil;
import com.argusoft.imtecho.document.dto.DocumentDto;
import com.argusoft.imtecho.document.service.DocumentService;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dao.MobileLibraryDao;
import com.argusoft.imtecho.mobile.dto.RecordStatusBean;
import com.argusoft.imtecho.mobile.dto.UploadFileDataBean;
import com.argusoft.imtecho.mobile.model.MobileLibraryMaster;
import com.argusoft.imtecho.mobile.model.SyncStatus;
import com.argusoft.imtecho.mobile.service.MobileUtilService;
import com.argusoft.imtecho.query.service.QueryMasterService;
import com.argusoft.imtecho.listvalues.service.UploadMultimediaService;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Date;
import java.util.Objects;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * <p>
 * Define all services for upload media.
 * </p>
 *
 * @author vaishali
 * @since 26/08/20 11:00 AM
 */
@Service
@Transactional
public class UploadMultimediaServiceImpl implements UploadMultimediaService {

    public static final String USER_HOME = "user.home";
    private static final Logger log = LoggerFactory.getLogger(UploadMultimediaServiceImpl.class);
    @Autowired
    QueryMasterService queryMasterService;
    @Autowired
    private MobileLibraryDao mobileLibraryDao;
    @Autowired
    private SystemConfigurationService systemConfigurationService;
    @Autowired
    private DocumentService documentService;

    @Autowired
    private UserService userService;
    @Autowired
    private MobileUtilService mobileUtilService;
    /**
     * {@inheritDoc}
     */
    @Override
    public String uploadFile(MultipartFile[] file) {

        String fileName = file[0].getOriginalFilename();
        String filePath = Objects.requireNonNullElseGet(ConstantUtil.REPOSITORY_PATH, () -> System.getProperty(USER_HOME) + "/Repository/");

        try (FileOutputStream outputStream = new FileOutputStream(new File(filePath  + fileName))) {
            outputStream.write(file[0].getBytes());
        } catch (IOException e) {
            log.error(e.getMessage(), e);
        }

        return fileName;


    }

    /**
     * {@inheritDoc}
     */
    @Override
    public FileSystemResource getFileById(String fileName) throws FileNotFoundException {
        String rootPath;

        rootPath = Objects.requireNonNullElseGet(ConstantUtil.REPOSITORY_PATH, () -> System.getProperty(USER_HOME) + "/Repository/");

        if (fileName.contains("Announcement")) {
            rootPath = rootPath + "Announcement/";
        }

        File file = new File(rootPath, fileName);
        if (!file.exists()) {
            log.error("File not found with name : {} at path: {} ", fileName, rootPath);
            return null;
        }
        return new FileSystemResource(file);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public File getLibraryFileById(Integer id) throws FileNotFoundException {
        MobileLibraryMaster mobileLibraryMaster = mobileLibraryDao.retrieveById(id);
        if (mobileLibraryMaster == null) {
            return null;
        }
        return getLibraryFileByName(mobileLibraryMaster.getFileName());
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public File getLibraryFileByName(String fileName) throws FileNotFoundException {
        String rootPath;

        rootPath = Objects.requireNonNullElseGet(ConstantUtil.REPOSITORY_PATH, () -> System.getProperty(USER_HOME) + "/Repository/");

        rootPath = rootPath + "Library/";
        File file = new File(rootPath, fileName);
        if (!file.exists()) {
            log.error("File not found with name : {} at path: {} ", fileName, rootPath);
            return null;
        } else {
            return file;
        }
    }

//    @Override
//    public RecordStatusBean uploadMedia(MultipartFile file, UploadFileDataBean uploadFileDataBean) {
//        if (file == null || uploadFileDataBean == null) return null;
//        RecordStatusBean recordStatusBean = null;
//        if(uploadFileDataBean.getToken() != null){
//            UserMaster userMaster = userService.getUserByValidToken( uploadFileDataBean.getToken());
//            if(userMaster != null){
//                SyncStatus syncStatus = mobileUtilService.retrieveSyncStatusById(uploadFileDataBean.getUniqueId());
//                if(syncStatus != null && syncStatus.getStatus().equals(MobileConstantUtil.SUCCESS_VALUE)){
//                    recordStatusBean = new RecordStatusBean();
//                    recordStatusBean.setChecksum(uploadFileDataBean.getCheckSum());
//                    recordStatusBean.setStatus(MobileConstantUtil.SUCCESS_VALUE);
//                } else {
//                    DocumentDto documentDto = documentService.uploadFile(file,"TECHO", false);
//                    if (documentDto != null) {
//                        switch (uploadFileDataBean.getFormType()) {
//                            case MobileConstantUtil.NCD_ECG_REPORT:
//                            case MobileConstantUtil.NCD_MO_CONFIRMED:
//                            case MobileConstantUtil.SICKLE_CELL_SURVEY:
//                            case SystemConstantUtil.HU_FOLLOW_UP:
//                                recordStatusBean = ncdService.storeMediaData(documentDto, uploadFileDataBean);
//                                if(syncStatus == null){
//                                    syncStatus = new SyncStatus();
//                                    syncStatus.setDevice(MobileConstantUtil.ANDROID);
//                                    syncStatus.setId(uploadFileDataBean.getUniqueId());
//                                    syncStatus.setActionDate(new Date());
//                                    syncStatus.setStatus(recordStatusBean.getStatus());
//                                    syncStatus.setRecordString(uploadFileDataBean.getFileName());
//                                    syncStatus.setUserId(userMaster.getId());
//                                    mobileUtilService.createSyncStatus(syncStatus);
//                                }else {
//                                    syncStatus.setStatus(recordStatusBean.getStatus());
//                                    mobileUtilService.updateSyncStatus(syncStatus);
//                                }
//                                break;
//                            default:
//                        }
//                    }
//                }
//
//            }else{
//                throw new ImtechoUserException("Invalid User",500);
//            }
//        }
//        return recordStatusBean;
//    }

}

