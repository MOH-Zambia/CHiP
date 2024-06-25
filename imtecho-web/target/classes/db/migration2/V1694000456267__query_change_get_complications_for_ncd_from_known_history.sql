DELETE FROM QUERY_MASTER WHERE CODE='get_complications_for_ncd_from_known_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8ca78f38-1100-45ff-acf3-1aa18f826629', 97080,  current_date , 97080,  current_date , 'get_complications_for_ncd_from_known_history',
'memberId',
'WITH mob_disease AS (
    SELECT
        unnest(string_to_array(disease_history, '','')) AS disease_id,
        *
    FROM
        ncd_member_hypertension_detail
    WHERE
        member_id = #memberId#
),
final_mob_details AS (
    SELECT
        member_id,
        string_agg(DISTINCT lfvd.value, '','') AS disease,
        string_agg(DISTINCT other_disease, '','') AS other_disease
    FROM
        mob_disease md
    INNER JOIN
        listvalue_field_value_detail lfvd ON cast(lfvd.id AS text) = md.disease_id
    WHERE
        lfvd.value NOT ILIKE ''none''
    GROUP BY
        member_id
),
web_details AS (
    SELECT
        member_id,
        unnest(string_to_array(history_disease, '','')) AS disease_id,
        other_disease
    FROM
        ncd_member_initial_assessment_detail
    WHERE
        member_id = #memberId#
        AND history_disease IS NOT NULL
),
final_web_details AS (
    SELECT
        member_id,
        string_agg(DISTINCT lfvd.value, '','') AS disease,
        string_agg(DISTINCT other_disease, '','') AS other_disease
    FROM
        web_details wd
    left JOIN
        listvalue_field_value_detail lfvd ON cast(lfvd.id AS text) = wd.disease_id
    WHERE
        lfvd.value NOT ILIKE ''none''
    GROUP BY
        member_id
)
SELECT
    im.id,
    fwd.disease AS from_web,
    fwd.other_disease AS other_disease_web,
    fmd.disease AS from_mob,
    fmd.other_disease AS other_disease_mob
FROM
    imt_member im
LEFT JOIN
    final_web_details fwd ON fwd.member_id = im.id
LEFT JOIN
    final_mob_details fmd ON fmd.member_id = im.id
WHERE
    im.id = #memberId#;',
null,
true, 'ACTIVE');