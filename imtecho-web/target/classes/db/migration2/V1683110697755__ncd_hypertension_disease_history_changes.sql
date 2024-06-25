
update system_configuration set key_value = '50' where system_key = 'MOBILE_FORM_VERSION';


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Diabetes foot','diseaseHistoryList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Diabetes retinopathy','diseaseHistoryList','bchikhly',now(),0);

update listvalue_field_value_detail set is_active = false, last_modified_on = now()
where field_key='diseaseHistoryList' and value='Hypertension';

update listvalue_field_value_detail set is_active = false, last_modified_on = now()
where field_key='diseaseHistoryList' and value='None';

update listvalue_field_value_detail set is_active = false, last_modified_on = now()
where field_key='diseaseHistoryList' and value='Other';


alter table ncd_member_home_visit_detail
drop column if exists height,
drop column if exists weight,
drop column if exists bmi,
add column height integer,
add column weight numeric(6,2),
add column bmi numeric(6,2);

alter table ncd_member_clinic_visit_detail
drop column if exists height,
drop column if exists weight,
drop column if exists bmi,
add column height integer,
add column weight numeric(6,2),
add column bmi numeric(6,2);