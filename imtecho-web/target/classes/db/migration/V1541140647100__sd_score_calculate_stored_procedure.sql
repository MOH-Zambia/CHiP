DROP TABLE IF EXISTS public.sd_score_master;

CREATE TABLE public.sd_score_master
(
  height integer NOT NULL,
  minus4 real,
  minus3 real,
  minus2 real,
  minus1 real,
  median real,
  gender text NOT NULL,
  CONSTRAINT sd_score_master_pkey PRIMARY KEY (height, gender)
);



CREATE OR REPLACE FUNCTION public.get_sd_score(
    gender1 text,
    height1 integer,
    weight1 real)
  RETURNS text AS
$BODY$
	DECLARE 
	days integer;
	months integer;
	weeks integer;
	sd sd_score_master;
        BEGIN	
		--the for loop here is just for storing the tuple from sd_score_master into a variable
		--the query below will always return only a single row
		for sd  in(select * from sd_score_master sdm where sdm.height = height1 and sdm.gender = gender1 limit 1)
		loop
		case 
			when weight1 <= sd.minus4
				then return 'SD4';
			when weight1 <= sd.minus3
				then return 'SD3';
			when weight1 <= sd.minus2
				then return 'SD2';
			when weight1 <= sd.minus1
				then return 'SD1';
			when weight1 <= sd.median
				then return 'MEDIAN';
			else
				return null;
		
		end case;
		end loop;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;