INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'referredOn', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Diagnostic Report', NULL, 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Laboratory report', NULL, 'NCD_DIAGNOSTIC_GENERAL', true, '4241000179101', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:DiagnosticReport.section', 'Laboratory report (General)', NULL, 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:CodeableConcept', 'General', NULL, 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Category', 'Laboratory', NULL, 'NCD_DIAGNOSTIC_GENERAL', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Category of Assessment', 'Category', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Followup place', 'FollowupPlace', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'FollowUp Date', 'FollowUpDate', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Refferal place', 'RefferalPlace', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Symptoms', 'Symptoms', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Clinical Observation', 'ClinicalObservation', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Diagnosis', 'Diagnosis', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Remarks', 'Remarks', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Conclusion', 'Treatment Status', 'TreatmentStatus', 'NCD_DIAGNOSTIC_GENERAL', true, NULL, 'Text', NULL);



delete from hi_type_query_builder_mapper where hi_type_code = 'NCD_DIAGNOSTIC_GENERAL';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('NCD_DIAGNOSTIC_GENERAL', 'get_fhir_ncd_diagnostic_general', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_ncd_diagnostic_general';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c53dbea7-f0c0-4162-a8fb-534dab27bc1f', -1,  current_date , -1,  current_date , 'get_fhir_ncd_diagnostic_general',
'serviceId',
'with ncd_general_detail as(
	select * from ncd_member_general_detail where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	ngd.screening_date as "referredOn",
	ngd.category as "Category",
	ngd.followup_place as "FollowupPlace",
	ngd.followup_date as "FollowUpDate",
	ngd.refferal_place as "RefferalPlace",
	ngd.symptoms as "Symptoms",
	ngd.clinical_observation as "ClinicalObservation",
	ngd.diagnosis as "Diagnosis",
	ngd.remarks as "Remarks",
	CASE
        WHEN ngd.treatment_status IS NOT NULL THEN concat(''Treatment Status :- '', ngd.treatment_status)
        ELSE NULL
    END as "TreatmentStatus",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from ncd_general_detail ngd
inner join imt_member im on ngd.member_id = im.id
left join um_user uu on uu.id = ngd.created_by
left join health_infrastructure_details hid on hid.id = ngd.health_infra_id
left join location_master lm on lm.id = hid.location_id;',
'To get all the related field to generate fhir for NCD Diagnostic General',
true, 'ACTIVE');