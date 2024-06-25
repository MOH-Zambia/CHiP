/*
delete from anmol_mother_registration where pregnancy_reg_det_id in (
select mother.pregnancy_reg_det_id from anmol_mother_registration mother inner join anmol_master anmol on mother.pregnancy_reg_det_id = anmol.pregnancy_reg_det_id
where is_upload is true and mother_registration_status is null) and  is_upload is true;


-- Manage records of failed LMP followup visit

with tmp as(
select am.member_id ,count(1) as count from anmol_master am inner join rch_lmp_follow_up lmp on am.member_id = lmp.member_id
where mother_registration_wsdl_code  ='36'
group by am.member_id
having count(1) = 1 )
update rch_lmp_follow_up
set anmol_registration_id = null,
anmol_upload_status_code = null,
anmol_follow_up_wsdl_code = null,
anmol_follow_up_date = null,
anmol_case_no  = null,
anmol_follow_up_status = null
where id in (select id from rch_lmp_follow_up where member_id in (select member_id from tmp))
and anmol_follow_up_wsdl_code = 'EXCEPTION';

with tmp as(
select am.member_id ,count(1) as count from anmol_master am inner join rch_lmp_follow_up lmp on am.member_id = lmp.member_id
where mother_registration_wsdl_code  ='36'
group by am.member_id
having count(1) = 1 )
delete from anmol_eligible_couple_tracking where member_id in (select member_id from tmp);

delete from anmol_mother_registration where member_id in (select member_id from anmol_master where mother_registration_wsdl_code='36');

update anmol_master set eligible_tracking_status=null ,mother_registration_wsdl_code = null,  mother_registration_status = null, mother_registration_date = null
where mother_registration_wsdl_code  ='36';


*/

begin;
with new_preg as (
select preg.* from
anmol_master am
inner join rch_pregnancy_registration_det preg on am.pregnancy_reg_det_id = preg.id
left join anmol_lmp_follow_up_details anmol_lmp_followup on anmol_lmp_followup.pregnancy_reg_det_id = preg.id
where am.eligible_tracking_status is null
and preg.state in ('PENDING', 'DELIVERY_DONE', 'PREGNANT')
and anmol_lmp_followup.id is null and am.eligible_registration_id != '-1'
and (cast(preg.reg_date as date) - cast(preg.lmp_date as date)) between 35 and 322)
insert into anmol_lmp_follow_up_details (member_id, location_id, lmp_date, family_planning_method, pregnancy_reg_det_id, service_date, pregnancy_test_done,is_pregnant )
select preg.member_id, preg.location_id,preg.lmp_date,'NONE',preg.id, preg.reg_date,true,true from new_preg preg;
commit;

begin;
-- eligibe couple tracking
-- Drop table
-- DROP TABLE anmol_eligible_couple_tracking_new;

  with tracking_members as (
        SELECT
          am.member_id,
          am.eligible_registration_id as Registration_no,
          am.eligible_mobile_id as Mobile_ID,
          fu.id,
          CASE
            WHEN (
              hierarchy_type = 'C'
              OR hierarchy_type = 'U'
            ) then 'U'
            ELSE 'R'
          END as rural_Urban,
          CASE
            WHEN fu.is_pregnant then 'Y'
            ELSE 'N'
          END as Pregnant,
          CASE
            WHEN fu.family_planning_method = 'CONDOM' THEN 'A'
            WHEN fu.family_planning_method = 'ORALPILLS' THEN 'B'
            WHEN fu.family_planning_method = 'IUCD10' THEN 'C'
            WHEN fu.family_planning_method = 'IUCD5' THEN 'D'
            WHEN fu.family_planning_method = 'FMLSTR' THEN 'E'
            WHEN fu.family_planning_method = 'MLSTR' THEN 'F'
            WHEN fu.family_planning_method = 'CONTRA' THEN 'G'
            WHEN fu.family_planning_method = 'ANTARA' THEN 'I'
            WHEN fu.family_planning_method = 'CHHAYA' THEN 'I'
            WHEN fu.family_planning_method = 'NONE' THEN 'H'
            ELSE 'H'
          END as Method,
          CASE
            WHEN fu.family_planning_method = 'CHHAYA' THEN fu.family_planning_method
            WHEN fu.family_planning_method = 'ANTARA' THEN fu.family_planning_method
            ELSE 'Not specified'
          END as Other,
          CASE
            WHEN fu.pregnancy_test_done then CASE
              WHEN fu.is_pregnant THEN 'P'
              ELSE 'N'
            END
            ELSE ''
          END as Pregnant_test,
          to_char(fu.service_date, 'yyyy-MM-dd') as VisitDate,
          to_char(fu.service_date, 'yyyy-MM-dd') as Created_On,
          fu.service_date as Created_Date,
          alm.State_Code as State_Code,
          alm.District_Code as District_Code,
          alm.Taluka_Code as Taluka_Code,
          alm.Village_Code as Village_Code,
          alm.Health_Facility_Code as HealthFacility_Code,
          alm.Health_SubFacility_Code as HealthSubFacility_Code,
          alm.Health_Block_Code as HealthBlock_Code,
          alm.Health_Facility_Type as HealthFacility_Type,
          alm.ASHA_ID as ASHA_ID,
          alm.ANM_ID as ANM_ID,
          alm.ANM_ID as Created_By,
          'W' AS Whose_mobile,
          am.case_no as Case_no,
          fu.id as rchLmpFollowUpId,
          (select totalVisit from (
              select
            sum(
              case
                when fu1.service_date >= fu2.service_date then 1
                else 0
              end
            ) as totalVisit,
            fu1.id
          from anmol_lmp_follow_up_details fu1,
            anmol_lmp_follow_up_details fu2
          where
            fu2.member_id = fu1.member_id
            and fu1.member_id = am.member_id
          group by
            fu1.id
          ) total_visit where total_visit.id = fu.id) as Visit_No
        FROM anmol_master am
        inner join anmol_lmp_follow_up_details fu on am.member_id = fu.member_id
          and am.state = 'ACTIVE'
        inner join location_hierarchy_type lhtm on lhtm.location_id = fu.location_id
        inner join anmol_location_mapping alm on alm.location_id = fu.location_id
        inner join rch_pregnancy_registration_det rprd on rprd.member_id = am.member_id
        where
          fu.anmol_registration_id is null
          and fu.anmol_follow_up_status is null
          and am.eligible_registration_id <> '-1'
          and fu.service_date <= rprd.reg_date
          and rprd.id = am.pregnancy_reg_det_id
          and fu.member_id not in (124267089,124273897) -- those members are register duplicate need to find out the root cause
          -- and fu.member_id = 106621633
        order by
          id
      ), t_anmol_eligible_couple_tracking as (
    select
      tracking_members.*,
      -- total_visit.totalVisit as Visit_No,
      false as is_upload
    from tracking_members
    )
INSERT INTO anmol_eligible_couple_tracking_new (
    member_id,
    registration_no,
    mobile_id,
    id,
    rural_urban,
    pregnant,
    "method",
    other,
    pregnant_test,
    visitdate,
    created_on,
    created_date,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    created_by,
    whose_mobile,
    case_no,
    rchlmpfollowupid,
    visit_no,
    is_upload
  )
select
taect.member_id,
taect.registration_no,
taect.mobile_id,
taect.id,
taect.rural_urban,
taect.pregnant,
taect."method",
taect.other,
taect.pregnant_test,
taect.visitdate,
taect.created_on,
taect.created_date,
taect.state_code,
taect.district_code,
taect.taluka_code,
taect.village_code,
taect.healthfacility_code,
taect.healthsubfacility_code,
taect.healthblock_code,
taect.healthfacility_type,
taect.asha_id,
taect.anm_id,
taect.created_by,
taect.whose_mobile,
taect.case_no,
taect.rchlmpfollowupid,
taect.visit_no,
taect.is_upload
from t_anmol_eligible_couple_tracking taect
left join anmol_eligible_couple_tracking_new aect
on aect.rchLmpFollowUpId = taect.rchLmpFollowUpId
where aect.rchLmpFollowUpId is null
order by taect.id;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED1'
where event_config_id = 96 and status = 'PROCESSED';
commit;


begin ;

-- before mother registration update lmp status

with tracking as (
select count(1) count, anmol.id from anmol_master anmol
inner join anmol_lmp_follow_up_details follow on follow.member_id = anmol.member_id
where
follow.anmol_registration_id  = anmol.eligible_registration_id
and anmol.pregnancy_reg_det_id is not null
and follow.anmol_follow_up_status is not null
and anmol.eligible_tracking_status is null
and follow.is_pregnant is true
and follow.anmol_case_no = anmol.case_no
group by anmol.id)
update anmol_master set eligible_tracking_status='SUCCESS'
from tracking
where  anmol_master.id = tracking.id
and tracking.count>0;
commit ;


begin ;
-- mother registration
-- Drop table
-- DROP TABLE anmol_mother_registration;

with t_mother_registration as(
  select
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    'W' AS Mobile_Relates_To,
    alm.ANM_ID AS Created_By,
    CASE
      WHEN im.jsy_beneficiary then 'S'
      ELSE 'N'
    end as JSY_Beneficiary,
    CASE
      WHEN im.jsy_payment_given then 'S'
      ELSE 'N'
    end as JSY_Payment_Received,
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    CASE
      WHEN imf.bpl_flag THEN '1'        -- checked in UI, Need master
      ELSE '99'
    END as BPL_APL,
    CASE
      WHEN im.dob IS NOT NULL THEN date_part('year', age(current_date, im.dob))
      ELSE NULL
    END as Age,
    concat_ws(',', imf.address1, imf.address2) as Address,
    concat_ws(' ', im.first_name, im.last_name) as Name_PW,
    concat_ws(' ', im.middle_name, im.last_name) as Name_H,
    to_char(rprd.created_on, 'yyyy-MM-dd') as Created_On,
    case
      when rprd.reg_date is not null then rprd.reg_date
      else rprd.created_on
    end as Created_Date,
    to_char(
      case
        when rprd.reg_date is not null then rprd.reg_date
        else rprd.created_on
      end,
      'yyyy-MM-dd'
    ) as Registration_Date,
    am.eligible_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    case
      when im.weight is null then 55.99
      else im.weight
    end as Weight,
    case
      when imf.caste = '625' then 2     -- ST
      when imf.caste = '624' then 1     -- Scheduled Caste
      else 99                           -- Others
    end as Caste,
    case
      when imf.religion = '623' then 1      -- CHRISTIAN
      when imf.religion = '621' then 2      -- HINDU
      when imf.religion = '622' then 3      -- MUSLIM
      else 99                               -- OTHERS, we are not taking Sikh
    end as Religion_Code,
    case
      when im.mobile_number is null
      or im.mobile_number = '0000000000' then '9999999999'
      else im.mobile_number
    end as Mobile_No,
    im.id as member_id,
    am.id as anmol_master_id,
    am.case_no as Case_no,
    rprd.id as pregnancy_reg_det_id,
    to_char(im.dob, 'yyyy-MM-dd') as Birth_Date,
    false as is_upload
  from anmol_master am
  inner join rch_pregnancy_registration_det rprd on am.member_id = rprd.member_id
    and am.pregnancy_reg_det_id = rprd.id
  inner join imt_member im on im.id = am.member_id
  inner join imt_family imf on imf.family_id = im.family_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rprd.location_id
  inner join anmol_location_mapping alm on alm.location_id = rprd.location_id
  where
    rprd.state in ('PENDING', 'DELIVERY_DONE', 'PREGNANT')
    and am.mother_registration_status is null
    and am.eligible_registration_id <> '-1'
    and am.eligible_tracking_status = 'SUCCESS'
)
INSERT INTO anmol_mother_registration (
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    mobile_relates_to,
    created_by,
    jsy_beneficiary,
    jsy_payment_received,
    rural_urban,
    bpl_apl,
    age,
    address,
    name_pw,
    name_h,
    created_on,
    created_date,
    registration_date,
    registration_no,
    mobile_id,
    weight,
    caste,
    religion_code,
    mobile_no,
    member_id,
    anmol_master_id,
    case_no,
    pregnancy_reg_det_id,
    birth_date,
    is_upload
  )
select
  tmreg.state_code,
tmreg.district_code,
tmreg.taluka_code,
tmreg.village_code,
tmreg.healthfacility_code,
tmreg.healthsubfacility_code,
tmreg.healthblock_code,
tmreg.healthfacility_type,
tmreg.asha_id,
tmreg.anm_id,
tmreg.mobile_relates_to,
tmreg.created_by,
tmreg.jsy_beneficiary,
tmreg.jsy_payment_received,
tmreg.rural_urban,
tmreg.bpl_apl,
tmreg.age,
tmreg.address,
tmreg.name_pw,
tmreg.name_h,
tmreg.created_on,
tmreg.created_date,
tmreg.registration_date,
tmreg.registration_no,
tmreg.mobile_id,
tmreg.weight,
tmreg.caste,
tmreg.religion_code,
tmreg.mobile_no,
tmreg.member_id,
tmreg.anmol_master_id,
tmreg.case_no,
tmreg.pregnancy_reg_det_id,
tmreg.birth_date,
tmreg.is_upload
from t_mother_registration tmreg
left join anmol_mother_registration amreg on tmreg.pregnancy_reg_det_id = amreg.pregnancy_reg_det_id
where
  amreg.pregnancy_reg_det_id IS NULL;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED2'
where event_config_id = 96 and status = 'PROCESSED1';
commit ;

begin ;
-- mother medical
-- Drop table
-- DROP TABLE anmol_mother_medical;

with pregnancy_registration as (
      select
        CASE
          WHEN (
            lhtm.hierarchy_type = 'C'
            OR lhtm.hierarchy_type = 'U'
          ) then 'U'
          ELSE 'R'
        END as rural_Urban,
        alm.State_Code as State_Code,
        alm.District_Code as District_Code,
        alm.Taluka_Code as Taluka_Code,
        alm.Village_Code as Village_Code,
        alm.Health_Facility_Code as HealthFacility_Code,
        alm.Health_SubFacility_Code as HealthSubFacility_Code,
        alm.Health_Block_Code as HealthBlock_Code,
        alm.Health_Facility_Type as HealthFacility_Type,
        alm.ASHA_ID as ASHA_ID,
        alm.ANM_ID as ANM_ID,
        'W' AS Mobile_Relates_To,
        alm.ANM_ID AS Created_By,
        to_char(rprd.lmp_date, 'yyyy-MM-dd') as LMP_Date,
        to_char(rprd.edd, 'yyyy-MM-dd') as EDD_Date,
        case
          when rpad.lmp_date is null then false
          else DATE_PART('day', reg_date - rpad.lmp_date) <= 84
        end as Reg_12Weeks,
        to_char(rprd.created_on, 'yyyy-MM-dd') as Created_On,
        am.eligible_registration_id as Registration_no,
        am.eligible_mobile_id as Mobile_ID,
        im.id as member_id,
        am.id as Anmol_master_id,
        am.case_no as Case_no,
        am.pregnancy_reg_det_id,
        case
          when rprd.reg_date is not null then rprd.reg_date
          else rprd.created_on
        end as created_Date,
        rpad.L2L_Preg_Complication as L2L_Preg_Complication,
        '' as Past_Illness,
        --'' as Last_Preg_Complication,
        case
          when rpad.Outcome_L2L_Preg is null then '0'
          else rpad.Outcome_L2L_Preg
        end as Outcome_L2L_Preg,
        case
          when rpad.registered_with_no_of_child is null then 0
          else rpad.registered_with_no_of_child
        end as No_Of_Pregnancy,
        --1 as Last_Preg_Complication_Length,
        case
          when rpad.Outcome_Last_Preg is null then 0
          else rpad.Outcome_Last_Preg
        end as Outcome_Last_Preg,
        0 as Past_Illness_Length,
        --19 as Expected_delivery_place,
        0 as DeliveryLocationID,
        case
          when rpad.L2L_Preg_Complication_Length is null then 0
          else rpad.L2L_Preg_Complication_Length
        end as L2L_Preg_Complication_Length,
        case
          when im.blood_group is not null then 1
          else 0
        end AS BloodGroup_Test,
        case
          when rpad.expected_delivery_place = 'SUBCENTER' then 24
          when rpad.expected_delivery_place = 'PHC' then 1
          when rpad.expected_delivery_place = 'UPHC' then 27
          when rpad.expected_delivery_place = 'CHC' then 2
          when rpad.expected_delivery_place = 'SUBDISTRICTHOSP' then 4
          when rpad.expected_delivery_place = 'DISTRICTHOSP' then 5
          when rpad.expected_delivery_place = 'TRUSTHOSP' then 99
          when rpad.expected_delivery_place = 'CHIRANJEEVIHOSP' then 99
          when rpad.expected_delivery_place = 'PRIVATEHOSP' then 21
          else 99
        end as expected_delivery_place_updated,
        CASE
          WHEN im.blood_group IS NOT NULL THEN CASE
            WHEN im.blood_group = 'A+' then '1'     --A+ve
            WHEN im.blood_group = 'B+' then '2'     --B+ve
            WHEN im.blood_group = 'AB+' then '3'    -- AB+ve
            WHEN im.blood_group = 'O+' then '4'     -- O+ve
            WHEN im.blood_group = 'A-' then '5'     -- A-ve
            WHEN im.blood_group = 'B-' then '6'     -- B-ve
            WHEN im.blood_group = 'AB-' then '7'    -- AB-ve
            WHEN im.blood_group = 'O-' then '8'     -- O-ve
            ELSE '9'        -- Not Known
          END
          ELSE '9'          -- Not Known
        END AS Blood_Group
      FROM anmol_master am
      inner join imt_member im on im.id = am.member_id --inner join imt_family imf on imf.id = am.family_id
      inner join rch_pregnancy_registration_det rprd on rprd.id = am.pregnancy_reg_det_id
      inner join anmol_location_mapping alm on alm.location_id = rprd.location_id
      inner join location_hierarchy_type lhtm on lhtm.location_id = rprd.location_id
      inner join rch_pregnancy_analytics_details rpad on rpad.pregnancy_reg_id = am.pregnancy_reg_det_id
      where
        am.mother_registration_status = 'SUCCESS'
        and am.mother_medial_registration_status is null

    ), rch_anc_master1 as (
      select
        rch.*,
        (
          select
            string_agg (danger_signs, '')
          from (
              select
                rcm_temp.id,
                case
                  when previous_pregnancy_complication = 'PIH' then 'C'
                  when previous_pregnancy_complication = 'CONVLS' then 'A' --when previous_pregnancy_complication = 'SEVANM'  then 'L'
                  when previous_pregnancy_complication = 'CAESARIAN' then 'G' --when previous_pregnancy_complication = 'MLPRST'  then 'L'
                  --when previous_pregnancy_complication = 'PRETRM'  then 'L'
                  when previous_pregnancy_complication = 'SBRTH' then 'E'
                  when previous_pregnancy_complication = 'APH' then 'B'
                  when previous_pregnancy_complication = 'CONGDEF' then 'F'
                  when previous_pregnancy_complication = 'PPH' then 'K'
                  when previous_pregnancy_complication = 'TWINS' then 'I' --when previous_pregnancy_complication = 'NK'  then 'L'
                  when previous_pregnancy_complication = 'OBSLBR' then 'J' --when previous_pregnancy_complication = 'PRELS'  then 'L'
                  --when previous_pregnancy_complication = 'PLPRE'  then 'L'
                  --when previous_pregnancy_complication = 'P2ABO'  then 'L'
                  --else 'L'
                end as danger_signs
              from rch_anc_master rcm_temp
              left join rch_anc_previous_pregnancy_complication_rel rappc on rcm_temp.id = rappc.anc_id
              where
                rappc.anc_id = rch.id
            ) as t1
          group by
            t1.id
        ) as previous_pregnancy_complication_array
      from rch_anc_master as rch
      where
        id in(
          select
            max(rprd.id)
          from rch_anc_master rprd
          inner join pregnancy_registration pr on pr.member_id = rprd.member_id
          group by
            rprd.pregnancy_reg_det_id
        )
    ), t_anmol_mother_medical as
    (select
      pr.*,
      case
        when VDRL_Test is not null then to_char(rch.service_date, 'yyyy-MM-dd')
        ELSE ''
      END as VDRL_Date,
      CASE
        WHEN rch.hiv_test IS NOT NULL THEN true
        ELSE false
      END AS HIV_Test,
      CASE
        WHEN rch.hiv_test IS NOT NULL
        and rch.hiv_test != 'NOT_DONE' THEN CASE
          WHEN rch.hiv_test = 'POSITIVE' then 'P'
          WHEN rch.hiv_test = 'NEGATIVE' then 'N'
          ELSE ''
        END
        ELSE ''
      END as HIV_Result,
      CASE
        WHEN rch.vdrl_test IS NOT NULL
        and rch.vdrl_test != 'NOT_DONE' THEN true
        ELSE false
      END AS VDRL_Test,
      CASE
        WHEN rch.vdrl_test IS NOT NULL THEN CASE
          WHEN rch.vdrl_test = 'POSITIVE' then 'P'
          WHEN rch.vdrl_test = 'NEGATIVE' then 'N'
          ELSE ''
        END
        ELSE ''
      END as VDRL_Result,
      case
        when expected_delivery_place_updated is null then 99
        else expected_delivery_place_updated
      end as Expected_delivery_place,
      previous_pregnancy_complication_array as Last_Preg_Complication,
      case
        when previous_pregnancy_complication_array is null then 0
        else length(previous_pregnancy_complication_array)
      end as Last_Preg_Complication_Length --	   ,rch.pregnancy_reg_det_id
,
      false as is_upload
    from pregnancy_registration pr
    left join rch_anc_master1 rch on pr.pregnancy_reg_det_id = rch.pregnancy_reg_det_id)
INSERT INTO anmol_mother_medical (
    rural_urban,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    mobile_relates_to,
    created_by,
    lmp_date,
    edd_date,
    reg_12weeks,
    created_on,
    registration_no,
    mobile_id,
    member_id,
    anmol_master_id,
    case_no,
    pregnancy_reg_det_id,
    created_date,
    l2l_preg_complication,
    past_illness,
    outcome_l2l_preg,
    no_of_pregnancy,
    outcome_last_preg,
    past_illness_length,
    deliverylocationid,
    l2l_preg_complication_length,
    bloodgroup_test,
    expected_delivery_place_updated,
    blood_group,
    vdrl_date,
    hiv_test,
    hiv_result,
    vdrl_test,
    vdrl_result,
    expected_delivery_place,
    last_preg_complication,
    last_preg_complication_length,
    is_upload
  )
select
tamm.rural_urban,
tamm.state_code,
tamm.district_code,
tamm.taluka_code,
tamm.village_code,
tamm.healthfacility_code,
tamm.healthsubfacility_code,
tamm.healthblock_code,
tamm.healthfacility_type,
tamm.asha_id,
tamm.anm_id,
tamm.mobile_relates_to,
tamm.created_by,
tamm.lmp_date,
tamm.edd_date,
tamm.reg_12weeks,
tamm.created_on,
tamm.registration_no,
tamm.mobile_id,
tamm.member_id,
tamm.anmol_master_id,
tamm.case_no,
tamm.pregnancy_reg_det_id,
tamm.created_date,
tamm.l2l_preg_complication,
tamm.past_illness,
tamm.outcome_l2l_preg,
tamm.no_of_pregnancy,
tamm.outcome_last_preg,
tamm.past_illness_length,
tamm.deliverylocationid,
tamm.l2l_preg_complication_length,
tamm.bloodgroup_test,
tamm.expected_delivery_place_updated,
tamm.blood_group,
tamm.vdrl_date,
tamm.hiv_test,
tamm.hiv_result,
tamm.vdrl_test,
tamm.vdrl_result,
tamm.expected_delivery_place,
tamm.last_preg_complication,
tamm.last_preg_complication_length,
tamm.is_upload
from t_anmol_mother_medical tamm
left join anmol_mother_medical amm
on amm.pregnancy_reg_det_id = tamm.pregnancy_reg_det_id
where amm.pregnancy_reg_det_id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED3'
where event_config_id = 96 and status = 'PROCESSED2';
commit ;

begin ;
-- mother anc
-- Drop table
-- DROP TABLE anmol_mother_anc;

with rch_anc_master1 as (
  select
    rcm.*
  from rch_anc_master rcm
  inner join anmol_master anmol on rcm.pregnancy_reg_det_id = anmol.pregnancy_reg_det_id
  where
    rcm.anmol_anc_status is null
    and mother_medial_registration_status = 'SUCCESS'
    and state = 'ACTIVE'
    and rcm.pregnancy_reg_det_id not in (11582517,11666027,12000869,12033693,12557635)	
    /* and rcm.pregnancy_reg_det_id not in (select pregnancy_reg_det_id from rch_wpd_mother_master
        where  state is null and has_delivery_happened
        and pregnancy_reg_det_id is not null and pregnancy_reg_det_id != -1
        group by pregnancy_reg_det_id
        having count(1)>1) */
), rch_visits as (
  select
    rch.id as rch_anc_master_id,
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    case when refPlaceValue.type = '1061' then 1   -- PHC
         when refPlaceValue.type = '1062' then 24    --SC
         when refPlaceValue.type = '1063' then 99   -- UPHC
         when refPlaceValue.type = '1064' then 99   -- Grant in Aid
         when refPlaceValue.type = '1007' then 5   -- District Hospital
         when refPlaceValue.type = '1008' then 99   -- Sub District Hospital
         when refPlaceValue.type = '1009' then 99   -- Community Health Center
         when refPlaceValue.type = '1010' then 99   -- Trust Hospital
         when refPlaceValue.type = '1012' then 99   -- Medical College Hospital
         when refPlaceValue.type = '1013' then 21   -- Private Hospital
         when refPlaceValue.type = '1011' then 21   -- Grant In Aid
         when refPlaceValue.type = '1084' then 99   -- Urban Community Health Center
         else 0
    end as Referral_facility,
    case when lmPlaceValue.id is null then 0 else lmPlaceValue.rch_code end as Referral_location,
    case when rch.referral_place is not null then to_char(rch.service_date, 'yyyy-MM-dd') else '' end as Referral_Date,
    case when ancPlaceValue.type = '1061' then 1   -- PHC
         when ancPlaceValue.type = '1062' then 24  --SC
         when ancPlaceValue.type = '1063' then 3   -- UPHC
         when ancPlaceValue.type = '1064' then 21  -- Grant in Aid
         when ancPlaceValue.type = '1007' then 5   -- District Hospital
         when ancPlaceValue.type = '1008' then 4   -- Sub District Hospital
         when ancPlaceValue.type = '1009' then 2   -- Community Health Center
         when ancPlaceValue.type = '1010' then 21  -- Trust Hospital
         when ancPlaceValue.type = '1012' then 17  -- Medical College Hospital
         when ancPlaceValue.type = '1013' then 21  -- Private Hospital
         when ancPlaceValue.type = '1011' then 21  -- Grant In Aid
         when ancPlaceValue.type = '1084' then 2   -- Urban Community Health Center
         else 19
    end as FacilityPlaceANCDone,


    -- for other public places
    case
      when ancPlaceValue.id is null then rch.delivery_place
      else ancPlaceValue.name_in_english
    end as FacilityLocationANCDone,
    case when lmAncPlace.id is null then 0 else lmAncPlace.rch_code end as FacilityLocationIDANCDone,
    alm.ANM_ID AS Created_By,
    case
      when extract(
        day
        from (
            case
              when rch.service_date is not null then rch.service_date
              else rch.created_on
            end
          ) - rprd.lmp_date
      ) <= 92 then 1
      when extract(
        day
        from (
            case
              when rch.service_date is not null then rch.service_date
              else rch.created_on
            end
          ) - rprd.lmp_date
      ) <= 190 then 2
      when extract(
        day
        from (
            case
              when rch.service_date is not null then rch.service_date
              else rch.created_on
            end
          ) - rprd.lmp_date
      ) <= 246 then 3
      when extract(
        day
        from (
            case
              when rch.service_date is not null then rch.service_date
              else rch.created_on
            end
          ) - rprd.lmp_date
      ) > 246 then 4
      else 4
    end as ANC_Type,
    case
      when rch.systolic_bp is null then 0
      else rch.systolic_bp
    end as BP_Systolic,
    case
      when rch.diastolic_bp is null then 0
      else rch.diastolic_bp
    end as BP_Distolic,
    case
      when rwmm.pregnancy_outcome in ('ABORTION', 'SPONT_ABORTION', 'MTP') then true
      else false
    end as Abortion_IfAny,
    to_char(rprd.lmp_date, 'yyyy-MM-dd') as LMP,
    case
      when rwmm.pregnancy_outcome in ('ABORTION', 'SPONT_ABORTION', 'MTP') then (
        (
          cast(rwmm.date_of_delivery as date) - cast(rprd.lmp_date as date)
        ) / 7
      )
      else 0
    end as Abortion_Preg_Weeks,
    case
      when rwmm.pregnancy_outcome in ('ABORTION', 'SPONT_ABORTION', 'MTP') then to_char(rwmm.date_of_delivery, 'yyyy-MM-dd')
    end as Abortion_date,
    case
      when rwmm.pregnancy_outcome in ('ABORTION', 'MTP') then 5
      when rwmm.pregnancy_outcome = 'SPONT_ABORTION' then 6
      else 0
    end as Abortion_Type,
    case
      when rwmm.pregnancy_outcome in ('ABORTION', 'MTP') THEN case
        when rwmm.delivery_place = 'HOSP'
        and rwmm.type_of_hospital in (898, 893, 1010, 1013) then 2
        else 1
      end
      else 0
    end as Induced_Indicate_Facility,
    case
      when rch.foetal_height is null then 0
      else rch.foetal_height
    end as Abdoman_FH,
    case
      when rch.foetal_position = 'VERTEX' then 1
      when rch.foetal_position = 'TRANSVERSE' then 2
      else 0
    end as Abdoman_FP,
    case when rch.family_planning_method is null then ''
          when rch.family_planning_method='PPIUCD' then 'A'
          when rch.family_planning_method='PPS' then 'B' -- We do not have PPS
          when rch.family_planning_method='MLSTR' then 'C'
          when rch.family_planning_method='CONDOM' then 'D'
          when rch.family_planning_method='ANY_TRADITIONAL_METHODS' then 'E' -- We do not have other traditional methods
          when rch.family_planning_method='CANT_DECIDE' then 'G' -- We do not have Cant Decide now option
          when rch.family_planning_method='NONE' then 'H'
          else 'F' end as PPMC,
    --0 as PPMC,
    case
      when rch.weight is null then 55.99
      else rch.weight
    end as Weight,
    case
      when rch.service_date is not null then rch.service_date
      else rch.created_on
    end as Created_Date,
    case
      when rch.haemoglobin_count is null then 0
      else haemoglobin_count
    end as Hb_gm,
    --CASE WHEN rim.immunisation_given = 'TT1' THEN to_char(rim.given_on,'yyyy-MM-dd') END as TT1_Date,
    --CASE WHEN rim.immunisation_given = 'TT2' THEN to_char(rim.given_on,'yyyy-MM-dd') END as TT2_Date,
    --CASE WHEN rim.immunisation_given = 'TT_BOOSTER' THEN to_char(rim.given_on,'yyyy-MM-dd') END as TTB_Date,
    case
      when rch.member_status = 'DEATH' then 'true'
      else 'false'
    end as Maternal_Death,
    case
      when rch.death_reason = '788' then 'A'    -- Eclampsia
      when rch.death_reason = '782' then 'B'    -- હેમરેજ (એ.પી.એચ.)
      when rch.death_reason = '783' then 'B'    -- હેમરેજ (પી.પી.એચ.)
      when rch.death_reason = '789' then 'D'    -- Abortion
      when rch.death_reason = '793' then 'E'    -- અન્ય
      when rch.death_reason = '784' then 'Z'    -- એનેમીયા
      when rch.death_reason = '785' then 'Z'    -- સેપ્સીસ
      when rch.death_reason = '786' then 'Z'    -- ઓબ્સ્ટ્રક્ટેડ લેબર
      when rch.death_reason = '787' then 'Z'    -- માલ પ્રેઝન્ટેશન
      when rch.death_reason = '790' then 'Z'    -- સર્જીકલ કોમ્પ્લિકેશન
      when rch.death_reason = '791' then 'Z'    -- બ્લડ ટ્રાન્સફ્યુઝન રિએઅક્શન
      when rch.death_reason = '792' then 'Z'    -- માતા મરણનાં કારણો સિવાયનુ  અન્ય કારણ
    end as Death_Reason,
    case
      when rch.sugar_test_before_food_val is null then 0
      else rch.sugar_test_before_food_val
    end as Blood_Sugar_Fasting,
    case
      when rch.sugar_test_after_food_val is null then 0
      else rch.sugar_test_after_food_val
    end as Blood_Sugar_Post_Prandial,
    case
      when (
        rch.ifa_tablets_given is null
        or (
          (
            cast(rch.service_date as date) - cast(rprd.lmp_date as date)
          ) <= 84
        )
      ) then 0
      when rch.ifa_tablets_given > 120 then 120
      else rch.ifa_tablets_given
    end as IFA_Given,
    case
      when (
        (rch.fa_tablets_given is null)
        or (
          (
            cast(rch.service_date as date) - cast(rprd.lmp_date as date)
          ) >= 84
        )
      ) then 0
      when rch.fa_tablets_given > 99 then 99
      else rch.fa_tablets_given
    end as FA_Given,
    (
      cast(rch.service_date as date) - cast(rprd.lmp_date as date)
    ) as totalWeek,
    -- date_part('month',age(rch.service_date,rprd.lmp_date )) as Pregnancy_Month,
    (
      cast(rch.service_date as date) - cast(rprd.lmp_date as date)
    ) / 7 as Pregnancy_Month,
    case
      when rch.foetal_movement = 'USUAL' then 1     -- Normal
      when rch.foetal_movement = 'DECREASED' then 3 -- Decreased
      when rch.foetal_movement = 'ABSENT' then 4    -- Absent
      else 1        -- -- Normal
    end as Foetal_Movements,
    case
      when rch.urine_sugar is null then ''
      when rch.urine_sugar = '0' then '0'
      else '1'
    end as Urine_Sugar,
    case
      when rch.Urine_Albumin is null then ''
      when rch.Urine_Albumin = '0' then '0'
      else '1'
    end as Urine_Albumin,
    case
      when rch.Urine_Test_Done is true then 1
      else 0
    end as Urine_Test,
    case
      when (
        blood_sugar_test = 'BOTH'
        or blood_sugar_test = 'EMPTY'
        or blood_sugar_test = 'NON_EMPTY'
      ) then 1
      else 0
    end as BloodSugar_Test,
    case
      when rch.death_date is not null then to_char(rch.death_date, 'yyyy-MM-dd')
    end as Death_Date,
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    to_char(rch.created_on, 'yyyy-MM-dd') as Created_On,
    to_char(rch.service_date, 'yyyy-MM-dd') as ANC_Date,
    am.eligible_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    am.case_no as Case_no,
    im.id as member_id,
    case
      when VDRL_Test is not null then to_char(rch.service_date, 'yyyy-MM-dd')
      ELSE ''
    END as VDRL_Date,
    (
      select
        string_agg(t1.danger_signs, '')
      from (
          select
            anc3.id,case
              when rads.dangerous_sign_id = 767 then 'A'        -- હાઇ બી.પી
              when rads.dangerous_sign_id = 909 then 'B'        -- Convulsions
              when rads.dangerous_sign_id = 914 then 'C'        -- Bleeding PV
              when rads.dangerous_sign_id = 911 then 'D'        -- Foul smelling discharge
              when rads.dangerous_sign_id = 765 then 'E'        -- ઓછું એચ.બી
              when rads.dangerous_sign_id = 769 then 'F'        -- યુરિન sugar
              when rads.dangerous_sign_id = 912 then 'G'        -- Twins
              when rads.dangerous_sign_id = 770 then 'H'        -- અન્‍ય જોખમી ચિહનો
              when rads.dangerous_sign_id = 771 then 'I'        -- કોઈ નહીં
              when other_dangerous_sign is not null
              and other_dangerous_sign != '' then 'Z' -- else 'Z'
            end as danger_signs
          from rch_anc_master anc3
          left join rch_anc_dangerous_sign_rel rads on anc3.id = rads.anc_id
          where
            anc3.id = rch.id
        ) as t1
      group by
        t1.id
    ) as Symptoms_High_RiskArray,
    other_dangerous_sign as Other_Symptoms_High_Risk
  from rch_anc_master1 rch
  inner join anmol_master am on am.member_id = rch.member_id
    and rch.pregnancy_reg_det_id = am.pregnancy_reg_det_id
  inner join imt_member im on im.id = am.member_id
  inner join imt_family imf on imf.id = rch.family_id
  inner join rch_pregnancy_registration_det rprd on rprd.id = am.pregnancy_reg_det_id
  inner join anmol_location_mapping alm on alm.location_id = rch.location_id
  left join health_infrastructure_details refPlaceValue on refPlaceValue.id = rch.referral_place
  left join location_master lmPlaceValue on lmPlaceValue.id = rch.referral_place
  left join health_infrastructure_details ancPlaceValue on ancPlaceValue.id = rch.health_infrastructure_id
  left join location_master lmAncPlace on lmAncPlace.id  = ancPlaceValue.location_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rch.location_id
  --left join  rch_anc_dangerous_sign_rel rads on rads.anc_id = rch.id
  --left join rch_immunisation_master rim on rim.visit_id = rch.id and rim.immunisation_given in ('TT1','TT2','TT_BOOSTER')
  left join rch_wpd_mother_master rwmm on rwmm.member_id = am.member_id
    and rwmm.pregnancy_reg_det_id = am.pregnancy_reg_det_id
    and rwmm.has_delivery_happened is true
    and rwmm.state is null
),
total_visit as (
  select
    sum(
      case
        when rcm1.service_date >= rcm2.service_date then 1
        else 0
      end
    ) as ANC_No,
    rcm1.id
  from rch_anc_master rcm1,
    rch_anc_master rcm2
  where
    rcm1.member_id = rcm2.member_id
    and rcm1.pregnancy_reg_det_id = rcm2.pregnancy_reg_det_id
    and rcm1.member_id in (
      select
        member_id
      from rch_anc_master1
    )
    and rcm1.pregnancy_reg_det_id in (
      select
        pregnancy_reg_det_id
      from rch_anc_master1
    )
  group by
    rcm1.id
),
immunisation as (
  select
    visit_id,
    to_char(
      max(
        case
          when immunisation_given = 'TT1' then given_on
          else null
        end
      ),
      'yyyy-MM-dd'
    ) as TT1_Date,
    to_char(
      max(
        case
          when immunisation_given = 'TT1'
          OR immunisation_given = 'TT2'
          OR immunisation_given = 'TT_BOOSTER' then given_on
          else null
        end
      ),
      'yyyy-MM-dd'
    ) as TT_Date,
    to_char(
      max(
        case
          when immunisation_given = 'TT2' then given_on
          else null
        end
      ),
      'yyyy-MM-dd'
    ) as TT2_Date,
    to_char(
      max(
        case
          when immunisation_given = 'TT_BOOSTER' then given_on
          else null
        end
      ),
      'yyyy-MM-dd'
    ) as TTB_Date,
    case
      when max(
        case
          when immunisation_given = 'TT1' then given_on
          else null
        end
      ) is not null then 13
      when max(
        case
          when immunisation_given = 'TT2' then given_on
          else null
        end
      ) is not null then 14
      when max(
        case
          when immunisation_given = 'TT_BOOSTER' then given_on
          else null
        end
      ) is not null then 17
      else 0
    end as TT_Code
  from rch_immunisation_master rim
  inner join rch_anc_master1 ram on rim.visit_id = ram.id
    and visit_type = 'FHW_ANC'
  group by
    visit_id
),
t_anmol_mother_anc as (
  select
    rv.*,
    tv.ANC_No,
    Symptoms_High_RiskArray as Symptoms_High_Risk,
    case
      when Symptoms_High_RiskArray is null then 0
      else length(Symptoms_High_RiskArray)
    end as Symptoms_High_Risk_Length,
    --array_to_string(rv.Symptoms_High_RiskArray,'') as Symptoms_High_Risk,
    --case when array_length(rv.Symptoms_High_RiskArray,1) is null then 0 else array_length(rv.Symptoms_High_RiskArray,1) end as Symptoms_High_Risk_Length,
    case
      when rv.death_reason = 'E' then 'No specified'
    end as Other_Death_Reason,
    im.*,
    false as is_upload
  from rch_visits rv
  inner join total_visit tv on rv.rch_anc_master_id = tv.id
  left join immunisation im on im.visit_id = rv.rch_anc_master_id
  order by
    anc_no
)
INSERT INTO anmol_mother_anc (
    rch_anc_master_id,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    facilityplaceancdone,
    facilitylocationancdone,
    facilitylocationidancdone,
    created_by,
    anc_type,
    bp_systolic,
    bp_distolic,
    abortion_ifany,
    lmp,
    abortion_preg_weeks,
    abortion_date,
    abortion_type,
    induced_indicate_facility,
    abdoman_fh,
    abdoman_fp,
    ppmc,
    weight,
    created_date,
    hb_gm,
    maternal_death,
    death_reason,
    blood_sugar_fasting,
    blood_sugar_post_prandial,
    ifa_given,
    fa_given,
    totalweek,
    pregnancy_month,
    foetal_movements,
    urine_sugar,
    urine_albumin,
    urine_test,
    bloodsugar_test,
    death_date,
    rural_urban,
    created_on,
    anc_date,
    registration_no,
    mobile_id,
    case_no,
    member_id,
    vdrl_date,
    symptoms_high_riskarray,
    other_symptoms_high_risk,
    anc_no,
    symptoms_high_risk,
    symptoms_high_risk_length,
    other_death_reason,
    visit_id,
    tt1_date,
    tt_date,
    tt2_date,
    ttb_date,
    tt_code,
    Referral_facility,
    Referral_location,
    is_upload
  )
select
  tama.rch_anc_master_id,
tama.state_code,
tama.district_code,
tama.taluka_code,
tama.village_code,
tama.healthfacility_code,
tama.healthsubfacility_code,
tama.healthblock_code,
tama.healthfacility_type,
tama.asha_id,
tama.anm_id,
tama.facilityplaceancdone,
tama.facilitylocationancdone,
tama.facilitylocationidancdone,
tama.created_by,
tama.anc_type,
tama.bp_systolic,
tama.bp_distolic,
tama.abortion_ifany,
tama.lmp,
tama.abortion_preg_weeks,
tama.abortion_date,
tama.abortion_type,
tama.induced_indicate_facility,
tama.abdoman_fh,
tama.abdoman_fp,
tama.ppmc,
tama.weight,
tama.created_date,
tama.hb_gm,
tama.maternal_death,
tama.death_reason,
tama.blood_sugar_fasting,
tama.blood_sugar_post_prandial,
tama.ifa_given,
tama.fa_given,
tama.totalweek,
tama.pregnancy_month,
tama.foetal_movements,
tama.urine_sugar,
tama.urine_albumin,
tama.urine_test,
tama.bloodsugar_test,
tama.death_date,
tama.rural_urban,
tama.created_on,
tama.anc_date,
tama.registration_no,
tama.mobile_id,
tama.case_no,
tama.member_id,
tama.vdrl_date,
tama.symptoms_high_riskarray,
tama.other_symptoms_high_risk,
tama.anc_no,
tama.symptoms_high_risk,
tama.symptoms_high_risk_length,
tama.other_death_reason,
tama.visit_id,
tama.tt1_date,
tama.tt_date,
tama.tt2_date,
tama.ttb_date,
tama.tt_code,
tama.Referral_facility,
tama.Referral_location,
tama.is_upload
from t_anmol_mother_anc tama
left join anmol_mother_anc ama on ama.rch_anc_master_id = tama.rch_anc_master_id
where
  ama.rch_anc_master_id IS NULL;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED4'
where event_config_id = 96 and status = 'PROCESSED3';
commit ;

begin ;
-- before mother delivery update ANC status

with preg_anc_updates_count as (
		select
		case when count(1) = count(1) filter (where rcm.anmol_anc_status is not null) then 'SUCCESS' else null end as status, -- if any pending then null else SUCCESS
		rcm.pregnancy_reg_det_id
		from rch_anc_master rcm
		inner join anmol_master anmol on anmol.member_id = rcm.member_id
		where
		anmol.mother_medial_registration_status = 'SUCCESS' and anmol.state='ACTIVE'
		and anmol.pregnancy_reg_det_id = anmol.pregnancy_reg_det_id
		group by rcm.pregnancy_reg_det_id
		having count(1)= count(1) filter (where rcm.anmol_anc_status is not null) )
		update anmol_master set anc_status = anc.status
		from  preg_anc_updates_count anc
		where anmol_master.pregnancy_reg_det_id = anc.pregnancy_reg_det_id
		and anc_status is null;
commit ;

begin ;
-- mother deliveries
-- Drop table
-- DROP TABLE anmol_mother_deliveries;

with delivery as (
  SELECT
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    to_char(rwmm.discharge_date, 'yyyy-MM-dd') as Discharge_Date,
    to_char(rwmm.discharge_date, 'HH:MI:PM') as Discharge_Time,
    to_char(rwmm.date_of_delivery, 'yyyy-MM-dd') as Delivery_date,
    to_char(rwmm.date_of_delivery, 'HH:MI:PM') as Delivery_Time,
    case
      when rwmm.delivery_place = 'ON_THE_WAY' THEN 'On the way'
      else rwmm.delivery_place
    end as Delivery_Location,
    --CASE WHEN rwmm.pregnancy_outcome = 'LBIRTH' then 1 else 0 end as LiveBirth,
    --CASE WHEN rwmm.pregnancy_outcome = 'SBIRTH' then 1 else 0 end as StillBirth,
    case
      when rwmm.other_danger_signs is null
      or rwmm.other_danger_signs = '' then array(
        select
          case
            when mother_danger_signs = 799 then 'A'     -- PPH
            when mother_danger_signs = 800 then 'B'     -- Retained Placenta
            when mother_danger_signs = 801 then 'C'     -- Obstructed labour
            when mother_danger_signs = 802 then 'D'     -- Prolapse Cord
            when mother_danger_signs = 803 then 'E'     -- Twins
            when mother_danger_signs = 805 then 'G'     -- Maternal Death
            when mother_danger_signs = 807 then 'H'     -- Others
            when mother_danger_signs = 804 then 'H'     -- Eclemcia
            when mother_danger_signs = 806 then 'H'     -- Severe Anemia
          end
        from rch_wpd_mother_danger_signs_rel rappc
        where
          rappc.wpd_id = rwmm.id
      )
      else array ['H']
    end as Delivery_Complication_Array,
    rwmm.other_danger_signs as OtherDelivery_Complication,
    CASE
      WHEN rwmm.type_of_delivery = 'CAESAREAN' then 2       -- Cesarian
      WHEN rwmm.type_of_delivery = 'ASSIT' then 3       -- Assissted
      WHEN rwmm.type_of_delivery = 'ASSIST' then 3      -- Assissted
      WHEN rwmm.type_of_delivery = 'NORMAL' then 1      -- Normal
      ELSE 1
    END as Delivery_Type,
    --CASE WHEN pregnancy_outcome = 'SBIRTH' then 1
    --     WHEN pregnancy_outcome = 'ABORTION' then 1
    --     WHEN pregnancy_outcome = 'LBIRTH' then 1
    --     WHEN pregnancy_outcome = 'MTP' then 1
    --     ELSE 1 END as Delivery_Outcomes,
    CASE
      WHEN death_reason IS NOT NULL THEN CASE
        WHEN death_reason = '788' THEN 1        --Eclampsia
        WHEN death_reason = '782' THEN 2        -- Haemorrahge
        WHEN death_reason = '783' THEN 2        -- Haemorrahge
        WHEN death_reason = '786' THEN 3        -- Obstructed Labour
        ELSE 99
      END
      ELSE 0
    END AS Death_Cause,
    CASE
      WHEN im.jsy_beneficiary then true
      ELSE false
    end as JSY_Benificiary,
    CASE
      WHEN im.jsy_payment_given then 'S'
      ELSE 'N'
    end as JSY_Payment_Received,
    rwmm.date_of_delivery,
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    alm.ANM_ID as Created_By,
    am.case_no as Case_no,
    case
      when rwmm.delivery_place = 'Home' then 22
      when rwmm.delivery_place = 'On the way' then 23
      when rwmm.delivery_place = 'HOSP' then case
        when type_of_hospital = '890' then 4 -- for તાલુકા હોસ્પિટલ/Sdh
        when type_of_hospital = '891' then 17 -- for જનરલ હોસ્પિટલ/Medical College Hospital
        when type_of_hospital = '892' then 21 -- for ચિરંજીવી હોસ્પિટલ
        when type_of_hospital = '893' then 21 -- for ખાનગી હોસ્પિટલ(ચિરંજીવી સિવાયની)
        when type_of_hospital = '894' then 3 -- for શહેરી આરોગ્ય કેન્દ્ર
        when type_of_hospital = '896' then 5 -- for જિલ્લા હોસ્પિટલ
        when type_of_hospital = '897' then 4 -- for પેટા કેન્દ્ર
        when type_of_hospital = '898' then 21 -- for ટ્રસ્ટ હોસ્પિટલ
        when type_of_hospital = '899' then 1 -- for પ્રા.આ.કેન્દ્ર
        when type_of_hospital = '895' then 2 -- for સા.આ.કેન્દ્ર
        when type_of_hospital = '904' then 22 -- HOME
        when type_of_hospital = '1061' then 1 -- PHC
        when type_of_hospital = '1062' then 24 -- SC
        when type_of_hospital = '1063' then 3 -- UPHC
        when type_of_hospital = '1064' then 21 -- Grant in Aid
        when type_of_hospital = '1007' then 5 -- District Hospital
        when type_of_hospital = '1008' then 4 -- Sub District Hospital
        when type_of_hospital = '1009' then 2 -- Community Health Center
        when type_of_hospital = '1010' then 21 -- Trust Hospital
        when type_of_hospital = '1012' then 17 -- Medical College Hospital
        when type_of_hospital = '1013' then 21 -- Private Hospital
        when type_of_hospital = '1011' then 21 -- Grant In Aid
        when type_of_hospital = '1084' then 2 -- Urban Community Health Center
        else 19
      end
      when rwmm.delivery_place = 'Private Hospital' then 21
      else 19
    end as Delivery_Place,
    0 AS DeliveryLocationID,
    99 AS DeliveryLocation,
    case
      when rwmm.delivery_done_by = 'NON-TBA' then 99        -- Other
      when rwmm.delivery_done_by = 'NON_TBA' then 99        -- Other
      when rwmm.delivery_done_by = 'TBA' then 99            -- Other
      when rwmm.delivery_done_by = 'DOCTOR' then 3          --Doctor
      when rwmm.delivery_done_by = 'CY-Doctor' then 3          --Doctor
      when rwmm.delivery_done_by = 'STAFF_NURSE' then 4     -- Staff Nurse
      when rwmm.delivery_done_by = 'NURSE' then 4       -- Staff Nurse
      when rwmm.delivery_done_by = 'ANM' then 1     -- ANM
      else 99
    end AS Delivery_Conducted_By,
    am.eligible_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    am.member_id as member_id,
    am.id as Anmol_master_id,
    case
      when rwmm.date_of_delivery is not null then rwmm.date_of_delivery
      else rwmm.created_on
    end as Created_Date,
    rwmm.id as rch_wpd_mother_master_id,
    to_char(rwmm.created_on, 'yyyy-MM-dd') as Created_On
  FROM rch_wpd_mother_master rwmm
  INNER JOIN anmol_master am on am.member_id = rwmm.member_id
    and rwmm.pregnancy_reg_det_id = am.pregnancy_reg_det_id
  inner join imt_member im on im.id = am.member_id
  inner join imt_family imf on imf.family_id = im.family_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rwmm.location_id
  inner join anmol_location_mapping alm on alm.location_id = rwmm.location_id
  WHERE
    am.mother_medial_registration_status = 'SUCCESS'
    and am.anc_status = 'SUCCESS'
    and am.mother_delivery_status is null
    and rwmm.pregnancy_outcome in ('SBIRTH', 'LBIRTH')
    and rwmm.has_delivery_happened is true
    and rwmm.state is null

), delivery_with_complications as(
  select
    *,
    array_to_string(Delivery_Complication_Array, '') as Delivery_Complication --case when array_length(Delivery_Complication_Array,1) is null then 0 else array_length(Delivery_Complication_Array,1) end as Delivery_Complication
  from delivery
),
count_outcomes as (
  select
    wpd_mother_id,
    sum(
      (
        CASE
          WHEN pregnancy_outcome = 'LBIRTH' then 1
          else 0
        end
      )
    ) LiveBirth,
    sum(
      (
        CASE
          WHEN pregnancy_outcome = 'SBIRTH' then 1
          else 0
        end
      )
    ) StillBirth,
    sum(
      (
        CASE
          WHEN pregnancy_outcome = 'SBIRTH'
          or pregnancy_outcome = 'LBIRTH' then 1
          else 0
        end
      )
    ) Delivery_Outcomes
  from delivery_with_complications d
  inner join rch_wpd_child_master rwcm on d.rch_wpd_mother_master_id = rwcm.wpd_mother_id
  group by
    rwcm.wpd_mother_id
),
t_anmol_mother_deliveries as (
  select
    *,
    false as is_upload
  from delivery_with_complications d
  inner join count_outcomes co on co.wpd_mother_id = d.rch_wpd_mother_master_id
)
INSERT INTO anmol_mother_deliveries (
    rural_urban,
    discharge_date,
    discharge_time,
    delivery_date,
    delivery_time,
    delivery_location,
    delivery_complication_array,
    otherdelivery_complication,
    delivery_type,
    death_cause,
    jsy_benificiary,
    jsy_payment_received,
    date_of_delivery,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    created_by,
    case_no,
    delivery_place,
    deliverylocationid,
    deliverylocation,
    delivery_conducted_by,
    registration_no,
    mobile_id,
    member_id,
    anmol_master_id,
    created_date,
    rch_wpd_mother_master_id,
    created_on,
    delivery_complication,
    wpd_mother_id,
    livebirth,
    stillbirth,
    delivery_outcomes,
    is_upload
  )
select
  tamd.rural_urban,
tamd.discharge_date,
tamd.discharge_time,
tamd.delivery_date,
tamd.delivery_time,
tamd.delivery_location,
tamd.delivery_complication_array,
tamd.otherdelivery_complication,
tamd.delivery_type,
tamd.death_cause,
tamd.jsy_benificiary,
tamd.jsy_payment_received,
tamd.date_of_delivery,
tamd.state_code,
tamd.district_code,
tamd.taluka_code,
tamd.village_code,
tamd.healthfacility_code,
tamd.healthsubfacility_code,
tamd.healthblock_code,
tamd.healthfacility_type,
tamd.asha_id,
tamd.anm_id,
tamd.created_by,
tamd.case_no,
tamd.delivery_place,
tamd.deliverylocationid,
tamd.deliverylocation,
tamd.delivery_conducted_by,
tamd.registration_no,
tamd.mobile_id,
tamd.member_id,
tamd.anmol_master_id,
tamd.created_date,
tamd.rch_wpd_mother_master_id,
tamd.created_on,
tamd.delivery_complication,
tamd.wpd_mother_id,
tamd.livebirth,
tamd.stillbirth,
tamd.delivery_outcomes,
tamd.is_upload
from t_anmol_mother_deliveries tamd
left join anmol_mother_deliveries amd on tamd.rch_wpd_mother_master_id = amd.rch_wpd_mother_master_id
where
  amd.rch_wpd_mother_master_id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED5'
where event_config_id = 96 and status = 'PROCESSED4';
commit ;


begin ;

-- mother infants
-- Drop table
--  DROP TABLE anmol_mother_infants;

with MotherInfants as (
  select
    case
      when rwcm.breast_feeding_in_one_hour is null then true
      else rwcm.breast_feeding_in_one_hour
    end as Breast_Feeding,
    case
      when rwcm.baby_cried_at_birth is true then 'Y'
      when baby_cried_at_birth is false then 'N'
      else ''
    end as Baby_Cried_Immediately_At_Birth,
    case
      when rwcm.birth_weight is null then 2.99
      else rwcm.birth_weight
    end as Weight,
    rwcm.gender as Gender_Infant,
    --'' as OPV_Date,
    --'' as BCG_Date,
    --'' as HEP_B_Date,
    --'' as HEP_B_Date,
    am.eligible_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    im.first_name as Infant_Name,
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    row_number() OVER (PARTITION BY rwmm.pregnancy_reg_det_id) AS infant_No,
    0 as Resucitation_Done,
    --7 as Any_Defect_Seen_At_Birth,
    to_char(rwcm.created_on, 'yyyy-MM-dd') as Created_On,
    am.member_id as Member_Id,
    am.Pregnancy_reg_det_id as Pregnancy_reg_det_id,
    rwcm.member_id as Child_Id,
    case
      when rwcm.date_of_delivery is not null then rwcm.date_of_delivery
      else rwcm.created_on
    end as Created_Date,
    rwcm.id as rwcmId,
    rwcm.id as rch_wpd_child_master_id,
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    am.case_no as Case_no,
    am.id as Anmol_master_id,
    alm.ANM_ID AS Created_By,
    case
      when rwmm.is_preterm_birth is true then 'P'
      else 'F'
    end as Infant_Term,
    case
      when rwmm.cortico_steroid_given is true then 'Y'
      when rwmm.cortico_steroid_given is false then 'N'
      else 'NA'
    end as Inj_Corticosteriods_Given,
    'N' as Higher_Facility --rim.immunisation_given
  from anmol_master am
  inner join rch_wpd_child_master rwcm on rwcm.mother_id = am.member_id
  inner join rch_wpd_mother_master rwmm on rwmm.id = rwcm.wpd_mother_id
  inner join imt_member im on im.id = rwcm.member_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rwcm.location_id
  inner join anmol_location_mapping alm on alm.location_id = rwcm.location_id --left join rch_immunisation_master  rim on rim.member_id = rwcm.member_id and rwcm.id = rim.visit_id and rim.member_type='C' and rim.immunisation_given in('OPV','BCG','HEPATITIS_B_0','VITAMIN K')
  where
    rwmm.pregnancy_reg_det_id = am.pregnancy_reg_det_id
    and am.child_infant_registration_status is null
    and am.mother_delivery_status = 'SUCCESS'
    and rwmm.has_delivery_happened is true
    and rwmm.state is null
    AND im.basic_state in ('NEW', 'VERIFIED', 'REVERIFICATION', 'DEAD')

), immunisation as (
  select
    visit_id,
    max(
      case
        when immunisation_given = 'OPV_0' then given_on
        else null
      end
    ) as OPV_Date,
    max(
      case
        when immunisation_given = 'BCG' then given_on
        else null
      end
    ) as BCG_Date,
    max(
      case
        when immunisation_given = 'HEPATITIS_B_0' then given_on
        else null
      end
    ) as HEP_B_Date,
    max(
      case
        when immunisation_given = 'VITAMIN_K' then given_on
        else null
      end
    ) as Vit_K_Date
  from rch_immunisation_master rim
  inner join MotherInfants mi on rim.visit_id = mi.rwcmId
    and rim.visit_type in('FHW_WPD', 'FHW WPD')
    and rim.member_type = 'C'
    and rim.member_id = mi.child_id
  group by
    visit_id
),
AnyDefect as (
  select
    case
      when max(congential_deformity) = 798 then 2       -- Club foot
      when max(congential_deformity) = 797 then 1       -- Cleft lip/Cleft plate
      when max(congential_deformity) = 796 then 6       -- Natural tube defect (spina bifida)
      when max(congential_deformity) = 905 then 3       -- Down’s Syndrome
      when max(congential_deformity) = 906 then 4       -- Hydrocephalus
      when max(congential_deformity) = 1065 then 99     -- Talipes
      when max(congential_deformity) = 1068 then 99     -- Congenital deafness
      when max(congential_deformity) = 1065 then 99     -- Talipes
      when max(congential_deformity) = 1070 then 99     -- Retinopathy of prematurity
      when max(congential_deformity) = 1066 then 99     -- Develop mental dysplasia of hip
      when max(congential_deformity) = 1067 then 99     -- Congenital cataract
      when max(congential_deformity) = 1069 then 99     -- Congenital heart disease
      when max(congential_deformity) = 907 then 99      -- Cerebral Palsy
      when max(congential_deformity) = 908 then 5       -- Imperforate Anus
      else 7
    end as Any_Defect_Seen_At_Birth,
    rwccdr.wpd_id as wpd_id
  from rch_wpd_child_congential_deformity_rel rwccdr
  inner join MotherInfants mi on mi.rwcmId = rwccdr.wpd_id
  group by
    rwccdr.wpd_id
),
t_anmol_mother_infants as (
  select
    *,
    false as is_upload
  from MotherInfants mi
  left join immunisation m on m.visit_id = mi.rwcmId
  left join AnyDefect ad on ad.wpd_id = mi.rwcmId
  order by
    infant_No
)
INSERT INTO anmol_mother_infants (
    breast_feeding,
    baby_cried_immediately_at_birth,
    weight,
    gender_infant,
    registration_no,
    mobile_id,
    infant_name,
    rural_urban,
    infant_no,
    resucitation_done,
    created_on,
    member_id,
    pregnancy_reg_det_id,
    child_id,
    created_date,
    rwcmid,
    rch_wpd_child_master_id,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    case_no,
    anmol_master_id,
    created_by,
    infant_term,
    inj_corticosteriods_given,
    higher_facility,
    visit_id,
    opv_date,
    bcg_date,
    hep_b_date,
    vit_k_date,
    any_defect_seen_at_birth,
    wpd_id,
    is_upload
  )
select
  tami.breast_feeding,
tami.baby_cried_immediately_at_birth,
tami.weight,
tami.gender_infant,
tami.registration_no,
tami.mobile_id,
tami.infant_name,
tami.rural_urban,
tami.infant_no,
tami.resucitation_done,
tami.created_on,
tami.member_id,
tami.pregnancy_reg_det_id,
tami.child_id,
tami.created_date,
tami.rwcmid,
tami.rch_wpd_child_master_id,
tami.state_code,
tami.district_code,
tami.taluka_code,
tami.village_code,
tami.healthfacility_code,
tami.healthsubfacility_code,
tami.healthblock_code,
tami.healthfacility_type,
tami.asha_id,
tami.anm_id,
tami.case_no,
tami.anmol_master_id,
tami.created_by,
tami.infant_term,
tami.inj_corticosteriods_given,
tami.higher_facility,
tami.visit_id,
tami.opv_date,
tami.bcg_date,
tami.hep_b_date,
tami.vit_k_date,
tami.any_defect_seen_at_birth,
tami.wpd_id,
tami.is_upload
from t_anmol_mother_infants tami
left join anmol_mother_infants ami on ami.rch_wpd_child_master_id = tami.rch_wpd_child_master_id
where
  ami.rch_wpd_child_master_id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED6'
where event_config_id = 96 and status = 'PROCESSED5';
commit ;

begin ;
-- get Mother PNC
-- Drop table
--  DROP TABLE anmol_mother_pnc;
with t_anmol_mother_pnc as (
  select
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    alm.ANM_ID AS Created_By,
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    case
      when tpmm.ifa_tablets_given is null then 0
      else tpmm.ifa_tablets_given
    end No_of_IFA_Tabs_given_to_mother,
    case
      when tpmm.is_alive is false then true
      else false
    end as Mother_Death,
    to_char(tpmm.death_date, 'yyyy-MM-dd') as Mother_Death_Date,
    case
      when tpmm.is_alive is false then case
        when tpmm.death_reason = '788' then 'A'     -- Eclampsia
        when tpmm.death_reason = '782' then 'B'     -- હેમરેજ (એ.પી.એચ.)
        when tpmm.death_reason = '783' then 'B'     -- હેમરેજ (પી.પી.એચ.)
        when tpmm.death_reason = '789' then 'D'     -- Abortion
        else 'Z'
      end
      else ''
    end as Mother_Death_Reason,
    case
      when tpmm.service_date is not null then to_char(tpmm.service_date, 'yyyy-MM-dd')
      else to_char(tpmm.created_on, 'yyyy-MM-dd')
    end as PNC_Date,
    tpmm.other_death_reason as Mother_Death_Reason_Other,
    am.eligible_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    am.case_no as Case_no,
    case
      when tpmm.family_planning_method is null then '0'
      when tpmm.family_planning_method = 'PPIUCD' then 'A'
      when tpmm.family_planning_method = 'CONDOM' then 'B'
      when tpmm.family_planning_method = 'MLSTR' then 'C'
      when tpmm.family_planning_method = 'PPS' then 'D'
      when tpmm.family_planning_method in ('NONE', 'none') then 'E'
      else 'F'
    end as PPC,
    case
      when tpmm.family_planning_method = 'OTHER' then 'Other'
      when tpmm.family_planning_method = 'ANTARA' then 'Antara'
      when tpmm.family_planning_method = 'CHHANT' then 'Chhant'
      when tpmm.family_planning_method = 'IUCD10' then 'IUCD10Years'
      when tpmm.family_planning_method = 'IUCD5' then 'IUCD5Years'
      when tpmm.family_planning_method = 'ORALPILLS' then 'OralPills'
      when tpmm.family_planning_method = 'CONTRA' then 'ContraceptivePills'
      when tpmm.family_planning_method = 'FMLSTR' then 'FemaleSterlization'
      when tpmm.family_planning_method = 'CHHAYA' then 'Chhaya'
      when tpmm.family_planning_method = 'OTHER' then 'Other'
      else ''
    end as OtherPPC_Method,
    tpmm.other_danger_sign as DangerSign_Mother_Other,
    case
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 1 then 1
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 3 then 2
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 7 then 3
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 14 then 4
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 21 then 5
      when extract(
        day
        from (
            case
              when tpmm.service_date is not null then tpmm.service_date
              else tpmm.created_on
            end
          ) - tpmm.date_of_delivery
      ) <= 28 then 6
      else 7
    end as PNC_Type,
    (
      select
        string_agg(distinct signs, '')
      from (
          select
            rch.id,
            tpmm.other_death_reason as Mother_Death_Reason_Other,
            case
              when mother_danger_signs = 833 then 'A' -- PPH
              when mother_danger_signs = 839 then 'B' -- Fever
              when mother_danger_signs = 842 then 'C' -- Sepsis
              --	   	when mother_danger_signs =  then 'D'	-- Severe Abdominal Pain
              when mother_danger_signs = 834 then 'E' -- Severe Headache or Blurred Vision
              when mother_danger_signs = 835 then 'F' -- Difficult Breathing
              when mother_danger_signs = 843 then 'G' -- Fever / Chills
              when mother_danger_signs in (846, 836, 837, 838, 840, 841, 842, 844) then 'Z' -- Any Other (Specify)
              when mother_danger_signs is null then 'Y' -- None
            end as signs
          from rch_pnc_mother_master rch
          left join rch_pnc_mother_danger_signs_rel rpds on rch.id = rpds.mother_pnc_id
          where
            rpds.mother_pnc_id = tpmm.id
        ) as t1
      group by
        t1.id
    ) as DangerSign_Mother,
    (
      select
        case
          when length(string_agg(distinct signs, '')) is null then 0
          else length(string_agg(distinct signs, ''))
        end
      from (
          select
            rch.id,
            case
              when mother_danger_signs = 833 then 'A' -- PPH
              when mother_danger_signs = 839 then 'B' -- Fever
              when mother_danger_signs = 842 then 'C' -- Sepsis
              --	   	when mother_danger_signs =  then 'D'	-- Severe Abdominal Pain
              when mother_danger_signs = 834 then 'E' -- Severe Headache or Blurred Vision
              when mother_danger_signs = 835 then 'F' -- Difficult Breathing
              when mother_danger_signs = 843 then 'G' -- Fever / Chills
              when mother_danger_signs in (846, 836, 837, 838, 840, 841, 842, 844) then 'Z' -- Any Other (Specify)
              when mother_danger_signs is null then 'Y' -- None
              when rch.other_danger_sign is not null
              and rch.other_danger_sign != '' then 'Z'
            end as signs
          from rch_pnc_mother_master rch
          left join rch_pnc_mother_danger_signs_rel rpds on rch.id = rpds.mother_pnc_id
          where
            rpds.mother_pnc_id = tpmm.id
        ) as t1
      group by
        t1.id
    ) as DangerSign_Mother_length,
    am.member_id as member_id,
    case
      when tpmm.service_date is not null then tpmm.service_date
      else tpmm.created_on
    end as Created_Date,
    to_char(tpmm.created_on, 'yyyy-MM-dd') as Created_On,
    (
      select
        count(1)
      from rch_pnc_mother_master mother,
        rch_pnc_master master
      where
        mother.pnc_master_id = master.id
        and master.pregnancy_reg_det_id = rpm.pregnancy_reg_det_id
        and master.service_date <= rpm.service_date
    ) as PNC_No,
    tpmm.id as Rch_Pnc_Mother_Master_Id,
    false as is_upload
  from anmol_master am
  inner join rch_pnc_master rpm on rpm.pregnancy_reg_det_id = am.pregnancy_reg_det_id
  inner join rch_pnc_mother_master tpmm on tpmm.pnc_master_id = rpm.id
  inner join imt_family imf on imf.id = rpm.family_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rpm.location_id
  inner join anmol_location_mapping alm on alm.location_id = rpm.location_id
  where
    am.child_infant_registration_status = 'SUCCESS'
    and tpmm.anmol_pnc_status is null
  order by
    PNC_Date
)
INSERT INTO anmol_mother_pnc (
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    created_by,
    rural_urban,
    no_of_ifa_tabs_given_to_mother,
    mother_death,
    mother_death_date,
    mother_death_reason,
    pnc_date,
    mother_death_reason_other,
    registration_no,
    mobile_id,
    case_no,
    ppc,
    otherppc_method,
    dangersign_mother_other,
    pnc_type,
    dangersign_mother,
    dangersign_mother_length,
    member_id,
    created_date,
    created_on,
    pnc_no,
    rch_pnc_mother_master_id,
    is_upload
  )
select
  tamp.state_code,
tamp.district_code,
tamp.taluka_code,
tamp.village_code,
tamp.healthfacility_code,
tamp.healthsubfacility_code,
tamp.healthblock_code,
tamp.healthfacility_type,
tamp.asha_id,
tamp.anm_id,
tamp.created_by,
tamp.rural_urban,
tamp.no_of_ifa_tabs_given_to_mother,
tamp.mother_death,
tamp.mother_death_date,
tamp.mother_death_reason,
tamp.pnc_date,
tamp.mother_death_reason_other,
tamp.registration_no,
tamp.mobile_id,
tamp.case_no,
tamp.ppc,
tamp.otherppc_method,
tamp.dangersign_mother_other,
tamp.pnc_type,
tamp.dangersign_mother,
tamp.dangersign_mother_length,
tamp.member_id,
tamp.created_date,
tamp.created_on,
tamp.pnc_no,
tamp.rch_pnc_mother_master_id,
tamp.is_upload
from t_anmol_mother_pnc tamp
left join anmol_mother_pnc amp on tamp.Rch_Pnc_Mother_Master_Id = amp.Rch_Pnc_Mother_Master_Id
where
  amp.Rch_Pnc_Mother_Master_Id IS NULL;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED7'
where event_config_id = 96 and status = 'PROCESSED6';
commit ;

begin ;

-- child registration
-- Drop table
-- DROP TABLE anmol_child_registration;
with t_anmol_child_registration as (
select
  alm.State_Code as State_Code,
  alm.District_Code as District_Code,
  alm.Taluka_Code as Taluka_Code,
  alm.Village_Code as Village_Code,
  alm.Health_Facility_Code as HealthFacility_Code,
  alm.Health_SubFacility_Code as HealthSubFacility_Code,
  alm.Health_Block_Code as HealthBlock_Code,
  alm.Health_Facility_Type as HealthFacility_Type,
  alm.ASHA_ID as ASHA_ID,
  alm.ANM_ID as ANM_ID,
  --                    acm.case_no as Case_no,
  --                    alm.ANM_ID AS Created_By,
  CASE
    WHEN (
      hierarchy_type = 'C'
      OR hierarchy_type = 'U'
    ) then 'U'
    ELSE 'R'
  END as rural_Urban,
  to_char(im.created_on, 'yyyy-MM-dd') as Registration_Date,
  im.gender as Gender,
  to_char(im.dob, 'yyyy-MM-dd') Birth_Date,
  im.first_name as Name_Child,
  im_mother.first_name as Name_Mother,
  im_mother.middle_name as Name_Father,
  case
    when im_mother.mobile_number is null
    or im_mother.mobile_number = '0000000000' then '9999999999'
    else im_mother.mobile_number
  end AS Mobile_no,
  concat_ws(',', ifm.address1, ifm.address2) as Address,
  case
    when ifm.caste = '625' then 2   -- ST
    when ifm.caste = '624' then 1   -- Scheduled Caste
    else 99 -- Others
  end as Caste,
  case
    when ifm.religion = '623' then 1    -- CHRISTIAN
    when ifm.religion = '621' then 2    -- HINDU
    when ifm.religion = '622' then 3    -- MUSLIM
    else 99     -- OTHERS, we are not taking Sikh
  end as Religion_Code,
  0 as Identity_type,
  alm.ANM_ID as Created_By,
  'H' as Mobile_Relates_To,
  acm.case_no as Case_no,
  4 as Status,
  case
    when rwmm.delivery_place = 'Home' then 22
    when rwmm.delivery_place = 'On the way' then 23
    when rwmm.delivery_place = 'HOSP' then case
      when type_of_hospital = '890' then 4 -- for તાલુકા હોસ્પિટલ/Sdh
      when type_of_hospital = '891' then 17 -- for જનરલ હોસ્પિટલ/Medical College Hospital
      when type_of_hospital = '892' then 20 -- for ચિરંજીવી હોસ્પિટલ
      when type_of_hospital = '893' then 20 -- for ખાનગી હોસ્પિટલ(ચિરંજીવી સિવાયની)
      when type_of_hospital = '894' then 3 -- for શહેરી આરોગ્ય કેન્દ્ર
      when type_of_hospital = '896' then 5 -- for જિલ્લા હોસ્પિટલ
      when type_of_hospital = '897' then 4 -- for પેટા કેન્દ્ર
      when type_of_hospital = '898' then 20 -- for ટ્રસ્ટ હોસ્પિટલ
      when type_of_hospital = '899' then 1 -- for પ્રા.આ.કેન્દ્ર
      when type_of_hospital = '895' then 2 -- for સા.આ.કેન્દ્ર
      when type_of_hospital = '904' then 22 -- HOME
      when type_of_hospital = '1061' then 1 -- PHC
      when type_of_hospital = '1062' then 24 -- SC
      when type_of_hospital = '1063' then 3 -- UPHC
      when type_of_hospital = '1064' then 20 -- Grant in Aid
      when type_of_hospital = '1007' then 5 -- District Hospital
      when type_of_hospital = '1008' then 4 -- Sub District Hospital
      when type_of_hospital = '1009' then 2 -- Community Health Center
      when type_of_hospital = '1010' then 21 -- Trust Hospital
      when type_of_hospital = '1012' then 17 -- Medical College Hospital
      when type_of_hospital = '1013' then 21 -- Private Hospital
      when type_of_hospital = '1011' then 21 -- Grant In Aid
      when type_of_hospital = '1084' then 2 -- Urban Community Health Center
      else 19
    end
    when rwmm.delivery_place = 'Private Hospital' then 21
    else 19
  end as Birth_place,
  CASE
    WHEN rwmm.delivery_place = 'ON_THE_WAY' THEN 'On the way'
    else rwmm.delivery_place
  end as Delivery_Location,
  im.id as Register_srno,
  0 as DeliveryLocationID,
  im.aadhar_number_encrypted as Child_Aadhar_No,
  am.eligible_registration_id as Mother_Reg_no,
  am.eligible_mobile_id as Mobile_ID,
  acm.child_infant_registration_id as Registration_no,
  case
    when rwcm.birth_weight is null then 3.99
    else im.birth_weight
  end as Weight,
  case
    when im.dob is not null then im.dob
    else im.created_on
  end as Created_Date,
  am.id as Anmol_Master_Id,
  acm.Member_Id as Member_Id,
  acm.Child_Id as Child_Id,
  acm.id as Anmol_Child_Master_Id,
  false as is_upload
from anmol_child_master acm
inner join anmol_master am on am.id = acm.anmol_master_id
inner join rch_wpd_child_master rwcm on rwcm.member_id = acm.child_id
inner join rch_wpd_mother_master rwmm on rwmm.id = rwcm.wpd_mother_id
inner join imt_member im on im.id = rwcm.member_id
inner join imt_family ifm on ifm.id = rwcm.family_id
inner join imt_member im_mother on im_mother.id = acm.member_id
inner join location_hierarchy_type lhtm on lhtm.location_id = rwcm.location_id
inner join anmol_location_mapping alm on alm.location_id = rwcm.location_id
where
  rwmm.pregnancy_reg_det_id = am.pregnancy_reg_det_id
  and acm.child_infant_registration_status = 'SUCCESS'
  and rwmm.has_delivery_happened is true
  and rwmm.state is null
  and acm.child_registration_status is null

)
INSERT INTO anmol_child_registration (
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    rural_urban,
    registration_date,
    gender,
    birth_date,
    name_child,
    name_mother,
    name_father,
    mobile_no,
    address,
    caste,
    religion_code,
    identity_type,
    created_by,
    mobile_relates_to,
    case_no,
    status,
    birth_place,
    delivery_location,
    register_srno,
    deliverylocationid,
    child_aadhar_no,
    mother_reg_no,
    mobile_id,
    registration_no,
    weight,
    created_date,
    anmol_master_id,
    member_id,
    child_id,
    anmol_child_master_id,
    is_upload
  )
select state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    rural_urban,
    registration_date,
    gender,
    birth_date,
    name_child,
    name_mother,
    name_father,
    mobile_no,
    address,
    caste,
    religion_code,
    identity_type,
    created_by,
    mobile_relates_to,
    case_no,
    status,
    birth_place,
    delivery_location,
    register_srno,
    deliverylocationid,
    child_aadhar_no,
    mother_reg_no,
    mobile_id,
    registration_no,
    weight,
    created_date,
    anmol_master_id,
    member_id,
    child_id,
    anmol_child_master_id,
    is_upload from t_anmol_child_registration;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED8'
where event_config_id = 96 and status = 'PROCESSED7';
commit ;

begin ;
-- child tracking
-- Drop table
-- DROP TABLE anmol_child_tracking;
with t_anmol_child_tracking as (
  select
    imm.immunisation_given,
    imm.visit_id,
    imm.visit_type,
    CASE
      WHEN (
        lhtm.hierarchy_type = 'C'
        OR lhtm.hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    alm.ANM_ID as Created_By,
    am.case_no as Case_no,
    amm.immucode as Immu_code,
    to_char(imm.given_on, 'yyyy-MM-dd') as Immu_date,
    rcsm.death_date as DeathDate,
    case
      when rcsm.death_reason is not null then case
        when rcsm.death_reason = '875' then 1       -- Diarrhoea
        when rcsm.death_reason = '876' then 2       -- High Fever
        when rcsm.death_reason = '873' then 3       -- Low Birth Weight
        when rcsm.death_reason = '877' then 4       -- Measles
        when rcsm.death_reason = '874' then 5       -- Pneumonia
        else 99     -- Other
      end
      else 0
    end as Death_reason,
    case
      when rcsm.place_of_death = 'HOSP' then 1
      when rcsm.place_of_death = 'HOME' then 2
      else 0
    end as DeathPlace,
    0 as Immu_Source,
    case
      when rcad.full_immunization_date is null then 0
      else 1
    end as Fully_Immunized,
    case
      when rvae.adverse_effect = 'SERIOUS' then 1
      else 0
    end as AEFI_Serious,
    0 as Serious_Reason,
    0 as Reason_closure,
    0 as Closure_Remarks,
    case
      when rcad.Received_AllVaccines is true then 1
      else 0
    end as Received_AllVaccines,
    false as Case_closure,
    rvae.manufacturer as Vac_manuf,
    rvae.expiry_date as Vac_exp_date,
    rvae.batch_number as Vac_batch,
    rvae.vaccine_name as Vac_Name,
    rcsm.other_death_reason as Other_Death_reason,
    acm.child_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    acm.child_id,
    imm.id as immu_id,
    rcsm.id as service_id,
    false as is_upload
  from anmol_child_master acm
  inner join anmol_master am on am.id = acm.anmol_master_id
  inner join rch_immunisation_master imm on imm.member_id = acm.child_id
    and imm.member_type = 'C'
  left join rch_child_service_master rcsm on rcsm.member_id = acm.child_id
    and rcsm.id = imm.visit_id
    and imm.visit_type = 'FHW_CS'
  inner join location_hierarchy_type lhtm on lhtm.location_id = imm.location_id
  inner join anmol_location_mapping alm on alm.location_id = imm.location_id
  inner join anmol_immunisation_master amm on case
      when imm.vitamin_a_no is null then imm.immunisation_given
      else concat(imm.immunisation_given, '-', imm.vitamin_a_no)
    end = amm.immunisation_given
  inner join rch_child_analytics_details rcad on rcad.member_id = acm.child_id
  left join rch_vaccine_adverse_effect rvae on rvae.member_id = acm.child_id
    and rvae.vaccine_name = imm.immunisation_given
  where
    imm.anmol_child_tracking_status is null
    and acm.child_registration_status = 'SUCCESS'
    and imm.visit_type != 'FHW_WPD'

)
INSERT INTO anmol_child_tracking (
    immunisation_given, visit_id, visit_type, rural_urban, state_code, district_code, taluka_code, village_code, healthfacility_code, healthsubfacility_code, healthblock_code, healthfacility_type, asha_id, anm_id, created_by, case_no, immu_code, immu_date, deathdate, death_reason, deathplace, immu_source, fully_immunized, aefi_serious, serious_reason, reason_closure, closure_remarks, received_allvaccines, case_closure, vac_manuf, vac_exp_date, vac_batch, vac_name, other_death_reason, registration_no, mobile_id, child_id, immu_id, service_id, is_upload
  )
select
  tact.immunisation_given,
tact.visit_id,
tact.visit_type,
tact.rural_urban,
tact.state_code,
tact.district_code,
tact.taluka_code,
tact.village_code,
tact.healthfacility_code,
tact.healthsubfacility_code,
tact.healthblock_code,
tact.healthfacility_type,
tact.asha_id,
tact.anm_id,
tact.created_by,
tact.case_no,
tact.immu_code,
tact.immu_date,
tact.deathdate,
tact.death_reason,
tact.deathplace,
tact.immu_source,
tact.fully_immunized,
tact.aefi_serious,
tact.serious_reason,
tact.reason_closure,
tact.closure_remarks,
tact.received_allvaccines,
tact.case_closure,
tact.vac_manuf,
tact.vac_exp_date,
tact.vac_batch,
tact.vac_name,
tact.other_death_reason,
tact.registration_no,
tact.mobile_id,
tact.child_id,
tact.immu_id,
tact.service_id,
tact.is_upload
from t_anmol_child_tracking tact
left join anmol_child_tracking act on act.immu_id = tact.immu_id
where
  act.immu_id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED9'
where event_config_id = 96 and status = 'PROCESSED8';
commit ;

begin ;
-- child tracking medical
  -- Drop table
-- DROP TABLE anmol_child_tracking_medical;
with t_anmol_child_tracking_medical as (
  select
    case
      when rcsm.complementary_feeding_started is true then '1'
      when rcsm.complementary_feeding_started is false then '0'
      when rcsm.complementary_feeding_started is null then ''
    end as Complentary_Feeding,
    to_char(rcsm.service_date, 'yyyy-MM-dd') as Visit_Date,
    to_char(rcsm.created_on, 'yyyy-MM-dd') as created_on,
    rcsm.service_date as Created_Date,
    case
      when rcsm.exclusively_breastfeded is true then '1'
      when rcsm.exclusively_breastfeded is true then '1'
      else '0'
    end as Breastfeeding,
    case
      when rcsm.weight is null then 9.99
      else rcsm.weight
    end as Child_Weight,
    case
      when rcsm.complementary_feeding_start_period = 'ENDOF6' then 6
      when rcsm.complementary_feeding_start_period = 'AFTER6' then 7
      when rcsm.complementary_feeding_start_period = 'BEFORE6' then 5
      when rcsm.complementary_feeding_start_period is null then 0
    end as Month_Complentary_Feeding,
    CASE
      WHEN (
        hierarchy_type = 'C'
        OR hierarchy_type = 'U'
      ) then 'U'
      ELSE 'R'
    END as rural_Urban,
    0 as Diarrhoea,
    0 as ORS_Given,
    0 as Pneumonia,
    0 as Antibiotics_Given,
    amm.immucode as Immu_code,
    alm.State_Code as State_Code,
    alm.District_Code as District_Code,
    alm.Taluka_Code as Taluka_Code,
    alm.Village_Code as Village_Code,
    alm.Health_Facility_Code as HealthFacility_Code,
    alm.Health_SubFacility_Code as HealthSubFacility_Code,
    alm.Health_Block_Code as HealthBlock_Code,
    alm.Health_Facility_Type as HealthFacility_Type,
    alm.ASHA_ID as ASHA_ID,
    alm.ANM_ID as ANM_ID,
    acm.case_no as Case_no,
    alm.ANM_ID AS Created_By,
    rcsm.id as service_id,
    acm.child_registration_id as Registration_no,
    am.eligible_mobile_id as Mobile_ID,
    false as is_upload
  from anmol_child_master acm
  inner join rch_child_service_master rcsm on acm.child_id = rcsm.member_id
  inner join rch_immunisation_master imm on imm.member_id = acm.child_id
    and rcsm.id = imm.visit_id
    and imm.visit_type = 'FHW_CS'
  inner join anmol_master am on am.id = acm.anmol_master_id
  inner join location_hierarchy_type lhtm on lhtm.location_id = rcsm.location_id
  inner join anmol_location_mapping alm on alm.location_id = rcsm.location_id
  inner join anmol_immunisation_master amm on amm.immunisation_given = imm.immunisation_given
  where
    anmol_child_tracking_medical_status is null
    and acm.child_registration_status = 'SUCCESS'
    and amm.immucode in (19, 20, 10)

)
INSERT INTO anmol_child_tracking_medical (
    complentary_feeding, visit_date, created_on, created_date, breastfeeding, child_weight, month_complentary_feeding, rural_urban, diarrhoea, ors_given, pneumonia, antibiotics_given, immu_code, state_code, district_code, taluka_code, village_code, healthfacility_code, healthsubfacility_code, healthblock_code, healthfacility_type, asha_id, anm_id, case_no, created_by, service_id, registration_no, mobile_id, is_upload
  )
select
  tactm.complentary_feeding,
tactm.visit_date,
tactm.created_on,
tactm.created_date,
tactm.breastfeeding,
tactm.child_weight,
tactm.month_complentary_feeding,
tactm.rural_urban,
tactm.diarrhoea,
tactm.ors_given,
tactm.pneumonia,
tactm.antibiotics_given,
tactm.immu_code,
tactm.state_code,
tactm.district_code,
tactm.taluka_code,
tactm.village_code,
tactm.healthfacility_code,
tactm.healthsubfacility_code,
tactm.healthblock_code,
tactm.healthfacility_type,
tactm.asha_id,
tactm.anm_id,
tactm.case_no,
tactm.created_by,
tactm.service_id,
tactm.registration_no,
tactm.mobile_id,
tactm.is_upload
from t_anmol_child_tracking_medical tactm
left join anmol_child_tracking_medical actm on actm.service_id = tactm.service_id
where
  actm.service_id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'PROCESSED10'
where event_config_id = 96 and status = 'PROCESSED9';
commit ;

begin ;
-- child pnc
-- Drop table
-- DROP TABLE anmol_child_pnc;
 with childPNC as(
      select
        to_char(
          case
            when rpm.service_date is not null then rpm.service_date
            else rpcm.created_on
          end,
          'yyyy-MM-dd'
        ) as PNC_Date,
        to_char(
          case
            when rpcm.created_on is not null then rpcm.created_on
            else rpm.service_date
          end,
          'yyyy-MM-dd'
        ) as Created_On,
        case
          when rpm.service_date is not null then rpm.service_date
          else rpcm.created_on
        end as created_date,
        to_char(rpcm.death_date, 'yyyy-MM-dd') as Infant_Death_Date,
        case
          when rpcm.is_alive is false then true
          else false
        end as Infant_Death,
        case
          when rpcm.is_alive is false then case
            when rpcm.place_of_death = 'HOME' then 2
            else 1
          end
          else 0
        end as Place_of_death,
        case
          when rpcm.death_reason = '847' then 'A'   -- asphyxia
          when rpcm.death_reason = '848' then 'B'   -- low birth weight/preterm
          when rpcm.death_reason = '849' then 'C'   -- Fever
          when rpcm.death_reason = '850' then 'D'   -- Diarrhea
          when rpcm.death_reason = '851' then 'E'   -- Pneumonia
          when rpcm.death_reason = '852' then 'Z'   -- Sepsis
          when rpcm.death_reason = '854' then 'Z'   -- Multiple Congenital Abnormality
          when rpcm.death_reason = '855' then 'Z'   -- Hypothermia
          when rpcm.death_reason = '856' then 'Z'   -- Milk Aspiration
          when rpcm.death_reason = '857' then 'Z'   -- SIDS
          when rpcm.death_reason = '858' then 'Z'   -- Social Neglect
          when rpcm.death_reason = '853' then 'Z'   -- Congenital Heart Disease

        end as Infant_Death_Reason,
        rpcm.other_death_reason as Infant_Death_Reason_Other,
        case
          when rpcm.death_reason is null then 0
          else 1
        end as Infant_Death_Reason_length,
        CASE
          WHEN (
            hierarchy_type = 'C'
            OR hierarchy_type = 'U'
          ) then 'U'
          ELSE 'R'
        END as rural_Urban,
        alm.State_Code as State_Code,
        alm.District_Code as District_Code,
        alm.Taluka_Code as Taluka_Code,
        alm.Village_Code as Village_Code,
        alm.Health_Facility_Code as HealthFacility_Code,
        alm.Health_SubFacility_Code as HealthSubFacility_Code,
        alm.Health_Block_Code as HealthBlock_Code,
        alm.Health_Facility_Type as HealthFacility_Type,
        alm.ASHA_ID as ASHA_ID,
        alm.ANM_ID as ANM_ID,
        alm.ANM_ID as created_by,
        am.eligible_registration_id Registration_no,
        am.eligible_mobile_id Mobile_id,
        acm.child_registration_id as InfantRegistration,
        am.case_no as Case_no,
        case
          when (
            rpcm.child_weight is null
            or rpcm.child_weight = 0
            or rpcm.child_weight >= 100
          ) then 6.99
          else rpcm.child_weight
        end as Infant_Weight,
        am.member_id as member_id,
        case
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 1 then 1
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 3 then 2
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 7 then 3
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 14 then 4
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 21 then 5
          when extract(
            day
            from (
                case
                  when rpm.service_date is not null then rpm.service_date
                  else rpm.created_on
                end
              ) - im.dob
          ) <= 28 then 6
          else 7
        end as PNC_Type,
        rpcm.child_id as Child_Id,
        rpcm.id as rch_pnc_child_master_id,
        rpcm.other_danger_sign as DangerSign_Infant_Other,
        (
          select
            string_agg(signs, '')
          from (
              select
                pnc.id,
                case
                  when child_danger_signs = 825 then 'A'        -- કમળો
                  when child_danger_signs = 826 then 'B'        -- ડાયેરીયા
                  when child_danger_signs = 827 then 'C'        -- ઉલટી
                  when child_danger_signs = 828 then 'D'        -- તાવ
                  when child_danger_signs = 820 then 'E'        -- હાઇપોર્થેમીયા
                  when child_danger_signs = 821 then 'F'        -- આંચકી/તાણ
                  when child_danger_signs = 829 then 'G'        -- CHEST-IN-Drawing(ઝડપી શ્વાસોશ્વાસ)
                  when child_danger_signs = 832 then 'H'        -- ધાવી ન શકવુ/હલન ચલન ધટવું
                  when child_danger_signs = 831 then 'H'        -- ધાવવામાં મુશ્કેલી
                  when pnc.other_danger_sign is not null
                  and other_danger_sign != '' then 'Z'
                end as signs
              from rch_pnc_child_master pnc
              left join rch_pnc_child_danger_signs_rel signs on pnc.id = signs.child_pnc_id
              where
                pnc.id = rpcm.id
            ) as t1
          group by
            t1.id
        ) as DangerSign_Infant_Array,
        (
          select
            count(1)
          from rch_pnc_child_master child,
            rch_pnc_master master
          where
            child.pnc_master_id = master.id
            and child.child_id = rpcm.child_id
            and master.pregnancy_reg_det_id = rpm.pregnancy_reg_det_id
            and master.service_date <= rpm.service_date
        ) as PNC_No
      from anmol_child_master acm
      inner join anmol_master am on am.id = acm.anmol_master_id
      inner join rch_pnc_child_master rpcm on acm.child_id = rpcm.child_id
      inner join rch_pnc_master rpm on rpm.id = rpcm.pnc_master_id
      inner join imt_member im on im.id = acm.child_id
      inner join imt_family ifm on ifm.family_id = im.family_id
      inner join location_hierarchy_type lhtm on lhtm.location_id = rpm.location_id
      inner join anmol_location_mapping alm on alm.location_id = rpm.location_id
      where
        acm.child_registration_status = 'SUCCESS'
        and rpcm.anmol_pnc_status is null

    ), t_anmol_child_pnc as (
    select
      cp.*,
      DangerSign_Infant_Array as DangerSign_Infant,
      case
        when DangerSign_Infant_Array is null then 0
        else length(DangerSign_Infant_Array)
      end as DangerSign_Infant_length,
      false as is_upload
    from childPNC cp
    order by
      PNC_Date)
INSERT INTO anmol_child_pnc (
    pnc_date,
    created_on,
    created_date,
    infant_death_date,
    infant_death,
    place_of_death,
    infant_death_reason,
    infant_death_reason_other,
    infant_death_reason_length,
    rural_urban,
    state_code,
    district_code,
    taluka_code,
    village_code,
    healthfacility_code,
    healthsubfacility_code,
    healthblock_code,
    healthfacility_type,
    asha_id,
    anm_id,
    created_by,
    registration_no,
    mobile_id,
    infantregistration,
    case_no,
    infant_weight,
    member_id,
    pnc_type,
    child_id,
    rch_pnc_child_master_id,
    dangersign_infant_other,
    dangersign_infant_array,
    pnc_no,
    dangersign_infant,
    dangersign_infant_length,
    is_upload
  )
select
tacp.pnc_date,
tacp.created_on,
tacp.created_date,
tacp.infant_death_date,
tacp.infant_death,
tacp.place_of_death,
tacp.infant_death_reason,
tacp.infant_death_reason_other,
tacp.infant_death_reason_length,
tacp.rural_urban,
tacp.state_code,
tacp.district_code,
tacp.taluka_code,
tacp.village_code,
tacp.healthfacility_code,
tacp.healthsubfacility_code,
tacp.healthblock_code,
tacp.healthfacility_type,
tacp.asha_id,
tacp.anm_id,
tacp.created_by,
tacp.registration_no,
tacp.mobile_id,
tacp.infantregistration,
tacp.case_no,
tacp.infant_weight,
tacp.member_id,
tacp.pnc_type,
tacp.child_id,
tacp.rch_pnc_child_master_id,
tacp.dangersign_infant_other,
tacp.dangersign_infant_array,
tacp.pnc_no,
tacp.dangersign_infant,
tacp.dangersign_infant_length,
tacp.is_upload
from t_anmol_child_pnc tacp
left join anmol_child_pnc acp
on acp.Rch_Pnc_Child_Master_Id = tacp.Rch_Pnc_Child_Master_Id
where acp.Rch_Pnc_Child_Master_Id is null;

update timer_event SET completed_on = clock_timestamp(),status = 'COMPLETED'
where event_config_id = 96 and status = 'PROCESSED10';

commit ;
