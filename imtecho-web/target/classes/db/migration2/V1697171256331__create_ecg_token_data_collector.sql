drop table if exists ecg_token_metadata;
create table if not exists ecg_token_metadata
(
  id serial primary key,
  user_id integer not null,
  token character varying(448) not null,
  created_on timestamp without time zone not null
);