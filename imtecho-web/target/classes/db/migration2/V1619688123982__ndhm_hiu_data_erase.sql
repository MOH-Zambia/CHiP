-- Added column to store expiration date and data deleted date.

ALTER table ndhm_hiu_care_context_info
DROP column if exists data_expiration_date,
ADD column data_expiration_date timestamp without time zone,
DROP column if exists data_deleted_on,
ADD column data_deleted_on timestamp without time zone;

comment on column ndhm_hiu_care_context_info.data_expiration_date is 'Date on which health record is going to expired';
comment on column ndhm_hiu_care_context_info.data_deleted_on is 'Date on which data is deleted due to expiration';

-- Create system function to erase expired health records
delete from system_function_master where name = 'eraseExpiredHealthRecord';
insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('eraseExpiredHealthRecord','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());