package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.EventBasedCareDao;
import com.argusoft.imtecho.chip.model.EventBasedCareModule;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;

@Repository
@Transactional
public class EventBaseDaoImpl extends GenericDaoImpl<EventBasedCareModule, Integer>
        implements EventBasedCareDao {
}
