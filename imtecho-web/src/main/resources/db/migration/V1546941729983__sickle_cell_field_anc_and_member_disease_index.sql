ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS sickle_cell_test,
ADD COLUMN sickle_cell_test text;