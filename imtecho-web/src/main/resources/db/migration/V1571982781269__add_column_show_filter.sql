-- Added column is_show_filter
DO $$ 
    BEGIN
        BEGIN
            ALTER table gvk_call_center_main_category_types
            ADD COLUMN is_show_filter boolean;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_show_filter already exists in gvk_call_center_main_category_types.';
        END;
    END;
$$;

-- Added column category_order
DO $$ 
    BEGIN
        BEGIN
            ALTER table gvk_call_center_main_category_types
            ADD COLUMN category_order integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column category_order already exists in gvk_call_center_main_category_types.';
        END;
    END;
$$;

UPDATE gvk_call_center_main_category_types
set is_show_filter=true
where main_type in ('New Call Added', 'Successful Call', 'Total Call Done', 'Unsuccessful Call', 'Number Of Resource');

--Added is_show_filter, category_order condition.
DELETE FROM query_master where code='gvk_call_center_get_all_data';
INSERT INTO public.query_master
(id, created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description)
VALUES(861, 1, '2019-10-25 11:28:22.168', 4108323, '2019-10-25 15:43:02.432', 'gvk_call_center_get_all_data', 'date,screenContext', 'with call_center_data as (
select ccdwa.main_type,ccdwa.sub_type,sum(ccdwa.cnt) as cnt,mct.query_code,mct.is_show_filter, mct.category_order
from gvk_call_center_date_wise_analytics ccdwa
inner join gvk_call_center_main_category_types mct on mct.main_type = ccdwa.main_type and mct.is_active = true
where CAST(call_date AS DATE) = ''#date#'' and mct.screen_context=''#screenContext#''
group by ccdwa.main_type,sub_type,mct.query_code,is_show_filter,category_order 
)
select ccdwa.main_type,STRING_AGG(ccdwa.sub_type,'','' order by ccdwa.sub_type) labels
,STRING_AGG(CAST(ccdwa.cnt as text),'','' order by ccdwa.sub_type) "countData"
,sum(ccdwa.cnt) as total
,query_code as "queryCode"
,is_show_filter as "isShowFilter"
from call_center_data ccdwa
group by main_type,query_code,is_show_filter,category_order
order by category_order', true, 'ACTIVE', NULL);

-- Create GVK Successfule Call Dashboard Menu.
delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'GVK Successful Call Dashboard');

delete from menu_config where id in (select id from menu_config where menu_name = 'GVK Successful Call Dashboard');

INSERT INTO  menu_config(
               active, menu_name, navigation_state, menu_type, group_id)
       VALUES('TRUE','GVK Successful Call Dashboard', 'techo.dashboard.gvksuccessfulcalldashboard', 'manage', 7);
