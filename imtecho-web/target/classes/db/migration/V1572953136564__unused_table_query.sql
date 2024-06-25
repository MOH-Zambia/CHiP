/*member update trigger*/
-- Function: public.update_basic_state_member_trigger()

-- DROP FUNCTION public.update_basic_state_member_trigger();

CREATE OR REPLACE FUNCTION public.update_basic_state_member_trigger()
  RETURNS trigger AS
$BODY$
begin
update imt_family set modified_on = now() where family_id = new.family_id and modified_on < now() - interval '1 minute';

if (TG_OP = 'UPDATE' and NEW.family_id != OLD.family_id) then 
update imt_family set modified_on = now() where family_id = old.family_id and (modified_on is null or modified_on < now() - interval '1 minute');
end if;

if (TG_OP = 'INSERT') then
	with rowss as(
		insert into imt_member_state_detail (member_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on)
		values (new.id, null, new.state, null, new.modified_by, now(), new.modified_by, now())
		returning id
	)
	select id into new.current_state from rowss;
end if;
if (TG_OP != 'INSERT' and new.state != old.state) then 
	with rowss as(
		insert into imt_member_state_detail (member_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on, comment)
		values (new.id, old.state, new.state, old.current_state, new.modified_by, now(), new.modified_by, now(),
                case 
                    when new.remarks is not null and old.remarks is null then new.remarks
                    when new.remarks is not null and old.remarks is not null and new.remarks <> old.remarks then new.remarks
                    else null
                end)
		returning id
	)
	select id into new.current_state from rowss;
end if;




if (TG_OP = 'INSERT' or new.state != old.state) and new.state in (
		'com.argusoft.imtecho.member.state.verified',
		'com.argusoft.imtecho.member.state.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.fhw.reverified'
		,'com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified',
		'com.argusoft.imtecho.member.state.temporary',
		'com.argusoft.imtecho.member.state.dead.fhsr.reverification',
		'com.argusoft.imtecho.member.state.dead.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.fhsr.reverification')  then

	insert into rch_member_data_sync_pending(member_id,created_on,is_synced)
	values(NEW.id,now(),false);
	
	if(new.state='com.argusoft.imtecho.member.state.temporary' and NEW.is_pregnant = true and NEW.cur_preg_reg_det_id is null) then
	drop table if exists member_details;
	CREATE temp TABLE member_details(
			family_id bigint,
			member_id bigint,
			family_id_text text,
			unique_health_id text,
			location_id bigint,
			area_id bigint,
			cur_preg_reg_det_id bigint,
			cur_preg_reg_date date,
			lmp date,
			is_pregnant boolean,
			dob date,
			imtecho_lmp date,
			anc_visit_dates text,
			immunisation_given text,
			gender text,
			marital_status text,
			sync_status text,
			mother_id bigint,
			emamta_health_id text,
			family_state text,
			last_delivery_date DATE,
			preg_reg_det_id bigint,
			is_lmp_followup_done boolean,
			is_wpd_entry_done boolean
		);

insert into member_details (family_id ,	member_id,family_id_text,unique_health_id,location_id,area_id,is_pregnant,dob,imtecho_lmp,lmp,gender,marital_status,emamta_health_id
,family_state,preg_reg_det_id)
select distinct imt_family.id as family_id,NEW.id as member_id,imt_family.family_id,case when NEW.state in ('com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified') and NEW.emamta_health_id is not null then UPPER(NEW.emamta_health_id) 
		else NEW.unique_health_id end as unique_health_id 
,imt_family.location_id as location_id,case when imt_family.area_id is null then imt_family.location_id else cast(imt_family.area_id as bigint) end ,
(case when NEW.is_pregnant = true then true else false end),NEW.dob,NEW.lmp,NEW.lmp,NEW.gender,NEW.marital_status
,UPPER(NEW.emamta_health_id),imt_family.state,NEW.cur_preg_reg_det_id
from imt_family 
where imt_family.family_id = NEW.family_id;


insert into rch_member_service_data_sync_detail (member_id,created_on,original_lmp,is_pregnant_in_imtecho,imtecho_dob,location_id)
select member_id,now(),imtecho_lmp,is_pregnant,dob,location_id from member_details ;


update member_details set lmp = now() - interval '28 days' 
where member_details.is_pregnant = true and member_details.cur_preg_reg_det_id is null and lmp is null;

INSERT INTO public.rch_pregnancy_registration_det(
             member_id,family_id,location_id,current_location_id,lmp_date, edd, reg_date, state, created_on, 
            created_by, modified_on, modified_by)
select member_details.member_id,member_details.family_id,member_details.area_id,member_details.area_id,member_details.lmp,member_details.lmp + interval '281 day',now(),'PREGNANT' ,now(),-1,now(),-1 
from member_details
where member_details.is_pregnant = true and member_details.cur_preg_reg_det_id is null;


update member_details SET is_pregnant = true 
--,lmp = case when member_details.lmp is null then rch_pregnancy_registration_det.lmp_date else member_details.lmp end
,cur_preg_reg_det_id = rch_pregnancy_registration_det.id
,cur_preg_reg_date = rch_pregnancy_registration_det.reg_date
from rch_pregnancy_registration_det where 
 member_details.is_wpd_entry_done is null and member_details.preg_reg_det_id is null
and rch_pregnancy_registration_det.member_id = member_details.member_id 
and rch_pregnancy_registration_det.state = 'PREGNANT'
and rch_pregnancy_registration_det.lmp_date > now() - interval '350 days';


-- anc notification
INSERT INTO public.techo_notification_master(
            notification_type_id, notification_code, location_id, location_hierchy_id, 
            family_id, member_id, schedule_date,
            action_by, state, created_by, created_on, modified_by, modified_on, 
            ref_code)
select 2,case when date_part('day',age(lmp,anc_date)) between 0 and 91 then '1' 
when date_part('day',age(lmp,anc_date)) between 92 and 189 then '2'
when date_part('day',age(lmp,anc_date)) between 190 and 245 then '3'
when date_part('day',age(lmp,anc_date)) > 246 then '4' end
,location_id,-1,family_id,member_id,anc_date,-1,'DONE_ON_EMAMTA',-1,now(),'-1',now(),cur_preg_reg_det_id
from (select member_details.family_id as family_id,member_details.member_id as member_id,member_details.cur_preg_reg_det_id,member_details.location_id
,member_details.lmp,max(rch_anc_master.created_on) as anc_date
from member_details
inner join rch_anc_master on rch_anc_master.pregnancy_reg_det_id = member_details.cur_preg_reg_det_id and member_details.preg_reg_det_id is null
where member_details.cur_preg_reg_det_id is not null
group by member_details.family_id ,member_details.member_id ,member_details.cur_preg_reg_det_id,member_details.location_id,member_details.lmp) as t;

-- Anc notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select '5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a' -- anc_config_id
,member_details.lmp,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',member_details.cur_preg_reg_det_id
 from member_details
where member_details.cur_preg_reg_det_id is not null and member_details.preg_reg_det_id is null;


-- WPD notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select 'faedb8e7-3e46-40a2-a9ac-ea7d5de944fa' -- wpd_config_id
,member_details.lmp,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',member_details.cur_preg_reg_det_id
 from member_details
where member_details.cur_preg_reg_det_id is not null and member_details.preg_reg_det_id is null;


-- PNC notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select '9b1a331b-fac5-48f0-908e-ef545e0b0c52' -- pnc_config_id
,rch_wpd_mother_master.date_of_delivery,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',rch_wpd_mother_master.pregnancy_reg_det_id
 from member_details
 inner join rch_wpd_mother_master on rch_wpd_mother_master.member_id = member_details.member_id and rch_wpd_mother_master.date_of_delivery > now() - interval '60 day';


NEW.cur_preg_reg_det_id = (select cur_preg_reg_det_id from member_details);
NEW.cur_preg_reg_date = (select cur_preg_reg_date from member_details);

drop table member_details;
	
	elseif (NEW.is_pregnant = true and NEW.cur_preg_reg_det_id is null) then

		NEW.is_pregnant = false;

	end if;
end if;
    
if TG_OP != 'INSERT' and new.current_state is null and old.current_state is not null then
	new.current_state = old.current_state;
end if;

if TG_OP != 'INSERT' and new.basic_state is null and old.basic_state is not null then 
	new.basic_state = old.basic_state;
end if;

case when TG_OP != 'INSERT' and new.state = old.state
	then return new;

	when new.state in ('com.argusoft.imtecho.member.state.unverified') 
	then new.basic_state := 'UNVERIFIED';

	when new.state in ('com.argusoft.imtecho.member.state.archived.fhsr.verified',
		'com.argusoft.imtecho.member.state.archived.fhw.reverified',
		'com.argusoft.imtecho.member.state.archived',
		'com.argusoft.imtecho.member.state.archived.mo.verified') 
	then new.basic_state := 'ARCHIVED';

	when new.state in ('com.argusoft.imtecho.member.state.verified',
		'com.argusoft.imtecho.member.state.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.fhw.reverified') 
	then new.basic_state := 'VERIFIED';

	when new.state in ('com.argusoft.imtecho.member.state.dead.fhsr.reverification',
		'com.argusoft.imtecho.member.state.dead.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.fhsr.reverification') 
	then new.basic_state := 'REVERIFICATION';

	when new.state in ('com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified') 
	then new.basic_state := 'NEW';

	when new.state in ('com.argusoft.imtecho.member.state.dead.fhw.reverified',
		'com.argusoft.imtecho.member.state.dead.mo.verified',
		'com.argusoft.imtecho.member.state.dead',
		'com.argusoft.imtecho.member.state.dead.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.dead.fhsr.verified') 
	then new.basic_state := 'DEAD';

	when new.state in ('com.argusoft.imtecho.member.state.orphan') 
	then new.basic_state := 'ORPHAN';
	
	when new.state in ('com.argusoft.imtecho.member.state.temporary') 
	then new.basic_state := 'TEMPORARY';
        
	when new.state in ('com.argusoft.imtecho.member.state.migrated') 
	then new.basic_state := 'MIGRATED';

    else
		new.basic_state := 'UNHANDLED';
end case;
    return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.update_basic_state_member_trigger()
  OWNER TO postgres;
  
  
/*um_user trigger*/
-- Function: public.um_user_insert_trigger_func()

-- DROP FUNCTION public.um_user_insert_trigger_func();

CREATE OR REPLACE FUNCTION public.um_user_insert_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
    update um_user set activation_date = now() where id=NEW.ID;

	INSERT INTO public.um_user_activation_status(
            user_id, activation_date, activate_by)
	VALUES (NEW.id, now(), NEW.created_by);

	if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
	   (select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
	   'DROP EXTENSION IF EXISTS dblink;
	    CREATE EXTENSION dblink; 

	    INSERT INTO um_user(
            id, created_by, created_on, first_name, 
            gender, last_name, middle_name, password, prefered_language, 
            role_id, state, user_name, search_text, server_type,activation_date)
	       Values ('|| quote_nullable(NEW.id) || '
			, '||quote_nullable(NEW.created_by) ||'
			, '||quote_nullable(NEW.created_on) ||'
			, '||quote_nullable(NEW.first_name) ||'
			, '||quote_nullable(NEW.gender) ||'
			, '||quote_nullable(NEW.last_name) ||'
			, '||quote_nullable(NEW.middle_name) ||'
			, '||quote_nullable(NEW.password) ||'
			, '||quote_nullable(NEW.prefered_language) ||'
			, '||quote_nullable(NEW.role_id) ||'
			, '||quote_nullable(NEW.state) ||'
			, '||quote_nullable(NEW.user_name || '_t') ||'
			, '||quote_nullable(NEW.search_text) ||'
			, '||quote_nullable(NEW.server_type) ||'
			, '||quote_nullable(NEW.activation_date) ||');'
	);
	end if;
 
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_user_insert_trigger_func()
  OWNER TO postgres;
  
/*um_user update trigger*/
-- Function: public.um_user_update_trigger_func()

-- DROP FUNCTION public.um_user_update_trigger_func();

CREATE OR REPLACE FUNCTION public.um_user_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN

	
	IF NEW.state != OLD.state then
		if NEW.state = 'ACTIVE' then
		
			INSERT INTO public.um_user_activation_status(
			user_id, activation_date, activate_by)
			VALUES (NEW.id, now(), NEW.modified_by);
			update um_user set activation_date = now() where id=NEW.ID;

		else

			UPDATE um_user_activation_status SET deactivation_date = now(),deactivate_by = NEW.modified_by where user_id = NEW.id and deactivation_date is null;
	
		end if;
	END if;
	
	if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_user SET created_by='||quote_nullable(NEW.created_by)||', created_on='||quote_nullable(NEW.created_on)||', 
			modified_by='||quote_nullable(NEW.modified_by)||', modified_on='||quote_nullable(NEW.modified_on)||', 
			aadhar_number='||quote_nullable(NEW.aadhar_number)||', address='||quote_nullable(NEW.address)||', 
			code='||quote_nullable(NEW.code)||', contact_number='||quote_nullable(NEW.contact_number)||', 
			date_of_birth='||quote_nullable(NEW.date_of_birth)||', email_id='||quote_nullable(NEW.email_id)||', 
			first_name='||quote_nullable(NEW.first_name)||', gender='||quote_nullable(NEW.gender)||', 
			last_name='||quote_nullable(NEW.last_name)||', middle_name='||quote_nullable(NEW.middle_name)||', 
			password='||quote_nullable(NEW.password)||', prefered_language='||quote_nullable(NEW.prefered_language)||', 
			role_id='||quote_nullable(NEW.role_id)||', state='||quote_nullable(NEW.state)||', 
			user_name='||quote_nullable(NEW.user_name || '_t')||', search_text='||quote_nullable(NEW.search_text)||', 
			server_type='||quote_nullable(NEW.server_type)||', title='||quote_nullable(NEW.title)||', 
			imei_number='||quote_nullable(NEW.imei_number)||', techo_phone_number='||quote_nullable(NEW.techo_phone_number)||'
			WHERE id='||quote_nullable(NEW.id)||';'
	   
	); 
	end if;
	
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_user_update_trigger_func()
  OWNER TO postgres;

/*Insert role trigger*/
-- Function: public.um_role_master_insert_trigger_func()

-- DROP FUNCTION public.um_role_master_insert_trigger_func();

CREATE OR REPLACE FUNCTION public.um_role_master_insert_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	
if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
                  'INSERT INTO public.um_role_master(
		created_by, created_on, modified_by, modified_on, code, description, 
		name, state, max_position, is_email_mandatory, is_contact_num_mandatory, 
		is_aadhar_num_mandatory)
		VALUES ('|| quote_nullable(NEW.created_by) || ',
			'|| quote_nullable(NEW.created_on) || ',
			'|| quote_nullable(NEW.modified_by) || ',
			'|| quote_nullable(NEW.modified_on) || ',
			'|| quote_nullable(NEW.code) || ',
			'|| quote_nullable(NEW.description) || ',
			'|| quote_nullable(NEW.name) || ',
			'|| quote_nullable(NEW.state) || ',
			'|| quote_nullable(NEW.max_position) || ',
			'|| quote_nullable(NEW.is_email_mandatory) || ',
			'|| quote_nullable(NEW.is_contact_num_mandatory) || ',
			'|| quote_nullable(NEW.is_aadhar_num_mandatory) || ');'

        ); 
	end if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_role_master_insert_trigger_func()
  OWNER TO postgres;

/*update um_role_master*/
-- Function: public.um_role_master_update_trigger_func()

-- DROP FUNCTION public.um_role_master_update_trigger_func();

CREATE OR REPLACE FUNCTION public.um_role_master_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN

if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_role_master
		SET created_by='|| quote_nullable(NEW.created_by) || ', created_on='|| quote_nullable(NEW.created_on) || ', 
		modified_by='|| quote_nullable(NEW.modified_by) || ', modified_on='|| quote_nullable(NEW.modified_on) || ', 
		code='|| quote_nullable(NEW.code) || ', description='|| quote_nullable(NEW.description) || ', 
		name='|| quote_nullable(NEW.name) || ', state='|| quote_nullable(NEW.state) || ', 
		max_position='|| quote_nullable(NEW.max_position) || ', is_email_mandatory='|| quote_nullable(NEW.is_email_mandatory) || ', 
		is_contact_num_mandatory='|| quote_nullable(NEW.is_contact_num_mandatory) || ', 
		is_aadhar_num_mandatory='|| quote_nullable(NEW.is_aadhar_num_mandatory) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'	
        ); 
	end if;
	
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_role_master_update_trigger_func()
  OWNER TO postgres;

/*um_user_location insert trigger*/
-- Function: public.um_user_location_insert_trigger_func()

-- DROP FUNCTION public.um_user_location_insert_trigger_func();

CREATE OR REPLACE FUNCTION public.um_user_location_insert_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN


if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'INSERT INTO public.um_user_location(
            id, created_by, created_on, modified_by, modified_on, loc_id, 
            state, type, user_id, level)
	   VALUES ('|| quote_nullable(NEW.id) || '
	   ,'|| quote_nullable(NEW.created_by) || '
	   ,'|| quote_nullable(NEW.created_on) || '
	   ,'|| quote_nullable(NEW.modified_by) || '
	   ,'|| quote_nullable(NEW.modified_on) || '
	   ,'|| quote_nullable(NEW.loc_id) || '
	   ,'|| quote_nullable(NEW.state) || '
	   ,'|| quote_nullable(NEW.type) || '
	   ,'|| quote_nullable(NEW.user_id) || '
	   ,'|| quote_nullable(NEW.level) || '
	   );'
        ); 
	end if;
    update location_master set modified_on = now() where id = NEW.loc_id;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_user_location_insert_trigger_func()
  OWNER TO postgres;

/*um_user_location update trigger*/
-- Function: public.um_user_location_update_trigger_func()

-- DROP FUNCTION public.um_user_location_update_trigger_func();

CREATE OR REPLACE FUNCTION public.um_user_location_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	
if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_user_location SET id='|| quote_nullable(NEW.id) || 
		', created_by='|| quote_nullable(NEW.created_by) || 
		', created_on='|| quote_nullable(NEW.created_on) || 
		', modified_by='|| quote_nullable(NEW.modified_by) || 
		', modified_on='|| quote_nullable(NEW.modified_on) || 
		', loc_id='|| quote_nullable(NEW.loc_id) || 
		', state='|| quote_nullable(NEW.state) || 
		', type='|| quote_nullable(NEW.type) || 
		', user_id='|| quote_nullable(NEW.user_id) || 
		', level='|| quote_nullable(NEW.level) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'

        ); 
	end if;
    update location_master set modified_on = now() where id = NEW.loc_id;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.um_user_location_update_trigger_func()
  OWNER TO postgres;

/*mytecho module trigger*/
DO $$ 
    BEGIN
        BEGIN
	ALTER TABLE user_menu_item ADD created_by int8 NULL;
EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
		END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
	ALTER TABLE public.user_menu_item ADD created_on timestamp NULL;
EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
		END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
	ALTER TABLE public.user_menu_item ADD modified_by int8 NULL;
EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
		END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
	ALTER TABLE public.user_menu_item ADD modified_on timestamp NULL;
	EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
		END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
	ALTER TABLE public.mytecho_timeline_config_det ADD category_id smallint;
	EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
		END;
    END;
$$;
 

/*YYY important but unused table*/

alter table if exists anmol_district rename to yyy_anmol_district;
alter table if exists anmol_health_block rename to yyy_anmol_health_block;
alter table if exists anmol_health_phc rename to yyy_anmol_health_phc;
alter table if exists anmol_health_subcentre rename to yyy_anmol_health_subcentre;
alter table if exists anmol_village_profile rename to yyy_anmol_village_profile;
alter table if exists location_census_master rename to yyy_location_census_master;
alter table if exists mcts_cen_village rename to yyy_mcts_cen_village;
alter table if exists mcts_district rename to yyy_mcts_district;
alter table if exists mcts_ground_staff rename to yyy_mcts_ground_staff;
alter table if exists mcts_health_block rename to yyy_mcts_health_block;
alter table if exists mcts_health_block_taluka rename to yyy_mcts_health_block_taluka;
alter table if exists mcts_health_subcentre rename to yyy_mcts_health_subcentre;
alter table if exists mcts_location_emamta_code rename to yyy_mcts_location_emamta_code;
alter table if exists mcts_location_emamta_code_text rename to yyy_mcts_location_emamta_code_text;
alter table if exists mcts_nrhm_format_child rename to yyy_mcts_nrhm_format_child;
alter table if exists mcts_nrhm_format_mother rename to yyy_mcts_nrhm_format_mother;
alter table if exists zzz_temp_anmol_location_master_final rename to yyy_zzz_temp_anmol_location_master_final;

/*ZZZ unused tables */


alter table if exists anc_morbidity_information rename to zzz_anc_morbidity_information;
alter table if exists anmol_eligible_couples_100 rename to zzz_anmol_eligible_couples_100;
alter table if exists anmol_eligible_couples_100_2 rename to zzz_anmol_eligible_couples_100_2;
alter table if exists anmol_eligible_couples_26_09_2019 rename to zzz_anmol_eligible_couples_26_09_2019;
alter table if exists anmol_eligible_couples_aanand rename to zzz_anmol_eligible_couples_aanand;
alter table if exists anmol_eligible_couples_ahemdabad rename to zzz_anmol_eligible_couples_ahemdabad;
alter table if exists anmol_eligible_couples_arvvali_vadodra rename to zzz_anmol_eligible_couples_arvvali_vadodra;
alter table if exists anmol_eligible_couples_bharuch_patan rename to zzz_anmol_eligible_couples_bharuch_patan;
alter table if exists anmol_eligible_couples_current_300 rename to zzz_anmol_eligible_couples_current_300;
alter table if exists anmol_eligible_couples_current_kheda rename to zzz_anmol_eligible_couples_current_kheda;
alter table if exists anmol_eligible_couples_current_rajkot_porbandat_jungath_dwarka_ rename to zzz_anmol_eligible_couples_current_rajkot_porbandat_jungath_dwarka_;
alter table if exists anmol_eligible_couples_dahod_banashkantha rename to zzz_anmol_eligible_couples_dahod_banashkantha;
alter table if exists anmol_eligible_couples_gandhinagar rename to zzz_anmol_eligible_couples_gandhinagar;
alter table if exists anmol_eligible_couples_jamnagar_botad_bhavnagar_morbi rename to zzz_anmol_eligible_couples_jamnagar_botad_bhavnagar_morbi;
alter table if exists anmol_eligible_couples_khuch_sabarkantha rename to zzz_anmol_eligible_couples_khuch_sabarkantha;
alter table if exists anmol_eligible_couples_mahisagar_valsad rename to zzz_anmol_eligible_couples_mahisagar_valsad;
alter table if exists anmol_eligible_couples_narmda rename to zzz_anmol_eligible_couples_narmda;
alter table if exists anmol_eligible_couples_navshari rename to zzz_anmol_eligible_couples_navshari;
alter table if exists anmol_eligible_couples_panchmahal_chhota_udaypur rename to zzz_anmol_eligible_couples_panchmahal_chhota_udaypur;
alter table if exists anmol_eligible_couples_tapi rename to zzz_anmol_eligible_couples_tapi;
alter table if exists asha_performance_details rename to zzz_asha_performance_details;
alter table if exists audit_trail rename to zzz_audit_trail;
alter table if exists child_cmtc_nrc_admission_delete_detail rename to zzz_child_cmtc_nrc_admission_delete_detail;
alter table if exists child_compliance_visit_detail rename to zzz_child_compliance_visit_detail;
alter table if exists child_ert_visit_detail rename to zzz_child_ert_visit_detail;
alter table if exists child_health_locationwise_stats rename to zzz_child_health_locationwise_stats;
alter table if exists child_vac_schedule rename to zzz_child_vac_schedule;
--alter table if exists child_vaccines_schedule rename to zzz_child_vaccines_schedule;
alter table if exists childcare_morbidity_information rename to zzz_childcare_morbidity_information;
alter table if exists childcare_visit_detail rename to zzz_childcare_visit_detail;
alter table if exists client_anc_detail rename to zzz_client_anc_detail;
alter table if exists client_compliance_visit_detail rename to zzz_client_compliance_visit_detail;
alter table if exists client_delivery_detail rename to zzz_client_delivery_detail;
alter table if exists client_ert_visit_detail rename to zzz_client_ert_visit_detail;
alter table if exists client_migration_detail rename to zzz_client_migration_detail;
alter table if exists client_pnc_detail rename to zzz_client_pnc_detail;
alter table if exists client_pregnancy_information rename to zzz_client_pregnancy_information;
alter table if exists clientdetails rename to zzz_clientdetails;
alter table if exists contact_person_det_family_id_temp rename to zzz_contact_person_det_family_id_temp;
alter table if exists del_child_from_wpd rename to zzz_del_child_from_wpd;
alter table if exists duplicate_health_id_det rename to zzz_duplicate_health_id_det;
alter table if exists duplicate_member_del_det rename to zzz_duplicate_member_del_det;
alter table if exists endline_form_submission_data rename to zzz_endline_form_submission_data;
alter table if exists endline_form_submission_data_1_to_4 rename to zzz_endline_form_submission_data_1_to_4;
alter table if exists endline_form_submission_data_6_to_9 rename to zzz_endline_form_submission_data_6_to_9;
alter table if exists endline_location_master rename to zzz_endline_location_master;
alter table if exists event_configuration1 rename to zzz_event_configuration1;
alter table if exists facility_performance_master_archived rename to zzz_facility_performance_master_archived;
alter table if exists family_id_anganwadi_update rename to zzz_family_id_anganwadi_update;
alter table if exists fhs_location_wise_data_temp rename to zzz_fhs_location_wise_data_temp;
alter table if exists fhw_notification_master rename to zzz_fhw_notification_master;
alter table if exists fhw_performance_details rename to zzz_fhw_performance_details;
alter table if exists form_submission_data rename to zzz_form_submission_data;
alter table if exists gvk_manage_call_master_16_07_1990 rename to zzz_gvk_manage_call_master_16_07_1990;
alter table if exists helpline_dashboard_info rename to zzz_helpline_dashboard_info;
alter table if exists imt_attendance rename to zzz_imt_attendance;
alter table if exists imt_attendance_topic_rel rename to zzz_imt_attendance_topic_rel;
alter table if exists imt_audit_trail rename to zzz_imt_audit_trail;
alter table if exists imt_certificate rename to zzz_imt_certificate;
alter table if exists imt_course rename to zzz_imt_course;
alter table if exists imt_course_topic_rel rename to zzz_imt_course_topic_rel;
alter table if exists imt_member_archive rename to zzz_imt_member_archive;
alter table if exists imt_member_duplicate_health_id_temp rename to zzz_imt_member_duplicate_health_id_temp;
alter table if exists imt_member_marital_status_issue rename to zzz_imt_member_marital_status_issue;
alter table if exists imt_member_state_max_temp rename to zzz_imt_member_state_max_temp;
alter table if exists imt_member_with_wrong_family rename to zzz_imt_member_with_wrong_family;
alter table if exists imt_role_hierarchy_detail rename to zzz_imt_role_hierarchy_detail;
alter table if exists imt_role_managed_by rename to zzz_imt_role_managed_by;
alter table if exists imt_state rename to zzz_imt_state;
alter table if exists imt_topic rename to zzz_imt_topic;
alter table if exists imt_topic_coverage rename to zzz_imt_topic_coverage;
alter table if exists imt_training rename to zzz_imt_training;
alter table if exists imt_training_additional_attendee_rel rename to zzz_imt_training_additional_attendee_rel;
alter table if exists imt_training_attendee_rel rename to zzz_imt_training_attendee_rel;
alter table if exists imt_training_course_rel rename to zzz_imt_training_course_rel;
alter table if exists imt_training_optional_trainer_rel rename to zzz_imt_training_optional_trainer_rel;
alter table if exists imt_training_org_unit_rel rename to zzz_imt_training_org_unit_rel;
alter table if exists imt_training_primary_trainer_rel rename to zzz_imt_training_primary_trainer_rel;
alter table if exists imt_training_role_rel rename to zzz_imt_training_role_rel;
alter table if exists internationalization_country_master rename to zzz_internationalization_country_master;
alter table if exists internationalization_currency_master rename to zzz_internationalization_currency_master;
alter table if exists internationalization_label_master1 rename to zzz_internationalization_label_master1;
alter table if exists internationalization_timezone_location_detail rename to zzz_internationalization_timezone_location_detail;
alter table if exists internationalization_timezone_master rename to zzz_internationalization_timezone_master;
alter table if exists location_english_det rename to zzz_location_english_det;
alter table if exists location_master_imtecho rename to zzz_location_master_imtecho;
alter table if exists location_master_new rename to zzz_location_master_new;
alter table if exists location_monthly_history_master rename to zzz_location_monthly_history_master;
alter table if exists location_rch_code rename to zzz_location_rch_code;
alter table if exists location_wise_month_year_analytics rename to zzz_location_wise_month_year_analytics;
alter table if exists locationwise_tasklist_info rename to zzz_locationwise_tasklist_info;
alter table if exists log_method_call rename to zzz_log_method_call;
alter table if exists m_to_mr_vaccine_change_member rename to zzz_m_to_mr_vaccine_change_member;
alter table if exists mamtaday_child_visit_detail rename to zzz_mamtaday_child_visit_detail;
alter table if exists mamtaday_client_visit_detail rename to zzz_mamtaday_client_visit_detail;
alter table if exists member_details_t rename to zzz_member_details_t;
alter table if exists mo_family_pending_work rename to zzz_mo_family_pending_work;
alter table if exists mo_member_pending_work rename to zzz_mo_member_pending_work;
alter table if exists mo_pending_work rename to zzz_mo_pending_work;
alter table if exists mo_work_done rename to zzz_mo_work_done;
alter table if exists morbidity_name_instructn_info rename to zzz_morbidity_name_instructn_info;
alter table if exists not_associated_preg_reg_id rename to zzz_not_associated_preg_reg_id;
alter table if exists others_family_ids rename to zzz_others_family_ids;
alter table if exists performance_summary_details rename to zzz_performance_summary_details;
alter table if exists person_death_detail rename to zzz_person_death_detail;
alter table if exists person_referral_detail rename to zzz_person_referral_detail;
alter table if exists phc_incentive_day_info rename to zzz_phc_incentive_day_info;
alter table if exists phc_incentive_history_info rename to zzz_phc_incentive_history_info;
alter table if exists pnc_child_morbidity_information rename to zzz_pnc_child_morbidity_information;
alter table if exists pnc_client_morbidity_information rename to zzz_pnc_client_morbidity_information;
alter table if exists rch_anc_family_planning_method_rel rename to zzz_rch_anc_family_planning_method_rel;
alter table if exists rch_data_sync_status rename to zzz_rch_data_sync_status;
alter table if exists rch_eligible_couple_analytics_t1 rename to zzz_rch_eligible_couple_analytics_t1;
alter table if exists rch_member_death_reason_rel rename to zzz_rch_member_death_reason_rel;
alter table if exists rch_temp_member_sync_data rename to zzz_rch_temp_member_sync_data;
alter table if exists setu_user_activity rename to zzz_setu_user_activity;
alter table if exists setu_user_last_known_loc rename to zzz_setu_user_last_known_loc;
alter table if exists similiar_record_information rename to zzz_similiar_record_information;
alter table if exists survey_location_master rename to zzz_survey_location_master;
alter table if exists suspicious_activity rename to zzz_suspicious_activity;
alter table if exists system_client_basic_information rename to zzz_system_client_basic_information;
alter table if exists system_form67_aggregate_information rename to zzz_system_form67_aggregate_information;
alter table if exists system_incentive_item_master rename to zzz_system_incentive_item_master;
alter table if exists system_incentive_per_month_detail rename to zzz_system_incentive_per_month_detail;
alter table if exists system_incentive_price_detail rename to zzz_system_incentive_price_detail;
alter table if exists system_inventory_item_master rename to zzz_system_inventory_item_master;
alter table if exists system_inventory_quantity_detail rename to zzz_system_inventory_quantity_detail;
alter table if exists system_mo_performance_detail rename to zzz_system_mo_performance_detail;
alter table if exists system_notification_master rename to zzz_system_notification_master;
alter table if exists system_user_beneficiary_map rename to zzz_system_user_beneficiary_map;
alter table if exists t_member_details rename to zzz_t_member_details;
alter table if exists tba_training_detail rename to zzz_tba_training_detail;
alter table if exists tbl_child_cc rename to zzz_tbl_child_cc;
alter table if exists tbl_cmtc_nrc rename to zzz_tbl_cmtc_nrc;
alter table if exists tbl_cmtc_nrc_child_followup rename to zzz_tbl_cmtc_nrc_child_followup;
alter table if exists tbl_cmtc_nrc_wt_gain_daily rename to zzz_tbl_cmtc_nrc_wt_gain_daily;
alter table if exists tbl_delivery_history rename to zzz_tbl_delivery_history;
alter table if exists tbl_mother_cc rename to zzz_tbl_mother_cc;
alter table if exists tbl_mother_death rename to zzz_tbl_mother_death;
alter table if exists tbl_risky_symptoms rename to zzz_tbl_risky_symptoms;
alter table if exists temp_lmp_det rename to zzz_temp_lmp_det;
alter table if exists temp_member_1_to_19_year_count_detail rename to zzz_temp_member_1_to_19_year_count_detail;
alter table if exists temp_member_1_to_19_year_count_detail1 rename to zzz_temp_member_1_to_19_year_count_detail1;
alter table if exists temp_member_details rename to zzz_temp_member_details;
alter table if exists um_user_role_chnage_to_mo_uphc rename to zzz_um_user_role_chnage_to_mo_uphc;
alter table if exists urban_area_id rename to zzz_urban_area_id;
alter table if exists user_absent_detail rename to zzz_user_absent_detail;
alter table if exists user_absent_response rename to zzz_user_absent_response;
alter table if exists user_activity_detail rename to zzz_user_activity_detail;
alter table if exists user_calls_made_information rename to zzz_user_calls_made_information;
alter table if exists user_contact_image rename to zzz_user_contact_image;
alter table if exists user_contact_profile rename to zzz_user_contact_profile;
alter table if exists user_data_usage_appwise_info rename to zzz_user_data_usage_appwise_info;
alter table if exists user_data_usage_daywise_info rename to zzz_user_data_usage_daywise_info;
alter table if exists user_gprs_usage_detail rename to zzz_user_gprs_usage_detail;
alter table if exists user_incentive_status rename to zzz_user_incentive_status;
alter table if exists user_mob_loc_detail rename to zzz_user_mob_loc_detail;
alter table if exists user_mobile_detail rename to zzz_user_mobile_detail;
alter table if exists user_monthly_incentive_detail rename to zzz_user_monthly_incentive_detail;
alter table if exists user_monthly_inventory_detail rename to zzz_user_monthly_inventory_detail;
alter table if exists user_monthly_inventory_usage rename to zzz_user_monthly_inventory_usage;
alter table if exists user_performance_details rename to zzz_user_performance_details;
alter table if exists user_token_old rename to zzz_user_token_old;
alter table if exists usermanagement_company_info rename to zzz_usermanagement_company_info;
alter table if exists usermanagement_group_contact rename to zzz_usermanagement_group_contact;
alter table if exists usermanagement_role_feature rename to zzz_usermanagement_role_feature;
alter table if exists usermanagement_system_feature rename to zzz_usermanagement_system_feature;
alter table if exists usermanagement_system_role rename to zzz_usermanagement_system_role;
alter table if exists usermanagement_user_feature rename to zzz_usermanagement_user_feature;
alter table if exists usermanagement_user_group rename to zzz_usermanagement_user_group;
alter table if exists zzz_temp_anmol_eligible_couple_count rename to zzz_zzz_temp_anmol_eligible_couple_count;
alter table if exists child_monthly_analytics_16_24_months_t rename to zzz_child_monthly_analytics_16_24_months_t;
alter table if exists child_pnc_detail rename to zzz_child_pnc_detail;
alter table if exists location_wise_rch_reports_analytics rename to zzz_location_wise_rch_reports_analytics;
alter table if exists mcts_all_taluka rename to zzz_mcts_all_taluka;
alter table if exists mcts_health_phc rename to zzz_mcts_health_phc;
alter table if exists mo_mobile_detail rename to zzz_mo_mobile_detail;
alter table if exists rch_member_services_temp rename to zzz_rch_member_services_temp;
alter table if exists rch_wpd_mother_death_reason_rel rename to zzz_rch_wpd_mother_death_reason_rel;
alter table if exists tbl_anc rename to zzz_tbl_anc;
alter table if exists tbl_child rename to zzz_tbl_child;
alter table if exists tbl_child_vaccination rename to zzz_tbl_child_vaccination;
alter table if exists tbl_child_vaccination_master rename to zzz_tbl_child_vaccination_master;
alter table if exists tbl_death_place rename to zzz_tbl_death_place;
alter table if exists tbl_death_reason rename to zzz_tbl_death_reason;
alter table if exists tbl_fp_method rename to zzz_tbl_fp_method;
alter table if exists tbl_mother rename to zzz_tbl_mother;
alter table if exists tbl_mother_delivery rename to zzz_tbl_mother_delivery;
alter table if exists tbl_mother_hb rename to zzz_tbl_mother_hb;
alter table if exists tbl_mother_tt1 rename to zzz_tbl_mother_tt1;
alter table if exists tbl_mother_tt2 rename to zzz_tbl_mother_tt2;
alter table if exists tbl_mother_ttbooster rename to zzz_tbl_mother_ttbooster;
alter table if exists tbl_pnc rename to zzz_tbl_pnc;
alter table if exists tbl_pnc_child rename to zzz_tbl_pnc_child;
alter table if exists tbl_reffer_place rename to zzz_tbl_reffer_place;
alter table if exists usermanagement_user_contact rename to zzz_usermanagement_user_contact;
alter table if exists usermanagement_user_role rename to zzz_usermanagement_user_role;
alter table if exists yearly_child_health_analytics rename to zzz_yearly_child_health_analytics;
alter table if exists yearly_location_wise_anc_performance rename to zzz_yearly_location_wise_anc_performance;