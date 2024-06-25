/*

alter table location_wise_expected_target
drop column if exists state,
drop column if exists no_of_times_unlocked,
add column state character varying(10),
add column no_of_times_unlocked integer;

with details as (
	select financial_year,
	sum(expected_mother_reg) as mother_registered,
	sum(expected_delivery_reg) as delivery_registered,
	sum(ela_dpt_opv_mes_vita_1dose) as vit1
	from location_wise_expected_target
	where location_id in (select id from location_master where type in ('P','U'))
	group by financial_year
)insert into location_wise_expected_target
(location_id,financial_year,expected_mother_reg,expected_delivery_reg,ela_dpt_opv_mes_vita_1dose,
created_by,created_on,modified_by,modified_on)
select 2,financial_year,mother_registered,delivery_registered,vit1,
-1,now(),-1,now()
from details;

update location_wise_expected_target
set state = 'LOCKED'
where location_id in (select id from location_master where type in ('S','D','C','B','Z','P','U'));

update location_wise_expected_target
set state = 'DRAFT'
where state is null;

update menu_config
set feature_json = '{"canLock":false,"canUnlock":false}'
where menu_name = 'Location Wise Expected Target';

*/