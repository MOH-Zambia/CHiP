DELETE FROM  system_configuration  WHERE system_key = 'V_TEST';
DELETE FROM  system_configuration  WHERE system_key = 'DB_BACKUP_TEST_V';
DELETE FROM system_configuration where system_key = 'TECHO_DB_BACKUP_PATH';
DELETE FROM system_configuration where system_key = 'TECHO_LOG_FILES_PATH';
INSERT into system_configuration(system_key,is_active,key_value) values('TECHO_DB_BACKUP_PATH',true,'/home/vivek/Desktop');
INSERT into system_configuration(system_key,is_active,key_value) values('TECHO_LOG_FILES_PATH',true,'/home/vivek/Desktop/static');