package com.argusoft.imtecho.chip.service.impl;

import com.argusoft.imtecho.chip.dao.OcrFormMasterDao;
import com.argusoft.imtecho.chip.service.OcrFormMasterService;
import com.argusoft.imtecho.mobile.dto.OcrFormDataBean;
import org.json.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
@Transactional
public class OcrFormMasterServiceImpl implements OcrFormMasterService {

    @Autowired
    private OcrFormMasterDao ocrFormMasterDao;

    @Override
    public List<OcrFormDataBean> getOcrFormBeans(int requestedBy, Long lastModifiedOn) {
        Date modifiedOn = null;
        if (lastModifiedOn != null) {
            modifiedOn = new Date(lastModifiedOn);
        }
        return ocrFormMasterDao.retrieveOcrFormBeans((long) requestedBy, modifiedOn);
    }
}