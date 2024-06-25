insert into listvalue_field_master (field_key,field,is_active,field_type,form) values
('member_edd_due','Member EDD Due',true,'T','WEB_DASHBOARD');

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Action taken','member_edd_due','slamba',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Action pending','member_edd_due','slamba',now(),0);
