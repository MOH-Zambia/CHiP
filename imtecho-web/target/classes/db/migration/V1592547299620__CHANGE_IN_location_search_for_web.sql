DELETE FROM QUERY_MASTER WHERE CODE='location_search_for_web';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ae9f821c-2703-4e75-b882-a856c3dd58f5', 75398,  current_date , 75398,  current_date , 'location_search_for_web', 
'locationString', 
'select loc.id,string_agg(l.name,''>'' order by lhcd.depth desc) as "hierarchy"
from location_master loc 
inner join location_hierchy_closer_det lhcd on lhcd.child_id = loc.id
inner join location_master l on l.id = lhcd.parent_id
where (loc.name ilike concat(''%'',#locationString#,''%'') or loc.english_name ilike concat(''%'',#locationString#,''%'')) and loc.type in (''V'',''ANG'')
group by loc.id, loc.name
limit 50', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrival_listvalue_values_acc_field';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f432547a-8222-492c-b276-206013f5db55', 75398,  current_date , 75398,  current_date , 'retrival_listvalue_values_acc_field', 
'fieldKey', 
'select * from listvalue_field_value_detail where  field_key=#fieldKey# and is_active', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'947fd387-9c47-4a2b-90c4-66c334a1a379', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_member_id', 
'offSet,limit,memberId', 
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.unique_health_id = #memberId#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c44e9d31-e082-446b-ae70-db2e10059732', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_family_id', 
'familyId,offSet,limit', 
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and imt_member.family_id = #familyId#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_family_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5996c44d-5b99-405c-8e28-19ec9a1c972b', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_family_mobile_number', 
'offSet,mobileNumber,limit,userId', 
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
and imt_member.family_id in
(select family_id from imt_member where mobile_number = #mobileNumber#)
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'38b9e9a7-47d6-4d5a-a881-da5af7891512', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_mobile_number', 
'offSet,mobileNumber,limit,userId', 
'select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.dob > now()-interval ''5 years''
and m2.mobile_number = #mobileNumber#
and ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))
and imt_family.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId#))
limit #limit# offset #offSet#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'01dc8d5c-1ef3-4060-873a-9ccea72884f1', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_name', 
'offSet,locationId,name,limit', 
'with member_details as
(select member_id from rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years'' 
and similarity(#name#,rch_child_analytics_details.member_name)>=0.50
and rch_child_analytics_details.loc_id in 
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join member_details on member_details.member_id = imt_member.id
where ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='child_service_retrieve_child_list_by_dob';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fb372992-ea27-4c1b-8a0b-f703ad272129', 75398,  current_date , 75398,  current_date , 'child_service_retrieve_child_list_by_dob', 
'offSet,dob,locationId,limit', 
'with member_details as
(select member_id from rch_child_analytics_details
where rch_child_analytics_details.dob > now()-interval ''5 years'' 
and rch_child_analytics_details.dob = #dob#
and rch_child_analytics_details.loc_id in 
(select child_id from location_hierchy_closer_det where parent_id = #locationId#)
limit #limit# offset #offSet#)
select imt_member.id,
imt_member.unique_health_id,
imt_member.family_id,
imt_member.first_name,imt_member.middle_name,imt_member.last_name,
imt_member.dob,m2.mobile_number from imt_member
left join imt_member m2 on imt_member.mother_id = m2.id
inner join member_details on member_details.member_id = imt_member.id
where ((imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'')) or (imt_member.state = ''com.argusoft.imtecho.member.state.temporary''))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='no_of_caesarean_deliveries_conducted';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'35230f5a-1313-457d-93d6-0dc7fe2f1f73', 75398,  current_date , 75398,  current_date , 'no_of_caesarean_deliveries_conducted', 
'performanceDate,hid', 
'SELECT count(*) from rch_wpd_mother_master where health_infrastructure_id=#hid# and  type_of_delivery = ''CAESAREAN'' and
date_of_delivery between cast(date_trunc(''day'', cast(#performanceDate# as date)) + ''00:00:00'' as timestamp)
	and
cast(date_trunc(''day'', cast(#performanceDate# as date)) + ''23:59:59'' as timestamp)', 
'To get number of caesarean deliveries conducted at health infrastructure on date', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='no_of_deliveries_conducted';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6472cc04-105e-4a47-9d3c-97c07def2849', 75398,  current_date , 75398,  current_date , 'no_of_deliveries_conducted', 
'performanceDate,hid', 
'SELECT count(*) from rch_wpd_mother_master where health_infrastructure_id=#hid#  and
date_of_delivery between cast(date_trunc(''day'', cast(#performanceDate# as date)) + ''00:00:00'' as timestamp)
	and
cast(date_trunc(''day'', cast(#performanceDate# as date)) + ''23:59:59'' as timestamp)', 
'To get number of deliveries conducted at health infrastructure on date.', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'64f2fa65-3610-4fa3-998c-1ac7038bcadd', 75398,  current_date , 75398,  current_date , 'fp_search_by_family_id', 
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
	where imt_member.family_id = #familyId# and imt_member.marital_status = 629 and imt_member.gender = ''F''
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


DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6513f497-2b84-4774-88f8-3a99f4fb3f08', 75398,  current_date , 75398,  current_date , 'fp_search_by_member_id', 
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
	where imt_member.unique_health_id = #uniqueHealthId# and imt_member.marital_status = 629 and imt_member.gender = ''F''
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

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b9b30470-daff-4df0-99ae-36b0bfd8fe43', 75398,  current_date , 75398,  current_date , 'fp_search_by_name', 
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
	and similarity(#firstName#,imt_member.first_name)>=0.50
	and similarity(#lastName#,imt_member.last_name)>=0.60
	and case when #middleName# != ''null'' and #middleName# !='''' then similarity(#middleName#,imt_member.middle_name)>=0.50 else 1=1 end
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



DELETE FROM QUERY_MASTER WHERE CODE='fp_search_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b1869fb7-0b81-4116-8ba3-dd84ddff371d', 75398,  current_date , 75398,  current_date , 'fp_search_by_mobile_number', 
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
	where imt_member.mobile_number = #mobileNumber# and imt_member.marital_status = 629 and imt_member.gender = ''F''
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

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd0efc905-1f84-4666-8a76-c3e4c218d28f', 75398,  current_date , 75398,  current_date , 'fp_search_by_family_mobile_number', 
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
	where imt_member.family_id in (select family_id from imt_member where mobile_number = #mobileNumber#) and imt_member.marital_status = 629 and imt_member.gender = ''F''
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


DELETE FROM QUERY_MASTER WHERE CODE='update_fp_method';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2b31c2c-e347-4644-9382-ceeb6b462ba3', 75398,  current_date , 75398,  current_date , 'update_fp_method', 
'healthInfrastructure,familyPlanningMethod,fpInsertOperateDate,loggedInUserId,memberId', 
'update imt_member
set last_method_of_contraception = #familyPlanningMethod#,
fp_insert_operate_date = cast(case when #fpInsertOperateDate# != null and #fpInsertOperateDate# != '''' then #fpInsertOperateDate# else null end as date),
family_planning_health_infra = #healthInfrastructure#,
is_iucd_removed = null,
modified_on = now(),
modified_by = #loggedInUserId#
where id = #memberId#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_iucd_removal';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a8c1c9fd-acce-4032-a3e7-f7545f05f6e5', 75398,  current_date , 75398,  current_date , 'update_iucd_removal', 
'iucdRemovalReason,iucdRemovalDate,loggedInUserId,memberId', 
'update imt_member
set is_iucd_removed = true,
last_method_of_contraception = null,
fp_insert_operate_date = null,
iucd_removal_date = cast(#iucdRemovalDate# as date),
iucd_removal_reason = #iucdRemovalReason#,
modified_on = now(),
modified_by = #loggedInUserId#
where id = #memberId#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_registered_patients';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a89d0cdb-e3b8-4186-842b-887cf464c9d2', 75398,  current_date , 75398,  current_date , 'retrieve_opd_registered_patients', 
'fetchPendingOnly,searchDate,userId', 
'select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    romr.id as "opdMemberRegistrationId",
    romr.registration_date as "registrationDate",
    romr.health_infra_id as "healthInfraId",
    hid.name as "healthInfraName"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romr.health_infra_id
    left join rch_opd_member_master romm on romr.id = romm.opd_member_registration_id
    where cast(romr.registration_date as date) = cast(#searchDate# as date)
    and (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romr.registration_date', 
'Retrieve OPD Registered Patients', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_patients_for_treatment';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'05d4e978-67a8-46c3-8b57-5cf4b4cbe2c3', 75398,  current_date , 75398,  current_date , 'retrieve_opd_patients_for_treatment', 
'fetchPendingOnly,searchDate,userId', 
'select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    romr.id as "opdMemberRegistrationId",
    romr.registration_date as "registrationDate",
    romr.health_infra_id as "healthInfraId",
    hid.name as "healthInfraName"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romr.health_infra_id
    left join rch_opd_member_master romm on romr.id = romm.opd_member_registration_id
    where
        (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    -- and cast(romr.registration_date as date) = cast(#searchDate# as date)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romr.registration_date desc', 
'Retrieve OPD Patients for Treatment', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e597e279-6c53-4e2e-a34e-71d4b97131ad', 75398,  current_date , 75398,  current_date , 'opd_search_by_member_id', 
'offSet,limit,uniqueHealthId', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.area_id as "areaId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.unique_health_id in (#uniqueHealthId#)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By Member ID', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'62a317fb-f9dd-4241-a9c7-83732b61934a', 75398,  current_date , 75398,  current_date , 'opd_search_by_mobile_number', 
'offSet,mobileNumber,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.mobile_number = #mobileNumber#
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By Mobile Number', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ad64a058-7dad-41e4-a7d3-6b9a03575e4c', 75398,  current_date , 75398,  current_date , 'opd_search_by_family_id', 
'familyId,offSet,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.family_id in (#familyId#)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By Family ID', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_dob';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'45394147-30e4-44ee-9ede-5d8d4c25438a', 75398,  current_date , 75398,  current_date , 'opd_search_by_dob', 
'offSet,dob,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.dob = cast(#dob# as date)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By DOB', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_pmjay_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1578f8de-b5c5-4f16-bc4d-9e129fab58d9', 75398,  current_date , 75398,  current_date , 'opd_search_by_pmjay_number', 
'pmjayNumber,offSet,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_member_cfhc_master on imt_member.id = imt_member_cfhc_master.member_id
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member_cfhc_master.pmjay_number = #pmjayNumber#
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By PMJAY Number', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_ration_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3818d84c-b196-4e34-8c2a-b875ffc46095', 75398,  current_date , 75398,  current_date , 'opd_search_by_ration_number', 
'rationNumber,offSet,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.ration_card_number = #rationNumber#
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By Ration Number', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_by_maa_vatsalya_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b3ca91a3-9d56-4473-ab70-9cd017e24a8e', 75398,  current_date , 75398,  current_date , 'opd_search_by_maa_vatsalya_number', 
'maavatsalyaNumber,offSet,limit', 
'select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.maa_vatsalya_number = #maavatsalyaNumber#
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#', 
'OPD Search By MAA Vatsalya Number', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='register_opd_patient';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8bfe0bfa-48fa-4f16-9f13-12e94b90569a', 75398,  current_date , 75398,  current_date , 'register_opd_patient', 
'healthInfrastructureId,registrationDate,referenceType,loggedInUserId,referenceId,memberId', 
'with get_location_id as (
        select
        case
            when if.area_id is not null then if.area_id
            else if.location_id
        end as location_id
        from imt_family if
        inner join imt_member im on im.family_id = if.family_id
        where im.id = #memberId#
    )
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, health_infra_id, created_by, created_on, modified_by, modified_on, reference_id, reference_type, location_id)
    VALUES
    (#memberId#, #registrationDate#, #healthInfrastructureId#, #loggedInUserId#, now(), #loggedInUserId#, now(), #referenceId#, #referenceType#,
        (select location_id from get_location_id)
    );', 
'Register OPD Patient', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_lab_tests_and_category_by_health_infrastructure';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a46fe381-bf3f-4b00-ac93-f705a3b8ab10', 75398,  current_date , 75398,  current_date , 'retrieve_opd_lab_tests_and_category_by_health_infrastructure', 
'healthInfrastructureId,healthInfrastructureType,type', 
'with lab_test_table as( select
	rch_opd_lab_test_master.id as "labTestId", rch_opd_lab_test_master.name as "labTestName", rch_opd_lab_test_master.category
from
	health_infrastructure_lab_test_mapping
inner join rch_opd_lab_test_master on
	health_infrastructure_lab_test_mapping.ref_id = rch_opd_lab_test_master.id
where
	case
		when ( select
			count(*)
		from
			health_infrastructure_lab_test_mapping
		where
			health_infra_id = #healthInfrastructureId# )>0 then health_infra_id = #healthInfrastructureId#
		else health_infra_type = #healthInfrastructureType#
	end
	and permission_type = #type#
	and rch_opd_lab_test_master.is_active = true) select
	lab_test_table."labTestId",
	lab_test_table."labTestName",
	cat.id as "categoryId",
	cat.value as "categoryName"
from
	lab_test_table
inner join listvalue_field_value_detail cat on
	lab_test_table.category = cat.id', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_member_treatment_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e06598a5-6888-4dd8-a8a7-3e683b7c8e34', 75398,  current_date , 75398,  current_date , 'opd_member_treatment_history', 
'offset,limit,uniqueHealthId', 
'select
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn",
    hid."name" as "healthInfraName",
    (
    	select
    	string_agg(
    		roltm.name, '', ''
		)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    where roltd.opd_member_master_id = romm.id
    ) as "labTests",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''name'', roltm.name,
		    	''category'', (select value from listvalue_field_value_detail where id = roltm.category),
		    	''result'', roltd.result,
		    	''requestedOn'', roltd.request_on,
		    	''formConfigJson'', sfc.form_config_json
			)
		) as text)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
        left join rch_opd_lab_test_master lab_test_master on lab_test_master.id = roltd.lab_test_id
        left join system_form_configuration sfc on sfc.form_id = lab_test_master.form_id and sfc."version" = roltd.result_version
	    where roltd.opd_member_master_id = romm.id
    ) as "labTestResults",
    (
    	select
    	string_agg(
    		lfvd.value, '', ''
		)
	    from listvalue_field_value_detail lfvd
	    inner join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
	    where lfvd.id = roltpr.provisional_id
    ) as "provisionalDiagnosis",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''id'', roed.id,
		    	''memberId'', roed.member_id,
		    	''opdMemberMasterId'', roed.opd_member_master_id,
		    	''edlName'', (select value from listvalue_field_value_detail where id = roed.edl_id),
	    		''frequency'', cast(roed.frequency as text),
	    		''quantityBeforeFood'', cast(roed.quantity_before_food as text),
	    		''quantityAfterFood'', cast(roed.quantity_after_food as text),
	    		''numberOfDays'', cast(roed.number_of_days as text)
			)
		) as text)
	    from rch_opd_edl_details roed
	    where roed.opd_member_master_id = romm.id
    ) as "opdEdlDetails",
    concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "treatmentDoneBy"
    from rch_opd_member_master romm
    inner join imt_member im on romm.member_id = im.id
    inner join um_user uu on romm.created_by = uu.id
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where im.unique_health_id in (#uniqueHealthId#)
    -- and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    order by romm.service_date desc
    limit #limit# offset #offset#', 
'OPD Member Treatment History', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='fetch_listvalue_detail_from_field_on_debounce';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5265a0e4-9d4f-4fd8-aa0e-a40bab830c19', 75398,  current_date , 75398,  current_date , 'fetch_listvalue_detail_from_field_on_debounce', 
'searchString,field', 
'select
    *
    from listvalue_field_value_detail lvfvd
    where lvfvd.field_key = (select field_key from listvalue_field_master where field =#field#)
    and lvfvd."value" ilike concat(''%'',#searchString#,''%'')
    and is_active = true
    limit 10;', 
'Fetch List Value Details by Field on Debounce', 
true, 'ACTIVE');