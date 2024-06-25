insert into listvalue_field_master (field_key,field,is_active,field_type) 
select 'cfhc_death_verification_mo','cfhc_death_verification_mo',true,'T'
where not exists (select 1 from listvalue_field_master where field_key = 'cfhc_death_verification_mo');


INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
select 'Confirmed','C',true,'superadmin',now(),0,false,'cfhc_death_verification_mo'
WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Confirmed' and field_key='cfhc_death_verification_mo');


INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
select 'Mark As False Death','M',true,'superadmin',now(),0,false,'infra_type'
WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Mark As False Death' and field_key='cfhc_death_verification_mo');
