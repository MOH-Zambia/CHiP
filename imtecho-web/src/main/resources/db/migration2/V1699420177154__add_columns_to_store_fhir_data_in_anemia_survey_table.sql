alter table anemia_member_detail
add column if not exists patient_uuid text,
add column if not exists patient_fhir_resource_data text;