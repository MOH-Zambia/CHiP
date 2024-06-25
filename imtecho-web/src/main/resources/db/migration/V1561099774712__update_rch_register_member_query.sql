delete from query_master where code = 'get_rch_service_register_detail';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_service_register_detail','location_id,to_date,from_date,limit,offset','
with location_det as(
select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
),dates as(
select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
)
, record_detail as (
select * from rch_member_services,location_det,dates
where service_date between dates.from_date and dates.to_date
and location_id = location_det.loc_id
order by  service_date desc
limit #limit# offset #offset#
)
select 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as "Member Name",
rec.service_type as "Service Type",  to_char(rec.service_date, ''DD/MM/YYYY'') as "Service Date", rec.loc_id as "hiddenlocation", rec.visit_id as "hiddenVisitId", mem.family_id as "Family Id", 
loc.name as "Location"
,concat(usr.first_name,'' '',usr.middle_name,'' '',usr.last_name,'' ('',usr.contact_number,'')'') as "ASHA/ANM Name"
from record_detail rec
inner join imt_member mem on mem.id = rec.member_id 
inner join location_master loc on loc_id = loc.id
inner join um_user usr on usr.id = rec.user_id
',true,'ACTIVE');