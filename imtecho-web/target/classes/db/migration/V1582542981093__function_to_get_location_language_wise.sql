CREATE OR REPLACE FUNCTION public.get_location_hierarchy_language_wise(location_id bigint, language varchar(30))
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE 
	hierarchy text;
	
        BEGIN	
		return (select string_agg(case when ( language = 'EN' and (l2.english_name is not null)) then l2.english_name else l2.name end,' > ' order by lhcd.depth desc) as location_id
				from location_master l1 
				inner join location_hierchy_closer_det lhcd on lhcd.child_id = l1.id
				inner join location_master l2 on l2.id = lhcd.parent_id
				where l1.id = location_id);
		
        END;

$function$
;

delete from query_master where code = 'team_user_search_for_selectize_by_role';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state)
    VALUES (1, localtimestamp, 'team_user_search_for_selectize_by_role', 'searchString,roleIds', 
        'with exclude_user as(
	select tmd.user_id from team_master tm inner join team_member_det tmd on tm.id = tmd.team_id and tmd.state =''ACTIVE'' and tm.state = ''ACTIVE'' where tmd.role_id in(#roleIds#)
)
select um_user.id,
first_name as "firstName", 
last_name as "lastName", 
user_name as "userName", 
um_user.role_id as "roleId",
um_role_master.name as "roleName"
from um_user 
inner join um_role_master on um_role_master.id = um_user.role_id
where um_user.role_id in (#roleIds#) and  um_user.id not in (select * from exclude_user) and
( first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#''  ) 
limit 50', 
        true, 'ACTIVE');