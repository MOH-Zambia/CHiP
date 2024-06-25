delete from menu_config where menu_name = 'Health Infrastructure Approval';
delete from menu_config where menu_name = 'Dr. Techo User Approval';

delete from menu_group where group_name = 'Dr. Techo';

insert into menu_group(group_name,active,group_type) values ('Dr. Techo',true,'admin');

insert into menu_config(group_id,active,menu_name,navigation_state,menu_type) 
select id,true,'Health Infrastructure Approval','techo.manage.healthInfrastructureApproval','admin'
from menu_group where group_name = 'Dr. Techo';

insert into menu_config(group_id,active,menu_name,navigation_state,menu_type) 
select id,true,'Dr. Techo User Approval','techo.manage.drtechoUserApproval','admin'
from menu_group where group_name = 'Dr. Techo';