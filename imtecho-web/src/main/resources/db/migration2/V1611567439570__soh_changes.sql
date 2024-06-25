update internationalization_label_master set text = 'Please enter the code that was provided to you for logging in. In case you do not have the code, please use the register form by clicking here. If you have already registered, please wait for 24 hours or contact <a href="mailto:techo@gujarat.gov.in" >techo@gujarat.gov.in</a>' where key = 'LoginCode';

insert into internationalization_label_master(country,key,language,created_by,created_on,text,app_name)
values
('IN','Indicators','EN',-1, current_date,'Indicators','SOH'),
('IN','SOH_State','EN',-1, current_date,'State','SOH'),
('IN','SOH_Rank','EN',-1, current_date,'Rank','SOH');

update system_configuration set key_value = (cast(key_value as integer) + 1) where system_key = 'SOH_LOCALE_VERSION';

DELETE FROM QUERY_MASTER WHERE CODE='get_soh_root_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'559934e6-0480-47a8-b0c3-10334eaf9fea', 84954,  current_date , 84954,  current_date , 'get_soh_root_location',
 null,
'select
	id,
	"name"
from
	location_master
where
	parent is null
	and state = ''ACTIVE''
order by
	id
limit 1',
null,
true, 'ACTIVE');
