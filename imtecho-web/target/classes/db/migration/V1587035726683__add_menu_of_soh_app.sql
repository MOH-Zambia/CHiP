update menu_group set group_name = 'State of Health' where group_name = 'State Of Health';

insert into menu_config(menu_name, menu_type, active, navigation_state, feature_json, group_id)
select 'SoH Application', 'admin', TRUE, 'techo.manage.sohApp', '{}', id
from menu_group
where group_name = 'State of Health' and group_type = 'admin' and
not exists (select id from menu_config where menu_name = 'techo.manage.sohApp' and menu_type = 'admin');