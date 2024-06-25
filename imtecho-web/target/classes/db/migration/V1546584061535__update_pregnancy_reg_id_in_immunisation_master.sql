update rch_immunisation_master 
set pregnancy_reg_det_id = rch_anc_master.pregnancy_reg_det_id
from rch_anc_master 
where rch_immunisation_master.visit_id = rch_anc_master.id
and rch_immunisation_master.member_id = rch_anc_master.member_id
and rch_immunisation_master.member_type = 'M' 
and rch_immunisation_master.visit_type = 'FHW_ANC' 
and rch_immunisation_master.pregnancy_reg_det_id is null;