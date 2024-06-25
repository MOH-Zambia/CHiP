DELETE FROM QUERY_MASTER WHERE CODE='retrieve_family_and_member_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'83a1447e-2abe-43c9-94d5-3ee37aaa5460', 79677,  current_date , 79677,  current_date , 'retrieve_family_and_member_info', 
'familyid', 
'with emamtalocation as (
        select
        f.family_id,string_agg(lm.name,''> '' order by lhcd.depth desc) as emamtalocationname
        from imt_family f
	    inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
	    inner join location_master lm on lm.id = lhcd.parent_id where f.family_id = #familyid#
	    group by f.family_id
    ), family_migration_det as (
	select distinct on (family_id ) family_id, location_migrated_from , location_migrated_to , reported_by , reported_on, state from  imt_family_migration_master ifmm 
	where ifmm.family_id = (select id from imt_family imf where family_id = #familyid#)
	order by family_id , id desc
	limit 1
)
    select
    f.family_id,
    f.address1 as address1,
    f.address2 as address2,
    f.bpl_flag as bplflag,
    f.house_number as housenumber,
    f.is_verified_flag as verifiedflag,
    f.migratory_flag as migratoryflag,
    f.toilet_available_flag as toiletavailableflag,
    f.vulnerable_flag as vulnerableflag,
    f.basic_state as familybasicstate,
    m.id as memberid,
    m.unique_health_id as uniquehealthid,
    m.first_name || '' '' || m.middle_name || '' '' || m.last_name as membername,
    m.family_head as familyhead,
    m.is_pregnant as ispregnant,
    m.gender as gender,
    m.mobile_number as mobilenumber,
    m.basic_state as memberbasicstate,
    string_agg(lm.name,''> '' order by lhcd.depth desc) as locationname,
    emm.emamtalocationname,
    case
        when f.state in (''CFHC_FN'',''CFHC_FV'') then ''Yes''
        else ''No''
    end as "isFamilyVerifiedUnderCFHC",
    get_location_hierarchy(fmd.location_migrated_from) as "familyMigratedFrom",
    get_location_hierarchy(fmd.location_migrated_to) as "familyMigratedTo",
    (select concat( uu.first_name , '' '' , uu.middle_name , '' '' , uu.last_name, ''( UserName: '', uu.user_name , '', Mobile Number: '', uu.contact_number, '')'') from um_user uu  where uu.id = fmd.reported_by)  as "familyReportedBy",
    to_char(fmd.reported_on, ''dd/mm/yyyy'') as "familyReportedOn"
    from imt_family f
    inner join imt_member m on f.family_id = m.family_id
    inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
    inner join location_master lm on lm.id = lhcd.parent_id
    left join family_migration_det fmd on fmd.family_id = f.id and fmd.state = ''REPORTED''
    left join emamtalocation emm on f.family_id = emm.family_id
    where f.family_id = #familyid#
    group by m.id,
    f.address1,
    f.address2,
    f.bpl_flag,
    f.house_number,
    f.is_verified_flag,
    f.migratory_flag,
    f.toilet_available_flag,
    f.vulnerable_flag,
    f.basic_state,
    emm.emamtalocationname,
    f.family_id,
    f.state,
     fmd.location_migrated_from, fmd.location_migrated_to, fmd.reported_by, fmd.reported_on', 
'Retrieve family and members basic info using familyId', 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_member_info_by_health_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9ac89158-c675-4c52-b423-9de8294675c7', 79677,  current_date , 79677,  current_date , 'retrieve_member_info_by_health_id', 
'healthid', 
'with member_migration_det as (
	select distinct on (member_id) location_migrated_from , location_migrated_to, reported_by,reported_on, member_id, state from migration_master mm 
	where mm.member_id = (select id from imt_member im where im.unique_health_id = #healthid#)
	order by member_id, id desc
	limit 1
), family_migration_det as (
	select distinct on (family_id ) family_id, location_migrated_from , location_migrated_to , reported_by , reported_on, state from  imt_family_migration_master ifmm 
	where ifmm.family_id = (select id from imt_family imf where imf.family_id in (select family_id from imt_member im where im.unique_health_id = #healthid#))
	order by family_id , id desc
	limit 1
)
select m.unique_health_id as "uniqueHealthId",m.id as "memberId", concat( m.first_name, '' '' ,m.middle_name ,'' '',m.last_name) as "memberName",  
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
                    (select string_agg(to_char(service_date, ''dd/mm/yyyy''),'','' order by created_on desc)  
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
                    case when f.area_id is not null then get_location_hierarchy(f.area_id) else null end as "areaHierarchy",
                    to_char(m.created_on, ''dd/mm/yyyy'') as "createdOn" ,
                    to_char(m.modified_on , ''dd/mm/yyyy'') as "modifiedOn",
                    get_location_hierarchy(mmd.location_migrated_from) as "memberMigratedFrom",
                    get_location_hierarchy(mmd.location_migrated_to) as "memberMigratedTo",
                    (select concat( uu.first_name , '' '' , uu.middle_name , '' '' , uu.last_name, ''( UserName: '', usr.user_name , '', Mobile Number: '', usr.contact_number, '')'') from um_user uu  where uu.id = mmd.reported_by)as "memberReportedBy",
                    to_char(mmd.reported_on, ''dd/mm/yyyy'') as "memberReportedOn",
                    get_location_hierarchy(fmd.location_migrated_from) as "familyMigratedFrom",
                    get_location_hierarchy(fmd.location_migrated_to) as "familyMigratedTo",
                    (select concat( uu.first_name , '' '' , uu.middle_name , '' '' , uu.last_name, ''( UserName: '', usr.user_name , '', Mobile Number: '', usr.contact_number, '')'') from um_user uu  where uu.id = fmd.reported_by)  as "familyReportedBy",
                    to_char(fmd.reported_on, ''dd/mm/yyyy'') as "familyReportedOn"
                    from imt_member m  
                    left join imt_family f on f.family_id = m.family_id 
                    left join member_migration_det mmd on mmd.member_id = m.id and mmd.state = ''REPORTED''
                    left join family_migration_det fmd on fmd.family_id = f.id and fmd.state = ''REPORTED''
                    left join um_user_location ul on f.location_id = ul.loc_id  and ul.state = ''ACTIVE'' 
                    left join um_user usr on ul.user_id = usr.id and usr.role_id = 30 and usr.state = ''ACTIVE'' 
                    left join um_user_location ashaLoc on f.area_id = ashaLoc.loc_id  and ashaLoc.state = ''ACTIVE'' 
                    left join um_user ashaName on ashaLoc.user_id = ashaname.id and ashaName.role_id = 24 and ashaName.state = ''ACTIVE''
                    left join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id 
                    left join location_master lm on lm.id = lhcd.parent_id 
                    left join location_type_master loc_name on lm.type = loc_name.type 
                    where unique_health_id = #healthid#
                    group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,
                    ashaName.middle_name,ashaName.last_name,m.unique_health_id,f.basic_state,f.area_id,mmd.location_migrated_from, mmd.location_migrated_to,
                    mmd.reported_by, mmd.reported_on, fmd.location_migrated_from, fmd.location_migrated_to, fmd.reported_by, fmd.reported_on
                    limit 1', 
'', 
true, 'ACTIVE');