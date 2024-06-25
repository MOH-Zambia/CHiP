ALTER TABLE covid_travellers_info
ADD COLUMN is_travel_from_other_country BOOLEAN;

ALTER TABLE covid_travellers_info
RENAME COLUMN is_travel_from_other_country TO is_travel;        
ALTER TABLE covid_travellers_info ALTER COLUMN is_travel TYPE BOOLEAN USING is_travel::boolean;

ALTER TABLE covid_travellers_info
ADD COLUMN is_travel_from_other_country BOOLEAN,
ADD COLUMN contact_with_other_traveler BOOLEAN;

ALTER TABLE covid_travellers_info
ADD COLUMN is_sari BOOLEAN;

ALTER TABLE covid_travellers_info ALTER COLUMN travel_date TYPE timestamp USING cast(travel_date as timestamp);

delete  from query_master qm where qm.code = 'dr_techo_insert_covid_beneficary_detail';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(409,'2020-03-21 17:43:28.852',80208,'2020-03-26 21:02:39.174','dr_techo_insert_covid_beneficary_detail','is_travel,pincode,travel_to,address,gender,is_shortness_of_breath,travel_date,created_by,other_symtoms,travel_details,is_respiratory_issue,travel_mode,travel_from,contact_with_other_traveler,name,suggest_covid_test,is_travel_from_other_country,district_id,mobile_number,age,country_id,is_cough,is_fever','INSERT INTO covid_travellers_info
("name", address, pincode, is_active, age, gender, country, mobile_number, 
status, input_type, is_cough, is_fever,is_sari, is_shortness_of_breath, is_respiratory_issue, 
other_symptoms, travel_date, is_travel_from_other_country, created_by, created_on, modified_by,
modified_on,travel_from,travel_to,travel_details,travel_mode,suggest_covid_test,contact_with_other_traveler,is_travel,district_id)
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
,(case when ''#travel_date#'' = ''null'' then null else cast( ''#travel_date#'' as timestamp)  end)
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
,(case when ''#is_travel#'' = ''null'' then cast(null as boolean) else #is_travel# end)
,(case when ''#district_id#'' = ''null'' then null else #district_id# end)
);',false,'ACTIVE',NULL,NULL)
;
delete  from query_master qm where qm.code = 'dr_techo_get_location_by_parent_id_and_type';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(80208,'2020-03-26 11:20:23.898',80208,now(),'dr_techo_get_location_by_parent_id_and_type','types,parent_id','select lm.english_name as "name" , lm.id as "locationId"
from location_hierchy_closer_det lhcd 
inner join location_master lm on lm.id = lhcd.child_id 
where  lm."type" in (#types#) and lm.state = ''ACTIVE'' and (#parent_id# is null or parent_id = #parent_id# ) group by lm.id ;',true,'ACTIVE',NULL,true)
;