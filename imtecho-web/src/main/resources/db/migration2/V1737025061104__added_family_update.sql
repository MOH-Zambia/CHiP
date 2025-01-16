delete from mobile_form_details where form_name = 'FAMILY_UPDATE';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('FAMILY_UPDATE', 'FAMILY_UPDATE', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'FAMILY_UPDATE';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'FAMILY_UPDATE';