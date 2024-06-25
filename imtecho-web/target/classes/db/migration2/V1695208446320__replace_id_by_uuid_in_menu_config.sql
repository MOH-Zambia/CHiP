begin;

with report_names as (
	select * from menu_config mc
	where navigation_state like '%techo.report.view({id:%'
	)
,report_ids as (
select id as menu_id,
  unnest(REGEXP_MATCHES(navigation_state, 'id:([a-f0-9-]+)')) as extracted_id,
  navigation_state
  from report_names
)
,report_with_ids as (
select
	menu_id,
    cast(extracted_id as integer) as report_id,
    navigation_state
    from report_ids
    where extracted_id ~ '^[0-9]+$'
)
,report_with_uuids as (
select
	menu_id,
	concat('techo.report.view({id:''',extracted_id,'''})') as nav_state,
    navigation_state
    from report_ids
    where extracted_id ~ '^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$'
)
,concat_uuids as (
	select concat('techo.report.view({id:''',rm.uuid,'''})') as nav_state, ri.menu_id, ri.navigation_state
	from report_master rm
	inner join report_with_ids ri on ri.report_id = rm.id
	where ri.report_id is not null
	)
,correct_record as (
select menu_id, nav_state
from report_with_uuids
union
select menu_id, nav_state
from
concat_uuids
)
update menu_config mc set navigation_state = correct_record.nav_state
from correct_record
where mc.id = correct_record.menu_id;

commit;