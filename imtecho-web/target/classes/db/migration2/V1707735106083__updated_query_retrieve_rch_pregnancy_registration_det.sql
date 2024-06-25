DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_pregnancy_registration_det';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'058013df-5435-4244-83e5-708a7569c0b8', 97068,  current_date , 97068,  current_date , 'retrieve_rch_pregnancy_registration_det',
'healthid',
'select
CURRENT_DATE as curdate,
preg.id as "pregId",preg.mthr_reg_no as "motherRegNo",preg.member_id,preg.lmp_date as "lmpDate",preg.edd as "expectedDeliveryDate",
preg.reg_date as "registrationDate",preg.state,preg.created_on as "createdOn",preg.created_by as "createdBy",preg.modified_on as "modifiedOn",
preg.modified_by as "modifiedBy",preg.location_id as "locationId",preg.family_id as "pregFamilyId",preg.current_location_id as "currLocationId",
usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,usr.user_name as username,fam.family_id as "familyId",
loc.name as locationname, curloc.name as currentlocationname
from rch_pregnancy_registration_det preg
left join um_user usr on preg.created_by = usr.id
left join imt_family fam on preg.family_id = fam.id
left join location_master loc on preg.location_id = loc.id
left join location_master curloc on preg.current_location_id = curloc.id
where preg.member_id = (select id from imt_member where unique_health_id = #healthid# limit 1) order by preg.created_on desc limit 5',
'Retrieve Pregnancy Registration Details',
true, 'ACTIVE');