insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('ACTIVE_MALARIA_FOLLOW_UP', 'ACTIVE_MALARIA_FOLLOW_UP', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'ACTIVE_MALARIA_FOLLOW_UP';

alter table imt_member
add column if not exists planning_for_family boolean;


delete from mobile_form_feature_rel where form_id = (select id from mobile_form_details where form_name = 'CHIP_COVID');
delete from mobile_form_details where form_name = 'CHIP_COVID';


insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('CHIP_COVID_SCREENING', 'CHIP_COVID_SCREENING', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_COVID_SCREENING';