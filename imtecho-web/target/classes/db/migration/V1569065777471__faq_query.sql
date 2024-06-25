delete from query_master where code = 'get_faq_question_list';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_faq_question_list',null,'
select id,title,is_active from mytecho_faq_master;
',true,'ACTIVE');


ALTER TABLE mytecho_faq_master
add column is_active boolean NOT NULL DEFAULT true;

UPDATE menu_config
   SET feature_json='{"canAddMasterQuestion":true, "canManageEnglishQuestion":true, "canManageHindiQuestion":true,
                "canManageGujaratiQuestion":true}'
 WHERE id= 208;

delete from query_master where code = 'faq_retrive_question_by_id';
delete from query_master where code = 'faq_language_list';
delete from query_master where code = 'mytecho_update_faq_status';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'faq_retrive_question_by_id','id','
select * from mytecho_faq_details where faq_master_id  = #id#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'faq_language_list','NULL','
select code as languageCode ,name from internationalization_language_master
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_update_faq_status','status,modifiedBy,id','
UPDATE mytecho_faq_master SET is_active=#status#,modified_by = #modifiedBy#,modified_on = NOW() WHERE id = #id#;
',false,'ACTIVE');
