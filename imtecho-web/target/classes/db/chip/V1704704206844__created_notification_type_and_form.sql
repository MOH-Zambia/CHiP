INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT','Hiv Negative Followup Visit','MO',245,'ACTIVE');

insert into notification_type_role_rel(role_id, notification_type_id)
select 245, id from notification_type_master where code in
('NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT');


insert into mobile_form_details (form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('HIV_SCREENING_FU', 'HIV_SCREENING_FU', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name in ('HIV_SCREENING_FU');


