-- all blocks hierarchy
/*
 with blocks as (
	select 
	lm.id,
	lm."type",
	1 as depth,
	-2 as parent_id,
	parent.type as parent_loc_type,
	lm.demographic_type as child_loc_demographic_type,
	parent.demographic_type as parent_loc_demographic_type 
	from location_master lm
	inner join location_master parent on parent.id =lm.parent 
	where lm."type" in ('B', 'Z') and lm.state= 'ACTIVE'
), phc as (
	select 
	lm.id,
	lm."type" as child_loc_type,
	2 as depth,
	-2 as parent_id,
	parent.type,
	parent.child_loc_demographic_type,
	parent.parent_loc_demographic_type
	from location_master lm
	inner join blocks parent on parent.id =lm.parent 
	where lm.state= 'ACTIVE' and lm.parent = parent.id
), sc as (
	select 
	lm.id,
	lm."type",
	3 as depth,
	-2 as parent_id,
	parent.type as parent_loc_type,
	parent.child_loc_demographic_type,
	parent.parent_loc_demographic_type
	from location_master lm
	inner join phc parent on parent.id =lm.parent 
	where lm.state= 'ACTIVE' and lm.parent = parent.id
), village as (
	select 
	lm.id,
	lm."type",
	4 as depth,
	-2 as parent_id,
	parent.type as parent_loc_type,
	parent.child_loc_demographic_type,
	parent.parent_loc_demographic_type
	from location_master lm
	inner join sc parent on parent.id =lm.parent 
	where lm.state= 'ACTIVE' and lm.parent = parent.id
), area as (
	select 
	lm.id,
	lm."type",
	5 as depth,
	-2 as parent_id,
	parent.type as parent_loc_type,
	parent.child_loc_demographic_type,
	parent.child_loc_demographic_type
	from location_master lm
	inner join village parent on parent.id =lm.parent 
	where lm.state= 'ACTIVE' and lm.parent = parent.id
), final_det as (
	select * from blocks
	union 
	select * from phc
	union 
	select * from sc
	union 
	select * from village
	union 
	select * from area
)


INSERT INTO public.location_hierchy_closer_det
(child_id, child_loc_type, "depth", parent_id, parent_loc_type, child_loc_demographic_type, parent_loc_demographic_type)
select id,type,depth, parent_id,parent_loc_type,child_loc_demographic_type,child_loc_demographic_type   from final_det
*/

