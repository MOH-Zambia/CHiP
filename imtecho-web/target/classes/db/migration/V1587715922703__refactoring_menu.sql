insert into menu_group(group_name, active, group_type)
SELECT 'Application Management', true, 'admin'
where not exists (select id from menu_group where group_name = 'Application Management' and group_type = 'admin');


update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Server Management' and navigation_state='techo.manage.servermanage';

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Query Management Tool' and navigation_state='techo.querymanagement';

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Query Builder' and navigation_state='techo.manage.query';

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Query Excel Sheet Genereator' and navigation_state='techo.manage.queryexcelsheetgenerator';

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Events Configured' and navigation_state='techo.notification.all';

