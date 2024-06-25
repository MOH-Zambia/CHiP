alter table rch_anc_master_archive
drop column anc_done_at;

ALTER TABLE rch_wpd_mother_master_archive
ADD COLUMN eligible_for_chiranjeevi boolean;