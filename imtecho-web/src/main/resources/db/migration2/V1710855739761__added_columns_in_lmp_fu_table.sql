alter table rch_lmp_follow_up
add column if not exists received_anc_from_other boolean,
add column if not exists have_details_card boolean,
add column if not exists other_anc_service_place text,
add column if not exists rch_id bigint;

insert into listvalue_field_master(field_key, field, is_active, field_type, form, role_type)
values('stateList', 'stateList', true, 'T', 'FHW_ANC', 'A,F');

insert into listvalue_field_form_relation(field, form_id)
select 'stateList', id from mobile_form_details where form_name = 'FHW_ANC';