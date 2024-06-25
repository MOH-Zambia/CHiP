insert into listvalue_field_form_relation (field, form_id)
values ('riskFactorList', 2);

insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('riskFactorList','riskFactorList',true,'T','FHS','A,F');

insert into listvalue_field_form_relation (field, form_id)
values ('diseaseHistoryList', 2);

insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('diseaseHistoryList','diseaseHistoryList',true,'T','FHS','A,F');

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Alcoholic','riskFactorList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Smoking','riskFactorList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Tobacco chewing','riskFactorList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'None','riskFactorList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Stroke','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Cardio vascular disease','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Kidney disease','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Diabetes','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Hypertension','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Other','diseaseHistoryList','ndodiya',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'None','diseaseHistoryList','ndodiya',now(),0);
