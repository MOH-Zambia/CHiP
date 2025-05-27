package com.argusoft.imtecho.scpro.dao.Impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.scpro.dao.PatientDao;
import com.argusoft.imtecho.scpro.dto.MemberDetailsDTO;
import com.argusoft.imtecho.scpro.dto.ReferralDTO;
import com.argusoft.imtecho.scpro.dto.ReferralNrcDTO;
import com.argusoft.imtecho.scpro.model.PatientData;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import org.springframework.transaction.annotation.Transactional;
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
                        "    AND status=false OR status IS NULL \n" +
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
                        "SET nupn = :nupn, " +
                        "    status = true " +
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
                "select\n" +
                        "nupn as nupn,\n" +
                        "    im.first_name as firstName,\n" +
                        "    im.last_name as lastName,\n" +
                        "    mother_name as motherName,\n" +
                        "    nrc_number as nrc,\n" +
                        "    im.religion as memberReligion,\n" +
                        "    (\n" +
                        "        select\n" +
                        "            value\n" +
                        "        from\n" +
                        "            listvalue_field_value_detail\n" +
                        "        where\n" +
                        "            id = marital_status\n" +
                        "    ) as maritalStatus,\n" +
                        "    dob as dateOfBirth,\n" +
                        "    im.gender,\n" +
                        "    house_number as houseNumberOrLocation,\n" +
                        "    im.mobile_number as mobileNumber,\n" +
                        "    address1 as landmark,\n" +
                        "    split_part(get_location_hierarchy(imf.area_id), ' > ', 3) AS district,\n" +
                        "\thid.mfl_code as mflCode\n" +
                        "from\n" +
                        "    imt_member im\n" +
                        "    inner join imt_family imf on im.family_id = imf.family_id\n" +
                        "\tinner join um_user uu on uu.id = im.created_by \n" +
                        "\tinner join user_health_infrastructure uhi on uhi.user_id=uu.id\n" +
                        "\tinner join health_infrastructure_details hid on uhi.health_infrastrucutre_id = hid.id\n" +
                        "where\n" +
                        "    nrc_number is not null\n" +
                        "    and nupn is null\n" +
                        "limit\n" +
                        "    100;"
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

        NativeQuery<?> query = currentSession.createNativeQuery(
                "UPDATE patient_data " +
                        "SET last_sync_date = CURRENT_DATE,  " +
                        "status = false  " +
                        "WHERE referral_id = :requestId "
        );

        query.setParameter("requestId", requestId);
        query.executeUpdate();
    }

    public List<ReferralDTO> getPatientsToBeReffered(){
        Session currentSession = getCurrentSession();
        NativeQuery<ReferralDTO> query = currentSession.createNativeQuery(
                "select\n" +
                        "    referral_id as referralId,\n" +
                        "    referred_from as referredFrom,\n" +
                        "    referred_to as referredTo,\n" +
                        "    referred_on as referredOn,\n" +
                        "    referred_by as referredBy,\n" +
                        "    reasons as reasons,\n" +
                        "    type_of_referral as typeOfReferral,\n" +
                        "    service_area as serviceArea,\n" +
                        "    notes as notes,\n" +
                        "    nupn as nupn\n" +
                        "from\n" +
                        "    store_referral_details\n" +
                        "WHERE\n" +
                        "    \\ n last_sync_date <> CURRENT_DATE\n" +
                        "    OR last_sync_date IS NULL \\ n\n" +
                        "LIMIT\n" +
                        "    10;"
        );

        return query.addScalar("referralId",StandardBasicTypes.STRING)
                .addScalar("referredFrom", StandardBasicTypes.STRING)
                .addScalar("referredTo",StandardBasicTypes.STRING)
                .addScalar("referredOn", StandardBasicTypes.STRING)
                .addScalar("referredBy", StandardBasicTypes.STRING)
                .addScalar("reasons", StandardBasicTypes.STRING)
                .addScalar("typeOfReferral", StandardBasicTypes.STRING)
                .addScalar("serviceArea", StandardBasicTypes.STRING)
                .addScalar("notes", StandardBasicTypes.STRING)
                .addScalar("nupn", StandardBasicTypes.STRING)



                .setResultTransformer(Transformers.aliasToBean(ReferralDTO.class)).list();
    }

    public void deleteReferralId(String refId){
        Session currentSession = getCurrentSession();

        NativeQuery<?> query = currentSession.createNativeQuery(
                "DELETE from patient_data " +
                        "WHERE referral_id = :refId "
        );

        query.setParameter("refId", refId);
        query.executeUpdate();
    }
}
