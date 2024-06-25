


-- 25% of the families where death has been reported for a family member (after 15th January 2020)
begin;
with last_execution as (
	select cast(key_value as timestamp) from system_configuration
	where system_key='CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION'
),
family_with_death_all as (
	select distinct imf.id,
	sum(1) over(partition by imf.location_id order by imf.family_id) sum
	from imt_family_cfhc_done_by_details chfc_done_by
	inner join imt_family imf on imf.family_id = chfc_done_by.family_id
	inner join imt_member im on im.family_id = imf.family_id
	inner join rch_member_death_deatil death_details on death_details.member_id = im.id
	left join imt_family_verification imv on imv.family_id = imf.family_id and imv.survey_type = 'CFHC'
	where
	death_details.created_on >= (select * from last_execution) and	-- as we need a death reported after 15th-Jan-2020 so used created_on
	imf.state in ('CFHC_FN','CFHC_FV') and
	imv.id is null
),
family_details_limited as (
	select * from family_with_death_all
	order by sum
	limit (select ceil(count(1) * 0.25) from family_with_death_all)
),
family_details as(
	select  ifm.location_id,
	ifm.family_id,
	ifm.state as state,
	'com.argusoft.imtecho.gvk.call.to-be-processed' as gvk_state,
	'family.dead' as type,
	'CFHC' as survey_type,
	now() as created_on,
	now() schedule_date
	from family_details_limited death_family inner join imt_family ifm on
	death_family.id =  ifm.id
),
inserting_imt_family_verification as (
    insert into imt_family_verification (family_id, location_id,gvk_state,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
    select family_id, location_id,gvk_state,state,survey_type,type,created_on,-1,schedule_date,'GVK' from  family_details
    returning family_id
)
update imt_family
set state ='CFHC_GVK_FRVP',
modified_on = now()
where family_id in (select * from inserting_imt_family_verification);

-- Add 1 family from each village (and hopefully all ANMs / MPHWs will be covered) per day from the families that they have verified in the last 7 days.

with last_execution as (
	select cast(key_value as timestamp) as last_execution from system_configuration
	where system_key='CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION'
),
family_with_villages as (
	select
	distinct on (imf.location_id) imf.location_id,imf.id
	from imt_family_cfhc_done_by_details cfhs_details inner join imt_family imf on imf.family_id = cfhs_details.family_id
	inner join location_master lm on imf.location_id = lm.id
	inner join last_execution on true
	left join imt_family_verification imv on imv.family_id = imf.family_id and imv.survey_type = 'CFHC'
	where
	(cfhs_details.created_on >= now() - interval '7 days' and current_date - last_execution.last_execution >= interval '7 days')
	and imf.state in ('CFHC_FN','CFHC_FV')
	and imv.id is null
	and lm.type = 'V' -- we will consider only village data, confirm with setu sir
	order by imf.location_id

),
family_details as(
	select  ifm.location_id,
	ifm.family_id,
	ifm.state as state,
	'com.argusoft.imtecho.gvk.call.to-be-processed' as gvk_state,
	'family.verified' as type,
	'CFHC' as survey_type,
	now() as created_on,
	now() schedule_date
	from family_with_villages death_family inner join imt_family ifm on
	death_family.id =  ifm.id
), inserting_imt_family_verification as (
insert into imt_family_verification (family_id, location_id,gvk_state,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
select family_id, location_id,gvk_state,state,survey_type,type,created_on,-1,schedule_date from  family_details
returning family_id)
update imt_family set
state ='CFHC_GVK_FRVP',
modified_on = now(),
'GVK'
where family_id in (select family_id from inserting_imt_family_verification);

-- add migrated family


--------------------MO CFHC Query------------------------------------------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

--- DEAD MEMBER HAVING AGE < 45
with last_execution as (
	select cast(key_value as timestamp) as last_execution from system_configuration
	where system_key='CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION'
),
dead_member as(
    select imf.family_id, imf.location_id, imf.state
    from  imt_family imf
    inner join imt_member im on imf.family_id = im.family_id
    inner join imt_family_cfhc_done_by_details cfhs_details  on imf.family_id =  cfhs_details.family_id
    inner join last_execution on true
    where
    im.state in ('com.argusoft.imtecho.member.state.dead') and
    date_part('year',age(current_date,im.dob)) < 45 and
    imf.state in ('CFHC_FN', 'CFHC_FV') and
    (cfhs_details.created_on >= now() - interval '7 days' and current_date - last_execution.last_execution >= interval '7 days')
    group by imf.family_id, imf.location_id, imf.state
 )
 ,family_details as(
    select  dm.location_id,
    dm.family_id,
    dm.state as state,
    'family.dead' as type,
    'CFHC' as survey_type,
    now() as created_on,
    now() schedule_date,
    'MO' as verification_body
    from dead_member dm
    left join imt_family_verification imv on imv.family_id = dm.family_id and imv.survey_type = 'CFHC'
    where imv.id is null
)
,
inserting_imt_family_verification as (
    insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
    select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date,verification_body from  family_details
    returning family_id
) 
update imt_family
set state ='CFHC_MO_FRVP',
modified_on = now()
where family_id in (select * from inserting_imt_family_verification);


--- Family Having Only One Member
with last_execution as (
	select cast(key_value as timestamp) as last_execution from system_configuration
	where system_key='CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION'
), 
single_member as(
    select imf.family_id, imf.location_id,  imf.state
    from imt_member im inner join imt_family imf  on imf.family_id = im.family_id
    where im.state in ('CFHC_MV', 'CFHC_MN') and
    imf.state in ('CFHC_FV', 'CFHC_FN')
    group by im.family_id, imf.family_id, imf.location_id, imf.state having count(im.unique_health_id) = 1
)
 ,family_details as(
    select  sm.location_id,
    sm.family_id,
    sm.state as state,
    'family.single' as type,
    'CFHC' as survey_type,
    now() as created_on,
    now() schedule_date,
    'MO' as verification_body
    from single_member sm
    left join imt_family_verification imv on imv.family_id = sm.family_id and imv.survey_type = 'CFHC'
    inner join last_execution on true
    where imv.id is null and (current_date - last_execution.last_execution >= interval '7 days')
)
,
inserting_imt_family_verification as (
    insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
    select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date,verification_body from  family_details
    returning family_id
) 
update imt_family
set state ='CFHC_MO_FRVP',
modified_on = now()
where family_id in (select * from inserting_imt_family_verification);


-- 5% of the verified families per each of the field workers
with last_execution as (
	select cast(key_value as timestamp) as last_execution from system_configuration
	where system_key='CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION'
),
verified_family as (
    select t.user_id, t.family_id, t.location_id,t.state, rn, cnt
    from (
    select cfhs_details.user_id,
           imf.family_id,imf.location_id, imf.state,
           count(*) over (partition by user_id) as cnt,
           row_number() over (partition by user_id order by imf.family_id desc) as rn
    from imt_family imf inner join imt_family_cfhc_done_by_details cfhs_details  on imf.family_id = cfhs_details.family_id
    inner join last_execution on true
    where state in ('CFHC_FN', 'CFHC_FV') and
    (cfhs_details.created_on >= now() - interval '7 days' and current_date - last_execution.last_execution >= interval '7 days')
    )t  where rn <= round((cnt * .05))
)
 ,family_details as(
    select  vf.location_id,
    vf.family_id,
    vf.state as state,
    'family.verified' as type,
    'CFHC' as survey_type,
    now() as created_on,
    now() schedule_date,
    'MO' as verification_body
    from verified_family vf
    left join imt_family_verification imv on imv.family_id = vf.family_id and imv.survey_type = 'CFHC'
    where imv.id is null
)
,
inserting_imt_family_verification as (
    insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
    select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date,verification_body from  family_details
    returning family_id
) 
update imt_family
set state ='CFHC_MO_FRVP',
modified_on = now()
where family_id in (select * from inserting_imt_family_verification);

--------------------End MO CFHC Query -----------------------------


update system_configuration set key_value= cast(now() as text)
where system_key = 'CFHC_DEATH_MEMBER_FAMILY_VERIFICATION_LAST_EXECUTION';


commit;

