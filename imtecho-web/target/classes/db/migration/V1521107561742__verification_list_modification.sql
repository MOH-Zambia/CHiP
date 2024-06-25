DO $$ 
   BEGIN
       BEGIN
           ALTER TABLE imt_family_verification
ADD COLUMN call_attempt integer DEFAULT 0;
       EXCEPTION
           WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
       END;
   END;
$$;

ALTER TABLE imt_family_verification
  DROP COLUMN if exists head;

ALTER TABLE imt_family_verification
  DROP COLUMN if exists mobile_number;