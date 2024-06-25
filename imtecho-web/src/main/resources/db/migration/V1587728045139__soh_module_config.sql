alter table soh_element_module_master
drop column if exists state,
add column state varchar(50);

update soh_element_module_master set state = 'ACTIVE' where state is null;
