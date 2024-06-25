alter table rch_opd_member_master
drop column if exists any_other_state_specific_disease,
add column any_other_state_specific_disease varchar(50);

alter table rch_opd_member_master
drop column if exists unusual_syndromes,
add column unusual_syndromes varchar(50);


-- fetch_listvalue_detail_from_field_on_debounce

delete from query_master where code='fetch_listvalue_detail_from_field_on_debounce';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'fetch_listvalue_detail_from_field_on_debounce', 'searchString,field', '
    select
    *
    from listvalue_field_value_detail lvfvd
    where lvfvd.field_key = (select field_key from listvalue_field_master where field =''#field#'')
    and lvfvd."value" ilike ''%#searchString#%''
    and is_active = true
    limit 10;
', true, 'ACTIVE', 'Fetch List Value Details by Field on Debounce');


-- fetch_listvalue_detail_by_ids

delete from query_master where code='fetch_listvalue_detail_by_ids';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'fetch_listvalue_detail_by_ids', 'ids', '
    select
    *
    from listvalue_field_value_detail lvfvd
    where id in (#ids#);
', true, 'ACTIVE', 'Fetch List Value Details by IDs');
