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
((#locationId# is null and location_migrated_to in (select child_id from location_hierchy_closer_det  where parent_id in 
(select location from user_location_detail  
where user_id=#userid# and is_active=true )))
 or(#locationId# is not null and location_migrated_to in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
))
--group by mig.id,location_migrated_to, mig.state, (mobile_data)
order by mig.created_on desc
limit #limit# offset #offset#
            ', true, 'ACTIVE', 'Retrival of migrated in members which are not known');

