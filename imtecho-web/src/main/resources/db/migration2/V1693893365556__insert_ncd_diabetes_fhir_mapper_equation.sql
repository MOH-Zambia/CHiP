INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'referredOn', 'NCD_DIAGNOSTIC_DIABETES', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Diagnostic Report', NULL, 'NCD_DIAGNOSTIC_DIABETES', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Laboratory report', NULL, 'NCD_DIAGNOSTIC_DIABETES', true, '4241000179101', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:DiagnosticReport.section', 'Laboratory report (Diabetes)', NULL, 'NCD_DIAGNOSTIC_DIABETES', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:CodeableConcept', 'Diabetes', NULL, 'NCD_DIAGNOSTIC_DIABETES', true, '73211009', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Category', 'Laboratory', NULL, 'NCD_DIAGNOSTIC_DIABETES', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Blood sugar (in mg/dl)', 'BloodSugar', 'NCD_DIAGNOSTIC_DIABETES', true, '33747003', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Urine sugar level', 'UrineSugar', 'NCD_DIAGNOSTIC_DIABETES', true, '268556000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Is peripheral pulses present?', 'PeripheralPulses', 'NCD_DIAGNOSTIC_DIABETES', true, '78564009', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Fasting blood sugar level (in mg/dl)', 'FastingBloodSugar', 'NCD_DIAGNOSTIC_DIABETES', true, '52302001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Post prandial blood sugar level (in mg/dl)', 'PostPrandialBloodSugar', 'NCD_DIAGNOSTIC_DIABETES', true, '302788006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Hemoglobin level (in mg/dl)', 'Hba1c', 'NCD_DIAGNOSTIC_DIABETES', true, '38082009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Conclusion', 'Treatment Status', 'TreatmentStatus', 'NCD_DIAGNOSTIC_DIABETES', true, NULL, 'Text', NULL);


delete from hi_type_query_builder_mapper where hi_type_code = 'NCD_DIAGNOSTIC_DIABETES';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('NCD_DIAGNOSTIC_DIABETES', 'get_fhir_ncd_diagnostic_diabetes', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_ncd_diagnostic_diabetes';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'817af558-c10a-4a6f-ab6b-156051aabc30', -1,  current_date , -1,  current_date , 'get_fhir_ncd_diagnostic_diabetes',
'serviceId',
'with ncd_diabetes_detail as(
	select * from ncd_member_diabetes_detail where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	ndd.screening_date as "referredOn",
	ndd.blood_sugar as "BloodSugar",
	ndd.urine_sugar as "UrineSugar",
	ndd.peripheral_pulses as "PeripheralPulses",
	ndd.fasting_blood_sugar as "FastingBloodSugar",
	ndd.post_prandial_blood_sugar as "PostPrandialBloodSugar",
	ndd.hba1c as "Hba1c",
	CASE
        WHEN ndd.treatment_status IS NOT NULL THEN concat(''Treatment Status :- '', ndd.treatment_status)
        ELSE NULL
    END as "TreatmentStatus",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from ncd_diabetes_detail ndd
inner join imt_member im on ndd.member_id = im.id
left join um_user uu on uu.id = ndd.created_by
left join health_infrastructure_details hid on hid.id = ndd.health_infra_id
left join location_master lm on lm.id = hid.location_id;',
'To get all the related field to generate fhir for NCD Diagnostic Diabetes',
true, 'ACTIVE');