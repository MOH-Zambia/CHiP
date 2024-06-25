package com.argusoft.imtecho.smstype.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster;

import java.util.List;


/**
 * <p>
 * Dao for sms type
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:23 PM
 */
public interface SmsTypeMasterDao extends GenericDao<SmsTypeMaster, String> {

    List<SmsTypeMaster> getAllActiveSmsTypes();

    SmsTypeMaster getSmsTypeMasterByType(String type);

}
