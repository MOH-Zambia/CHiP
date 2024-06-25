package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.FieldMasterDao;
import com.argusoft.imtecho.common.model.FieldConstantMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

/**
 * <p>
 *     Implements methods of FieldMasterDao
 * </p>
 * @author shrey
 * @since 31/08/2020 4:30
 */
@Repository
public class FieldMasterDaoImpl
        extends GenericDaoImpl<FieldConstantMaster,Integer> 
        implements FieldMasterDao{
    
}
