CREATE TABLE IF NOT EXISTS public.npcb_member_examination_detail(
id bigserial,
member_id bigint NOT NULL,
health_infrastructure_id bigint,
re_dist_sph real,
le_dist_sph real,
re_near_sph real,
le_near_sph real,
re_cyl real,
le_cyl real,
re_axis real,
le_axis real,
re_dist_va real,
le_dist_va real,
re_near_va real,
le_near_va real,
on_the_spot_treatment boolean,
on_the_spot_treatment_comment text,
is_cataract_suggested boolean,
cataract_health_infrastructure_id bigint,
other_issues_referral boolean,
other_issues_health_infrastructure_id bigint,
created_by bigint NOT NULL,
created_on timestamp without time zone NOT NULL,
modified_by bigint,
modified_on timestamp without time zone,
CONSTRAINT npcb_member_examination_detail_pkey PRIMARY KEY (id)
);



CREATE INDEX IF NOT EXISTS idx_npcb_member_examination_detail_member_id
ON public.npcb_member_examination_detail
USING btree
(member_id);    