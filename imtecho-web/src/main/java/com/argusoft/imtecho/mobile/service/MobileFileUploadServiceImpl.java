package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.chip.service.GbvService;
import com.argusoft.imtecho.common.model.SyncStatusFileUpload;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.service.SyncStatusFileUploadService;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.common.util.ImtechoUtil;
import com.argusoft.imtecho.document.dto.DocumentDto;
import com.argusoft.imtecho.document.service.DocumentService;
import com.argusoft.imtecho.exception.ImtechoUserException;
import com.argusoft.imtecho.mobile.constants.MobileConstantUtil;
import com.argusoft.imtecho.mobile.dto.RecordStatusBean;
import com.argusoft.imtecho.mobile.dto.UploadFileDataBean;
import com.argusoft.imtecho.mobile.service.MobileFileUploadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Date;

@Service
@Transactional
public class MobileFileUploadServiceImpl implements MobileFileUploadService {

    @Autowired
    private UserService userService;
    @Autowired
    private SyncStatusFileUploadService syncStatusFileUploadService;
    @Autowired
    private DocumentService documentService;
    @Autowired
    private GbvService gbvService;

    @Override
    public RecordStatusBean uploadMediaFromMobile(MultipartFile file, UploadFileDataBean uploadFileDataBean) {
        if (file == null || uploadFileDataBean == null) {
            return null;
        }

        if (uploadFileDataBean.getToken() == null) {
            //Need to remove this and throw exception.
            //Keeping this only for supporting older android app version.
            return startFileUploadingProcess(file, uploadFileDataBean);
        }

        UserMaster userMaster = userService.getUserByValidToken(uploadFileDataBean.getToken());
        if (userMaster == null) {
            throw new ImtechoUserException("User token is expired. Please login again", 500);
        }

        return startFileUploadingProcess(file, uploadFileDataBean);
    }

    private RecordStatusBean startFileUploadingProcess(MultipartFile file, UploadFileDataBean uploadFileDataBean) {

        RecordStatusBean recordStatusBean = new RecordStatusBean();
        recordStatusBean.setChecksum(uploadFileDataBean.getCheckSum());
        recordStatusBean.setStatus(MobileConstantUtil.PENDING_VALUE);

        SyncStatusFileUpload syncStatus = syncStatusFileUploadService.retrieveById(uploadFileDataBean.getUniqueId());
        if (syncStatus != null && syncStatus.getStatus().equalsIgnoreCase(MobileConstantUtil.SUCCESS_VALUE)) {
            recordStatusBean.setStatus(MobileConstantUtil.SUCCESS_VALUE);
            return recordStatusBean;
        }
        if (syncStatus == null) {
            syncStatus = new SyncStatusFileUpload();
            syncStatus.setUniqueId(uploadFileDataBean.getUniqueId());
            syncStatus.setFileName(uploadFileDataBean.getFileName());
            syncStatus.setFileType(uploadFileDataBean.getFileType());
            syncStatus.setActionDate(new Date());
            syncStatus.setChecksum(uploadFileDataBean.getCheckSum());
            syncStatus.setParentStatus(uploadFileDataBean.getParentStatus());
            syncStatus.setPath(uploadFileDataBean.getPath());
            syncStatus.setFormType(uploadFileDataBean.getFormType());
            syncStatus.setNoOfAttempt(uploadFileDataBean.getNoOfAttemp());
            if (uploadFileDataBean.getMemberId() != null) {
                syncStatus.setMemberId(Math.toIntExact(uploadFileDataBean.getMemberId()));
            }
            if (uploadFileDataBean.getMemberUuid() != null) {
                syncStatus.setMemberUuid(uploadFileDataBean.getMemberUuid());
            }
            syncStatus.setUserName(uploadFileDataBean.getUserName());
            syncStatus.setToken(uploadFileDataBean.getToken());
            syncStatus.setStatus(MobileConstantUtil.PENDING_VALUE);
            syncStatusFileUploadService.create(syncStatus);
        }
        Integer i = -1;
        try {
            i = submitFileUpload(file, uploadFileDataBean);
        } catch (Exception e) {
            Writer writer = new StringWriter();
            PrintWriter printWriter = new PrintWriter(writer);
            e.printStackTrace(printWriter);
            syncStatus.setException(writer.toString());
        }

        if (i != -1) {
            syncStatus.setStatus(MobileConstantUtil.SUCCESS_VALUE);
            recordStatusBean.setStatus(MobileConstantUtil.SUCCESS_VALUE);
        } else {
            syncStatus.setStatus(MobileConstantUtil.PENDING_VALUE);
            recordStatusBean.setStatus(MobileConstantUtil.PENDING_VALUE);
        }
        syncStatus.setActionDate(new Date());
        syncStatusFileUploadService.update(syncStatus);
        return recordStatusBean;
    }

    private Integer submitFileUpload(MultipartFile file, UploadFileDataBean uploadFileDataBean) {
        DocumentDto documentDto = documentService.uploadFile(file, "TECHO", false);

        switch (uploadFileDataBean.getFormType()) {
            case MobileConstantUtil.CHIP_GBV_SCREENING:
                return gbvService.storeMediaData(documentDto, uploadFileDataBean);
            default:
                ImtechoUtil.printSomething("Inside case DEFAULT");
                return -1;
        }
    }

}
