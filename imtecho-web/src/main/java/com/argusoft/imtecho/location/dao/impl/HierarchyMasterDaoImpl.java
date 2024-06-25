/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.location.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.location.dao.HierarchyMasterDao;
import com.argusoft.imtecho.location.model.HierarchyMaster;
import org.springframework.stereotype.Repository;

/**
 *
 * <p>
 * Implementation of methods define in hierarchy master dao.
 * </p>
 *
 * @author akshar
 * @since 26/08/20 10:19 AM
 */
@Repository("hierarchyMasterDao")
public class HierarchyMasterDaoImpl extends GenericDaoImpl<HierarchyMaster, Integer> implements HierarchyMasterDao{
    
}
