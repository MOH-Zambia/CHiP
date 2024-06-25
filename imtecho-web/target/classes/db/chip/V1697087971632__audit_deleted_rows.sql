-- Developer note - to use the following function, use this syntax: select audit_register_for_delete(table_name, primary_key_array(optional))
-- It will track the deleted rows for the given table 'table_name'

-- Create a table to store the deleted rows -

create table if not exists audit_deleted_rows (
   table_id smallint,
   identifier text,
   row_details jsonb,
   deleted_at timestamp without time zone default now()
) partition by list (table_id);

create table if not exists audit_registered_rows (
    id serial,
    table_name text primary key,
    pk_name text[]
);

-- Create a trigger function that captures the deleted rows -

create or replace function capture_deleted_rows()
returns trigger as $$
declare
    t_id smallint;
    t_pk text[];
    concatenated_value text := '';
    pk_value text;
begin
    select id, pk_name from audit_registered_rows where table_name = tg_table_name into t_id, t_pk;

    if t_pk is null then
        insert into audit_deleted_rows (table_id, identifier, row_details)
        select t_id, old.id, to_jsonb(old);
    else
        for i in 1..array_length(t_pk, 1) loop
            execute format('select $1.%s', t_pk[i]) using old into pk_value;
            concatenated_value := concatenated_value || pk_value;

            if i < array_length(t_pk, 1) then
                concatenated_value := concatenated_value || '::';
            end if;
        end loop;

        insert into audit_deleted_rows (table_id, identifier, row_details)
        select t_id, concatenated_value, to_jsonb(old);
    end if;
return null;
end;
$$ language plpgsql;

-- Attach the trigger function to the table you want to track deletions on -

create or replace function audit_register_for_delete(table_n text, pk_n text[] default null)
returns void as $$
declare
    table_id smallint;
begin

    insert into audit_registered_rows (table_name, pk_name)
    values (table_n, pk_n)
    on conflict (table_name) do update
    set pk_name = excluded.pk_name;

    select id from audit_registered_rows where table_name = table_n into table_id;

    execute ('create table if not exists audit_deleted_rows_' || table_id || ' partition of audit_deleted_rows for values in ('|| table_id ||')');

    if not exists (
        select 1 from pg_trigger
        where tgname = 'track_deleted_rows'
        and tgrelid = table_n::regclass
    ) then
    execute format(' create trigger track_deleted_rows
        after delete on %s
        for each row execute function capture_deleted_rows();', table_n);
    else
        raise notice 'The trigger already exists';
    end if;
end;
$$ language plpgsql;