package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.model.BcgVaccinationSurveyDetails;

public interface BcgVaccinationSurveyDao extends GenericDao<BcgVaccinationSurveyDetails, Integer> {
    BcgVaccinationSurveyDetails retrieveByMemberId(Integer memberId);

    boolean validateNikshayId(String nikshayId);
}
