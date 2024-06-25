DROP TABLE if exists member_abha_consent_details;

create table member_abha_consent_details (
	member_id integer,
	is_aadhaar_sharing_consent_given boolean,
	is_doc_other_than_aadhaar_consent_given boolean,
	is_abha_usage_consent_given boolean,
	is_sharing_health_records_consent_given boolean,
	is_anonymization_consent_given boolean,
	is_health_worker_consent_given boolean,
	is_beneficiary_consent_given boolean,
	constraint member_abha_consent_details_member_id unique (member_id)
);


update system_configuration set key_value = '81' where system_key = 'MOBILE_FORM_VERSION';