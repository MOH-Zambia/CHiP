-- Added column screen_context
DO $$ 
    BEGIN
        BEGIN
            ALTER table gvk_call_center_main_category_types
            ADD COLUMN screen_context varchar(300);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column screen_context already exists in gvk_call_center_main_category_types.';
        END;
    END;
$$;

UPDATE gvk_call_center_main_category_types
set screen_context='call center dashboard'
where main_type in ('New Call Added', 'Successful Call', 'Total Call Done', 'Unsuccessful Call', 'Number Of Resource');

--Added screen_context condition.
DELETE FROM query_master where code='gvk_call_center_get_all_data';
INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'gvk_call_center_get_all_data', 'date,screenContext', 'select ccdwa.main_type,STRING_AGG(ccdwa.sub_type,'','' order by ccdwa.sub_type) labels
,STRING_AGG(CAST(ccdwa.cnt as text),'','' order by ccdwa.sub_type) "countData"
,sum(ccdwa.cnt) as total
,mct.query_code as "queryCode"
from gvk_call_center_date_wise_analytics ccdwa
inner join gvk_call_center_main_category_types mct on mct.main_type = ccdwa.main_type and mct.is_active = true
where CAST(call_date AS DATE) = ''#date#'' and mct.screen_context=''#screenContext#''
group by ccdwa.main_type, mct.query_code', true, 'ACTIVE', NULL);
