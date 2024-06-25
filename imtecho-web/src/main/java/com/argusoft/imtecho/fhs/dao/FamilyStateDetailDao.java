/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.model.FamilyStateDetailEntity;

/**
 *
 * <p>
 * Define methods for family states.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
public interface FamilyStateDetailDao extends GenericDao<FamilyStateDetailEntity, Integer> {

    /**
     * Retrieves family states detail by id.
     * @param id Id of family state.
     * @return Returns family details.
     */
    @Override
    FamilyStateDetailEntity retrieveById(Integer id);
}
