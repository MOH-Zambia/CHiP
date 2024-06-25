update rch_pregnancy_registration_det 
set location_id = case when imt_family.area_id is null then imt_family.location_id else cast(imt_family.area_id as bigint) end 
from imt_member, imt_family 
where imt_member.id = rch_pregnancy_registration_det.member_id 
and imt_member.family_id = imt_family.family_id
and rch_pregnancy_registration_det.location_id is null;
/*
update rch_immunisation_master 
set location_id = case when imt_family.area_id is null then imt_family.location_id else cast(imt_family.area_id as bigint) end
from imt_member, imt_family
where imt_member.id = rch_immunisation_master.member_id 
and imt_member.family_id = imt_family.family_id
and rch_immunisation_master.location_id is null;
*/