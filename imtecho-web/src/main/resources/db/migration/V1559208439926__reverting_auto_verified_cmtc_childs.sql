with child_ids as (
	select distinct child_id from child_cmtc_nrc_screening_detail
	where mo_not_verified and admission_id is null and is_imported is null
),notification_ids as (
	select max(id) from techo_web_notification_master
	inner join child_ids on child_ids.child_id = techo_web_notification_master.member_id
	where notification_type_id = 17
	and state = 'COMPLETED' and action_taken is not null
	group by techo_web_notification_master.member_id
),deleted_ids as (
	delete from child_cmtc_nrc_screening_detail
	where child_id in (select child_id from child_ids)
	and mo_not_verified and admission_id is null and is_imported is null
	returning child_cmtc_nrc_screening_detail.id
) 
update techo_web_notification_master
set state='PENDING',action_taken = null
where id in (select max from notification_ids)