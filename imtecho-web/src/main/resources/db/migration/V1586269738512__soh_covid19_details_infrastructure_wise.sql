delete from query_master qm where qm.code = 'soh_covid19_infrastructure_wise_results';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,now(),1,now(),'soh_covid19_infrastructure_wise_results',NULL,'with det as(
select 
case when hid.name_in_english is null then hid."name" else hid.name_in_english end "Name" ,
sum( caad.no_of_test )"Tests",
sum( case when caad.positive = 1 then 1 else 0 end) "Positive", 
sum(case when caad.cad_status = ''DEATH'' and caad.positive = 1 then 1 else 0 end ) "Death",
sum(case when caad.cad_status = ''DISCHARGE'' and caad.positive = 1 then 1 else 0 end ) "Discharge"
from covid19_admission_analytics_details caad 
left join health_infrastructure_details hid on hid.id = caad.health_infra_id 
group by hid.id
),
total as (
	select cast(''Total'' as varchar) "Name",sum(det."Tests") "Tests",sum(det."Positive") "Positive",sum(det."Death") "Death",sum(det."Discharge") "Discharge" from det 
)
select * from det UNION ALL select * from total;',true,'ACTIVE',NULL,true)
;