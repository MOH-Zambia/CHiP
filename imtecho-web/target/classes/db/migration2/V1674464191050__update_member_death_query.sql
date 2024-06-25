update system_configuration set key_value = '41' where system_key = 'MOBILE_FORM_VERSION';


DELETE FROM QUERY_MASTER WHERE CODE='mark_member_as_death';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'05a95b2b-c62d-4e4d-9ecc-94539136470e', 97070,  current_date , 97070,  current_date , 'mark_member_as_death',
'member_id,family_id,reference_id,%,member_death_mark_state,death_reason,other_death_reason,location_id,death_date,health_infra_id,location_hierarchy_id,action_by,service_type,place_of_death',
'update techo_notification_master set state = ''MARK_AS_DEATH'',
        modified_on = now(), modified_by = #action_by#
        where member_id = #member_id# and state in (''PENDING'',''RESCHEDULE'');
    update event_mobile_notification_pending set is_completed = true, state = ''MARK_AS_DEATH'',
        modified_by = #action_by#, modified_on = now() from event_mobile_configuration
        where event_mobile_notification_pending.notification_configuration_type_id = event_mobile_configuration.id
        and member_id = #member_id# and state = ''PENDING'';

with death_det as(
INSERT INTO public.rch_member_death_deatil(
	member_id, family_id, location_id, location_hierarchy_id, dod, death_reason, other_death_reason, place_of_death, created_on, created_by, modified_on,modified_by,service_type, reference_id,health_infrastructure_id
)
VALUES(
	#member_id#, #family_id#, #location_id#, #location_hierarchy_id#,
case when ''#death_date#'' != ''null'' then to_timestamp(''#death_date#'', ''YYYY/MM/DD HH24:MI:SS'') else null end,
    case when ''#death_reason#'' != ''null'' then ''#death_reason#'' else null end,
	case when ''#other_death_reason#'' != ''null'' then ''#other_death_reason#'' else null end,
	''#place_of_death#'', now(), #action_by#,now(), #action_by#, ''#service_type#'', #reference_id#, #health_infra_id#
)
returning id,member_id,family_id,dod,location_id,location_hierarchy_id
),member_det as(
select imt_member.id,death_det.location_id as location_id
,imt_family.contact_person_id
,imt_member.state
,case when is_pregnant = true then true else false end as is_pregnant
,death_det.location_hierarchy_id
,case when last_delivery_date + interval ''42 days'' > death_det.dod then true else false end as is_del_done_in_42_days
,case when dob + interval ''5 years'' > death_det.dod then true else false end as child_less_than_5_year
from imt_member,death_det,imt_family where imt_member.id = death_det.member_id
and imt_member.family_id = imt_family.family_id
),user_det as(
select um_user.id as user_id from um_user,um_user_location,member_det where um_user.id = um_user_location.user_id
and um_user_location.state = ''ACTIVE'' and um_user.state = ''ACTIVE''
and um_user_location.loc_id in (select parent_id from location_hierchy_closer_det where child_id = member_det.location_id)
and um_user.role_id in (select id from um_role_master where code in (''mo_uphc'',''mo_phc''))
limit 1
),insert_anm_death_ttc as(
INSERT INTO public.techo_web_notification_master(
            notification_type_id, location_id, location_hierarchy_id,
            user_id,member_id, escalation_level_id, schedule_date,
            state, created_by, created_on,
            modified_by, modified_on, ref_code, notification_type_escalation_id
            )
select notification_type_id,member_det.location_id,member_det.location_hierarchy_id,(select user_id from user_det)
			,member_det.id,notification_type.id,now(),
			''PENDING'',#action_by#,now(),#action_by#,now(),death_det.id,escalation_id
			from death_det,member_det,
			(select id,notification_type_id,notification_type_id||''_''||id as escalation_id from escalation_level_master where name = ''Default''
and notification_type_id = (select id from notification_type_master where code = ''maternal_death_verification_ttc'')) as notification_type
where (member_det.is_pregnant or is_del_done_in_42_days)
returning id
),insert_anm_death_mo as(
INSERT INTO public.techo_web_notification_master(
            notification_type_id, location_id, location_hierarchy_id,
            member_id, escalation_level_id, schedule_date,
            state, created_by, created_on,
            modified_by, modified_on, ref_code,related_notification_id, notification_type_escalation_id
            )
select notification_type_id,member_det.location_id,member_det.location_hierarchy_id,
			member_det.id,notification_type.id,now(),
			''PENDING'',#action_by#,now(),#action_by#,now(),death_det.id,insert_anm_death_ttc.id,escalation_id
			from death_det,member_det,
			(select id,notification_type_id,notification_type_id||''_''||id as escalation_id from escalation_level_master where name = ''Default''
and notification_type_id = (select id from notification_type_master where code = ''maternal_death_verification_mo'')) as notification_type
,insert_anm_death_ttc
where (member_det.is_pregnant or is_del_done_in_42_days)
returning id
),insert_child_death_ttc as(
INSERT INTO public.techo_web_notification_master(
            notification_type_id, location_id, location_hierarchy_id,
            user_id,member_id, escalation_level_id, schedule_date,
            state, created_by, created_on,
            modified_by, modified_on, ref_code, notification_type_escalation_id
            )
select notification_type_id,member_det.location_id,member_det.location_hierarchy_id,(select user_id from user_det)
			,member_det.id,notification_type.id,now(),
			''PENDING'',#action_by#,now(),#action_by#,now(),death_det.id,escalation_id
			from death_det,member_det,
			(select id,notification_type_id,notification_type_id||''_''||id as escalation_id from escalation_level_master where name = ''Default''
and notification_type_id = (select id from notification_type_master where code = ''child_death_veriffication_ttc'')) as notification_type
where member_det.child_less_than_5_year
returning id
), mo_death_verification_cfhc as (
INSERT INTO public.techo_web_notification_master(
            notification_type_id, location_id, location_hierarchy_id,
            member_id, escalation_level_id, schedule_date,
            state, created_by, created_on,
            modified_by, modified_on, ref_code, notification_type_escalation_id
            )
select notification_type_id,member_det.location_id,member_det.location_hierarchy_id,
            member_det.id,notification_type.id,now(),
            ''PENDING'',#action_by#,now(),#action_by#,now(),death_det.id,escalation_id
            from death_det,member_det,
            (select id,notification_type_id,notification_type_id||''_''||id as escalation_id from escalation_level_master where name = ''Default''
and notification_type_id = (select id from notification_type_master where code = ''cfhc_death_verification_mo'')) as notification_type
where member_det.state in (''CFHC_MD'')
returning id
),insert_child_death_mo as(
INSERT INTO public.techo_web_notification_master(
            notification_type_id, location_id, location_hierarchy_id,
            member_id, escalation_level_id, schedule_date,
            state, created_by, created_on,
            modified_by, modified_on, ref_code,related_notification_id, notification_type_escalation_id
            )
select notification_type_id,member_det.location_id,member_det.location_hierarchy_id
			,member_det.id,notification_type.id,now(),
			''PENDING'',#action_by#,now(),#action_by#,now(),death_det.id,insert_child_death_ttc.id,escalation_id
			from death_det,member_det,
			(select id,notification_type_id,notification_type_id||''_''||id as escalation_id from escalation_level_master where name = ''Default''
and notification_type_id = (select id from notification_type_master where code = ''child_death_veriffication_mo'')) as notification_type
,insert_child_death_ttc
where member_det.child_less_than_5_year
returning id
)
update imt_member set death_detail_id = death_det.id,
	state = case when ''#member_death_mark_state#'' is not null
		and ''#member_death_mark_state#'' not like ''#%#''
		and ''#member_death_mark_state#'' != ''null''
		then ''#member_death_mark_state#''
		else ''com.argusoft.imtecho.member.state.dead'' end,
    modified_on = now(), modified_by = #action_by# from death_det where imt_member.id = #member_id#;',
'It will mark the member as DEAD',
false, 'ACTIVE');