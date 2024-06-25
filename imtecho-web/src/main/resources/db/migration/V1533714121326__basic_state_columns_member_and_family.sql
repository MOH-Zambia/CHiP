ALTER TABLE public.imt_family
DROP COLUMN IF EXISTS basic_state,
ADD COLUMN basic_state text;

ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS basic_state,
ADD COLUMN basic_state text;



CREATE OR REPLACE FUNCTION public.update_basic_state_member_trigger()
  RETURNS trigger AS
$BODY$
begin
    case
	when new.state = old.state
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
        
        else
	     new.basic_state := 'UNHANDLED';
	
    end case;
    return new;
end
$BODY$
  LANGUAGE plpgsql;


CREATE TRIGGER update_basic_state_member_trigger
  BEFORE UPDATE
  ON public.imt_member
  FOR EACH ROW
  EXECUTE PROCEDURE public.update_basic_state_member_trigger();


CREATE OR REPLACE FUNCTION public.update_basic_state_family_trigger()
  RETURNS trigger AS
$BODY$
begin
    case
	when new.state = old.state
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
end
$BODY$
  LANGUAGE plpgsql;


CREATE TRIGGER update_basic_state_family_trigger
  BEFORE UPDATE
  ON public.imt_family
  FOR EACH ROW
  EXECUTE PROCEDURE public.update_basic_state_family_trigger();







