package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.ChipMalariaDao;
import com.argusoft.imtecho.chip.dao.ChipTBDao;
import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.chip.model.ChipTBEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class ChipTBDaoImpl extends GenericDaoImpl<ChipTBEntity, Integer> implements ChipTBDao {
}
