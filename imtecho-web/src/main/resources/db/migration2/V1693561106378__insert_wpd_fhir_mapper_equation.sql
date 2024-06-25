INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'DischargeOrDateOfDelivery', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'dateTime', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'WPD (Discharge Summary Record)', NULL, 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Discharge Summary', NULL, 'WPD_DISCHARGE_SUMMARY', true, '373942005', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Date of delivery', 'DateOfDelivery', 'WPD_DISCHARGE_SUMMARY', true, '169961004', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Delivery place', 'DeliveryPlace', 'WPD_DISCHARGE_SUMMARY', true, '410539008', 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Pregnancy Outcome', 'PregnancyOutcome', 'WPD_DISCHARGE_SUMMARY', true, '77386006', 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Type of delivery', 'TypeOfDelivery', 'WPD_DISCHARGE_SUMMARY', true, '48782003', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Member status', 'MemberStatus', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Discharge Date', 'DischargeDate', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Free Medicines Dispensed?', 'FreeMedicines', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Free Diet Provided?', 'FreeDiet', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Free Lab Tests Done?', 'FreeLabTest', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Free Blood Transfusion Done?', 'FreeBloodTransfusion', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Free drop back/ referral transport provided?', 'FreeDropTransport', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Family Planning Method', 'FamilyPlanningMethod', 'WPD_DISCHARGE_SUMMARY', true, '13197004', 'Text', 'KV');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Date of death', 'DeathDate', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Place of death', 'PlaceOfDeath', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Reason of death', 'DeathReason', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Pregnancy Outcome', 'PregnancyOutcome', 'WPD_DISCHARGE_SUMMARY', true, '77386006', 'Text', 'KV,PregnancyOutcome');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Child Gender', 'Gender', 'WPD_DISCHARGE_SUMMARY', true, '285116001', 'Text', 'KV,Gender');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Birth Weight', 'BirthWeight', 'WPD_DISCHARGE_SUMMARY', true, '27113001', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Did baby cry at the time of birth?', 'BabyCriedAtBirth', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Breastfeeding in 1 hour of delivery?', 'BreastFeedingInOneHour', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Breast crawl done?', 'BreastCrawl', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Kangaroo Care Initiated?', 'KangarooCare', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Type of delivery', 'TypeOfDelivery', 'WPD_DISCHARGE_SUMMARY', true, '48782003', 'Text', 'USCC');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Member status', 'MemberStatus', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Date of death', 'DeathDate', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Place of death', 'PlaceOfDeath', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Reason of death', 'DeathReason', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Is Child high risk case?', 'IsHighRiskCase', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'boolean', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Child:Loop:{Physical Examination}:Observation.text', 'Name of child', 'Name', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Value:Loop:Condition.section:{Mother Danger Sign}', 'Mother Danger Sign', 'MotherDangerSigns', 'WPD_DISCHARGE_SUMMARY', true, NULL, 'Text', 'FVB');


delete from hi_type_query_builder_mapper where hi_type_code = 'WPD_DISCHARGE_SUMMARY';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('WPD_DISCHARGE_SUMMARY', 'get_fhir_wpd_discharge_summary', true);

DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_wpd_discharge_summary';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e1d7c9ac-ae90-4266-b0b7-7783366fe059', -1,  current_date , -1,  current_date , 'get_fhir_wpd_discharge_summary',
'serviceId',
'with wpd_mother_details as(
	select * from rch_wpd_mother_master where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	coalesce(wmd.discharge_date, wmd.date_of_delivery) as "DischargeOrDateOfDelivery",
	wmd.date_of_delivery as "DateOfDelivery",
	wmd.delivery_place as "DeliveryPlace",
	wmd.pregnancy_outcome as "PregnancyOutcome",
	wmd.type_of_delivery as "TypeOfDelivery",
	wmd.member_status as "MemberStatus",
	wmd.discharge_date as "DischargeDate",
	wmd.free_medicines as "FreeMedicines",
	wmd.free_diet as "FreeDiet",
	wmd.free_lab_test as "FreeLabTest",
	wmd.free_blood_transfusion as "FreeBloodTransfusion",
	wmd.free_drop_transport as "FreeDropTransport",
	wmd.family_planning_method as "FamilyPlanningMethod",
	wmd.death_date as "DeathDate",
	wmd.place_of_death as "PlaceOfDeath",
	wmd.death_reason as "DeathReason",
	STRING_AGG(distinct cast(rwmdsr.mother_danger_signs as text), '','') as "MotherDangerSigns",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from wpd_mother_details wmd
inner join imt_member im on im.id = wmd.member_id
left join rch_wpd_mother_danger_signs_rel rwmdsr on rwmdsr.wpd_id = wmd.id
left join um_user uu on uu.id = wmd.created_by
left join health_infrastructure_details hid on hid.id = wmd.health_infrastructure_id
left join location_master lm on lm.id = hid.location_id
group by uu.first_name,uu.middle_name, uu.last_name, im.dob, im.first_name, im.middle_name, im.last_name,
im.gender, im.unique_health_id, im.mobile_number, im.marital_status,
wmd.discharge_date, wmd.date_of_delivery, delivery_place, wmd.pregnancy_outcome, wmd.type_of_delivery,
wmd.member_status, wmd.discharge_date, wmd.free_medicines, wmd.free_diet, wmd.free_lab_test, wmd.free_blood_transfusion,
wmd.free_drop_transport, wmd.family_planning_method, wmd.death_date, wmd.place_of_death, wmd.death_reason,
lm.english_name, hid.name_in_english, hid.name, hid.hfr_facility_id, hid.mobile_number, hid.contact_number,
hid.address, hid.postal_code;',
'To get all the related field to generate fhir for WPD Discharge Summary',
true, 'ACTIVE');