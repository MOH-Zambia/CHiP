DELETE FROM QUERY_MASTER WHERE CODE='get_complications_for_ncd_from_known_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8ca78f38-1100-45ff-acf3-1aa18f826629', 97084,  current_date , 97084,  current_date , 'get_complications_for_ncd_from_known_history',
'memberId',
'WITH details AS (
    SELECT
        member_id,
        unnest(string_to_array(disease_history, '','')) AS disease_id,
        other_disease_history
    FROM
        imt_member_ncd_detail
    WHERE
        member_id = #memberId#
        AND disease_history IS NOT NULL
),
final_details AS (
    SELECT
        member_id,
        string_agg(DISTINCT lfvd.value, '','') AS disease,
        string_agg(DISTINCT other_disease_history, '','') AS other_disease
    FROM
        details
    left JOIN
        listvalue_field_value_detail lfvd ON cast(lfvd.id AS text) = details.disease_id
    GROUP BY
        member_id
)
SELECT
    im.id,
    fd.disease AS disease,
    fd.other_disease AS other_disease
FROM
    imt_member im
LEFT JOIN
    final_details fd ON fd.member_id = im.id
WHERE
    im.id = #memberId#;',
'N/A',
true, 'ACTIVE');