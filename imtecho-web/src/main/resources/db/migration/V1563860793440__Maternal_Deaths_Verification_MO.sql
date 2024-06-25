create table rch_member_death_deatil_reason(
	id bigserial primary key,
	death_detail_id  bigint not null,
	death_reason text,
	other_death_reason text,
	user_id bigint not null,
	member_id bigint not null,
	role_id bigint not null,
	created_on timestamp  without time zone default now()
);


--insert into listvalue_field_value_detail (is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
--select true,false,'slamba',now(), value,'maternal_death_verification_mo',0 from listvalue_field_value_detail where field_key ='2018';


insert into listvalue_field_value_detail (is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values
--(true,false,'slamba',now(),'Abortion','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Hypertensive disorders in pregnancy, birth and Puperium','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Obstetric Haemorrhage: APH','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Obstetric Haemorrhage; PPH','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Obstructed Labour','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Prenancy related infection / Sepsis','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Hypertensive Disorder in pregnancy (Pre-eclampsia)','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Hypertensive Disorder in pregnancy (Eclampsia) ','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Surgical Complications','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Complication of Anasthesia','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Complication of Blood Transfusion','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Other Obstetric Complications','maternal_death_verification_mo',0),
--(true,false,'slamba',now(),'Anaemia','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Sickle Cell Anaemia','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Indirect Causes - Non Obstetric Complication: Cardiac Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Liver Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Respiratory Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Renal Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Endocrinal Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Neurolgical Disorders','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Indirect Cause - Non Obstetric Causes: Infections / infestations ','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Unspecified Maternal Death','maternal_death_verification_mo',0),
(true,false,'slamba',now(),'Coincidental / incidental causes (due to external causes) (Accidental injuries, Burns, Suicide)','maternal_death_verification_mo',0);


update listvalue_field_value_detail set is_active=false, is_archive = true where value in ('Accept') and field_key ='maternal_death_verification_mo';

alter table rch_member_death_deatil
add column modified_by bigint,
add column modified_on timestamp without time zone;


update rch_member_death_deatil
set modified_by = created_by,
modified_on = created_on;


CREATE OR REPLACE FUNCTION rch_member_death_deatil_change_function() RETURNS TRIGGER AS '
BEGIN

WITH user_detail as (
	SELECT NEW.death_reason,role_id,id,NEW.member_id,NEW.ID, NEW.other_death_reason FROM um_user where id= NEW.modified_by
)
INSERT INTO rch_member_death_deatil_reason (death_reason,role_id,user_id,member_id,death_detail_id,other_death_reason)
select * from user_detail;

RETURN NULL;
END' LANGUAGE 'plpgsql';


CREATE TRIGGER rch_member_death_deatil_trigger AFTER INSERT OR UPDATE ON rch_member_death_deatil
FOR EACH ROW EXECUTE PROCEDURE rch_member_death_deatil_change_function();


insert into rch_member_death_deatil_reason (death_detail_id, death_reason, other_death_reason,user_id,member_id,role_id)
select detail.id,
case when detail.death_reason= 'null' then null else detail.death_reason end,
detail.other_death_reason,
detail.created_by,
detail.member_id,
uu.role_id from rch_member_death_deatil detail , um_user uu
where  detail.created_by = uu.id;
