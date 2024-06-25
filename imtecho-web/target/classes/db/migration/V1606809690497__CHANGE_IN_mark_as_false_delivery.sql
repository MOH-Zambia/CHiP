-- Added missing modified_by and modified_on in update statement.

DELETE FROM QUERY_MASTER WHERE CODE='mark_as_false_delivery';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bc399365-286c-4b33-a171-2f8f022395a0', 75398,  current_date , 75398,  current_date , 'mark_as_false_delivery', 
'member_id,action_by,pregnancy_reg_det_id,wpd_mother_id', 
'--Activate WPD Notification
update techo_notification_master set state = from_state,modified_on = now(), modified_by = #action_by# 
from (
	select techo_notification_state_detail.notification_id,techo_notification_state_detail.from_state 
	from techo_notification_state_detail, (
		select techo_notification_master.id,max(techo_notification_state_detail.id) as techo_notification_state_detail_id  
		from techo_notification_master,techo_notification_state_detail 
		where techo_notification_master.state= ''COMPLETED'' and member_id = #member_id# and ref_code = #pregnancy_reg_det_id#
		and techo_notification_master.id = techo_notification_state_detail.notification_id
		and techo_notification_state_detail.from_state != techo_notification_state_detail.to_state
		and notification_type_id = (
			select id from notification_type_master where code = ''FHW_WPD''
		)
		group by techo_notification_master.id
	) as notification_id_last_state_detail_id
	where techo_notification_state_detail.id = notification_id_last_state_detail_id.techo_notification_state_detail_id
) as t  where t.notification_id =  techo_notification_master.id;

--Activate ANC Notification
update techo_notification_master set state = from_state,modified_on = now(), modified_by = #action_by# 
from (
	select techo_notification_state_detail.notification_id,techo_notification_state_detail.from_state 
	from techo_notification_state_detail,(
		select techo_notification_master.id,max(techo_notification_state_detail.id) as techo_notification_state_detail_id  
		from techo_notification_master,techo_notification_state_detail 
		where techo_notification_master.state= ''MARK_AS_DELIVERY_HAPPENED'' 
		and member_id = #member_id# and ref_code = #pregnancy_reg_det_id#
		and techo_notification_master.id = techo_notification_state_detail.notification_id
		and techo_notification_state_detail.from_state != techo_notification_state_detail.to_state
		and notification_type_id in (select id from notification_type_master where code in (''FHW_ANC'', ''ASHA_ANC''))
		group by techo_notification_master.id
	) as notification_id_last_state_detail_id
	where techo_notification_state_detail.id = notification_id_last_state_detail_id.techo_notification_state_detail_id
) as t  where t.notification_id =  techo_notification_master.id;

--Activate Pending Notification Generation Events
update event_mobile_notification_pending set is_completed = false, state = ''PENDING'', 
modified_by = #action_by#, modified_on = now() 
where member_id = #member_id# and state = ''COMPLETED'' 
and notification_configuration_type_id in (
	select id from event_configuration_type where mobile_notification_type in (
		select id from notification_type_master where code in (''FHW_ANC'', ''FHW_WPD'', ''ASHA_ANC'')
	)
)
and ref_code = #pregnancy_reg_det_id#;

--Activate Pregnancy Registration details
update rch_pregnancy_registration_det set state = ''PENDING'',
modified_on = now(), modified_by = #action_by# 
where id = #pregnancy_reg_det_id#;

update event_mobile_notification_pending set is_completed = false, state = ''MARK_AS_FALSE_DELIVERY'', 
modified_by = #action_by#, modified_on = now() 
where member_id = #member_id# 
and notification_configuration_type_id in (
	select id from event_configuration_type where mobile_notification_type in (
		select id from notification_type_master where code in (''FHW_PNC'', ''ASHA_PNC'')
	)
)
and ref_code = #pregnancy_reg_det_id#;

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''FHW_PNC'')
and state in (''PENDING'',''RESCHEDULE'') and ref_code = #pregnancy_reg_det_id# and member_id = #member_id# ;

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''ASHA_PNC'')
and state in (''PENDING'',''RESCHEDULE'') and ref_code = #pregnancy_reg_det_id# and member_id = #member_id# ;

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''LMPFU'')
and state in (''PENDING'',''RESCHEDULE'') and member_id = #member_id#;

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''ASHA_LMPFU'')
and state in (''PENDING'',''RESCHEDULE'') and member_id = #member_id#;

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''DISCHARGE'')
and state in (''PENDING'',''RESCHEDULE'') and member_id = #member_id#;

update imt_member set is_pregnant = true
,last_delivery_date = null,last_delivery_outcome = null,cur_preg_reg_det_id = #pregnancy_reg_det_id#,
modified_on = now(), modified_by = #action_by# 
where id = #member_id#;

update imt_member set immunisation_given = t.immunisation_given,
modified_on = now(), modified_by = #action_by# 
from (
select rch_immunisation_master.member_id,
string_agg(concat(rch_immunisation_master.immunisation_given,''#'',to_char(rch_immunisation_master.given_on,''DD/MM/YYYY''))
,'','' order by rch_immunisation_master.given_on) as immunisation_given
from rch_immunisation_master 
where rch_immunisation_master.pregnancy_reg_det_id = #pregnancy_reg_det_id#
group by rch_immunisation_master.member_id) as t 
where t.member_id = imt_member.id;

update rch_wpd_mother_master set state = ''MARK_AS_FALSE_DELIVERY'',
modified_on = now(), modified_by = #action_by# 
where id = #wpd_mother_id#;

update rch_wpd_child_master set state = ''MARK_AS_FALSE_DELIVERY'',
modified_on = now(), modified_by = #action_by# 
where wpd_mother_id = #wpd_mother_id#;

update imt_member set state = ''com.argusoft.imtecho.member.state.archived'',remarks = ''MARK_AS_FALSE_DELIVERY''
,modified_by = #action_by#,modified_on = now() where id  in (select member_id from rch_wpd_child_master where wpd_mother_id = #wpd_mother_id#);

update event_mobile_notification_pending set is_completed = false, state = ''MARK_AS_FALSE_DELIVERY'', 
modified_by = #action_by#, modified_on = now() 
where member_id in (select member_id from rch_wpd_child_master where wpd_mother_id = #wpd_mother_id#) 
and notification_configuration_type_id in (
	select id from event_configuration_type where mobile_notification_type in (
		select id from notification_type_master where code in (''FHW_CS'', ''ASHA_CS'')
	)
);

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''FHW_CS'')
and state in (''PENDING'',''RESCHEDULE'') and member_id in (select member_id from rch_wpd_child_master where wpd_mother_id = #wpd_mother_id#);

delete from techo_notification_master where notification_type_id = (select id from notification_type_master where code = ''ASHA_CS'')
and state in (''PENDING'',''RESCHEDULE'') and member_id in (select member_id from rch_wpd_child_master where wpd_mother_id = #wpd_mother_id#);', 
'It will use when ttc/mo will reject the delivery entry.', 
false, 'ACTIVE');