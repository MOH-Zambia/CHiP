-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3142

alter table soh_element_configuration
drop COLUMN IF EXISTS enable_reporting,
add COLUMN enable_reporting boolean;
