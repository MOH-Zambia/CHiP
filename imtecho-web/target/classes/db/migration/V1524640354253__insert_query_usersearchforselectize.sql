ALTER TABLE public.query_master
   ALTER COLUMN code TYPE character varying(255);
INSERT INTO public.query_master(
            created_by, created_on, code,  
            query,params, returns_result_set, state)
    VALUES ( 1, current_date, 'user_search_for_selectize', 'select id,first_name as "firstName", last_name as "lastName", user_name as "userName" from um_user where first_name like ''%#searchString#%'' or last_name like ''%#searchString#%'' or user_name like ''%#searchString#'' limit 50', 
            'searchString,searchString,searchString',true,'ACTIVE');

