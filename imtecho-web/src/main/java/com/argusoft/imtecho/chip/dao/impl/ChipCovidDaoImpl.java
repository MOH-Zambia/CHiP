package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.ChipCovidDao;
import com.argusoft.imtecho.chip.dao.ChipMalariaDao;
import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.chip.model.CovidScreeningEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

@Repository
@Transactional
public class ChipCovidDaoImpl extends GenericDaoImpl<CovidScreeningEntity, Integer> implements ChipCovidDao {

}
