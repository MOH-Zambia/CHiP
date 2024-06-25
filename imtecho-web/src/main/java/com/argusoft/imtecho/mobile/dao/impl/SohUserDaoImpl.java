package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.SohUserDao;
import com.argusoft.imtecho.mobile.model.SohUser;
import org.hibernate.query.NativeQuery;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

@Repository
//@Transactional
public class SohUserDaoImpl extends GenericDaoImpl<SohUser, Integer> implements SohUserDao {

    public int countUserByMobileNo(String mobileNo) {
        String query = "select (select count(*) as count from um_user where contact_number = :mobileNo and state IN ('ACTIVE')) + \n" +
                "(select count(*) from soh_user where mobile_no = :mobileNo and state IN ('ACTIVE','PENDING') ) as count";
        NativeQuery<Integer> sQLQuery = getCurrentSession().createNativeQuery(query);
        sQLQuery.setParameter("mobileNo", mobileNo);
        sQLQuery.addScalar("count", StandardBasicTypes.INTEGER);
        return sQLQuery.uniqueResult();
    }

    public void deleteByMobileNo(String mobileNo) {
        String query = "delete from soh_user where mobile_no = :mobileNo and state='OTP_SEND'";
        NativeQuery<Integer> sQLQuery = getCurrentSession().createNativeQuery(query);
        sQLQuery.setParameter("mobileNo", mobileNo);
        sQLQuery.executeUpdate();
    }
}
