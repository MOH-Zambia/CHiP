ALTER TABLE wt_cfhc_suspected_disease
DROP COLUMN IF EXISTS status;

ALTER TABLE wt_cfhc_suspected_disease
add COLUMN status text;