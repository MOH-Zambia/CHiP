DROP SEQUENCE IF EXISTS covid_lab_test_id_seq;
CREATE SEQUENCE covid_lab_test_id_seq START 1;

CREATE OR REPLACE FUNCTION get_lab_test_id() RETURNS text AS $$
        BEGIN
                RETURN 'L' || nextval('covid_lab_test_id_seq');
        END;
$$ LANGUAGE plpgsql;