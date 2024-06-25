with location_ids as (
	select id
	from location_master
	where type = 'R'
),target_details as (
	select location_ids.id,
	location_wise_expected_target.financial_year,
	sum(location_wise_expected_target.expected_mother_reg) as expected_mother,
	sum(location_wise_expected_target.expected_delivery_reg) as expected_delivery,
	sum(location_wise_expected_target.ela_dpt_opv_mes_vita_1dose) as expected_vit1_dose
	from location_ids
	inner join location_hierchy_closer_det on location_ids.id = location_hierchy_closer_det.parent_id
	inner join location_wise_expected_target on location_hierchy_closer_det.child_id = location_wise_expected_target.location_id
	and location_hierchy_closer_det."depth" = 1
	group by location_ids.id,location_wise_expected_target.financial_year
)insert into location_wise_expected_target
(location_id,financial_year,expected_mother_reg,expected_delivery_reg,ela_dpt_opv_mes_vita_1dose,
created_by,created_on,modified_by,modified_on,state)
select id,financial_year,expected_mother,expected_delivery,expected_vit1_dose,
-1,now(),-1,now(),'LOCKED'
from target_details;