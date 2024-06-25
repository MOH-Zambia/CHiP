delete from location_hierchy_closer_det;

INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select id,type,id,type,0 from location_master;

INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level2,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level2 
where level3 is null and level2 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level3,child.type,2 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level3 
where level4 is null and level3 is not null;



INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level4,child.type,3 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level4 
where level5 is null and level4 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level5,child.type,4 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level5 
where level6 is null and level5 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level6,child.type,5 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level6 
where level7 is null and level6 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level1,parent.type,level7,child.type,6 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level1 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level2,parent.type,level3,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level2 
inner join location_master child on  child.id = llh.level3 
where level4 is null and level3 is not null;



INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level2,parent.type,level4,child.type,2 from location_level_hierarchy_master llh 
inner join location_master parent on parent.id = llh.level2 
inner join location_master child on child.id = llh.level4 
where level5 is null and level4 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level2,parent.type,level5,child.type,3 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level2 
inner join location_master child on  child.id = llh.level5 
where level6 is null and level5 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level2,parent.type,level6,child.type,4 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level2 
inner join location_master child on  child.id = llh.level6 
where level7 is null and level6 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level2,parent.type,level7,child.type,5 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level2 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level3,parent.type,level4,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on parent.id = llh.level3 
inner join location_master child on child.id = llh.level4 
where level5 is null and level4 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level3,parent.type,level5,child.type,2 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level3 
inner join location_master child on  child.id = llh.level5 
where level6 is null and level5 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level3,parent.type,level6,child.type,3 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level3 
inner join location_master child on  child.id = llh.level6 
where level7 is null and level6 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level3,parent.type,level7,child.type,4 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level3 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;

INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level4,parent.type,level5,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level4 
inner join location_master child on  child.id = llh.level5 
where level6 is null and level5 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level4,parent.type,level6,child.type,2 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level4 
inner join location_master child on  child.id = llh.level6 
where level7 is null and level6 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level4,parent.type,level7,child.type,3 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level4 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;

INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level5,parent.type,level6,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level5 
inner join location_master child on  child.id = llh.level6 
where level7 is null and level6 is not null;


INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level5,parent.type,level7,child.type,2 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level5 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;

INSERT INTO public.location_hierchy_closer_det(
            parent_id, parent_loc_type,child_id, child_loc_type, depth)
select level6,parent.type,level7,child.type,1 from location_level_hierarchy_master llh 
inner join location_master parent on  parent.id = llh.level6 
inner join location_master child on  child.id = llh.level7 
where level7 is not null;



