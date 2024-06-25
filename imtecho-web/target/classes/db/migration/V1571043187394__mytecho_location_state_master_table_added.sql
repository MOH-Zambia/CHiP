DROP table if exists public.location_state_master;

CREATE TABLE public.location_state_master (
	id bigserial NOT NULL,
	name text,
	created_on timestamp without time zone,
        created_by bigint,
        modified_on timestamp without time zone,
        modified_by bigint,
        state text,
	CONSTRAINT location_state_master_pkey PRIMARY KEY (id)
);

ALTER TABLE mytecho_user ADD COLUMN state_id bigint;