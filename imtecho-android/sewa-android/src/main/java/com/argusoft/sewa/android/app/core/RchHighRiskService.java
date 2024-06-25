package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.databean.OptionTagBean;

import java.util.List;
import java.util.Map;

public interface RchHighRiskService {

    String identifyHighRiskForRchAnc(Map<String, Object> mapOfAnswers);

    String identifyHighRiskForChildRchPnc(Object dangerousSignAnswer, Object otherDangerousSignAnswer);

    String identifyHighRiskForMotherRchPnc(Object dangerousSignAnswer, Object otherDangerousSignAnswer);

    String identifyHighRiskForChildRchWpd(Object weightAnswer);

    String identifyHighRiskForChardhamTourist(Map<String, Object> mapOfAnswers);

    void identifyHighRisk(String type, Object answer, List<OptionDataBean> allOptions, String property);

    String identifyHighRiskForAdolescent(Map<String, Object> mapOfAnswers);

}
