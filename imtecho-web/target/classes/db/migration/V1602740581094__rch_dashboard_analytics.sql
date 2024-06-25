drop
	table
		if exists rch_dashboard_analytics;

create table rch_dashboard_analytics
(
    location_id integer,
    financial_year text
    ,expected_mother_reg text
    ,anc_reg integer
    ,per_anc_reg float
    ,anc_reg_rank integer
    ,early_anc integer
    ,per_early_anc float
    ,early_anc_rank integer
    ,expected_delivery_reg text
    ,no_of_del integer
    ,per_no_of_del float
    ,no_of_del_rank integer
    ,inst_del integer
    ,phi_del integer
    ,per_phi_del float
    ,phi_del_rank integer
    ,breast_feeding integer
    ,per_breast_feeding float
    ,breast_feeding_rank integer
    ,maternal_death integer
    ,expected_mmr text
    ,per_maternal_death float
    ,maternal_death_rank integer
    ,high_risk_mother_2nd_trimester integer
    ,total_beneficiary_under_pmsma integer
    ,per_total_beneficiary_under_pmsma float
    ,pmsma_rank  integer
    ,infant_death  integer
    ,expected_imr text
    ,per_imr float
    ,imr_rank integer
    ,del_less_eq_34 integer
    ,cortico_steroid integer
    ,per_cortico_steroid float
    ,cortico_steroid_rank integer
    ,live_birth integer
    ,weighed integer
    ,weighed_less_than_2_5 integer
    ,per_lbw float
    ,lbw_rank integer
    ,expected_fully_immu text
    ,fully_immunized integer
    ,per_fully_immu float
    ,fully_immu_rank integer
    ,total_male integer
    ,total_female integer
    ,per_sex_ratio float
    ,sex_ratio_rank integer
    ,ppiucd integer
    ,per_ppiucd float
    ,ppiucd_rank integer
    ,total_0_to_5_child integer
    ,total_screened_for_malnutition integer
    ,per_total_anemic_malnutrition_treated float
    ,total_anemic_malnutrition_rank integer
    ,total_sam_child integer
    ,per_total_sam_malnutrition float
    ,per_total_sam_malnutrition_rank float
    ,total_anemic integer
    ,per_total_anemic float
    ,total_anemic_rank integer
    ,total_severe_anemic integer
    ,per_total_sever_anemic float
    ,total_severe_anemic_treated integer
    ,per_total_anemic_treated float
    ,primary key(financial_year, location_id)
);