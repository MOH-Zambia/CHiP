package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.GbvDao;
import com.argusoft.imtecho.chip.model.GbvVisit;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class GbvDaoImpl extends GenericDaoImpl<GbvVisit, Integer> implements GbvDao {
}
