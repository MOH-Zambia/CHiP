package com.argusoft.imtecho.course.dao;

import com.argusoft.imtecho.course.model.LmsUserMetaData;
import com.argusoft.imtecho.database.common.GenericDao;

import java.util.List;

public interface LmsUserMetaDataDao extends GenericDao<LmsUserMetaData, Integer> {

    List<LmsUserMetaData> retrieveByUserId(Integer userId);

    LmsUserMetaData retrieveByUserIdAndCourseId(Integer userId, Integer courseId);
}
