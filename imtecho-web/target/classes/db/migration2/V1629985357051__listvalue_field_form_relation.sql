drop table if exists listvalue_field_form_relation;

create table listvalue_field_form_relation (
	field text,
	form_id integer
);


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('referralPlaces'),
        ('healthFacilityOptions'),
        ('videoSevereAnemia'),
        ('probableAnemiaVideo'),
        ('moderateAnemiaVideo')
) f(field)
where mfm.file_name = 'ANCMORB';


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc'),
        ('anccounselabtnutrition'),
        ('ancHomeVisitVideo'),
        ('dangerSignInANC'),
        ('newBornCareVideo'),
        ('ancSymptomAudio')
) f(field)
where mfm.file_name = 'ASHA_ANC';


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsChildFhwPnc'),
        ('cchvbreastfeedingvideo'),
        ('cchvstartingcomplimentaryvideo'),
        ('cchvimmunizationvideo'),
        ('cchvincreasingcomplimentaryvideo'),
        ('cchvdangersign')
) f(field)
where mfm.file_name = 'ASHA_CS';


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc')
) f(field)
where mfm.file_name = 'ASHA_LMPFU';


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc')
) f(field)
where mfm.file_name = 'ASHA_WPD';


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc'),
        ('pncmotherrelatedimage'),
        ('deathReasonsChildFhwPnc'),
        ('pncroutinenewborn'),
        ('pncdangersignnewborn'),
        ('pncinfoimages'),
        ('pncskinofbabyimages'),
        ('pncpustulesimages'),
        ('pncchestimages'),
        ('pncumbilicusimages'),
        ('pncabdomenimages'),
        ('pncBreastfeedingVideo'),
        ('pncbreastfeedingimage')
) f(field)
where mfm.file_name = 'ASHA_PNC';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('referralPlaces'),
        ('healthFacilityOptions'),
        ('feedingVideo'),
        ('feedingHabits')
) f(field)
where mfm.file_name = 'CCMORB';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('religionList'),
        ('casteList'),
        ('deathReasonsFhwAnc'),
        ('childDeathReasonsFhwCs'),
        ('maritalStatusList'),
        ('educationStatusList'),
        ('congenitalAnomalyList'),
        ('chronicDiseaseList'),
        ('currentDiseaseList'),
        ('eyeIssueList')
) f(field)
where mfm.file_name in ('CFHC', 'FHS', 'MEMBER_UPDATE');


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('ancVisitPlacesFhwAnc'),
        ('dangerousSignsFhwAnc'),
        ('referralPlaceFhwAnc'),
        ('deathReasonsFhwAnc')
) f(field)
where mfm.file_name = 'FHW_ANC';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('childDiseaseFhwCs'),
        ('childDeathReasonsFhwCs')
) f(field)
where mfm.file_name in ('FHW_CL', 'FHW_CS', 'SAM_SCREENING');



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc'),
        ('childDeathReasonsFhwCs')
) f(field)
where mfm.file_name in ('FHW_DEATH_CONF');



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc'),
        ('dangerSignsMotherFhwPnc'),
        ('referralPlaceFhwAnc'),
        ('deathReasonsChildFhwPnc'),
        ('dangerSignsChildFhwPnc')
) f(field)
where mfm.file_name = 'FHW_PNC';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('fpVideoRim')
) f(field)
where mfm.file_name = 'FHW_RIM';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('institutionsListFhwWpd'),
        ('deathReasonsFhwAnc'),
        ('deliveryDangerSignsFhwWpd'),
        ('referralPlaceFhwAnc'),
        ('congenitalDeformityFhwWpd'),
        ('institutionsListFhwWpd')
) f(field)
where mfm.file_name = 'FHW_WPD';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('Countries list')
) f(field)
where mfm.file_name in ('IDSP_MEMBER', 'IDSP_MEMBER_2');


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('religionList'),
        ('casteList'),
        ('maritalStatusList')
) f(field)
where mfm.file_name = 'IDSP_NEW_FAMILY';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('deathReasonsFhwAnc'),
        ('fpVideoLmp')
) f(field)
where mfm.file_name = 'LMPFU';



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('referralPlaces'),
        ('healthFacilityOptions'),
        ('referralPlaces')
) f(field)
where mfm.file_name = 'PNCMORB';



----------------------------------------------------------------------------


DELETE FROM QUERY_MASTER WHERE CODE='retrival_listvalues_mobile';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'789c459f-dabd-4c09-8327-44323becd39f', 58981,  current_date , 58981,  current_date , 'retrival_listvalues_mobile',
'roleId,lastUpdatedOn',
'with features as (
	select cast(CAST(jsonb_array_elements(CAST(config_json AS jsonb)) as jsonb)->>''mobile_constant'' as text) as const
	from mobile_menu_master mmm
	inner join mobile_menu_role_relation mmrr on mmm.id = mmrr.menu_id
	inner join um_role_master urm on mmrr.role_id  = urm.id
	where urm.id = #roleId#
), field_list as (
	select distinct lffr.field
	from features f
	inner join mobile_feature_master mfm on mfm.mobile_constant = f.const
	inner join mobile_form_feature_rel mffr on f.const = mffr.mobile_constant
	inner join mobile_form_details mfd on mfd.id = mffr.form_id
	inner join listvalue_field_form_relation lffr on lffr.form_id = mfd.id
	where mfm.state = ''ACTIVE''
)
select values.id as "idOfValue", fields.form as "formCode",
	fields.field as "field", fields.field_type as "fieldType", values.value as value,
    values.last_modified_on as "lastUpdateOfFieldValue", values.is_active as "isActive"
from listvalue_field_value_detail values
join listvalue_field_master fields on fields.field_key = values.field_key
where fields.field in (select * from field_list)
	and values.last_modified_on >= cast((case when ''#lastUpdatedOn#'' = ''null'' then ''1970-01-01 05:30:00.0'' else ''#lastUpdatedOn#'' end) as timestamp);',
null,
true, 'ACTIVE');