DELETE FROM QUERY_MASTER WHERE CODE='ncd_initial_assessment_prefilled_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'557f12cb-9e90-4cd2-a118-f4b51c204190', 97070,  current_date , 97070,  current_date , 'ncd_initial_assessment_prefilled_data',
'memberId',
'with final_data as(select member_id,screening_date,weight,height,bmi,waist from ncd_member_hypertension_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null or waist is not null)
union
select member_id,screening_date,weight,height,bmi,waist_circumference as waist from ncd_member_initial_assessment_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null or waist_circumference is not null)
union
select member_id,screening_date,weight,height,bmi,0 as waist from ncd_member_diabetes_detail where member_id=#memberId# and (bmi is not null or weight is not null or height is not null)),
weight as (select ''weight'' as key,weight as value from final_data where weight is not null order by screening_date desc limit 1),
height as (select ''height'' as key,height as value from final_data where height is not null order by screening_date desc limit 1),
bmi as (select ''bmi'' as key,bmi as value from final_data where bmi is not null order by screening_date desc limit 1),
waist as (select ''waist'' as key,waist as value from final_data where waist is not null and waist!=0 order by screening_date desc limit 1)
select * from weight
union
select * from height
union
select * from bmi
union
select * from waist',
null,
true, 'ACTIVE');