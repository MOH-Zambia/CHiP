ALTER TABLE public.migration_master
  ADD COLUMN  status character varying(200);



Delete from query_master 
where code='migration_resolved_tasks';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'migration_resolved_tasks','userid,offset,limit,locationId', 
            '
with migration as (select * from migration_master mig
where
 (mig.state IN(''LFU'',''CONFIRMED'',''ROLLBACK'')  or mig.status=''PENDING'')and modified_by=#userid# and
(#locationId# is null and location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userid# and is_active=true )))
 or(#locationId# is not null and location_migrated_from in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)
order by mig.created_on desc
limit #limit# offset #offset#)
,  member_migration as(select  m.mobile_number as contactnumber,migration.state as mig_state,status,
 m.id as memberid, m.first_name || '' '' || m.last_name as fullname, migration.id as migrationid, migration.location_migrated_from as locationmigratedfrom ,
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
case when member_migration.status is not null then member_migration.status else member_migration.mig_state end as status ,
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId,member_migration.mig_state,member_migration.status
            ', true, 'ACTIVE', 'Resolved task by user in migrations');

Delete from query_master 
where code='mark_as_lfu';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'mark_as_lfu', 'userid,id,outOfState', 
            'UPDATE public.migration_master
   SET  
       confirmed_by=#userid#, 
       confirmed_on=now(),  modified_on=now(), 
       modified_by=#userid#, state=''LFU'',
out_of_state=#outOfState#
       
 WHERE id=#id#;'
       
 , false, 'ACTIVE', 'Update status of member to lfu');

Delete from query_master 
where code='retrieve_location_by_level_parent';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'retrieve_location_by_level_parent', 'level,parentId', 
            'select m.name,m.id,t.type as typeCode,t.name as type from  location_hierchy_closer_det  c inner join location_type_master  t on t.type=c.child_loc_type inner join location_master m on m.id=c.child_id where t.level=#level# and parent_id=#parentId# order by depth'
       
 , true, 'ACTIVE', 'Retrieve location by given parent and for certain level');

Delete from query_master 
where code='lfu_migrated_membbers_retrival';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'lfu_migrated_membbers_retrival','userId,offset,limit,locationId', 
            '
with migration as (select mig.* from migration_master mig
inner join migration_master m on m.member_id = mig.member_id and m.id<> mig.id
where
(mig.out_of_state is null or mig.out_of_state=false) and 
mig.type=''OUT'' and mig.migrated_location_not_known=true and mig.state=''REPORTED'' and
(#locationId# is null and mig.location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userId# and is_active=true )))
 or(#locationId# is not null and mig.location_migrated_from in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)

order by mig.created_on desc
limit #limit# offset #offset#),
migration_count as (
select migration.*,count(distinct m.id) as count from migration
inner join migration_master m on m.member_id = migration.member_id and m.id <> migration.id and m.type=''OUT''

group by migration.status,migration.id,migration.member_id,migration.reported_by,migration.reported_on,migration.location_migrated_to,
migration.location_migrated_from,migration.migrated_location_not_known,
migration.confirmed_by,migration.confirmed_on,migration.type,
migration.created_by,migration.modified_by,migration.other_information,
migration.created_on,migration.modified_on,migration.state,migration.family_migrated_from
,migration.family_migrated_to,migration.no_family,migration.out_of_state
,migration.has_children,migration.is_temporary,migration.area_migrated_to,migration.area_migrated_from,migration.nearest_loc_id
,migration.village_name,migration.fhw_asha_name,migration.fhw_asha_phone,migration.mobile_data
,migration.similar_member_verified
)
,  member_migration as(select m.mobile_number as contactnumber ,m.id as memberid, m.first_name || '' '' || m.last_name as fullname, migration.id as migrationid, migration.location_migrated_from as locationmigratedfrom ,
migration.location_migrated_to as locationmigratedto ,
migration.migrated_location_not_known as migratedlocationnotknown,
migration.created_by as createdBy, migration.created_on as createdOn ,
migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
migration.family_migrated_from as familyMigratedFrom,
migration.family_migrated_from as familyMigratedTo,
m.unique_health_id as uniqueHealthId,count

from migration_count as migration, imt_member m
where m.id=migration.member_id)
select memberid, fullname,contactnumber,count,
migrationid,locationmigratedto,migratedlocationnotknown,
createdBy,createdOn,modifiedOn,modifiedBy,uniqueHealthId,familyMigratedTo,familyMigratedFrom,
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId,contactnumber,count
', true, 'ACTIVE', 'Retrival of migrated members which are lfu');

DELETE from query_master where code ='mark_migrated_location';
INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'mark_migrated_location', 'userid,locationid,id,memberid', 
            'UPDATE public.migration_master
   SET  location_migrated_to=#locationid#, 
        migrated_location_not_known=false, confirmed_by=#userid#, 
       confirmed_on=now(),  modified_by=#userid#, 
       modified_on=now(), state=''CONFIRMED'',
status=''PENDING''
       
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
notification_type_id,  location_id, other_details,schedule_date,state,migration_id,member_id,created_by,created_on,modified_by,modified_on)
     ( select id,#locationid#,row_to_json(t),now(),''PENDING'',#id#,#memberid#,#userid#,now(),#userid#,now()

     from notification_type_master, (select * from member_details,location,fhw)t  where code=''MI''
     )

', false, 'ACTIVE', 'Update migrated location for the lfu member');

Delete from query_master 
where code='mark_as_rollback';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'mark_as_rollback','memberid,id,userid', 
            '
update migration_master 
set state=''''ROLLBACK'''',
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
 state IN (''MARK_AS_MIGRATED_PENDING'',''MARK_AS_MIGRATED_RESCHEDULED'') and member_id=#memberid#
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
where id=#memberid#;

INSERT INTO public.techo_notification_master(
             notification_type_id,  location_id,  
             schedule_date, 
            state, created_by, created_on, modified_by, modified_on, 
             other_details, migration_id,  header)
    (select (select id from notification_type_master  where code=''READ_ONLY''),f.location_id,now(),''PENDING'',#userid#,now(),#userid#,now(),
''Your request for Migration In has been approved.''||E''\n''  || '' Name : ''|| m.first_name ||'' '' ||m.middle_name ||'' ''  || '' '' ||m.last_name
|| E''\n'' || '' Member ID : ''||m.unique_health_id|| E''\n''  || '' Family Migrated to : '' || m.family_id ||'' Location Migrated to : ''||f.location_id ,
#id#,
m.unique_health_id || '' - ''|| m.first_name||'' ''||m.middle_name||'' ''||m.last_name as header
from imt_member m 
inner join imt_family f  on f.family_id = m.family_id
where m.id=#memberid#
)

            ', false, 'ACTIVE', 'Mark the migrated user to rollback state');


Delete from query_master 
where code='retrieve_member_details_for_mig';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'retrieve_member_details_for_mig','memberId', 
            '
with member as(select m.*,f.hof_id,f.location_id,head.first_name || '' ''  ||head.middle_name|| '' '' || head.last_name as headName,head.mobile_number as headContactNumber from imt_member m 
inner join imt_family f on m.family_id=f.family_id
inner join imt_member head on head.id=f.hof_id

where m.id = #memberId#)
,children as (
(select concat(first_name,'' '',middle_name, '' '' ,last_name) as fullname, dob,mother_id, id,weight, unique_health_id as uniquehealthid from imt_member where mother_id = #memberId#)
)
, asha as (
select member.*,um_user.first_name || '' ''  ||um_user.middle_name|| '' '' || um_user.last_name as fhwName , 
               um_user.contact_number as fhwContactNumber
                from member,um_user ,um_user_location l 
                where role_id = (select id from um_role_master where code= ''FHW'') 
                
                and l.state=''ACTIVE''
                and um_user.id = l.user_id
                and um_user.state = ''ACTIVE''
               and loc_id= member.location_id
),location as(select string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , asha  ,location_master
where asha.location_id=l.child_id and
 location_master.id = l.parent_id
)
select asha.mobile_number as contactnumber, asha.id,asha.unique_health_id as uniquehealthid, concat(asha.first_name,'' '',asha.middle_name, '' '' ,asha.last_name) fullname ,
asha.fhwName,asha.fhwContactNumber,locationfromName,
 asha.family_id as familyid,
asha.headname,asha.headcontactnumber,
 case when count(children.*) >0  then cast(array_to_json(array_agg(row_to_json(children.*) ))as text) end as child
 from location,asha 
left outer join children on asha.id=children.mother_id
group by asha.id,asha.unique_health_id,asha.first_name,asha.middle_name,asha.last_name,asha.headcontactnumber,asha.headname,asha.family_id,
asha.fhwName,asha.fhwContactNumber,asha.mobile_number ,locationfromName
', true, 'ACTIVE', 'Retrieve Member information for migration');