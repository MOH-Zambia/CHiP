/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.EMTCTDao;
import com.argusoft.imtecho.chip.model.EMTCTEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.rch.dao.HivPositiveDao;
import com.argusoft.imtecho.rch.model.HivPositiveEntity;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author utkarsh
 */
@Repository
@Transactional
public class EMTCTDaoImpl extends GenericDaoImpl<EMTCTEntity, Integer> implements EMTCTDao {
}
