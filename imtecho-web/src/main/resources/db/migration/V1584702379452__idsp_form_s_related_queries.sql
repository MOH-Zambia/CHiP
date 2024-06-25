alter table rch_opd_lab_test_details
drop column if exists result_version,
add column result_version varchar(250);


-- opd_member_treatment_history

delete from query_master where code='opd_member_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_member_treatment_history', 'uniqueHealthId,limit,offset', '
    select
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn",
    hid."name" as "healthInfraName",
    (
    	select
    	string_agg(
    		roltm.name, '', ''
		)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    where roltd.opd_member_master_id = romm.id
    ) as "labTests",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''name'', roltm.name,
		    	''category'', (select value from listvalue_field_value_detail where id = roltm.category),
		    	''result'', roltd.result,
		    	''requestedOn'', roltd.request_on,
		    	''formConfigJson'', sfc.form_config_json
			)
		) as text)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
        left join rch_opd_lab_test_master lab_test_master on lab_test_master.id = roltd.lab_test_id
        left join system_form_configuration sfc on sfc.form_id = lab_test_master.form_id and sfc."version" = roltd.result_version
	    where roltd.opd_member_master_id = romm.id
    ) as "labTestResults",
    (
    	select
    	string_agg(
    		lfvd.value, '', ''
		)
	    from listvalue_field_value_detail lfvd
	    inner join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
	    where lfvd.id = roltpr.provisional_id
    ) as "provisionalDiagnosis",
    (
    	select
    	cast(json_agg(
		    json_build_object(
		    	''id'', roed.id,
		    	''memberId'', roed.member_id,
		    	''opdMemberMasterId'', roed.opd_member_master_id,
		    	''edlName'', (select value from listvalue_field_value_detail where id = roed.edl_id),
	    		''frequency'', cast(roed.frequency as text),
	    		''quantityBeforeFood'', cast(roed.quantity_before_food as text),
	    		''quantityAfterFood'', cast(roed.quantity_after_food as text),
	    		''numberOfDays'', cast(roed.number_of_days as text)
			)
		) as text)
	    from rch_opd_edl_details roed
	    where roed.opd_member_master_id = romm.id
    ) as "opdEdlDetails",
    concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "treatmentDoneBy"
    from rch_opd_member_master romm
    inner join imt_member im on romm.member_id = im.id
    inner join um_user uu on romm.created_by = uu.id
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where im.unique_health_id in (''#uniqueHealthId#'')
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    order by romm.service_date desc
    limit #limit# offset #offset#
', true, 'ACTIVE', 'OPD Member Treatment History');


-- for issue

insert into menu_group(group_name, active, group_type)
select 'IDSP', true, 'manage'
where not exists (select id from menu_group where group_name = 'IDSP' and group_type = 'manage');

insert into menu_config(menu_name, menu_type, active, navigation_state, feature_json, group_id)
select 'From S', 'manage', TRUE, 'techo.manage.idspFormS', '{}', id
from menu_group
where group_name = 'IDSP' and group_type = 'manage' and
not exists (select id from menu_config where menu_name = 'From S' and menu_type = 'manage');
