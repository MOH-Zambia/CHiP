package com.argusoft.imtecho.course.dao.impl;

import com.argusoft.imtecho.course.dao.CourseNotificationTypeRelDao;
import com.argusoft.imtecho.course.model.CourseNotificationTypeRel;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


@Repository
@Transactional
public class CourseNotificationTypeRelDaoImpl extends GenericDaoImpl<CourseNotificationTypeRel,Integer> implements CourseNotificationTypeRelDao {
}
