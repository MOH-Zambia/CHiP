CREATE OR REPLACE FUNCTION public.update_basic_state_family_trigger()
  RETURNS trigger AS
$BODY$
begin

    if (TG_OP = 'INSERT') then 
	with rowss as(
		insert into imt_family_state_detail (family_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on)
		values (new.family_id, null, new.state, null, new.modified_by, now(), new.modified_by, now())
		returning id
	)
	select id into NEW.current_state from rowss;
    end if;

    if (TG_OP != 'INSERT' and new.state != old.state) then 
	with rowss as(
		insert into imt_family_state_detail (family_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on, comment)
		values (new.family_id, old.state, new.state, old.current_state, new.modified_by, now(), new.modified_by, now(),
                case 
                    when new.remarks is not null and old.remarks is null then new.remarks
                    when new.remarks is not null and old.remarks is not null and new.remarks <> old.remarks then new.remarks
                    else null
                end)
		returning id
	)
	select id into NEW.current_state from rowss;
    end if;

    case
	when TG_OP != 'INSERT' and new.state = old.state
	then return new;

	when new.state in ('com.argusoft.imtecho.family.state.unverified') 
	then new.basic_state := 'UNVERIFIED';

	when new.state in ('com.argusoft.imtecho.family.state.archived',
			'com.argusoft.imtecho.family.state.archived.fhsr.verified',
			'com.argusoft.imtecho.family.state.new.archived.mo.fhw.reverified',
			'com.argusoft.imtecho.family.state.archived.emri.fhw.reverified',
			'com.argusoft.imtecho.family.state.new.archived.fhw.reverified',
			'com.argusoft.imtecho.family.state.archived.mo.verified',
			'com.argusoft.imtecho.family.state.archived.mo.fhw.reverified') 
	then new.basic_state := 'ARCHIVED';

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
			'com.argusoft.imtecho.family.state.emri.verified.ok.archived') 
	then new.basic_state := 'VERIFIED';

	when new.state in ('com.argusoft.imtecho.family.state.archived.fhsr.reverification',
			'com.argusoft.imtecho.family.state.archived.mo.reverification',
			'com.argusoft.imtecho.family.state.new.fhsr.reverification',
			'com.argusoft.imtecho.family.state.new.mo.reverification',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.verified',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.dead',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.archived') 
	then new.basic_state := 'REVERIFICATION';

	when new.state in ('com.argusoft.imtecho.family.state.new',
			'com.argusoft.imtecho.family.state.new.fhsr.verified',
			'com.argusoft.imtecho.family.state.new.fhw.reverified',
			'com.argusoft.imtecho.family.state.new.mo.verified',
			'com.argusoft.imtecho.family.state.new.mo.fhw.reverified') 
	then new.basic_state := 'NEW';
	
	when new.state in ('com.argusoft.imtecho.family.state.orphan') 
	then new.basic_state := 'ORPHAN';

	else
	     new.basic_state := 'UNHANDLED';	
    end case;
    return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;