package com.argusoft.imtecho.smstype.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.smstype.dao.SmsTypeMasterDao;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster;
import com.argusoft.imtecho.smstype.model.SmsTypeMaster.State;
import org.hibernate.Criteria;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * <p>
 * Dao impl for sms type
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:23 PM
 */
@Repository
public class SmsTypeMasterDaoImpl extends GenericDaoImpl<SmsTypeMaster, String> implements SmsTypeMasterDao {

    @Override
    public List<SmsTypeMaster> getAllActiveSmsTypes() {
        Criteria criteria = getCriteria();
        criteria.add(Restrictions.eq(SmsTypeMaster.Fields.STATE, State.ACTIVE));
        return criteria.list();
    }

    @Override
    public SmsTypeMaster getSmsTypeMasterByType(String type) {
        if (type != null) {
            Criteria criteria = getCriteria();
            criteria.add(Restrictions.eq(SmsTypeMaster.Fields.SMS_TYPE, type));
            return (SmsTypeMaster) criteria.uniqueResult();
        }
        return null;
    }

}
