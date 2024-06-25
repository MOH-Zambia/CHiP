DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE imt_family ADD COLUMN contact_person_id bigint;
EXCEPTION
        
            WHEN duplicate_column THEN 
            ALTER TABLE imt_family ADD COLUMN old_contact_person_id character varying(256);
            update imt_family set old_contact_person_id = contact_person_id;
            ALTER TABLE imt_family drop COLUMN contact_person_id; 
            ALTER TABLE imt_family ADD COLUMN contact_person_id bigint;
            update imt_family fam set contact_person_id = mem.id from imt_member mem where mem.oldid = fam.old_contact_person_id;
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

