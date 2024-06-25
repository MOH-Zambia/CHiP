update menu_config
set group_id = null
where group_id = (select id from menu_group where group_name = 'NCD Reports' and group_type = 'ncd');

delete from menu_group where group_name = 'NCD Reports' and group_type = 'ncd';

insert into menu_group
(group_name,active,group_type)
values('NCD Reports',true,'ncd');

update menu_config
set menu_type = 'ncd',
group_id = menu_group.id
from menu_group
where menu_config.menu_name in ('NCD Progress tracking report','NCD Form Fillup (Location wise)','NCD Screening Status')
and menu_group.group_name = 'NCD Reports'
and menu_group.group_type = 'ncd';