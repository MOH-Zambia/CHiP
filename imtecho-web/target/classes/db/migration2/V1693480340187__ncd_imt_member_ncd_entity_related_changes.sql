alter table if exists imt_member_ncd_detail
add column if not exists cvc_treatement_status text,
add column if not exists last_mo_comment_by integer,
add column if not exists last_mo_comment_form_type text,
add column if not exists last_remark_by integer,
add column if not exists last_remark_form_type text,
add column if not exists other_disease_history text;

alter table if exists imt_member_ncd_detail
drop constraint if exists imt_member_ncd_detail_unique_members,
add constraint imt_member_ncd_detail_unique_members unique (member_id);

DELETE FROM QUERY_MASTER WHERE CODE='ncd_initial_assessment_prefilled_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'557f12cb-9e90-4cd2-a118-f4b51c204190', 97070,  current_date , 97070,  current_date , 'ncd_initial_assessment_prefilled_data',
'memberId',
'with final_data as(select member_id,screening_date,weight,height,bmi,waist from ncd_member_hypertension_detail where member_id=#memberId# and waist is not null
union
select member_id,screening_date,weight,height,bmi,waist_circumference as waist from ncd_member_initial_assessment_detail where member_id=#memberId# and waist_circumference is not null),
waist as (select ''waist'' as key,waist as value from final_data where waist is not null and waist!=0 order by screening_date desc limit 1)
select * from waist',
null,
true, 'ACTIVE');