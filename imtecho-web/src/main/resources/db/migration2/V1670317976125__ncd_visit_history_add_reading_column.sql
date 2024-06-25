ALTER TABLE IF EXISTS ncd_visit_history
ADD COLUMN IF NOT EXISTS reading character varying(200);