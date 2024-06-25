ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;

ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;

ALTER TABLE public.rch_wpd_child_master
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;

ALTER TABLE public.rch_wpd_mother_master
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;

ALTER TABLE public.rch_pnc_mother_master
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;


ALTER TABLE public.rch_pnc_child_master
DROP COLUMN IF EXISTS is_high_risk_case,
ADD COLUMN is_high_risk_case boolean;