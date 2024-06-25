-- Added column is_show_location_filter
DO $$ 
    BEGIN
        BEGIN
            ALTER table gvk_call_center_main_category_types
            ADD COLUMN is_show_location_filter boolean;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column is_show_location_filter already exists in gvk_call_center_main_category_types.';
        END;
    END;
$$;
