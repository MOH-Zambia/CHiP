begin;
update rch_wpd_child_master
set is_high_risk_case = true
where birth_weight < 2.5
and is_high_risk_case is null;
commit;

begin;
update imt_member
set is_high_risk_case = true
from rch_wpd_child_master
where imt_member.is_high_risk_case is null
and rch_wpd_child_master.birth_weight < 2.5
and imt_member.id = rch_wpd_child_master.member_id;
commit;