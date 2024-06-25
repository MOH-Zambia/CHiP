alter table covid19_lab_test_detail
drop column if exists rejection_remark_selected,
drop column if exists result_remarks,
drop column if exists is_recollect,
drop column if exists other_result_remarks_selected,
add column rejection_remark_selected text,
add column result_remarks text,
add column is_recollect boolean,
add column other_result_remarks_selected text;


DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_result_status';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_result_status', 
'result,otherResultRemarksSelected,resultDate,labName,isRecollect,id,userId,resultRemarks', 
'with admission_det as (
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id# and ''#result#'' = ''POSITIVE''
),update_admission_status as (
update covid19_admission_detail
set status = ''CONFORMED'' where id = (select admission_id from admission_det) and ''#result#'' = ''POSITIVE''
)
update covid19_lab_test_detail
set lab_result_entry_on = to_timestamp(''#resultDate#'',''DD/MM/YYYY HH24:MI:SS''),
lab_result_entry_by = #userId#,
lab_result = ''#result#'',
lab_collection_status = ''#result#'',
indeterminate_lab_name = (case when ''#labName#'' = ''null'' then indeterminate_lab_name else ''#labName#'' end),
result_remarks = (case when ''#resultRemarks#'' = ''null'' then null else ''#resultRemarks#'' end),
is_recollect = #isRecollect#,
other_result_remarks_selected = (case when ''#otherResultRemarksSelected#'' = ''null'' then null else ''#otherResultRemarksSelected#'' end),
result_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_sample_received_status';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_sample_received_status', 
'receiveDate,rejectionRemarks,labTestNumber,rejectionRemarkSelected,id,userId,status', 
'update covid19_lab_test_detail
set lab_collection_status = ''#status#'',
lab_sample_rejected_by = case when ''#status#'' = ''SAMPLE_REJECTED'' then #userId# else null end,
lab_sample_rejected_on = case when ''#status#'' = ''SAMPLE_REJECTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_sample_reject_reason = ''#rejectionRemarks#'',
lab_sample_received_by = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then #userId# else null end,
lab_sample_received_on = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_test_number = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then ''#labTestNumber#'' else null end,
rejection_remark_selected = (case when ''#rejectionRemarkSelected#'' = ''null'' then null else ''#rejectionRemarkSelected#'' end),
receive_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');


CREATE OR REPLACE FUNCTION public.covid19_addmission_insert_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	NEW.search_text = concat_ws(' ',NEW.first_name,NEW.middle_name,NEW.last_name,NEW.case_no,NEW.unit_no,NEW.opd_case_no,NEW.current_bed_no,NEW.contact_number,(select ward_name from health_infrastructure_ward_details where id = NEW.current_ward_id));
	if NEW.lab_test_id is null then
	update covid19_lab_test_detail set created_by = created_by where covid_admission_detail_id = NEW.id and covid19_lab_test_detail.lab_test_id is null;
	end if; 
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  

CREATE OR REPLACE FUNCTION public.covid19_lab_test_detail_insert_update_trigger_func()
  RETURNS trigger AS
$BODY$
declare
			admission_type text;
			sample_count integer;
begin

	NEW.search_text = concat_ws(' ',
		(select concat_ws(' ',
			first_name,
			middle_name,
			last_name,
			case_no,
			unit_no,
			opd_case_no,
			current_bed_no,
			contact_number
			)
			from covid19_admission_detail
			where id = NEW.covid_admission_detail_id
		),
	NEW.lab_test_number,
	NEW.lab_result,
	NEW.indeterminate_lab_name,
	(select name from health_infrastructure_details where id = NEW.sample_health_infra),
	(select name from health_infrastructure_details where id = NEW.sample_health_infra_send_to)
);

admission_type := (select admission_from from covid19_admission_detail where id =  NEW.covid_admission_detail_id);
sample_count := (select sample_no from (
select id,ROW_NUMBER() OVER(
    PARTITION BY covid_admission_detail_id
    ORDER BY COALESCE(lab_collection_on,created_on)
) as sample_no from covid19_lab_test_detail where   
 covid_admission_detail_id = NEW.covid_admission_detail_id and lab_sample_rejected_on is null) as t
 where t.id = NEW.id);
 
if sample_count is null then
sample_count := (select count(1) from covid19_lab_test_detail where id != NEW.id and covid_admission_detail_id = NEW.covid_admission_detail_id and lab_sample_rejected_on is null);
else
sample_count := sample_count - 1;
end if;


if (NEW.created_on > '04-15-2020 09:00:00' and NEW.lab_test_id is null and admission_type = 'OPD_ADMIT') then
		NEW.lab_test_id = upper(get_lab_test_code(-1,NEW.sample_health_infra_send_to,NEW.covid_admission_detail_id));
		update covid19_admission_detail set lab_test_id = NEW.lab_test_id  where id = NEW.covid_admission_detail_id and lab_test_id is null;
		NEW.lab_test_id = upper(concat_ws('/',NEW.lab_test_id,(case when sample_count > 0 then concat('R',sample_count)end)));
elseif (NEW.created_on > '04-15-2020 09:00:00' and NEW.lab_test_id is null and admission_type = 'NEW') then
NEW.lab_test_id = upper(get_lab_test_code(NEW.sample_health_infra,NEW.sample_health_infra_send_to,NEW.covid_admission_detail_id));
		update covid19_admission_detail set lab_test_id = NEW.lab_test_id  where id = NEW.covid_admission_detail_id and lab_test_id is null;
		NEW.lab_test_id = upper(concat_ws('/',NEW.lab_test_id,(case when sample_count > 0 then concat('R',sample_count)end)));
		
END if;
RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
  ALTER TABLE public.covid19_lab_test_detail
   ALTER COLUMN lab_test_id DROP DEFAULT;

CREATE OR REPLACE FUNCTION public.get_lab_test_code(
    source_id integer,
    dest_id integer,
    admission_id integer)
  RETURNS text AS
$BODY$
		declare
			counter integer := (select count(*) from health_infra_lab_sample_id_master
								where source_infra = source_id and destination_infra = dest_id);
			code text;

			lab_test_id text := (select lab_test_id from covid19_admission_detail  where id  = admission_id);
        begin
			if lab_test_id is not null then
				return lab_test_id;
			end if;
				
	        	if counter > 0 then
				with t1 as(update health_infra_lab_sample_id_master set current_count = current_count + 1
	        					where source_infra = source_id and destination_infra = dest_id
	        					returning  destination_infra_code||'-'||source_infra_code||'-'||current_count)
	        		 (select * into code from t1);
				return code;
	        	else
				if source_id = -1 then
					with source_inf as (select 1 as "tmp_id",-1 as "id",'RND' as "substring"),

					dest_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
					health_infrastructure_details where id = dest_id),

					t as
					(insert into health_infra_lab_sample_id_master(source_infra, source_infra_code,
					destination_infra,destination_infra_code)
					select s.id,s.substring,d.id,d.substring from source_inf s,dest_inf d where s.tmp_id = d.tmp_id
					returning   destination_infra_code|| '-' || source_infra_code|| '-' || current_count)

					--t1 as (update health_infra_lab_sample_id_master set current_count = current_count + 1
       					--where source_infra = source_id and destination_infra = dest_id
       					--returning source_infra_code || '-' || destination_infra_code || '-' || current_count)
					select * into code from t;
					return code;
				else 
					with source_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
						health_infrastructure_details where id = source_id),

						dest_inf as (select 1 as "tmp_id",id,substring(name_in_english from 1 for 3) from
						health_infrastructure_details where id = dest_id),

						t as
						(insert into health_infra_lab_sample_id_master(source_infra, source_infra_code,
						destination_infra,destination_infra_code)
						select s.id,s.substring,d.id,d.substring from source_inf s,dest_inf d where s.tmp_id = d.tmp_id
						returning   destination_infra_code|| '-' ||source_infra_code|| '-' || current_count)

						--t1 as (update health_infra_lab_sample_id_master set current_count = current_count + 1
						--where source_infra = source_id and destination_infra = dest_id
						--returning source_infra_code || '-' || destination_infra_code || '-' || current_count)
						select * into code from t;
					return code;
				end if;
	        	end if;
        end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_collection';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid19_lab_test_pending_sample_collection', 
'searchText,limit_offset,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_test_number as lab_test_number,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from."name" as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96)) 
	or ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''COLLECTION_PENDING''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by cacd.service_date desc
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_id as "labTestId"
,lab_test_number as "labTestNumber"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
from idsp_screening;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_receive';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_receive', 
'searchText,limit_offset,healthInfra,loggedInUserId,collectionDate', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_collection_on as collection_date,
	ltd.sample_health_infra_send_to as health_infra_to,
	ltd.is_transferred as is_transferred,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_test_number as lab_test_number,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from.name_in_english as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96)) 
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_COLLECTED''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	and case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end
	and case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_collection_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end
	order by ltd.collection_server_date desc
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,collection_date as "sampleCollectionDate"
,health_infra_to as "healthInfraTo"
,is_transferred as "isTransferred"
,lab_test_id as "labTestId"
,lab_test_number as "labTestNumber"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
from idsp_screening;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_result';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_result', 
'searchText,limit_offset,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.lab_sample_received_on as receive_date,
	ltd.lab_test_id as lab_test_id,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from.name_in_english as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96)) 
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_ACCEPTED''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by ltd.receive_server_date desc
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,receive_date as "sampleReceiveDate"
,lab_test_id as "labTestId"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
,cast(''CONFIRMATION'' as text) as "resultStage"
from idsp_screening', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_only_lab_test_admission';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid_19_get_opd_only_lab_test_admission', 
'limit_offset,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then clt.age
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' years'') as dob,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.current_bed_no,
	cltd.lab_collection_status as test_result,
	(case when cltd.lab_collection_status in (''COLLECTION_PENDING'',''SAMPLE_COLLECTED'',''SAMPLE_ACCEPTED'') then true else false end) as "isLabTestInProgress",
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time,
	clt.is_hiv,
	clt.is_heart_patient,
	clt.is_diabetes ,
	clt.is_copd,
	clt.is_renal_condition,
	clt.is_hypertension,
	clt.is_immunocompromized,
	clt.is_malignancy,
	clt.is_other_co_mobidity,
	clt.other_co_mobidity,
	clt.is_fever,
	clt.is_cough,
	clt.is_breathlessness,
	clt.is_sari,
    cltd.id as lab_test_id,
    cltd.lab_test_id as lab_id
	from covid19_admission_detail clt
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	cltd.sample_health_infra in (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.admission_from in (''OPD_ADMIT'')
	order by cltd.created_on desc
	#limit_offset#
)
select
id as "admissionId"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,dob as "DOB"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,test_result as "testResult"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator as "onVentilator"
,ventilator_type1 as "ventilatorType1"
,ventilator_type2 as "ventilatorType2"
,on_o2 as "onO2"
,on_air as "onAir"
,remarks
,"isLabTestInProgress"
,is_hiv as "isHIV"
,is_heart_patient as "isHeartPatient"
,is_diabetes as "isDiabetes"
,is_copd as "isCOPD"
,is_renal_condition as "isRenalCondition"
,is_hypertension as "isHypertension"
,is_immunocompromized as "isImmunocompromized"
,is_malignancy as "isMalignancy"
,is_other_co_mobidity as "isOtherCoMobidity"
,other_co_mobidity as "otherCoMobidity"
,is_fever as "hasFever"
,is_cough as "hasCough"
,is_breathlessness as "hasShortnessBreath"
,is_sari as "isSari"
,lab_test_id as "labTestId"
,lab_id as "labTestIdFromLabTest"
from idsp_screening;', 
null, 
true, 'ACTIVE');