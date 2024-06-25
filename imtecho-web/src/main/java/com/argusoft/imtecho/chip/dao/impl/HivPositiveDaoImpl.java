/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dto.MemberDto;
import com.argusoft.imtecho.rch.dao.AdolescentDao;
import com.argusoft.imtecho.rch.dao.HivPositiveDao;
import com.argusoft.imtecho.rch.model.AdolescentScreeningEntity;
import com.argusoft.imtecho.rch.model.HivPositiveEntity;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

/**
 * @author utkarsh
 */
@Repository
@Transactional
public class HivPositiveDaoImpl extends GenericDaoImpl<HivPositiveEntity, Integer> implements HivPositiveDao {
}
