begin;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),'{npcbStatus}','"REFERRED"',true)
else '{"npcbStatus":"REFERRED"}' end
where id in (select member_id from npcb_member_screening_master);
commit;

begin;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),'{npcbStatus}','"EXAMINED"',true)
else '{"npcbStatus":"EXAMINED"}' end
where id in (select member_id from npcb_member_examination_detail);
commit;

begin;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),'{npcbStatus}','"SPECTACLES_GIVEN"',true)
else '{"npcbStatus":"SPECTACLES_GIVEN"}' end
where id in (select member_id from npcb_member_examination_detail where spectacles_given);
commit;

delete from query_master where code='npcb_mark_as_spectacles_given';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_mark_as_spectacles_given','spectaclesGivenDate,id,memberId','
update npcb_member_examination_detail
set spectacles_given_date =  to_date(''#spectaclesGivenDate#'',''YYYY-MM-DD'')
where id = #id#;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),''{npcbStatus}'',''"SPECTACLES_GIVEN"'',true)
else ''{"npcbStatus":"SPECTACLES_GIVEN"}'' end
where id = #memberId#;
',false,'ACTIVE');