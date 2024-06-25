ALTER TABLE public.rch_lmp_follow_up
    ADD COLUMN notification_id bigint;

ALTER TABLE public.rch_anc_master
    ADD COLUMN notification_id bigint;

ALTER TABLE public.rch_wpd_mother_master
    ADD COLUMN notification_id bigint;

ALTER TABLE public.rch_wpd_child_master
    ADD COLUMN notification_id bigint;