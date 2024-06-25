package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.SohElementModuleMasterDao;
import com.argusoft.imtecho.mobile.model.SohElementModuleMaster;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class SohElementModuleMasterDaoImpl extends GenericDaoImpl<SohElementModuleMaster, Integer> implements SohElementModuleMasterDao {
    @Override
    public List<SohElementModuleMaster> getAllModules(Boolean retrieveActiveOnly) {

        String query = "select\n" +
                "semm.id as \"id\",\n" +
                "semm.module as \"module\",\n" +
                "semm.module_name as \"moduleName\",\n" +
                "semm.is_public as \"isPublic\",\n" +
                "semm.module_order as \"moduleOrder\",\n" +
                "semm.footer_description as \"footerDescription\",\n" +
                "semm.state as \"state\",\n" +
                "semm.created_on as \"createdOn\",\n" +
                "semm.created_by as \"createdBy\",\n" +
                "semm.modified_on as \"modifiedOn\",\n" +
                "semm.modified_by as \"modifiedBy\"\n" +
                "from soh_element_module_master semm\n";
        if (retrieveActiveOnly) {
            query += "where semm.state = 'ACTIVE'\n";
        }
        query += "order by semm.module_order";

        NativeQuery<SohElementModuleMaster> q = getCurrentSession().createNativeQuery(query)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("module", StandardBasicTypes.STRING)
                .addScalar("moduleName", StandardBasicTypes.STRING)
                .addScalar("isPublic", StandardBasicTypes.BOOLEAN)
                .addScalar("moduleOrder", StandardBasicTypes.INTEGER)
                .addScalar("state", StandardBasicTypes.STRING)
                .addScalar("createdBy", StandardBasicTypes.INTEGER)
                .addScalar("createdOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("modifiedBy", StandardBasicTypes.INTEGER)
                .addScalar("footerDescription", StandardBasicTypes.STRING)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP);

        return q.setResultTransformer(Transformers.aliasToBean(SohElementModuleMaster.class)).list();
    }
}
