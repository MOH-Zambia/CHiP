--delete and insert for update query in query_master for code = 'mark_migrated_family_location'

delete from query_master where code = 'mark_migrated_family_location';

insert into query_master (created_by , created_on , modified_by , modified_on, code , params , query ,returns_result_set , state , description)
VALUES (-1  , now() , -1  , now() , 'mark_migrated_family_location' , 'familyid,areaid,locationid,id,userid',
	   'update imt_family_migration_master set location_migrated_to = #locationid# , area_migrated_to = #areaid# ,migrated_location_not_known = false , confirmed_on = now() , confirmed_by = #userid# , modified_on = now() , modified_by = #userid# where  id=#id#;

with family_details as(

select id as "familyId"  , family_id as "familyIdString"
from imt_family  where id = #familyid# 
),

member_details as(

select ARRAY(
select row_to_json(tm.*) from (
select  unique_health_id as "healthId" , first_name as "firstName", middle_name as "middleName", last_name as "lastName"
from imt_member where family_id=(select family_id from imt_family where id = #familyid#) ) tm
) as "memberDetails"
	
),

location_details as(

                 select string_agg(l.name,''>'' order by ld.depth desc) as  "locationDetails" from location_hierchy_closer_det ld,
                 location_master l  where child_id  = #locationid# and ld.parent_id = l.id
),

area_details as(

                select string_agg(l.name,''>'' order by ld.depth desc)  as "areaDetails" from location_hierchy_closer_det ld,
                location_master l  where child_id  = #areaid# and ld.parent_id = l.id
),


fhw as (

	select first_name || '' '' || middle_name || '' '' || last_name as "fhwName", 
	contact_number as "fhwPhoneNumber"
	from imt_family_migration_master fm
	inner join um_user_location ul on fm.location_migrated_from = ul.loc_id and ul.state = ''ACTIVE''
	inner join um_user u on ul.user_id = u.id and u.state = ''ACTIVE'' and u.role_id = (select id from um_role_master where name = ''FHW'')
	where fm.id = #id#

) ,
otherInfo as (

	select other_information as "otherInfo" from imt_family_migration_master where id = #id#

)
 									  
INSERT INTO public.techo_notification_master(
	notification_type_id,  location_id, other_details,schedule_date,state,migration_id,family_id,created_by,created_on,modified_by,modified_on
)
select id, #locationid#, row_to_json(t), now(), ''PENDING'', #id#, #familyid#, #userid#, now(), #userid#, now()
from notification_type_master, ( select * from   family_details , member_details, location_details , area_details , fhw , otherInfo ) t where code = ''FMI'';' ,
false , 'ACTIVE' , 'Mark Migrated Location Of Family' 
);