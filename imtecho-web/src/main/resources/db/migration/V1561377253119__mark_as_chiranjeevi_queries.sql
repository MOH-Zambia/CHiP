delete from query_master where code='mark_as_chiranjeevi_list';
delete from query_master where code='mark_as_chiranjeevi';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mark_as_chiranjeevi_list','locationId,limit,offSet','
with ids as (
	select id,member_id,date_of_delivery from rch_wpd_mother_master where type_of_hospital = 1013
)
select imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
concat(um_user.first_name,'' '',um_user.last_name,'' ('',um_user.contact_number,'')'') as "ashaDetail",
ids.date_of_delivery as "deliveryDate",
ids.id as "wpdId",
listvalue_field_value_detail.value as "caste",
imt_family.bpl_flag as "bplFlag"
from imt_member
inner join ids on imt_member.id = ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
left join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
inner join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
and (imt_family.caste = ''625'' or imt_family.bpl_flag)
order by ids.date_of_delivery desc
limit #limit# offset #offSet#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mark_as_chiranjeevi','wpdId','
update rch_wpd_mother_master
set type_of_hospital = 892
where id = #wpdId#
',false,'ACTIVE');

delete from menu_config where menu_name = 'Temp - Chiranjeevi Deliveries';

insert into menu_config 
(active,menu_name,navigation_state,menu_type) 
values (true,'Temp - Chiranjeevi Deliveries','techo.manage.markchiranjeevi','manage');