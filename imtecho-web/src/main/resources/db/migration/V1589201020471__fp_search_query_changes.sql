DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_member_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_member_id',
'offSet,limit,uniqueHealthId',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.unique_health_id = ''#uniqueHealthId#'' and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_family_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_family_id',
'familyId,offSet,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.family_id = ''#familyId#'' and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_mobile_number';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_mobile_number',
'offSet,mobileNumber,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.mobile_number = ''#mobileNumber#'' and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_family_mobile_number';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_family_mobile_number',
'offSet,mobileNumber,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_member.family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'') and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_location_id',
'offSet,locationId,limit',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_name';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'fp_search_by_name',
'firstName,lastName,offSet,locationId,limit,middleName',
'with member_detail as (
	select imt_member.is_pregnant, imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	cast(age(imt_member.dob) as text) as "memberAge",
	case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,''years'') else null end as "memberWedding",
	case when imt_member.last_method_of_contraception = ''FMLSTR'' then ''FEMALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''MLSTR'' then ''MALE STERILIZATION''
	     when imt_member.last_method_of_contraception = ''IUCD5'' then ''IUCD- 5 YEARS''
	     when imt_member.last_method_of_contraception = ''IUCD10'' then ''IUCD- 10 YEARS''
	     when imt_member.last_method_of_contraception = ''CONDOM'' then ''CONDOM''
	     when imt_member.last_method_of_contraception = ''ORALPILLS'' then ''ORAL PILLS''
	     when imt_member.last_method_of_contraception = ''CHHAYA'' then ''CHHAYA''
	     when imt_member.last_method_of_contraception = ''ANTARA'' then ''ANTARA''
	     when imt_member.last_method_of_contraception = ''CONTRA'' then ''EMERGENCY CONTRACEPTIVE PILLS''
	     when imt_member.last_method_of_contraception = ''PPIUCD'' then ''PPIUCD''
	     when imt_member.last_method_of_contraception = ''PAIUCD'' then ''PAIUCD''
	     when imt_member.last_method_of_contraception = ''PPTL'' then ''Post Parterm TL''
	     when imt_member.last_method_of_contraception = ''PATL'' then ''Post Abortion TL''
	     else null end as "memberCurrentFp",
	imt_member.last_method_of_contraception as "memberCurrentFpValue", imt_member.fp_insert_operate_date as "memberFpOperateDate",
	imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
	get_location_hierarchy(imt_family.location_id) as "location",
	imt_family.location_id as "locationId",
	imt_family.area_id as "areaId"
	from imt_member
	inner join imt_family on imt_member.family_id = imt_family.family_id
	where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
	and similarity(''#firstName#'',imt_member.first_name)>=0.50
	and similarity(''#lastName#'',imt_member.last_name)>=0.60
	and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='''' then similarity(''#middleName#'',imt_member.middle_name)>=0.50 else 1=1 end
	and imt_member.marital_status = 629 and imt_member.gender = ''F''
	    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
	    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false)
	    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false)
	    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false)
	    and (imt_member.last_method_of_contraception is null
	    		or (imt_member.last_method_of_contraception != ''FMLSTR'' and imt_member.last_method_of_contraception != ''MLSTR'')
	    		or (imt_member.fp_insert_operate_date is null)
	    		or (extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3)
	    	)
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
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
	asha.contact_number as "ashaNumber"
	from member_detail
	inner join um_user_location asha_location on member_detail."areaId" = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE''
)select member_detail.*,
child_details."liveChildren",
child_details."liveChildrenBoys",
child_details."liveChildrenGirls",
child_details."lastChildAge",
fhw_details."fhwName",
fhw_details."fhwNumber",
asha_details."ashaName",
asha_details."ashaNumber"
from member_detail
left join child_details on member_detail."memberId" = child_details."memberId"
left join fhw_details on member_detail."memberId" = fhw_details."memberId"
left join asha_details on member_detail."memberId" = asha_details."memberId"',
null,
true, 'ACTIVE');