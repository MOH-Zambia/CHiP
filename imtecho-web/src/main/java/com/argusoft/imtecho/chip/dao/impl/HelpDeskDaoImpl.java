package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.HelpDeskDao;
import com.argusoft.imtecho.chip.model.HelpDeskEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class HelpDeskDaoImpl extends GenericDaoImpl<HelpDeskEntity, Integer> implements HelpDeskDao {

}