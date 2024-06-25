update query_master set query = '
with counts as (
	select member_id, max(id) as id, count(*)
	from migration_master
	group by member_id
), loc as (
	select child_id as loc from location_hierchy_closer_det  where parent_id in (
		case when #locationId# is null then (
			select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''
		) else #locationId# end
	)
), migration as (
	select mig.*, counts.count
	from migration_master mig
	inner join counts on mig.member_id = counts.member_id and mig.id = counts.id
	inner join loc on loc.loc = mig.location_migrated_from
	where (mig.out_of_state is null or mig.out_of_state = false) 
	and mig.type = ''OUT'' 
	and mig.migrated_location_not_known = true 
	and mig.state = ''REPORTED''
	order by mig.created_on desc
	limit #limit# offset #offset#
), member_migration as (
	select m.id as memberid, 
	migration.id as migrationid, 
	m.first_name || '' '' || m.last_name as fullname,
	m.mobile_number as contactnumber, 
	migration.location_migrated_from as locationmigratedfrom ,
	migration.location_migrated_to as locationmigratedto,
	migration.migrated_location_not_known as migratedlocationnotknown,
	migration.created_by as createdBy, migration.created_on as createdOn,
	migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
	migration.family_migrated_from as familyMigratedFrom,
	migration.family_migrated_to as familyMigratedTo,
	m.unique_health_id as uniqueHealthId, count
	from migration, imt_member m
	where m.id=migration.member_id
)
select memberid, migrationid, fullname, contactnumber, uniqueHealthId, count,
locationmigratedto, locationmigratedFrom, familyMigratedTo, familyMigratedFrom,
migratedlocationnotknown, createdBy, createdOn, modifiedOn, modifiedBy, 
get_location_hierarchy(locationmigratedfrom) as locationfromName
from member_migration
',
description = 'Unresolved migrated out members retrieval'
where code = 'lfu_migrated_membbers_retrival';


update query_master set query = '
with loc as (
	select child_id as loc from location_hierchy_closer_det  where parent_id in (
		case when #locationId# is null then (
			select loc_id from um_user_location where user_id = #userid# and state = ''ACTIVE''
		) else #locationId# end
	)
)
select mig.id, location_migrated_to, family_migrated_to, mig.state, (mobile_data),
u.id as fhwid, u.first_name || '' '' || u.last_name as fhwName, u.contact_number as fhwMobile, 
m.name || '' ('' || (
	case 
		when m.type = ''B'' then ''Block'' 
		when m.type = ''D'' then ''District'' 
		when m.type = ''Z'' then ''Zone'' 
		when m.type = ''C'' then ''Corporation'' 
	end
) || '')'' as dist_block
from  migration_master mig
inner join loc on loc.loc = mig.location_migrated_to
inner join um_user_location ul on mig.location_migrated_to = ul.loc_id and ul.state = ''ACTIVE''
inner join um_user u on ul.user_id = u.id and u.state=''ACTIVE'' and u.role_id = 30
left join location_master m on mig.nearest_loc_id = m.id
where (mig.out_of_state is null or mig.out_of_state = false)
and mig.type = ''IN'' and mig.state = ''REPORTED'' 
and mig.member_id is null
order by mig.created_on desc
limit #limit# offset #offset#
',
description = 'Unresolved migrated in members retrieval'
where code = 'migrated_in_members';



update query_master set query = '
with loc as (
	select child_id as loc from location_hierchy_closer_det  where parent_id in (
		case when #locationId# is null then (
			select loc_id from um_user_location where user_id = #userid# and state = ''ACTIVE''
		) else #locationId# end
	)
), migration as (
	select * from migration_master mig
	inner join loc on loc.loc = mig.location_migrated_from
	where type = ''OUT'' and migrated_location_not_known = true and mig.state = ''LFU''
	order by mig.created_on desc
	limit #limit# offset #offset#
), member_migration as(
	select m.mobile_number as contactnumber, m.id as memberid, 
	m.first_name || '' '' || m.last_name as fullname, 
	m.unique_health_id as uniqueHealthId, migration.id as migrationid, 
	migration.location_migrated_from as locationmigratedfrom,
	migration.location_migrated_to as locationmigratedto ,
	migration.migrated_location_not_known as migratedlocationnotknown,
	migration.created_by as createdBy, migration.created_on as createdOn ,
	migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
	migration.family_migrated_from as familyMigratedFrom,
	migration.family_migrated_from as familyMigratedTo
	from migration, imt_member m
	where m.id = migration.member_id
)
select memberid, fullname, migrationid, locationmigratedto, migratedlocationnotknown,
createdBy, createdOn, modifiedOn, modifiedBy, uniqueHealthId, familyMigratedTo, familyMigratedFrom,
get_location_hierarchy(locationmigratedfrom) as locationfromName 
from member_migration
',
description = 'LFU marked member retrieval'
where code = 'member_marked_lfu_retrival';



update query_master set query = '
with loc as (
	select child_id as loc from location_hierchy_closer_det  where parent_id in (
		case when #locationId# is null then (
			select loc_id from um_user_location where user_id = #userid# and state = ''ACTIVE''
		) else #locationId# end
	)
), migration as (
	select * from migration_master mig
	inner join loc on loc.loc = mig.location_migrated_from
	where (
		mig.state in (''LFU'',''CONFIRMED'',''ROLLBACK'') 
		or mig.status=''PENDING''
	) 
	and modified_by = #userid# 
	order by mig.created_on desc
	limit #limit# offset #offset#
), member_migration as(
	select  m.mobile_number as contactnumber,migration.state as mig_state,status,
	m.id as memberid, m.first_name || '' '' || m.last_name as fullname, 
	migration.id as migrationid, migration.location_migrated_from as locationmigratedfrom,
	migration.location_migrated_to as locationmigratedto ,
	migration.migrated_location_not_known as migratedlocationnotknown,
	migration.type as migrationtype,
	migration.created_by as createdBy, migration.created_on as createdOn ,
	migration.modified_by as modifiedBy, migration.modified_on as modifiedOn,
	migration.family_migrated_from as familyMigratedFrom,
	migration.family_migrated_from as familyMigratedTo,
	m.unique_health_id as uniqueHealthId
	from migration , imt_member m
	where m.id = migration.member_id
)
select memberid, fullname,
migrationid,locationmigratedto,locationmigratedfrom,migratedlocationnotknown,migrationtype,
createdBy,createdOn,modifiedOn,modifiedBy,uniqueHealthId,familyMigratedTo,familyMigratedFrom,
case when member_migration.status is not null then member_migration.status else member_migration.mig_state end as status ,
get_location_hierarchy(locationmigratedfrom) as locationfromName,
get_location_hierarchy(locationmigratedto) as locationtoname
from member_migration
',
description = 'Resolved migration tasks that are done by user'
where code = 'migration_resolved_tasks';



update query_master set query = '
with member as(
	select m.*, f.hof_id, f.location_id, 
	head.first_name || '' '' || head.middle_name || '' '' || head.last_name as headName,
	head.mobile_number as headContactNumber from imt_member m 
	inner join imt_family f on m.family_id = f.family_id
	inner join imt_member head on head.id = f.hof_id
	where m.id = #memberId#
), children as (
	select concat(first_name, '' '', middle_name, '' '', last_name) as fullname, 
	dob, mother_id, id, weight, unique_health_id as uniquehealthid 
	from imt_member 
	where mother_id = #memberId#
), asha as (
	select member.*, 
	um_user.first_name || '' ''  || um_user.middle_name || '' '' || um_user.last_name as fhwName , 
   	um_user.contact_number as fhwContactNumber
    from member, um_user, um_user_location l 
    where l.state = ''ACTIVE''
    and um_user.id = l.user_id
    and um_user.state = ''ACTIVE''
   	and l.loc_id= member.location_id
)
select asha.mobile_number as contactnumber, asha.id,asha.unique_health_id as uniquehealthid, concat(asha.first_name, '' '', asha.middle_name, '' '', asha.last_name) fullname,
asha.fhwName, asha.fhwContactNumber,
get_location_hierarchy(asha.location_id) as locationfromName,
asha.family_id as familyid,
asha.headname, asha.headcontactnumber,
case when count(children.*) > 0 then cast(array_to_json(array_agg(row_to_json(children.*)))as text) end as child
from asha 
left join children on asha.id = children.mother_id
group by asha.id,asha.unique_health_id,asha.first_name,asha.middle_name,asha.last_name,asha.headcontactnumber,asha.headname,asha.family_id,
asha.fhwName,asha.fhwContactNumber,asha.mobile_number,locationfromName
',
description = 'Retrieve details of unresolved migrated out members'
where code = 'retrieve_member_details_for_mig';



update query_master set query = '
update public.migration_master
set location_migrated_to = #locationid#, 
migrated_location_not_known = false, confirmed_by = #userid#, 
confirmed_on = now(), status=''PENDING'', 
modified_on = now(), modified_by = #userid#
where id = #id#;

with member_details as(
	select id as "memberId", first_name as "firstName", middle_name as "middleName", last_name as "lastName", 
	family_id as "familyId", unique_health_id as "healthId"
	from imt_member where id = #memberid#
), loc as (
	select location_master.name as "locationDetails" 
	from migration_master, location_master 
	where location_master.id = migration_master.location_migrated_from
	and migration_master.id = #id#
), fhw as (
	select first_name || '' '' || middle_name || '' '' || last_name as "fhwName", 
	contact_number as "fhwPhoneNumber"
	from migration_master mm
	inner join um_user_location ul on mm.location_migrated_from = ul.loc_id and ul.state = ''ACTIVE''
	inner join um_user u on ul.user_id = u.id and u.state = ''ACTIVE'' and u.role_id = 30
	where mm.id = #id#
)
INSERT INTO public.techo_notification_master(
	notification_type_id,  location_id, other_details,schedule_date,state,migration_id,member_id,created_by,created_on,modified_by,modified_on
)
select id, #locationid#, row_to_json(t), now(), ''PENDING'', #id#, #memberid#, #userid#, now(), #userid#, now()
from notification_type_master, (select * from member_details,loc, fhw) t where code = ''MI''
',
description = 'Update the location of a member where he/she has been migrated to'
where code = 'mark_migrated_location';


update query_master set query = '
update migration_master 
set state = ''ROLLBACK'',
confirmed_by = #userid#, confirmed_on = now(), 
modified_by = #userid#, modified_on = now()
where id = #id#;

update techo_notification_master  
set modified_on = now(), modified_by = #userid#, 
state = case 
			when state = ''MARK_AS_MIGRATED_PENDING'' then ''PENDING''
			when state = ''MARK_AS_MIGRATED_RESCHEDULE'' then ''RESCHEDULE''
		end
where state in (''MARK_AS_MIGRATED_PENDING'', ''MARK_AS_MIGRATED_RESCHEDULED'') 
and member_id = #memberid#;

update event_mobile_notification_pending  
set state = ''PENDING'',
modified_on = now(), modified_by = #userid#
where state = ''MARK_AS_MIGRATED_PENDING'' 
and member_id = #memberid#;

update imt_member 
set state = imt_member_state_detail.from_state,
modified_on = now(), modified_by = #userid#
from imt_member_state_detail 
where imt_member.id = #memberid#
and imt_member.state=''com.argusoft.imtecho.member.state.migrated''
and imt_member.current_state = imt_member_state_detail.id;

insert into techo_notification_master (
	notification_type_id, member_id, location_id, schedule_date, 
	state, created_by, created_on, modified_by, modified_on, 
	migration_id, other_details, header
)
select (
	select id from notification_type_master  where code=''READ_ONLY''
), 
#memberid#,
f.location_id,
now(),
''PENDING'',
#userid#,
now(),
#userid#,
now(),
#id#,
concat(
	''Your request for Migration In has been Rejected.'',
	chr(10),
	'' Name : '',
	m.first_name,
	'' '',
	m.middle_name,
	'' '',
	m.last_name,
	chr(10),
	'' Member ID : '',
	m.unique_health_id,
	chr(10),
	'' Family Migrated to : '',
	m.family_id,
	chr(10),
	'' Location Migrated to : '',
	get_location_hierarchy(f.location_id)
),
concat(
	m.unique_health_id,
	'' - '',
	m.first_name,
	'' '',
	m.middle_name,
	'' '',
	m.last_name
) as header
from imt_member m 
inner join imt_family f on f.family_id = m.family_id
where m.id = #memberid#;
',
description = 'Rollback to the location from where a member has been migrated from'
where code = 'mark_as_rollback';



update query_master set query = '
update migration_master
set confirmed_by = #userid#, confirmed_on = now(),
modified_by = #userid#, modified_on = now(), 
state = ''LFU'',
out_of_state = #outOfState#
where id = #id#;
',
description = 'Mark a member as LFU from unresolved migrated out members'
where code = 'mark_as_lfu';


