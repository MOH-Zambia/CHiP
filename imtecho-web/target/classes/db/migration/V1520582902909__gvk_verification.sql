CREATE TABLE if not exists gvk_verification
(
  id bigserial NOT NULL,
  created_on timestamp without time zone,
  family_id character varying(255),
  processing_time bigint,
  state character varying(255),
  status character varying(255),
  user_id bigint,
  CONSTRAINT gvk_verification_pkey PRIMARY KEY (id),
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint
);

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE gvk_verification ADD COLUMN userid bigint;
EXCEPTION
        
            WHEN duplicate_column THEN 
            ALTER TABLE gvk_verification
                ADD COLUMN oldUserId bigint;
            update gvk_verification set oldUserId = userid::bigint;
            ALTER TABLE gvk_verification
                ADD COLUMN user_id bigint;
            update gvk_verification set user_id = oldUserId; 
            RAISE NOTICE 'Already exists';
        END;
    END;
$$;

ALTER TABLE gvk_verification
  DROP COLUMN if exists userid;

ALTER TABLE gvk_verification
  DROP COLUMN if exists oldUserId;

ALTER TABLE gvk_verification
  DROP COLUMN if exists modified_by;

ALTER TABLE gvk_verification
  ADD COLUMN modified_by bigint;

ALTER TABLE gvk_verification
  DROP COLUMN if exists created_by;

ALTER TABLE gvk_verification
  ADD COLUMN created_by bigint;

ALTER TABLE gvk_verification
  DROP COLUMN if exists modified_on;

ALTER TABLE gvk_verification
  ADD COLUMN modified_on timestamp without time zone;
