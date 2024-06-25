INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'referredOn', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Diagnostic Report', NULL, 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Laboratory report', NULL, 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, '4241000179101', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:DiagnosticReport.section', 'Laboratory report (Mental Health)', NULL, 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:CodeableConcept', 'Mental Health', NULL, 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Category', 'Laboratory', NULL, 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Examination of Talk out of 4', 'Talk', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Examination of own daily work out of 4', 'OwnDailyWork', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Examination of social work out of 4', 'SocialWork', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Examination of understanding out of 4', 'Understanding', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Conclusion', 'Treatment Status', 'TreatmentStatus', 'NCD_DIAGNOSTIC_MENTAL_HEALTH', true, NULL, 'Text', NULL);


delete from hi_type_query_builder_mapper where hi_type_code = 'NCD_DIAGNOSTIC_MENTAL_HEALTH';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('NCD_DIAGNOSTIC_MENTAL_HEALTH', 'get_fhir_ncd_diagnostic_mental_health', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_ncd_diagnostic_mental_health';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3e8722af-a128-4cde-9c2f-bcd073f6fb6d', -1,  current_date , -1,  current_date , 'get_fhir_ncd_diagnostic_mental_health',
'serviceId',
'with ncd_mental_health_detail as(
	select * from ncd_member_mental_health_detail where id =  #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	nmhd.screening_date as "referredOn",
	nmhd.talk as "Talk",
	nmhd.own_daily_work as "OwnDailyWork",
	nmhd.social_work as "SocialWork",
	nmhd.understanding as "Understanding",
	CASE
        WHEN nmhd.treatment_status IS NOT NULL THEN concat(''Treatment Status :- '', nmhd.treatment_status)
        ELSE NULL
    END as "TreatmentStatus",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from ncd_mental_health_detail nmhd
inner join imt_member im on nmhd.member_id = im.id
left join um_user uu on uu.id = nmhd.created_by
left join health_infrastructure_details hid on hid.id = nmhd.health_infra_id
left join location_master lm on lm.id = hid.location_id;',
'To get all the related field to generate fhir for NCD Diagnostic Mental Health',
true, 'ACTIVE');