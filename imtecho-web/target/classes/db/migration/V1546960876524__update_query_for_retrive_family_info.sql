DELETE FROM public.query_master
 WHERE code='retrieve_family_and_member_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_family_and_member_info','familyid','with emamtalocation as 
	(select f.family_id,string_agg(lm.name,''> '' order by lhcd.depth desc) as emamtalocationname  from imt_family f 
	inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
	inner join location_master lm on lm.id = lhcd.parent_id where f.family_id = ''#familyid#''
	group by f.family_id)
select f.family_id,f.address1 as address1, f.address2 as address2, f.bpl_flag as bplflag, f.house_number as housenumber, f.is_verified_flag as verifiedflag,
f.migratory_flag as migratoryflag, f.toilet_available_flag as toiletavailableflag, f.vulnerable_flag as vulnerableflag, f.basic_state as familybasicstate,
m.id as memberid, m.unique_health_id as uniquehealthid, m.first_name || '' '' || m.middle_name || '' '' || m.last_name as membername,
m.family_head as familyhead, m.is_pregnant as ispregnant, m.gender as gender, m.mobile_number as mobilenumber, m.basic_state as memberbasicstate,
string_agg(lm.name,''> '' order by lhcd.depth desc) as locationname, emm.emamtalocationname
from imt_family  f
inner join imt_member m on f.family_id = m.family_id 
inner join location_hierchy_closer_det lhcd on f.location_id = lhcd.child_id
inner join location_master lm on lm.id = lhcd.parent_id
left join emamtalocation emm on f.family_id = emm.family_id 
where f.family_id = ''#familyid#''
group by f.address1,f.address2,f.bpl_flag, f.house_number, f.is_verified_flag, 
f.migratory_flag, f.toilet_available_flag, f.vulnerable_flag, f.basic_state, m.id, emm.emamtalocationname, f.family_id',true,'ACTIVE','Retrieve family and members basic info using familyId');