package com.argusoft.imtecho.chip.dao.impl;

import com.argusoft.imtecho.chip.dao.OcrFormMasterDao;
import com.argusoft.imtecho.chip.model.OcrFormMasterEntity;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dto.OcrFormDataBean;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Repository
@Transactional
public class OcrFormMasterDaoImpl extends GenericDaoImpl<OcrFormMasterEntity, Integer> implements OcrFormMasterDao {

    @Override
    public List<OcrFormDataBean> retrieveOcrFormBeans(Long userId, Date lastModifiedOn) {
        String query = "\n" +
                "select form_name as \"formName\",\n" +
                "form_json as \"formJson\",\n" +
                "modified_on as modifiedOn\n" +
                "from ocr_form_master ofm ";

        if (lastModifiedOn != null) {
            query = query + " and modified_on > :lastModifiedOn";
        }
        Session session = sessionFactory.getCurrentSession();
        NativeQuery<OcrFormDataBean> q = session.createNativeQuery(query);
        if (lastModifiedOn != null) {
            q.setParameter("lastModifiedOn", lastModifiedOn);
        }
        q.addScalar("formName", StandardBasicTypes.TEXT);
        q.addScalar("formJson", StandardBasicTypes.TEXT);
        q.addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP);
        return q.setResultTransformer(Transformers.aliasToBean(OcrFormDataBean.class)).list();
    }
}