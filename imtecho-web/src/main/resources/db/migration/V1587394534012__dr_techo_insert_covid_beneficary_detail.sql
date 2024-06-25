ALTER table covid_travellers_info
drop column if exists in_contact_with_covid19_paitent,
ADD COLUMN in_contact_with_covid19_paitent character varying(30);


DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_insert_covid_beneficary_detail';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
409,  current_date , 409,  current_date , 'dr_techo_insert_covid_beneficary_detail',
'is_travel,gender,is_shortness_of_breath,travel_details,is_cough,is_fever,pincode,travel_to,address,is_sari,travel_date,created_by,other_symtoms,is_respiratory_issue,travel_mode,travel_from,contact_with_other_traveler,name,suggest_covid_test,is_travel_from_other_country,district_id,mobile_number,age,country_id,in_contact_with_covid19_paitent',
'INSERT INTO covid_travellers_info
("name", address, pincode, is_active, age, gender, country, mobile_number,
status, input_type, is_cough, is_fever,is_sari, is_shortness_of_breath, is_respiratory_issue,
other_symptoms, travel_date, is_travel_from_other_country, created_by, created_on, modified_by,
modified_on,travel_from,travel_to,travel_details,travel_mode,suggest_covid_test,contact_with_other_traveler,in_contact_with_covid19_paitent,is_travel,district_id)
VALUES(''#name#''
, (case when ''#address#'' = ''null'' then null else ''#address#'' end)
, (case when #pincode# = null then 0 else #pincode# end)
,true
,(case when ''#age#'' = ''null'' then null else #age# end)
,(case when ''#gender#'' = ''null'' then null else ''#gender#'' end)
,(select value from listvalue_field_value_detail where id = #country_id#)
,(case when ''#mobile_number#'' = ''null'' then null else ''#mobile_number#'' end)
,''ACTIVE''
,''DR_TECHO''
,(case when ''#is_cough#'' = ''null'' then cast(null as boolean) else #is_cough# end)
,(case when ''#is_fever#'' = ''null'' then cast(null as boolean) else #is_fever# end)
,(case when ''#is_sari#'' = ''null'' then cast(null as boolean) else #is_sari# end)
,(case when ''#is_shortness_of_breath#'' = ''null'' then cast(null as boolean) else #is_shortness_of_breath# end)
,(case when ''#is_respiratory_issue#'' = ''null'' then cast(null as boolean) else #is_respiratory_issue# end)
,(case when ''#other_symtoms#'' = ''null'' then null else ''#other_symtoms#'' end)
,(case when ''#travel_date#'' = ''null'' then null else cast(case when ''#travel_date#'' = ''null'' then null else ''#travel_date#'' end  as timestamp)  end)
,(case when ''#is_travel_from_other_country#'' = ''null'' then cast(null as boolean) else #is_travel_from_other_country# end)
,(case when ''#created_by#'' = ''null'' then null else #created_by# end)
,now()
,(case when ''#created_by#'' = ''null'' then null else #created_by# end)
,now()
,(case when ''#travel_from#'' = ''null'' then null else ''#travel_from#'' end)
,(case when ''#travel_to#'' = ''null'' then null else ''#travel_to#'' end)
,(case when ''#travel_details#'' = ''null'' then null else ''#travel_details#'' end)
,(case when ''#travel_mode#'' = ''null'' then null else ''#travel_mode#'' end)
,(case when ''#suggest_covid_test#'' = ''null'' then cast(null as boolean) else #suggest_covid_test# end)
,(case when ''#contact_with_other_traveler#'' = ''null'' then cast(null as boolean) else #contact_with_other_traveler# end)
,(case when ''#in_contact_with_covid19_paitent#'' = ''null'' then null else ''#in_contact_with_covid19_paitent#'' end)
,(case when ''#is_travel#'' = ''null'' then cast(null as boolean) else #is_travel# end)
,(case when ''#district_id#'' = ''null'' then null else #district_id# end)
);',
null,
false, 'ACTIVE');