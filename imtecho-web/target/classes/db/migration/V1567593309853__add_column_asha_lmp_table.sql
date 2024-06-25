ALTER TABLE rch_asha_lmp_follow_up
DROP COLUMN IF EXISTS preg_conf_status,
ADD COLUMN preg_conf_status text;


insert into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
values(-1, now(), -1, now(), 'FHW_PREG_CONF', 'FHW Pregnancy Confirmation Form', 'ACTIVE');

