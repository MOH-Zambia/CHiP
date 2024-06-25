delete from query_master where code='ncd_current_count';
delete from query_master where code='ncd_current_score';

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
(select count(*) from ncd_member_hypertension_detail  where done_by = ''FHW'' and member_id in (select * from ncd_member_id) and (systolic_bp >= 140 or diastolic_bp >=90)) as "Diagnosed For HyperTension",
(select count(*) from ncd_member_diabetes_detail  where done_by = ''FHW'' and member_id in (select * from ncd_member_id) and blood_sugar > 140) as "Diagnosed For Diabetes",
count(*) as "Total Count",
(select count(*) from ncd_member_oral_detail  where done_by = ''FHW'' and refferal_done  = true and member_id in (select * from ncd_member_id)) as "Referred For Oral Cancer",
(select count(*) from ncd_member_cervical_detail  where done_by = ''FHW'' and refferal_done  = true  and member_id in (select * from ncd_member_id)) as "Diagnosed For Cervical Cancer",
(select count(*) from ncd_member_breast_detail  where done_by = ''FHW'' and refferal_done  = true and member_id in (select * from ncd_member_id)) as "Diagnosed For Breast Cancer"
from ncd_member_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,query,returns_result_set,state)
values(1,current_date,'ncd_current_score','
select round(avg(case when m.dob between now() - INTERVAL ''35 year'' and now() - INTERVAL ''30 year'' then score end),2) as "30-35",
round(avg(case when m.dob between now() - INTERVAL ''40 year'' and now() - INTERVAL ''36 year'' then score end),2) as "36-40",
round(avg(case when m.dob between now() - INTERVAL ''45 year'' and now() - INTERVAL ''41 year'' then score end),2) as "41-45",
round(avg(case when m.dob between now() - INTERVAL ''50 year'' and now() - INTERVAL ''46 year'' then score end),2) as "46-50",
round(avg(case when m.dob between now() - INTERVAL ''55 year'' and now() - INTERVAL ''51 year'' then score end),2) as "51-55",
round(avg(case when m.dob between now() - INTERVAL ''60 year'' and now() - INTERVAL ''56 year'' then score end),2) as "56-60",
round(avg(case when m.dob between now() - INTERVAL ''65 year'' and now() - INTERVAL ''61 year'' then score end),2) as "61-65",
round(avg(case when m.dob between now() - INTERVAL ''70 year'' and now() - INTERVAL ''66 year'' then score end),2) as "66-70",
round(avg(case when m.dob between now() - INTERVAL ''75 year'' and now() - INTERVAL ''71 year'' then score end),2) as "71-75",
round(avg(case when m.dob between now() - INTERVAL ''80 year'' and now() - INTERVAL ''76 year'' then score end),2) as "76-80",
round(avg(case when m.dob between now() - INTERVAL ''85 year'' and now() - INTERVAL ''81 year'' then score end),2) as "81-85"
from imt_member m,ncd_member_cbac_detail cbac where m.id = cbac.member_id;
',true,'ACTIVE');

delete from menu_config where menu_name='NCD Screening Dashboard';
insert into menu_config(active,menu_name,navigation_state,menu_type) values('TRUE','NCD Screening Dashboard','techo.dashboard.ncdscreeningdashboard','ncd');