delete from QUERY_MASTER where CODE='retrieve_followups_by_admission_id';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'8eccb47b-841f-408c-867b-f58a1f95a124', 69851,  current_date , 69851,  current_date , 'retrieve_followups_by_admission_id',
'admissionId',
'select * from child_cmtc_nrc_follow_up where admission_id = #admissionId#',
null,
true, 'ACTIVE');