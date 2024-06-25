-- for feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3059

-- menu_config

INSERT INTO menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
SELECT null, true, 'Manage Location Wards', 'techo.manage.wards', 'manage', false
WHERE NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name = 'Manage Location Wards');

