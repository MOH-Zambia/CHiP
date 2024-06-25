package com.argusoft.imtecho.translation.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.translation.dao.AppDao;
import com.argusoft.imtecho.translation.model.App;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class AppDaoImpl extends GenericDaoImpl<App, Integer> implements AppDao {

}
