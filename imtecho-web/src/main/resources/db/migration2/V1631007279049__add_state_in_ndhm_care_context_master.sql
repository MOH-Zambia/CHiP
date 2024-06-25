ALTER table ndhm_care_context_master
drop column if exists status,
ADD COLUMN status varchar(55);