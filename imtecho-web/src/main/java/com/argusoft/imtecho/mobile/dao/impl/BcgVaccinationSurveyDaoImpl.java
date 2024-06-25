package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.BcgVaccinationSurveyDao;
import com.argusoft.imtecho.mobile.model.BcgVaccinationSurveyDetails;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import java.util.List;
import java.util.Objects;

@Repository
@Transactional
public class BcgVaccinationSurveyDaoImpl extends GenericDaoImpl<BcgVaccinationSurveyDetails, Integer> implements BcgVaccinationSurveyDao {

    @Override
    public BcgVaccinationSurveyDetails retrieveByMemberId(Integer memberId) {
        Session session = sessionFactory.getCurrentSession();
        CriteriaBuilder criteriaBuilder = session.getCriteriaBuilder();
        CriteriaQuery<BcgVaccinationSurveyDetails> criteriaQuery = criteriaBuilder.createQuery(BcgVaccinationSurveyDetails.class);
        Root<BcgVaccinationSurveyDetails> root = criteriaQuery.from(BcgVaccinationSurveyDetails.class);
        Predicate memberIdEqual = criteriaBuilder.equal(root.get(BcgVaccinationSurveyDetails.Fields.MEMBER_ID), memberId);
        criteriaQuery.select(root).where(criteriaBuilder.and(memberIdEqual));
        criteriaQuery.orderBy(criteriaBuilder.desc(root.get("id")));
        List<BcgVaccinationSurveyDetails> bcgVaccinationSurveyDetails = session.createQuery(criteriaQuery).list();
        if (Objects.nonNull(bcgVaccinationSurveyDetails) && !bcgVaccinationSurveyDetails.isEmpty()) {
            return bcgVaccinationSurveyDetails.get(0);
        }
        return null;
    }

    @Override
    public boolean validateNikshayId(String nikshayId) {
        String query = "select nikshay_id from bcg_vaccination_survey_details where nikshay_id = :nikshayId";
        Session session = sessionFactory.getCurrentSession();
        SQLQuery q = session.createSQLQuery(query);
        q.setParameter("nikshayId", nikshayId);
        List<String> result = q.addScalar("nikshay_id", StandardBasicTypes.STRING).list();
        if (CollectionUtils.isEmpty(result)) {
            return true;
        } else {
            return false;
        }
    }
}
