create table if not exists yearly_location_wise_anc_performance
(
	loc_id bigint not null,
	year varchar(10),
	anc_regd integer,
	early_anc_regd integer,
	delivery_regd integer,
	child_regd integer,
	CONSTRAINT yearly_location_wise_anc_performance_pkey PRIMARY KEY (loc_id,year)
);

alter table rch_pregnancy_registration_det 
add column location_id bigint;

update rch_pregnancy_registration_det rprd
set location_id = t.loc
from 
(
	select  case when f.area_id is not null then f.area_id::bigint else f.location_id end as loc,r.member_id
	from rch_pregnancy_registration_det r inner join imt_member m on m.id = r.member_id
	inner join imt_family f on f.family_id = m.family_id
) t 
where t.member_id = rprd.member_id;

