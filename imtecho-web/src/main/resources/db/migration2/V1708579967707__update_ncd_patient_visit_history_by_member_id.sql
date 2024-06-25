DELETE FROM QUERY_MASTER WHERE CODE='ncd_patient_visit_history_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c6b8bc7e-ba12-49bf-aa4c-e121e59f75d0', 97084,  current_date , 97084,  current_date , 'ncd_patient_visit_history_by_member_id',
'memberId',
'WITH memberId AS (
    SELECT #memberId# AS member_id
),
FirstMOVisitTest AS (
    SELECT
        member_id,
        visit_date,
        disease_code,
        status,
        reading,
        created_by,
        visit_by,
        ROW_NUMBER() OVER(
            PARTITION BY disease_code
            ORDER BY visit_date
        ) AS rn
    FROM
        ncd_visit_history
    WHERE
        visit_by = ''MO''
        AND member_id = (SELECT member_id FROM memberId)
),
latest4VisitTest AS (
    SELECT
        member_id,
        visit_date,
        disease_code,
        status,
        reading,
        created_by,
        visit_by,
        ROW_NUMBER() OVER(
            PARTITION BY disease_code
            ORDER BY visit_date DESC
        ) AS rn
    FROM
        ncd_visit_history nvh
    WHERE
        member_id = (SELECT member_id FROM memberId)
    ORDER BY
        disease_code,
        visit_date DESC
),
getBmi AS (
    SELECT
        member_id,
        weight,
        bmi,
        screening_date,
        ''HT'' AS disease_code
    FROM
        ncd_member_hypertension_detail
    WHERE
        member_id = (SELECT member_id FROM memberId)
        AND weight IS NOT NULL
        AND bmi IS NOT NULL
    UNION ALL
    SELECT
        member_id,
        weight,
        bmi,
        screening_date,
        ''IA'' AS disease_code
    FROM
        ncd_member_initial_assessment_detail
    WHERE
        member_id = (SELECT member_id FROM memberId)
        AND weight IS NOT NULL
        AND bmi IS NOT NULL
    UNION ALL
    SELECT
        member_id,
        weight,
        bmi,
        screening_date,
        ''D'' AS disease_code
    FROM
        ncd_member_diabetes_detail
    WHERE
        member_id = (SELECT member_id FROM memberId)
        AND weight IS NOT NULL
        AND bmi IS NOT NULL
),
medicine_data AS (
    SELECT
        member_id,
        diagnosed_on,
        STRING_AGG(
            CONCAT(
                lfvd.value,
                '': '',
                nmdm.frequency,
                '' time(s) a day for '',
                nmdm.duration,
                '' day(s)''
            ),
            ''<br/>''
        ) AS medicines
    FROM
        ncd_member_disesase_medicine nmdm
    INNER JOIN
        listvalue_field_value_detail lfvd ON nmdm.medicine_id = lfvd.id
    WHERE
        member_id = (SELECT member_id FROM memberId)
    GROUP BY
        member_id,
        diagnosed_on
),
test_data AS (
    SELECT
        fmvt.member_id,
        fmvt.visit_date,
        fmvt.disease_code,
        fmvt.status,
        fmvt.reading,
        (
            SELECT
                weight
            FROM
                getBmi
            WHERE
                getBmi.member_id = fmvt.member_id
                AND screening_date = fmvt.visit_date
                AND disease_code = fmvt.disease_code
        ),
        (
            SELECT
                bmi
            FROM
                getBmi
            WHERE
                getBmi.member_id = fmvt.member_id
                AND screening_date = fmvt.visit_date
                AND disease_code = fmvt.disease_code
        ),
        CONCAT(
            fmvt.visit_by,
            '': '',
            um_user.first_name,
            '' '',
            um_user.last_name
        ) AS "DiagnosedBy",
        CASE
            WHEN md.medicines IS NOT NULL THEN md.medicines
            ELSE NULL
        END AS medicines
    FROM
        FirstMOVisitTest fmvt
    INNER JOIN
        um_user ON fmvt.created_by = um_user.id
    LEFT JOIN
        medicine_data md ON md.member_id = fmvt.member_id
        AND CAST(md.diagnosed_on AS DATE) = CAST(fmvt.visit_date AS DATE)
    WHERE
        fmvt.rn = 1
    UNION ALL
    SELECT
        l4vt.member_id,
        l4vt.visit_date,
        l4vt.disease_code,
        l4vt.status,
        l4vt.reading,
        (
            SELECT
                weight
            FROM
                getBmi
            WHERE
                getBmi.member_id = l4vt.member_id
                AND screening_date = l4vt.visit_date
                AND disease_code = l4vt.disease_code
        ),
        (
            SELECT
                bmi
            FROM
                getBmi
            WHERE
                getBmi.member_id = l4vt.member_id
                AND screening_date = l4vt.visit_date
                AND disease_code = l4vt.disease_code
        ),
        CONCAT(
            l4vt.visit_by,
            '': '',
            um_user.first_name,
            '' '',
            um_user.last_name
        ) AS "DiagnosedBy",
        CASE
            WHEN md.medicines IS NOT NULL THEN md.medicines
            ELSE NULL
        END AS medicines
    FROM
        latest4VisitTest l4vt
    INNER JOIN
        um_user ON l4vt.created_by = um_user.id
    LEFT JOIN
        medicine_data md ON md.member_id = l4vt.member_id
        AND CAST(md.diagnosed_on AS DATE) = CAST(l4vt.visit_date AS DATE)
    WHERE
        l4vt.rn <= 4
)
SELECT *
FROM test_data;',
null,
true, 'ACTIVE');