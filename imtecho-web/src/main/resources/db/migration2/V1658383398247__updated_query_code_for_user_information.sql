DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_information_of_user';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b5228870-2951-4c98-9d62-0bad36a3f1d2', 97070,  current_date , 97070,  current_date , 'retrieve_all_information_of_user',
'username',
'select
um.contact_number as mobilenumber,
um.email_id as emailid, CONCAT(um.first_name, '' '', um.middle_name, '' '',um.last_name) as fullname,
um.gender, to_char(um.date_of_birth, ''dd/mm/yyyy'') as dateofbirth, um.user_name as username, um.state, um.title, um.techo_phone_number as techophonenumber,
loc.level as locationlevel, loc.state as areaofinterventionstate,
rol.name as rolename, rol.state as rolestate,
string_agg(lm.name,''> '' order by lhcd.depth desc) as locationname, locname.state as locationstate
from um_user um
left join um_user_location loc on loc.user_id = um.id and loc.state = ''ACTIVE''
left join location_hierchy_closer_det lhcd on loc.loc_id = lhcd.child_id
left join location_master lm on lm.id = lhcd.parent_id
left join um_role_master rol on um.role_id = rol.id
left join location_master locname on loc.loc_id = locname.id and locName.state = ''ACTIVE''
where um.user_name = #username#
group by um.aadhar_number, um.contact_number, um.email_id, um.first_name, um.middle_name, um.last_name,
um.gender, um.date_of_birth, um.user_name, um.state, um.title, um.techo_phone_number,
loc.level, loc.state,rol.name, rol.state, locname.state , lhcd.child_id limit 1',
'Retrieve User Information using userName',
true, 'ACTIVE');