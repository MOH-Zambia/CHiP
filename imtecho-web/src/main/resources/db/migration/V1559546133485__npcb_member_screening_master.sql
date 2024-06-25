CREATE TABLE IF NOT EXISTS public.npcb_member_screening_master(
id bigserial,
member_id bigint NOT NULL,
family_id bigint NOT NULL,
vision_faded boolean,
object_visible_multi_times boolean,
blackboard_vision_faded boolean,
glare_in_vision boolean,
retinal_migraine boolean,
difficulty_night_driving boolean,
frequent_power_change_specs boolean,
other_issue boolean,
current_treatment boolean,
vision_lt_6_18 boolean,
referral_done boolean,
health_infrastructure_id bigint,
latitude text,
longitude text,
mobile_start_date timestamp without time zone NOT NULL,
mobile_end_date timestamp without time zone NOT NULL,
location_id bigint NOT NULL,
location_hierarchy_id bigint NOT NULL,
created_by bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT npcb_member_screening_master_pkey PRIMARY KEY (id)
);

CREATE INDEX IF NOT EXISTS idx_npcb_member_screening_master_member_id
ON public.npcb_member_screening_master
USING btree
(member_id);