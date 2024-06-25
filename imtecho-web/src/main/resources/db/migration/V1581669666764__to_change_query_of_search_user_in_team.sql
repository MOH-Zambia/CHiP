delete from query_master qm where code= 'user_search_for_selectize_by_role';

delete from query_master qm where code= 'team_user_search_for_selectize_by_role';

INSERT INTO public.query_master(
            created_by, created_on, code,  
            params,query, returns_result_set, state)
    VALUES ( 1, current_date, 'team_user_search_for_selectize_by_role','searchString,roleIds,teamTypeId','select um_user.id,
first_name as "firstName", 
last_name as "lastName", 
user_name as "userName", 
um_user.role_id as "roleId",
um_role_master.name as "roleName"
from um_user 
inner join um_role_master on um_role_master.id = um_user.role_id
left join team_member_det tm on tm.user_id = um_user.id and tm.state = ''ACTIVE'' 
left join team_master t on t.id = tm.team_id and t.state = ''ACTIVE''  and t.team_type_id = ''#teamTypeId#''
where um_user.role_id in (#roleIds#) and  
( first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#''  ) 
and t.id is null
limit 50',true,'ACTIVE');
;