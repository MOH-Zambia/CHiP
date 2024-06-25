DELETE FROM QUERY_MASTER WHERE CODE='check_for_user_exist_or_not_for_same_team_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f049398d-b63c-43e5-8524-c478292d3934', 80314,  current_date , 80314,  current_date , 'check_for_user_exist_or_not_for_same_team_type',
'roleIds,teamTypeId,teamId',
'with available_user as(
select
	tmd.user_id as "userId",
	tm."name"
from
	team_master tm
inner join team_member_det tmd on
	tm.id = tmd.team_id
where
	tmd.role_id in (#roleIds#)
	and tm.team_type_id = #teamTypeId#
	and tm.id not  in (#teamId#)
        and tmd.state = ''ACTIVE''
)
select um_user.id as "userId",
first_name as "firstName",
last_name as "lastName",
user_name as "userName",
available_user.name as "teamName"
from um_user inner join available_user on um_user.id = available_user."userId"',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='check_for_team_name_already_exist_or_not';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c5401d39-edac-4959-bbb5-defd3fd968cf', 80314,  current_date , 80314,  current_date , 'check_for_team_name_already_exist_or_not',
'teamName,id',
'select
	count(*)
from
	team_master
where
	case
		when #id# is null then "name" = #teamName#
		else "name" = #teamName#
		and id not in (#id#)
	end',
null,
true, 'ACTIVE');