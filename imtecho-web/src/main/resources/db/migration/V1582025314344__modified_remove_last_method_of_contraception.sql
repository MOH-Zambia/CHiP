delete from query_master where code='remove_last_method_of_contraception';

INSERT INTO public.query_master(
created_by, created_on, code, params, 
query, returns_result_set, state, description)
VALUES(1,now(), 'remove_last_method_of_contraception','unique_health_id,reason_for_change',
'with insert_change_log_detail as (
insert into support_change_request_log(member_id,change_type,other_detail,reason_for_change,created_on)
select id as member_id,''REMOVE_LAST_METHOD_OF_CONTRACEPTION'',null,(case when ''null'' = ''#reason_for_change#'' then null else  ''#reason_for_change#'' end ),now() from imt_member
where unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id
),update_imt_member as (
update imt_member set last_method_of_contraception = null,modified_on = now() where  unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id)
select cast(''Changes done'' as text) result from update_imt_member;'
,true,'ACTIVE','');

