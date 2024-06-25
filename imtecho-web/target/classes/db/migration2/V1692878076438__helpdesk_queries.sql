DELETE FROM QUERY_MASTER WHERE CODE='retrieve_member_info_by_health_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9ac89158-c675-4c52-b423-9de8294675c7', 97575,  current_date , 97575,  current_date , 'retrieve_member_info_by_health_id',
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
			 case when m.marital_status != 629 then ''Marital status is not married.'' end,
			 case when m.is_pregnant = true then ''Member is pregnant.'' end,
			 case when m.hysterectomy_done = true then ''Hysterectomy is done.'' end,
			 case when (m.dob > now() - interval ''18 years'' and m.dob < now() - interval ''45 years'') then ''Age is not between 18 to 45 year.'' end,
			 case when m.gender = ''M'' then ''Member is Male.'' end
			) as "reasonForNotEligibleCouple",
                    (select string_agg(to_char(service_date, ''dd/mm/yyyy''),'','' order by created_on desc)
                    from rch_child_service_master  where member_id  = m.id group by member_id) as "childServiceVisitDatesList",
                    m.weight as weight, m.haemoglobin,
                    get_fhw_by_location(f.location_id) as "fhwName",
                    get_asha_by_area(f.area_id) as "asha",
                    (select concat(first_name , '' '' , middle_name , '' '' , last_name) from imt_member where id = m.mother_id) as "motherName" ,
                    (select string_agg(to_char(service_date , ''dd/mm/yyyy''),'','' order by service_date  desc)
                    from rch_anc_master where member_id  = m.id group by member_id) as "ancVisitDatesList",
                    f.basic_state as "familyState",
                    get_location_hierarchy(f.location_id) as "memberLocation",
                    case when f.area_id is not null then get_location_hierarchy(f.area_id) else null end as "areaHierarchy",
                    to_char(m.created_on, ''dd/mm/yyyy'') as "createdOn" ,
                    to_char(m.modified_on , ''dd/mm/yyyy'') as "modifiedOn",
                    get_location_hierarchy(mmd.location_migrated_from) as "memberMigratedFrom",
                    get_location_hierarchy(mmd.location_migrated_to) as "memberMigratedTo",
                    concat( uu.first_name , '' '' , uu.middle_name , '' '' , uu.last_name, ''( UserName: '', uu.user_name , '', Mobile Number: '', uu.contact_number, '')'') as "memberReportedBy",
                    to_char(mmd.reported_on, ''dd/mm/yyyy'') as "memberReportedOn",
                    get_location_hierarchy(fmd.location_migrated_from) as "familyMigratedFrom",
                    get_location_hierarchy(fmd.location_migrated_to) as "familyMigratedTo",
                    concat( uu1.first_name , '' '' , uu1.middle_name , '' '' , uu1.last_name, ''( UserName: '', uu1.user_name , '', Mobile Number: '', uu1.contact_number, '')'') as "familyReportedBy",
                    to_char(fmd.reported_on, ''dd/mm/yyyy'') as "familyReportedOn"
                    from imt_member m
                    left join imt_family f on f.family_id = m.family_id
                    left join member_migration_det mmd on mmd.member_id = m.id and mmd.state = ''REPORTED''
                    left join family_migration_det fmd on fmd.family_id = f.id and fmd.state = ''REPORTED''
					left join um_user uu on uu.id = mmd.reported_by
					left join um_user uu1 on uu1.id = fmd.reported_by
                    left join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
                    left join location_master lm on lm.id = lhcd.parent_id
                    left join location_type_master loc_name on lm.type = loc_name.type
 					left join rch_member_death_deatil mdd on mdd.member_id = m.id
 					left join listvalue_field_value_detail lvd on lvd.id = CAST (mdd.death_reason AS INTEGER)
                    where unique_health_id = #healthid#
                    group by m.id,
                    uu.first_name,uu.middle_name,uu.last_name,uu.user_name,uu.contact_number,
					uu1.first_name,uu1.middle_name,uu1.last_name,uu1.user_name,uu1.contact_number,
                    f.state, m.unique_health_id,f.basic_state,f.location_id,f.area_id,mmd.location_migrated_from, mmd.location_migrated_to,
                    mmd.reported_by, mmd.reported_on, fmd.location_migrated_from, fmd.location_migrated_to, fmd.reported_by, fmd.reported_on ,mdd.dod , lvd.value
                    limit 1',
'',
true, 'ACTIVE');

-- function to get asha by area id
CREATE OR REPLACE FUNCTION public.get_asha_by_area(area_id bigint)
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE
    area_type text;
    asha text;
BEGIN
    SELECT child_loc_type
    INTO area_type
    FROM location_hierchy_closer_det
    WHERE child_id = area_id;

    IF area_type in ('AA','A') THEN
        SELECT concat(usr.first_name, ' ', usr.middle_name, ' ', usr.last_name,
		COALESCE(' ('|| usr.contact_number|| ')',''))
        INTO asha
        FROM um_user usr
        INNER JOIN um_user_location ul ON ul.user_id = usr.id AND usr.role_id = 24
        WHERE ul.loc_id = area_id;

        RETURN asha;
    ELSE
        RETURN null;
    END IF;
END;
$function$;


-- function to get fhw by village or area id
CREATE OR REPLACE FUNCTION public.get_fhw_by_location(location_id bigint)
RETURNS text
LANGUAGE plpgsql
AS $function$
DECLARE
    fhw_list text;
BEGIN
     WITH village_loc AS (
            SELECT
                CASE
                    WHEN lm."type" in ('V','ANG','ANM') THEN lm.id
                    WHEN lm."type" in ('AA','A') THEN lm.parent
                END AS village_id
            FROM location_master lm
            WHERE lm.id = location_id
        )
    SELECT string_agg(
        concat(
            usr.first_name, ' ', usr.middle_name, ' ', usr.last_name,
            COALESCE('(userName: ' || usr.user_name || ')', ''),
            COALESCE('(mobileNo: ' || usr.contact_number || ')', '')
        ), ', '
    )
    INTO fhw_list
    FROM um_user usr
    INNER JOIN um_user_location ul ON ul.user_id = usr.id AND usr.role_id = 30
    INNER JOIN village_loc vl ON ul.loc_id = vl.village_id
    WHERE ul.loc_id = vl.village_id
    AND usr.state = 'ACTIVE'
    AND ul.state = 'ACTIVE';

    RETURN fhw_list;
END;
$function$;
