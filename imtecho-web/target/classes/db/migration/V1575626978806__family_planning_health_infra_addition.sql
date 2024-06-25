alter table imt_member
drop column if exists family_planning_health_infra,
add column family_planning_health_infra bigint;

update query_master
set query = 'update imt_member
set last_method_of_contraception = ''#familyPlanningMethod#'',
fp_insert_operate_date = cast(case when ''#fpInsertOperateDate#'' != ''null'' and ''#fpInsertOperateDate#'' != '''' then ''#fpInsertOperateDate#'' else null end as date),
family_planning_health_infra = case when #healthInfrastructure# is not null then #healthInfrastructure# else null end,
is_iucd_removed = null
where id = #memberId#',
params = 'familyPlanningMethod,fpInsertOperateDate,memberId,healthInfrastructure'
where code = 'update_fp_method';