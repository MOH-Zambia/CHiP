package com.argusoft.imtecho.chip.service;

import com.argusoft.imtecho.mobile.dto.OcrFormDataBean;

import java.util.List;

public interface OcrFormMasterService {
    List<OcrFormDataBean> getOcrFormBeans(int requestedBy, Long lastModifiedOn);
}