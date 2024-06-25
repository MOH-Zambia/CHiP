INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'referredOn', 'NCD_DIAGNOSTIC_HYPERTENSION', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Diagnostic Report', NULL, 'NCD_DIAGNOSTIC_HYPERTENSION', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Laboratory report', NULL, 'NCD_DIAGNOSTIC_HYPERTENSION', true, '4241000179101', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:DiagnosticReport.section', 'Laboratory report (Hypertension)', NULL, 'NCD_DIAGNOSTIC_HYPERTENSION', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:CodeableConcept', 'Hypertension', NULL, 'NCD_DIAGNOSTIC_HYPERTENSION', true, '38341003', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Category', 'Laboratory', NULL, 'NCD_DIAGNOSTIC_HYPERTENSION', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Heart Rate (BPM)', 'PulseRate', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '301113001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Diastolic BP (mmHg)', 'DiastolicBp', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '271650006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'is Regular Rythm?', 'IsRegularRythm', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '49260003', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Murmur', 'Murmur', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '88610006', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Bilateral clear', 'BilateralClear', 'NCD_DIAGNOSTIC_HYPERTENSION', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Bilateral Basal Crepitation', 'BilateralBasalCrepitation', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '284520004', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Rhonchi', 'Rhonchi', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '24612001', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Systolic Bp (mmHg)', 'SystolicBp', 'NCD_DIAGNOSTIC_HYPERTENSION', true, '271649006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Conclusion', 'Treatment Status', 'TreatmentStatus', 'NCD_DIAGNOSTIC_HYPERTENSION', true, NULL, 'Text', NULL);


delete from hi_type_query_builder_mapper where hi_type_code = 'NCD_DIAGNOSTIC_HYPERTENSION';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('NCD_DIAGNOSTIC_HYPERTENSION', 'get_fhir_ncd_diagnostic_hypertension', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_ncd_diagnostic_hypertension';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'09eee8f9-8022-49b7-a921-d0681f5e0c74', -1,  current_date , -1,  current_date , 'get_fhir_ncd_diagnostic_hypertension',
'serviceId',
'with ncd_hypertension_detail as(
	select * from ncd_member_hypertension_detail where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	nhd.screening_date as "referredOn",
	nhd.pulse_rate as "PulseRate",
	nhd.diastolic_bp as "DiastolicBp",
	nhd.is_regular_rythm as "IsRegularRythm",
	nhd.murmur as "Murmur",
	nhd.bilateral_clear as "BilateralClear",
	nhd.bilateral_basal_crepitation as "BilateralBasalCrepitation",
	nhd.rhonchi as "Rhonchi",
	nhd.systolic_bp as "SystolicBp",
	CASE
        WHEN nhd.treatment_status IS NOT NULL THEN concat(''Treatment Status :- '', nhd.treatment_status)
        ELSE NULL
    END as "TreatmentStatus",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from ncd_hypertension_detail nhd
inner join imt_member im on nhd.member_id = im.id
left join um_user uu on uu.id = nhd.created_by
left join health_infrastructure_details hid on hid.id = nhd.health_infra_id
left join location_master lm on lm.id = hid.location_id;',
'To get all the related field to generate fhir for NCD Diagnostic Hypertension',
true, 'ACTIVE');
