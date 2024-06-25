package com.argusoft.imtecho.fhs.dao.impl;

import com.argusoft.imtecho.cfhc.dto.FamilyAvailabilityDataBean;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.fhs.dao.FamilyAvailabilityDetailDao;
import com.argusoft.imtecho.fhs.model.FamilyAvailabilityDetail;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import java.util.Collections;
import java.util.Date;
import java.util.List;


@Repository
public class FamilyAvailabilityDetailDaoImpl extends GenericDaoImpl<FamilyAvailabilityDetail, Integer> implements FamilyAvailabilityDetailDao {

    public List<FamilyAvailabilityDataBean> getFamilyAvailabilityByModifiedOn(Integer userId, Date modifiedOn) {
        String query = "select id as \"actualId\", user_id as \"userId\", availability_status as \"availabilityStatus\", house_number as \"houseNumber\",\n" +
                "address1 , address2 , location_id as \"locationId\", family_id as \"familyId\", modified_on as \"modifiedOn\"\n" +
                "from family_availability_detail \n" +
                "where location_id in (\n" +
                "\tselect child_id from location_hierchy_closer_det where parent_id in (\n" +
                "\t\tselect loc_id from um_user_location where user_id = :userId and state = 'ACTIVE'\n" +
                "\t)\n" +
                ")";
        NativeQuery q = getCurrentSession().createNativeQuery(query);
        q.setParameter("userId", userId);
        q.addScalar("actualId", StandardBasicTypes.INTEGER)
                .addScalar("actualId", StandardBasicTypes.INTEGER)
                .addScalar("userId", StandardBasicTypes.INTEGER)
                .addScalar("availabilityStatus", StandardBasicTypes.STRING)
                .addScalar("houseNumber", StandardBasicTypes.STRING)
                .addScalar("address1", StandardBasicTypes.STRING)
                .addScalar("address2", StandardBasicTypes.STRING)
                .addScalar("locationId", StandardBasicTypes.INTEGER)
                .addScalar("familyId", StandardBasicTypes.INTEGER)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP);

        return q.setResultTransformer(Transformers.aliasToBean(FamilyAvailabilityDataBean.class)).list();
    }

}
