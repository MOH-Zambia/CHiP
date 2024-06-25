CREATE INDEX migration_master_created_on_idx
  ON public.migration_master
    (created_on DESC);

CREATE INDEX migration_master_location_migrated_from_created_on_idx
  ON public.migration_master
  (location_migrated_from, created_on DESC);

Delete from query_master 
where code='lfu_migrated_membbers_retrival';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (0, now(),'lfu_migrated_membbers_retrival', 'userId,limit,offset',
	'with migration as (select * from migration_master mig
where
type=''OUT'' and migrated_location_not_known=true and mig.state=''REPORTED'' and
location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userId# and is_active=true ))
order by mig.created_on desc
limit #limit# offset #offset#)
,  member_migration as(select m.id as memberid, m.first_name || '' '' || m.last_name as fullname, migration.id as migrationid, migration.location_migrated_from as locationmigratedfrom ,
migration.location_migrated_to as locationmigratedto ,
migration.migrated_location_not_known as migratedlocationnotknown,
migration.created_by as createdBy, migration.created_on as createdOn ,
migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
migration.family_migrated_from as familyMigratedFrom,
migration.family_migrated_from as familyMigratedTo,
m.unique_health_id as uniqueHealthId
from migration , imt_member m
where m.id=migration.member_id)
select memberid, fullname,
migrationid,locationmigratedto,migratedlocationnotknown,
createdBy,createdOn,modifiedOn,modifiedBy,uniqueHealthId,familyMigratedTo,familyMigratedFrom,
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId', true,'ACTIVE', 'Retrival of migrated members which are lfu');

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
 state=''MARK_AS_MIGRATED'' and member_id=#memberid#
))
where state=''MARK_AS_MIGRATED'' and member_id=#memberid#;
update event_mobile_notification_pending  
set state = ''PENDING'',
modified_on=now(), 
       modified_by=#userid#
where state=''MARK_AS_MIGRATED'' and member_id=#memberid#;
update imt_member 
set modified_on=now(), 
       modified_by=#userid#,
state = (
select from_state from imt_member_state_detail d, imt_member m  
where current_state=d.id and m.id=#memberid# and m.state=''com.argusoft.imtecho.member.state.migrated'' )
where id=#memberid#

            ', false, 'ACTIVE', 'Mark the migrated user to rollback state');

Delete from query_master 
where code='mark_as_lfu';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'mark_as_lfu', 'userid,id', 
            'UPDATE public.migration_master
   SET  
        migrated_location_not_known=false, confirmed_by=#userid#, 
       confirmed_on=now(),  modified_on=now(), 
       modified_by=#userid#, state=''LFU''
       
 WHERE id=#id#;', false, 'ACTIVE', 'Update status of member to lfu');

delete from query_master where code='mark_migrated_location';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'mark_migrated_location', 'userid,locationid,id,memberid', 
            'UPDATE public.migration_master
   SET  location_migrated_to=#locationid#, 
        migrated_location_not_known=false, confirmed_by=#userid#, 
       confirmed_on=now(),  modified_by=#userid#, 
       modified_on=now(), state=''CONFIRMED''
       
 WHERE id=#id#;
 with member_details as(
select  id as "memberId", first_name as "firstName", middle_name as "middleName", last_name as "lastName", family_id as "familyId",
unique_health_id as "healthId"
 from imt_member
 where id=#memberid#
) ,
location as  (select  location_master.name as "locationDetails" from migration_master , location_master where location_master.id=migration_master.location_migrated_from
and  migration_master.id=#id#),
fhw as (select first_name || '' '' || middle_name || '' ''|| last_name as  "fhwName" , contact_number as "fhwPhoneNumber"
from um_user,um_user_location l,migration_master 
where role_id = (select id from um_role_master  where code= ''FHW'')  and
migration_master.location_migrated_from = l.loc_id
and l.state=''ACTIVE''
and um_user.id = l.user_id
 and loc_id= migration_master.location_migrated_from
 and migration_master.id = #id#)


INSERT INTO public.techo_notification_master(
notification_type_id,  location_id, other_details,schedule_date,state,migration_id,member_id,created_by,created_on)
     ( select id,#locationid#,row_to_json(t),now(),''PENDING'',#id#,#memberid#,#userid#,now()

     from notification_type_master, (select * from member_details,location,fhw)t  where code=''MI''
     )

', false, 'ACTIVE', 'Update migrated location for the lfu member');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Manage Migrations','manage',TRUE,'techo.manage.migrations','{}');

