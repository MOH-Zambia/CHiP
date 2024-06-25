alter table soh_element_configuration
drop column if exists state,
add column state varchar(50);

update soh_element_configuration set state = 'ACTIVE' where state is null;