--Create Sequence for gvk_family_migration_info;

DROP TABLE  IF EXISTS  public.gvk_family_migration_info;

CREATE TABLE public.gvk_family_migration_info
(
    id bigserial not NULL,
    family_migration_id bigint NOT NULL,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    gvk_call_status text COLLATE pg_catalog."default" DEFAULT 'com.argusoft.imtecho.gvk.call.to-be-processed'::text,
    call_attempt integer DEFAULT 0,
    schedule_date timestamp without time zone DEFAULT now(),
    CONSTRAINT gvk_family_migration_info_pkey PRIMARY KEY (id)
);

--Create Gvk Family Migration Response Table;

DROP TABLE  IF EXISTS public.gvk_family_migration_response;

CREATE TABLE public.gvk_family_migration_response
(
    id bigserial not NULL,
    family_id character varying(255) COLLATE pg_catalog."default" NOT NULL,
    migration_id bigint NOT NULL,
    gvk_call_response_status text COLLATE pg_catalog."default",
    performed_action text COLLATE pg_catalog."default",
    is_fhw_called boolean,
    is_asha_called boolean,
    is_member_called boolean,
    processing_time bigint,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    migration_type text COLLATE pg_catalog."default",
    manage_call_master_id bigint,
    CONSTRAINT gvk_family_migration_response_pkey PRIMARY KEY (id)
);

--Update Menu Config for adding canFamilyMigrationOutVerification

update menu_config  
    set feature_json  = '{"canAbsentVerification":true,"canFamilyVerification":true, "canGvkImmunisationVerification":true, 
			"canHighriskFollowupVerification":true, "canPregnancyRegistrationsVerification":true, 
			"canHighriskFollowupVerificationFowFhw":false, "canPregnancyRegistrationsPhoneNumberVerification":false, "canMemberMigrationOutVerification":false, 
			"canMemberMigrationInVerification":false, "canDuplicateMemberVerification":false, "canPerformEligibleCoupleCounselling":false, 
			"canBeneficiaryServiceVerification":false,"canAnc4Schedule": false,"canFamilyMigrationOutVerification":false}'
        where navigation_state = 'techo.dashboard.gvkverification';

--Insert queries in query_master for adding update_location  , rollback , lfu

insert into query_master (created_by , created_on , modified_by , modified_on, code , params , query ,returns_result_set , state , description)
VALUES (-1  , now() , -1  , now() , 'mark_migrated_family_location' , 'familyid,areaid,locationid,id,userid',
	   'update imt_family_migration_master set location_migrated_to = #locationid# , area_migrated_to = #areaid# , state=''PENDING'', migrated_location_not_known = false , confirmed_on = now() , confirmed_by = #userid# , modified_on = now() , modified_by = #userid# where  id=#id#;

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
) , 


(-1  , now() , -1  , now()  , 'mark_family_as_rollback' , 'familyid,id,userid' , 
 'update imt_family_migration_master 
set state = ''ROLLBACK'',
confirmed_by = #userid#, confirmed_on = now(), 
modified_by = #userid#, modified_on = now()
where id = #id#;

update imt_family 
set state = imt_family_state_detail.from_state,
modified_on = now(), modified_by = #userid#
from imt_family_state_detail 
where imt_family.id = #familyid#
and imt_family.state=''com.argusoft.imtecho.family.state.migrated''
and imt_family.current_state = imt_family_state_detail.id;


with family_details as(

select id as "familyId"  , family_id as "familyIdString"
from imt_family  where id = #familyid# 

),

member_details as(

select ARRAY(
select row_to_json(tm.*) from (
select  unique_health_id as "healthId" , first_name as "firstName", middle_name as "middleName", last_name as "lastName"
from imt_member where family_id=(select family_id from imt_family where id = #familyid#) ) tm
) as "memberDetails"),

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
 
insert into techo_notification_master (
	notification_type_id, family_id, location_id, schedule_date, 
	state, created_by, created_on, modified_by, modified_on, 
	migration_id, other_details, header
)
select (
	select id from notification_type_master  where code=''READ_ONLY''
), 
#familyid#,
f.location_id,
now(),
''PENDING'',
#userid#,
now(),
#userid#,
now(),
#id#,

concat(
	''Your request for Family Migration Out has been Rejected.'',
	chr(10),
	'' Details : '',
	row_to_json(t),
	'' Location Migrated to : '',
	get_location_hierarchy(f.location_id)
),
concat(
	''Family Migration  - '',
	chr(10),
	f.family_id
) as header
from imt_family f , ( select * from   family_details , member_details  , fhw , otherInfo ) t
where f.id = #familyid#;' , false , 'ACTIVE' , 'Rollback Family Migration') , 

(-1  , now() , -1  , now()  , 'mark_family_as_lfu' , 'outOfState,id,userid' , 
'update imt_family_migration_master
set confirmed_by = #userid#, confirmed_on = now(),
modified_by = #userid#, modified_on = now(), 
state = ''LFU'',
out_of_state = #outOfState#
where id = #id#;' , false , 'ACTIVE' , 'Mark Family As LFU'
);
