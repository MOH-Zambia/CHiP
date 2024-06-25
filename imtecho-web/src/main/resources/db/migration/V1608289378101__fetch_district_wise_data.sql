DELETE FROM QUERY_MASTER WHERE CODE='district_wise_rch_dashboard_analytics';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9e3ca727-5019-43da-89f2-58eebd903311', 80314,  current_date , 80314,  current_date , 'district_wise_rch_dashboard_analytics', 
'financial_year,location_id', 
'select
location_id,
''district'' as type
,case when substr(#financial_year#,1,4) = substr(cast(current_date as text),1,4) then
(current_date - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date)) + 1
else
(cast(concat(substr(#financial_year#,6,10),''-03-31'') as date) - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date)) + 1  end  AS days
,financial_year
,COALESCE(expected_mother_reg, 0) as expected_mother_reg
,COALESCE(anc_reg, 0) as anc_reg
,COALESCE(per_anc_reg, 0) as per_anc_reg
,COALESCE(anc_reg_rank, 0) as anc_reg_rank
,COALESCE(expected_pw_reg, 0) as expected_pw_reg
,COALESCE(early_anc, 0) as early_anc
,COALESCE(per_early_anc, 0) as per_early_anc
,COALESCE(early_anc_rank, 0) as early_anc_rank
,COALESCE(expected_delivery_reg, 0) as expected_delivery_reg
,COALESCE(no_of_del, 0) as no_of_del
,COALESCE(per_no_of_del, 0) as per_no_of_del
,COALESCE(no_of_del_rank, 0) as no_of_del_rank
,COALESCE(expected_inst_del, 0) as expected_inst_del
,COALESCE(inst_del, 0) as inst_del
,COALESCE(per_inst_del, 0) as per_inst_del
,COALESCE(inst_del_rank, 0) as inst_del_rank
,COALESCE(expected_phi_del, 0) as expected_phi_del
,COALESCE(phi_del, 0) as phi_del
,COALESCE(per_phi_del, 0) as per_phi_del
,COALESCE(phi_del_rank, 0) as phi_del_rank
,cast(''-'' as text) as expected_home_del
,COALESCE(home_del, 0 ) as home_del
,COALESCE(per_home_del, 0 ) as per_home_del
,COALESCE(home_del_rank, 0 ) as home_del_rank
,COALESCE(breast_feeding, 0 ) as breast_feeding
,COALESCE(per_breast_feeding, 0 ) as per_breast_feeding
,COALESCE(breast_feeding_rank, 0 ) as breast_feeding_rank
,COALESCE(maternal_death, 0 ) as maternal_death
,COALESCE(expected_mmr, 0 ) as expected_mmr
,COALESCE(expected_no_mmr, 0 ) as expected_no_mmr
,COALESCE(expected_maternal_death, 0 ) as expected_maternal_death
,COALESCE(expected_no_mmr_rank, 0 ) as expected_no_mmr_rank
,COALESCE(per_maternal_death, 0 ) as per_maternal_death
,COALESCE(maternal_death_rank, 0 ) as maternal_death_rank
,COALESCE(high_risk_mother_2nd_trimester, 0 ) as high_risk_mother_2nd_trimester
,COALESCE(total_beneficiary_under_pmsma, 0 ) as total_beneficiary_under_pmsma
,COALESCE(per_total_beneficiary_under_pmsma, 0 ) as per_total_beneficiary_under_pmsma
,COALESCE(pmsma_rank, 0 ) as pmsma_rank
,COALESCE(infant_death, 0 ) as infant_death
,COALESCE(expected_imr, 0 ) as expected_imr
,COALESCE(expected_infant_death, 0 ) as expected_infant_death
,COALESCE(expected_no_imr, 0 ) as expected_no_imr
,COALESCE(per_imr, 0 ) as per_imr
,COALESCE(imr_rank, 0 ) as imr_rank
,COALESCE(expected_imr_rank, 0 ) as expected_imr_rank
,COALESCE(del_less_eq_34, 0 ) as del_less_eq_34
,COALESCE(cortico_steroid, 0 ) as cortico_steroid
,COALESCE(expected_cortico_steroid, 0 ) as expected_cortico_steroid
,COALESCE(per_cortico_steroid, 0 ) as per_cortico_steroid
,COALESCE(cortico_steroid_rank, 0 ) as cortico_steroid_rank
,COALESCE(live_birth, 0 ) as live_birth
,COALESCE(expected_child_reg, 0 ) as expected_child_reg
,COALESCE(per_live_birth, 0 ) as per_live_birth
,COALESCE(live_birth_rank, 0 ) as live_birth_rank
,COALESCE(weighed, 0 ) as weighed
,COALESCE(weighed_less_than_2_5, 0 ) as weighed_less_than_2_5
,COALESCE(expected_weighed, 0 ) as expected_weighed
,COALESCE(per_weighed, 0 ) as per_weighed
,COALESCE(weighed_rank, 0 ) as weighed_rank
,cast(''-'' as text) as expected_lbw
,COALESCE(per_lbw, 0) as per_lbw
,COALESCE(lbw_rank, 0) as lbw_rank
,COALESCE(expected_fully_immu, 0) as expected_fully_immu
,COALESCE(fully_immunized, 0) as fully_immunized
,COALESCE(per_fully_immu, 0) as per_fully_immu
,COALESCE(fully_immu_rank, 0) as fully_immu_rank
,COALESCE(total_male, 0) as total_male
,COALESCE(total_female, 0) as total_female
,COALESCE(per_sex_ratio, 0) as per_sex_ratio
,COALESCE(sex_ratio_rank, 0) as sex_ratio_rank
,COALESCE(ppiucd, 0) as ppiucd
,COALESCE(expected_ppiucd, 0) as expected_ppiucd
,COALESCE(per_ppiucd, 0) as per_ppiucd
,COALESCE(ppiucd_rank, 0) as ppiucd_rank
,COALESCE(total_0_to_5_child, 0) as total_0_to_5_child
,COALESCE(total_screened_for_malnutition, 0) as total_screened_for_malnutition
,COALESCE(per_total_anemic_malnutrition_treated, 0) as per_total_anemic_malnutrition_treated
,COALESCE(total_anemic_malnutrition_rank, 0) as total_anemic_malnutrition_rank
,COALESCE(total_sam_child, 0) as total_sam_child
,COALESCE(per_total_sam_malnutrition, 0) as per_total_sam_malnutrition
,COALESCE(per_total_sam_malnutrition_rank, 0) as per_total_sam_malnutrition_rank
,COALESCE(total_anemic, 0) as total_anemic
,COALESCE(per_total_anemic, 0) as per_total_anemic
,COALESCE(total_anemic_rank, 0) as total_anemic_rank
,cast(''-'' as text) as expected_anemic_pw
,COALESCE(total_severe_anemic, 0) as total_severe_anemic
,COALESCE(per_total_sever_anemic, 0) as per_total_sever_anemic
,COALESCE(total_sever_anemic_rank, 0) as total_sever_anemic_rank
,COALESCE(total_severe_anemic_treated, 0) as total_severe_anemic_treated
,COALESCE(expected_severe_anemic_treated, 0) as expected_severe_anemic_treated
,COALESCE(per_total_anemic_treated, 0) as per_total_anemic_treated
,COALESCE(total_anemic_treated_rank, 0) as total_anemic_treated_rank
,COALESCE(expected_anc4, 0) as expected_anc4
,COALESCE(anc4, 0) as anc4
,COALESCE(per_anc4, 0) as per_anc4
,COALESCE(per_anc4_rank, 0) as per_anc4_rank
,COALESCE(c_section_delivery, 0) as c_section_delivery
,COALESCE(expected_c_section_delivery, 0) as expected_c_section_delivery
,COALESCE(per_c_section_delivery, 0) as per_c_section_delivery
,COALESCE(c_section_delivery_rank, 0) as c_section_delivery_rank
,COALESCE(expected_child_screening_for_malnutritition, 0) as expected_child_screening_for_malnutritition
,COALESCE(per_sam, 0) as per_sam
,COALESCE(total_sam_rank, 0) as total_sam_rank
,cast(''-'' as text) as expected_sam
,cast(''-'' as text) as expected_total_anemic
from rch_dashboard_analytics
where location_id in ( #location_id# ) and financial_year = #financial_year#
union
select
2,
''state'' as type
,case when substr(#financial_year#,1,4) = substr(cast(current_date as text),1,4) then
(current_date - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date))
else
(cast(concat(substr(#financial_year#,6,10),''-03-31'') as date) - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date)) end  AS days
,null
,COALESCE(sum(expected_mother_reg), 0) as expected_mother_reg
,COALESCE(sum(anc_reg), 0) as anc_reg
,COALESCE(case when sum(expected_mother_reg) = 0 then 0 else round(cast(sum(anc_reg)*100.0/sum(expected_mother_reg) as numeric),2) end, 0) as per_anc_reg
,null as anc_reg_rank
,COALESCE(sum(expected_pw_reg), 0) as expected_pw_reg
,COALESCE(sum(early_anc), 0) as early_anc
,COALESCE(case when sum(anc_reg) = 0 then 0 else round(sum(early_anc)*100.0/sum(anc_reg) ,2) end, 0) as per_early_anc
,null as early_anc_rank
,COALESCE(sum(expected_delivery_reg), 0) as expected_delivery_reg
,COALESCE(sum(no_of_del), 0) as no_of_del
,COALESCE(case when sum(expected_delivery_reg) = 0 then 0 else round(cast(sum(no_of_del)*100.0/sum(expected_delivery_reg) as numeric),2) end, 0) as per_no_of_del
,null as no_of_del_rank
,COALESCE(sum(expected_inst_del), 0) as expected_inst_del
,COALESCE(sum(inst_del), 0) as inst_del
,COALESCE(case when sum(no_of_del) = 0 then 0 else round(sum(inst_del)*100.0/sum(no_of_del),2) end, 0) as per_inst_del
,null as inst_del_rank
,COALESCE(sum(expected_phi_del), 0) as expected_phi_del
,COALESCE(sum(phi_del), 0) as phi_del
,COALESCE(case when sum(inst_del) = 0 then 0 else round(sum(phi_del)*100.0/sum(inst_del),2) end, 0) as per_phi_del
,null as phi_del_rank
,cast(''-'' as text) as expected_home_del
,COALESCE(sum(home_del), 0) as home_del
,COALESCE(case when sum(no_of_del) = 0 then 0 else round(sum(home_del)*100.0/sum(no_of_del),2) end, 0) as per_home_del
,null as home_del_rank
,COALESCE(sum(breast_feeding), 0) as breast_feeding
,COALESCE(case when sum(inst_del) = 0 then 0 else round(sum(breast_feeding)*100.0/sum(inst_del),2) end, 0) as per_breast_feeding
,null as breast_feeding_rank
,COALESCE(sum(maternal_death), 0) as maternal_death
,COALESCE(sum(expected_mmr), 0) as expected_mmr
,COALESCE(case when sum(live_birth) = 0 then 0 else round(sum(maternal_death)*100000.0/sum(live_birth),0) end, 0) as expected_no_mmr
,COALESCE(sum(expected_maternal_death), 0) as expected_maternal_death
,null as expected_no_mmr_rank
,COALESCE(case when sum(expected_mmr) = 0 then 0 else round(cast(sum(maternal_death)*100.0/sum(expected_mmr) as numeric ),2) end, 0) as per_maternal_death
,null as maternal_death_rank
,COALESCE(sum(high_risk_mother_2nd_trimester), 0) as high_risk_mother_2nd_trimester
,COALESCE(sum(total_beneficiary_under_pmsma), 0) as total_beneficiary_under_pmsma
,COALESCE(case when sum(high_risk_mother_2nd_trimester) = 0 then 0 else round(sum(total_beneficiary_under_pmsma)*100.0/sum(high_risk_mother_2nd_trimester) ,2) end, 0) as per_total_beneficiary_under_pmsma
,null as pmsma_rank
,COALESCE(sum(infant_death), 0) as infant_death
,COALESCE(sum(expected_imr), 0) as expected_imr
,COALESCE(sum(expected_infant_death), 0) as expected_infant_death
,COALESCE(case when sum(live_birth) = 0 then 0 else round(sum(infant_death)*1000.0/sum(live_birth),0) end, 0) as expected_no_imr
,COALESCE(case when sum(expected_imr) = 0 then 0 else round(cast(sum(infant_death)*100.0/sum(expected_imr) as numeric ),2) end, 0) as per_imr
,null as imr_rank
, null as expected_imr_rank
,COALESCE(sum(del_less_eq_34), 0) as del_less_eq_34
,COALESCE(sum(cortico_steroid), 0) as cortico_steroid
,COALESCE(sum(expected_cortico_steroid), 0) as expected_cortico_steroid
,COALESCE(case when sum(del_less_eq_34) = 0 then 0 else round(sum(cortico_steroid)*100.0/sum(del_less_eq_34) ,2) end, 0) as per_cortico_steroid
,null as cortico_steroid_rank
,COALESCE(sum(live_birth), 0) as live_birth
,COALESCE(sum(expected_child_reg), 0) as expected_child_reg
,COALESCE(case when sum(expected_delivery_reg) = 0 then 0 else round(cast(sum(live_birth)*100.0/sum(expected_delivery_reg) as numeric ),2) end, 0) as per_live_birth
,null as live_birth_rank
,COALESCE(sum(weighed), 0) as weighed
,COALESCE(sum(weighed_less_than_2_5), 0) as weighed_less_than_2_5
,COALESCE(sum(expected_weighed), 0) as expected_weighed
,COALESCE(case when sum(live_birth) = 0 then 0 else round(sum(weighed)*100.0/sum(live_birth) ,2) end, 0) as per_weighed
,null as weighed_rank
,cast(''-'' as text) as expected_lbw
,COALESCE(case when sum(live_birth) = 0 then 0 else round(sum(weighed_less_than_2_5)*100.0/(0.135*sum(live_birth)) ,2) end, 0) as per_lbw
,null as lbw_rank
,COALESCE(sum(expected_fully_immu), 0) as expected_fully_immu
,COALESCE(sum(fully_immunized), 0) as fully_immunized
,COALESCE(case when sum(expected_fully_immu) = 0 then 0 else round(cast(sum(fully_immunized)*100.0/sum(expected_fully_immu) as numeric ),2) end, 0) as per_fully_immu
,null as fully_immu_rank
,COALESCE(sum(total_male), 0) as total_male
,COALESCE(sum(total_female), 0) as total_female
,COALESCE(case when sum(total_male) = 0 then 0 else round(sum(total_female)*1000.0/sum(total_male) ,0) end, 0) as per_sex_ratio
,null as sex_ratio_rank
,COALESCE(sum(ppiucd), 0) as ppiucd
,COALESCE(sum(expected_ppiucd), 0) as expected_ppiucd
,COALESCE(case when sum(phi_del) = 0 then 0 else round(sum(ppiucd)*100.0/sum(phi_del) ,2) end, 0) as per_ppiucd
,null as ppiucd_rank
,COALESCE(sum(total_0_to_5_child), 0) as total_0_to_5_child
,COALESCE(sum(total_screened_for_malnutition), 0) as total_screened_for_malnutition
,COALESCE(case when sum(total_0_to_5_child) = 0 then 0 else round(sum(total_screened_for_malnutition)*100.0/sum(total_0_to_5_child) ,2) end, 0) as per_total_anemic_malnutrition_treated
,null as total_anemic_malnutrition_rank
,COALESCE(sum(total_sam_child), 0) as total_sam_child
,COALESCE(case when sum(total_screened_for_malnutition) = 0 then 0 else round(sum(total_sam_child)*100.0/sum(total_screened_for_malnutition) ,2) end, 0) as per_total_sam_malnutrition
,null as per_total_sam_malnutrition_rank
,COALESCE(sum(total_anemic), 0) as total_anemic
,COALESCE(case when sum(anc_reg) = 0 then 0 else round(sum(total_anemic)*100.0/sum(anc_reg) ,2) end, 0) as per_total_anemic
,null as total_anemic_rank
,cast(''-'' as text) as expected_anemic_pw
,COALESCE(sum(total_severe_anemic), 0) as total_severe_anemic
,COALESCE(case when sum(anc_reg) = 0 then 0 else round(sum(total_severe_anemic)*100.0/(0.015*sum(anc_reg)) ,2) end, 0) as per_total_sever_anemic
, null as total_sever_anemic_rank
,COALESCE(sum(total_severe_anemic_treated), 0) as total_severe_anemic_treated
,COALESCE(sum(expected_severe_anemic_treated), 0) as expected_severe_anemic_treated
,COALESCE(case when sum(total_severe_anemic) = 0 then 0 else round(sum(total_severe_anemic_treated)*100.0/sum(total_severe_anemic) ,2) end, 0) as per_total_anemic_treated
,null as total_anemic_treated_rank
,COALESCE(sum(expected_anc4), 0) as expected_anc4
,COALESCE(sum(anc4), 0) as anc4
,COALESCE(case when sum(early_anc) = 0 then 0 else round(sum(anc4)*100.0/sum(early_anc) ,2) end, 0) as per_anc4
,null as per_anc4_rank
,COALESCE(sum(c_section_delivery), 0) as c_section_delivery
,COALESCE(sum(expected_c_section_delivery), 0) as expected_c_section_delivery
,COALESCE(case when sum(no_of_del) = 0 then 0 else round(sum(c_section_delivery)*100.0/sum(no_of_del) ,2) end, 0) as per_c_section_delivery
,null as c_section_delivery_rank
,COALESCE(sum(expected_child_screening_for_malnutritition), 0) as expected_child_screening_for_malnutritition
,COALESCE(case when sum(total_0_to_5_child) = 0 then 0 else round(sum(total_sam_child)*100.0/sum(total_0_to_5_child) ,2) end, 0) as per_sam
, null as total_sam_rank
, cast(''-'' as text) as expected_sam
, cast(''-'' as text) as expected_total_anemic
from rch_dashboard_analytics
where financial_year = #financial_year#', 
null, 
true, 'ACTIVE');