UPDATE listvalue_field_value_detail
SET is_active = false
WHERE
    value IN ('Balsakha-1', 'Chiranjivi Yojana', 'Balsakha-3', 'MA Yojana', 'PMJAY Facility','HWC','IDSP','NPCB Referral Center')
    AND field_key = 'health_infra_facilities';


update listvalue_field_value_detail
set is_active = false
where
    value in ('GVKEMRI RO','NON TBA','PHC/CHC DEO','SD/MCH DEO','TBA','ANM')
    and field_key = 'role_catg';


DELETE FROM QUERY_MASTER WHERE CODE='fetch_active_location_types';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'353e27eb-b5a4-484e-9635-3385afd34e1f', 97083,  current_date , 97083,  current_date , 'fetch_active_location_types',
 null,
'select name from location_type_master where is_active = true;',
null,
true, 'ACTIVE');