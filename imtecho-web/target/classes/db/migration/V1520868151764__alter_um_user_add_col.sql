DO $$ 
    BEGIN
        BEGIN
        ALTER TABLE um_user
            ADD COLUMN search_text character varying(1500);
EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;
update um_user um set search_text = um.user_name || ' ' || case when um.contact_number is null then '' else um.contact_number end || ' ' || um.first_name|| ' ' ||um.last_name || ' ' || case when um.aadhar_number is null then '' else um.aadhar_number end ||ur.name    from um_role_master ur where ur.id = um.role_id;