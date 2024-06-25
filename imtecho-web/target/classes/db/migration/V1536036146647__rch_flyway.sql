update tr_course_master set module_id  = (select id from field_value_master where field_value = 'FHS')
where course_name = 'FHS Verification Course for FHWs (2 day))';

update tr_course_master set module_id  = (select id from field_value_master where field_value = 'RCH')
where course_name = 'FHW RCH module training';