Delete from query_master 
where code='mark_as_rollback';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'mark_as_rollback','memberid,id,userid', 
            'update migration_master 
set state=''ROLLBACK'',
confirmed_by=#userid#, 
       confirmed_on=now(),  modified_on=now(), 
       modified_by=#userid#
where id=#id#;
update techo_notification_master  
set modified_on=now(), 
       modified_by=#userid#, state = (select from_state from techo_notification_state_detail where id =(
select max(d.id) from techo_notification_state_detail d, techo_notification_master n
 where 
 n.id = d.notification_id and
 stateIN (''MARK_AS_MIGRATED_PENDING'',''MARK_AS_MIGRATED_RESCHEDULED'') and member_id=#memberid#
))
where state IN (''MARK_AS_MIGRATED_PENDING'',''MARK_AS_MIGRATED_RESCHEDULED'') and member_id=#memberid#;
update event_mobile_notification_pending  
set state = ''PENDING'',
modified_on=now(), 
       modified_by=#userid#
where state = ''MARK_AS_MIGRATED_PENDING'' and member_id=#memberid#;
update imt_member 
set modified_on=now(), 
       modified_by=#userid#,
state = (
select from_state from imt_member_state_detail d, imt_member m  
where current_state=d.id and m.id=#memberid# and m.state=''com.argusoft.imtecho.member.state.migrated'' )
where id=#memberid#

            ', false, 'ACTIVE', 'Mark the migrated user to rollback state');