alter table if exists member_anemia_survey_details
add column if not exists iron_def_anemia_inj varchar NULL,
add column if not exists iron_def_anemia_inj_given_date timestamp NULL,
add column if not exists blood_transfusion bool NULL,
add column if not exists treatment_facility_type text null,
add column if not exists treatment_facility text null,
add column if not exists other_anemia_cause text null;


DROP TABLE IF EXISTS public.anemia_status_reference;

CREATE TABLE IF NOT EXISTS public.anemia_status_reference (
	age_min numeric(6, 2) NULL,
	age_max numeric(6, 2) NULL,
	is_pregnant bool NULL,
	gender varchar(1) NULL,
	no_anemia_min numeric(6, 2) NULL,
	mild_anemia_min numeric(6, 2) NULL,
	mild_anemia_max numeric(6, 2) NULL,
	moderate_anemia_min numeric(6, 2) NULL,
	moderate_anemia_max numeric(6, 2) NULL,
	severe_anemia_max numeric(6, 2) NULL
);

INSERT INTO public.anemia_status_reference (age_min,age_max,is_pregnant,gender,no_anemia_min,mild_anemia_min,mild_anemia_max,moderate_anemia_min,moderate_anemia_max,severe_anemia_max) VALUES
	 (0.5,4.9,NULL,NULL,11,10,10.9,7,9.9,7),
	 (5,11,NULL,NULL,11.5,11,11.4,8,10.9,8),
	 (12,14,NULL,NULL,12,11,11.9,8,10.9,8),
	 (15,NULL,false,'F',12,11,11.9,8,10.9,8),
	 (NULL,NULL,true,'F',11,10,10.9,7,9.9,7),
	 (15,NULL,NULL,'M',13,11,12.9,8,10.9,8);

-- anemia status function
CREATE OR REPLACE FUNCTION public.get_anemia_status(mem_gender text, hb numeric, dob date, pregnant boolean)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
	DECLARE
	member_age numeric(6,2);
	anemia_status text;
        BEGIN
	    member_age := (extract (year from age(dob)) * 12 + extract (month from age(dob)))/12;

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
$function$
;

DROP TABLE IF EXISTS public.anemia_cause_rel;

CREATE TABLE IF NOT EXISTS public.anemia_cause_rel (
	anemia_survey_details_id int4 NOT NULL,
	anemia_cause varchar NOT NULL,
	CONSTRAINT anemia_cause_rel_pkey PRIMARY KEY (anemia_survey_details_id, anemia_cause)
);

DROP TABLE IF EXISTS public.anemia_other_high_risk_rel;

CREATE TABLE IF NOT EXISTS public.anemia_other_high_risk_rel (
	anemia_survey_details_id int4 NOT NULL,
	high_risk_name varchar NOT NULL,
	CONSTRAINT anemia_other_high_risk_rel_pkey PRIMARY KEY (anemia_survey_details_id, high_risk_name)
);