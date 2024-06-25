/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.event.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.event.dao.EventConfigurationTypeDao;
import com.argusoft.imtecho.event.model.EventConfigurationType;
import org.springframework.stereotype.Repository;

/**
 *
 * <p>
 * Implementation of methods define in event configuration type dao.
 * </p>
 *
 * @author vaishali
 * @since 26/08/20 10:19 AM
 */
@Repository()
public class EventConfigurationTypeDaoImpl extends GenericDaoImpl<EventConfigurationType,String> implements EventConfigurationTypeDao{
    
}
