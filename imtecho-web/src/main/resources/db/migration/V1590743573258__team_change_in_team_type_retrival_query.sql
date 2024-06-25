DELETE FROM QUERY_MASTER WHERE CODE='retriveal_of_team_conf_detail_by_team_type';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f9b82356-2c50-4668-841a-244114af4d39', 80208,  current_date , 80208,  current_date , 'retriveal_of_team_conf_detail_by_team_type',
'teamTypeId',
'SELECT tcd.id as id,
tcd.team_type_id as "teamTypeId",
tcd.min_member as "minMember",
tcd.max_member as "maxMember",
rm.name as "roleName",
rm.id as "roleId"
from team_configuration_det tcd  inner join um_role_master rm on rm.id = tcd.role_id and rm.state =''ACTIVE'' where tcd.team_type_id = #teamTypeId# and tcd.state =''ACTIVE'' ;',
null,
true, 'ACTIVE');