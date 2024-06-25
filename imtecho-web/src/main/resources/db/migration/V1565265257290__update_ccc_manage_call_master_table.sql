ALTER TABLE ccc_manage_call_master
ALTER COLUMN mobile_number TYPE text;


with mobile_json as (
	select cc.user_id,
	concat('[',(select row_to_json(_) from ( select uu.contact_number as "mobileNumber", uu.id as "userId", concat_ws(' ',uu.first_name,uu.middle_name,uu.last_name) as name,
	true as "isCalled") as _ ),']') as mobile_number
	from ccc_manage_call_master cc
	inner join um_user uu on cc.user_id = uu.id
	and uu.contact_number = cc.mobile_number
)
update ccc_manage_call_master set mobile_number = mobile_json.mobile_number
from mobile_json
where ccc_manage_call_master.user_id = mobile_json.user_id and ccc_manage_call_master.call_response = 'com.argusoft.imtecho.ccc.call.success';

with mobile_json as (
	select cc.user_id,
	concat('[',(select row_to_json(_) from ( select uu.contact_number as "mobileNumber", uu.id as "userId", concat_ws(' ',uu.first_name,uu.middle_name,uu.last_name) as name,
	false as "isCalled") as _ ),']') as mobile_number
	from ccc_manage_call_master cc
	inner join um_user uu on cc.user_id = uu.id
	and uu.contact_number = cc.mobile_number
)
update ccc_manage_call_master set mobile_number = mobile_json.mobile_number
from mobile_json
where ccc_manage_call_master.user_id = mobile_json.user_id and ccc_manage_call_master.call_response != 'com.argusoft.imtecho.ccc.call.success';
