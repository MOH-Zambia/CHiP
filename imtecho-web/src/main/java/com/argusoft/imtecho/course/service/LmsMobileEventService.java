package com.argusoft.imtecho.course.service;

import com.argusoft.imtecho.course.model.LmsMobileEventMaster;

public interface LmsMobileEventService {

    LmsMobileEventMaster retrieveMobileEventMaster(String checksum);

    void createOrUpdateLmsMobileEventMaster(LmsMobileEventMaster lmsMobileEventMaster);
}
