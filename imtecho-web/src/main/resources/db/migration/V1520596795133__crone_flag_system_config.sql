delete from system_configuration 
    where system_key = 'CRONE_FLAG';
insert into system_configuration values
    ('CRONE_FLAG',true,'true');