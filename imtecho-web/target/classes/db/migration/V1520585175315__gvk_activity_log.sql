CREATE TABLE if not exists gvk_activity_log
(
  id bigserial NOT NULL ,
  state character varying(255),
  "timestamp" timestamp without time zone,
  user_id bigint,
  CONSTRAINT gvk_activity_log_pkey PRIMARY KEY (id),
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint
);

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_activity_log ADD COLUMN userid bigint;
EXCEPTION
        
            WHEN duplicate_column THEN 
            ALTER TABLE gvk_activity_log
            ADD COLUMN oldUserId bigint;

            update gvk_activity_log set oldUserId = userid::bigint;
            
            ALTER TABLE gvk_activity_log
            ADD COLUMN user_id bigint;
            update gvk_activity_log set userid = oldUserId;
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_activity_log ADD COLUMN created_on timestamp without time zone;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_activity_log ADD COLUMN modified_on timestamp without time zone;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_activity_log  ADD COLUMN created_by bigint;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_activity_log ADD COLUMN  modified_by bigint;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

ALTER TABLE gvk_activity_log
  DROP COLUMN if exists userid;

ALTER TABLE gvk_activity_log
  DROP COLUMN if exists oldUserId;
