DROP TABLE IF EXISTS public.rch_lmpfu_family_planning_methods_rel;

ALTER TABLE public.rch_lmp_follow_up
    DROP COLUMN IF EXISTS family_planning_method,
    ADD COLUMN family_planning_method character varying(50);