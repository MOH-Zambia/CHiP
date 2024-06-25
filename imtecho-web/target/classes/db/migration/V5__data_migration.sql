ALTER TABLE public.um_user
   ALTER COLUMN password TYPE character varying(250);

insert into um_role_master (id,created_by,created_on,modified_by,modified_on,code,description,name,state)
select usr_role.id,
case when crusr.id is null then 1 else crusr.id end ,usr_role.created_on,case when mdusr.id is null then 1 else mdusr.id end,usr_role.modified_on,
null,description,name,
case 
when usr_role.is_active=true and usr_role.is_archive=false then 'ACTIVE'  
when usr_role.is_active=false and usr_role.is_archive=false then 'INACTIVE'  
else 
'ARCHIVED' END
from usermanagement_system_role usr_role
left join usermanagement_system_user crusr on usr_role.created_by = crusr.user_id
left join usermanagement_system_user mdusr on usr_role.modified_by = mdusr.user_id;


insert into um_user
select usr.id,case when crusr.id is null then 1 else crusr.id end ,usr.created_on,case when mdusr.id is null then 1 else mdusr.id end,
usr.modified_on,
null,
case when uc.address is null then '' else uc.address end,null,
case when uc.mobile_number is null then '' else uc.mobile_number end,uc.date_of_birth,uc.email_address,uc.first_name,
uc.gender,uc.last_name,uc.middle_name, usr.password,usr.custom2,ur.role,
case 
when usr.is_active=true and usr.is_archive=false then 'ACTIVE'  
when usr.is_active=false and usr.is_archive=false then 'INACTIVE'  
else 
'ARCHIVED' END,
usr.user_id 
 from usermanagement_system_user  usr 
inner join usermanagement_user_contact uc on usr.id = uc.userobj
left join usermanagement_system_user crusr on usr.created_by = crusr.user_id
left join usermanagement_system_user mdusr on usr.modified_by = mdusr.user_id
left join usermanagement_user_role ur on usr.id = ur.userobj;

select setval('um_user_id_seq', max(id)) FROM um_user  ;

select setval('um_role_master_id_seq', max(id)) FROM um_role_master  ;

insert into location_type_master (type,name)
select  distinct(type),
case when type='B' then 'Block'
when type='P' then 'PHC'
when type='S' then 'State'
when type='U' then 'UPHC'
when type='D' then 'District'
when type='A' then 'Area' 
when type='V' then 'Village'
when type='SC' then 'Sub Center'
when type='C' then 'Corporation'
when type='Z' then 'Zone' 
when type='UA' then 'Urban Area' 
when type='ANG' then 'Anganwadi Area' 
when type='ANM' then 'ANM Area' 
when type='AA' then 'Asha Area' 
END 
from location_master;


insert into um_user_location (id,state,type,loc_id,user_id,created_by,modified_by,created_on,modified_on,level)
select loc_user.id, 
case when loc_user.is_active=true then 'ACTIVE' 
when loc_user.is_active=false then 'INACTIVE' end,
loc_user.location_type,loc_user.location,loc_user.user_id,1,1,current_date,current_date,case when level7 is not null then 7
when level6 is not null then 6
when level5 is not null then 5
when level4 is not null then 4
when level3 is not null then 3
when level2 is not null then 2
when level1 is not null then 1 end
from user_location_detail as loc_user
inner join location_master lm on lm.id=loc_user.location
inner join location_level_hierarchy_master lh on lh.id = lm.location_hierarchy_id;


select setval('um_user_location_id_seq ', max(id)) FROM um_user_location ;


ALTER TABLE public.location_master
   ALTER COLUMN id TYPE bigint;

   
update location_master set state = case 
when is_active=true then 'ACTIVE'  
when is_active=false then 'INACTIVE'
END;





/*ALTER TABLE public.course_master
   ALTER COLUMN course_id TYPE bigint;

   
ALTER TABLE public.course_topic_rel
  DROP COLUMN course_id;
ALTER TABLE public.course_topic_rel
  DROP COLUMN topic_id;
ALTER TABLE public.course_topic_rel
  ADD COLUMN course_id bigint;
ALTER TABLE public.course_topic_rel
  ADD COLUMN topic_id bigint;
  */
  
ALTER TABLE um_user_location 
DROP COLUMN if EXISTS heirarchy_type;

ALTER TABLE public.location_master
ALTER COLUMN location_hierarchy_id TYPE bigint;
   
ALTER TABLE public.location_master
ALTER COLUMN parent TYPE bigint;

-- ALTER TABLE public.topic_master
-- ALTER COLUMN topic_id TYPE bigint;
--    
-- ALTER TABLE public.topic_master
-- DROP COLUMN if EXISTS day;
-- 
-- ALTER TABLE public.topic_master
-- ADD COLUMN day integer;

ALTER TABLE um_user_location
ADD COLUMN heirarchy_type character varying(50);

ALTER TABLE public.um_user_location
DROP COLUMN if EXISTS level;

ALTER TABLE public.um_user_location
ADD COLUMN level integer;

