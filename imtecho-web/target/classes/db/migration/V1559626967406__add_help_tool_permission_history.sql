drop table if EXISTS member_audit_log;
create table member_audit_log(
id bigserial,
member_id bigint,
table_name  varchar(255),
created_on timestamp without time zone default now(),
user_id bigint,
data json
);

insert into menu_config (feature_json,active,menu_name,navigation_state,menu_type)
values('{"canModifyMemberDob":false,"canModifyMemberGender":false,"canModifyPregnancyRegDate":false,"canModifyLmpDate":false,"canModifyAncServiceDate":false,"canModifyWpdServiceDate":false,"canModifyWpdDeliveryDate":false,"canModifyPncServiceDate":false,"canModifyChvServiceDate":false,"canModifyImmuGivenDate":false}',true,'Helpdesk Tool - Search','techo.manage.searchfeature','manage');