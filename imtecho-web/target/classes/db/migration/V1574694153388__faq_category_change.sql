
alter table mytecho_faq_details add column category_id int;

INSERT INTO listvalue_field_master(
field_key, field, is_active, field_type ,form)
VALUES ('my_techo_faq_category_type', 'faqCategoryType', true, 'T','MYTECHO');

insert into listvalue_field_value_detail(
is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
values (true, false,'superadmin',now(), 'Hepatitis', 'my_techo_faq_category_type', 0);

insert into listvalue_field_value_detail(
is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
values (true, false,'superadmin',now(), 'Anemia', 'my_techo_faq_category_type', 0);
 
insert into listvalue_field_value_detail(
is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
values (true, false,'superadmin',now(), 'Polio', 'my_techo_faq_category_type', 0);

delete from query_master where code = 'mytecho_faq_get_category_type';
delete from query_master where code = 'mytecho_get_all_category_type';
delete from query_master where code = 'mytecho_add_faq_category';
delete from query_master where code = 'mytecho_get_faq_categorywise';
delete from query_master where code = 'mytecho_delete_faq_category';
delete from query_master where code = 'mytecho_update_category_value';


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_faq_get_category_type','NULL','
select * from listvalue_field_value_detail where field_key = ''my_techo_faq_category_type'' and is_active = true
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_get_all_category_type','NULL','
select * from listvalue_field_value_detail where field_key = ''my_techo_faq_category_type''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_add_faq_category','last_modified_by,value','
insert into listvalue_field_value_detail(
	is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
select true, false, ''#last_modified_by#'' ,now(), ''#value#'', ''my_techo_faq_category_type'', 0
where not exists (select id from listvalue_field_value_detail where value = ''#value#'')
',false,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_get_faq_categorywise','id','
select id from mytecho_faq_details where category_id = ''#id#''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_delete_faq_category','is_active,is_archive,id','
update listvalue_field_value_detail set last_modified_on = now(), is_active = #is_active# , is_archive = #is_archive# where id = #id# and not exists(
select id from mytecho_faq_details where category = ''#id#'')
',false,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_update_category_value','value,id','
update listvalue_field_value_detail set last_modified_on = now(), value = ''#value#'' where id = #id#
',false,'ACTIVE');
