insert into mobile_form_details (form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('KNOWN_POSITIVE', 'KNOWN_POSITIVE', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name in ('KNOWN_POSITIVE');