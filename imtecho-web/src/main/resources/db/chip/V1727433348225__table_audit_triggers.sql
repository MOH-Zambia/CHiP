-- Developer note - to use the following function, use this syntax: select audit_register_table_for_update(table_name, primary_key_array(optional))
-- It will track the updated rows for the given table 'table_name'

-- Create a table to store the updated rows -

create table if not exists audit_updated_rows (
   table_id smallint,
   identifier text,
   row_details jsonb,
   updated_at timestamp without time zone default now()
) partition by list (table_id);

create table if not exists audit_table_registered_rows (
    id serial,
    table_name text primary key,
    pk_name text[]
);

-- Create a trigger function that captures the updated rows -

create or replace function capture_updated_rows()
returns trigger as $$
declare
    t_id smallint;
    t_pk text[];
    concatenated_value text := '';
    pk_value text;
begin
    select id, pk_name from audit_table_registered_rows where table_name = tg_table_name into t_id, t_pk;

    if t_pk is null then
        insert into audit_updated_rows (table_id, identifier, row_details)
        select t_id, old.id, to_jsonb(old);
    else
        for i in 1..array_length(t_pk, 1) loop
            execute format('select $1.%s', t_pk[i]) using old into pk_value;
            concatenated_value := concatenated_value || pk_value;

            if i < array_length(t_pk, 1) then
                concatenated_value := concatenated_value || '::';
            end if;
        end loop;

        insert into audit_updated_rows (table_id, identifier, row_details)
        select t_id, concatenated_value, to_jsonb(old);
    end if;
return null;
end;
$$ language plpgsql;

-- Attach the trigger function to the table you want to track deletions on -

create or replace function audit_register_table_for_update(table_n text, pk_n text[] default null)
returns void as $$
declare
    table_id smallint;
begin

    insert into audit_table_registered_rows (table_name, pk_name)
    values (table_n, pk_n)
    on conflict (table_name) do update
    set pk_name = excluded.pk_name;

    select id from audit_table_registered_rows where table_name = table_n into table_id;

    execute ('create table if not exists audit_updated_rows_' || table_id || ' partition of audit_updated_rows for values in ('|| table_id ||')');

    if not exists (
        select 1 from pg_trigger
        where tgname = 'track_table_updated_rows'
        and tgrelid = table_n::regclass
    ) then
    execute format(' create trigger track_table_updated_rows
        after update on %s
        for each row execute function capture_updated_rows();', table_n);
    else
        raise notice 'The trigger already exists';
    end if;
end;
$$ language plpgsql;


select audit_register_table_for_update('imt_member', array['id']);
select audit_register_table_for_update('imt_family', array['id']);
select audit_register_table_for_update('rch_hiv_known_master', array['id']);
select audit_register_table_for_update('malaria_details', array['id']);
select audit_register_table_for_update('rch_hiv_screening_master', array['id']);
select audit_register_table_for_update('gbv_visit_master', array['id']);
select audit_register_table_for_update('malaria_index_case_details', array['id']);
select audit_register_table_for_update('malaria_non_index_case_details', array['id']);
select audit_register_table_for_update('rch_preg_hiv_positive_master', array['id']);
select audit_register_table_for_update('emtct_details', array['id']);
select audit_register_table_for_update('rch_vaccine_adverse_effect', array['id']);
select audit_register_table_for_update('tuberculosis_screening_details', array['id']);
select audit_register_table_for_update('covid_screening_details', array['id']);
select audit_register_table_for_update('rch_pnc_mother_master', array['id']);
select audit_register_table_for_update('rch_pnc_mother_danger_signs_rel', array['mother_pnc_id', 'mother_danger_signs']);
select audit_register_table_for_update('rch_pnc_child_master', array['id']);
select audit_register_table_for_update('rch_pnc_child_danger_signs_rel', array['child_pnc_id', 'child_danger_signs']);
select audit_register_table_for_update('rch_child_service_master', array['id']);
select audit_register_table_for_update('rch_child_service_diseases_rel', array['child_service_id', 'diseases']);
select audit_register_table_for_update('rch_child_service_symptoms_rel', array['child_service_id', 'symptoms']);
select audit_register_table_for_update('rch_wpd_mother_master', array['id']);
select audit_register_table_for_update('rch_wpd_mother_danger_signs_rel', array['wpd_id', 'mother_danger_signs']);
select audit_register_table_for_update('rch_wpd_child_master', array['id']);
select audit_register_table_for_update('rch_wpd_child_congential_deformity_rel', array['wpd_id', 'congential_deformity']);
select audit_register_table_for_update('rch_immunisation_master', array['id']);
select audit_register_table_for_update('rch_anc_master', array['id']);
select audit_register_table_for_update('stock_inventory_entity', array['id']);