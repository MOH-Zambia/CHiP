delete from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST_NEW';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('HOUSE_HOLD_LINE_LIST_NEW', 'HOUSE_HOLD_LINE_LIST_NEW', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'HOUSE_HOLD_LINE_LIST_NEW';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'HOUSE_HOLD_LINE_LIST' from mobile_form_details where form_name = 'HOUSE_HOLD_LINE_LIST_NEW';

delete from mobile_form_details where form_name = 'MEMBER_UPDATE_NEW';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('MEMBER_UPDATE_NEW', 'MEMBER_UPDATE_NEW', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'MEMBER_UPDATE_NEW';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'MEMBER_UPDATE_NEW';
