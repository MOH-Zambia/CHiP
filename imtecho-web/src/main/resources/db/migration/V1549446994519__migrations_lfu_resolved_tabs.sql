Delete from query_master 
where code='lfu_migrated_membbers_retrival';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'lfu_migrated_membbers_retrival','userId,offset,limit,locationId', 
            '
with migration as (select * from migration_master mig
where
type=''OUT'' and migrated_location_not_known=true and mig.state=''REPORTED'' and
(#locationId# is null and location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userId# and is_active=true )))
 or(#locationId# is not null and location_migrated_from in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)
order by mig.created_on desc
limit #limit# offset #offset#)
,  member_migration as(select m.mobile_number as contactnumber ,m.id as memberid, m.first_name || '' '' || m.last_name as fullname, migration.id as migrationid, migration.location_migrated_from as locationmigratedfrom ,
migration.location_migrated_to as locationmigratedto ,
migration.migrated_location_not_known as migratedlocationnotknown,
migration.created_by as createdBy, migration.created_on as createdOn ,
migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
migration.family_migrated_from as familyMigratedFrom,
migration.family_migrated_from as familyMigratedTo,
m.unique_health_id as uniqueHealthId
from migration , imt_member m
where m.id=migration.member_id)
select memberid, fullname,contactnumber,
migrationid,locationmigratedto,migratedlocationnotknown,
createdBy,createdOn,modifiedOn,modifiedBy,uniqueHealthId,familyMigratedTo,familyMigratedFrom,
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId,contactnumber

            ', true, 'ACTIVE', 'Retrival of migrated members which are lfu');

Delete from query_master 
where code='member_marked_lfu_retrival';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'member_marked_lfu_retrival','userid,offset,limit,locationId', 
            'with migration as (select * from migration_master mig
where
type=''OUT'' and migrated_location_not_known=true and mig.state=''LFU'' and
(#locationId# is null and location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userid# and is_active=true )))
 or(#locationId# is not null and location_migrated_from in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)
order by mig.created_on desc
limit #limit# offset #offset#)
,  member_migration as(select  m.mobile_number as contactnumber,
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
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId

            ', true, 'ACTIVE', 'Retrieve members lfu marked');

Delete from query_master 
where code='migration_resolved_tasks';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'migration_resolved_tasks','userid,offset,limit,locationId', 
            'with migration as (select * from migration_master mig
where
 mig.state IN(''LFU'',''CONFIRMED'',''ROLLBACK'')  and modified_by=#userid# and
(#locationId# is null and location_migrated_from in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userid# and is_active=true )))
 or(#locationId# is not null and location_migrated_from in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)
order by mig.created_on desc
limit #limit# offset #offset#)
,  member_migration as(select  m.mobile_number as contactnumber,migration.state as state,
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
string_agg(location_master.name,'' > '' order by depth desc) as locationfromName from
 location_hierchy_closer_det l , member_migration  ,location_master
where member_migration.locationmigratedfrom=l.child_id and
 location_master.id = l.parent_id
 group by member_migration.memberid,fullname,migrationid,
 migratedlocationnotknown,locationmigratedto,createdBy,createdOn,modifiedOn,
 modifiedBy,familyMigratedTo,familyMigratedFrom,uniqueHealthId

            ', true, 'ACTIVE', 'Resolved task by user in migrations');

Delete from query_master 
where code='mark_as_lfu';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES ( 1, now(), 'mark_as_lfu', 'userid,id', 
            'UPDATE public.migration_master
   SET  
       confirmed_by=#userid#, 
       confirmed_on=now(),  modified_on=now(), 
       modified_by=#userid#, state=''LFU''
       
 WHERE id=#id#;'
       
 , false, 'ACTIVE', 'Update status of member to lfu');