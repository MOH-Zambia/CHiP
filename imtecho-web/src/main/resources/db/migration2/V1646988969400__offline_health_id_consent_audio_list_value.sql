delete from listvalue_field_master where field_key = 'offline_health_id_consent';
delete from listvalue_field_role where field_key = 'offline_health_id_consent';
delete from listvalue_field_form_relation where field = 'offline_health_id_consent';


insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('offline_health_id_consent','offline_health_id_consent',true,'M','FHS','F');

insert into listvalue_field_role (role_id,field_key) values (30,'offline_health_id_consent');

insert into listvalue_field_form_relation (field,form_id) values ('offline_health_id_consent',2);