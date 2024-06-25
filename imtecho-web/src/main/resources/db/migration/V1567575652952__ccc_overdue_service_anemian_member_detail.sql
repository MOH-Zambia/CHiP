delete from query_master where code = 'get_ccc_overdue_service_anemia_member_detail';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_ccc_overdue_service_anemia_member_detail','fhwId','
with fhw_loc_id as( 
	select loc_id from um_user_location
	where user_id = #fhwId# and state = ''ACTIVE''
)
,fhw_child_location_id_list as (
	select child_id from location_hierchy_closer_det,fhw_loc_id where parent_id = fhw_loc_id.loc_id
)	select
        distinct mem.id, rch_mem.member_id, concat(mem.first_name,'' '',mem.last_name) as member_name, mem.unique_health_id , 
	get_location_hierarchy(rch_mem.location_id) as location
from rch_anc_master rch_mem
inner join imt_member mem on rch_mem.member_id = mem.id
where haemoglobin_count < 7
and rch_mem.location_id in (select child_id from fhw_child_location_id_list)
order by id
',true,'ACTIVE');