-- retrieve_list_values_by_field_key

delete from query_master where code='retrieve_list_values_by_field_key';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state)
values (1, localtimestamp, 'retrieve_list_values_by_field_key', 'fieldKey', ' select * from listvalue_field_value_detail where field_key=''#fieldKey#'' ', true, 'ACTIVE');
