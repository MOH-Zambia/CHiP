ALTER TABLE public.event_mobile_notification_pending
  ADD COLUMN state text;

ALTER TABLE public.imt_member
  ADD COLUMN death_detail_id bigint;

CREATE TABLE public.rch_member_death_deatil
(
   id bigserial, 
   member_id bigint, 
   family_id text, 
   dod timestamp without time zone, 
   created_on timestamp without time zone, 
   created_by bigint
);

CREATE TABLE public.rch_member_death_reason_rel
(
  death_detail_id bigint NOT NULL,
  death_reason integer NOT NULL,
  CONSTRAINT rch_member_death_reason_rel_pkey PRIMARY KEY (death_detail_id, death_reason)
);

