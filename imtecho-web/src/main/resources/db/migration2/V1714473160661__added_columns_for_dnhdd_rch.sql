ALTER TABLE rch_lmp_follow_up
ADD COLUMN if not exists prev_anc_state text;

ALTER TABLE rch_wpd_mother_master
ADD COLUMN if not exists other_state_of_delivery text;

insert into listvalue_field_form_relation(field, form_id)
select 'indianStateList', id from mobile_form_details where form_name in ('FHW_WPD', 'LMPFU');