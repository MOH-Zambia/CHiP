DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'47ef4d50-2897-4144-8216-15a238154861', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_member_id',
'memberId',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and imt_member.unique_health_id = #memberId#
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_family_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ca1ab66c-e15a-4316-8095-f265e649433d', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_family_id',
'familyId,offSet,limit',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and imt_member.family_id = #familyId#
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_location_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'49842fbe-7574-4e89-95c7-a0085ce5f036', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_location_id',
'offSet,locationId,limit',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and rch_pregnancy_registration_det.current_location_id in (
	select child_id from location_hierchy_closer_det where parent_id = #locationId#
)
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
order by rch_pregnancy_registration_det.delivery_date desc
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_family_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fdf94c16-cd74-484e-b8cb-8256919c6055', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_family_mobile_number',
'offSet,mobileNumber,limit',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and imt_member.family_id in (
	select family_id
	from imt_member where mobile_number = #mobileNumber#
)
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
order by rch_pregnancy_registration_det.delivery_date desc
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'dbdb23e3-356d-455e-9922-de4b32363c8c', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_mobile_number',
'offSet,mobileNumber,limit',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and imt_member.mobile_number = #mobileNumber#
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
order by rch_pregnancy_registration_det.delivery_date desc
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='pnc_retrieve_mother_list_by_name';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'a182a2aa-c705-4c5a-9224-b2df50219ae0', 60512,  current_date , 60512,  current_date , 'pnc_retrieve_mother_list_by_name',
'offSet,locationId,name,limit',
'select imt_member.*
from rch_pregnancy_registration_det
inner join imt_member on rch_pregnancy_registration_det.member_id = imt_member.id
where rch_pregnancy_registration_det.delivery_date > now() - interval ''60 days''
and rch_pregnancy_registration_det.state = ''DELIVERY_DONE''
and rch_pregnancy_registration_det.current_location_id in (
	select child_id from location_hierchy_closer_det where parent_id = #locationId#
)
and concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name) ilike #name#
and imt_member.basic_state in (''NEW'',''VERIFIED'',''REVERIFICATION'',''TEMPORARY'')
order by rch_pregnancy_registration_det.delivery_date desc
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');