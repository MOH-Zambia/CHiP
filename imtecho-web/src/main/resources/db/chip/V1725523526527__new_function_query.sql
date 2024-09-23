drop function if exists get_dhis2_payload;

CREATE OR REPLACE FUNCTION get_dhis2_payload(month_end DATE, facility_id INT)
RETURNS JSONB AS
$$
BEGIN
    RETURN (
        SELECT
            row_to_json(t, true)
        FROM
        (
            SELECT
                json_agg(d) AS dataValues
            FROM
            (
                SELECT
                    r.dhis2_indicator_id AS dataElement,
                    'USfPOPAeN16' AS categoryOptionCombo,
                    r.dhis2_facility_id AS orgUnit,
                    r.period AS period,
                    r.indicator_value AS value
                FROM
                (
                    SELECT *
                    FROM get_monthly_report(month_end, facility_id)
                ) AS r
            ) AS d
        ) AS t
    );
END;
$$ LANGUAGE plpgsql;