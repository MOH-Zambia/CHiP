DELETE FROM QUERY_MASTER WHERE CODE='get_screening_center_by_admission_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'95c6b541-0983-4ddc-8fd4-d90680a26cc7', -1,  current_date , -1,  current_date , 'get_screening_center_by_admission_id',
'admissionId',
'select screening_center as "screeningCenter" from child_cmtc_nrc_screening_detail
where admission_id = #admissionId#;',
'this will return  screening center id from child_cmtc_nrc_screening_detail based on admission_id',
true, 'ACTIVE');