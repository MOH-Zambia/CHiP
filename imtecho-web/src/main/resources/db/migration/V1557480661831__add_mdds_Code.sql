alter table location_master 
add column mdds_code text;


UPDATE public.menu_config
   SET feature_json='{"canAdd":true,"canEdit":true,"canEditUserName":false,"canEditPassword":false,"canEditLGDCode":false}'
WHERE navigation_state='techo.manage.users';