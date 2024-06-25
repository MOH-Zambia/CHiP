package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.ChipMalariaIndexDao;
import com.argusoft.imtecho.chip.dao.ChipMalariaNonIndexDao;
import com.argusoft.imtecho.chip.model.MalariaIndexCaseEntity;
import com.argusoft.imtecho.chip.model.MalariaNonIndexEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class ChipMalariaIndexDaoImpl extends GenericDaoImpl<MalariaIndexCaseEntity, Integer> implements ChipMalariaIndexDao {
}
