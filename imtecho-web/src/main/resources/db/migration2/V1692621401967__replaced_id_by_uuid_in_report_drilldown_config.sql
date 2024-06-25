begin;

with report_config as (
	select id as report_id, cast(config_json as jsonb) as config from report_master
	where active = true
), containers as (
	select report_id, cast(config ->> 'containers' as jsonb) as containers from report_config
), table_fields as (
	select report_id, cast(containers ->> 'tableFieldContainer' as jsonb) as tableField from containers
where containers ->> 'tableFieldContainer' is not null and containers ->> 'tableFieldContainer' != '[]'
), field_rows as (
	select report_id, jsonb_array_elements(tableField) as fields from table_fields
), custom_states as (
	select row_number() over() as sr_no, report_id, fields, cast(fields ->> 'customState' as text) as cstate from field_rows
), state_ids as (
	select sr_no, report_id, cstate
    from custom_states where fields ->> 'customState' is not null and fields ->> 'customState' != ''
	and fields ->> 'customState' like ',%'
), fixed_state as (
	select sr_no, report_id, concat(substr(cstate, 2, strpos(cstate, '$",techo.report')), '}})') as fixed_state
	from state_ids
), all_states as (
	select cs.sr_no, cs.report_id, case when fs.fixed_state is not null then fs.fixed_state else cs.cstate end as final_state
	from custom_states cs left join fixed_state fs
	on cs.report_id = fs.report_id and cs.sr_no = fs.sr_no
	where cs.report_id in (select report_id from fixed_state)
), final_rows as (
	select cs.sr_no, cs.report_id, jsonb_set(fields, '{customState}', to_jsonb(final_state)) as final_state
	from custom_states cs inner join all_states als on cs.sr_no = als.sr_no
), final_arrays as (
	select report_id, to_jsonb(array_agg(final_state)) as final_array from final_rows group by report_id
), configs as (
	select rc.report_id, cast(jsonb_set(config, '{containers, tableFieldContainer}', to_jsonb(fr.final_array)) as text) as final_config
	from report_config rc inner join final_arrays fr on rc.report_id = fr.report_id
	where rc.report_id in (select report_id from table_fields)
)
update report_master ri set config_json = final_config
from configs
where ri.id = configs.report_id;

commit;

begin;

with report_config as (
	select id as report_id, cast(config_json as jsonb) as config from report_master
	where active = true
), containers as (
	select report_id, cast(config ->> 'containers' as jsonb) as containers from report_config
), table_fields as (
	select report_id, cast(containers ->> 'tableFieldContainer' as jsonb) as tableField from containers
where containers ->> 'tableFieldContainer' is not null and containers ->> 'tableFieldContainer' != '[]'
), field_rows as (
	select report_id, jsonb_array_elements(tableField) as fields from table_fields
), custom_states as (
	select row_number() over() as sr_no, report_id, fields, cast(fields ->> 'customState' as text) as cstate from field_rows
), state_ids as (
	select sr_no, report_id, cast(split_part(substr(cstate, 25), ',', 1) as int) as state_id, cstate
    from custom_states where fields ->> 'customState' is not null and fields ->> 'customState' != ''
), new_uuid as (
	select si.sr_no, si.report_id, si.state_id, uuid as new_id, si.cstate
	from state_ids si inner join report_master on si.state_id = id
), new_state as (
	select si.sr_no, nu.report_id, concat(substr(si.cstate, 1, 24), '"', cast(nu.new_id as text), '"', substr(si.cstate, strpos(si.cstate, ','))) as new_state, si.cstate as old_state
    from new_uuid nu inner join state_ids si on nu.sr_no = si.sr_no
), final_rows as (
	select cs.sr_no, cs.report_id, jsonb_set(fields, '{customState}', to_jsonb(new_state)) as final_state
	from custom_states cs inner join new_state ns on cs.sr_no = ns.sr_no
	union
	select cs.sr_no, cs.report_id, cs.fields from custom_states cs where cs.sr_no not in (select sr_no from new_state)
), final_arrays as (
	select report_id, to_jsonb(array_agg(final_state)) as final_array from final_rows group by report_id
), configs as (
	select rc.report_id, cast(jsonb_set(config, '{containers, tableFieldContainer}', to_jsonb(fr.final_array)) as text) as final_config
	from report_config rc inner join final_arrays fr on rc.report_id = fr.report_id
	where rc.report_id in (select report_id from table_fields)
)
update report_master ri set config_json = final_config
from configs
where ri.id = configs.report_id;

commit;