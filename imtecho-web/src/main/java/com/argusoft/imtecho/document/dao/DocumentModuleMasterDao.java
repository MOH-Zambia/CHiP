/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.document.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.document.dto.DocumentModuleMasterDto;
import com.argusoft.imtecho.document.model.DocumentModuleMaster;
import java.util.List;

/**
 *
 * @author jay
 */
public interface DocumentModuleMasterDao extends GenericDao<DocumentModuleMaster, Integer> {

    List<DocumentModuleMasterDto> retrieveModuleName(String moduleName);
}
