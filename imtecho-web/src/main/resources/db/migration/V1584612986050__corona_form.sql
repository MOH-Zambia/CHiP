delete from listvalue_field_value_detail where field_key = 'corona_virus_symptoms';
delete from listvalue_field_master where field_key = 'corona_virus_symptoms';
delete from listvalue_form_master where form_key = 'CORONA_SYMPTOMS';


insert
	into
		listvalue_form_master( form_key, form, is_active, is_training_req )
	values ( 'CORONA_SYMPTOMS', 'Corona Symptoms', true, false );


insert
	into
		listvalue_field_master( field_key, field, is_active, field_type, form )
	values( 'corona_virus_symptoms', 'Corona Virus Symptoms', true, 'T', 'CORONA_SYMPTOMS' );