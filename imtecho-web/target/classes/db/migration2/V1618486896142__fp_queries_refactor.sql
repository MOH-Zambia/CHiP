--5012

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6513f497-2b84-4774-88f8-3a99f4fb3f08', 60512,  current_date , 60512,  current_date , 'fp_search_by_member_id',
'offSet,limit,uniqueHealthId',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.unique_health_id = #uniqueHealthId# and imt_member.marital_status = 629 and imt_member.gender = ''F''
		and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'64f2fa65-3610-4fa3-998c-1ac7038bcadd', 60512,  current_date , 60512,  current_date , 'fp_search_by_family_id',
'familyId,offSet,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.family_id = #familyId# and imt_member.marital_status = 629 and imt_member.gender = ''F''
		and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_location_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a3fbe299-83ed-4522-a6c6-5b8a4e5f6677', 60512,  current_date , 60512,  current_date , 'fp_search_by_location_id',
'offSet,locationId,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end in
		(select child_id from location_hierchy_closer_det where parent_id = #locationId#) and imt_member.marital_status = 629 and imt_member.gender = ''F''
		and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_family_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd0efc905-1f84-4666-8a76-c3e4c218d28f', 60512,  current_date , 60512,  current_date , 'fp_search_by_family_mobile_number',
'offSet,mobileNumber,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.family_id in (select family_id from imt_member where mobile_number = #mobileNumber#) and imt_member.marital_status = 629 and imt_member.gender = ''F''
		and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b1869fb7-0b81-4116-8ba3-dd84ddff371d', 60512,  current_date , 60512,  current_date , 'fp_search_by_mobile_number',
'offSet,mobileNumber,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.mobile_number = #mobileNumber# and imt_member.marital_status = 629 and imt_member.gender = ''F''
		and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b9b30470-daff-4df0-99ae-36b0bfd8fe43', 60512,  current_date , 60512,  current_date , 'fp_search_by_name',
'firstName,lastName,offSet,locationId,limit,middleName',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	imt_member.last_method_of_contraception as "memberCurrentFp",
	imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
	and similarity(#firstName#,imt_member.first_name)>=0.50
	and similarity(#lastName#,imt_member.last_name)>=0.60
	and case when #middleName# != ''null'' and #middleName# !='''' then similarity(#middleName#,imt_member.middle_name)>=0.50 else 1=1 end
	and imt_member.marital_status = 629 and imt_member.gender = ''F''
	and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
	order by imt_member.id
	limit #limit# offset #offSet#
),child_details as (
	select member_detail."memberId",
	count(child.id) as "liveChildren",
	SUM(case when child.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
	SUM(case when child.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",
	cast(age(max(child.dob)) as text) as "lastChildAge"
	from member_detail
	left join imt_member child on member_detail."memberId" = child.mother_id
	group by member_detail."memberId"
),fhw_details as (
	select member_detail."memberId",
	concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
	fhw.contact_number as "fhwNumber"
	from member_detail
	inner join um_user_location fhw_location on member_detail."locationId" = fhw_location.loc_id and fhw_location.state = ''ACTIVE''
	inner join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE''
),asha_details as (
	select member_detail."memberId",
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'', '') as asha_details
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
	group by member_detail."memberId"
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details.asha_details as "ashaDetails"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');