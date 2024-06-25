-- Developer note - to use the following function, use this syntax: select audit_register_for_update(table_name, column_name_array, primary_key_array(optional))
-- It will track the columns mentioned in the array 'column_name_array' for the given table 'table_name'

-- Create a table to store the updated columns -

create table if not exists audit_updated_columns (
   table_id smallint,
   identifier text,
   column_name text,
   old_value text,
   new_value text,
   updated_at timestamp without time zone default now()
) partition by list (table_id);

create table if not exists audit_registered_columns (
    id serial,
    table_name text primary key,
    column_name text[],
    pk_name text[]
);

-- Create a trigger function that captures the updated columns -

create or replace function capture_updated_columns()
returns trigger as $$
declare
    t_id smallint;
    t_pk text[];
    concatenated_value text := '';
    pk_value text;
begin
    select id, pk_name from audit_registered_columns where table_name = tg_table_name into t_id, t_pk;

    if t_pk is null then
        insert into audit_updated_columns (table_id, identifier, column_name, old_value, new_value)
        select t_id, new.id, pre.key, pre.value, post.value
        from json_each_text(to_json(old)) as pre cross join json_each_text(to_json(new)) as post
        where pre.key = post.key and pre.value is distinct from post.value and pre.key = any(select unnest(column_name) from audit_registered_columns where table_name = tg_table_name);
    else
        for i in 1..array_length(t_pk, 1) loop
            execute format('select $1.%s', t_pk[i]) using new into pk_value;
            concatenated_value := concatenated_value || pk_value;

            if i < array_length(t_pk, 1) then
                concatenated_value := concatenated_value || '::';
            end if;
        end loop;

        insert into audit_updated_columns (table_id, identifier, column_name, old_value, new_value)
        select t_id, concatenated_value, pre.key, pre.value, post.value
        from json_each_text(to_json(old)) as pre cross join json_each_text(to_json(new)) as post
        where pre.key = post.key and pre.value is distinct from post.value and pre.key = any(select unnest(column_name) from audit_registered_columns where table_name = tg_table_name);
    end if;
return new;
end;
$$ language plpgsql;

-- Create a function that stores which columns to store upon updation -

create or replace function audit_register_for_update(table_n text, columns_n text[], pk_n text[] default null)
returns void as $$
declare
    table_id smallint;
begin
    insert into audit_registered_columns (table_name, column_name, pk_name)
    values (table_n, columns_n, pk_n)
    on conflict (table_name) do update
    set column_name = excluded.column_name,
        pk_name = excluded.pk_name;

    select id from audit_registered_columns where table_name = table_n into table_id;

    execute ('create table if not exists audit_updated_columns_' || table_id || ' partition of audit_updated_columns for values in ('|| table_id ||')');

    if not exists (
        select 1 from pg_trigger
        where tgname = 'track_updated_columns'
        and tgrelid = table_n::regclass
    ) then
    execute format('create trigger track_updated_columns
        after update on %s
        for each row execute function capture_updated_columns();', table_n);
    else
        raise notice 'The trigger already exists';
    end if;
end;
$$ language plpgsql;