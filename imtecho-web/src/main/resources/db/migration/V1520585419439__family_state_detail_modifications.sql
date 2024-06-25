--To modify the length of comment column in family state detail column
ALTER TABLE imt_family_state_detail
     ALTER COLUMN comment
         TYPE character varying(4000);
