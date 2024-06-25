delete from query_master where code='retrieve_anc_member_details';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_anc_member_details','id','
with loc_area_ids as (
	select location_id,area_id
	from imt_family,imt_member
	where imt_member.family_id = imt_family.family_id
	and imt_member.id = #id#
),fhw_details as (
	select loc_area_ids.location_id,concat(u.first_name,'' '',u.last_name,'' ('',contact_number,'')'') as anmInfo
	from um_user u, um_user_location ul,loc_area_ids
	where u.id = ul.user_id and ul.state = ''ACTIVE'' and u.state = ''ACTIVE'' and ul.loc_id = loc_area_ids.location_id
),asha_details as (
	select loc_area_ids.area_id, concat(u.first_name,'' '',u.last_name,'' ('',contact_number,'')'') as ashaInfo
	from um_user u, um_user_location ul,loc_area_ids
	where u.id = ul.user_id and ul.state = ''ACTIVE'' and u.state = ''ACTIVE'' and ul.loc_id = loc_area_ids.area_id
), gravida as (
	select #id# as mother_id, count(*) as gravida from (
		select mother_id
		from imt_member where mother_id = #id#
		group by mother_id, dob
	) as t
)
select
aadhar_number_encrypted as "aadharNumber",
unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
account_number as "accountNumber",
ifsc as "ifsc",
additional_info as "additionalInfo",
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
gravida.gravida as "gravida"
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
left join fhw_details on imt_family.location_id = fhw_details.location_id
left join asha_details on imt_family.area_id = asha_details.area_id
left join gravida on imt_member.id = gravida.mother_id
where imt_member.id = #id#
',true,'ACTIVE');