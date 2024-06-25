drop sequence IF EXISTS covid_lab_test_id_seq;
create sequence covid_lab_test_id_seq start 1;

create or replace function get_lab_test_id() RETURNS text as $$
        begin
                return 'L' || nextval('covid_lab_test_id_seq');
        end;
$$ LANGUAGE plpgsql;

ALTER TABLE covid19_lab_test_detail  drop column if exists lab_test_id,
add column lab_test_id text,
alter column lab_test_id set default get_lab_test_id();

update covid19_lab_test_detail set lab_test_id = get_lab_test_id();