-- Moving Manage Notification, Widgets management to Application Management Group

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Manage Notification' and navigation_state='techo.manage.notification';

update menu_config
set group_id = (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where menu_name = 'Widgets management' and navigation_state='techo.manage.manage-widgets';
