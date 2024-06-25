package com.argusoft.imtecho.caughtexception.service.impl;

import com.argusoft.imtecho.caughtexception.dao.CaughtExceptionDao;
import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.caughtexception.service.CaughtExceptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * <p>
 * Implement methods of {@link CaughtExceptionService}
 * </p>
 *
 * @author dhruvil
 * @since 27/05/2023 5:46 pm
 */
@Service
@Transactional
public class CaughtExceptionServiceImpl implements CaughtExceptionService {

    @Autowired
    private CaughtExceptionDao caughtExceptionDao;

    @Override
    public void saveCaughtException(CaughtExceptionEntity exception) {
        caughtExceptionDao.save(exception);
    }

}

