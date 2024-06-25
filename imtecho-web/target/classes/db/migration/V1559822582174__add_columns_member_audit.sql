alter table member_audit_log
add column column_name  varchar(255);

alter table member_audit_log
add column ref_code bigint;

update member_audit_log set ref_code = (data->>'id')::bigint where ref_code is null;

update member_audit_log set column_name = 'dob' where data->>'dob' is not null and column_name is null;

update member_audit_log set column_name = 'service_date' where data->>'service_date' is not null and column_name is null;

update member_audit_log set column_name = 'lmp' where data->>'lmp' is not null and column_name is null;

update member_audit_log set column_name = 'lmp_date' where data->>'lmp_date' is not null and column_name is null;

update member_audit_log set column_name = 'reg_date' where data->>'reg_date' is not null and column_name is null;


update member_audit_log set column_name = 'gender' where data->>'gender' is not null and column_name is null;

update member_audit_log set column_name = 'date_of_delivery' where data->>'date_of_delivery' is not null and column_name is null;