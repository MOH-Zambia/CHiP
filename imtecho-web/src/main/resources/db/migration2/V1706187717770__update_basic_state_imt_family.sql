CREATE OR REPLACE FUNCTION public.update_basic_state_family_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
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
'CFHC_FN', 'NCD_FN') then new.basic_state := 'NEW';
when new.state in ('com.argusoft.imtecho.family.state.orphan') then new.basic_state := 'ORPHAN';
when new.state in ('com.argusoft.imtecho.family.state.merged') then new.basic_state := 'MERGED';
when new.state in ('com.argusoft.imtecho.family.state.temporary') then new.basic_state := 'TEMPORARY';
when new.state in ('IDSP_DR_TECHO','IDSP_MY_TECHO','IDSP_TECHO','IDSP_TEMP') then new.basic_state := 'IDSP';
when new.state in ('com.argusoft.imtecho.family.state.migrated'
,'com.argusoft.imtecho.family.state.archived.temporary'
,'com.argusoft.imtecho.family.state.archived.temporary.outofstate','com.argusoft.imtecho.family.state.migrated.outofstate')
then new.basic_state := 'MIGRATED';
else new.basic_state := 'UNHANDLED';
end
case;

return new;
end;

$function$
;
