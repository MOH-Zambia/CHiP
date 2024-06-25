INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'referredOn', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'Diagnostic Report', NULL, 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Laboratory report', NULL, 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, '4241000179101', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:DiagnosticReport.section', 'Laboratory report (Initial Assessment)', NULL, 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:CodeableConcept', 'Initial Assessment', NULL, 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Category', 'Laboratory', NULL, 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, 'laboratory', 'CodeableConcept', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Excess Thirst (Polydipsia)', 'ExcessThirst', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Excess Urination (Polyuria)', 'ExcessUrination', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Excess Hunger', 'ExcessHunger', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Recurrent skin/Genito-urinary infection', 'RecurrentSkinGUI', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Delayed Healing Of Wounds', 'DelayedHealingOfWounds', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Change In Dietary Habits', 'ChangeInDietaryHabits', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Sudden Visual Disturbances history or present', 'SuddenVisualDisturbances', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Significant Edema', 'SignificantEdema', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Breathlessness', 'Breathlessness', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Angina (Chest Pain)', 'Angina', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Intermittent Claudication', 'IntermittentClaudication', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Diagnostic:Observation.text', 'Limpness or lack of strength on one side of limbs', 'Limpness', 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', true, NULL, 'boolean', NULL);






delete from hi_type_query_builder_mapper where hi_type_code = 'NCD_DIAGNOSTIC_INITIAL_ASSESSMENT';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('NCD_DIAGNOSTIC_INITIAL_ASSESSMENT', 'get_fhir_ncd_diagnostic_initial_assessment', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_ncd_diagnostic_initial_assessment';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c58a660d-9d83-426a-abfb-08144fd386d6', -1,  current_date , -1,  current_date , 'get_fhir_ncd_diagnostic_initial_assessment',
'serviceId',
'with ncd_initial_assessments as(
	select * from ncd_member_initial_assessment_detail where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	nia.screening_date as "referredOn",
	nia.excess_thirst as "ExcessThirst",
	nia.excess_urination as "ExcessUrination",
	nia.excess_hunger as "ExcessHunger",
	nia.recurrent_skin_gui as "RecurrentSkinGUI",
	nia.delayed_healing_of_wounds as "DelayedHealingOfWounds",
	nia.change_in_dietary_habits as "ChangeInDietaryHabits",
	nia.sudden_visual_disturbances as "SuddenVisualDisturbances",
	nia.significant_edema as "SignificantEdema",
	nia.breathlessness as "Breathlessness",
	nia.angina as "Angina",
	nia.intermittent_claudication as "IntermittentClaudication",
	nia.limpness as "Limpness",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from ncd_initial_assessments nia
inner join imt_member im on nia.member_id = im.id
left join um_user uu on uu.id = nia.created_by
left join health_infrastructure_details hid on hid.id = nia.health_infra_id
left join location_master lm on lm.id = hid.location_id',
'To get all the related field to generate fhir for  NCD Diagnostic Initial Assessment',
true, 'ACTIVE');