delete from query_master where code='retrieve_opd_lab_tests_and_category_by_health_infrastructure';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_opd_lab_tests_and_category_by_health_infrastructure','healthInfrastructureId,healthInfrastructureType,type','
with lab_test_table as( select
	rch_opd_lab_test_master.id as "labTestId", rch_opd_lab_test_master.name as "labTestName", rch_opd_lab_test_master.category
from
	health_infrastructure_lab_test_mapping
inner join rch_opd_lab_test_master on
	health_infrastructure_lab_test_mapping.ref_id = rch_opd_lab_test_master.id
where
	case
		when ( select
			count(*)
		from
			health_infrastructure_lab_test_mapping
		where
			health_infra_id = #healthInfrastructureId# )>0 then health_infra_id = #healthInfrastructureId#
		else health_infra_type = #healthInfrastructureType#
	end
	and permission_type = ''#type#''
	and rch_opd_lab_test_master.is_active = true) select
	lab_test_table."labTestId",
	lab_test_table."labTestName",
	cat.id as "categoryId",
	cat.value as "categoryName"
from
	lab_test_table
inner join listvalue_field_value_detail cat on
	lab_test_table.category = cat.id
',true,'ACTIVE');