delete from mobile_form_details where form_name = 'CHIP_GBV_SCREENING';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('CHIP_GBV_SCREENING', 'CHIP_GBV_SCREENING', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'CHIP_GBV_SCREENING';