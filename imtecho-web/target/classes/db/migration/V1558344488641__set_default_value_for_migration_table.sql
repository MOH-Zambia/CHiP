alter table migration_master
alter column gvk_call_status set default 'com.argusoft.imtecho.gvk.call.to-be-processed',
alter column call_attempt set default 0,
alter column schedule_date set default current_timestamp;

alter table gvk_member_migration_call_response
add column migration_type text;

ALTER TABLE gvk_member_migration_call_response ALTER COLUMN member_id DROP NOT NULL;

alter table gvk_member_migration_call_response 
rename column is_beneficiary_called to is_member_called;