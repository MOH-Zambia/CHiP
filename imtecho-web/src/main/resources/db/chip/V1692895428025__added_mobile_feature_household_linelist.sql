delete from mobile_feature_master where mobile_constant = 'HOUSE_HOLD_LINE_LIST';
insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values('HOUSE_HOLD_LINE_LIST', 'Household Line List', 'Household Line List', 'ACTIVE',  now(), -1, now(), -1);

delete from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('HOUSE_HOLD_LINE_LIST', 'HOUSE_HOLD_LINE_LIST', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'HOUSE_HOLD_LINE_LIST';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'HOUSE_HOLD_LINE_LIST' from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';

delete from mobile_menu_master where menu_name = 'CHW Menu';
insert into mobile_menu_master(config_json, menu_name, created_on, created_by, modified_on, modified_by)
values ('[{"mobile_constant":"HOUSE_HOLD_LINE_LIST","order":1},{"mobile_constant":"WORK_LOG","order":2}]', 'CHW Menu', now(), -1, now(), -1);

delete from mobile_menu_role_relation where role_id = (select id from um_role_master where name = 'CHW');
insert into mobile_menu_role_relation
select id, (select id from um_role_master where name = 'CHW') from mobile_menu_master where menu_name = 'CHW Menu';



insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('religionList2','religionList2',true,'T','HOUSE_HOLD_LINE_LIST','CHW');
insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('chronicDiseaseList2','chronicDiseaseList2',true,'T','HOUSE_HOLD_LINE_LIST','CHW');


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Christian','religionList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Muslim','religionList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Hindu','religionList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Others','religionList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t want to disclose','religionList2','kvyas',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'HIV','chronicDiseaseList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'TB','chronicDiseaseList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Hypertension','chronicDiseaseList2','kvyas',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Diabetes','chronicDiseaseList2','kvyas',now(),0);


insert into listvalue_field_form_relation (field, form_id)
select 'religionList2', id
from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';
insert into listvalue_field_form_relation (field, form_id)
select 'chronicDiseaseList2', id
from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';
insert into listvalue_field_form_relation (field, form_id)
select 'maritalStatusList', id
from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';
insert into listvalue_field_form_relation (field, form_id)
select 'educationStatusList', id
from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';