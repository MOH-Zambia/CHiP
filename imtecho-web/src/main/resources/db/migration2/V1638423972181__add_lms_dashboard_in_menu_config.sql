insert into menu_config(active,menu_name,navigation_state,menu_type)
select true,'LMS Dashboard','techo.manage.lmsdashboard','training'
WHERE NOT exists(select 1 from menu_config where menu_name='LMS Dashboard');
