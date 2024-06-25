DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_expected_target 
 ADD COLUMN ela_dpt_opv_mes_vita_2dose integer;
 comment on column location_wise_expected_target.ela_dpt_opv_mes_vita_2dose is '2nd Year No Of expected vaccination dose(DPT Booster 1st & 2nd Dose, OPV Booster, Measles 2nd Dose and Vitamin A 2nd Dose))';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;