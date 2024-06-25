
package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.dao.SmsDao;
import com.argusoft.imtecho.common.model.Sms;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;

/**
 * <p>
 *     Implements methods of SmsDao
 * </p>
 *
 * @author prateek
 * @since 31/08/2020 4:30
 */
@Repository
public class SmsDaoImpl extends GenericDaoImpl<Sms, Integer> implements SmsDao {

}
