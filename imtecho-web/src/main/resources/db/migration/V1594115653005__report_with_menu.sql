
ALTER TABLE menu_config 
Drop COLUMN if exists group_name_uuid;

ALTER TABLE menu_config 
add COLUMN group_name_uuid UUID;



ALTER TABLE menu_config 
drop COLUMN if exists sub_group_uuid;

ALTER TABLE menu_config 
add COLUMN  sub_group_uuid UUID;


update menu_config 
set uuid = uuid_generate_v4()
where uuid is null;

update menu_config 
set group_name_uuid = uuid_generate_v4()
where group_name_uuid is null;

update menu_config 
set sub_group_uuid = uuid_generate_v4()
where sub_group_uuid is null;
