CREATE TABLE if not EXISTS imt_family
(
  id character varying(255) NOT NULL,
  address1 character varying(255),
  address2 character varying(255),
  anganwadi_id character varying(255),
  area_id character varying(255),
  assigned_to bigint,
  bpl_flag boolean,
  caste character varying(255),
  created_by character varying(255),
  created_on timestamp without time zone,
  family_id character varying(255),
  house_number character varying(255),
  is_verified_flag boolean,
  latitude character varying(255),
  location_id character varying(255),
  longitude character varying(255),
  maa_vatsalya_number character varying(255),
  migratory_flag boolean,
  religion character varying(255),
  state character varying(255),
  toilet_available_flag boolean,
  type character varying(255),
  updated_by character varying(255),
  updated_on timestamp without time zone,
  vulnerable_flag boolean,
  rsby_card_number character varying(255),
  comment character varying(4000),
  is_report boolean,
  verified_by_fhsr character varying(4000),
  current_state character varying(255),
  CONSTRAINT imt_family_pkey PRIMARY KEY (id)
);

drop table if EXISTS imt_family_member_rel;



ALTER TABLE imt_family
  ADD COLUMN oldId character varying(256);

update imt_family set oldId = id;

ALTER TABLE imt_family
  DROP CONSTRAINT imt_family_pkey;

ALTER TABLE imt_family
  DROP COLUMN id;

ALTER TABLE imt_family
  ADD COLUMN id bigserial;

ALTER TABLE imt_family
  ADD PRIMARY KEY (id);

ALTER TABLE imt_family
  ADD COLUMN old_created_by character varying(256);

ALTER TABLE imt_family
  ADD COLUMN old_modified_by character varying(256);

update imt_family set old_created_by  = created_by , old_modified_by = updated_by;

ALTER TABLE public.imt_family
  DROP COLUMN created_by;

ALTER TABLE public.imt_family
  DROP COLUMN updated_by;

ALTER TABLE imt_family
  ADD COLUMN created_by bigint;

DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE imt_family
 ADD COLUMN modified_by bigint;
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;
DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE imt_family
ADD COLUMN modified_on timestamp without time zone;
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

update imt_family fam set created_by  = u.id from um_user u where fam.old_created_by <> 'dataloader'  and u.id = fam.old_created_by::bigint;
update imt_family fam set old_modified_by  = u.id from um_user u where fam.old_modified_by <> 'dataloader'  and u.user_name = fam.old_modified_by;
update imt_family fam set modified_by  = u.id from um_user u where fam.old_modified_by <> 'dataloader'  and u.id = fam.old_modified_by::bigint;

ALTER TABLE public.imt_family
  DROP COLUMN old_modified_by;

ALTER TABLE public.imt_family
  DROP COLUMN old_created_by;
-- 
-- ALTER TABLE imt_family
--   ADD COLUMN modified_on timestamp without time zone;

update imt_family set modified_on = updated_on;

ALTER TABLE imt_family
  DROP COLUMN updated_on;


CREATE TABLE if not exists imt_member
(
  id character varying(255) NOT NULL,
  aadhar_number character varying(255),
  account_number character varying(255),
  created_by character varying(255),
  created_on timestamp without time zone,
  dob date,
  emamta_health_id character varying(255),
  family_head boolean,
  family_id character varying(255),
  family_planning_method character varying(255),
  first_name character varying(255),
  gender character varying(255),
  grandfather_name character varying(255),
  ifsc character varying(255),
  is_aadhar_verified boolean,
  is_mobile_verified boolean,
  is_native boolean,
  is_pregnant boolean,
  last_name character varying(255),
  lmp date,
  maa_vatsalya_card_number character varying(255),
  marital_status character varying(255),
  middle_name character varying(255),
  mobile_number character varying(255),
  normal_cycle_days integer,
  state character varying(255),
  type character varying(255),
  unique_health_id character varying(255),
  updated_by character varying(255),
  updated_on timestamp without time zone,
  education_status character varying(255),
  CONSTRAINT imt_member_pkey PRIMARY KEY (id)
);

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_member ADD COLUMN current_state bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;


ALTER TABLE imt_member
  ADD COLUMN old_created_by character varying(256);

ALTER TABLE imt_member
  ADD COLUMN old_modified_by character varying(256);

update imt_member set old_created_by  = created_by , old_modified_by = updated_by;

ALTER TABLE imt_member
  DROP COLUMN created_by;

ALTER TABLE imt_member
  DROP COLUMN updated_by;

ALTER TABLE imt_member
  ADD COLUMN created_by bigint;

ALTER TABLE imt_member
  ADD COLUMN modified_by bigint;

update imt_member fam set created_by  = u.id from um_user u where fam.old_created_by <> 'dataloader'  and u.id = fam.old_created_by::bigint;
update imt_member fam set old_modified_by  = u.id from um_user u where fam.old_modified_by <> 'dataloader'  and u.user_name = fam.old_modified_by;
update imt_member fam set modified_by  = u.id from um_user u where fam.old_modified_by <> 'dataloader'  and u.id = fam.old_modified_by::bigint;

ALTER TABLE imt_member
  DROP COLUMN old_modified_by;

ALTER TABLE imt_member
  DROP COLUMN old_created_by;

ALTER TABLE imt_member
  ADD COLUMN modified_on timestamp without time zone;

update imt_member set modified_on = updated_on;

ALTER TABLE imt_member
  DROP COLUMN updated_on;



DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='imt_member_current_disease_rel' and ccu.table_name = 'imt_member'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'imt_member_current_disease_rel'|| ' DROP CONSTRAINT IF EXISTS '|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;


DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='imt_member_chronic_disease_rel' and ccu.table_name = 'imt_member'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'imt_member_chronic_disease_rel'|| ' DROP CONSTRAINT IF EXISTS '|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;


DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='imt_member_eye_issue_rel' and ccu.table_name = 'imt_member'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'imt_member_eye_issue_rel'|| ' DROP CONSTRAINT IF EXISTS '|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;


DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='imt_member_health_issue_rel' and ccu.table_name = 'imt_member'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'imt_member_health_issue_rel'|| ' DROP CONSTRAINT IF EXISTS '|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;

DO $$DECLARE r record;
BEGIN
        FOR r IN SELECT
    tc.constraint_name
FROM 
    information_schema.table_constraints AS tc 
    JOIN information_schema.key_column_usage AS kcu
      ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage AS ccu
      ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY' AND tc.table_name='imt_member_congenital_anomaly_rel' and ccu.table_name = 'imt_member'
        LOOP
            EXECUTE 'ALTER TABLE IF EXISTS ' || 'imt_member_congenital_anomaly_rel'|| ' DROP CONSTRAINT IF EXISTS '|| quote_ident(r.constraint_name) || ';';
        END LOOP;
END$$;




ALTER TABLE imt_member
  ADD COLUMN oldId character varying(256);

update imt_member set oldId = id;

ALTER TABLE imt_member
  DROP CONSTRAINT imt_member_pkey;

ALTER TABLE imt_member
  DROP COLUMN id;


ALTER TABLE imt_member
  ADD COLUMN id bigserial;

ALTER TABLE imt_member
  ADD PRIMARY KEY (id);



CREATE TABLE if not exists imt_member_chronic_disease_rel
(
  member_id character varying(255) NOT NULL,
  chronic_disease_id character varying(255)
);

alter TABLE imt_member_chronic_disease_rel
	ADD COLUMN old_member_id character varying(255);

alter TABLE imt_member_chronic_disease_rel
	ADD COLUMN old_chronic_disease_id character varying(255);

update imt_member_chronic_disease_rel set old_member_id = member_id , old_chronic_disease_id = chronic_disease_id;

alter TABLE imt_member_chronic_disease_rel
	Drop COLUMN member_id;

alter TABLE imt_member_chronic_disease_rel
	Drop COLUMN chronic_disease_id;

alter TABLE imt_member_chronic_disease_rel
	ADD COLUMN member_id bigint;

alter TABLE imt_member_chronic_disease_rel
	ADD COLUMN chronic_disease_id bigint;

update imt_member_chronic_disease_rel set chronic_disease_id = old_chronic_disease_id::bigint;

update imt_member_chronic_disease_rel imt_rel set member_id = mem.id  from imt_member mem where mem.oldid = imt_rel.old_member_id;

alter TABLE imt_member_chronic_disease_rel
	DROP COLUMN old_member_id;

alter TABLE imt_member_chronic_disease_rel
	DROP COLUMN old_chronic_disease_id;

ALTER TABLE imt_member_chronic_disease_rel
  ADD PRIMARY KEY (member_id, chronic_disease_id);



CREATE TABLE if not exists imt_member_congenital_anomaly_rel
(
  member_id character varying(255) NOT NULL,
  congenital_anomaly_id character varying(255)
);


alter TABLE imt_member_congenital_anomaly_rel
	ADD COLUMN old_member_id character varying(255);

alter TABLE imt_member_congenital_anomaly_rel
	ADD COLUMN old_congenital_anomaly_id character varying(255);

update imt_member_congenital_anomaly_rel set old_member_id = member_id , old_congenital_anomaly_id = congenital_anomaly_id;

alter TABLE imt_member_congenital_anomaly_rel
	Drop COLUMN member_id;

alter TABLE imt_member_congenital_anomaly_rel
	Drop COLUMN congenital_anomaly_id;

alter TABLE imt_member_congenital_anomaly_rel
	ADD COLUMN member_id bigint;

alter TABLE imt_member_congenital_anomaly_rel
	ADD COLUMN congenital_anomaly_id bigint;

update imt_member_congenital_anomaly_rel set congenital_anomaly_id = old_congenital_anomaly_id::bigint;

update imt_member_congenital_anomaly_rel imt_rel set member_id = mem.id  from imt_member mem where mem.oldid = imt_rel.old_member_id;

alter TABLE imt_member_congenital_anomaly_rel
	DROP COLUMN old_member_id;

alter TABLE imt_member_congenital_anomaly_rel
	DROP COLUMN old_congenital_anomaly_id;

ALTER TABLE imt_member_congenital_anomaly_rel
  ADD PRIMARY KEY (member_id, congenital_anomaly_id);



CREATE TABLE if not exists imt_member_current_disease_rel
(
  member_id character varying(255) NOT NULL,
  current_disease_id character varying(255)
);

alter TABLE imt_member_current_disease_rel
	ADD COLUMN old_member_id character varying(255);

alter TABLE imt_member_current_disease_rel
	ADD COLUMN old_current_disease_id character varying(255);

update imt_member_current_disease_rel set old_member_id = member_id , old_current_disease_id = current_disease_id;

alter TABLE imt_member_current_disease_rel
	Drop COLUMN member_id;

alter TABLE imt_member_current_disease_rel
	Drop COLUMN current_disease_id;

alter TABLE imt_member_current_disease_rel
	ADD COLUMN member_id bigint;

alter TABLE imt_member_current_disease_rel
	ADD COLUMN current_disease_id bigint;

update imt_member_current_disease_rel set current_disease_id = old_current_disease_id::bigint;

update imt_member_current_disease_rel imt_rel set member_id = mem.id  from imt_member mem where mem.oldid = imt_rel.old_member_id;

alter TABLE imt_member_current_disease_rel
	DROP COLUMN old_member_id;

alter TABLE imt_member_current_disease_rel
	DROP COLUMN old_current_disease_id;

ALTER TABLE imt_member_current_disease_rel
  ADD PRIMARY KEY (member_id, current_disease_id);



CREATE TABLE if not exists imt_member_eye_issue_rel
(
  member_id character varying(255) NOT NULL,
  eye_issue_id character varying(255)
);

alter TABLE imt_member_eye_issue_rel
	ADD COLUMN old_member_id character varying(255);

alter TABLE imt_member_eye_issue_rel
	ADD COLUMN old_eye_issue_id character varying(255);

update imt_member_eye_issue_rel set old_member_id = member_id , old_eye_issue_id = eye_issue_id;

alter TABLE imt_member_eye_issue_rel
	Drop COLUMN member_id;

alter TABLE imt_member_eye_issue_rel
	Drop COLUMN eye_issue_id;

alter TABLE imt_member_eye_issue_rel
	ADD COLUMN member_id bigint;

alter TABLE imt_member_eye_issue_rel
	ADD COLUMN eye_issue_id bigint;

update imt_member_eye_issue_rel set eye_issue_id = old_eye_issue_id::bigint;

update imt_member_eye_issue_rel imt_rel set member_id = mem.id  from imt_member mem where mem.oldid = imt_rel.old_member_id;

alter TABLE imt_member_eye_issue_rel
	DROP COLUMN old_member_id;

alter TABLE imt_member_eye_issue_rel
	DROP COLUMN old_eye_issue_id;

ALTER TABLE imt_member_eye_issue_rel
  ADD PRIMARY KEY (member_id, eye_issue_id);



CREATE TABLE if not exists imt_member_health_issue_rel
(
  member_id character varying(255) NOT NULL,
  health_issue_id character varying(255)
);

alter TABLE imt_member_health_issue_rel
	ADD COLUMN old_member_id character varying(255);

alter TABLE imt_member_health_issue_rel
	ADD COLUMN old_health_issue_id character varying(255);

update imt_member_health_issue_rel set old_member_id = member_id , old_health_issue_id = health_issue_id;

alter TABLE imt_member_health_issue_rel
	Drop COLUMN member_id;

alter TABLE imt_member_health_issue_rel
	Drop COLUMN health_issue_id;

alter TABLE imt_member_health_issue_rel
	ADD COLUMN member_id bigint;

alter TABLE imt_member_health_issue_rel
	ADD COLUMN health_issue_id bigint;

update imt_member_health_issue_rel set health_issue_id = old_health_issue_id::bigint;

update imt_member_health_issue_rel imt_rel set member_id = mem.id  from imt_member mem where mem.oldid = imt_rel.old_member_id;

alter TABLE imt_member_health_issue_rel
	DROP COLUMN old_member_id;

alter TABLE imt_member_health_issue_rel
	DROP COLUMN old_health_issue_id;

ALTER TABLE imt_member_health_issue_rel
  ADD PRIMARY KEY (member_id, health_issue_id);

ALTER TABLE imt_member
  ADD COLUMN old_current_state character varying(256);

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_member ADD COLUMN current_state character varying(255);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;

update imt_member set old_current_state  = current_state; 


CREATE TABLE if not exists imt_member_state_detail
(
 id character varying(255) NOT NULL,
 comment character varying(255),
 from_state character varying(255),
 member_id character varying(255),
 parent character varying(255),
 to_state character varying(255),
 CONSTRAINT imt_member_state_detail_pkey PRIMARY KEY (id)
);

ALTER TABLE imt_member_state_detail
  ADD COLUMN oldId character varying(256);

update imt_member_state_detail set oldId = id;

ALTER TABLE imt_member_state_detail
  DROP CONSTRAINT imt_member_state_detail_pkey;

ALTER TABLE imt_member_state_detail
  DROP COLUMN id;


ALTER TABLE imt_member_state_detail
  ADD COLUMN id bigserial;

ALTER TABLE imt_member_state_detail
  ADD PRIMARY KEY (id);


ALTER TABLE imt_member Drop COLUMN current_state;

ALTER TABLE imt_member Add COLUMN current_state bigint;

update imt_member mem set current_state = cur.id from imt_member_state_detail cur where cur.oldId = mem.old_current_state;


ALTER TABLE imt_family
  ADD COLUMN old_current_state character varying(256);

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_family ADD COLUMN current_state character varying(255);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;

update imt_family set old_current_state  = current_state; 


CREATE TABLE if not exists imt_family_state_detail
(
 id character varying(255) NOT NULL,
 comment character varying(255),
 family_id character varying(255),
 from_state character varying(255),
 parent character varying(255),
 to_state character varying(255),
 CONSTRAINT imt_family_state_detail_pkey PRIMARY KEY (id)
);

ALTER TABLE imt_family_state_detail
  ADD COLUMN oldId character varying(256);

update imt_family_state_detail set oldId = id;

ALTER TABLE imt_family_state_detail
  DROP CONSTRAINT imt_family_state_detail_pkey;

ALTER TABLE imt_family_state_detail
  DROP COLUMN id;


ALTER TABLE imt_family_state_detail
  ADD COLUMN id bigserial;

ALTER TABLE imt_family_state_detail
  ADD PRIMARY KEY (id);


ALTER TABLE imt_family Drop COLUMN current_state;

ALTER TABLE imt_family Add COLUMN current_state bigint;

update imt_family mem set current_state = cur.id from imt_family_state_detail cur where cur.oldId = mem.old_current_state;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_family_state_detail ADD COLUMN created_by bigint;
        EXCEPTION
            
            WHEN duplicate_column THEN 
            ALTER TABLE imt_family_state_detail ADD COLUMN old_created_by character varying(256);
            update imt_family_state_detail set old_created_by = created_by;
            ALTER TABLE imt_family_state_detail drop COLUMN created_by;
            ALTER TABLE imt_family_state_detail ADD COLUMN created_by bigint; 
            update imt_family_state_detail fam set old_created_by  = u.id from um_user u where u.user_name = fam.old_created_by;
            update imt_family_state_detail set created_by  = old_created_by::bigint where old_created_by <> 'dataloader';
            RAISE NOTICE 'Already exists';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_family_state_detail ADD COLUMN modified_by bigint;
        EXCEPTION
            WHEN duplicate_column THEN 
            ALTER TABLE imt_family_state_detail ADD COLUMN old_modified_by character varying(256);
            update imt_family_state_detail set old_modified_by = modified_by;
            ALTER TABLE imt_family_state_detail drop COLUMN modified_by;
            ALTER TABLE imt_family_state_detail ADD COLUMN modified_by bigint; 
            update imt_family_state_detail fam set old_modified_by  = u.id from um_user u where u.user_name = fam.old_modified_by;
            update imt_family_state_detail set modified_by  = old_modified_by::bigint where old_modified_by <> 'dataloader';
            RAISE NOTICE 'Already exists';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
		ALTER TABLE imt_family_state_detail
		ADD COLUMN modified_on timestamp without time zone;
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE imt_family_state_detail
	ADD COLUMN created_on timestamp without time zone;
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
 END;
    END;
$$;

ALTER TABLE imt_family_state_detail
  ADD COLUMN old_parent character varying(256);

update imt_family_state_detail set old_parent = parent;

ALTER TABLE imt_family_state_detail
  DROP COLUMN parent;

ALTER TABLE imt_family_state_detail
  ADD COLUMN parent bigint;

update imt_family_state_detail set parent = parent.id from imt_family_state_detail parent where parent.oldId = imt_family_state_detail.old_parent;


ALTER TABLE imt_member_state_detail
  ADD COLUMN old_parent character varying(256);

update imt_member_state_detail set old_parent = parent;

ALTER TABLE imt_member_state_detail
  DROP COLUMN parent;

ALTER TABLE imt_member_state_detail
  ADD COLUMN parent bigint;

update imt_member_state_detail set parent = parent.id from imt_member_state_detail parent where parent.oldId = imt_member_state_detail.old_parent;

DO $$ 
    BEGIN
        BEGIN
		ALTER TABLE imt_member
		ADD COLUMN is_report boolean;
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
		ALTER TABLE imt_member
		ADD COLUMN name_as_per_aadhar character varying(500);
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_member_state_detail ADD COLUMN created_by bigint;
        EXCEPTION
            WHEN duplicate_column THEN 
            ALTER TABLE imt_member_state_detail ADD COLUMN old_created_by character varying(256);
            update imt_member_state_detail set old_created_by = created_by;
            ALTER TABLE imt_member_state_detail drop COLUMN created_by;
            ALTER TABLE imt_member_state_detail ADD COLUMN created_by bigint; 
            update imt_member_state_detail fam set old_created_by  = u.id from um_user u where u.user_name = fam.old_created_by;
            update imt_member_state_detail set created_by  = old_created_by::bigint where old_created_by <> 'dataloader';
            RAISE NOTICE 'Already exists';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE imt_member_state_detail ADD COLUMN modified_by bigint;
        EXCEPTION
            WHEN duplicate_column THEN 
            ALTER TABLE imt_member_state_detail ADD COLUMN old_modified_by character varying(256);
            update imt_member_state_detail set old_modified_by = modified_by;
            ALTER TABLE imt_member_state_detail drop COLUMN modified_by;
            ALTER TABLE imt_member_state_detail ADD COLUMN modified_by bigint; 
            update imt_member_state_detail fam set old_modified_by  = u.id from um_user u where u.user_name = fam.old_modified_by;
            update imt_member_state_detail set modified_by  = old_modified_by::bigint where old_modified_by <> 'dataloader';
            RAISE NOTICE 'Already exists';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
		ALTER TABLE imt_member_state_detail
		ADD COLUMN modified_on timestamp without time zone;
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE imt_member_state_detail
	ADD COLUMN created_on timestamp without time zone;
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
 END;
    END;
$$;


ALTER TABLE imt_member_state_detail
 ADD COLUMN old_member_id character varying(256);

update imt_member_state_detail set old_member_id = member_id;

ALTER TABLE imt_member_state_detail
 DROP COLUMN member_id;

ALTER TABLE imt_member_state_detail
 ADD COLUMN member_id bigint;

update imt_member_state_detail set member_id = member.id from imt_member member where member.oldId = imt_member_state_detail.old_member_id;
