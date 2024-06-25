update um_role_master set code = 'superadmin' where name = 'Super Admin' and code is null;
update um_role_master set code = 'argusadmin' where name = 'Argus Admin' and code is null;