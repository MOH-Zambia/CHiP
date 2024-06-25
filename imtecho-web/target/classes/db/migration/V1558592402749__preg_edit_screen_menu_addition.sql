alter table rch_pregnancy_registration_det
drop column if exists is_reg_date_verified,
add column is_reg_date_verified boolean;

delete from menu_config where menu_name = 'Pregnancy Registration Verification';

insert into menu_config 
(active,menu_name,navigation_state,menu_type) 
values (true,'Pregnancy Registration Verification','techo.manage.pregregedit','manage');