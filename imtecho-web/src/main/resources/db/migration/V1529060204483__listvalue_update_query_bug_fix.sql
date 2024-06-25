update query_master set query = 'UPDATE public.listvalue_field_value_detail
   SET is_active=#isActive#, last_modified_on = now()
 WHERE id=#id#;' where code = 'update_active_inactive_listvalues';