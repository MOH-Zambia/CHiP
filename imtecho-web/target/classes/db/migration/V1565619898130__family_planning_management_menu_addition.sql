delete from menu_config where menu_name = 'Manage Family Planning';

insert into menu_config 
(active,menu_name,navigation_state,menu_type) 
values (true,'Manage Family Planning','techo.manage.fpChangeSearch','manage');