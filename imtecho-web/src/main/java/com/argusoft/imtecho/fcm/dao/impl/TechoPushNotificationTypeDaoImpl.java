package com.argusoft.imtecho.fcm.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fcm.dao.TechoPushNotificationTypeDao;
import com.argusoft.imtecho.fcm.model.TechoPushNotificationType;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.Restrictions;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * @author nihar
 * @since 02/08/22 3:46 PM
 */
@Repository
@Transactional
public class TechoPushNotificationTypeDaoImpl extends GenericDaoImpl<TechoPushNotificationType, Integer>
        implements TechoPushNotificationTypeDao {

    @Override
    public TechoPushNotificationType getTechoPushNotificationTypeByType(String type) {
        if (type != null) {
            Criteria criteria = getCriteria();
            criteria.add(Restrictions.eq(TechoPushNotificationType.Fields.TYPE, type));
            return (TechoPushNotificationType) criteria.uniqueResult();
        }
        return null;
    }

    @Override
    public boolean checkFileExists(Integer id) {
        Session session = sessionFactory.getCurrentSession();
        Criteria criteria = session.createCriteria(TechoPushNotificationType.class);
        criteria.add(Restrictions.eq(TechoPushNotificationType.Fields.MEDIA_ID, id));
        List<TechoPushNotificationType> locationDetails = (List) criteria.list();
        return !locationDetails.isEmpty();
    }
}
