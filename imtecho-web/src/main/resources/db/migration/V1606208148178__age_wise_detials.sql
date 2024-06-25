DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE member_basic_detail 
 ADD COLUMN gender text;
 comment on column member_basic_detail.gender is 'gender in member basic detail';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_0_to_5_male integer;
 comment on column location_wise_analytics.member_0_to_5_male is '0 to 5 male in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_0_to_5_female integer;
 comment on column location_wise_analytics.member_0_to_5_female is '0 to 5 female in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_0_to_5_male_with_comorbid integer;
 comment on column location_wise_analytics.member_0_to_5_male_with_comorbid is '0 to 5 male with comorbidity in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_0_to_5_female_with_comorbid integer;
 comment on column location_wise_analytics.member_0_to_5_female_with_comorbid is '0 to 5 female with comorbidity in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_6_to_10_male integer;
 comment on column location_wise_analytics.member_6_to_10_male is '6 to 10 male in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_6_to_10_female integer;
 comment on column location_wise_analytics.member_6_to_10_female is '6 to 10 female in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;



DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_6_to_10_male_with_comorbid integer;
 comment on column location_wise_analytics.member_6_to_10_male_with_comorbid is '6 to 10 male with comorbidity in location wise analytics';

       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_6_to_10_female_with_comorbid integer;
 comment on column location_wise_analytics.member_6_to_10_female_with_comorbid is '6 to 10 female with comorbid in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;


DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_11_to_20_male integer;
 comment on column location_wise_analytics.member_11_to_20_male is '11 to 20 male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_11_to_20_female integer;
 comment on column location_wise_analytics.member_11_to_20_female is '11 to 20 female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_11_to_20_male_with_comorbid integer;
 comment on column location_wise_analytics.member_11_to_20_male_with_comorbid is '11 to 20 male with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_11_to_20_female_with_comorbid integer;
 comment on column location_wise_analytics.member_11_to_20_female_with_comorbid is '11 to 20 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_21_to_30_male integer;
 comment on column location_wise_analytics.member_21_to_30_male is '21 to 30 male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_21_to_30_female integer;
 comment on column location_wise_analytics.member_21_to_30_female is '21 to 30 female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_21_to_30_male_with_comorbid integer;
 comment on column location_wise_analytics.member_21_to_30_male_with_comorbid is '21 to 30 male with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_21_to_30_female_with_comorbid integer;
 comment on column location_wise_analytics.member_21_to_30_female_with_comorbid is '21 to 30 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_31_to_40_male integer;
 comment on column location_wise_analytics.member_31_to_40_male is '31 to 40 male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_31_to_40_female integer;
 comment on column location_wise_analytics.member_31_to_40_female is '31 to 40 female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_31_to_40_male_with_comorbid integer;
 comment on column location_wise_analytics.member_31_to_40_male_with_comorbid is '31 to 40 male with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_31_to_40_female_with_comorbid integer;
 comment on column location_wise_analytics.member_31_to_40_female_with_comorbid is '31 to 40 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_41_to_50_male integer;
 comment on column location_wise_analytics.member_41_to_50_male is '41 to 50 male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;
 
DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_41_to_50_female integer;
 comment on column location_wise_analytics.member_41_to_50_female is '41 to 50 female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_41_to_50_male_with_comorbid integer;
 comment on column location_wise_analytics.member_41_to_50_male_with_comorbid is '41 to 50 male with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_41_to_50_female_with_comorbid integer;
 comment on column location_wise_analytics.member_41_to_50_female_with_comorbid is '41 to 50 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_51_to_60_male integer;
 comment on column location_wise_analytics.member_51_to_60_male is '51 to 60 male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_51_to_60_female integer;
 comment on column location_wise_analytics.member_51_to_60_female is '51 to 60 female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_51_to_60_male_with_comorbid integer;
 comment on column location_wise_analytics.member_51_to_60_male_with_comorbid is '51 to 60 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_51_to_60_female_with_comorbid integer;
 comment on column location_wise_analytics.member_51_to_60_female_with_comorbid is '51 to 60 female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_60_plus_male integer;
 comment on column location_wise_analytics.member_60_plus_male is '60 plus male in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_60_plus_female integer;
 comment on column location_wise_analytics.member_60_plus_female is '60 plus female in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_60_plus_male_with_comorbid integer;
 comment on column location_wise_analytics.member_60_plus_male_with_comorbid is '60 plus male with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE location_wise_analytics 
 ADD COLUMN member_60_plus_female_with_comorbid integer;
 comment on column location_wise_analytics.member_60_plus_female_with_comorbid is '60 plus female with comorbidity in location wise analytics';
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;