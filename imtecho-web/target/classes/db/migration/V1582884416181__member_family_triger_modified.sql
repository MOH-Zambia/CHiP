CREATE OR REPLACE FUNCTION public.update_basic_state_member_trigger()
  RETURNS trigger AS
$BODY$
begin
update
	imt_family
set
	modified_on = now()
where
	family_id = new.family_id
	and modified_on < now() - interval '1 minute';

if (TG_OP = 'UPDATE'
and NEW.family_id != OLD.family_id) then update
	imt_family
set
	modified_on = now()
where
	family_id = old.family_id
	and (modified_on is null
	or modified_on < now() - interval '1 minute');
end if;

if (TG_OP = 'INSERT') then with rowss as(
insert
	into
		imt_member_state_detail (member_id,
		from_state,
		to_state,
		parent,
		created_by,
		created_on,
		modified_by,
		modified_on)
	values (new.id,
	null,
	new.state,
	null,
	new.modified_by,
	now(),
	new.modified_by,
	now()) returning id ) select
	id into
		new.current_state
	from
		rowss;
end if;

if (TG_OP != 'INSERT'
and new.state != old.state) then with rowss as(
insert
	into
		imt_member_state_detail (member_id,
		from_state,
		to_state,
		parent,
		created_by,
		created_on,
		modified_by,
		modified_on,
		comment)
	values (new.id,
	old.state,
	new.state,
	old.current_state,
	new.modified_by,
	now(),
	new.modified_by,
	now(),
	case
		when new.remarks is not null
		and old.remarks is null then new.remarks
		when new.remarks is not null
		and old.remarks is not null
		and new.remarks <> old.remarks then new.remarks
		else null
	end) returning id ) select
	id into
		new.current_state
	from
		rowss;
end if;

if (TG_OP = 'INSERT'
or new.state != old.state)
and new.state in ( 'com.argusoft.imtecho.member.state.verified',
'com.argusoft.imtecho.member.state.mo.fhw.reverified',
'com.argusoft.imtecho.member.state.fhw.reverified' ,
'com.argusoft.imtecho.member.state.new',
'com.argusoft.imtecho.member.state.new.fhw.reverified',
'com.argusoft.imtecho.member.state.temporary',
'com.argusoft.imtecho.member.state.dead.fhsr.reverification',
'com.argusoft.imtecho.member.state.dead.mo.reverification',
'com.argusoft.imtecho.member.state.archived.mo.reverification',
'com.argusoft.imtecho.member.state.archived.fhsr.reverification',
'CFHC_MV',
'CFHC_MN',
'CFHC_MIR',
'CFHC_MMOV') then insert
	into
		rch_member_data_sync_pending(member_id,
		created_on,
		is_synced)
	values(NEW.id,
	now(),
	false);

if(new.state = 'com.argusoft.imtecho.member.state.temporary'
and NEW.is_pregnant = true
and NEW.cur_preg_reg_det_id is null) then drop table
	if exists member_details;

create temp table
	member_details( family_id bigint,
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
	last_delivery_date date,
	preg_reg_det_id bigint,
	is_lmp_followup_done boolean,
	is_wpd_entry_done boolean );

insert
	into
		member_details (family_id ,
		member_id,
		family_id_text,
		unique_health_id,
		location_id,
		area_id,
		is_pregnant,
		dob,
		imtecho_lmp,
		lmp,
		gender,
		marital_status,
		emamta_health_id ,
		family_state,
		preg_reg_det_id) select
			distinct imt_family.id as family_id,
			NEW.id as member_id,
			imt_family.family_id,
			case
				when NEW.state in ('com.argusoft.imtecho.member.state.new',
				'com.argusoft.imtecho.member.state.new.fhw.reverified')
				and NEW.emamta_health_id is not null then upper(NEW.emamta_health_id)
				else NEW.unique_health_id
			end as unique_health_id ,
			imt_family.location_id as location_id,
			case
				when imt_family.area_id is null then imt_family.location_id
				else cast(imt_family.area_id as bigint)
			end ,
			(case
				when NEW.is_pregnant = true then true
				else false
			end),
			NEW.dob,
			NEW.lmp,
			NEW.lmp,
			NEW.gender,
			NEW.marital_status ,
			upper(NEW.emamta_health_id),
			imt_family.state,
			NEW.cur_preg_reg_det_id
		from
			imt_family
		where
			imt_family.family_id = NEW.family_id;

insert
	into
		rch_member_service_data_sync_detail (member_id,
		created_on,
		original_lmp,
		is_pregnant_in_imtecho,
		imtecho_dob,
		location_id) select
			member_id,
			now(),
			imtecho_lmp,
			is_pregnant,
			dob,
			location_id
		from
			member_details ;

update
	member_details
set
	lmp = now() - interval '28 days'
where
	member_details.is_pregnant = true
	and member_details.cur_preg_reg_det_id is null
	and lmp is null;

insert
	into
		public.rch_pregnancy_registration_det( member_id,
		family_id,
		location_id,
		current_location_id,
		lmp_date,
		edd,
		reg_date,
		state,
		created_on,
		created_by,
		modified_on,
		modified_by) select
			member_details.member_id,
			member_details.family_id,
			member_details.area_id,
			member_details.area_id,
			member_details.lmp,
			member_details.lmp + interval '281 day',
			now(),
			'PREGNANT' ,
			now(),
			-1,
			now(),
			-1
		from
			member_details
		where
			member_details.is_pregnant = true
			and member_details.cur_preg_reg_det_id is null;

update
	member_details
set
	is_pregnant = true,
	--,lmp = case when member_details.lmp is null then rch_pregnancy_registration_det.lmp_date else member_details.lmp end 
 cur_preg_reg_det_id = rch_pregnancy_registration_det.id ,
	cur_preg_reg_date = rch_pregnancy_registration_det.reg_date
from
	rch_pregnancy_registration_det
where
	member_details.is_wpd_entry_done is null
	and member_details.preg_reg_det_id is null
	and rch_pregnancy_registration_det.member_id = member_details.member_id
	and rch_pregnancy_registration_det.state = 'PREGNANT'
	and rch_pregnancy_registration_det.lmp_date > now() - interval '350 days';
-- anc notification 
 insert
	into
		public.techo_notification_master( notification_type_id,
		notification_code,
		location_id,
		location_hierchy_id,
		family_id,
		member_id,
		schedule_date,
		action_by,
		state,
		created_by,
		created_on,
		modified_by,
		modified_on,
		ref_code) select
			2,
			case
				when date_part('day', age(lmp, anc_date)) between 0 and 91 then '1'
				when date_part('day', age(lmp, anc_date)) between 92 and 189 then '2'
				when date_part('day', age(lmp, anc_date)) between 190 and 245 then '3'
				when date_part('day', age(lmp, anc_date)) > 246 then '4'
			end ,
			location_id,
			-1,
			family_id,
			member_id,
			anc_date,
			-1,
			'DONE_ON_EMAMTA',
			-1,
			now(),
			'-1',
			now(),
			cur_preg_reg_det_id
		from
			(
			select
				member_details.family_id as family_id,
				member_details.member_id as member_id,
				member_details.cur_preg_reg_det_id,
				member_details.location_id ,
				member_details.lmp,
				max(rch_anc_master.created_on) as anc_date
			from
				member_details
			inner join rch_anc_master on
				rch_anc_master.pregnancy_reg_det_id = member_details.cur_preg_reg_det_id
				and member_details.preg_reg_det_id is null
			where
				member_details.cur_preg_reg_det_id is not null
			group by
				member_details.family_id ,
				member_details.member_id ,
				member_details.cur_preg_reg_det_id,
				member_details.location_id,
				member_details.lmp) as t;
-- Anc notification 
 insert
	into
		public.event_mobile_notification_pending( notification_configuration_type_id,
		base_date,
		family_id,
		member_id,
		created_by,
		created_on,
		modified_by,
		modified_on,
		is_completed,
		state,
		ref_code) select
			'5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a'
			-- anc_config_id 
,
			member_details.lmp,
			member_details.family_id,
			member_details.member_id,
			-1,
			now(),
			-1,
			now(),
			false,
			'PENDING',
			member_details.cur_preg_reg_det_id
		from
			member_details
		where
			member_details.cur_preg_reg_det_id is not null
			and member_details.preg_reg_det_id is null;
-- WPD notification 
 insert
	into
		public.event_mobile_notification_pending( notification_configuration_type_id,
		base_date,
		family_id,
		member_id,
		created_by,
		created_on,
		modified_by,
		modified_on,
		is_completed,
		state,
		ref_code) select
			'faedb8e7-3e46-40a2-a9ac-ea7d5de944fa'
			-- wpd_config_id 
,
			member_details.lmp,
			member_details.family_id,
			member_details.member_id,
			-1,
			now(),
			-1,
			now(),
			false,
			'PENDING',
			member_details.cur_preg_reg_det_id
		from
			member_details
		where
			member_details.cur_preg_reg_det_id is not null
			and member_details.preg_reg_det_id is null;
-- PNC notification 
 insert
	into
		public.event_mobile_notification_pending( notification_configuration_type_id,
		base_date,
		family_id,
		member_id,
		created_by,
		created_on,
		modified_by,
		modified_on,
		is_completed,
		state,
		ref_code) select
			'9b1a331b-fac5-48f0-908e-ef545e0b0c52'
			-- pnc_config_id 
,
			rch_wpd_mother_master.date_of_delivery,
			member_details.family_id,
			member_details.member_id,
			-1,
			now(),
			-1,
			now(),
			false,
			'PENDING',
			rch_wpd_mother_master.pregnancy_reg_det_id
		from
			member_details
		inner join rch_wpd_mother_master on
			rch_wpd_mother_master.member_id = member_details.member_id
			and rch_wpd_mother_master.date_of_delivery > now() - interval '60 day';

NEW.cur_preg_reg_det_id = (
	select cur_preg_reg_det_id
from
	member_details);

NEW.cur_preg_reg_date = (
	select cur_preg_reg_date
from
	member_details);

drop table
	member_details;

elseif (NEW.is_pregnant = true
and NEW.cur_preg_reg_det_id is null) then NEW.is_pregnant = false;
end if;
end if;

if TG_OP != 'INSERT'
and new.current_state is null
and old.current_state is not null then new.current_state = old.current_state;
end if;

if TG_OP != 'INSERT'
and new.basic_state is null
and old.basic_state is not null then new.basic_state = old.basic_state;
end if;
case
	when new.state in ('com.argusoft.imtecho.member.state.unverified','CFHC_MU') then new.basic_state := 'UNVERIFIED';
when new.state in ('com.argusoft.imtecho.member.state.archived.fhsr.verified',
'com.argusoft.imtecho.member.state.archived.fhw.reverified',
'com.argusoft.imtecho.member.state.archived',
'com.argusoft.imtecho.member.state.archived.mo.verified') then new.basic_state := 'ARCHIVED';
when new.state in ('com.argusoft.imtecho.member.state.verified',
'com.argusoft.imtecho.member.state.mo.fhw.reverified',
'com.argusoft.imtecho.member.state.fhw.reverified',
'CFHC_MV','CFHC_MMOV') then new.basic_state := 'VERIFIED';
when new.state in ('com.argusoft.imtecho.member.state.dead.fhsr.reverification',
'com.argusoft.imtecho.member.state.dead.mo.reverification',
'com.argusoft.imtecho.member.state.archived.mo.reverification',
'com.argusoft.imtecho.member.state.archived.fhsr.reverification','CFHC_MIR') then new.basic_state := 'REVERIFICATION';
when new.state in ('com.argusoft.imtecho.member.state.new',
'com.argusoft.imtecho.member.state.new.fhw.reverified',
'CFHC_MN') then new.basic_state := 'NEW';
when new.state in ('com.argusoft.imtecho.member.state.dead.fhw.reverified',
'com.argusoft.imtecho.member.state.dead.mo.verified',
'com.argusoft.imtecho.member.state.dead',
'com.argusoft.imtecho.member.state.dead.mo.fhw.reverified',
'com.argusoft.imtecho.member.state.dead.fhsr.verified',
'CFHC_MD') then new.basic_state := 'DEAD';
when new.state in ('com.argusoft.imtecho.member.state.orphan') then new.basic_state := 'ORPHAN';
when new.state in ('com.argusoft.imtecho.member.state.temporary') then new.basic_state := 'TEMPORARY';
when new.state in ('com.argusoft.imtecho.member.state.migrated') then new.basic_state := 'MIGRATED';
else new.basic_state := 'UNHANDLED';
end
case;

return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


create or replace
function public.update_basic_state_family_trigger() RETURNS trigger AS
$BODY$
begin
if (TG_OP = 'INSERT') then with rowss as(
insert
	into
		imt_family_state_detail (family_id,
		from_state,
		to_state,
		parent,
		created_by,
		created_on,
		modified_by,
		modified_on)
	values (new.family_id,
	null,
	new.state,
	null,
	new.modified_by,
	now(),
	new.modified_by,
	now()) returning id ) select
	id into
		NEW.current_state
	from
		rowss;
end if;

if (TG_OP != 'INSERT'
and new.state != old.state) then with rowss as(
insert
	into
		imt_family_state_detail (family_id,
		from_state,
		to_state,
		parent,
		created_by,
		created_on,
		modified_by,
		modified_on,
		comment)
	values (new.family_id,
	old.state,
	new.state,
	old.current_state,
	new.modified_by,
	now(),
	new.modified_by,
	now(),
	case
		when new.remarks is not null
		and old.remarks is null then new.remarks
		when new.remarks is not null
		and old.remarks is not null
		and new.remarks <> old.remarks then new.remarks
		else null
	end) returning id ) select
	id into
		NEW.current_state
	from
		rowss;
end if;
case
	when TG_OP != 'INSERT'
	and new.state = old.state then return new;
when new.state in ('com.argusoft.imtecho.family.state.unverified') then new.basic_state := 'UNVERIFIED';
when new.state in ('com.argusoft.imtecho.family.state.archived',
'com.argusoft.imtecho.family.state.archived.fhw.reverified',
'com.argusoft.imtecho.family.state.archived.fhsr.verified',
'com.argusoft.imtecho.family.state.new.archived.mo.fhw.reverified',
'com.argusoft.imtecho.family.state.archived.emri.fhw.reverified',
'com.argusoft.imtecho.family.state.new.archived.fhw.reverified',
'com.argusoft.imtecho.family.state.archived.mo.verified',
'com.argusoft.imtecho.family.state.archived.mo.fhw.reverified') then new.basic_state := 'ARCHIVED';
when new.state in ('com.argusoft.imtecho.family.state.verified',
'com.argusoft.imtecho.family.state.fhw.reverified',
'com.argusoft.imtecho.family.state.emri.fhw.reverified',
'com.argusoft.imtecho.family.state.emri.verified.ok',
'com.argusoft.imtecho.family.state.emri.fhw.reverified.dead',
'com.argusoft.imtecho.family.state.emri.fhw.reverified.verified',
'com.argusoft.imtecho.family.state.emri.verified.ok.dead',
'com.argusoft.imtecho.family.state.emri.verification.pool.dead',
'com.argusoft.imtecho.family.state.emri.verification.pool.verified',
'com.argusoft.imtecho.family.state.emri.verification.pool.archived',
'com.argusoft.imtecho.family.state.emri.verification.pool',
'com.argusoft.imtecho.family.state.emri.verified.ok.verified',
'com.argusoft.imtecho.family.state.mo.fhw.reverified',
'com.argusoft.imtecho.family.state.emri.fhw.reverified.archived',
'com.argusoft.imtecho.family.state.emri.verified.ok.archived',
'CFHC_FV',
'CFHC_GVK_FV',
'CFHC_MO_FV',
'CFHC_GVK_FRV',
'CFHC_MO_FRV',
'CFHC_GVK_FRVP',
'CFHC_MO_FRVP'
) then new.basic_state := 'VERIFIED';
when new.state in ('com.argusoft.imtecho.family.state.archived.fhsr.reverification',
'com.argusoft.imtecho.family.state.archived.mo.reverification',
'com.argusoft.imtecho.family.state.new.fhsr.reverification',
'com.argusoft.imtecho.family.state.new.mo.reverification',
'com.argusoft.imtecho.family.state.emri.fhw.reverification.verified',
'com.argusoft.imtecho.family.state.emri.fhw.reverification.dead',
'com.argusoft.imtecho.family.state.emri.fhw.reverification',
'com.argusoft.imtecho.family.state.emri.fhw.reverification.archived',
'CFHC_FIR',
'CFHC_GVK_FIR') then new.basic_state := 'REVERIFICATION';
when new.state in ('com.argusoft.imtecho.family.state.new',
'com.argusoft.imtecho.family.state.new.fhsr.verified',
'com.argusoft.imtecho.family.state.new.fhw.reverified',
'com.argusoft.imtecho.family.state.new.mo.verified',
'com.argusoft.imtecho.family.state.new.mo.fhw.reverified',
'CFHC_FN') then new.basic_state := 'NEW';
when new.state in ('com.argusoft.imtecho.family.state.orphan') then new.basic_state := 'ORPHAN';
when new.state in ('com.argusoft.imtecho.family.state.merged') then new.basic_state := 'MERGED';
when new.state in ('com.argusoft.imtecho.family.state.temporary') then new.basic_state := 'TEMPORARY';
else new.basic_state := 'UNHANDLED';
end
case;

return new;
end;

$BODY$
  LANGUAGE plpgsql VOLATILE

  COST 100;
  /*
insert into rch_member_data_sync_pending(member_id,
		created_on,
		is_synced)
select id,now(),false
from imt_member where state in ('CFHC_MV',
'CFHC_MN');


*/