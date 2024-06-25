CREATE OR REPLACE FUNCTION public.retrieve_user_details(
	location_id bigint, user_role_id bigint, total_user int default null)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$

        BEGIN
		return (with users as(
	select distinct
			concat(
				uu.first_name,
				' ',
				uu.last_name,
				' (',
				uu.user_name,
				case when uu.contact_number is not null then concat(' : ',uu.contact_number) end,
				')'
			)
		as users
	from um_user_location uul
		inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
		and lhcd.parent_id = location_id
		and uul.state = 'ACTIVE'
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = 'ACTIVE'
		and uu.role_id = user_role_id
	limit total_user
)
select string_agg(users, ',')
from users);

        END;
$BODY$;