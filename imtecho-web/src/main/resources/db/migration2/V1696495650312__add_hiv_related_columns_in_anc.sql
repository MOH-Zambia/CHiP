ALTER TABLE rch_anc_master
ADD COLUMN if not exists cd_four_level integer,
ADD COLUMN if not exists viral_load integer,
ADD COLUMN if not exists coinfections text,
ADD COLUMN if not exists is_hiv_counselling_done boolean,
ADD COLUMN if not exists is_art_started boolean,
ADD COLUMN if not exists is_partner_tested_positive_for_hiv boolean;


ALTER TABLE rch_wpd_child_master
ADD COLUMN if not exists is_antiretroviral_therapy_started boolean;


ALTER TABLE rch_pnc_child_master
ADD COLUMN if not exists is_cpt_started boolean,
ADD COLUMN if not exists is_eid_started boolean;