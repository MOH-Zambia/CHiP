--6062

update menu_config
set feature_json = '{"canAdd":true,"canEdit":true,"canEditLGDCode":false}'
where menu_name = 'Locations';

update menu_config
set feature_json = '{"canAdd":true,"canEdit":true,"canEditUserName":false,"canEditPassword":false}'
where menu_name = 'Users';