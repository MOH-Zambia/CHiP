-- Add menu for feature of mange schools
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3036

-- menu_config

INSERT INTO menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
SELECT null, true, 'Manage Schools', 'techo.manage.schools', 'manage', true
WHERE NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name = 'Manage Schools');

