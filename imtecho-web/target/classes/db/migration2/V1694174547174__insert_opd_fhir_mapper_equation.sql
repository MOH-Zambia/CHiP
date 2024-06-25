INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.date', 'Date', 'CreatedOn', 'OPD', true, NULL, 'date', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.title', 'OP Consultation Document', NULL, 'OPD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition.type', 'Clinical consultation report', NULL, 'OPD', true, '371530004', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Advised Lab Tests', 'AdvisedLabTest', 'OPD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:section:Physicalexamination:Observation.text', 'Advised Lab Tests Category', 'AdvisedCategory', 'OPD', true, NULL, 'Text', 'FVB');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Value:Condition.section:{History and physical report}', 'History and physical report', 'LabTests', 'OPD', true, '371529009', 'Text', 'C_FVB');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.section', 'Medication summary document', NULL, 'OPD', true, '721912009', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.setMedication', 'Medicine Name', 'EdlId', 'OPD', true, NULL, 'Text', 'FVB');
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:MedicationRequest.authored', 'Authored On', 'MedicineGivenDate', 'OPD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.Dosage.text', 'No of Tablets (or ML in case of Syrups) ', NULL, 'OPD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.Dosage.additionalInstruction', 'After Food', 'QuantityAfterFood', 'OPD', true, '311504000', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.Dosage.additionalInstruction', 'Before Food', 'QuantityBeforeFood', 'OPD', true, '311501008', 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.Dosage.Frequency', 'Frequency', 'Frequency', 'OPD', true, NULL, 'Text', NULL);
INSERT INTO public.fhir_mapper_equation
(fhir, field_description, field_name, hi_type_code, is_active, snomed_ct_code, "type", value_type)
VALUES('Composition:Loop:MedicationRequest.Dosage.Period', 'Period', 'NumberOfDays', 'OPD', true, NULL, 'Text', NULL);


delete from hi_type_query_builder_mapper where hi_type_code = 'OPD';

insert into hi_type_query_builder_mapper(hi_type_code, query_code, is_active)
	VALUES('OPD', 'get_fhir_opd', true);


DELETE FROM QUERY_MASTER WHERE CODE='get_fhir_opd';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6d5de833-4f8c-4c00-a89d-0922c14dfe79', -1,  current_date , -1,  current_date , 'get_fhir_opd',
'serviceId',
'with opd_member_registration as (
	select * from rch_opd_member_registration where id = #serviceId#
)
select
	concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "PractitionerFullName" ,
	im.dob as "PatientDob",
	concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "PatientFullName",
	im.gender as "Gender",
	im.unique_health_id as "PatientUniqueHealthId",
	im.mobile_number as "PatientMobileNumber",
	im.marital_status as "PatientMaritalStatus",
	omr.created_on as "CreatedOn",
	roltm."name" as "AdvisedLabTest",
	roltm.category as "AdvisedCategory",
	STRING_AGG(distinct cast(roltpr.provisional_id  as text), '','') as "LabTests",
	romm.medicines_given_on as "MedicineGivenDate",
	lm.english_name as "HealthInfraCityName",
	coalesce(hid.name_in_english, hid."name") as "HealthInfraName",
	hid.hfr_facility_id as "HfrFacilityId",
	coalesce(hid.mobile_number, hid.contact_number) as "HealthInfraMobileNumber",
	hid.address as "HealthInfraAddress",
	hid.postal_code as "HealthInfraPostalCode"
from opd_member_registration omr
inner join imt_member im on im.id = omr.member_id
left join rch_opd_member_master romm on romm.opd_member_registration_id = omr.id
left join rch_opd_lab_test_details roltd on roltd.opd_member_master_id = romm.id
left join rch_opd_lab_test_master roltm on roltm.id = roltd.lab_test_id
left join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
left join um_user uu on uu.id = omr.created_by
left join health_infrastructure_details hid on hid.id = omr.health_infra_id
left join location_master lm on lm.id = hid.location_id
group by uu.first_name,uu.middle_name, uu.last_name, im.dob, im.first_name, im.middle_name, im.last_name,
im.gender, im.unique_health_id, im.mobile_number, im.marital_status,
omr.created_on, roltm."name", roltm.category, romm.medicines_given_on,
lm.english_name, hid.name_in_english, hid.name, hid.hfr_facility_id, hid.mobile_number, hid.contact_number,
hid.address, hid.postal_code;',
'To get all the related field to generate fhir for OPD (OpConsultation)',
true, 'ACTIVE');