
update user_menu_item 
set menu_config_id = (select id from menu_config  where navigation_state='techo.ncd.members')
where user_menu_id in (select user_menu_id from user_menu_item   join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members({type:''CHC''})' 
and role_id is not null and
role_id not in  ( 
select distinct role_id from user_menu_item  
join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members'
and role_id is not null));


update user_menu_item 
set menu_config_id = (select id from menu_config  where navigation_state='techo.ncd.members')
where user_menu_id in (select user_menu_id from user_menu_item   join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members({type:''DIST_HOSP''})' 
and role_id is not null and
role_id not in  ( 
select distinct role_id from user_menu_item  
join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members'
and role_id is not null));





update user_menu_item 
set menu_config_id = (select id from menu_config  where navigation_state='techo.ncd.members')
where user_menu_id in (select user_menu_id from user_menu_item   join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members({type:''DIST_HOSP''})' 
and user_id is not null and
user_id not in  ( 
select distinct user_id from user_menu_item  
join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members'
and user_id is not null));
update user_menu_item 
set menu_config_id = (select id from menu_config  where navigation_state='techo.ncd.members')
where user_menu_id in (select user_menu_id from user_menu_item   join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members({type:''CHC''})' 
and user_id is not null and
user_id not in  ( 
select distinct user_id from user_menu_item  
join menu_config c on c.id=menu_config_id
where
c.navigation_state='techo.ncd.members'
and user_id is not null));

delete FROM user_menu_item  
where menu_config_id in(
select id from menu_config  where 
navigation_state='techo.ncd.members({type:''DIST_HOSP''})' 
or navigation_state='techo.ncd.members({type:''CHC''})' 
);


delete FROM menu_config  where
navigation_state='techo.ncd.members({type:''DIST_HOSP''})' 
or navigation_state='techo.ncd.members({type:''CHC''})';
