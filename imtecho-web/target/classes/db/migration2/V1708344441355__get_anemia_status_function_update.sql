-- drop old function
DROP FUNCTION if exists public.get_anemia_status(text, numeric, date, bool);

DROP FUNCTION if exists public.get_anemia_status(text, float8, text, bool);

CREATE OR REPLACE FUNCTION public.get_anemia_status(mem_gender text, hb double precision, dob text, pregnant boolean)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	member_age numeric(6,2);
	anemia_status text;
        BEGIN
	    member_age := (extract (year from age(to_date(dob,'YYYY-MM-DD'))) * 12 + extract (month from age(to_date(dob,'YYYY-MM-DD'))))/12;

        select
        case when hb >= asr.no_anemia_min
				then 'No Anemia'
        when hb <= asr.mild_anemia_max and hb >= asr.mild_anemia_min
				then 'Mild Anemia'
        when hb <= asr.moderate_anemia_max and hb >= asr.moderate_anemia_min
				then 'Moderate Anemia'
        when hb <= asr.severe_anemia_max
				then 'Severe Anemia' end
		into anemia_status
		from anemia_status_reference asr
		where
		(case when pregnant is true and gender = 'F'
		then asr.is_pregnant is true and asr.gender = 'F'
		when pregnant is false and mem_gender = 'F' and member_age >= 15
		then asr.is_pregnant is false and asr.gender = 'F'
		when mem_gender = 'M' and member_age >= 15
		then asr.gender = 'M'
		else
		member_age between asr.age_min and asr.age_max end);

		return anemia_status;
        END;
$function$;
