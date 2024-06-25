-- Add menu for feature of soh element configuration
--

-- menu_group

INSERT INTO menu_group (group_name, active, parent_group, group_type, menu_display_order)
SELECT 'State Of Health', true, null, 'admin', null
WHERE NOT EXISTS (SELECT 1 FROM menu_group WHERE group_name = 'State Of Health' and group_type = 'admin');

-- menu_config

INSERT INTO menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
SELECT id, true, 'Element Configuration', 'techo.manage.sohElementConfiguration', 'admin', true
FROM menu_group
WHERE group_name = 'State Of Health' AND
NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name='Element Configuration');

