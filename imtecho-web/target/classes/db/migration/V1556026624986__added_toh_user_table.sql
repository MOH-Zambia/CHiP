create table toh_user
(id bigserial,
 name character varying(255),
 designation character varying(255),
 organization character varying(255),
 purpose text,
 state character varying(255)
);

alter table um_user
add column login_code character varying(255);