--Migration out members where out of state is not true
Delete from query_master 
where code='lfu_migrated_membbers_retrival';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'lfu_migrated_membbers_retrival','userId,offset,limit,locationId', 
            '
with migration as (select * from migration_master mig
where
(mig.out_of_state is null or mig.out_of_state=false) and 
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
--Migration in members where out of state is not true and member id is null
Delete from query_master 
where code='migrated_in_members';

INSERT INTO public.query_master(
             created_by, created_on,  code, params, 
            query, returns_result_set, state, description)
    VALUES (1, now(), 'migrated_in_members','userid,offset,limit,locationId', 
            '
select u.id as fhwid,u.first_name || '' '' || u.last_name as fhwName,u.contact_number as fhwMobile, mig.id,location_migrated_to, mig.state, (mobile_data) from  migration_master mig
--left join migration_in_member_analytics a on mig.id=a.migration_id
left join um_user_location  ul on mig.location_migrated_to= ul.loc_id and ul.state=''ACTIVE''
inner join um_user u on ul.user_id=u.id and u.role_id in (select id from um_role_master  where code=''FHW'' or code=''ASHA'') and u.state=''ACTIVE''
where
(mig.out_of_state is null or mig.out_of_state=false) and 
mig.type=''IN''  and mig.state=''REPORTED'' and
mig.member_id is null and 
(#locationId# is null and location_migrated_to in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userid# and is_active=true )))
 or(#locationId# is not null and location_migrated_to in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
)
--group by mig.id,location_migrated_to, mig.state, (mobile_data)
order by mig.created_on desc
limit #limit# offset #offset#
            ', true, 'ACTIVE', 'Retrival of migrated in members which are not known');


CREATE TABLE public.migration_in_member_analytics
(
    member_id bigint, 
    migration_id bigint, 
    id bigserial, 
    state text,
    created_on timestamp without time zone,
    created_by bigint,
    modified_on timestamp without time zone,
    modified_by bigint,
   PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
)
;
ALTER TABLE public.migration_master
  ADD COLUMN similar_member_verified boolean;