package com.argusoft.imtecho.translation.dao.impl;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.translation.dao.LanguageDao;
import com.argusoft.imtecho.translation.model.LanguageMaster;
import com.argusoft.imtecho.translation.model.TempTranslation;
import org.apache.commons.codec.language.bm.Lang;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.UUID;

@Repository
@Transactional
public class LanguageDaoImpl extends GenericDaoImpl<LanguageMaster, Integer> implements LanguageDao {

    @Override
    public List<LanguageMaster> getAllActiveLanguage() {
        var session = sessionFactory.getCurrentSession();
        var cb = session.getCriteriaBuilder();
        CriteriaQuery<LanguageMaster> cq = cb.createQuery(LanguageMaster.class);
        Root<LanguageMaster> root = cq.from(LanguageMaster.class);
        cq.select(root).where(
                cb.equal(root.get(LanguageMaster.Fields.IS_ACTIVE), true)
        );
        return session.createQuery(cq).list();
    }

}
