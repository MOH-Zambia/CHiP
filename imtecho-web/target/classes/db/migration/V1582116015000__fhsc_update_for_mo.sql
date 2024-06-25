DO $$ 
    BEGIN
        BEGIN
           ALTER TABLE imt_family_verification
           ADD COLUMN verification_body varchar(250);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column verification_body already exists in imt_family_verification.';
        END;
    END;
$$
-- 
-- --- DEAD MEMBER HAVING AGE < 45
-- 
-- with dead_member as(
-- 	select imf.family_id, imf.location_id, imf.state
-- 	from  imt_family imf 
-- 	inner join imt_member im on imf.family_id = im.family_id
-- 	inner join imt_family_cfhc_done_by_details cfhs_details  on imf.family_id =  cfhs_details.family_id
-- 	where 
-- 		im.state in ('com.argusoft.imtecho.member.state.dead') and 
--  		date_part('year',age(current_date,im.dob)) < 45 and
--  		imf.state in ('CFHC_FU', 'CFHC_FV')
--  	group by imf.family_id, imf.location_id, imf.state
--  )
--  ,family_details as(
-- 	select  dm.location_id,
-- 	dm.family_id,
-- 	dm.state as state,
-- 	'family.dead' as type,
-- 	'CFHC' as survey_type,
-- 	now() as created_on,
-- 	now() schedule_date,
--         'MO' as verification_body
-- 	from dead_member dm
--     left join imt_family_verification imv on imv.family_id = dm.family_id and imv.survey_type = 'CFHC'
--     where imv.id is null
-- 
-- )
--    -- insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
--     select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date,verification_body from  family_details
--    
-- 
-- --- Family Having Only One Member
-- 
-- with single_member as(
-- 	select imf.family_id, imf.location_id,  imf.state
-- 	from imt_member im inner join imt_family imf  on imf.family_id = im.family_id
--         where im.state in ('CFHC_MU', 'CFHC_FN') and
--               imf.state in ('CFHC_FU', 'CFHC_FV')
-- 	group by im.family_id, imf.family_id, imf.location_id, imf.state having count(im.unique_health_id) = 1
-- )
--  ,family_details as(
-- 	select  sm.location_id,
-- 	sm.family_id,
-- 	sm.state as state,
-- 	'family.single' as type,
-- 	'CFHC' as survey_type,
-- 	now() as created_on,
-- 	now() schedule_date,
--         'MO' as verification_body
-- 	from single_member sm
--     left join imt_family_verification imv on imv.family_id = sm.family_id and imv.survey_type = 'CFHC'
--     where imv.id is null
-- 
-- )
--    -- insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date,verification_body)
--     select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date,verification_body from  family_details
-- 
-- -- 5% of the verified families per each of the field workers
-- 
-- with verified_family as (
--   select t.user_id, t.family_id, t.location_id,t.state, rn, cnt
-- 	from (
--   	select cfhs_details.user_id, 
--          imf.family_id,imf.location_id, imf.state,
--          count(*) over (partition by user_id) as cnt,
--          row_number() over (partition by user_id order by imf.family_id desc) as rn
--   	 from imt_family imf inner join imt_family_cfhc_done_by_details cfhs_details  
--      on imf.family_id = cfhs_details.family_id
-- 	 where state in ('CFHC_FU', 'CFHC_FV')
--  )t  where rn <= round((cnt * .05))
-- ) 
--  ,family_details as(
-- 	select  vf.location_id,
-- 	vf.family_id,
-- 	vf.state as state,
-- 	'family.verified' as type,
-- 	'CFHC' as survey_type,
-- 	now() as created_on,
-- 	now() schedule_date, 
--         'MO' as verification_body
-- 	from verified_family vf
--     left join imt_family_verification imv on imv.family_id = vf.family_id and imv.survey_type = 'CFHC'
--     where imv.id is null
-- 
-- )
--    -- insert into imt_family_verification (family_id, location_id,state,survey_type,type,created_on,created_by,schedule_date, verification_body)
--     select family_id, location_id,state,survey_type,type,created_on,-1,schedule_date, verification_body from  family_details
