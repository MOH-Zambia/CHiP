delete from query_master where code='translation_label_check';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'translation_label_check','key','
select * from internationalization_label_master where key = ''#key#''
',true,'ACTIVE');