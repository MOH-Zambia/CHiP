ALTER TABLE public.mytecho_member
DROP COLUMN IF EXISTS menstruation_days,
ADD COLUMN menstruation_days smallint;

ALTER TABLE public.mytecho_member
DROP COLUMN IF EXISTS normal_cycle_days,
ADD COLUMN normal_cycle_days smallint;

ALTER TABLE public.mytecho_member
DROP COLUMN IF EXISTS last_delivery_date,
ADD COLUMN last_delivery_date timestamp without time zone;


DROP table if exists public.mytecho_period_tracking_detail;

CREATE TABLE public.mytecho_period_tracking_detail (
	id bigserial NOT NULL,
	member_id bigint,
        lmp_date date,
        period_status text,
        remarks text,
	created_on timestamp without time zone,
        created_by bigint,
        modified_on timestamp without time zone,
        modified_by bigint,
	CONSTRAINT mytecho_period_tracking_detail_pkey PRIMARY KEY (id)
);
