-- script for inserting system functions of crone job
delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.ChildPNCService' ;

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.ChildPNCService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.ChildRegistrationService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.ChildRegistrationService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.ChildTrackingMedicalService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.ChildTrackingMedicalService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.ChildTrackingService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.ChildTrackingService','','[]',-1,now());

delete from system_function_master  where name='uploadEligibleCouple' and class_name='com.argusoft.imtecho.anmol.service.EligibleCoupleService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('uploadEligibleCouple','com.argusoft.imtecho.anmol.service.EligibleCoupleService','','[]',-1,now());

delete from system_function_master  where name='uploadEliginleCouple' and class_name='com.argusoft.imtecho.anmol.service.EligibleCoupleTrackingService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('uploadEliginleCouple','com.argusoft.imtecho.anmol.service.EligibleCoupleTrackingService','','[]',-1,now());

delete from system_function_master  where name='uploadMothers' and class_name='com.argusoft.imtecho.anmol.service.MotherANCService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('uploadMothers','com.argusoft.imtecho.anmol.service.MotherANCService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.MotherDeliveryService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.MotherDeliveryService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.MotherInfrantService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.MotherInfrantService','','[]',-1,now());

delete from system_function_master  where name='uploadMothers' and class_name='com.argusoft.imtecho.anmol.service.MotherMadicalService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('uploadMothers','com.argusoft.imtecho.anmol.service.MotherMadicalService','','[]',-1,now());

delete from system_function_master  where name='upload' and class_name='com.argusoft.imtecho.anmol.service.MotherPNCService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('upload','com.argusoft.imtecho.anmol.service.MotherPNCService','','[]',-1,now());

delete from system_function_master  where name='uploadMothers' and class_name='com.argusoft.imtecho.anmol.service.MotherRegistrationService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('uploadMothers','com.argusoft.imtecho.anmol.service.MotherRegistrationService','','[]',-1,now());

delete from system_function_master  where name='updateMaxRefreshCount' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('updateMaxRefreshCount','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='updateAllActiveLocationsWithWorkerInfo' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('updateAllActiveLocationsWithWorkerInfo','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='checkIfChildIsDefaulter' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('checkIfChildIsDefaulter','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='pushNcdDataToDell' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('pushNcdDataToDell','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='createTemporaryMemberForMigrationIn' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('createTemporaryMemberForMigrationIn','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='dailyTipsNotificationsForMYTechoUsers' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('dailyTipsNotificationsForMYTechoUsers','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='checkRequestResponseList' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('checkRequestResponseList','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());

delete from system_function_master  where name='setSystemSyncConfig' and class_name='com.argusoft.imtecho.fhs.util.CroneService';

insert into system_function_master (name,class_name , description ,parameters ,created_by , created_on )
values ('setSystemSyncConfig','com.argusoft.imtecho.fhs.util.CroneService','','[]',-1,now());