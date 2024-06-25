DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_admitted_patient_daily_status_print';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
80251,  current_date , 80251,  current_date , 'covid19_get_admitted_patient_daily_status_print', 
'admissionId', 
'with temp as (
select
	cacd.id as "id",
	to_char(cacd.service_date,''DD/MM/YYYY'') as service_date,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	cacd.clinically_clear as clinically_clear,
	cacd.temperature as temperature,
	cacd.pulse_rate as pulse_rate,
	cacd.bp_systolic as bp_systolic,
	cacd.bp_dialostic as bp_dialostic,
	cacd.respiration_rate as respiration_rate,
	cacd.spo2 as spo2,
	cacd.azithromycin as azithromycin,
	cacd.hydroxychloroquine as hydroxychloroquine,
	cacd.oseltamivir as oseltamivir,
	cacd.antibiotics as antibiotics,
	cacd.health_status as health_status
	from covid19_admitted_case_daily_status cacd
	inner join covid19_admission_detail clt on clt.id = cacd.admission_id
	where
	cacd.admission_id =   ''#admissionId#''
	order by cacd.service_date
)
select 
id as "id" 
,service_date as "service_date"
,health_status as "health_status"
,on_ventilator as "on_ventilator"
,ventilator_type1 as "ventilator_type1"
,ventilator_type2 as "ventilator_type2"
,on_o2 as "on_o2"
,on_air as "on_air"
,remarks
,"temperature"
,"pulse_rate"
,"bp_systolic"
,"bp_dialostic"
,"respiration_rate"
,"spo2"
,"azithromycin"
,"hydroxychloroquine"
,"oseltamivir"
,"antibiotics"
from temp;', 
'this query is used to print the daily status of  patient', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_admission_details';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_retrieve_admission_details', 
'admissionId', 
'select get_location_hierarchy(clt.location_id) as "location",
clt.address as "address",
clt.pincode as "pincode",
clt.occupation as "occupation",
clt.travel_history as "travelHistory",
clt.is_abroad_in_contact as "abroadContact",
clt.in_contact_with_covid19_paitent as "covidPositiveContact",
clt.case_no as "caseNumber",
clt.opd_case_no as "opdCaseNumber",
clt.contact_number as "contactNumber",
clt.gender as "gender",
clt.is_fever as "fever",
clt.is_cough as "cough",
clt.is_breathlessness as "breathlessness",
clt.is_sari as "sari",
clt.is_hiv as "hiv",
clt.is_heart_patient as "heartPatient",
clt.is_diabetes as "diabetes",
clt.is_copd as "copd",
clt.is_hypertension as "hypertension",
clt.is_renal_condition as "renalCondition",
clt.is_immunocompromized as "immunocompromized",
clt.is_malignancy as "maligancy",
clt.date_of_onset_symptom as "onsetDate",
clt.unit_no as "unitNumber",
clt.status as "status",
concat(clt.emergency_contact_name,'' ('',clt.emergency_contact_no,'')'') as "emergencyDetails",
case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as "name",
clt.admission_date as "admissionDate",
clt.age as "age"
from covid19_admission_detail clt
left join imt_member on clt.member_id = imt_member.id
left join imt_family on imt_member.family_id = imt_family.family_id
where clt.id =  ''#admissionId#''', 
null, 
true, 'ACTIVE');