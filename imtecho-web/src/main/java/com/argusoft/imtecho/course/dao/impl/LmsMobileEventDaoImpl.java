package com.argusoft.imtecho.course.dao.impl;

import com.argusoft.imtecho.course.dao.LmsMobileEventDao;
import com.argusoft.imtecho.course.model.LmsMobileEventMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

@Repository
public class LmsMobileEventDaoImpl extends GenericDaoImpl<LmsMobileEventMaster, String> implements LmsMobileEventDao {
}
