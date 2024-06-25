
INSERT INTO menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),true,'Positive Cases Heat Map','techo.manage.symptomaticMembersHeatmap','manage');
-------------------------------------------------
DROP TABLE IF EXISTS public.covid_positive_case_gps_info;

CREATE TABLE public.covid_positive_case_gps_info
(
  member_id integer,
  latitude text,
  longitude text
);
-------------------------------------------------
delete from query_master where code = 'covid_heat_map_data';

INSERT INTO public.query_master(
            created_by, created_on,code, params, 
            query, returns_result_set, state)
    VALUES ( 1,localtimestamp,'covid_heat_map_data', '',
    'select latitude ,longitude  ,count(*) as weight from covid_positive_case_gps_info  group by latitude,longitude',TRUE,'ACTIVE');