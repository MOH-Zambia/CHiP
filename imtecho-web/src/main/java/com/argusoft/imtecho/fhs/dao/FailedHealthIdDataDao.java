/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.fhs.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fhs.model.FailedHealthIdDataEntity;

public interface FailedHealthIdDataDao extends GenericDao<FailedHealthIdDataEntity, Integer> {


    FailedHealthIdDataEntity updateFailedHealthIdData(FailedHealthIdDataEntity failedHealthIdDataEntity);

    /**
     * Retrieves member by id.
     * @param id Id of member.
     * @return Returns member details by id.
     */
    FailedHealthIdDataEntity retrieveFailedHealthIdDataById(Integer id);


    /**
     * Add new member details.
     * @param failedHealthIdDataEntity Member details.
     * @return Returns newly added member details.
     */
    FailedHealthIdDataEntity createFailedHealthIdData(FailedHealthIdDataEntity failedHealthIdDataEntity);
}
