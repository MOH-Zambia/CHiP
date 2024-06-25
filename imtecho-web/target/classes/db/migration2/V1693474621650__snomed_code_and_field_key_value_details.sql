INSERT INTO public.snomed_code_info (snomed_ct_code, value, url) VALUES('U', 'UNMARRIED', '	http://terminology.hl7.org/CodeSystem/v3-MaritalStatus');
INSERT INTO public.snomed_code_info (snomed_ct_code, value, url) VALUES('W', 'WIDOW', '	http://terminology.hl7.org/CodeSystem/v3-MaritalStatus');
INSERT INTO public.snomed_code_info (snomed_ct_code, value, url) VALUES('M', 'MARRIED', 'http://terminology.hl7.org/CodeSystem/v3-MaritalStatus');
INSERT INTO public.snomed_code_info (snomed_ct_code, value, url) VALUES('W', 'WIDOWER', '	http://terminology.hl7.org/CodeSystem/v3-MaritalStatus');
INSERT INTO public.snomed_code_info (snomed_ct_code, value, url) VALUES('UNK', 'ABANDON', '	http://terminology.hl7.org/CodeSystem/v3-MaritalStatus');

insert into ndhm_field_master (field_name) values ('Gender');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'Gender'), 'M', 'Male');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'Gender'), 'F', 'Female');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'Gender'), 'T', 'Transgender');

insert into ndhm_field_master (field_name) values ('FamilyPlanningMethod');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'FMLSTR', 'FEMALE STERILIZATION');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'MLSTR', 'MALE STERILIZATION');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'ORALPILLS', 'ORAL PILLS');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'CONTRA', 'EMERGENCY CONTRACEPTIVE PILLS');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'IUCD5', 'IUCD- 5 YEARS');
	insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'FamilyPlanningMethod'), 'IUCD10', 'IUCD- 10 YEARS');

insert into ndhm_field_master (field_name) values ('DeliveryPlace');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), '108_AMBULANCE', '108 AMBULANCE');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), 'HOSP', 'Hospital');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), 'ON_THE_WAY', 'On the Way');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), 'OUT_OF_STATE_GOVT', 'Out of State-Private Hospital');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), 'OUT_OF_STATE_PVT', 'Out of State-Government Hospital');
	insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'DeliveryPlace'), 'THISHOSP', 'This Hospital');


insert into ndhm_field_master (field_name) values ('PregnancyOutcome');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'PregnancyOutcome'), 'LBIRTH', 'Live Birth');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'PregnancyOutcome'), 'SBIRTH', 'Still Birth');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'PregnancyOutcome'), 'SPONT_ABORTION', 'Spontaneous Abortion');

insert into ndhm_field_master (field_name) values ('SdScore');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'SdScore'), 'SD4', 'Less than -4');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'SdScore'), 'SD3', '-4 to -3');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'SdScore'), 'SD2', '-3 to -2');
insert into ndhm_field_key_value_details (field_master_id, key, value)
	values( (select id from ndhm_field_master where field_name = 'SD1'), 'SD1', '-2 to -1');