update system_configuration set key_value = '25' where system_key = 'MOBILE_FORM_VERSION';


DELETE FROM QUERY_MASTER WHERE CODE='mob_ncd_cbac_details_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'35ffa425-7273-4130-8e27-c5f2df8f7415', 97072,  current_date , 97072,  current_date , 'mob_ncd_cbac_details_by_member_id',
'memberId',
'with max_record as (
	select max(id) as ncd_id from ncd_member_cbac_detail where member_id = #memberId#
)select imt_member.unique_health_id as "uniqueHealthId",
cast(imt_member.id as text) as "memberId",
imt_member.family_id as "familyId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.dob,
cast(age(imt_member.dob) as text) as "age",
imt_member.gender as "gender",
concat(imt_family.address1,'' '',imt_family.address2) as "address",
imt_family.type_of_house as "typeOfHouse",
imt_family.type_of_toilet as "typeOfToilet",
imt_family.electricity_availability as "electricityAvailability",
imt_family.drinking_water_source as "drinkingWaterSource",
imt_family.fuel_for_cooking as "fuelForCooking",
imt_family.house_ownership_status as "houseOwnershipStatus",
imt_family.annual_income as "annualIncome",
cast(imt_family.id as text) as "fid",
imt_member.mobile_number as "mobileNumber",
ncd_member_cbac_detail.* from ncd_member_cbac_detail
inner join imt_member on ncd_member_cbac_detail.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
where ncd_member_cbac_detail.id in (select ncd_id from max_record)',
'CBAC Online Viewing Data Query',
true, 'ACTIVE');