alter table covid19_admission_detail
drop column if exists lab_test_id,
add column lab_test_id text;

drop table if exists health_infra_lab_sample_id_master;

create table health_infra_lab_sample_id_master (
id serial,
source_infra integer,
source_infra_code text,
destination_infra integer,
destination_infra_code text,
current_count integer default 1,
CONSTRAINT health_infra_lab_sample_id_master_pkey PRIMARY KEY (id)
);

create or replace function get_lab_test_code(source_id integer, dest_id integer, admission_id integer) RETURNS text as $$
		declare
			counter integer := (select count(*) from health_infra_lab_sample_id_master
								where source_infra = source_id and destination_infra = dest_id);
			code text;

			lab_test_id text := (select lab_test_id from covid19_admission_detail  where id  = admission_id);
        begin
			if lab_test_id is not null then
				return lab_test_id;
			end if;

	        	if counter > 0 then
				with t1 as(update health_infra_lab_sample_id_master set current_count = current_count + 1
	        					where source_infra = source_id and destination_infra = dest_id
	        					returning  destination_infra_code||'-'||source_infra_code||'-'||current_count)
	        		 (select * into code from t1);
				return code;
	        	else
				if source_id = -1 then
					with source_inf as (select 1 as "tmp_id",-1 as "id",'RND' as "substring"),

					dest_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
					health_infrastructure_details where id = dest_id),

					t as
					(insert into health_infra_lab_sample_id_master(source_infra, source_infra_code,
					destination_infra,destination_infra_code)
					select s.id,s.substring,d.id,d.substring from source_inf s,dest_inf d where s.tmp_id = d.tmp_id
					returning   destination_infra_code|| '-' || source_infra_code|| '-' || current_count)

					--t1 as (update health_infra_lab_sample_id_master set current_count = current_count + 1
       					--where source_infra = source_id and destination_infra = dest_id
       					--returning source_infra_code || '-' || destination_infra_code || '-' || current_count)
					select * into code from t;
					return code;
				else
					with source_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
						health_infrastructure_details where id = source_id),

						dest_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
						health_infrastructure_details where id = dest_id),

						t as
						(insert into health_infra_lab_sample_id_master(source_infra, source_infra_code,
						destination_infra,destination_infra_code)
						select s.id,s.substring,d.id,d.substring from source_inf s,dest_inf d where s.tmp_id = d.tmp_id
						returning   destination_infra_code|| '-' ||source_infra_code|| '-' || current_count)

						--t1 as (update health_infra_lab_sample_id_master set current_count = current_count + 1
						--where source_infra = source_id and destination_infra = dest_id
						--returning source_infra_code || '-' || destination_infra_code || '-' || current_count)
						select * into code from t;
					return code;
				end if;
	        	end if;
        end;
$$ LANGUAGE plpgsql;


