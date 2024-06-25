update menu_group set active=false where group_name = 'Facility Data Entry';

insert into menu_group (group_name,active,group_type) values('Facility Data Entry',true,'manage');

update menu_config set group_id = menu_group.id
from menu_group 
where menu_group.group_name = 'Facility Data Entry'
and menu_group.active = true
and menu_config.menu_name in ('ANC Institution Form','PNC Institution Form','Child Service Visit','WPD Institution Form');