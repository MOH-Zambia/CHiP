INSERT INTO menu_config (feature_json,group_id,active,is_dynamic_report,menu_name,navigation_state,sub_group_id,menu_type,only_admin,menu_display_order) VALUES 
('{}',NULL,true,NULL,'Team Type Config','techo.manage.teamtypes',NULL,'admin',NULL,NULL)
;


delete from query_master qm where qm.code = 'team_type_config_retieve_all';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(80208,now(),80208,now(),'team_type_config_retieve_all',NULL,'with team_type_role as (
select ttm.id , cast(json_agg(json_build_object(''id'',urm1.id,''name'',urm1.name ) ) as text) as "selectedManageRoleIds"
from team_type_master ttm 
left join team_type_role_master ttrm on ttrm.team_type_id = ttm.id and ttrm.state=''ACTIVE'' 
left join um_role_master urm1 on urm1.id = ttrm.role_id 
group by ttm.id
),
team_type_conf as (
select ttm.id, 
cast(json_agg(json_build_object(''roleId'',tcd.role_id ,''minMember'',tcd.min_member,''maxMember'' ,tcd.max_member,''role'',json_build_object(''id'',urm.id ,''name'',urm.name ) ) )as text) as "teamConfDetails"
from team_type_master ttm 
left join team_configuration_det tcd on tcd.team_type_id = ttm.id and tcd.state = ''ACTIVE'' 
left join um_role_master urm on urm.id = tcd.role_id group by ttm.id 
)
select ttm.id ,ttm."type" , ttm.state , ttr."selectedManageRoleIds" , ttc."teamConfDetails" 
from team_type_master ttm left join team_type_role ttr on ttr.id = ttm.id left join team_type_conf ttc on ttm.id = ttc.id order by ttm.modified_on desc , ttm.created_on desc ;',true,'ACTIVE','',true)
;

delete from query_master qm where qm.code = 'team_type_mark_team_type_active_or_inactive';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(80208,now(),80208,now(),'team_type_mark_team_type_active_or_inactive','state,id','update team_type_master set state = ''#state#''  , modified_on = now() where id = #id# ;',false,'ACTIVE',NULL,NULL)
;

delete from query_master qm where qm.code = 'role_retrieve_all_excluding_some_role';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(80208,now(),80208,now(),'role_retrieve_all_excluding_some_role','roleIds','select * from um_role_master urm where urm.state = ''ACTIVE'' and ((#roleIds#) is null or urm.id not in (#roleIds#))',true,'ACTIVE',NULL,true)
;

delete from query_master qm where qm.code = 'team_type_config_retrieve_by_id';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(80208,now(),80208,now(),'team_type_config_retrieve_by_id','id','with team_type_role as (
select ttm.id , cast(json_agg(json_build_object(''id'',urm1.id,''name'',urm1.name ) ) as text) as "selectedManageRoleIds"
from team_type_master ttm 
left join team_type_role_master ttrm on ttrm.team_type_id = ttm.id and ttrm.state=''ACTIVE'' 
left join um_role_master urm1 on urm1.id = ttrm.role_id where ttm.id = #id#
group by ttm.id
),
team_type_conf as (
select ttm.id, 
cast(json_agg(json_build_object(''roleId'',tcd.role_id ,''minMember'',tcd.min_member,''maxMember'' ,tcd.max_member,''role'',json_build_object(''id'',urm.id ,''name'',urm.name ) ) )as text) as "teamConfDetails"
from team_type_master ttm 
left join team_configuration_det tcd on tcd.team_type_id = ttm.id and tcd.state = ''ACTIVE'' 
left join um_role_master urm on urm.id = tcd.role_id 
where ttm.id = #id# group by ttm.id 
)
select ttm.id ,ttm."type" ,ttm.state , ttr."selectedManageRoleIds" , ttc."teamConfDetails" 
from team_type_master ttm left join team_type_role ttr on ttr.id = ttm.id left join team_type_conf ttc on ttm.id = ttc.id where ttm.id = #id#;',true,'ACTIVE',NULL,true)
;