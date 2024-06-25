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
	cacd.health_status as health_status,
	cacd.is_xray as is_xray,
	cacd.xray_detail as xray_detail,
	cacd.is_ctscan as is_ctscan,
	cacd.ct_scan_detail as ct_scan_detail,
	cacd.is_ecg as is_ecg,
	cacd.ecg_detail as ecg_detail,
	cacd.is_serum_creatinine as is_serum_creatinine,
	cacd.serum_creatinine_detail as serum_creatinine_detail,
	cacd.is_sgpt as is_sgpt,
	cacd.sgpt_detail as sgpt_detail,
	cacd.is_h1n1_test as is_h1n1_test,
	cacd.h1n1_test_detail as h1n1_test_detail,
	cacd.blood_culture as blood_culture,
	cacd.blood_culture_detail as blood_culture_detail,
	cacd.is_g6pd as is_g6pd,
	cacd.g6pd_detail as g6pd_detail
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
, is_xray as "is_xray"
, xray_detail as "xray_detail"
, is_ctscan as "is_ctscan"
, ct_scan_detail as "ct_scan_detail"
, is_ecg as "is_ecg"
, ecg_detail as "ecg_detail"
, is_serum_creatinine as "is_serum_creatinine"
, serum_creatinine_detail as "serum_creatinine_detail"
, is_sgpt as "is_sgpt"
, sgpt_detail as "sgpt_detail"
, is_h1n1_test as "is_h1n1_test"
, h1n1_test_detail as "h1n1_test_detail"
, blood_culture as "blood_culture"
, blood_culture_detail as "blood_culture_detail"
, is_g6pd as "is_g6pd"
, g6pd_detail as "g6pd_detail"
from temp;', 
'this query is used to print the daily status of  patient', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_lab_test_for_admission_print';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
80251,  current_date , 80251,  current_date , 'covid19_get_lab_test_for_admission_print', 
'admissionId', 
'select
ltd.id as "id",
ltd.lab_collection_status as "lab_collection_status",
ltd.lab_collection_on as "lab_collection_on",
ltd.lab_sample_received_on as "lab_sample_received_on",
ltd.lab_result_entry_on as "lab_result_entry_on",
ltd.lab_result as "lab_result",
hid1.name_in_english as "sample_health_infra",
hid2.name_in_english as "sample_health_infra_send_to",
ltd.lab_sample_rejected_on as "lab_sample_rejected_on",
ltd.lab_sample_reject_reason as "lab_sample_reject_reason",
ltd.lab_test_number as "lab_test_number"
from covid19_lab_test_detail ltd
left join health_infrastructure_details hid1 on ltd.sample_health_infra = hid1.id
left join health_infrastructure_details hid2 on ltd.sample_health_infra_send_to = hid2.id
where ltd.covid_admission_detail_id  =  ''#admissionId#''', 
'this query is used for printing the admission details', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_admission_details_for_print';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_retrieve_admission_details_for_print', 
'admissionId', 
'select get_location_hierarchy_from_ditrict(clt.location_id) as "location",
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
			, '' ('' , imt_member.unique_health_id , '')'' , '' '' , imt_member.family_id) end as "name",
clt.admission_date as "admissionDate",
clt.age as "age",
hid.name_in_english as "hospital_name"
from covid19_admission_detail clt
left join imt_member on clt.member_id = imt_member.id
left join imt_family on imt_member.family_id = imt_family.family_id
left join health_infrastructure_details hid on clt.health_infra_id = hid.id
where clt.id =  ''#admissionId#''', 
null, 
true, 'ACTIVE');