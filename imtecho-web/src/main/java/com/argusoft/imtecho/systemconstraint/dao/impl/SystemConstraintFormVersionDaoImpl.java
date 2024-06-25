package com.argusoft.imtecho.systemconstraint.dao.impl;

import com.argusoft.imtecho.common.model.FieldValueMaster;
import com.argusoft.imtecho.common.model.SystemBuildHistory;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.systemconstraint.dao.SystemConstraintFormVersionDao;
import com.argusoft.imtecho.systemconstraint.model.SystemConstraintFormVersion;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;


import java.util.UUID;

@Repository
public class SystemConstraintFormVersionDaoImpl
        extends GenericDaoImpl<SystemConstraintFormVersion, UUID>
        implements SystemConstraintFormVersionDao {


    @Override
    public SystemConstraintFormVersion getFormVersionByFormUuidAndType(UUID formUuid, String type) {
        String query = "select " +
                "id,form_master_uuid as formMasterUuid,template_config as templateConfig,\"version\" ,\"type\",created_by as createdBy,\n" +
                "created_on as createdOn " +
                " from system_constraint_form_version where form_master_uuid = :uuid\n" +
                " \tand type =:type and \"version\" = (select Max(\"version\") from system_constraint_form_version where \n" +
                " \tform_master_uuid = :uuid and type =:type)";
        NativeQuery<SystemConstraintFormVersion> nativeQuery = getCurrentSession().createNativeQuery(query);
        nativeQuery.setParameter("uuid", formUuid)
                .setParameter("type", type)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("formMasterUuid", StandardBasicTypes.UUID_CHAR)
                .addScalar("templateConfig", StandardBasicTypes.STRING)
                .addScalar("version", StandardBasicTypes.INTEGER)
                .addScalar("type", StandardBasicTypes.STRING)
                .addScalar("createdBy", StandardBasicTypes.INTEGER)
                .addScalar("createdOn", StandardBasicTypes.DATE);
        return nativeQuery.setResultTransformer(Transformers.aliasToBean(SystemConstraintFormVersion.class)).uniqueResult();

    }
}
