
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2698

alter table gvk_emri_pregnant_member_responce
drop column if exists verification_reason,
add column verification_reason bigint;

