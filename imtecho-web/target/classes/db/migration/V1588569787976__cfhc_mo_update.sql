
delete from listvalue_field_value_detail  where value='Mark As False Death' and field_key='infra_type';

INSERT INTO listvalue_field_value_detail (value, code,is_active,last_modified_by,last_modified_on,file_size,is_archive,field_key)
select 'Mark As False Death','M',true,'superadmin',now(),0,false,'cfhc_death_verification_mo'
WHERE NOT EXISTS (select 1 from listvalue_field_value_detail  where value='Mark As False Death' and field_key='cfhc_death_verification_mo');
