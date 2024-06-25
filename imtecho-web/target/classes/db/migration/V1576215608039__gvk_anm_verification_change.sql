alter table gvk_anm_verification_info
drop column if exists wpd_mother_reference_id,
add column wpd_mother_reference_id bigint;

alter table gvk_anm_verification_response
drop column if exists is_delivery_happened,
drop column if exists no_of_child_gender_verification,
drop column if exists delivery_place_verification,
add column is_delivery_happened boolean,
add column no_of_child_gender_verification boolean,
add column delivery_place_verification boolean;

update gvk_anm_verification_response
set is_delivery_happened = false
where delivery_status is not null
and delivery_status = false
and delivery_place_status is null;

update gvk_anm_verification_response
set is_delivery_happened = true
where is_delivery_happened is null
and service_type = 'FHW_DEL_VERI'
and gvk_call_response_status = 'com.argusoft.imtecho.gvk.call.success';

update gvk_anm_verification_info
set service_type = 'FHW_CH_SER_PREG_VERI'
where service_type = 'FHW_CH_SER_VERI'
and gvk_anm_verification_info.gvk_call_status in ('com.argusoft.imtecho.gvk.call.processing','com.argusoft.imtecho.gvk.call.to-be-processed');

update gvk_anm_verification_info
set wpd_mother_reference_id = rch_wpd_child_master.wpd_mother_id
from rch_wpd_child_master
where gvk_anm_verification_info.member_id = rch_wpd_child_master.member_id
and gvk_anm_verification_info.gvk_call_status in ('com.argusoft.imtecho.gvk.call.processing','com.argusoft.imtecho.gvk.call.to-be-processed')
and gvk_anm_verification_info.service_type = 'FHW_CH_SER_PREG_VERI';

alter table gvk_anm_verification_response
rename column delivery_status to delivery_status_deleted;