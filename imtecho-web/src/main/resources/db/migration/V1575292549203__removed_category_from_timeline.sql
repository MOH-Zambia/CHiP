DELETE FROM query_master where code='mytecho_create_or_update_timeline_config';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_create_or_update_timeline_config', 'component_type,expier_after_number_of_days,is_active,category_id,timeline_theme,name,id,schedule_after_number_of_days,base_date_type', 'INSERT INTO public.mytecho_timeline_config_det(
            id, name, component_type, is_any_condition, base_date_type, schedule_after_number_of_days, 
            expier_after_number_of_days, timeline_theme, is_important, is_active, category_id)
VALUES (case when ''#id#'' = ''null'' then nextval(''mytecho_timeline_config_det_id_seq'') else #id# end,''#name#''
,''#component_type#'', false, ''#base_date_type#'', ''#schedule_after_number_of_days#''
,cast (case when ''#expier_after_number_of_days#'' = ''null'' then null else ''#expier_after_number_of_days#'' end as smallint)
, ''#timeline_theme#'', true, true, cast (case when  ''#category_id#''= ''null'' then null else  ''#category_id#'' end as smallint))
on conflict (id)
DO UPDATE
set name = ''#name#'',component_type=''#component_type#'',is_any_condition=false,base_date_type = ''#base_date_type#''
,schedule_after_number_of_days = ''#schedule_after_number_of_days#'' 
,expier_after_number_of_days =  cast (case when ''#expier_after_number_of_days#'' = ''null'' then null else ''#expier_after_number_of_days#'' end as smallint)
,timeline_theme = ''#timeline_theme#''
,is_important = true
,is_active = ''#is_active#''
,category_id = cast (case when  ''#category_id#''= ''null'' then null else  ''#category_id#'' end as smallint)
returning id;', true, 'ACTIVE', NULL);