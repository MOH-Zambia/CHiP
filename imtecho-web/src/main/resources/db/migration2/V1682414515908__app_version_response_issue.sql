create table if not exists app_version_response(created_on timestamp without time zone);

delete from system_configuration where system_key = 'SCREENING_STATUS_RED';
insert into system_configuration values ('SCREENING_STATUS_RED', true, 'Please take rest and get yourself checked again, Refer to the nearest health facility or stabilization unit for further testing');

delete from system_configuration where system_key = 'SCREENING_STATUS_YELLOW';
insert into system_configuration values ('SCREENING_STATUS_YELLOW', true, 'Please take frequent breaks & get your health vitals checked regularly during the yatra, Refer to health facility in case of any symptoms');

delete from system_configuration where system_key = 'SCREENING_STATUS_GREEN';
insert into system_configuration values ('SCREENING_STATUS_GREEN', true, 'Please keep warm clothes like sweaters, jackets & appropriate medicines & devices (previously prescribed, if any)');