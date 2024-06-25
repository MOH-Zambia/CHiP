delete from query_master where code='ncd_current_count';

insert into query_master(created_by,created_on,code,query,returns_result_set,state)
values(1,current_date,'ncd_current_count','
with ncd_member_id as (select member_id from ncd_member_diabetes_detail
union
select member_id from ncd_member_hypertension_detail
union
select member_id from ncd_member_oral_detail
union
select member_id from ncd_member_breast_detail
union 
select member_id from ncd_member_cervical_detail)
select
(select count(*) from ncd_member_hypertension_detail  where done_by = ''FHW'' and member_id in (select * from ncd_member_id) and (systolic_bp >= 140 or diastolic_bp >=90)) as "Hypertension",
(select count(*) from ncd_member_diabetes_detail  where done_by = ''FHW'' and member_id in (select * from ncd_member_id) and blood_sugar > 140) as "Diabetes",
count(*) as "Total Count",
(select count(*) from ncd_member_oral_detail  where done_by = ''FHW'' and refferal_done  = true and member_id in (select * from ncd_member_id)) as "Oral Cancer",
(select count(*) from ncd_member_cervical_detail  where done_by = ''FHW'' and refferal_done  = true  and member_id in (select * from ncd_member_id)) as "Cervical Cancer",
(select count(*) from ncd_member_breast_detail  where done_by = ''FHW'' and refferal_done  = true and member_id in (select * from ncd_member_id)) as "Breast Cancer"
from ncd_member_id
',true,'ACTIVE');