alter table gvk_anm_verification_response
drop column if exists is_verified,
add column is_verified boolean;