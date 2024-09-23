package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.document.dto.DocumentDto;
import com.argusoft.imtecho.mobile.dto.ParsedRecordBean;
import com.argusoft.imtecho.mobile.dto.UploadFileDataBean;

import java.util.Map;

public interface GbvService {
    public Integer storeGbvForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    public Integer storeGbvOcrForm(ParsedRecordBean parsedRecordBean, UserMaster user, Map<String, String> keyAndAnswerMap);

    Integer storeMediaData(DocumentDto documentDto, UploadFileDataBean uploadFileDataBean);

}
