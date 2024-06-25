DELETE FROM QUERY_MASTER WHERE CODE='get_soh_covid_ratio_data';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
1,  current_date , 1,  current_date , 'get_soh_covid_ratio_data', 
 null, 
'select 
round(sum( caad.no_of_test )/65,2)  "Tests per million",
round(cast(sum( case when caad.cad_status = ''DEATH'' and caad.positive = 1 then 1 else 0 end ) as numeric )/65,2)  "Deaths per million",
-- round( sum( case when caad.positive = 1 then 1 else 0 end)/65 ,2)  "Positives per million",
CONCAT ( cast(round(cast((sum(case when caad.cad_status = ''DEATH'' and caad.positive = 1 then 1 else 0 end ) * 100) as numeric) / cast(sum(  case when caad.positive = 1 then 1 else 0 end) as numeric),2) as text),''%'' ) "Deaths to Positives ratio",
CONCAT ( cast(round(cast((sum(case when caad.cad_status = ''DISCHARGE'' and caad.positive = 1 then 1 else 0 end ) * 100) as numeric) /cast(sum(  case when caad.positive = 1 then 1 else 0 end ) as numeric) ,2)   as text ), ''%'') "Recoveries to Positives ratio",
CONCAT (round(sum( case when caad.positive = 1 then 1 else 0 end)/ROUND(CAST((3 * POWER(CBRT(2), (cast(now() as date) - cast(''2020-03-19'' as date)))) AS NUMERIC), 2)*100,2),''%'') "Actual to doubling ratio",
CONCAT (round(sum( case when caad.positive = 1 and caad.postive_date < (now() -interval ''3 day'') then 1 else 0 end)/ROUND(CAST((3 * POWER(CBRT(2), (cast(cast(now() as date) - interval ''3 day'' as date) - cast(''2020-03-19'' as date)))) AS NUMERIC), 2)*100,2),''%'')	"Previous to doubling ratio"
from covid19_admission_analytics_details caad ;', 
null, 
true, 'ACTIVE');
