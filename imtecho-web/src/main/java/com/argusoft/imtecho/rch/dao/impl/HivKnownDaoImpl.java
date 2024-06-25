package com.argusoft.imtecho.rch.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.rch.dao.HivKnownDao;
import com.argusoft.imtecho.rch.model.HivKnownPositiveEntity;
import org.springframework.stereotype.Repository;

@Repository
public class HivKnownDaoImpl extends GenericDaoImpl<HivKnownPositiveEntity, Integer> implements HivKnownDao {
}
