DELETE FROM QUERY_MASTER WHERE CODE='district_wise_rch_dashboard_analytics';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9e3ca727-5019-43da-89f2-58eebd903311', 74841,  current_date , 74841,  current_date , 'district_wise_rch_dashboard_analytics', 
'financial_year,location_id', 
'select
location_id
,case when substr(#financial_year#,1,4) = substr(cast(current_date as text),1,4) then
(current_date - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date))
else
(cast(concat(substr(#financial_year#,6,10),''-03-31'') as date) - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date)) end  AS days
,financial_year
,expected_mother_reg
,anc_reg
,per_anc_reg
,anc_reg_rank
,expected_pw_reg
,early_anc
,per_early_anc
,early_anc_rank
,expected_delivery_reg
,no_of_del
,per_no_of_del
,no_of_del_rank
,expected_inst_del
,inst_del
,per_inst_del
,inst_del_rank
,expected_phi_del
,phi_del
,per_phi_del
,phi_del_rank
,expected_home_del
,home_del
,per_home_del
,home_del_rank
,breast_feeding
,per_breast_feeding
,breast_feeding_rank
,maternal_death
,expected_mmr
,expected_no_mmr
,expected_maternal_death
,expected_no_mmr_rank
,per_maternal_death
,maternal_death_rank
,high_risk_mother_2nd_trimester
,total_beneficiary_under_pmsma
,per_total_beneficiary_under_pmsma
,pmsma_rank
,infant_death
,expected_imr
,expected_infant_death
,expected_no_imr
,per_imr
,imr_rank
,expected_imr_rank
,del_less_eq_34
,cortico_steroid
,expected_cortico_steroid
,per_cortico_steroid
,cortico_steroid_rank
,live_birth
,expected_child_reg
,per_live_birth
,live_birth_rank
,weighed
,weighed_less_than_2_5
,expected_weighed
,per_weighed
,weighed_rank
,expected_lbw
,per_lbw
,lbw_rank
,expected_fully_immu
,fully_immunized
,per_fully_immu
,fully_immu_rank
,total_male
,total_female
,per_sex_ratio
,sex_ratio_rank
,ppiucd
,expected_ppiucd
,per_ppiucd
,ppiucd_rank
,total_0_to_5_child
,total_screened_for_malnutition
,per_total_anemic_malnutrition_treated
,total_anemic_malnutrition_rank
,total_sam_child
,per_total_sam_malnutrition
,per_total_sam_malnutrition_rank
,total_anemic
,per_total_anemic
,total_anemic_rank
,expected_anemic_pw
,total_severe_anemic
,per_total_sever_anemic
,total_sever_anemic_rank
,total_severe_anemic_treated
,expected_severe_anemic_treated
,per_total_anemic_treated
,total_anemic_treated_rank
,expected_anc4
,anc4
,per_anc4
,per_anc4_rank
,c_section_delivery
,expected_c_section_delivery
,per_c_section_delivery
,c_section_delivery_rank
from rch_dashboard_analytics
where location_id = #location_id# and financial_year = #financial_year#
union
select
2
,case when substr(#financial_year#,1,4) = substr(cast(current_date as text),1,4) then
(current_date - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date))
else
(cast(concat(substr(#financial_year#,6,10),''-03-31'') as date) - cast(concat(substr(#financial_year#,1,4),''-04-01'') as date)) end  AS days
,null
,sum(expected_mother_reg) as expected_mother_reg
,sum(anc_reg) as anc_reg
,case when sum(expected_mother_reg) = 0 then 0 else round(cast(sum(anc_reg)*100.0/sum(expected_mother_reg) as numeric),2) end as per_anc_reg
,null as anc_reg_rank
,sum(expected_pw_reg) as expected_pw_reg
,sum(early_anc) as early_anc
,case when sum(anc_reg) = 0 then 0 else round(sum(early_anc)*100.0/sum(anc_reg) ,2) end as per_early_anc
,null as early_anc_rank
,sum(expected_delivery_reg) as expected_delivery_reg
,sum(no_of_del) as no_of_del
,case when sum(expected_delivery_reg) = 0 then 0 else round(cast(sum(no_of_del)*100.0/sum(expected_delivery_reg) as numeric),2) end as per_no_of_del
,null as no_of_del_rank
,sum(expected_inst_del) as expected_inst_del
,sum(inst_del) as inst_del
,case when sum(no_of_del) = 0 then 0 else round(sum(inst_del)*100.0/sum(no_of_del),2) end as per_inst_del
,null as inst_del_rank
,sum(expected_phi_del) as expected_phi_del
,sum(phi_del) as phi_del
,case when sum(inst_del) = 0 then 0 else round(sum(phi_del)*100.0/sum(inst_del),2) end as per_phi_del
,null as phi_del_rank
,sum(expected_home_del) as expected_home_del
,sum(home_del) as home_del
,case when sum(no_of_del) = 0 then 0 else round(sum(home_del)*100.0/sum(no_of_del),2) end as per_home_del
,null as home_del_rank
,sum(breast_feeding) as breast_feeding
,case when sum(inst_del) = 0 then 0 else round(sum(breast_feeding)*100.0/sum(inst_del),2) end as per_breast_feeding
,null as breast_feeding_rank
,sum(maternal_death) as maternal_death
,sum(expected_mmr) as expected_mmr
,case when sum(live_birth) = 0 then 0 else round(sum(maternal_death)*100000.0/sum(live_birth),2) end as expected_no_mmr
,sum(expected_maternal_death) as expected_maternal_death
,null as expected_no_mmr_rank
,case when sum(expected_mmr) = 0 then 0 else round(cast(sum(maternal_death)*100.0/sum(expected_mmr) as numeric ),2) end as per_maternal_death
,null as maternal_death_rank
,sum(high_risk_mother_2nd_trimester) as high_risk_mother_2nd_trimester
,sum(total_beneficiary_under_pmsma) as total_beneficiary_under_pmsma
,case when sum(high_risk_mother_2nd_trimester) = 0 then 0 else round(sum(total_beneficiary_under_pmsma)*100.0/sum(high_risk_mother_2nd_trimester) ,2) end as per_total_beneficiary_under_pmsma
,null as pmsma_rank
,sum(infant_death) as infant_death
,sum(expected_imr) as expected_imr
,sum(expected_infant_death) as expected_infant_death
,case when sum(live_birth) = 0 then 0 else round(sum(infant_death)*1000.0/sum(live_birth),2) end as expected_no_imr
,case when sum(expected_imr) = 0 then 0 else round(cast(sum(infant_death)*100.0/sum(expected_imr) as numeric ),2) end as per_imr
,null as imr_rank
, null as expected_imr_rank
,sum(del_less_eq_34) as del_less_eq_34
,sum(cortico_steroid) as cortico_steroid
,sum(expected_cortico_steroid) as expected_cortico_steroid
,case when sum(del_less_eq_34) = 0 then 0 else round(sum(cortico_steroid)*100.0/sum(del_less_eq_34) ,2) end as per_cortico_steroid
,null as cortico_steroid_rank
,sum(live_birth) as live_birth
,sum(expected_child_reg) as expected_child_reg
,case when sum(expected_delivery_reg) = 0 then 0 else round(cast(sum(live_birth)*100.0/sum(expected_delivery_reg) as numeric ),2) end as per_live_birth
,null as live_birth_rank
,sum(weighed) as weighed
,sum(weighed_less_than_2_5) as weighed_less_than_2_5
,sum(expected_weighed) as expected_weighed
,case when sum(live_birth) = 0 then 0 else round(sum(weighed)*100.0/sum(live_birth) ,2) end as per_weighed
,null as weighed_rank
,sum(expected_lbw) as expected_lbw
,case when sum(live_birth) = 0 then 0 else round(sum(weighed_less_than_2_5)*100.0/(0.135*sum(live_birth)) ,2) end as per_lbw
,null as lbw_rank
,sum(expected_fully_immu) as expected_fully_immu
,sum(fully_immunized) as fully_immunized
,case when sum(expected_fully_immu) = 0 then 0 else round(cast(sum(fully_immunized)*100.0/sum(expected_fully_immu) as numeric ),2) end as per_fully_immu
,null as fully_immu_rank
,sum(total_male) as total_male
,sum(total_female) as total_female
,case when sum(total_male) = 0 then 0 else round(sum(total_female)*1000.0/sum(total_male) ,2) end as per_sex_ratio
,null as sex_ratio_rank
,sum(ppiucd) as ppiucd
,sum(expected_ppiucd) as expected_ppiucd
,case when sum(phi_del) = 0 then 0 else round(sum(ppiucd)*100.0/sum(phi_del) ,2) end as per_ppiucd
,null as ppiucd_rank
,sum(total_0_to_5_child) as total_0_to_5_child
,sum(total_screened_for_malnutition) as total_screened_for_malnutition
,case when sum(total_0_to_5_child) = 0 then 0 else round(sum(total_screened_for_malnutition)*100.0/sum(total_0_to_5_child) ,2) end as per_total_anemic_malnutrition_treated
,null as total_anemic_malnutrition_rank
,sum(total_sam_child) as total_sam_child
,case when sum(total_screened_for_malnutition) = 0 then 0 else round(sum(total_sam_child)*100.0/sum(total_screened_for_malnutition) ,2) end as per_total_sam_malnutrition
,null as per_total_sam_malnutrition_rank
,sum(total_anemic) as total_anemic
,case when sum(anc_reg) = 0 then 0 else round(sum(total_anemic)*100.0/sum(anc_reg) ,2) end as per_total_anemic
,null as total_anemic_rank
,sum(expected_anemic_pw) as expected_anemic_pw
,sum(total_severe_anemic) as total_severe_anemic
,case when sum(anc_reg) = 0 then 0 else round(sum(total_severe_anemic)*100.0/(0.015*sum(anc_reg)) ,2) end as per_total_sever_anemic
, null as total_sever_anemic_rank
,sum(total_severe_anemic_treated) as total_severe_anemic_treated
,sum(expected_severe_anemic_treated) as expected_severe_anemic_treated
,case when sum(total_severe_anemic) = 0 then 0 else round(sum(total_severe_anemic_treated)*100.0/sum(total_severe_anemic) ,2) end as per_total_anemic_treated
,null as total_anemic_treated_rank
,sum(expected_anc4) as expected_anc4
,sum(anc4) as anc4
,case when sum(early_anc) = 0 then 0 else round(sum(anc4)*100.0/sum(early_anc) ,2) end as per_anc4
,null as per_anc4_rank
,sum(c_section_delivery) as c_section_delivery
,sum(expected_c_section_delivery) as expected_c_section_delivery
,case when sum(no_of_del) = 0 then 0 else round(sum(c_section_delivery)*100.0/sum(no_of_del) ,2) end as per_c_section_delivery
,null as c_section_delivery_rank
from rch_dashboard_analytics
where financial_year = #financial_year#', 
null, 
true, 'ACTIVE');