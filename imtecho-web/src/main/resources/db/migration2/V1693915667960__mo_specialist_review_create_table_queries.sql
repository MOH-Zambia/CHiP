DROP TABLE IF EXISTS public.ncd_ecg_member_detail;
CREATE TABLE IF NOT EXISTS public.ncd_ecg_member_detail
(
    id serial PRIMARY KEY,
    member_id integer NOT NULL,
    created_by integer,
    created_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by integer,
    modified_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    screening_date timestamp without time zone,
    type text,
    satisfactory_image boolean,
    old_mi integer,
    lvh integer
);

DROP TABLE IF EXISTS public.ncd_stroke_member_detail;
CREATE TABLE IF NOT EXISTS public.ncd_stroke_member_detail
(
    id serial PRIMARY KEY,
    member_id integer NOT NULL,
    created_by integer,
    created_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by integer,
    modified_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    screening_date timestamp without time zone,
    stroke_present boolean
);

DROP TABLE IF EXISTS public.ncd_amputation_member_detail;
CREATE TABLE IF NOT EXISTS public.ncd_amputation_member_detail
(
    id serial PRIMARY KEY,
    member_id integer NOT NULL,
    created_by integer,
    created_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by integer,
    modified_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    screening_date timestamp without time zone,
    amputation_present boolean
);

DROP TABLE IF EXISTS public.ncd_renal_member_detail;
CREATE TABLE IF NOT EXISTS public.ncd_renal_member_detail
(
    id serial PRIMARY KEY,
    member_id integer NOT NULL,
    created_by integer,
    created_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by integer,
    modified_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    screening_date timestamp without time zone,
    is_s_creatinine_done boolean,
    s_creatinine_value numeric(6,2),
    is_renal_complication_present boolean
);

drop table if exists ncd_specialist_master;
create table if not exists ncd_specialist_master(
	id bigserial primary key,
	member_id integer,
	created_by integer,
    created_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_by integer,
    modified_on timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
	last_ecg_specialist_id integer NULL,
	last_stroke_specialist_id integer NULL,
	last_amputation_specialist_id integer NULL,
	last_renal_specialist_id integer NULL,
	last_cardiologist_id integer NULL,
	last_opthamologist_id integer NULL
);