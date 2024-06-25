update gvk_anm_verification_info
set service_type = 'FHW_TT_VERI'
where service_type = 'FHW_TT_VERIFICATION';

update gvk_anm_verification_info
set service_type = 'FHW_DEL_VERI'
where service_type = 'FHW_DELIVERY_VERIFICATION';

update gvk_anm_verification_info
set service_type = 'FHW_CH_SER_VERI'
where service_type = 'FHW_CHILD_SERVICE_VERIFICATION';

update gvk_anm_verification_response
set service_type = 'FHW_TT_VERI'
where service_type = 'FHW_TT_VERIFICATION';

update gvk_anm_verification_response
set service_type = 'FHW_DEL_VERI'
where service_type = 'FHW_DELIVERY_VERIFICATION';

update gvk_anm_verification_response
set service_type = 'FHW_CH_SER_VERI'
where service_type = 'FHW_CHILD_SERVICE_VERIFICATION';

update gvk_manage_call_master
set call_type = 'FHW_TT_VERI'
where call_type = 'FHW_TT_VERIFICATION';

update gvk_manage_call_master
set call_type = 'FHW_DEL_VERI'
where call_type = 'FHW_DELIVERY_VERIFICATION';

update gvk_manage_call_master
set call_type = 'FHW_CH_SER_VERI'
where call_type = 'FHW_CHILD_SERVICE_VERIFICATION';

alter table gvk_anm_verification_info
drop column if exists priority,
add column priority integer;