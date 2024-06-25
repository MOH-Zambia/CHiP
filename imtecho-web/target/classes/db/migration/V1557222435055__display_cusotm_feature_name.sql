DROP TABLE IF EXISTS public.feature_display_name;
CREATE TABLE public.feature_display_name( 
id bigserial NOT NULL,
menu_id bigint,
feature_name text,
display_name text,
CONSTRAINT feature_display_name_pkey PRIMARY KEY (menu_id,feature_name)
);


delete from query_master where code='retrieve_display_name_for_feature';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_display_name_for_feature','feature_name_list',
'select feature_name,display_name from feature_display_name where menu_id = #menu_id# and feature_name in (#feature_name_list#)',
true,'ACTIVE');
