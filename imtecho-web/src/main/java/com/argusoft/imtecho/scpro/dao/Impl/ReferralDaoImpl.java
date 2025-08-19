package com.argusoft.imtecho.scpro.dao.Impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.scpro.dao.ReferralDao;
import com.argusoft.imtecho.scpro.dto.*;
import com.argusoft.imtecho.scpro.model.ReferralData;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;

@Repository
@Transactional
public class ReferralDaoImpl extends GenericDaoImpl<ReferralData,Long> implements ReferralDao {
    @Override
    public List<ReferralNupnDTO> getReferredIds(){
        Session currentSession = getCurrentSession();
        NativeQuery<ReferralNupnDTO> query = currentSession.createNativeQuery(
                "SELECT \n" +
                        "    referral_id AS referralId, \n" +
                        "    client_nupn AS clientNupn \n" +
                        "FROM \n" +
                        "    referred_patient_data \n" +
                        "WHERE \n" +
                        "    last_sync_date <> CURRENT_DATE \n" +
                        "    OR last_sync_date IS NULL \n" +
                        "    AND status=false OR status IS NULL \n" +
                        "LIMIT 10;"
        );


        return query.addScalar("referralId", StandardBasicTypes.STRING)
                .addScalar("clientNupn", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(ReferralNupnDTO.class)).list();
    }

    @Override
    public void updateSyncDate(String requestId){
        Session currentSession = getCurrentSession();

        NativeQuery<?> query = currentSession.createNativeQuery(
                "UPDATE referred_patient_data " +
                        "SET last_sync_date = CURRENT_DATE,  " +
                        "status = false  " +
                        "WHERE referral_id = :requestId "
        );

        query.setParameter("requestId", requestId);
        query.executeUpdate();
    }

    @Override
    public List<StoredReferralDTO>getStoredReferredPatinets(){
        Session currentSession = getCurrentSession();
        NativeQuery<StoredReferralDTO> query = currentSession.createNativeQuery(
                "select srd.referral_id as id, srd.nupn_id as nupn,srd.referred_place as facility,srd.referral_reason as reasonForReferral,srd.service_area as referralType,srd.referral_reason as additionalComments,split_part(get_location_hierarchy(imf.area_id), ' > ', 2) AS province,\n" +
                        "split_part(get_location_hierarchy(imf.area_id), ' > ', 3) AS district from store_referral_details srd inner join imt_member im on im.nupn = srd.nupn_id inner join imt_family imf on imf.family_id=im.family_id where im.nupn is not null and srd.referral_sent is false "
        );


        return query.addScalar("nupn",StandardBasicTypes.STRING)
                .addScalar("facility", StandardBasicTypes.STRING)
                .addScalar("reasonForReferral",StandardBasicTypes.STRING)
                .addScalar("referralType", StandardBasicTypes.STRING)
                .addScalar("additionalComments", StandardBasicTypes.STRING)
                .addScalar("province", StandardBasicTypes.STRING)
                .addScalar("district", StandardBasicTypes.STRING)
                .addScalar("id",StandardBasicTypes.INTEGER)
                .setResultTransformer(Transformers.aliasToBean(StoredReferralDTO.class)).list();
    }

    @Override
    public void updateStoredReferral(Integer id ){
        Session currentSession = getCurrentSession();

        NativeQuery<?> query = currentSession.createNativeQuery(
                "UPDATE store_referral_details " +
                        "SET referral_sent = true " +
                        "WHERE referral_id = :id "
        );

        query.setParameter("id", id);
        query.executeUpdate();
    }
}
