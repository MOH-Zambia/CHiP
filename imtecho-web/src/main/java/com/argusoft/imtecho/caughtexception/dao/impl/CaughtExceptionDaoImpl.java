package com.argusoft.imtecho.caughtexception.dao.impl;

import com.argusoft.imtecho.caughtexception.dao.CaughtExceptionDao;
import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.hibernate.Session;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class CaughtExceptionDaoImpl extends GenericDaoImpl<CaughtExceptionEntity, Integer> implements CaughtExceptionDao {

    @Override
    public void save(CaughtExceptionEntity exception) {
        Session session = sessionFactory.getCurrentSession();
        session.save(exception);
        session.flush();
    }

}
