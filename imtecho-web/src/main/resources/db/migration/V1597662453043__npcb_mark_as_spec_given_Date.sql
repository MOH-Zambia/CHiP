DELETE FROM QUERY_MASTER WHERE CODE='npcb_mark_as_spectacles_given';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4855a380-d4cc-46b0-8aa2-d66292b2349e', 74840,  current_date , 74840,  current_date , 'npcb_mark_as_spectacles_given',
'loggedInUserId,id,spectaclesGivenDate,memberId',
'update npcb_member_examination_detail
set spectacles_given_date =  to_date(#spectaclesGivenDate#,''YYYY-MM-DD''),
modified_on = now(),
modified_by = #loggedInUserId#
where id = #id#;
update imt_member
set additional_info =
case when additional_info is not null then
jsonb_set(cast(additional_info as jsonb),''{npcbStatus}'',''"SPECTACLES_GIVEN"'',true)
else ''{"npcbStatus":"SPECTACLES_GIVEN"}'' end
where id = #memberId#;',
null,
false, 'ACTIVE');