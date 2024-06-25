update menu_config set menu_name = 'Family Planing Service Visit' where menu_config.menu_name = 'Manage Family Planning';

update menu_config set group_id = (select id from menu_group where group_name = 'Facility Data Entry') where menu_name  = 'Family Planing Service Visit';

--Create column of iucd_removal_reason in imt_member
ALTER TABLE imt_member
DROP COLUMN IF EXISTS iucd_removal_reason;


ALTER TABLE imt_member
ADD COLUMN iucd_removal_reason  character varying(255);

--Update removal
update query_master set query = 'update imt_member
set is_iucd_removed = true,
iucd_removal_date = cast(''#iucdRemovalDate#'' as date),
iucd_removal_reason = ''#iucdRemovalReason#''
where id = #memberId#
' 
where code = 'update_iucd_removal';


--Update Live Children Boys/Girls Count

--fp_search_by_member_id 
update query_master set query = 'select imt_member.is_pregnant, imt_member.id as "memberId", 
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
count(m2.id) as "liveChildren",
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls", 
cast(age(max(m2.dob)) as text) as "lastChildAge", 
concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName", 
fhw.contact_number as "fhwNumber", 
concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName", 
asha.contact_number as "ashaNumber" from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where imt_member.unique_health_id = ''#uniqueHealthId#'' and imt_member.marital_status = 629 and imt_member.gender = ''F'' 
    and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45 
    and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
    and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
    and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
    and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR''
    and imt_member.last_method_of_contraception != ''MLSTR'') end 
    and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end 
    and fhw.state = ''ACTIVE'' 
    group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, imt_member.last_name,
    imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, imt_member.fp_insert_operate_date,
    imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,fhw.middle_name,fhw.last_name, 
    fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number 
limit #limit# offset #offSet#;' 

where code = 'fp_search_by_member_id';


--fp_search_by_family_id
update query_master set query = 'select imt_member.id as "memberId", imt_member.unique_health_id as "uniqueHealthId", 
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName", 
cast(age(imt_member.dob) as text) as "memberAge", 
case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,'' years'') else null end as "memberWedding",
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
imt_member.last_method_of_contraception as "memberCurrentFpValue", 
imt_member.fp_insert_operate_date as "memberFpOperateDate", 
imt_member.lmp as "lmpDate", imt_member.last_delivery_date as "lastDeliveryDate",
get_location_hierarchy(imt_family.location_id) as "location", 
count(m2.id) as "liveChildren", 
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls", 
cast(age(max(m2.dob)) as text) as "lastChildAge", concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName",
fhw.contact_number as "fhwNumber", 
concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName",
 asha.contact_number as "ashaNumber" from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where imt_member.family_id = ''#familyId#'' and imt_member.marital_status = 629 and imt_member.gender = ''F'' 
and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
 and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR'' 
and imt_member.last_method_of_contraception != ''MLSTR'') end 
and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end 
and fhw.state = ''ACTIVE'' 
group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, 
imt_member.last_name,imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, 
imt_member.fp_insert_operate_date,imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,
fhw.middle_name,fhw.last_name, fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number
limit #limit# offset #offSet#;

    
' 

where code = 'fp_search_by_family_id';


--fp_search_by_mobile_number
update query_master set query = '
with member_ids as (
 select imt_member.id from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.mobile_number = ''#mobileNumber#'' and imt_member.marital_status = 629 and imt_member.gender = ''F'' 
and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45
 and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR'' 
and imt_member.last_method_of_contraception != ''MLSTR'') end 
and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end 
limit #limit# offset #offSet# ) 
select imt_member.id as "memberId", imt_member.unique_health_id as "uniqueHealthId", 
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName", 
cast(age(imt_member.dob) as text) as "memberAge", 
case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,'' years'') else null end as "memberWedding", 
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
count(m2.id) as "liveChildren",
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",  
cast(age(max(m2.dob)) as text) as "lastChildAge", 
concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName", 
fhw.contact_number as "fhwNumber", concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName", 
asha.contact_number as "ashaNumber" from member_ids 
inner join imt_member on member_ids.id = imt_member.id 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where fhw.state = ''ACTIVE'' 
group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, 
imt_member.last_name,imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, 
imt_member.fp_insert_operate_date,imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,
fhw.middle_name,fhw.last_name, fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number

' 

where code = 'fp_search_by_mobile_number';



--fp_search_by_family_mobile_number
update query_master set query = 'with member_ids as ( 
select imt_member.id from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_member.family_id in (select family_id from imt_member where mobile_number = ''#mobileNumber#'') 
and imt_member.marital_status = 629 and imt_member.gender = ''F'' 
and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45 
and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR'' 
and imt_member.last_method_of_contraception != ''MLSTR'') end 
and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end 
limit #limit# offset #offSet# ) 
select imt_member.id as "memberId", imt_member.unique_health_id as "uniqueHealthId", 
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName", 
cast(age(imt_member.dob) as text) as "memberAge", 
case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,'' years'') else null end as "memberWedding", 
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
imt_member.last_method_of_contraception as "memberCurrentFpValue", 
imt_member.fp_insert_operate_date as "memberFpOperateDate", imt_member.lmp as "lmpDate", 
imt_member.last_delivery_date as "lastDeliveryDate", get_location_hierarchy(imt_family.location_id) as "location", 
count(m2.id) as "liveChildren", 
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls", 
cast(age(max(m2.dob)) as text) as "lastChildAge", 
concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName", 
fhw.contact_number as "fhwNumber", concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName", 
asha.contact_number as "ashaNumber" from member_ids 
inner join imt_member on member_ids.id = imt_member.id 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where fhw.state = ''ACTIVE'' 
group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, imt_member.last_name,
imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, imt_member.fp_insert_operate_date,
imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,fhw.middle_name,fhw.last_name, 
fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number


' 

where code = 'fp_search_by_family_mobile_number';


--fp_search_by_location_id
update query_master set query = '
with member_ids as ( 
select imt_member.id 
from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) 
and imt_member.marital_status = 629 and imt_member.gender = ''F'' 
and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45 
and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR'' 
and imt_member.last_method_of_contraception != ''MLSTR'') end 
and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end 
limit #limit# offset #offSet# ) 
select imt_member.id as "memberId", imt_member.unique_health_id as "uniqueHealthId", 
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName", 
cast(age(imt_member.dob) as text) as "memberAge", 
case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,'' years'') else null end as "memberWedding", 
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
count(m2.id) as "liveChildren",
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",  
cast(age(max(m2.dob)) as text) as "lastChildAge", concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName", 
fhw.contact_number as "fhwNumber", concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName", 
asha.contact_number as "ashaNumber" from member_ids 
inner join imt_member on member_ids.id = imt_member.id 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where fhw.state = ''ACTIVE'' 
group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, imt_member.last_name,
imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, imt_member.fp_insert_operate_date,
imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,fhw.middle_name,fhw.last_name, 
fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number

' 

where code = 'fp_search_by_location_id';




--fp_search_by_name

update query_master set query = 'with member_ids as ( 
select imt_member.id from imt_member 
inner join imt_family on imt_member.family_id = imt_family.family_id 
where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) 
and similarity(''#firstName#'',imt_member.first_name)>=0.50 
and similarity(''#lastName#'',imt_member.last_name)>=0.60 
and case when ''#middleName#'' != ''null'' and ''#middleName#'' !='' then similarity(''#middleName#'',imt_member.middle_name)>=0.50 else 1=1 end 
and imt_member.marital_status = 629 
and imt_member.gender = ''F'' 
and date_part(''years'',current_date) - date_part(''years'',imt_member.dob) between 18 and 45 
and (imt_member.is_pregnant is null or imt_member.is_pregnant = false) 
and (imt_member.menopause_arrived is null or imt_member.menopause_arrived = false) 
and (imt_member.hysterectomy_done is null or imt_member.hysterectomy_done = false) 
and case when imt_member.last_method_of_contraception is null then 1=1 else (imt_member.last_method_of_contraception != ''FMLSTR'' 
and imt_member.last_method_of_contraception != ''MLSTR'') end 
and case when imt_member.fp_insert_operate_date is null then 1=1 else extract(year from age(current_date, imt_member.fp_insert_operate_date)) * 12 + extract(month from age(current_date, imt_member.fp_insert_operate_date)) <=3 end
 limit #limit# offset #offSet# ) 
select imt_member.id as "memberId", imt_member.unique_health_id as "uniqueHealthId", 
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName", 
cast(age(imt_member.dob) as text) as "memberAge", 
case when imt_member.year_of_wedding is not null then concat(date_part(''year'',current_date) - imt_member.year_of_wedding,'' years'') else null end as "memberWedding", 
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
count(m2.id) as "liveChildren",
SUM(case when m2.gender = ''M'' then 1 else 0 end) as "liveChildrenBoys",
SUM(case when m2.gender = ''F'' then 1 else 0 end) as "liveChildrenGirls",  
cast(age(max(m2.dob)) as text) as "lastChildAge", 
concat(fhw.first_name,'' '',fhw.middle_name,'' '',fhw.last_name) as "fhwName", fhw.contact_number as "fhwNumber", 
concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as "ashaName", asha.contact_number as "ashaNumber" 
from member_ids 
inner join imt_member on member_ids.id = imt_member.id 
inner join imt_family on imt_member.family_id = imt_family.family_id 
left join imt_member m2 on m2.mother_id = imt_member.id 
left join um_user_location fhw_location on imt_family.location_id = fhw_location.loc_id and fhw_location.state = ''ACTIVE'' 
left join um_user fhw on fhw_location.user_id = fhw.id and fhw.role_id = 30 and fhw.state = ''ACTIVE'' 
left join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE'' 
left join um_user asha on asha_location.user_id = asha.id and asha.role_id = 24 and asha.state = ''ACTIVE'' 
where fhw.state = ''ACTIVE'' 
group by imt_member.id,imt_member.unique_health_id,imt_member.first_name,imt_member.middle_name, imt_member.last_name,
imt_member.dob,imt_member.year_of_wedding,imt_member.last_method_of_contraception, imt_member.fp_insert_operate_date,
imt_member.lmp,imt_member.last_delivery_date,imt_family.location_id,fhw.first_name,fhw.middle_name,fhw.last_name, 
fhw.contact_number,asha.first_name,asha.middle_name,asha.last_name,asha.contact_number
' 

where code = 'fp_search_by_name';

