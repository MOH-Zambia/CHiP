--Patient Details (common for all Hi types)
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Patient.Name.text', 'Name', 'PatientFullName', NULL, true, NULL, 'Text', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Patient.gender', 'Gender', 'Gender', NULL, true, NULL, 'Text', 'KV');
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:subject:Patient.identifier.id', 'Unique Health Id', 'PatientUniqueHealthId', NULL, true, NULL, 'Text', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Patient.telecom.value', 'Contact Details', 'PatientMobileNumber', NULL, true, NULL, 'Narrative', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Patient.maritalStatus', 'Marital Status', 'PatientMaritalStatus', NULL, true, 'MULTIPLE', 'CodeableConcept', 'FVB');
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Patient.birthDate', 'Birth Date', 'PatientDob', NULL, true, NULL, 'date', NULL);

--Practitioner Details (name)
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Practitioner', 'Name', 'PractitionerFullName', NULL, true, NULL, 'HumanName', NULL);

--Organization Details
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.name', 'Name', 'HealthInfraName', NULL, true, NULL, 'Text', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.identifier', 'HFR Facility Id', 'HfrFacilityId', NULL, true, NULL, 'Identifier', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.telecom', 'Mobile Number', 'HealthInfraMobileNumber', NULL, true, NULL, 'ContactPoint', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.address.line', 'Address', 'HealthInfraAddress', NULL, true, NULL, 'Text', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.address.city', 'City', 'HealthInfraCityName', NULL, true, NULL, 'Text', NULL);
INSERT INTO fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Subject:Organization.address.postalCode', 'Postal Code', 'HealthInfraPostalCode', NULL, true, NULL, 'Text', NULL);


--**** For ANC_WELLNESS_RECORD ****
--For Composition Date (service_date) and Title of FHIR --
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'ANC Wellness Record', NULL, 'ANC_WELLNESS_RECORD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'ServiceDate', 'ANC_WELLNESS_RECORD', true, NULL, 'dateTime', NULL);


INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationLifestyle:Observation.text', 'Diastolic Bp (mm Hg)', 'DiastolicBp', 'ANC_WELLNESS_RECORD', true, '271650006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationLifestyle:Observation.text', 'Systolic Bp (mm Hg)', 'SystolicBp', 'ANC_WELLNESS_RECORD', true, '271649006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationBodyMeasurement:Observation.text', 'Member weight (kg)', 'MemberWeight', 'ANC_WELLNESS_RECORD', true, '27113001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationBodyMeasurement:Observation.text', 'Member height (kg)', 'MemberHeight', 'ANC_WELLNESS_RECORD', true, '50373000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'Non Empty Stomach Blood Sugar Test Value', 'SugarTestAfterFoodValue', 'ANC_WELLNESS_RECORD', true, '36048009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'Empty Stomach Blood Sugar Test Value', 'SugarTestBeforeFoodValue', 'ANC_WELLNESS_RECORD', true, '50373000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'hbsag test', 'HbsagTest', 'ANC_WELLNESS_RECORD', true, '22290004', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'Blood sugar test', 'BloodSugarTest', 'ANC_WELLNESS_RECORD', true, '33747003', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'Vdrl test', 'VdrlTest', 'ANC_WELLNESS_RECORD', true, '28902003', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'Sickle cell test', 'SickleCellTest', 'ANC_WELLNESS_RECORD', true, '160320002', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationGeneralAssessment:Observation.text', 'HIV test', 'HivTest', 'ANC_WELLNESS_RECORD', true, '266974005', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:ObservationWomenHealth:Observation.text', 'Date of last menstrual period', 'Lmp', 'ANC_WELLNESS_RECORD', true, '21840007', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Foetal Height', 'FoetalHeight', 'ANC_WELLNESS_RECORD', true, '27113001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Foetal Heart sound', 'FoetalHeartSound', 'ANC_WELLNESS_RECORD', true, '23472005', 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Foetal Movement', 'FoetalMovement', 'ANC_WELLNESS_RECORD', true, '32279003', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Foetal Position', 'FoetalPosition', 'ANC_WELLNESS_RECORD', true, '386811000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Urine Albumin', 'UrineAlbumin', 'ANC_WELLNESS_RECORD', true, '271000000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Urine Sugar', 'UrineSugar', 'ANC_WELLNESS_RECORD', true, '268556000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Haemoglobin Count', 'HaemoglobinCount', 'ANC_WELLNESS_RECORD', true, '104091002', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Blood Group', 'BloodGroup', 'ANC_WELLNESS_RECORD', true, '365636006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Expected delivery place', 'ExpectedDeliveryPlace', 'ANC_WELLNESS_RECORD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Family Planning Method', 'FamilyPlanningMethod', 'ANC_WELLNESS_RECORD', true, '13197004', 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Delivery Place', 'DeliveryPlace', 'ANC_WELLNESS_RECORD', true, NULL, 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'type of hospital', 'TypeOfHospital', 'ANC_WELLNESS_RECORD', true, NULL, 'Text', 'FVB');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Delivery done by', 'DeliveryDoneBy', 'ANC_WELLNESS_RECORD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Blood Transfusion', 'BloodTransfusion', 'ANC_WELLNESS_RECORD', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Iron def Anemia Injection', 'IronDefAnemiaInj', 'ANC_WELLNESS_RECORD', true, '87522002', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'iron def Injection Due Date', 'IronDefAnemiaInjDueDate', 'ANC_WELLNESS_RECORD', true, '87522002', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Number of Calcium Tablets Given', 'CalciumTabletsGiven', 'ANC_WELLNESS_RECORD', true, '5540006', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:OtherObservations:Observation.text', 'Number of IFA Tablets Given', 'IfaTabletsGiven', 'ANC_WELLNESS_RECORD', true, '199248002', 'Text', NULL);





delete from hi_type_query_builder_mapper where hi_type_code = 'ANC_WELLNESS_RECORD';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('ANC_WELLNESS_RECORD', 'get_fhir_anc_wellness_record', true);

DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_anc_wellness_record';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'69c7847e-f7b4-403f-ac5e-742c4d676cac', 97071,  current_date , 97071,  current_date , 'get_fhir_anc_wellness_record',
'serviceId',
'with rch_anc_details as (
	select ram.*  from rch_anc_master ram where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	rad.service_date as "ServiceDate",
	rad.diastolic_bp as "DiastolicBp",
	rad.systolic_bp as "SystolicBp",
	rad.weight as "MemberWeight",
	rad.member_height as "MemberHeight",
	rad.sugar_test_after_food_val as "SugarTestAfterFoodValue",
	rad.sugar_test_before_food_val as "SugarTestBeforeFoodValue",
	rad.hbsag_test as "HbsagTest",
	rad.blood_sugar_test as "BloodSugarTest",
	rad.vdrl_test as "VdrlTest",
	rad.sickle_cell_test as "SickleCellTest",
	rad.hiv_test as "HivTest",
	rad.lmp as "Lmp",
	rad.foetal_height as "FoetalHeight",
	rad.foetal_heart_sound as "FoetalHeartSound",
	rad.foetal_movement as "FoetalMovement",
	rad.foetal_position as "FoetalPosition",
	rad.urine_albumin as "UrineAlbumin",
	rad.urine_sugar as "UrineSugar",
	rad.haemoglobin_count as "HaemoglobinCount",
	rad.blood_group as "BloodGroup",
	rad.expected_delivery_place as "ExpectedDeliveryPlace",
	rad.family_planning_method as "FamilyPlanningMethod",
	rad.delivery_place as "DeliveryPlace",
	rad.type_of_hospital as "TypeOfHospital",
	rad.delivery_done_by as "DeliveryDoneBy",
	rad.blood_transfusion as "BloodTransfusion",
	rad.iron_def_anemia_inj as "IronDefAnemiaInj",
	rad.iron_def_anemia_inj_due_date as "IronDefAnemiaInjDueDate",
	rad.calcium_tablets_given as "CalciumTabletsGiven",
	rad.ifa_tablets_given as "IfaTabletsGiven",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from rch_anc_details rad
inner join imt_member im on im.id  = rad.member_id
left join um_user uu on uu.id = rad.created_by
left join health_infrastructure_details hid on hid.id = coalesce(rad.health_infrastructure_id, rad.hmis_health_infra_id)
left join location_master lm on lm.id = hid.location_id ;',
'To get all the related field to generate fhir for ANC Wellness Record',
true, 'ACTIVE');

