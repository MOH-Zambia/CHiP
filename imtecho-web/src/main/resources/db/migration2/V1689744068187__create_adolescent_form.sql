delete from mobile_form_details where form_name = 'ADOLESCENT_HEALTH_SCREENING';
insert into mobile_form_details(form_name, file_name, created_on, created_by, modified_on, modified_by)
values('ADOLESCENT_HEALTH_SCREENING', 'ADOLESCENT_HEALTH_SCREENING', now(), -1, now(), -1);

delete from mobile_form_feature_rel where mobile_constant = 'ADOLESCENT_HEALTH_SCREENING';
insert into mobile_form_feature_rel (form_id, mobile_constant)
select id, 'ADOLESCENT_HEALTH_SCREENING' from mobile_form_details where form_name = 'ADOLESCENT_HEALTH_SCREENING';

drop table if exists public.adolescent_child_det;

CREATE TABLE public.adolescent_child_det
(
member_id bigint primary key,
location_id int,
dob date,
search_text tsvector
);