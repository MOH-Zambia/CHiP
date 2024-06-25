ALTER table ndhm_hiu_master
drop column if exists status,
ADD COLUMN status varchar(55) default 'ACTIVE';
