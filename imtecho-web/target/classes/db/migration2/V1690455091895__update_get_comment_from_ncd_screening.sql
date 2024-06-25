DELETE FROM QUERY_MASTER WHERE CODE='get_comment_from_ncd_screening';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'65711a3e-0d9e-4e8e-9110-53972e33eb5a', 97084,  current_date , 97084,  current_date , 'get_comment_from_ncd_screening',
'memberId',
'SELECT
    flag,
    note,
    created_on,
    tbl
FROM (
    SELECT
        flag,
        note,
        created_on,
        ''ht'' AS tbl
    FROM
        ncd_member_hypertension_detail
    WHERE
        member_id = #memberId#
        AND flag = ''true''
    ORDER BY
        created_on DESC
    LIMIT 1
) AS hypertension_data

UNION ALL

SELECT
    flag,
    note,
    created_on,
    tbl
FROM (
    SELECT
        flag,
        note,
        created_on,
        ''db'' AS tbl
    FROM
        ncd_diabetes_confirmation_detail
    WHERE
        member_id =#memberId#
        AND flag = ''true''
    ORDER BY
        created_on DESC
    LIMIT 1
) AS diabetes_data

UNION ALL

SELECT
    flag,
    note,
    created_on,
    tbl
FROM (
    SELECT
        flag,
        note,
        created_on,
        ''mh'' AS tbl
    FROM
        ncd_member_mental_health_detail
    WHERE
        member_id =#memberId#
        AND flag = ''true''
    ORDER BY
        created_on DESC
    LIMIT 1
) AS mental_data;',
null,
true, 'ACTIVE');