drop table if exists report_offline_details;
create table report_offline_details(
    id serial,
    user_id Integer NOT NULL,
    report_id Integer NOT NULL,
    report_name varchar(250) NOT NULL,
    report_parameters text,
    file_id bigint,
    file_type varchar(250) NOT NULL,
    status varchar(250) NOT NULL,
    state varchar(250) NOT NULL,
    error text,
    completed_on  timestamp without time zone,
    created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT report_offline_details_pkey PRIMARY KEY(id)
);

comment ON TABLE report_offline_details IS 'This is table to store report offline request';
comment on column report_offline_details.id is 'Primary key of table';
comment on column report_offline_details.user_id is 'Id of logged in user';
comment on column report_offline_details.report_id is 'Id of requested report';
comment on column report_offline_details.report_name is 'Name of requested report';
comment on column report_offline_details.report_parameters is 'ReprotExcelDto in string';
comment on column report_offline_details.file_id is 'Id of generated file of report';
comment on column report_offline_details.file_type is 'Type of file. It can be pdf or excel';
comment on column report_offline_details.status is 'Status of report offline request. It can be NEW, PROCESSED, READY_FOR_DOWNLOAD, ERROR, ARCHIVED';
comment on column report_offline_details.state is 'State of report offline request. It can be Active or Inactive';
comment on column report_offline_details.error is 'If Any error occurred during processing report';
comment on column report_offline_details.completed_on is 'Completed of report processing timestamp';
comment on column report_offline_details.created_by is 'Id from um_user';
comment on column report_offline_details.created_on is 'Created on timestamp';
comment on column report_offline_details.modified_by is 'Id from um_user';
comment on column report_offline_details.modified_on is 'Modified on timestamp';

-- Create Report Offline Menu
delete from user_menu_item where menu_config_id  in (select id from menu_config mc where menu_name = 'Report Offline');

delete from menu_config where menu_name = 'Report Offline';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('Report Offline','manage',TRUE,'techo.manage.reportoffline','{}');


-- Create system function to remove report pdf file after 10 days
delete from system_function_master where name = 'deleteOfflineReport';
insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('deleteOfflineReport','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

-- Create system configuration for number of days to remove old reports
delete from system_configuration sc where system_key = 'NUMBER_OF_DAYS_TO_DELETE_FILE_IN_OFFLINE_REPORT';
insert into system_configuration (system_key,is_active,key_value) values ('NUMBER_OF_DAYS_TO_DELETE_FILE_IN_OFFLINE_REPORT',true,'10');

-- Create new module for offline report
delete from document_module_master where module_name = 'TECHO_OFFLINE_REPORTS';
INSERT INTO document_module_master(
            module_name, base_path, created_by, created_on)
    VALUES ('TECHO_OFFLINE_REPORTS', 'techo_offline_reports',-1 , now());