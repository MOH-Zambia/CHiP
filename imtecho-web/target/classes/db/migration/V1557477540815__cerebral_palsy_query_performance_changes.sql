delete from query_master where code='cerebral_palsy_retrieve_immunisation_by_id';
delete from query_master where code='cerebral_palsy_retrieve_anc_danger_signs_by_id';
delete from query_master where code='cerebral_palsy_retrieve_immunisation_anc_danger_signs_by_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_immunisation_anc_danger_signs_by_id','id','
with preg_member_ids as (
	select pregnancy_reg_det_id, member_id
	from rch_wpd_mother_master 
	where id = (select wpd_mother_id from rch_wpd_child_master where member_id = #id#)
),anc_danger_signs as (
	select distinct listvalue_field_value_detail.value as dangerous_sign_id,preg_member_ids.member_id
	from preg_member_ids
	inner join rch_anc_master on preg_member_ids.pregnancy_reg_det_id = rch_anc_master.pregnancy_reg_det_id
	and rch_anc_master.member_id = preg_member_ids.member_id
	left join rch_anc_dangerous_sign_rel on rch_anc_master.id = rch_anc_dangerous_sign_rel.anc_id
	left join listvalue_field_value_detail on rch_anc_dangerous_sign_rel.dangerous_sign_id = listvalue_field_value_detail.id
),immunisation_details as (
	select concat(immunisation_given,'' ('',to_char(given_on,''DD-MM-YYYY''),'')'') as immunisation,
	preg_member_ids.member_id
	from rch_immunisation_master
	inner join preg_member_ids on rch_immunisation_master.pregnancy_reg_det_id = preg_member_ids.pregnancy_reg_det_id	
	and preg_member_ids.member_id = rch_immunisation_master.member_id
)
select
string_agg(immunisation,'', '') as immunisation ,string_agg(dangerous_sign_id,'', '') as ancDangerSigns
from preg_member_ids
left join immunisation_details on preg_member_ids.member_id = immunisation_details.member_id
left join anc_danger_signs on preg_member_ids.member_id = anc_danger_signs.member_id
group by preg_member_ids.member_id
',true,'ACTIVE');