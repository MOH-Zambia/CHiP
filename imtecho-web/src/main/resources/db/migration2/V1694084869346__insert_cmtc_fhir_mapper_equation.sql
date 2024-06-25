INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Discharge Summary Record (CMTC)', NULL, 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'DischargeDate', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Discharge summary', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '373942005', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Body weight (Kg)', 'WeightAtAdmission', 'CMTC_DISCHARGE_SUMMARY', true, '27113001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Mid upper arm circumference (cm)', 'MidUpperArmCircumference', 'CMTC_DISCHARGE_SUMMARY', true, '284473002', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Edema of foot', 'BilateralPittingOedema', 'CMTC_DISCHARGE_SUMMARY', true, '102576009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'SD score', 'SdScore', 'CMTC_DISCHARGE_SUMMARY', true, '386136009', 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Value:Loop:Condition.section:{Child Illness}', 'Illness', 'childIllness', 'CMTC_DISCHARGE_SUMMARY', true, NULL, NULL, NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:DiagnosticReport', 'Laboratory report', NULL, 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:CodeableConcept', 'Laboratory report (CMTC)', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '15220000', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Category', 'Laboratory', NULL, 'CMTC_DISCHARGE_SUMMARY', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Hemoglobin in Blood', 'Hemoglobin', 'CMTC_DISCHARGE_SUMMARY', true, '38082009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Urine R/M', 'UrinePusCells', 'CMTC_DISCHARGE_SUMMARY', true, '38082009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Urine Albumin', 'UrineAlbumin', 'CMTC_DISCHARGE_SUMMARY', true, '46716003', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'HIV', 'Hiv', 'CMTC_DISCHARGE_SUMMARY', true, '86406008', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Sickle', 'Sickle', 'CMTC_DISCHARGE_SUMMARY', true, '127040003', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'PS For MP', 'PsForMp', 'CMTC_DISCHARGE_SUMMARY', true, '61462000', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'PS For MP Value', 'PsForMpValue', 'CMTC_DISCHARGE_SUMMARY', true, '61462000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Mantoux', 'MonotouxTest', 'CMTC_DISCHARGE_SUMMARY', true, '298014004', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'X-Ray', 'XrayChest', 'CMTC_DISCHARGE_SUMMARY', true, '168731009', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:Observation.text', 'Blood Group', 'BloodGroup', 'CMTC_DISCHARGE_SUMMARY', true, '44608003', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Diagnostic:IssueDate', 'Laboratory Date', 'LaboratoryDate', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'date', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:CarePlan.section', 'Care plan', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '734163000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:CarePlan.Category', 'Assessment of nutritional status', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '1759002', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:CarePlan.Title', 'Assessment of nutritional status', 'CarePlanTitle', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:CarePlan.Description', 'Maximum 3 follow up visits will be planned in 15 days gap in order to assessment of nutritional status', 'CarePlanDescription', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:CarePlan.Status', 'Care Plan Status', 'CarePlanStatus', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.Status', 'Appointment Status', NULL, 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.ServiceCategory', 'Child Care /Kindergarten', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '4', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.ServiceType', 'Nutrition', NULL, 'CMTC_DISCHARGE_SUMMARY', true, '60', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.AppointmentType', 'Follow-up visit', NULL, 'CMTC_DISCHARGE_SUMMARY', true, 'FOLLOWUP', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.Description', 'Assessment of nutritional status', NULL, 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.Start', 'Appointment Start', 'FollowUpDate', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'date', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:Appointment.End', 'Appointment End', 'FollowUpDate', 'CMTC_DISCHARGE_SUMMARY', true, NULL, 'date', NULL);


delete from hi_type_query_builder_mapper where hi_type_code = 'CMTC_DISCHARGE_SUMMARY';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('CMTC_DISCHARGE_SUMMARY', 'get_fhir_cmtc_discharge_summary', true);

DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_cmtc_discharge_summary';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7ce9369c-3e4d-4b49-8d40-737fe5da81b7', -1,  current_date , -1,  current_date , 'get_fhir_cmtc_discharge_summary',
'serviceId',
'with child_cmtc_admission_details as(
	select * from child_cmtc_nrc_admission_detail where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	ccndd.discharge_date  as "DischargeDate",
	cmad.weight_at_admission as "WeightAtAdmission",
	cmad.mid_upper_arm_circumference as "MidUpperArmCircumference",
	cmad.bilateral_pitting_oedema as "BilateralPittingOedema",
	cmad.sd_score as "SdScore",
	STRING_AGG(distinct cast(cmnraid.illness  as text), '','') as "childIllness",
	case when
		count(ccnfu.*) = 3 then ''COMPLETED''
	else ''ACTIVE''
	end as "CarePlanStatus",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from child_cmtc_admission_details cmad
inner join imt_member im on im.id = cmad.child_id
inner join child_cmtc_nrc_discharge_detail ccndd on ccndd.admission_id  = cmad.id
left join child_cmtc_nrc_admission_illness_detail cmnraid on cmnraid.admission_id = cmad.id
left join um_user uu on uu.id = cmad.created_by
left join health_infrastructure_details hid on hid.id = cmad.screening_center
left join location_master lm on lm.id = hid.location_id
left join child_cmtc_nrc_follow_up ccnfu on ccnfu.admission_id = cmad.id
group by uu.first_name,uu.middle_name, uu.last_name, im.dob, im.first_name, im.middle_name, im.last_name,
im.gender, im.unique_health_id, im.mobile_number, im.marital_status,
ccndd.discharge_date, cmad.weight_at_admission, cmad.weight_at_admission, cmad.mid_upper_arm_circumference,
cmad.bilateral_pitting_oedema, cmad.sd_score,
lm.english_name, hid.name_in_english, hid.name, hid.hfr_facility_id, hid.mobile_number, hid.contact_number,
hid.address, hid.postal_code;',
'To get all the related field to generate fhir for CMTC Discharge Summary',
true, 'ACTIVE');