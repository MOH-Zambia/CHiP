
-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3452

alter table soh_element_module_master
drop column if exists module_order,
add column module_order integer;


update soh_element_module_master set module_order = 1 where module = 'IDSP';
update soh_element_module_master set module_order = 2 where module = 'RCH';
update soh_element_module_master set module_order = 3 where module = 'NCD';