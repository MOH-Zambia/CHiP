alter table gvk_anm_verification_response
drop column if exists anm_id,
add column anm_id bigint;

update gvk_anm_verification_response
set anm_id = gvk_anm_verification_info.anm_id
from gvk_anm_verification_info
where gvk_anm_verification_info.id = gvk_anm_verification_response.request_id;

alter table gvk_anm_verification_response alter column anm_id set not null;