insert into listvalue_field_value_detail(is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size,code)
values(true,false,'superadmin',current_date,'GVKEMRI RO','role_catg',0,'GVKEMRI_RO');	

insert into um_role_category (role_id,category_id, created_by, created_on, modified_by, modified_on, state)
values
(84,(select id from listvalue_field_value_detail where code = 'GVKEMRI_RO'),-1,current_date,-1,current_date,'ACTIVE'),
(110,(select id from listvalue_field_value_detail where code = 'GVKEMRI_RO'),-1,current_date,-1,current_date,'ACTIVE'),
(111,(select id from listvalue_field_value_detail where code = 'GVKEMRI_RO'),-1,current_date,-1,current_date,'ACTIVE');