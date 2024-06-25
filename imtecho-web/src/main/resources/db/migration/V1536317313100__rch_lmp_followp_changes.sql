ALTER TABLE rch_lmp_follow_up ALTER is_pregnant DROP NOT NULL;

ALTER TABLE rch_lmp_follow_up DROP COLUMN IF EXISTS year_of_wedding;

ALTER TABLE rch_lmp_follow_up DROP COLUMN IF EXISTS other_death_reason;

