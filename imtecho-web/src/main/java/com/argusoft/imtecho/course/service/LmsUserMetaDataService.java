package com.argusoft.imtecho.course.service;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.course.dto.LmsMobileEventDto;

public interface LmsUserMetaDataService {

    Integer storeLmsLessonStartDate(UserMaster user, LmsMobileEventDto dto);

    Integer storeLmsLessonEndDate(UserMaster user, LmsMobileEventDto dto);

    Integer storeLmsLessonSession(UserMaster user, LmsMobileEventDto dto);

    Integer storeLmsLessonFeedback(UserMaster user, LmsMobileEventDto dto);

    Integer storeLmsLessonCompleted(UserMaster user, LmsMobileEventDto dto);

    Integer storeLmsLessonPausedOn(UserMaster user, LmsMobileEventDto dto);

}
