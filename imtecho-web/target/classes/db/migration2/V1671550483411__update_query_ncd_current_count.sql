DELETE FROM QUERY_MASTER WHERE CODE='ncd_current_count';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6ac14ae8-4ccf-4dc4-8106-474f1162557f', 97070,  current_date , 97070,  current_date , 'ncd_current_count',
 null,
'select
count(distinct member_id) filter (
            where disease_code = ''HT''
        ) as "Hypertension",
count(distinct member_id) filter (
            where disease_code = ''D''
        ) as "Diabetes",
count(distinct member_id) filter (
            where disease_code = ''MH''
        ) as "Mental_Health",
count(distinct member_id) filter (
            where disease_code = ''O''
        ) as "Oral_Cancer",
count(distinct member_id) filter (
            where disease_code = ''B''
        ) as "Breast_Cancer",
count(distinct member_id) filter (
            where disease_code = ''C''
        ) as "Cervical_Cancer",
count(distinct member_id) as "Total_Count"
from ncd_master where status=''SCREENED''',
null,
true, 'ACTIVE');