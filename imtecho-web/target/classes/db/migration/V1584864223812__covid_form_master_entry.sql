delete from form_master where code = 'COVID_LAB_TEST_CASE_HISTORY';

insert into form_master
(created_by,created_on,modified_by,modified_on,code,name,state)
values (1,now(),1,now(),'COVID_LAB_TEST_CASE_HISTORY','Covid Lab Test Case History','ACTIVE');