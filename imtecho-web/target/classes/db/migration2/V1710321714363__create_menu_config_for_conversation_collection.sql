DELETE FROM user_menu_item where menu_config_id = (select id from menu_config mc where group_id = (select id from menu_group mg where group_name='LLM'));

DELETE FROM menu_config where group_id = (select id from menu_group where group_name='LLM');

DELETE FROM menu_group where group_name = 'LLM';

INSERT INTO menu_group(group_name, active, group_type)
values('LLM', TRUE, 'manage');

INSERT INTO menu_config(feature_json, group_id, active, menu_name, navigation_state, menu_type)
values ('{}', (select id from menu_group where group_name = 'LLM'), TRUE, 'Conversation Collection', 'techo.manage.conversationcollection', 'manage');
