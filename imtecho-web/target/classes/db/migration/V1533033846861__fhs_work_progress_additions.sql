CREATE TABLE if not exists verfied_families_village_wise_records
(
    loc_id bigint,
    created_on date,
    total bigint,
    verified bigint
);

insert into query_master(created_by, created_on, modified_by, modified_on, code, params, query,returns_result_set,state)
values (1027,localtimestamp,null,null,'fhs_verifification_percentage','locationId,loggedInUserId',
'select to_char(vf.created_on,''dd-mm-yyyy'') as created_on,round((sum(vf.verified)*100)/sum(vf.total),1) as percentage from 
location_hierchy_closer_det lhcd inner join  verfied_families_village_wise_records vf
on lhcd.child_id = vf.loc_id
where 
((#locationId# is not null and parent_id = #locationId#) or
(#locationId# is null and parent_id in (select loc_id from um_user_location where user_id = #loggedInUserId# and state = ''ACTIVE'')))
group by vf.created_on',
true,'ACTIVE');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('FHS Work Progress','manage',TRUE,'techo.manage.fhsworkbargraph','{}');