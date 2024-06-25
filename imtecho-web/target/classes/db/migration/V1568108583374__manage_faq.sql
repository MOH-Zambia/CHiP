INSERT INTO public.internationalization_language_master(
            code, country, name, character_encoding, is_left_to_right, is_active, 
            is_archive, created_by, created_on)
    select 'HI','IN', 'Hindi', 'UTF-8', TRUE, TRUE, 
            FALSE, 'Administrator', CURRENT_TIMESTAMP;


DROP TABLE IF EXISTS mytecho_faq_details;
DROP TABLE IF EXISTS mytecho_faq_master;


CREATE TABLE mytecho_faq_master
(
  id bigserial NOT NULL,
  title text NOT NULL UNIQUE,
  created_on timestamp without time zone NOT NULL,
  created_by bigint NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT mytecho_faq_master_id PRIMARY KEY (id)
);


CREATE TABLE mytecho_faq_details
(
  id bigserial NOT NULL,
  question text NOT NULL,
  content text NOT NULL,
  tags character varying(255),
  category character varying(255),
  language_code character varying(50),
  faq_master_id bigint NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT mytecho_managefaq_pkey PRIMARY KEY (id),
  CONSTRAINT faq_foreign_key FOREIGN KEY (faq_master_id)
      REFERENCES mytecho_faq_master (id)
);

delete from query_master where code='mytecho_faq_add';
delete from query_master where code='update_mytecho_faq_by_id';
delete from query_master where code='update_mytecho_faq_details';
delete from query_master where code='delete_faq_by_id';
delete from query_master where code='get_faq_list_by_language';
delete from query_master where code='get_internationalization_language';
delete from query_master where code='mytecho_search_faq';
delete from query_master where code='mytecho_search_doctor_directory';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_faq_add','title,created_by,question,content,tags,category,language_code','
INSERT INTO public.mytecho_faq_master(title, created_on, created_by) select ''#title#'', NOW(),#created_by# 
WHERE NOT EXISTS(SELECT id FROM mytecho_faq_master t2 WHERE t2.title = ''#title#'');

INSERT INTO public.mytecho_faq_details(created_by, created_on,  question, content, tags, category, language_code, faq_master_id) 
select  #created_by#, NOW(), ''#question#'', ''#content#'', ''#tags#'', ''#category#'', ''#language_code#'', 
 ms.id from mytecho_faq_master as ms where ms.title = ''#title#'';
',false,'ACTIVE');


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'update_mytecho_faq_by_id','faqid','
SELECT * from mytecho_faq_details where id =  #faqid#
',true,'ACTIVE');


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'update_mytecho_faq_details','modified_by,modified_on,question,content,tags,language_code,id','
UPDATE mytecho_faq_details 
SET modified_by= #modified_by#, modified_on=''#modified_on#'',question=''#question#'', content=''#content#'', tags=''#tags#'', language_code=''#language_code#'' WHERE id=#id# ;
',false,'ACTIVE');


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'delete_faq_by_id','faqId','
DELETE FROM mytecho_faq_details WHERE id = #faqId#
',false,'ACTIVE');


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_faq_list_by_language','language','
select details.* from mytecho_faq_details as details LEFT JOIN mytecho_faq_master as master on details.faq_master_id = master.id where language_code = ''#language#'';
',true,'ACTIVE');


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_internationalization_language','NULL','
select * from internationalization_language_master;
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_search_faq','searchText,language_code','
select distinct result.* from mytecho_faq_details serch
inner join mytecho_faq_details result on serch.faq_master_id = result.faq_master_id
where (
(serch.tags ILIKE ''%#searchText#%'') 
or (serch.category ILIKE ''%#searchText#%'') 
or (serch.question ILIKE ''%#searchText#%'')) 
and result.language_code = ''#language_code#''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'mytecho_search_doctor_directory','latitude,longitude,limit,pageno','
WITH distanceData AS (
SELECT *, (6371 * acos(cos(radians(#latitude#) ) * cos(radians(latitude)) * 
cos( radians(longitude) - radians(#longitude#) ) + sin( radians(#latitude#)) * 
sin( radians(latitude)))) AS distance FROM mytecho_doctor_directory 
)
select * from distanceData ORDER BY distance LIMIT #limit# OFFSET ( #limit# *( #pageno# - 1 ))
',true,'ACTIVE');



    