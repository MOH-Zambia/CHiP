delete from system_configuration where system_key = 'MINIO_API_FOLDER_PREFIX';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('MINIO_API_FOLDER_PREFIX', true, 'Sensory/Participant_');

delete from system_configuration where system_key = 'MINIO_API_BUCKET_NAME';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('MINIO_API_BUCKET_NAME', true,'sewa-rural');

--inserting function in crone service to db used to delete older then 1 day MinIO stored image data.
INSERT INTO system_function_master
("name", class_name, parameters, created_by, created_on)
VALUES('deleteMinIOStoredImageFiles', 'com.argusoft.imtecho.fhs.util.CroneService', '[]' , -1, now());


DELETE FROM QUERY_MASTER WHERE CODE='get_anemia_survey_member_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd3f1ef8a-a5d5-4b8a-82e6-a1f158206457', 97080,  current_date , 97080,  current_date , 'get_anemia_survey_member_list',
'loggedInUserId,location_id,status',
'select
	amd.id as id,
    msdm.id as member_id,
    get_location_hierarchy(msdm.location_id) as location_hierarchy,
	lm.name as location,
	amd.service_date as service_date,
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
	Case when #location_id# is NULL then lhcd2.parent_id in (select loc_id from um_user_location where user_id = #loggedInUserId#
							 and state = ''ACTIVE'')
				and lhcd2.child_id=msdm.location_id
 		else lhcd2.parent_id = #location_id# and lhcd2.child_id=msdm.location_id end
inner join location_master lm on lm.id = msdm.location_id
left join anemia_survey_verification_details asvd on asvd.anemia_survey_id = amd.id
where case when #status# = ''ALL'' or #status# is NULL then true
		when #status# = ''PENDING'' then asvd.id is null
		when #status# = ''VERIFIED'' then asvd.id is not null end
group by amd.id,msdm.id,lm.name,amd.service_date,msdm.location_id,first_name, middle_name, last_name,
	amd.patient_uuid,msdm.dob,msdm.gender,amd.hemoglobin,msdm.is_pregnant,asvd.id,
	is_anemia_conjunctiva_approved, is_anemia_external_left_eye_approved,
 	is_anemia_external_right_eye_approved, is_anemia_fingernails_closed_approved,
   	is_anemia_fingernails_open_approved,is_anemia_tongue_approved
order by amd.id,msdm.id,lm.name,amd.service_date,msdm.location_id,first_name, middle_name, last_name,
	amd.patient_uuid,msdm.dob,msdm.gender,amd.hemoglobin,msdm.is_pregnant,asvd.id,
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
    get_location_hierarchy(msdm.location_id) as location_hierarchy,
	lm.name as location,
	amd.service_date as service_date,
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
inner join location_master lm on lm.id = msdm.location_id
left join anemia_survey_verification_details asvd on asvd.anemia_survey_id = amd.id
where amd.id = #anemiaSurveyId#',
null,
true, 'ACTIVE');