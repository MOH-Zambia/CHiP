ALTER TABLE rch_wpd_mother_master
DROP COLUMN if exists has_delivery_happened, ADD COLUMN has_delivery_happened boolean;

ALTER TABLE rch_pnc_child_master
DROP COLUMN if exists other_death_reason, ADD COLUMN other_death_reason character varying(50);

ALTER TABLE rch_pnc_child_master
DROP COLUMN if exists child_referral_done, ADD COLUMN child_referral_done boolean;

ALTER TABLE rch_pnc_mother_master
DROP COLUMN if exists family_planning_method, ADD COLUMN family_planning_method character varying(50);