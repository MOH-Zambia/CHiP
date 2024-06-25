update rch_pregnancy_registration_det 
set current_location_id = case when imt_family.area_id is null then imt_family.location_id else imt_family.area_id end
from imt_member im,imt_family 
where imt_family.family_id = im.family_id and im.id = rch_pregnancy_registration_det.member_id;