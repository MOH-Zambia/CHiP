-- Add feature of content preview config to update the lmp date of users
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2396


INSERT INTO menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
SELECT id, true, 'Content Preview Config', 'techo.manage.contentPreviewConfig', 'admin', true
FROM menu_group
WHERE group_name = 'My Techo' AND
NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name='Content Preview Config');

