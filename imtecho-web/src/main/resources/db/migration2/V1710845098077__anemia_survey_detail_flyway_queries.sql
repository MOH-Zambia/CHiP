insert into menu_config(active,menu_name,navigation_state,menu_type)
select true,'Anemia Survey List','techo.manage.anemiasurveylist','manage'
WHERE NOT exists(select 1 from menu_config where menu_name='Anemia Survey List');



CREATE TABLE IF NOT EXISTS anemia_survey_verification_details (
	id serial4 NOT NULL,
	anemia_survey_id int4 NULL,
	member_id int4 NULL,
	verification_date date NULL,
	is_anemia_conjunctiva_approved bool NULL,
	is_anemia_external_left_eye_approved bool NULL,
	is_anemia_external_right_eye_approved bool NULL,
	is_anemia_fingernails_closed_approved bool NULL,
	is_anemia_fingernails_open_approved bool NULL,
	is_anemia_tongue_approved bool NULL,
	created_on timestamp NULL,
	modified_on timestamp NULL,
	created_by int4 NULL,
	midified_by int4 NULL,
	CONSTRAINT anemia_survey_verification_details_pkey PRIMARY KEY (id)
);


DELETE FROM QUERY_MASTER WHERE CODE='get_anemia_survey_member_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd3f1ef8a-a5d5-4b8a-82e6-a1f158206457', 97080,  current_date , 97080,  current_date , 'get_anemia_survey_member_list',
'location_id,status',
'select
	amd.id as id,
    msdm.id as member_id,
	get_location_hierarchy_by_type(msdm.location_id,''SC'') as sc,
	lm.name as village,
    get_location_hierarchy(msdm.location_id) as location,
    concat_ws('' '', first_name, middle_name, last_name) as name ,
	amd.patient_uuid as uuid,
	EXTRACT(YEAR FROM age(current_date, msdm.dob))  as age,
	msdm.gender as gender,
	amd.hemoglobin as hemoglobin,
	msdm.is_pregnant,
	case when asvd.id is not null then ''VERIFIED''
		else ''PENDING'' end as status,
	 is_anemia_conjunctiva_approved,
	 is_anemia_external_left_eye_approved,
 	 is_anemia_external_right_eye_approved,
  	 is_anemia_fingernails_closed_approved,
   	 is_anemia_fingernails_open_approved,
 	 is_anemia_tongue_approved
from member_survey_detail_master msdm
inner join anemia_member_detail amd on amd.member_id = msdm.id
inner join location_hierchy_closer_det lhcd2 on
	Case when #location_id# is NULL then lhcd2.parent_loc_type = ''S'' and lhcd2.child_id=msdm.location_id
 		else lhcd2.parent_id = #location_id# and lhcd2.child_id=msdm.location_id end
left join anemia_survey_verification_details asvd on asvd.anemia_survey_id = amd.id
left join location_hierchy_closer_det lhcd on lhcd.child_id = msdm.location_id
	and lhcd.parent_loc_type=''V''
left join location_master lm on lm.id = lhcd.parent_id
where case when #status# = ''ALL'' or #status# is NULL then true
		when #status# = ''PENDING'' then asvd.id is null
		when #status# = ''VERIFIED'' then asvd.id is not null end
group by amd.id,msdm.id,lm.name,msdm.location_id,first_name, middle_name, last_name,
	amd.patient_uuid,amd.status,msdm.dob,msdm.gender,amd.hemoglobin,msdm.is_pregnant,asvd.id,
	is_anemia_conjunctiva_approved, is_anemia_external_left_eye_approved,
 	is_anemia_external_right_eye_approved, is_anemia_fingernails_closed_approved,
   	is_anemia_fingernails_open_approved,is_anemia_tongue_approved
order by amd.id,msdm.id,lm.name,msdm.location_id,first_name, middle_name, last_name,
	amd.patient_uuid,amd.status,msdm.dob,msdm.gender,amd.hemoglobin,msdm.is_pregnant,asvd.id,
	is_anemia_conjunctiva_approved, is_anemia_external_left_eye_approved,
 	is_anemia_external_right_eye_approved, is_anemia_fingernails_closed_approved,
   	is_anemia_fingernails_open_approved,is_anemia_tongue_approved',
'Get Member List of Anemia Survey',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_anemia_survey_details_by_anemia_survey_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd5fcf467-622d-4686-ba03-759a04a9116a', 97080,  current_date , 97080,  current_date , 'get_anemia_survey_details_by_anemia_survey_id',
'anemiaSurveyId',
'select
	amd.id as id,
    msdm.id as member_id,
	get_location_hierarchy_by_type(msdm.location_id,''SC'') as sc,
	lm.name as village,
    get_location_hierarchy(msdm.location_id) as location,
    concat_ws('' '', first_name, middle_name, last_name) as name ,
	amd.patient_uuid as uuid,
	EXTRACT(YEAR FROM age(current_date, msdm.dob))  as age,
	msdm.gender as gender,
	amd.hemoglobin as hemoglobin,
	msdm.is_pregnant,
	case when asvd.id is not null then ''VERIFIED''
		else ''PENDING'' end as status,
	 is_anemia_conjunctiva_approved,
	 is_anemia_external_left_eye_approved,
 	 is_anemia_external_right_eye_approved,
  	 is_anemia_fingernails_closed_approved,
   	 is_anemia_fingernails_open_approved,
 	 is_anemia_tongue_approved
from member_survey_detail_master msdm
inner join anemia_member_detail amd on amd.member_id = msdm.id
left join anemia_survey_verification_details asvd on asvd.anemia_survey_id = amd.id
left join location_hierchy_closer_det lhcd on lhcd.child_id = msdm.location_id
	and lhcd.parent_loc_type=''V''
left join location_master lm on lm.id = lhcd.parent_id
where amd.id = #anemiaSurveyId#',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_into_anemia_survey_verification_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8a8a5c61-626c-4db5-b0c2-667930f19c74', 97080,  current_date , 97080,  current_date , 'insert_into_anemia_survey_verification_details',
'isAnemiaFingernailsOpenApproved,isAnemiaExternalLeftEyeApproved,isAnemiaFingernailsClosedApproved,isAnemiaTongueApproved,anemiaSurveyId,loggedInUserId,isAnemiaConjunctivaApproved,verificationDate,isAnemiaExternalRightEyeApproved,memberId',
'INSERT INTO anemia_survey_verification_details
( anemia_survey_id,member_id, verification_date, is_anemia_conjunctiva_approved, is_anemia_external_left_eye_approved,
 is_anemia_external_right_eye_approved, is_anemia_fingernails_closed_approved, is_anemia_fingernails_open_approved,
 is_anemia_tongue_approved, created_on, created_by)

 select
 #anemiaSurveyId#,
 #memberId#,
 cast (#verificationDate# as date),
 case when #isAnemiaConjunctivaApproved# = ''true'' then true
 	when #isAnemiaConjunctivaApproved# = ''false'' then false
	else null end,
 case when #isAnemiaExternalLeftEyeApproved# = ''true'' then true
 	when #isAnemiaExternalLeftEyeApproved# = ''false'' then false
	else null end,
 case when #isAnemiaExternalRightEyeApproved# = ''true'' then true
 	when #isAnemiaExternalRightEyeApproved# = ''false'' then false
	else null end,
 case when #isAnemiaFingernailsClosedApproved# = ''true'' then true
 	when #isAnemiaFingernailsClosedApproved# = ''false'' then false
	else null end,
 case when #isAnemiaFingernailsOpenApproved# = ''true'' then true
 	when #isAnemiaFingernailsOpenApproved# = ''false'' then false
	else null end,
 case when #isAnemiaTongueApproved# = ''true'' then true
 	when #isAnemiaTongueApproved# = ''false'' then false
	else null end,
 now(),
 #loggedInUserId#;',
null,
false, 'ACTIVE');