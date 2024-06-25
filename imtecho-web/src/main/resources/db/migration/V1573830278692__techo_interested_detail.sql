drop table if exists techo_interested_detail;
create table techo_interested_detail (
id bigserial,
full_name text,
email text,
mobile_number text,
CONSTRAINT techo_interested_detail_pkey PRIMARY KEY (id)
);