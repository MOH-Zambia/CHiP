delete from listvalue_field_value_detail where field_key = 'opd_lab_test_category';
delete from listvalue_field_master where field_key = 'opd_lab_test_category';
delete from listvalue_form_master where form_key = 'opd_lab_test';
delete from form_master where code = 'opd_lab_test';

insert
	into
		listvalue_field_master( field_key, field, is_active, field_type, form )
	values( 'opd_lab_test_category', 'OPD Lab Test Category', true, 'T', 'WEB' );