DELETE FROM QUERY_MASTER WHERE CODE='get_complications_for_ncd_from_known_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8ca78f38-1100-45ff-acf3-1aa18f826629', 97070,  current_date , 97070,  current_date , 'get_complications_for_ncd_from_known_history',
'memberId',
'with mob_disease as (select unnest(string_to_array(disease_history,'','')) as disease_id,* from ncd_member_hypertension_detail
where member_id = #memberId#),
final_mob_details as(
select member_id,string_agg(distinct lfvd.value,'','') as disease,string_agg(distinct other_disease,'','') as other_disease from mob_disease md
inner join listvalue_field_value_detail lfvd on cast(lfvd.id as text) = md.disease_id
where lfvd.value not ilike ''none'' group by member_id),
final_web_details as(
select member_id,REPLACE(REPLACE(history_disease, ''['', ''''),'']'','''')
 as disease,other_disease from ncd_member_initial_assessment_detail
where member_id = #memberId# and history_disease is not null)
select
im.id,
fwd.disease as from_web,
fwd.other_disease as other_disease_web,
fmd.disease as from_mob,
fmd.other_disease as other_disease_mob
from imt_member im
left join final_web_details fwd on fwd.member_id = im.id
left join final_mob_details fmd on fmd.member_id = im.id
where im.id = #memberId#',
null,
true, 'ACTIVE');