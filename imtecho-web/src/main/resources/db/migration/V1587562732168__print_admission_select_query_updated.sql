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
to_char(clt.date_of_onset_symptom,''DD/MM/YYYY'') as "onsetDate",
to_char(clt.discharge_date,''DD/MM/YYYY'') as "dischargeDate",
to_char(current_timestamp,''DD/MM/YYYY'') as "currentDate",
to_char(clt.admission_date,''DD/MM/YYYY'') as "admissionDate",
CASE WHEN clt.discharge_date IS NULL THEN DATE_PART(''day'',current_timestamp - clt.admission_date) 
ELSE DATE_PART(''day'',clt.discharge_date - clt.admission_date) END as "days",
clt.unit_no as "unitNumber",
hiwd.ward_name as "wardName",
clt.current_bed_no as "bedNumber",
clt.status as "status",
concat(clt.emergency_contact_name,'' ('',clt.emergency_contact_no,'')'') as "emergencyDetails",
case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , '' '' , imt_member.family_id) end as "name",
clt.age as "age",
hid.name_in_english as "hospital_name"
from covid19_admission_detail clt
left join imt_member on clt.member_id = imt_member.id
left join imt_family on imt_member.family_id = imt_family.family_id
left join health_infrastructure_details hid on clt.health_infra_id = hid.id 
left join health_infrastructure_ward_details hiwd on clt.current_ward_id = hiwd.id
where clt.id =  ''#admissionId#''', 
null, 
true, 'ACTIVE');