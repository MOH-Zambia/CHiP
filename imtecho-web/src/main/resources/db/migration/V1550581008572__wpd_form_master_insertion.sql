insert into listvalue_form_master(form_key,form,is_active,is_training_req) values('WEB_WPD','Institutional WPD',true,false);

update listvalue_field_master set form = 'WEB_WPD' where field in ('highRiskSymptomsDuringDelivery','treatmentsDuringDelivery','wpdDangerSigns');

select setval('listvalue_field_role_id_seq',max(id)) from listvalue_field_role;

insert into listvalue_field_role(role_id,field_key) values(30,3001);
insert into listvalue_field_role(role_id,field_key) values(30,3002);
insert into listvalue_field_role(role_id,field_key) values(30,3003);