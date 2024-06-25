DELETE FROM QUERY_MASTER WHERE CODE='get_comment_from_clinic_or_home_visit';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9a4b6c7b-931a-4087-a70f-5376ad9814d3', 97074,  current_date , 97074,  current_date , 'get_comment_from_clinic_or_home_visit',
'memberId',
'SELECT CONCAT(flag_reason,CASE WHEN other_reason IS NULL THEN '' : Not Available'' ELSE CONCAT('' :'', other_reason) END) AS comment,created_on
FROM (
    SELECT flag_reason, other_reason,c.flag,created_on
    FROM ncd_member_clinic_visit_detail as c
    WHERE member_id = #memberId# and c.flag=''true''
    UNION ALL
    SELECT flag_reason, other_reason,h.flag,created_on
    FROM ncd_member_home_visit_detail as h
    WHERE member_id = #memberId# and h.flag=''true''
) AS merged_data
order by created_on desc
LIMIT 1;',
null,
true, 'ACTIVE');