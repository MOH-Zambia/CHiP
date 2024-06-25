--create index member_id_idx on rch_immunisation_master (member_id);

CREATE TABLE public.child_vaccines_schedule
(
  hepatitis_from smallint,
  hepatitis_to smallint,
  opv_0_from smallint,
  opv_0_to smallint,
  bcg1_from smallint,
  bcg1_to smallint,
  bcg2_from smallint,
  bcg2_to smallint,
  penta_1_from smallint,
  penta_1_to smallint,
  opv_1_from smallint,
  opv_1_to smallint,
  f_ip_1_01_from smallint,
  f_ip_1_01_to smallint,
  penta_2_from smallint,
  penta_2_to smallint,
  opv_2_from smallint,
  opv_2_to smallint,
  penta_3_from smallint,
  penta_3_to smallint,
  opv_3_from smallint,
  opv_3_to smallint,
  f_ip_2_01_from smallint,
  f_ip_2_01_to smallint,
  measles_1_from smallint,
  measles_1_to smallint,
  vitamin_a_from smallint,
  vitamin_a_to smallint,
  opv_booster_from smallint,
  opv_booster_to smallint,
  dpt_booster_from smallint,
  dpt_booster_to smallint,
  measles_2_from smallint,
  measles_2_to smallint
); 


INSERT INTO child_vaccines_schedule(
            hepatitis_from, hepatitis_to, opv_0_from, opv_0_to, bcg1_from, 
            bcg1_to, bcg2_from, bcg2_to, penta_1_from, penta_1_to, opv_1_from, 
            opv_1_to, f_ip_1_01_from, f_ip_1_01_to, penta_2_from, penta_2_to, 
            opv_2_from, opv_2_to, penta_3_from, penta_3_to, opv_3_from, opv_3_to, 
            f_ip_2_01_from, f_ip_2_01_to, measles_1_from, measles_1_to, vitamin_a_from, 
            vitamin_a_to, opv_booster_from, opv_booster_to, dpt_booster_from, 
            dpt_booster_to, measles_2_from, measles_2_to)
    VALUES (0,1,0,15,0,15,42,365,42,70,42,70,42,70,71,98,71,98,99,365,99,365,99,270,271,480,271,1825,481,730,481,730,481,1825);
