INSERT INTO public.mobile_form_details
(form_name, file_name, created_on, created_by, modified_on, modified_by)
VALUES('INDEX_INVESTIGATION', 'INDEX_INVESTIGATION', now(), -1, now(), -1);

insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'CBV_MY_PEOPLE' from mobile_form_details where form_name = 'INDEX_INVESTIGATION';