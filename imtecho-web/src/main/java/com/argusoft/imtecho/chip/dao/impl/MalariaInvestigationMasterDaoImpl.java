package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.MalariaInvestigationMasterDao;
import com.argusoft.imtecho.chip.model.MalariaInvestigationMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class MalariaInvestigationMasterDaoImpl extends GenericDaoImpl<MalariaInvestigationMaster, Integer>
        implements MalariaInvestigationMasterDao {

}
