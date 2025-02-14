package com.argusoft.imtecho.scpro.dao.Impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.scpro.dao.ReferralDao;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNupnDTO;
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
}
