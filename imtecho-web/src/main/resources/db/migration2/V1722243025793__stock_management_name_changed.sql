delete from mobile_feature_master where mobile_constant='STOCK_MANAGEMENT';

insert into mobile_feature_master (mobile_constant,feature_name,mobile_display_name,state,created_on,created_by,modified_on,modified_by)
values ('STOCK_MANAGEMENT','STOCK MANAGEMENT', 'Pharmacy','ACTIVE',now(),-1,now(),-1);