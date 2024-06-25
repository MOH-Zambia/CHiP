DELETE FROM public.query_master
 WHERE code='retrieve_member_info_by_health_id';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_member_info_by_health_id','healthid','select m.unique_health_id as "uniqueHealthId",m.id as "memberId", m.first_name || '' '' || m.middle_name || '' '' || m.last_name  as "memberName",  
                    m.family_id as "familyId", to_char(m.dob, ''dd/mm/yyyy'') as "dob",  
                    case when m.aadhar_number_encrypted is not null then ''Yes'' else ''No'' end as "aadharAvailable", 
                    m.mobile_number as "mobileNumber", m.is_pregnant as "isPregnantFlag", m.gender,  
                    m.basic_state as "memberState", m.ifsc, m.account_number as "accountNumber",  
                    m.family_head as "familyHeadFlag", m.immunisation_given as "immunisationGiven", 
                    case when (m.dob > now() - interval ''5 years'') then ''Yes'' else ''No'' end as "isChild", 
                    case when (m.dob < now() - interval ''18 years'' and m.dob > now() - interval ''45 years'')  then ''Yes'' else ''No'' end as "isEligibleCouple",
                    (select string_agg(to_char(created_on, ''dd/mm/yyyy''),'','' order by created_on desc)  
                    from rch_child_service_master  where member_id  = m.id group by member_id) as "childServiceVisitDatesList", 
                    m.weight as weight, m.haemoglobin, 
                    usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name  as "fhwName", 
                    ashaName.first_name || '' '' || ashaName.middle_name || '' '' || ashaName.last_name  as "ashaName",
                    usr.user_name as fhwUserName, usr.contact_number as "fhwMobileNumber", 
                    (select first_name || '' '' || middle_name || '' '' || last_name from imt_member where id = m.mother_id) as "motherName" , 
                    (select string_agg(to_char(created_on, ''dd/mm/yyyy''),'','' order by created_on desc)  
                    from rch_anc_master where member_id  = m.id group by member_id) as "ancVisitDatesList", 
                    f.basic_state as "familyState", 
                    string_agg(lm.name,''> '' order by lhcd.depth desc) as "memberLocation" 
                    from imt_member m  
                    left join imt_family f on f.family_id = m.family_id 
                    left join um_user_location ul on f.location_id = ul.loc_id  and ul.state = ''ACTIVE'' 
                    left join um_user usr on ul.user_id = usr.id and usr.role_id = 30 and usr.state = ''ACTIVE'' 
                    left join um_user_location ashaLoc on f.area_id = ashaLoc.loc_id  and ashaLoc.state = ''ACTIVE'' 
                    left join um_user ashaName on ashaLoc.user_id = ashaname.id and ashaName.role_id = 24 and ashaName.state = ''ACTIVE''
                    left join location_hierchy_closer_det lhcd on (case when f.area_id is null then f.location_id else cast(f.area_id as bigint) end) = lhcd.child_id 
                    left join location_master lm on lm.id = lhcd.parent_id 
                    left join location_type_master loc_name on lm.type = loc_name.type 
                    where unique_health_id = ''#healthid#'' 
                    group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,
                    ashaName.middle_name,ashaName.last_name,m.unique_health_id,f.basic_state limit 1',true,'ACTIVE','Retrieve Member Information by health id');