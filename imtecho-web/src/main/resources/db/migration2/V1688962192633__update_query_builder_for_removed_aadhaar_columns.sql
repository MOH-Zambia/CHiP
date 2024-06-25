DELETE FROM QUERY_MASTER WHERE CODE='retrieve_anc_member_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'eed9134b-6929-480e-b29e-911811a0258a', -1,  current_date , -1,  current_date , 'retrieve_anc_member_details',
'id',
'with loc_area_ids as (
	select location_id,area_id
	from imt_family,imt_member
	where imt_member.family_id = imt_family.family_id
	and imt_member.id = #id#
),fhw_details as (
	select loc_area_ids.location_id,concat(u.first_name,'' '',u.last_name,'' ('',contact_number,'')'') as anmInfo
	from um_user u, um_user_location ul,loc_area_ids
	where u.id = ul.user_id and ul.state = ''ACTIVE'' and u.state = ''ACTIVE'' and u.role_id = 30 and ul.loc_id = loc_area_ids.location_id
),asha_details as (
	select loc_area_ids.area_id, concat(u.first_name,'' '',u.last_name,'' ('',contact_number,'')'') as ashaInfo
	from um_user u, um_user_location ul,loc_area_ids
	where u.id = ul.user_id and ul.state = ''ACTIVE'' and u.state = ''ACTIVE'' and u.role_id = 24 and ul.loc_id = loc_area_ids.area_id
), gravida as (
	select #id# as mother_id, count(*) as gravida from (
		select mother_id
		from imt_member where mother_id = #id#
		group by mother_id, dob
	) as t
)
select
unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
account_number as "accountNumber",
ifsc as "ifsc",
imt_member.additional_info as "additionalInfo",
anc_visit_dates as "ancVisitDates",
imt_family.area_id as "areaId",
blood_group as "bloodGroup",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
cur_preg_reg_date as "curPregRegDate",
cur_preg_reg_det_id as "curPregRegDetId",
dob as "dob",
edd as "edd",
family_planning_method as "familyPlanningMethod",
imt_family.id as "fid",
first_name as "firstName",
middle_name as "middleName",
last_name as "lastName",
gender as "gender",
haemoglobin as "haemoglobin",
imt_member.id as "id",
immunisation_given as "immunisationGiven",
early_registration as "isEarlyRegistration",
iay_beneficiary as "isIayBeneficiary",
jsy_beneficiary as "isJsyBeneficiary",
jsy_payment_given as "isJsyPaymentDone",
kpsy_beneficiary as "isKpsyBeneficiary",
chiranjeevi_yojna_beneficiary as "isChiranjeeviYojnaBeneficiary",
is_mobile_verified as "isMobileNumberVerified",
is_native as "isNativeFlag",
is_pregnant as "isPregnantFlag",
imt_member.is_report as "isReport",
last_delivery_date as "lastDeliveryDate",
last_delivery_outcome as "lastDeliveryOutcome",
lmp as "lmpDate",
get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
imt_family.location_id as "locationId",
imt_family.maa_vatsalya_number as "maaVatsalyaCardNumber",
marital_status as "maritalStatus",
mobile_number as "mobileNumber",
imt_member.state as "state",
weight as "weight",
year_of_wedding as "yearOfWedding",
fhw_details.anmInfo as "anmInfo",
asha_details.ashaInfo as "ashaInfo",
gravida.gravida as "gravida",
current_gravida as "currentGravida"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
left join fhw_details on imt_family.location_id = fhw_details.location_id
left join asha_details on imt_family.area_id = asha_details.area_id
left join gravida on imt_member.id = gravida.mother_id
where imt_member.id = #id#',
null,
true, 'ACTIVE');





DELETE FROM QUERY_MASTER WHERE CODE='retrieve_member_info_by_health_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9ac89158-c675-4c52-b423-9de8294675c7', -1,  current_date , -1,  current_date , 'retrieve_member_info_by_health_id',
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
                    case when m.aadhaar_reference_key is not null then ''Yes'' else ''No'' end as "aadharAvailable",
                    m.mobile_number as "mobileNumber", m.is_pregnant as "isPregnantFlag", m.gender,
                    m.basic_state as "memberState", m.ifsc, m.account_number as "accountNumber",
					date(mdd.dod) as "dateOfDeath", lvd.value as "deathReason" ,
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
 					left join rch_member_death_deatil mdd on mdd.member_id = m.id
 					left join listvalue_field_value_detail lvd on lvd.id = CAST (mdd.death_reason AS INTEGER)
                    where unique_health_id = #healthid#
                    group by m.id,usr.first_name,usr.middle_name,usr.last_name,usr.user_name,usr.contact_number,f.state,ashaName.first_name,
                    ashaName.middle_name,ashaName.last_name,m.unique_health_id,f.basic_state,f.area_id,mmd.location_migrated_from, mmd.location_migrated_to,
                    mmd.reported_by, mmd.reported_on, fmd.location_migrated_from, fmd.location_migrated_to, fmd.reported_by, fmd.reported_on ,mdd.dod , lvd.value
                    limit 1',
'',
true, 'ACTIVE');





DELETE FROM QUERY_MASTER WHERE CODE='get_rch_register_eligible_couple_service_detailed_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b490ba1c-a43d-452a-bcb7-d1b50ffce94e', -1,  current_date , -1,  current_date , 'get_rch_register_eligible_couple_service_detailed_info',
'member_id,from_date,to_date',
'with dates as (
	select
	to_date(case when #from_date# = null then null else #from_date# end,''MM/DD/YYYY'') as from_date,
	to_date(case when #to_date# = null then null else #to_date# end,''MM/DD/YYYY'')+ interval ''1 day'' - interval ''1 millisecond'' as to_date
),
lmp_followup_det as (
	select
	lfu.member_id,
	cast(
	    json_agg(
	        json_build_object(
	            ''date'',
	            to_char(lfu.service_date, ''dd-MM-yyyy''),
	            ''contraception_method'',
	            case
	                when lfu.family_planning_method = ''NONE'' then ''None''
	                when lfu.family_planning_method = ''ANTARA'' then ''Antara''
	                when lfu.family_planning_method = ''IUCD5'' then ''IUCD 5 Years''
	                when lfu.family_planning_method = ''IUCD10'' then ''IUCD 10 Years''
	                when lfu.family_planning_method = ''CONDOM'' then ''Condom''
	                when lfu.family_planning_method = ''ORALPILLS'' then ''Oral Pills''
	                when lfu.family_planning_method = ''CHHAYA'' then ''Chhaya''
	                when lfu.family_planning_method = ''ANTARA'' then ''Antara''
	                when lfu.family_planning_method = ''CONTRA'' then ''Emergency Contraceptive Pills''
	                when lfu.family_planning_method = ''FMLSTR'' then ''Female Sterilization''
	                when lfu.family_planning_method = ''MLSTR'' then ''Male Sterilization''
			        when lfu.family_planning_method = ''OTHER'' then ''Other''
			        when lfu.family_planning_method = ''CHHANT'' then ''Chhant''
	                else lfu.family_planning_method
                end,
                ''is_pregnant'',
                case
                    when lfu.is_pregnant is true then ''Yes''
                    else ''No''
                end
            )
        ) as text) as lmp_visit_info
	from rch_lmp_follow_up lfu
	inner join dates on lfu.created_on
		between dates.from_date and dates.to_date
	where lfu.member_status = ''AVAILABLE''
		and lfu.member_id = #member_id#
	group by lfu.member_id
),
last_child_dob as (
    select
    m.id as member_id,
    min(
        case
			when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then fam_mem.dob
			else null
		end) as last_child_dob
	from lmp_followup_det as eligible_couple
	inner join imt_member m on m.id = eligible_couple.member_id
	left join imt_member fam_mem on fam_mem.family_id = m.family_id
	group by m.id
),
eligible_couple_det as (
	select
	m.id as member_id,
	sum(case
			when fam_mem.mother_id = m.id then 1
			else 0
		end) as total_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''M'' then 1
			else 0
		end) as total_male_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''F'' then 1
			else 0
		end) as total_female_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''M'' and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then 1
			else 0
		end) as total_live_male_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''F'' and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then 1
			else 0
		end) as total_live_female_child,
	max(case
			when similarity(fam_mem.first_name,m.middle_name) > 0.8 then fam_mem.id
			else null
		end) as husband_id,
	min(
        case
			when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then fam_mem.dob
			else null
		end) as last_child_dob,
	max(
	    case
	        when last_child.gender is null then null
	        when last_child.gender = ''F'' then ''Female''
	        else ''Male''
	     end) as last_child_gender
	from lmp_followup_det as eligible_couple
	inner join imt_member m on m.id = eligible_couple.member_id
	left join imt_member fam_mem on fam_mem.family_id = m.family_id
	left join last_child_dob lcd on lcd.member_id = eligible_couple.member_id
	left join imt_member last_child on last_child.mother_id = m.id
	    and last_child.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'')
	    and last_child.dob in (select last_child_dob from last_child_dob)
	group by m.id
)
select
m.id as member_id,
m.unique_health_id as unique_health_id,
to_char(m.created_on, ''dd-MM-yyyy'') as registration_date,
concat_ws('' '', m.first_name, m.middle_name, m.last_name) as member_name,
case
    when m.aadhaar_reference_key is not null then ''Yes''
    else ''No''
end as member_aadhar_number_available,
case
	when m.account_number is null then ''No''
	else ''Yes''
end as member_bank_account_number_available,
EXTRACT(YEAR FROM age(cast(m.dob as date))) as member_current_age,
case
	when m.year_of_wedding is null then null
	else m.year_of_wedding - date_part(''year'', m.dob)
end as member_marriage_age,
case
    when m.husband_name is null then concat_ws('' '', m.middle_name, m.last_name)
    else m.husband_name
end as husband_name,
EXTRACT(YEAR FROM age(cast(husband.dob as date))) as husband_current_age,
case
	when m.year_of_wedding is null then null
	else m.year_of_wedding - date_part(''year'', husband.dob)
end as husband_marriage_age,
case
	when (f.address1 is null and f.address2 is null) then ''N/A''
	else
		case
			when f.address1 is null then f.address2
			when f.address2 is null then f.address1
			else concat(f.address1, '','', f.address2)
		end
end as address,
case
	when religion.value = ''HINDU'' then ''Hindu''
	when religion.value = ''CHRISTIAN'' then ''Christian''
	when religion.value = ''MUSLIM'' then ''Muslim''
	when religion.value = ''OTHERS'' then ''Others''
	else religion.value
end as religion,
case
	when caste.value = ''GENERAL'' then ''General''
	else caste.value
end as cast,
case
	when f.bpl_flag then ''BPL''
end as bpl_apl,
m.eligible_couple_date,
ec.total_male_child as total_given_male_birth,
ec.total_female_child as total_given_female_birth,
ec.total_live_male_child as live_male_birth,
ec.total_live_female_child as live_female_birth,
EXTRACT(YEAR FROM age(cast(ec.last_child_dob as date))) as smallest_child_age,
ec.last_child_gender as smallest_child_gender,
lmp_followup_det.lmp_visit_info as lmp_visit_info
from lmp_followup_det
inner join imt_member m on m.id = lmp_followup_det.member_id
inner join eligible_couple_det ec on lmp_followup_det.member_id = ec.member_id
inner join imt_family f on f.family_id=m.family_id
left join imt_member husband on husband.id =ec.husband_id
left join listvalue_field_value_detail religion on religion.id = cast(f.religion as int)
left join listvalue_field_value_detail caste on caste.id = cast(f.caste as int);',
null,
true, 'ACTIVE');





