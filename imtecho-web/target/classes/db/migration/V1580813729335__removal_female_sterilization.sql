update menu_config
SET feature_json ='{"canModifyMemberDob":false,"canModifyMemberGender":false,"canModifyPregnancyRegDate":false,"canModifyLmpDate":false,"canModifyAncServiceDate":false,"canModifyWpdServiceDate":false,"canModifyWpdDeliveryDate":false,"canModifyPncServiceDate":false,"canModifyChvServiceDate":false,"canModifyImmuGivenDate":false,"canModifyWpdDeliveryPlace":false, "canMarkAsEligibleCouple":false}'
WHERE menu_name  = 'Helpdesk Tool - Search' and active ='t';

delete from query_master where code='remove_last_method_of_contraception';
INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'remove_last_method_of_contraception','unique_health_id,reason_for_change',
'with insert_change_log_detail as (
insert into support_change_request_log(member_id,change_type,other_detail,reason_for_change,created_on)
select id as member_id,''REMOVE_LAST_METHOD_OF_CONTRACEPTION'',null,(case when ''null'' = ''#reason_for_change#'' then null else  ''#reason_for_change#'' end ),created_on from imt_member
where unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id
),update_imt_member as (
update imt_member set last_method_of_contraception = null,modified_on = now() where  unique_health_id = ''#unique_health_id#'' and last_method_of_contraception is not null
returning id)
select cast(''Changes done'' as text) result from update_imt_member;'
,true,'ACTIVE','');

delete from query_master where code='retrieve_member_info_by_health_id';
INSERT INTO public.query_master(
            created_by, created_on, modified_by, modified_on, code, params, 
            query, returns_result_set, state, description)
VALUES(-1,now(),-1,now(),'retrieve_member_info_by_health_id','healthid',
'select m.unique_health_id as "uniqueHealthId",m.id as "memberId", concat( m.first_name, '' '' ,m.middle_name ,'' '',m.last_name) as "memberName",  
                    m.family_id as "familyId", m.dob as "dob",  
                    case when m.aadhar_number_encrypted is not null then ''Yes'' else ''No'' end as "aadharAvailable", 
                    m.mobile_number as "mobileNumber", m.is_pregnant as "isPregnantFlag", m.gender,  
                    m.basic_state as "memberState", m.ifsc, m.account_number as "accountNumber",  
                    m.family_head as "familyHeadFlag", m.immunisation_given as "immunisationGiven", 
                    case when (m.dob > now() - interval ''5 years'') then ''Yes'' else ''No'' end as "isChild", 
                    case when (
				(m.fp_insert_operate_date is null or  ( now() - m.fp_insert_operate_date < interval ''3 month''))
				and (m.last_method_of_contraception is null or m.last_method_of_contraception not in (''FMLSTR'',''MLSTR''))
				and (m.hysterectomy_done is null or m.hysterectomy_done = false)
				and (m.menopause_arrived is null or  m.menopause_arrived = false)
				and (m.is_pregnant is null or m.is_pregnant = false)
				and (m.dob < now() - interval ''18 years'' and m.dob > now() - interval ''45 years'')
				and m.marital_status = 629
				and m.gender = ''F''
			)  then ''Yes'' else ''No'' end as "isEligibleCouple",
			case when m.last_method_of_contraception in (''FMLSTR'',''MLSTR'') then true else false end as "isFemaleSterilizationFlag",
		    concat(case 
			  when (now() - m.fp_insert_operate_date > interval ''3 month'') then (
			   case 
			    when m.last_method_of_contraception in (''IUCD5'',''IUCD10'') then '' Last contraception method is IUCD.''
			    when m.last_method_of_contraception = ''CHHAYA'' then '' Last contraception method is CHHAYA.''
			    when m.last_method_of_contraception = ''ANTARA'' then '' Last contraception method is ANTARA.''
			   end
			  )end,
			 case when m.last_method_of_contraception = ''FMLSTR'' then '' Last contraception method is FEMALE STERILIZATION.'' end,
			 case when m.last_method_of_contraception = ''MLSTR'' then ''Last contraception method is MALE STERILIZATION.'' end,
			 case when m.menopause_arrived = true then ''Menopause is arrived.'' end,
			 case when m.marital_status != 629 then ''Merital status is not married.'' end,
			 case when m.is_pregnant = true then ''Member is pregnant.'' end,
			 case when m.hysterectomy_done = true then ''Hysterectomy is done.'' end,
			 case when (m.dob > now() - interval ''18 years'' and m.dob < now() - interval ''45 years'') then ''Age is not between 18 to 45 year.'' end,
			 case when m.gender = ''M'' then ''Member is Male.'' end
			) as "reasonForNotEligibleCouple",
                    (select string_agg(to_char(created_on, ''dd/mm/yyyy''),'','' order by created_on desc)  
                    from rch_child_service_master  where member_id  = m.id group by member_id) as "childServiceVisitDatesList", 
                    m.weight as weight, m.haemoglobin, 
                    concat( usr.first_name , '' '' , usr.middle_name , '' '' , usr.last_name)  as "fhwName", 
                    concat(ashaName.first_name , '' '' , ashaName.middle_name , '' '' , ashaName.last_name)  as "ashaName",
                    usr.user_name as fhwUserName, usr.contact_number as "fhwMobileNumber", 
                    (select concat(first_name , '' '' , middle_name , '' '' , last_name) from imt_member where id = m.mother_id) as "motherName" , 
                    (select string_agg(to_char(service_date , ''dd/mm/yyyy''),'','' order by service_date  desc)  
                    from rch_anc_master where member_id  = m.id group by member_id) as "ancVisitDatesList", 
                    f.basic_state as "familyState", 
                    string_agg(lm.name,''> '' order by lhcd.depth desc) as "memberLocation",
                    case when f.area_id is not null then get_location_hierarchy(f.area_id) else null end as "areaHierarchy"
                    from imt_member m  
                    left join imt_family f on f.family_id = m.family_id 
                    left join um_user_location ul on f.location_id = ul.loc_id  and ul.state = ''ACTIVE'' 
                    left join um_user usr on ul.user_id = usr.id and usr.role_id = 30 and usr.state = ''ACTIVE'' 
                    left join um_user_location ashaLoc on f.area_id = ashaLoc.loc_id  and ashaLoc.state = ''ACTIVE'' 
                    left join um_user ashaName on ashaLoc.user_id = ashaname.id and ashaName.role_id = 24 and ashaName.state = ''ACTIVE''
                    left join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id 
                    left join location_master lm on lm.id = lhcd.parent_id 
                    left join location_type_master loc_name on lm.type = loc_name.type 
                    where unique_health_id = ''#healthid#''
                    group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,
                    ashaName.middle_name,ashaName.last_name,m.unique_health_id,f.basic_state,f.area_id limit 1'
,true,'ACTIVE','');

