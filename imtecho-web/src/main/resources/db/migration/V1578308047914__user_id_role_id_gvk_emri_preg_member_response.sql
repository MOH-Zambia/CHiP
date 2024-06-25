alter table gvk_emri_pregnant_member_responce
drop column if exists user_id,
drop column if exists role_id,
add column user_id integer,
add column role_id integer;