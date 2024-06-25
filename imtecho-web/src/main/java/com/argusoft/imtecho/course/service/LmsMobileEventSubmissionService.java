package com.argusoft.imtecho.course.service;

import com.argusoft.imtecho.course.dto.LmsMobileEventDto;
import com.argusoft.imtecho.mobile.dto.RecordStatusBean;

import java.util.List;

public interface LmsMobileEventSubmissionService {

    List<RecordStatusBean> storeLmsMobileEventToDB(String token, List<LmsMobileEventDto> mobileEventDtos);
}
