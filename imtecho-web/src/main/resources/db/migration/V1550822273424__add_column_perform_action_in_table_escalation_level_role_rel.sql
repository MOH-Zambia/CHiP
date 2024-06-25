ALTER TABLE escalation_level_role_rel DROP COLUMN IF EXISTS can_perform_action;
ALTER TABLE escalation_level_role_rel ADD COLUMN can_perform_action boolean  DEFAULT false;