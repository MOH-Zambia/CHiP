package com.argusoft.imtecho.scpro.dao.Impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.scpro.dao.PatientDao;
import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.model.PatientData;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Repository
@Transactional
public class PatientDaoImpl extends GenericDaoImpl<PatientData,Long> implements PatientDao {
    @Override
    public List<ReferralNrcDTO> getPatientId(){
        Session currentSession = getCurrentSession();
        NativeQuery<ReferralNrcDTO> query = currentSession.createNativeQuery(
                "SELECT \n" +
                        "    referral_id AS referralId, \n" +
                        "    nrc AS nrc \n" +
                        "FROM \n" +
                        "    patient_data \n" +
                        "WHERE \n" +
                        "    last_sync_date <> CURRENT_DATE \n" +
                        "    OR last_sync_date IS NULL \n" +
                        "LIMIT 10;"
        );


        return query.addScalar("referralId",StandardBasicTypes.STRING)
                .addScalar("nrc", StandardBasicTypes.STRING)
                .setResultTransformer(Transformers.aliasToBean(ReferralNrcDTO.class)).list();
    }

    @Override
    public void setNUPN(String nupn,String nrc){
        Session currentSession = getCurrentSession();

        // Construct the native SQL query for insertion
        NativeQuery<?> query = currentSession.createNativeQuery(
                "UPDATE imt_member\n" +
                        "SET nupn = :nupn\n" +
                        "WHERE nrc_number = :nrc"
        );

        query.setParameter("nupn", nupn);
        query.setParameter("nrc", nrc);

        // Execute the query
        query.executeUpdate();
    }
    @Override
    public List<MemberDetailsDTO> getPatientsFromImt(){
        Session currentSession = getCurrentSession();
        NativeQuery<MemberDetailsDTO> query = currentSession.createNativeQuery(
                "select first_name as firstName,last_name as lastName,mother_name as motherName,nrc_number as nrc,im.religion as memberReligion,(select value from listvalue_field_value_detail where id=marital_status)as maritalStatus,dob as dateOfBirth,gender,house_number as houseNumberOrLocation,mobile_number as mobileNumber,address1 as landmark\n" +
                        "from imt_member im inner join imt_family imf on im.family_id = imf.family_id where nrc_number is not null limit 100;"
        );


        return query.addScalar("firstName",StandardBasicTypes.STRING)
                .addScalar("lastName", StandardBasicTypes.STRING)
                .addScalar("motherName",StandardBasicTypes.STRING)
                .addScalar("memberReligion", StandardBasicTypes.STRING)
                .addScalar("nrc", StandardBasicTypes.STRING)
                .addScalar("gender", StandardBasicTypes.STRING)
                .addScalar("maritalStatus", StandardBasicTypes.STRING)
                .addScalar("dateOfBirth", StandardBasicTypes.STRING)
                .addScalar("mobileNumber", StandardBasicTypes.STRING)
                .addScalar("houseNumberOrLocation", StandardBasicTypes.STRING)
                .addScalar("landmark", StandardBasicTypes.STRING)



                .setResultTransformer(Transformers.aliasToBean(MemberDetailsDTO.class)).list();
    }

    public void updateSyncDate(String requestId)
    {
        Session currentSession = getCurrentSession();

// Construct the native SQL query for updating
        NativeQuery<?> query = currentSession.createNativeQuery(
                "UPDATE patient_data " +
                        "SET last_sync_date = CURRENT_DATE  " +
                        "WHERE referral_id = :requestId "
        );

// Set parameters for the query

        query.setParameter("requestId", requestId);

// Execute the query
        query.executeUpdate();
    }
}
