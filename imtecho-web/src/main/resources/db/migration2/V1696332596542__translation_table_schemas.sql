create table if not exists language_master (
id serial primary key,
language_key character varying(10) unique not null,
language_value text not null,
is_ltr boolean not null,
is_active boolean not null,
created_by integer not null,
created_on timestamp without time zone,
modified_by integer not null,
modified_on timestamp without time zone
);

create table if not exists app_master (
id serial primary key,
app_key character varying(20) unique not null,
app_value text not null,
is_active boolean not null,
created_by integer not null,
created_on timestamp without time zone not null,
modified_by integer not null,
modified_on timestamp without time zone not null
);

create table if not exists translation_master (
id serial not null unique,
app smallint not null,
language smallint not null,
key text not null,
value text not null,
is_active boolean not null,
created_by integer not null,
created_on timestamp without time zone not null,
modified_by integer not null,
modified_on timestamp without time zone not null,
primary key (id,app, language, key)
);

-- Create the unique constraint
alter table if exists translation_master
drop constraint if exists unique_app_lang_key;

alter table if exists translation_master
add constraint unique_app_lang_key unique (app, language, key);