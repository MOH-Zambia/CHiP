update listvalue_field_value_detail set value='Amlodipine 5mg+Hydrochlorothiazide 12.5mg' where field_key='drugInventoryMedicine'
and value='LAmlodipine 5mg+Hydrochlorothiazide 12.5mg';


INSERT INTO listvalue_field_value_detail (file_size,last_modified_on,last_modified_by,is_archive,is_active,value,field_key)
select 0,now(),-1,false,true,'Telmiride H','drugInventoryMedicine'
where not exists (select * from listvalue_field_value_detail where value='Telmiride H' and field_key='drugInventoryMedicine'
);