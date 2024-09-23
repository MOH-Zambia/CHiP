package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.RecordStatusBean;
import com.argusoft.imtecho.mobile.dto.UploadFileDataBean;
import org.springframework.web.multipart.MultipartFile;

public interface MobileFileUploadService {

    RecordStatusBean uploadMediaFromMobile(MultipartFile file, UploadFileDataBean uploadFileDataBean);

}
