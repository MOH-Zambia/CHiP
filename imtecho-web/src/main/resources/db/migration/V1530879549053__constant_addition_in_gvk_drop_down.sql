insert into field_value_master  (field_id,field_value,created_on,created_by,modified_on,modified_by)
select id,'I will work from today',localtimestamp,-1,null,null from field_constant_master 
where field_name = 'GVK_WORK_QUESTION_DROPDOWN';