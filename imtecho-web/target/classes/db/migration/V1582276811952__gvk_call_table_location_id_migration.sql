begin;
update gvk_manage_call_master 
set location_id = imt_family.location_id 
from imt_member
inner join imt_family on imt_member.family_id = imt_family.family_id 
where gvk_manage_call_master.member_id = imt_member.id
and gvk_manage_call_master.call_type = 'FHW_HIGH_RISK_CONF';
commit;