ALTER table internationalization_label_master
drop column if exists app_name,
ADD COLUMN app_name character varying(50);

delete from internationalization_label_master where app_name = 'SOH';
delete from system_configuration where system_key = 'SOH_LOCALE_VERSION';
delete from system_configuration where system_key = 'SOH_COVID19_FIRST_TEST_DATE';
DELETE FROM QUERY_MASTER WHERE CODE='get_soh_labels';
DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_by_key';
DELETE FROM QUERY_MASTER WHERE CODE='get_soh_vaccine_name';
DELETE FROM QUERY_MASTER WHERE CODE='soh_performance_line_chart';




ALTER table soh_element_configuration
drop column if exists show_in_menu,
ADD COLUMN show_in_menu boolean;

update
	soh_element_configuration
set
	show_in_menu = true
where
	element_name = 'DATA_QUALITY' and is_hidden = false;


INSERT INTO system_configuration(
            system_key, is_active, key_value)
    VALUES ('SOH_LOCALE_VERSION', true,'1'),
    ('SOH_COVID19_FIRST_TEST_DATE',true,'2020-03-18');
/*
insert into internationalization_label_master(country,key,language,created_by,created_on,text,app_name)
values
('IN','StateOfHealth','EN',-1, current_date,'State of Health','SOH'),
('IN','InfantDeathHelp','EN',-1, current_date,'This will show the number of Infant deaths that occurred.','SOH'),
('IN','MaternalDeathHelp','EN',-1, current_date,'Maternal Death – This will show the number of Maternal deaths that occurred.','SOH'),
('IN','SexratioHelp','EN',-1, current_date,'Sex ratio at Birth – This will show the number of live birth girls to 1000 boys','SOH'),
('IN','InstDeliveriesHelp','EN',-1, current_date,'The number of institutional deliveries that happened as a percentage (This will include both still birth as well as live births)','SOH'),
('IN','MaternalAnemiaHelp','EN',-1, current_date,'This will be pie chart that shows the number and % of Severe Anemia (7 and less than 7) and Moderate Anemia (7.1 to 11) and Normal 11.1 and above who were identified in the last one week','SOH'),
('IN','LowBirthWeight','EN',-1, current_date,'This will show a pie chart with values for LBW (below 2.5) and VLBW (below 1.8) of all the live births','SOH'),
('IN','SAMHelp','EN',-1, current_date,'The number of new cases identified','SOH'),
('IN','ImmunizationHelp','EN',-1, current_date,'The number of children who were fully immunized out of the total number of children who should have been immunized','SOH'),
('IN','Help','EN',-1, current_date,'Help','SOH'),
('IN','Login','EN',-1, current_date,'Login','SOH'),
('IN','Logout','EN',-1, current_date,'Logout','SOH'),
('IN','UserName','EN',-1, current_date,'User Name (GoG Staff Only)','SOH'),
('IN','Password','EN',-1, current_date,'Password','SOH'),
('IN','Register','EN',-1, current_date,'Register','SOH'),
('IN','LoginWithCode','EN',-1, current_date,'Login with Code','SOH'),
('IN','Back','EN',-1, current_date,'Back','SOH'),
('IN','Code','EN',-1, current_date,'Code','SOH'),
('IN','IMRMessage1','EN',-1, current_date,'It''s indicating total number of live birth during selected time period','SOH'),
('IN','IMRMessage2','EN',-1, current_date,'It''s indicating total number of child death during selected time period','SOH'),
('IN','IMRMessage3','EN',-1, current_date,'It''s indicating % against estimated infant deaths.','SOH'),
('IN','MMRMessage1','EN',-1, current_date,'It''s indicating total number of live birth during selected time period','SOH'),
('IN','MMRMessage2','EN',-1, current_date,'It''s indicating total number of mother death during selected time period','SOH'),
('IN','MMRMessage3','EN',-1, current_date,'It''s indicating % against estimated maternal deaths.','SOH'),
('IN','IDMessage1','EN',-1, current_date,'It''s indicating total number of delivery during selected time period','SOH'),
('IN','IDMessage2','EN',-1, current_date,'It''s indicating total number of institution delivery during selected time period','SOH'),
('IN','IDMessage4','EN',-1, current_date,'It''s indicating % of institution delivery during selected time period','SOH'),
('IN','IDMessage3','EN',-1, current_date,'It''s indicating % of home delivery.','SOH'),
('IN','SRMessage1','EN',-1, current_date,'It''s indicating the number of live birth girls to 1000 boys during selected time period.','SOH'),
('IN','AnemiaMessage1','EN',-1, current_date,'The number of new cases identified as anemia in selected time period.','SOH'),
('IN','SAMMessage1','EN',-1, current_date,'The number of new cases identified in selected time period.','SOH'),
('IN','FIMessage1','EN',-1, current_date,'This will show total number of fully immunized children during selected time period.','SOH'),
('IN','FIMessage2','EN',-1, current_date,'This will show total number of partially or non-fully immunized children during selected time period.','SOH'),
('IN','FIMessage3','EN',-1, current_date,'This will be percentage of fully immunized children','SOH'),
('IN','PregRegMessage1','EN',-1, current_date,'It''s indicating total no of pregnancy registrations during selected time period.','SOH'),
('IN','PregRegMessage2','EN',-1, current_date,'It''s indicating % of early registrations against total registration','SOH'),
('IN','PregRegMessage3','EN',-1, current_date,'It''s indicating total no of early pregnancy registrations during selected time period.','SOH'),
('IN','LBWMessage1','EN',-1, current_date,'It''s indicating total number of babies weighed during selected time period.','SOH'),
('IN','LBWMessage2','EN',-1, current_date,'This will show very LBW and moderately LBW values of live births in selected time period.','SOH'),
('IN','ServiceVeriMessage1','EN',-1, current_date,'Total indicates, total number of service verified.','SOH'),
('IN','ServiceVeriMessage2','EN',-1, current_date,'False indicates, count of potentially wrong information entered by user as verified by call center.','SOH'),
('IN','HYPDMMessage1','EN',-1, current_date,'Number of person diagnosed for hypertension & diabetes','SOH'),
('IN','HYPDMMessage2','EN',-1, current_date,'Number of person diagnosed for hypertension & diabetes confirmed cases','SOH'),
('IN','DMMessage1','EN',-1, current_date,'It''s indicating total number of person diagnosed for diabetes','SOH'),
('IN','DMMessage2','EN',-1, current_date,'It''s indicating total number of person diagnosed for diabetes confirmed cases','SOH'),
('IN','DMMessage3','EN',-1, current_date,'It''s indicating % of screened against estimation','SOH'),
('IN','HYPMessage1','EN',-1, current_date,'Number of person diagnosed for hypertension','SOH'),
('IN','HYPMessage2','EN',-1, current_date,'Number of person diagnosed for hypertension confirmed cases','SOH'),
('IN','HYPMessage3','EN',-1, current_date,'It''s indicating % of screened against estimation','SOH'),
('IN','DateRange','EN',-1, current_date,'Date Range','SOH'),
('IN','AboutUs','EN',-1, current_date,'About us','SOH'),
('IN','HYPConfirmMessage1','EN',-1, current_date,'It''s indicating confirmed female for the hypertension','SOH'),
('IN','HYPConfirmMessage2','EN',-1, current_date,'It''s indicating confirmed male for the hypertension','SOH'),
('IN','DMConfirmMessage1','EN',-1, current_date,'It''s indicating confirmed female for the diabetes','SOH'),
('IN','DMConfirmMessage2','EN',-1, current_date,'It''s indicating confirmed male for the diabetes','SOH'),
('IN','AVGMessage1','EN',-1, current_date,'It''s indicating number of days required to complete one service','SOH'),
('IN','Birth','EN',-1, current_date,'Birth','SOH'),
('IN','PercentageSign','EN',-1, current_date,'%','SOH'),
('IN','Total','EN',-1, current_date,'Total','SOH'),
('IN','ID','EN',-1, current_date,'ID','SOH'),
('IN','IDPercentage','EN',-1, current_date,'ID %','SOH'),
('IN','Ratio','EN',-1, current_date,'Ratio','SOH'),
('IN','Severe','EN',-1, current_date,'Severe','SOH'),
('IN','SAM','EN',-1, current_date,'SAM','SOH'),
('IN','FI','EN',-1, current_date,'FI','SOH'),
('IN','NonFI','EN',-1, current_date,'Non-FI','SOH'),
('IN','Reg','EN',-1, current_date,'Reg.','SOH'),
('IN','EarlyReg','EN',-1, current_date,'Early Reg.','SOH'),
('IN','LBW','EN',-1, current_date,'LBW','SOH'),
('IN','Female','EN',-1, current_date,'Female','SOH'),
('IN','Male','EN',-1, current_date,'Male','SOH'),
('IN','AVG','EN',-1, current_date,'AVG','SOH'),
('IN','Screened','EN',-1, current_date,'Screened','SOH'),
('IN','FalseVeri','EN',-1, current_date,'False Veri.','SOH'),
('IN','ListNotAvailable','EN',-1, current_date,'Line list not available.','SOH'),
('IN','Moderate','EN',-1, current_date,'Moderate','SOH'),
('IN','Mild','EN',-1, current_date,'Mild','SOH'),
('IN','Normal','EN',-1, current_date,'Normal','SOH'),
('IN','Moderately','EN',-1, current_date,'Moderately','SOH'),
('IN','VeryLBW','EN',-1, current_date,'VeryLBW','SOH'),
('IN','MAM','EN',-1, current_date,'MAM','SOH'),
('IN','PermissionDeniedMessage','EN',-1, current_date,'You don''t have permission to view this','SOH'),
('IN','InvalidCodeMessage','EN',-1, current_date,'Invalid code','SOH'),
('IN','InavalidUsernameOrPasswordMessage','EN',-1, current_date,'Invalid username or password','SOH'),
('IN','SexRatio','EN',-1, current_date,'Sex Ratio','SOH'),
('IN','ConfirmedFemale','EN',-1, current_date,'Confirmed Female','SOH'),
('IN','ConfirmedMale','EN',-1, current_date,'Confirmed Male','SOH'),
('IN','LoginCode','EN',-1, current_date,'Please enter the code that was provided to you for logging in. In case you do not have the code, please use the register form by clicking here. If you have already registered, please wait for 24 hours or contact','SOH'),
('IN','AsExpected','EN',-1, current_date,'As expected','SOH'),
('IN','OverReporting','EN',-1, current_date,'Value is more than expected range.','SOH'),
('IN','UnderReporting','EN',-1, current_date,'Value is less than expected range.','SOH'),
('IN','URMessage','EN',-1, current_date,'Please verify under-reporting.','SOH'),
('IN','FemaleScreen','EN',-1, current_date,'Female Screen','SOH'),
('IN','MaleScreen','EN',-1, current_date,'Male Screen','SOH'),
('IN','DM','EN',-1, current_date,'Diabetes Mellitus','SOH'),
('IN','HTN','EN',-1, current_date,'Hypertension','SOH'),
('IN','LBWFullForm','EN',-1, current_date,'Low Birth Weight','SOH'),
('IN','SAMFullForm','EN',-1, current_date,'Severe Acute Malnutrition','SOH'),
('IN','FIFullForm','EN',-1, current_date,'Fully Immunized','SOH'),
('IN','Note','EN',-1, current_date,'Source of data: TeCHO','SOH'),
('IN','PW','EN',-1, current_date,'Pregnant women','SOH'),
('IN','Corporation','EN',-1, current_date,'Dot indicates Corporation','SOH'),
('IN','FIAfter1YearMsg','EN',-1, current_date,'This child has been immunised after 1 year so considering as a non-fully immunised','SOH'),
('IN','ASON','EN',-1, current_date,'As On','SOH'),
('IN','LoginDescription','EN',-1, current_date,'TeCHO+ State of Health has open access. Key Indicators and Metrics can be accessed by anyone without the need for login','SOH'),
('IN','AlreadyRegistered','EN',-1, current_date,'You are already register','SOH'),
('IN','RegisterDescription','EN',-1, current_date,'If you are a employee of the Health Department, GoG and have been asked to use the State of Health App by your seniors for monitoring health status in your area, please use your TeCHO+ ID or Code provided to you. In case you do not have this, please fill out the following form','SOH'),
--('IN','Name','EN',-1, current_date,'Name*','SOH'),
('IN','Designation','EN',-1, current_date,'Designation*','SOH'),
('IN','MobileNo','EN',-1, current_date,'Mobile No*','SOH'),
('IN','Organization','EN',-1, current_date,'Organization*','SOH'),
('IN','Purpose','EN',-1, current_date,'Purpose of using this application*','SOH'),
('IN','SendOtp','EN',-1, current_date,'Send OTP','SOH'),
('IN','OtpMobileNo','EN',-1, current_date,'We have send OTP to mobile No','SOH'),
('IN','OTP','EN',-1, current_date,'OTP*','SOH'),
('IN','Submit','EN',-1, current_date,'Submit','SOH'),
('IN','AboutDescription','EN',-1, current_date,'Gujarat Dashboard shows the key indicators and metrics in near real time for the public as well as the various Stakeholders in the department. The data shown is directly computed from the service data that is entered in TeCHO+.','SOH'),
('IN','OtherApps','EN',-1, current_date,'Other Apps in the TeCHO+ Eco System','SOH'),
('IN','Version','EN',-1, current_date,'Version','SOH'),
('IN','ReleaseDate','EN',-1, current_date,'ReleaseDate','SOH'),
('IN','Citizens','EN',-1, current_date,'For the Citizens','SOH'),
('IN','Practitioners','EN',-1, current_date,'For Private Practitioners','SOH'),
('IN','FLHW','EN',-1, current_date,'For the FLHW','SOH'),
('IN','MyTeCHO','EN',-1, current_date,'MyTeCHO','SOH'),
('IN','DrTeCHO','EN',-1, current_date,'Dr.TeCHO','SOH'),
('IN','TeCHO+','EN',-1, current_date,'TeCHO+','SOH'),
('IN','Covid19Facilities','EN',-1, current_date,'COVID2019 Facilities','SOH'),
('IN','BedUtilization','EN',-1, current_date,'Bed Utilization %','SOH'),
('IN','VentiUtilization','EN',-1, current_date,'Venti Utilization %','SOH'),
('IN','PeopleTested','EN',-1, current_date,'People Tested','SOH'),
('IN','SampleTested','EN',-1, current_date,'Sample Tested','SOH'),
('IN','FacilityName','EN',-1, current_date,'Facility Name','SOH'),
('IN','TestingCenterDetails','EN',-1, current_date,'Testing Center Details','SOH'),
('IN','TotalSampleTested','EN',-1, current_date,'Total Sample Tested','SOH'),
('IN','SampleTestedToday','EN',-1, current_date,'Sample Tested Today','SOH'),
('IN','Members','EN',-1, current_date,'Members','SOH'),
('IN','Suspected','EN',-1, current_date,'Suspected','SOH'),
('IN','Positives','EN',-1, current_date,'Positives','SOH'),
('IN','PositivesNotInFacility','EN',-1, current_date,'Positives Not in Facility','SOH'),
('IN','Discharged','EN',-1, current_date,'Discharged','SOH'),
('IN','Deaths','EN',-1, current_date,'Deaths','SOH'),
('IN','ActiveCases','EN',-1, current_date,'Active Cases','SOH'),
('IN','Critical','EN',-1, current_date,'Critical','SOH'),
('IN','StableModerate','EN',-1, current_date,'Stable Moderate','SOH'),
('IN','StableMild','EN',-1, current_date,'Stable Mild','SOH'),
('IN','Asymptomatic','EN',-1, current_date,'Asymptomatic','SOH'),
('IN','Occupied','EN',-1, current_date,'Occupied','SOH'),
('IN','Free','EN',-1, current_date,'Free','SOH'),
('IN','BeingAdded','EN',-1, current_date,'Being Added','SOH'),
('IN','VentilatorDetails','EN',-1, current_date,'Ventilator Details','SOH'),
('IN','BedDetails','EN',-1, current_date,'Bed Details','SOH'),
('IN','InUse','EN',-1, current_date,'In use','SOH'),
('IN','PPEDetails','EN',-1, current_date,'P.P.E Details','SOH'),
('IN','Balance','EN',-1, current_date,'Balance','SOH'),
('IN','Added','EN',-1, current_date,'Added','SOH'),
('IN','Consumed','EN',-1, current_date,'Consumed','SOH'),
('IN','NoDataAvailable','EN',-1, current_date,'No data available','SOH'),
('IN','NoAreaAvailable','EN',-1, current_date,'No Area available','SOH'),
('IN','StandBy','EN',-1, current_date,'Stand By','SOH'),
('IN','FieldMobileNo','EN',-1, current_date,'Mobile No','SOH'),
('IN','PatientsAdmittedBetween','EN',-1, current_date,'Patients admitted between','SOH'),
('IN','Days','EN',-1, current_date,'Days','SOH'),
('IN','MoreThan30','EN',-1, current_date,'More than 30','SOH'),
('IN','to','EN',-1, current_date,'to','SOH'),
('IN','ActiveName','EN',-1, current_date,'Name','SOH'),
('IN','Gender','EN',-1, current_date,'Gender','SOH'),
('IN','Facility','EN',-1, current_date,'Facility','SOH'),
('IN','Address','EN',-1, current_date,'Address','SOH'),
('IN','Age','EN',-1, current_date,'Age','SOH'),
('IN','HealthState','EN',-1, current_date,'Health State','SOH'),
('IN','AdmissionDate','EN',-1, current_date,'Admission Date','SOH'),
('IN','Comorbidity','EN',-1, current_date,'Comorbidity','SOH'),
('IN','COVID2019HeatMap','EN',-1, current_date,'COVID2019 Heat Map','SOH'),
('IN','Indicator','EN',-1, current_date,'Indicator','SOH'),
('IN','SelectIndicator','EN',-1, current_date,'Select Indicator','SOH'),
('IN','CaseTaggings','EN',-1, current_date,'Case Taggings','SOH'),
('IN','HeatMap','EN',-1, current_date,'HeatMap','SOH'),
('IN','ShowCount','EN',-1, current_date,'Show Count','SOH'),
('IN','Member','EN',-1, current_date,'Member','SOH'),
('IN','HeadOfFamily','EN',-1, current_date,'Head of Family','SOH'),
('IN','ContactPerson','EN',-1, current_date,'Contact Person','SOH'),
('IN','BirthWeight','EN',-1, current_date,'Birth Weight','SOH'),
('IN','Reason','EN',-1, current_date,'Reason','SOH'),
('IN','VerifiedOn','EN',-1, current_date,'Verified On','SOH'),
('IN','LMPDate','EN',-1, current_date,'LMP Date','SOH'),
('IN','PregancyRegDate','EN',-1, current_date,'Pregancy Reg. Date','SOH'),
('IN','Weight','EN',-1, current_date,'Weight','SOH'),
--('IN','Height','EN',-1, current_date,'Height','SOH'),
('IN','DateOfBirth','EN',-1, current_date,'Date of Birth','SOH'),
('IN','AgeGroup','EN',-1, current_date,'Age Group','SOH'),
('IN','MUAC','EN',-1, current_date,'MUAC','SOH'),
('IN','ZScore','EN',-1, current_date,'Z Score','SOH'),
--('IN','DeliveryDate','EN',-1, current_date,'Delivery Date','SOH'),
--('IN','DeliveryDoneBy','EN',-1, current_date,'Delivery Done By','SOH'),
('IN','DeathDate','EN',-1, current_date,'Death Date','SOH'),
('IN','DeathReason','EN',-1, current_date,'Death Reason','SOH'),
('IN','DeathLocation','EN',-1, current_date,'Death Location','SOH'),
('IN','ServiceType','EN',-1, current_date,'Service Type','SOH'),
('IN','Hemoglobin','EN',-1, current_date,'Hemoglobin','SOH'),
('IN','TtVerificationStatus','EN',-1, current_date,'TT Verification Status','SOH'),
('IN','DeliveryVerificationStatus','EN',-1, current_date,'Delivery Verification Status','SOH'),
('IN','DeliveryPlaceVerificationStatus','EN',-1, current_date,'Delivery Place Verification Status','SOH'),
('IN','NoOfGenderVerification','EN',-1, current_date,'No of Child & Gender Verification','SOH'),
('IN','VaccinationVerificationStatus','EN',-1, current_date,'Child Vaccination Verification Status','SOH'),
('IN','DiagnosisType','EN',-1, current_date,'Diagnosis Type','SOH'),
('IN','DiagnosisOn','EN',-1, current_date,'Diagnosis On','SOH'),
('IN','ANM','EN',-1, current_date,'ANM','SOH'),
('IN','ASHA','EN',-1, current_date,'ASHA','SOH'),
('IN','GivenVaccinations','EN',-1, current_date,'Given Vaccinations','SOH'),
('IN','Vaccination','EN',-1, current_date,'Vaccination','SOH'),
('IN','GivenDate','EN',-1, current_date,'Given Date','SOH'),
('IN','None','EN',-1, current_date,'None','SOH'),
('IN','OverdueVaccinations','EN',-1, current_date,'Overdue Vaccinations','SOH'),
('IN','OtherVaccinations','EN',-1, current_date,'Other Vaccinations','SOH'),
('IN','MemberLineListNote','EN',-1, current_date,'Note','SOH'),
('IN','More','EN',-1, current_date,'More','SOH'),
('IN','Less','EN',-1, current_date,'Less','SOH'),
('IN','ShowMore','EN',-1, current_date,'Show More','SOH'),
('IN','ServerDownText','EN',-1, current_date,'Application not able to communicate with server.','SOH'),
('IN','CheckInternetConnection','EN',-1, current_date,'Please check internet connection.','SOH'),
('IN','MaintenanceMode','EN',-1, current_date,'Server might be in maintenance mode.','SOH'),
('IN','MajorHealthSector','EN',-1, current_date,'Major Health Sector','SOH'),
('IN','LastServiceDate','EN',-1, current_date,'Last Service Date','SOH'),
('IN','SomethingWentWrong','EN',-1, current_date,'Something went wrong. Please contact your administrator','SOH'),
('IN','StatusReport','EN',-1, current_date,'Status Report','SOH'),
('IN','MarkerInformation','EN',-1, current_date,'Marker Information','SOH'),
('IN','LastMarker','EN',-1, current_date,'Last marker','SOH'),
('IN','Marker','EN',-1, current_date,'@Marker','SOH'),
('IN','New','EN',-1, current_date,'New','SOH'),
('IN','Tested','EN',-1, current_date,'Tested','SOH'),
('IN','Positive','EN',-1, current_date,'Positive','SOH'),
('IN','Dead','EN',-1, current_date,'Dead','SOH'),
('IN','NewPositives','EN',-1, current_date,'New Positives','SOH'),
('IN','ReportedDate','EN',-1, current_date,'Reported Date','SOH'),
('IN','DOD','EN',-1, current_date,'DOD','SOH'),
('IN','NewDeaths','EN',-1, current_date,'New Deaths','SOH'),
('IN','NewDischarged','EN',-1, current_date,'New Discharged','SOH'),
('IN','UnauthorizedAccess','EN',-1, current_date,'Unauthorized Access','SOH'),
('IN','ContactAdmin','EN',-1, current_date,'Please contact administrator.','SOH'),
('IN','UnderMaintenance','EN',-1, current_date,'Under Maintenance','SOH'),
('IN','MaintenanceDescription','EN',-1, current_date,'Our website is currently undergoing scheduled maintenance. We will be back shorlty. Thank you for your patience','SOH'),
('IN','MaintenanceButtonText','EN',-1, current_date,'Ok','SOH'),
('IN','DataQuality','EN',-1, current_date,'Data Quality','SOH'),
('IN','LoginRequired','EN',-1, current_date,'Login required','SOH'),
('IN','LoginRequiredDescription','EN',-1, current_date,'Please login to view this information.','SOH'),
('IN','Cancel','EN',-1, current_date,'Cancel','SOH'),
('IN','GotoLogin','EN',-1, current_date,'GotoLogin','SOH'),
('IN','Close','EN',-1, current_date,'Close','SOH'),
('IN','ErrorMsg','EN',-1, current_date,'Something went wrong...!!','SOH'),
('IN','RegisterSuccess','EN',-1, current_date,'Register success','SOH'),
('IN','SuccessRegistration','EN',-1, current_date,'Thank you for registration. We will inform your login code soon.','SOH'),
('IN','ProblemWithReg','EN',-1, current_date,'Problem while registration.','SOH'),
('IN','FillAllFields','EN',-1, current_date,'Please fill all the fields','SOH'),
('IN','InvalidMobileNo','EN',-1, current_date,'Please enter valid mobile no','SOH'),
('IN','UpdateAvailable','EN',-1, current_date,'Update available','SOH'),
('IN','UpdateDescription','EN',-1, current_date,'Updated app available in store. Please update it for better experience.','SOH'),
('IN','Update','EN',-1, current_date,'Update','SOH'),
('IN','Skip','EN',-1, current_date,'Skip','SOH'),
('IN','MyLocation','EN',-1, current_date,'My location','SOH'),
('IN','StatusZero','EN',-1, current_date,'Application is not able to communicate with server, either internet connection/server is down.','SOH');
*/


INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'429210a6-4485-4ebc-84cb-85837a14c099', 74909,  current_date , 74909,  current_date , 'get_soh_labels',
 null,
'select
	label."language",
	cast( json_agg( json_build_object( label.key, label.text )) as text ) as "labels"
from
	internationalization_label_master label
where
	label.app_name = ''SOH''
group by
	label."language"',
null,
true, 'ACTIVE');


INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7a9306e5-c52c-47b9-881a-1ac14dd50bb9', 74909,  current_date , 74909,  current_date , 'retrieve_system_by_key',
 null,
'select key_value from system_configuration where system_key = ''SOH_LOCALE_VERSION''',
null,
true, 'ACTIVE');



INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'51fe0482-f01f-4d7e-824e-8e08f7129fb5', 74909,  current_date , 74909,  current_date , 'get_soh_vaccine_name',
 null,
'select cast(''{
    "HEPATITIS_B_0":"HEPATITIS B 0",
    "OPV_0":"OPV 0",
    "OPV_1":"OPV 1",
    "OPV_2":"OPV 2",
    "OPV_3":"OPV 3",
    "BCG":"BCG",
    "PENTA_1":"PENTA 1",
    "PENTA_2":"PENTA 2",
    "PENTA_3":"PENTA 3",
    "VITAMIN_A":"VITAMIN A",
    "VITAMIN_K":"VITAMIN K",
    "F_IPV_1_01":"F IPV 1 01",
    "F_IPV_2_01":"F IPV 2 01",
    "F_IPV_2_05":"F IPV 2 05",
    "MEASLES_RUBELLA_1":"MEASLES RUBELLA 1",
    "MEASLES_RUBELLA_2":"MEASLES RUBELLA 2",
    "ROTA_VIRUS_3":"ROTA VIRUS 3",
    "ROTA_VIRUS_2":"ROTA VIRUS 2",
    "ROTA_VIRUS_1":"ROTA VIRUS 1",
    "OPV_BOOSTER":"OPV BOOSTER",
    "DPT_BOOSTER":"DPT BOOSTER",
    "DPT_1":"DPT 1",
    "DPT_2":"DPT 2",
    "DPT_3":"DPT 3",
    "MMR":"MMR",
    "HIB_2":"HIB 2",
    "HEPATITIS_B_1":"HEPATITIS B 1",
    "CHICKEN_POX":"CHICKEN POX",
    "HEPATITIS_A_1":"HEPATITIS A 1",
    "MEASLES_1":"MEASLES 1",
    "HEPATITIS_B_3":"HEPATITIS B 3",
    "HIB_1":"HIB 1",
    "JE":"JE",
    "DPT_BOOSTER_2":"DPT BOOSTER 2",
    "HEPATITIS_A_2":"HEPATITIS A 2",
    "TT_16":"TT 16",
    "HIB_3":"HIB 3",
    "MEASLES_2":"MEASLES 2",
    "TYPHOID":"TYPHOID",
    "HEPATITIS_B_2":"HEPATITIS B 2",
    "TT_10":"TT 10"
}'' as text) as "VACCINATION_NAME"',
null,
true, 'ACTIVE');

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e616fb90-ce62-4e16-bfbc-be375da62cd0', 74909,  current_date , 74909,  current_date , 'soh_performance_line_chart',
'locationId',
'with json_to_row as (
select
	json_array_elements(cast(configuration_json as json)) as fields,
	from_date,
	to_date,
	id
from
	soh_chart_configuration
),
chart_details as (
select
	jtr.id,
	jtr.from_date,
	jtr.to_date,
	json_array_elements(jtr.fields -> ''fields'') as config,
	jtr.fields ->> ''elementName'' as element_name,
	jtr.fields ->> ''color'' as color,
	jtr.fields ->> ''displayName'' as display_name
from
	json_to_row jtr),
json_with_row_number as (
select
	*,
	row_number () over() as serial
from
	chart_details
),
axis_data as (
select
	*,
	row_to_json(t) as json
from
	(
	select
		jtr.element_name as name,
		jtr.color as color,
		jtr.display_name as display_name,
		jtr.id,
		array_agg(
		    case
		        when jtr.config ->> ''field'' = ''chart1'' then cast(coalesce(soh.chart1, 0) as text)
		        when jtr.config ->> ''field'' = ''timeline'' then (
                    case
                        when soh.timeline_sub_type = ''DAY'' then concat(''Day '', (cast(timeline_type as date) - cast((select key_value from system_configuration where system_key = ''SOH_COVID19_FIRST_TEST_DATE'') as date)))
                        else to_char(cast(soh.timeline_type as date),''DD-Mon'')
                    end
                )
                when jtr.config ->> ''field'' = ''chart2'' then cast(coalesce(soh.chart2, 0) as text)
                when jtr.config ->> ''field'' = ''chart3'' then cast(coalesce(soh.chart3, 0) as text)
                when jtr.config ->> ''field'' = ''chart4'' then cast((soh.chart4, 0) as text)
                when jtr.config ->> ''field'' = ''chart5'' then cast(soh.chart5 as text)
		        when jtr.config ->> ''field'' = ''chart6'' then cast(soh.chart6 as text)
                when jtr.config ->> ''field'' = ''chart7'' then cast(soh.chart7 as text)
                when jtr.config ->> ''field'' = ''chart8'' then cast(soh.chart8 as text)
                when jtr.config ->> ''field'' = ''chart9'' then cast(soh.chart9 as text)
                when jtr.config ->> ''field'' = ''chart10'' then cast(soh.chart10 as text)
                when jtr.config ->> ''field'' = ''chart11'' then cast(soh.chart11 as text)
                when jtr.config ->> ''field'' = ''chart12'' then cast(soh.chart12 as text)
                when jtr.config ->> ''field'' = ''chart13'' then cast(soh.chart13 as text)
                when jtr.config ->> ''field'' = ''chart14'' then cast(soh.chart14 as text)
                when jtr.config ->> ''field'' = ''chart15'' then cast(soh.chart15 as text)
                when jtr.config ->> ''field'' = ''percentage'' then cast(coalesce(soh.percentage, 0) as text)
                when jtr.config ->> ''field'' = ''displayValue'' then cast(soh.displayValue as text)
                when jtr.config ->> ''field'' = ''value'' then cast(coalesce(soh.value, 0) as text)
                when jtr.config ->> ''field'' = ''calculatedTarget'' then cast(soh.calculatedTarget as text)
            end order by cast(soh.timeline_type as date) asc) as value,
		jtr.config ->> ''type'' as "axis"
	from
		soh_timeline_analytics_temp soh
	inner join json_with_row_number jtr on
		jtr.element_name = soh.element_name
	where
		soh.timeline_sub_type IN (''DATE'',''DAY'')
		and soh.location_id = #locationId#
        and cast(soh.timeline_type as date) between jtr.from_date and jtr.to_date
	group by
		jtr.id,
		jtr.element_name,
		jtr.config ->> ''type'',
		jtr.color,
		jtr.display_name) as t),
result_set as (
select
	t.id,
	json_agg(t) as element_name
from
	(
	select
		id,
		name,
		json_agg(json) as json
	from
		axis_data
	group by
		id,
		name,
		color) as t
group by
	id
)
select
	scc.id,
	name,
    module as module,
	display_name,
    chart_type as "chartType",

	cast(element_name as text) as data
from
	result_set rs
	inner join soh_chart_configuration scc
	on scc.id = rs.id',
null,
true, 'ACTIVE');
