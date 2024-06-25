insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('wasteDisposalTypeList','wasteDisposalTypeList',true,'T','HOUSE_HOLD_LINE_LIST','CHW');


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Open Disposal','wasteDisposalTypeList','ujadhav',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Pit','wasteDisposalTypeList','ujadhav',now(),0);
insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Collection by local authority','wasteDisposalTypeList','ujadhav',now(),0);

insert into listvalue_field_form_relation (field, form_id)
select 'wasteDisposalTypeList', id
from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST';

update mobile_feature_master set mobile_display_name  = 'Health Services' where mobile_constant  = 'CBV_MY_PEOPLE';

INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'FP_FOLLOW_UP_VISIT','Family Planning Follow Up Visit','MO',245,'ACTIVE');

insert into notification_type_role_rel(role_id, notification_type_id)
select 245, id from notification_type_master where code in
('FP_FOLLOW_UP_VISIT');

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('CHIP_FP_FOLLOW_UP', 'CHIP_FP_FOLLOW_UP', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_FP_FOLLOW_UP';

update system_configuration set key_value = '105' where system_key = 'MOBILE_FORM_VERSION';