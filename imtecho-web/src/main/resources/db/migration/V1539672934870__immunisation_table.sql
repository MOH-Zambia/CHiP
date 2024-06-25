alter table child_vaccines_schedule 
add column hepatitis_b_0_type_from  varchar(1),add column hepatitis_b_0_type_to varchar(1),
add column opv_0_type_from  varchar(1),add column opv_0_type_to  varchar(1),
add column bcg1_type_from varchar(1),add column bcg1_type_to varchar(1),
add column bcg2_type_from varchar(1),add column bcg2_type_to varchar(1),
add column penta_1_type_from varchar(1),add column penta_1_type_to varchar(1),
add column opv_1_type_from varchar(1),add column opv_1_type_to varchar(1),
add column f_ipv_1_01_type_from varchar(1),add column f_ipv_1_01_type_to varchar(1),
add column penta_2_type_from varchar(1),add column penta_2_type_to varchar(1),
add column opv_2_type_from varchar(1),add column opv_2_type_to varchar(1),
add column penta_3_type_from varchar(1),add column penta_3_type_to varchar(1),
add column opv_3_type_from varchar(1),add column opv_3_type_to varchar(1),
add column f_ipv_2_01_type_from varchar(1),add column f_ipv_2_01_type_to varchar(1),
add column measles_1_type_from varchar(1),add column measles_1_type_to varchar(1),
add column vitamin_a_type_from varchar(1),add column vitamin_a_type_to varchar(1),
add column opv_booster_type_from varchar(1),add column opv_booster_type_to varchar(1),
add column dpt_booster_type_from varchar(1),add column dpt_booster_type_to varchar(1),
add column measles_2_type_from varchar(1),add column measles_2_type_to varchar(1);



UPDATE public.child_vaccines_schedule
   SET hepatitis_from= 0, hepatitis_to=1, opv_0_from=0, opv_0_to=15, bcg1_from=0, 
       bcg1_to=15,bcg2_from=42, bcg2_to=12, penta_1_from=42, penta_1_to=10, 
       opv_1_from=42, opv_1_to=10, f_ip_1_01_from=42, f_ip_1_01_to=10, penta_2_from=10, 
       penta_2_to=14, opv_2_from=10, opv_2_to=14, penta_3_from=14, penta_3_to=12, 
       opv_3_from=14, opv_3_to=12, f_ip_2_01_from=14, f_ip_2_01_to=9, measles_1_from=9, 
       measles_1_to=16, vitamin_a_from=9, vitamin_a_to=60, opv_booster_from=16, 
       opv_booster_to=24, dpt_booster_from=16, dpt_booster_to=24, measles_2_from=16, 
       measles_2_to=60;

UPDATE public.child_vaccines_schedule
SET hepatitis_b_0_type_from='D', hepatitis_b_0_type_to='D', opv_0_type_from='D', 
       opv_0_type_to='D', bcg1_type_from='D', bcg1_type_to='D', bcg2_type_from='D', 
       bcg2_type_to='M', penta_1_type_from='D', penta_1_type_to='W', opv_1_type_from='D', 
       opv_1_type_to='W', f_ipv_1_01_type_from='D', f_ipv_1_01_type_to='W', 
       penta_2_type_from='W', penta_2_type_to='W', opv_2_type_from='W', opv_2_type_to='W', 
       penta_3_type_from='W', penta_3_type_to='M', opv_3_type_from='W', opv_3_type_to='M', 
       f_ipv_2_01_type_from='W', f_ipv_2_01_type_to='M', measles_1_type_from='M', 
       measles_1_type_to='M', vitamin_a_type_from='M', vitamin_a_type_to='M', 
       opv_booster_type_from='M', opv_booster_type_to='M', dpt_booster_type_from='M', 
       dpt_booster_type_to='M', measles_2_type_from='M', measles_2_type_to='M';


alter table child_vaccines_schedule rename column hepatitis_from to hepatitis_b_0_from;
alter table child_vaccines_schedule rename column hepatitis_to to hepatitis_b_0_to;
alter table child_vaccines_schedule rename column f_ip_1_01_from to f_ipv_1_01_from;
alter table child_vaccines_schedule rename column f_ip_1_01_to to f_ipv_1_01_to;
alter table child_vaccines_schedule rename column f_ip_2_01_from to f_ipv_2_01_from;
alter table child_vaccines_schedule rename column f_ip_2_01_to to f_ipv_2_01_to;



CREATE OR REPLACE FUNCTION vaccine_status(
    dob date,
    vac text,
    mem bigint)
  RETURNS text AS
$BODY$
	DECLARE 
	days integer;
	months integer;
	weeks integer;
	from_flag boolean := false;
	to_flag boolean := false;
	from_type varchar(1);
	to_type varchar(1);
	from_count integer;
	to_count integer;
	vac_lower text;
        BEGIN	
		days := current_date - dob;
		months := extract (year from age(dob)) * 12 + extract (month from age(dob));
		weeks := (days/7)::integer;
		if exists (select 1 from rch_immunisation_master  where member_id = mem and immunisation_given = vac) then
			return 'given';
		end if;
		execute 'select LOWER(''' || vac || ''')' into vac_lower;
		if vac = 'BCG' then
		  if days < 42 then	
		   execute 'select bcg1_type_from from child_vaccines_schedule' into from_type;
		   execute 'select bcg1_type_to from child_vaccines_schedule' into to_type;
		   execute 'select bcg1_from from child_vaccines_schedule' into from_count;
	           execute 'select bcg1_to from child_vaccines_schedule' into to_count;
		   if from_type = 'D' and days >= from_count then from_flag := true;
		   elsif from_type = 'W' and weeks >= from_count then from_flag := true;
		   elsif from_type = 'M' and months >= from_count then from_flag := true;	
		   end if;
		   if to_type = 'D' and days <= to_count then to_flag := true;
		   elsif to_type = 'W' and weeks <= to_count then to_flag := true;
		   elsif to_type = 'M' and months <= to_count then to_flag := true;
		   end if;
		   if from_flag = true and to_flag = true then return 'not_given';
		   elsif from_flag = false then return 'to_be_given';
		   elsif to_flag = false then return 'missed';
		   end if;
		else 		
		   execute 'select bcg2_type_from from child_vaccines_schedule' into from_type;
		   execute 'select bcg2_type_to from child_vaccines_schedule' into to_type;
		   execute 'select bcg2_from from child_vaccines_schedule' into from_count;
	           execute 'select bcg2_to from child_vaccines_schedule' into to_count;
		   if from_type = 'D' and days >= from_count then from_flag := true;
		   elsif from_type = 'W' and weeks >= from_count then from_flag := true;
		   elsif from_type = 'M' and months >= from_count then from_flag := true;	
		   end if;
		   if to_type = 'D' and days <= to_count then to_flag := true;
		   elsif to_type = 'W' and weeks <= to_count then to_flag := true;
		   elsif to_type = 'M' and months <= to_count then to_flag := true;
		   end if;
		   if from_flag = true and to_flag = true then return 'not_given';
		   elsif from_flag = false then return 'to_be_given';
		   elsif to_flag = false then return 'missed';
		   end if;
		end if;
		else
		execute 'select ' || vac_lower ||  '_type_from from child_vaccines_schedule' into from_type;
		execute 'select ' || vac_lower || '_type_to from child_vaccines_schedule' into to_type;
		execute 'select ' || vac_lower || '_from from child_vaccines_schedule' into from_count;
	        execute 'select ' || vac_lower || '_to from child_vaccines_schedule' into to_count;
		if from_type = 'D' and days >= from_count then from_flag := true;
		   elsif from_type = 'W' and weeks >= from_count then from_flag := true;
		   elsif from_type = 'M' and months >= from_count then from_flag := true;	
		end if;
		if to_type = 'D' and days <= from_count then to_flag := true;
		   elsif to_type = 'W' and weeks <= to_count then to_flag := true;
		   elsif to_type = 'M' and months <= to_count then to_flag := true;
		end if;
		if from_flag = true and to_flag = true then return 'not_given';
		   elsif from_flag = false then return 'to_be_given';
		   elsif to_flag = false then return 'missed';
		end if;
	   end if;	
        END;
$BODY$
  LANGUAGE plpgsql;