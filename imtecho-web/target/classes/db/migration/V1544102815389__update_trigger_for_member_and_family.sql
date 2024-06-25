--  for family
CREATE OR REPLACE FUNCTION public.update_basic_state_family_trigger()
  RETURNS trigger AS
$BODY$
begin

    if (TG_OP = 'INSERT') then 
	with rowss as(
		insert into imt_family_state_detail (family_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on)
		values (new.id, null, new.state, null, new.modified_by, now(), new.modified_by, now())
		returning id
	)
	select id into NEW.current_state from rowss;
    end if;

    if (TG_OP != 'INSERT' and new.state != old.state) then 
	with rowss as(
		insert into imt_family_state_detail (family_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on, comment)
		values (new.id, old.state, new.state, old.current_state, new.modified_by, now(), new.modified_by, now(),
                case 
                    when new.remarks is not null and old.remarks is null then new.remarks
                    when new.remarks is not null and old.remarks is not null and new.remarks <> old.remarks then new.remarks
                    else null
                end)
		returning id
	)
	select id into NEW.current_state from rowss;
    end if;

    case
	when TG_OP != 'INSERT' and new.state = old.state
	then return new;

	when new.state in ('com.argusoft.imtecho.family.state.unverified') 
	then new.basic_state := 'UNVERIFIED';

	when new.state in ('com.argusoft.imtecho.family.state.archived',
			'com.argusoft.imtecho.family.state.archived.fhsr.verified',
			'com.argusoft.imtecho.family.state.new.archived.mo.fhw.reverified',
			'com.argusoft.imtecho.family.state.archived.emri.fhw.reverified',
			'com.argusoft.imtecho.family.state.new.archived.fhw.reverified',
			'com.argusoft.imtecho.family.state.archived.mo.verified',
			'com.argusoft.imtecho.family.state.archived.mo.fhw.reverified') 
	then new.basic_state := 'ARCHIVED';

	when new.state in ('com.argusoft.imtecho.family.state.verified',
			'com.argusoft.imtecho.family.state.fhw.reverified',
			'com.argusoft.imtecho.family.state.emri.fhw.reverified',
			'com.argusoft.imtecho.family.state.emri.verified.ok',
			'com.argusoft.imtecho.family.state.emri.fhw.reverified.dead',
			'com.argusoft.imtecho.family.state.emri.fhw.reverified.verified',
			'com.argusoft.imtecho.family.state.emri.verified.ok.dead',
			'com.argusoft.imtecho.family.state.emri.verification.pool.dead',
			'com.argusoft.imtecho.family.state.emri.verification.pool.verified',
			'com.argusoft.imtecho.family.state.emri.verification.pool.archived',
			'com.argusoft.imtecho.family.state.emri.verification.pool',
			'com.argusoft.imtecho.family.state.emri.verified.ok.verified',
			'com.argusoft.imtecho.family.state.mo.fhw.reverified',
			'com.argusoft.imtecho.family.state.emri.fhw.reverified.archived',
			'com.argusoft.imtecho.family.state.emri.verified.ok.archived') 
	then new.basic_state := 'VERIFIED';

	when new.state in ('com.argusoft.imtecho.family.state.archived.fhsr.reverification',
			'com.argusoft.imtecho.family.state.archived.mo.reverification',
			'com.argusoft.imtecho.family.state.new.fhsr.reverification',
			'com.argusoft.imtecho.family.state.new.mo.reverification',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.verified',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.dead',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification',
			'com.argusoft.imtecho.family.state.emri.fhw.reverification.archived') 
	then new.basic_state := 'REVERIFICATION';

	when new.state in ('com.argusoft.imtecho.family.state.new',
			'com.argusoft.imtecho.family.state.new.fhsr.verified',
			'com.argusoft.imtecho.family.state.new.fhw.reverified',
			'com.argusoft.imtecho.family.state.new.mo.verified',
			'com.argusoft.imtecho.family.state.new.mo.fhw.reverified') 
	then new.basic_state := 'NEW';
	
	when new.state in ('com.argusoft.imtecho.family.state.orphan') 
	then new.basic_state := 'ORPHAN';

	else
	     new.basic_state := 'UNHANDLED';	
    end case;
    return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


-- for member
CREATE OR REPLACE FUNCTION public.update_basic_state_member_trigger()
  RETURNS trigger AS
$BODY$
begin
update imt_family set modified_on = now() where family_id = new.family_id and modified_on < now() - interval '1 minute';


if (TG_OP = 'INSERT') then
	with rowss as(
		insert into imt_member_state_detail (member_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on)
		values (new.id, null, new.state, null, new.modified_by, now(), new.modified_by, now())
		returning id
	)
	select id into NEW.current_state from rowss;
end if;
if (TG_OP != 'INSERT' and new.state != old.state) then 
	with rowss as(
		insert into imt_member_state_detail (member_id, from_state, to_state, parent, created_by, created_on, modified_by, modified_on, comment)
		values (new.id, old.state, new.state, old.current_state, new.modified_by, now(), new.modified_by, now(),
                case 
                    when new.remarks is not null and old.remarks is null then new.remarks
                    when new.remarks is not null and old.remarks is not null and new.remarks <> old.remarks then new.remarks
                    else null
                end)
		returning id
	)
	select id into NEW.current_state from rowss;
end if;


if (TG_OP = 'INSERT' or new.state != old.state) and new.state in (
		'com.argusoft.imtecho.member.state.verified',
		'com.argusoft.imtecho.member.state.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.fhw.reverified'
		,'com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified',
		'com.argusoft.imtecho.member.state.temporary')  then

	insert into rch_member_data_sync_pending(member_id,created_on,is_synced)
	values(NEW.id,now(),false);

if (NEW.is_pregnant = true and (select count(*) from rch_member_service_data_sync_detail where member_id = NEW.id) = 0) then
drop table if exists member_details;
CREATE temp TABLE member_details(
			family_id bigint,
			member_id bigint,
			family_id_text text,
			unique_health_id text,
			location_id bigint,
			area_id bigint,
			cur_preg_reg_det_id bigint,
			lmp date,
			is_pregnant boolean,
			dob date,
			imtecho_lmp date,
			anc_visit_dates text,
			immunisation_given text,
			gender text,
			marital_status text,
			sync_status text,
			mother_id bigint,
			emamta_health_id text,
			family_state text,
			preg_reg_det_id bigint,
			is_lmp_followup_done boolean,
			is_wpd_entry_done boolean
		);

insert into member_details (family_id ,	member_id,family_id_text,unique_health_id,location_id,area_id,is_pregnant,dob,imtecho_lmp,lmp,gender,marital_status,emamta_health_id
,family_state,preg_reg_det_id)
select distinct imt_family.id as family_id,NEW.id as member_id,imt_family.family_id,case when NEW.state in ('com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified') and NEW.emamta_health_id is not null then UPPER(NEW.emamta_health_id) 
		else NEW.unique_health_id end as unique_health_id 
,imt_family.location_id as location_id,case when imt_family.area_id is null then imt_family.location_id else cast(imt_family.area_id as bigint) end ,
(case when NEW.is_pregnant = true then true else false end),NEW.dob,NEW.lmp,NEW.lmp,NEW.gender,NEW.marital_status
,UPPER(NEW.emamta_health_id),imt_family.state,NEW.cur_preg_reg_det_id
from imt_family 
where imt_family.family_id = NEW.family_id;


insert into rch_member_service_data_sync_detail (member_id,created_on,original_lmp,is_pregnant_in_imtecho,imtecho_dob,location_id)
select member_id,now(),imtecho_lmp,is_pregnant,dob,location_id from member_details ;



-- query to insert rch_pregnancy_registration_det
INSERT INTO public.rch_pregnancy_registration_det(
             mthr_reg_no,location_id, member_id, lmp_date, edd, reg_date, state, created_on, 
            created_by, modified_on, modified_by)
select mother.mthr_reg_no,m.area_id,m.member_id,mother.mthr_lastmas_date,mother.exp_del_date,mother.entrydate
,case when d.mthr_reg_no is null then 'PREGNANT' else 'DELIVERY_DONE' end 
,now(),null,now(),null 
from member_details m 
inner join  tbl_mother mother on mother.member_id = m.unique_health_id
left join tbl_mother_delivery d on d.mthr_reg_no = mother.mthr_reg_no;



INSERT INTO public.rch_anc_master(
            member_id, family_id, location_id,location_hierarchy_id
            ,mobile_start_date
            ,mobile_end_date
            ,blood_sugar_test
            ,sugar_test_after_food_val
            ,sugar_test_before_food_val
            ,urine_test_done, 
            albendazole_given, referral_place, other_dangerous_sign, dangerous_sign_id,
            created_on, member_status,              
            referral_done, hbsag_test,pregnancy_reg_det_id
            ,haemoglobin_count,ifa_tablets_given,weight,systolic_bp,diastolic_bp,calcium_tablets_given,fa_tablets_given,created_by)
select member_details.member_id,member_details.family_id,member_details.location_id,-1,'01-01-1970','01-01-1970'
,'BOTH',case when isInteger(tbl_anc.bgtest_after_food) then cast(tbl_anc.bgtest_after_food as int) else null end
,case when isInteger(tbl_anc.bgtest_empty_stomach) then cast(tbl_anc.bgtest_empty_stomach as int) else null end
,case when tbl_anc.urine_test = 1 then true else false end
,case when tbl_anc.albendazole = 1 then true else false end
,tbl_reffer_place.ref_id
,tbl_anc.other_risky_symptom
,tbl_anc.anc_risky_symptom
,tbl_anc.anc_date,'AVAILABLE'
,case when tbl_anc.anc_is_referred = 1 then 'YES' else case when tbl_anc.anc_is_referred = 0 then 'NO' else 'NOT_REQUIRED' end end
,case when tbl_anc.is_hba1c = 1 then 'REACTIVE' when tbl_anc.anc_is_referred = 0 then 'NON_REACTIVE' else null end ,rch_pregnancy_registration_det.id
,case when isInteger(tbl_mother_hb.hb) then tbl_mother_hb.hb else null end
,case when isInteger(tbl_mother_hb.ifa) then tbl_mother_hb.ifa else null end
,tbl_mother_hb.weight
,case when isInteger(tbl_mother_hb.bp) then tbl_mother_hb.bp else null end
,case when isInteger(tbl_mother_hb.bp_low) then tbl_mother_hb.bp_low else null end
,case when isInteger(tbl_mother_hb.ca) then tbl_mother_hb.ca else null end
,case when isInteger(tbl_mother_hb.number_folicacid_tabletgiven) then tbl_mother_hb.number_folicacid_tabletgiven else null end
,-1
from member_details inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_anc on tbl_anc.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
left join tbl_mother_hb on tbl_anc.mthr_reg_no = tbl_mother_hb.mthr_reg_no and tbl_anc.anc_date = tbl_mother_hb.hb_date
left join tbl_reffer_place on tbl_anc.anc_referred_place = tbl_reffer_place.emamta_id;



INSERT INTO public.rch_wpd_mother_master(
            member_id, family_id, mobile_start_date, 
            mobile_end_date, location_id, location_hierarchy_id, date_of_delivery, 
            member_status, is_preterm_birth, delivery_place, type_of_hospital, 
            delivery_done_by,  type_of_delivery, pregnancy_outcome, 
            created_on, discharge_date, 
            cortico_steroid_given, 
            has_delivery_happened,pregnancy_reg_det_id,created_by)
select member_details.member_id,member_details.family_id,'01-01-1970','01-01-1970',member_details.location_id,-1
,tbl_mother_delivery.mthr_delivery_date,'AVAILABLE'
,case when tbl_mother_delivery.is_early_birth = 1 then true else false end
,case when tbl_mother_delivery.mthr_delivery_place = 7 then 'HOME' 
when tbl_mother_delivery.mthr_delivery_place = 12 then 'ON_THE_WAY'
else 'HOSP' end
,case when tbl_mother_delivery.mthr_delivery_place = 1 then 897 
when tbl_mother_delivery.mthr_delivery_place = 2 then 899
when tbl_mother_delivery.mthr_delivery_place = 3 then 895
when tbl_mother_delivery.mthr_delivery_place = 4 then 891
when tbl_mother_delivery.mthr_delivery_place = 5 then 898
when tbl_mother_delivery.mthr_delivery_place = 6 then 893
when tbl_mother_delivery.mthr_delivery_place = 8 then 894
when tbl_mother_delivery.mthr_delivery_place = 9 then 890
when tbl_mother_delivery.mthr_delivery_place = 10 then 896
when tbl_mother_delivery.mthr_delivery_place = 11 then 892
else null end
,case when tbl_mother_delivery.deliver_designation = 1 then 'DOCTOR' 
when tbl_mother_delivery.deliver_designation = 2 then 'ANM'
when tbl_mother_delivery.deliver_designation = 3 then 'NURSE'
when tbl_mother_delivery.deliver_designation = 4 then 'TBA'
when tbl_mother_delivery.deliver_designation = 5 then 'NON-TBA'
when tbl_mother_delivery.deliver_designation = 6 then 'CY-Doctor'
else null end
,case when tbl_mother_delivery.mthr_delivery_type = 1 then 'NORMAL' 
when tbl_mother_delivery.mthr_delivery_type = 2 then 'CAESAREAN'
when tbl_mother_delivery.mthr_delivery_type = 3 then 'ASSIT'
else null end
,case when tbl_mother_delivery.mthr_delivery_type = 1 then 'LBIRTH' 
when tbl_mother_delivery.mthr_delivery_type = 2 then 'LBIRTH'
when tbl_mother_delivery.mthr_delivery_type = 3 then 'LBIRTH'
when tbl_mother_delivery.mthr_delivery_type = 4 then 'ABORTION'
when tbl_mother_delivery.mthr_delivery_type = 5 then 'MTP'
else null end
,tbl_mother_delivery.entrydt
,tbl_mother_delivery.discharge_dt
,case when tbl_mother_delivery.corticost_injec = 1 then true else false end
,true
,rch_pregnancy_registration_det.id
,-1
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_mother_delivery on tbl_mother_delivery.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no;


--insert into rch_wpd_child_master
with rch_wpd_child_master_t as (
select child_detail.id as member_id,member_details.family_id,'01-01-1970'::date as mobile_start_date
,'01-01-1970'::date as mobile_end_date,member_details.location_id ,-1 as location_hierarchy_id,rch_wpd_mother_master.id as wpd_mother_id
,member_details.member_id as mother_id,case when tbl_child.cld_is_death = 0 then 'SBIRTH' else 'LBIRTH' end as pregnancy_outcome
,tbl_child.sex as gender, tbl_child.cld_birth_date as date_of_delivery
,-1 as created_by,tbl_child.cld_reg_date as created_on,-1 as modified_by,tbl_child.cld_reg_date as modified_on
,tbl_child.cld_death_date as death_date,tbl_death_reason.pnc_ref_id as death_reason,tbl_death_place.ref_code as place_of_death
,'AVAILABLE' as member_status
from member_details
inner join rch_wpd_mother_master on rch_wpd_mother_master.member_id = member_details.member_id
inner join tbl_child on tbl_child.mot_huid = member_details.unique_health_id and cast(tbl_child.cld_birth_date as date) = cast(rch_wpd_mother_master.date_of_delivery as date)
inner join imt_member child_detail on child_detail.unique_health_id = tbl_child.cld_huid
left join tbl_death_reason on tbl_death_reason.id = tbl_child.cld_death_reason
left join tbl_death_place on tbl_death_place.emamta_id = tbl_child.cld_death_place
),rch_wpd_child_master_ins as(
INSERT INTO public.rch_wpd_child_master(
            member_id, family_id, mobile_start_date, 
            mobile_end_date, location_id, location_hierarchy_id, wpd_mother_id, 
            mother_id, pregnancy_outcome, gender, date_of_delivery, 
            created_by, created_on, modified_by, modified_on, death_date, death_reason, place_of_death, member_status 
            )
select member_id, family_id, mobile_start_date, 
            mobile_end_date, location_id, location_hierarchy_id, wpd_mother_id, 
            mother_id, pregnancy_outcome, gender, date_of_delivery, 
            created_by, created_on, modified_by, modified_on, death_date, death_reason, place_of_death, member_status 
			from rch_wpd_child_master_t
			returning id
)
update imt_member set mother_id = rch_wpd_child_master_t.mother_id from rch_wpd_child_master_t
where imt_member.id = rch_wpd_child_master_t.member_id;

-- lmp and is_pregnant flag update

update member_details SET is_pregnant = true 
,lmp = rch_pregnancy_registration_det.lmp_date
,cur_preg_reg_det_id = rch_pregnancy_registration_det.id
--,modified_on = now() 
from rch_pregnancy_registration_det where rch_pregnancy_registration_det.member_id = member_details.member_id 
and rch_pregnancy_registration_det.state = 'PREGNANT'
and rch_pregnancy_registration_det.lmp_date > now() - interval '350 days'
and member_details.preg_reg_det_id is null and member_details.is_wpd_entry_done is null;

update member_details set cur_preg_reg_det_id = preg_reg_det_id where preg_reg_det_id is not null;


drop table if exists temp_child_details;
CREATE TEMPORARY TABLE temp_child_details(
	family_id text,
	member_id bigint,
	mthr_reg_no text,
	unique_health_id text,
	birth_date date,
    cld_reg_date date,
    sex text,
    child_name text,
complementary_feeding_started boolean
    
);

--logic to add pregnancy done children
insert into temp_child_details(family_id,member_id,mthr_reg_no,unique_health_id,birth_date,cld_reg_date,sex,child_name,complementary_feeding_started)
select member_details.family_id_text,member_details.member_id as member_id ,rch_pregnancy_registration_det.mthr_reg_no,tbl_child.cld_huid,
cld_birth_date,cld_reg_date,sex,child_name,case when is_compliment_feed = '1' then true else false end
from member_details 
--inner join imt_member on member_details.member_id = imt_member.id  and imt_member.is_pregnant = true
--inner join imt_family on imt_family.family_id = imt_member.family_id
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id and member_details.is_pregnant = true 
and rch_pregnancy_registration_det.state = 'DELIVERY_DONE' and member_details.lmp < rch_pregnancy_registration_det.edd
inner join tbl_mother_delivery on rch_pregnancy_registration_det.mthr_reg_no = tbl_mother_delivery.mthr_reg_no
left join tbl_child on tbl_child.mot_huid = member_details.unique_health_id and cast(tbl_child.cld_birth_date as date) = cast(tbl_mother_delivery.mthr_delivery_date as date);


with temp_child_detail as(
INSERT INTO public.imt_member(
created_on, dob, 
family_head, family_id, first_name, gender, 
middle_name ,last_name ,state, unique_health_id,created_by, modified_by, modified_on,
complementary_feeding_started, 
mother_id)
select cld_reg_date,birth_date,false,temp_child_details.family_id,child_name,sex,imt_member.middle_name,imt_member.last_name
,'com.argusoft.imtecho.member.state.new', temp_child_details.unique_health_id,-1,-1,cld_reg_date
,temp_child_details.complementary_feeding_started,imt_member.id from temp_child_details,imt_member 
where temp_child_details.member_id = imt_member.id
and temp_child_details.unique_health_id is not null
returning id,family_id,unique_health_id,dob)
insert into member_details(family_id,member_id,unique_health_id,dob)
select imt_family.id,temp_child_detail.id,temp_child_detail.unique_health_id,dob from temp_child_detail,imt_family 
where temp_child_detail.family_id = imt_family.family_id;



update member_details set is_pregnant = false where member_id in (select member_id from temp_child_details) 
and cur_preg_reg_det_id is null and preg_reg_det_id is null;


--anc dates update
update member_details SET anc_visit_dates = pregnancy_reg_det.anc_visit_dates 
from (select member_details.member_id,pregnancy_reg_det_id,string_agg(to_char(created_on,'DD/MM/YYYY'),',' order by created_on) anc_visit_dates from rch_anc_master,member_details 
where pregnancy_reg_det_id = member_details.cur_preg_reg_det_id
--and member_details.lmp > now() - interval '281 day'
group by pregnancy_reg_det_id,member_details.member_id) as pregnancy_reg_det where pregnancy_reg_det.member_id = member_details.member_id;

--entry in pnc master for mother detail
 INSERT INTO public.rch_pnc_master(
            member_id, family_id, mobile_start_date, 
            mobile_end_date, location_id, location_hierarchy_id, 
            created_by, created_on, modified_by, modified_on, member_status, 
            pregnancy_reg_det_id, pnc_no)
select member_details.member_id,member_details.family_id,'01-01-1970','01-01-1970',member_details.location_id,-1
,-1,tbl_pnc.pnc_date,-1,tbl_pnc.pnc_date,'AVAILABLE',rch_pregnancy_registration_det.id,tbl_pnc.pnc_no 
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_pnc on tbl_pnc.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
where tbl_pnc.pnc_date is not null;


--entry in pnc mother table
INSERT INTO public.rch_pnc_mother_master(
            pnc_master_id, mother_id,
            is_alive, referral_place, 
            created_by, created_on, modified_by, modified_on, member_status, 
            family_planning_method)            
select rch_pnc_master.id,member_details.member_id,true,tbl_reffer_place.ref_id
,-1,tbl_pnc.pnc_date,-1,tbl_pnc.pnc_date,'AVAILABLE',tbl_fp_method.code
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_pnc on tbl_pnc.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
inner join rch_pnc_master on rch_pnc_master.pregnancy_reg_det_id = rch_pregnancy_registration_det.id 
and tbl_pnc.pnc_date = rch_pnc_master.created_on
and tbl_pnc.pnc_no = cast(rch_pnc_master.pnc_no as bigint)
left join tbl_reffer_place on tbl_reffer_place.emamta_id = tbl_pnc.pnc_referred_place
left join tbl_fp_method on tbl_fp_method.fp_id = tbl_pnc.pnc_contra_method
where tbl_pnc.pnc_date is not null;

--update ref_id for child_table
update tbl_pnc_child set pnc_ref_id = pnc_master_id from (
select tbl_pnc_child.mthr_reg_no,tbl_pnc_child.dt,max(rch_pnc_master.id) as pnc_master_id
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_pnc_child on tbl_pnc_child.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
inner join rch_pnc_master on rch_pnc_master.pregnancy_reg_det_id = rch_pregnancy_registration_det.id 
and tbl_pnc_child.dt = rch_pnc_master.created_on 
group by tbl_pnc_child.mthr_reg_no,tbl_pnc_child.dt) as t
where tbl_pnc_child.mthr_reg_no = t.mthr_reg_no and t.dt =tbl_pnc_child.dt and pnc_ref_id != pnc_master_id;



--entry in pnc master for child detail
 INSERT INTO public.rch_pnc_master(
            member_id, family_id, mobile_start_date, 
            mobile_end_date, location_id, location_hierarchy_id, 
            created_by, created_on, modified_by, modified_on, member_status, 
            pregnancy_reg_det_id, pnc_no)
select member_details.member_id as member_id,member_details.family_id as family_id,'01-01-1970' as mobile_start_date ,'01-01-1970' as mobile_end_date,member_details.location_id as location_id
,-1 as location_hierarchy_id 
,-1 as created_by ,tbl_pnc_child.dt as created_on,-1 as modified_by ,tbl_pnc_child.dt as modified_on
,'AVAILABLE' as member_status ,rch_pregnancy_registration_det.id as pregnancy_reg_det_id ,tbl_pnc_child.pnc_visit_day as pnc_no
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_pnc_child on tbl_pnc_child.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
where pnc_ref_id is null and tbl_pnc_child.dt is not null;

--update ref_id for child_table
update tbl_pnc_child set pnc_ref_id = pnc_master_id from (
select tbl_pnc_child.mthr_reg_no,tbl_pnc_child.dt,max(rch_pnc_master.id) as pnc_master_id
from member_details
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.member_id = member_details.member_id
inner join tbl_pnc_child on tbl_pnc_child.mthr_reg_no = rch_pregnancy_registration_det.mthr_reg_no
inner join rch_pnc_master on rch_pnc_master.pregnancy_reg_det_id = rch_pregnancy_registration_det.id 
and tbl_pnc_child.dt = rch_pnc_master.created_on 
and tbl_pnc_child.pnc_ref_id is null
group by tbl_pnc_child.mthr_reg_no,tbl_pnc_child.dt) as t
where tbl_pnc_child.mthr_reg_no = t.mthr_reg_no and t.dt =tbl_pnc_child.dt;

--entry in child pnc master for mother detail
 INSERT INTO public.rch_pnc_child_master(
            pnc_master_id, child_id, is_alive, other_danger_sign, child_weight, 
            created_by, created_on, modified_by, modified_on, member_status, 
            death_date, death_reason, place_of_death, referral_place,  
            child_referral_done)            
select tbl_pnc_child.pnc_ref_id,member_details.member_id,case when tbl_pnc_child.is_death = '1' then false else true end 
,tbl_pnc_child.other_diseases,tbl_pnc_child.wt,-1,tbl_pnc_child.dt,-1,tbl_pnc_child.dt,'AVAILABLE'
,tbl_pnc_child.death_date,tbl_death_reason.pnc_ref_id,tbl_death_place.ref_code,tbl_reffer_place.ref_id
,case when tbl_reffer_place.ref_id is not null then true else false end
from member_details
inner join tbl_pnc_child on tbl_pnc_child.health_uid = member_details.unique_health_id
left join tbl_death_reason on tbl_death_reason.id = tbl_pnc_child.death_reason
left join tbl_death_place on tbl_death_place.emamta_id = tbl_pnc_child.death_place
left join tbl_reffer_place on tbl_reffer_place.emamta_id = tbl_pnc_child.refer_place
where tbl_pnc_child.dt is not null;


--entry for child immunization
 INSERT INTO public.rch_immunisation_master(
            member_id,location_id,member_type,  
            immunisation_given, given_on, given_by, created_by, created_on, 
            modified_by, modified_on)            
select member_details.member_id,member_details.area_id,'C',tbl_child_vaccination_master.ref_code,tbl_child_vaccination.given_date,-1,-1
,tbl_child_vaccination.given_date,-1,tbl_child_vaccination.given_date
from member_details
inner join tbl_child_vaccination on tbl_child_vaccination.cld_huid = member_details.unique_health_id
inner join tbl_child_vaccination_master on tbl_child_vaccination_master.id = tbl_child_vaccination.vid
where tbl_child_vaccination.given_date is not null;

-- entry for TT1 immunization
 INSERT INTO public.rch_immunisation_master(
            member_id, member_type,  
            immunisation_given, given_on, given_by, created_by, created_on, 
            modified_by, modified_on,pregnancy_reg_det_id)            
select member_details.member_id,'M','TT1',tbl_mother_tt1.mthr_tt1_date,-1,-1
,tbl_mother_tt1.mthr_tt1_date,-1,tbl_mother_tt1.mthr_tt1_date,rch_pregnancy_registration_det.id
from member_details
inner join tbl_mother_tt1 on tbl_mother_tt1.member_id = member_details.unique_health_id
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.mthr_reg_no = tbl_mother_tt1.mthr_reg_no
where tbl_mother_tt1.mthr_tt1_date is not null;


--entry for TT2 immunization
 INSERT INTO public.rch_immunisation_master(
            member_id, member_type,  
            immunisation_given, given_on, given_by, created_by, created_on, 
            modified_by, modified_on,pregnancy_reg_det_id)            
select member_details.member_id,'M','TT2',tbl_mother_tt2.mthr_tt2_date,-1,-1
,tbl_mother_tt2.mthr_tt2_date,-1,tbl_mother_tt2.mthr_tt2_date,rch_pregnancy_registration_det.id
from member_details
inner join tbl_mother_tt2 on tbl_mother_tt2.member_id = member_details.unique_health_id
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.mthr_reg_no = tbl_mother_tt2.mthr_reg_no
where tbl_mother_tt2.mthr_tt2_date is not null;

--entry in TTBoster
 INSERT INTO public.rch_immunisation_master(
            member_id, member_type,  
            immunisation_given, given_on, given_by, created_by, created_on, 
            modified_by, modified_on,pregnancy_reg_det_id)            
select member_details.member_id,'M','TT2',tbl_mother_ttbooster.mthr_ttbuster_date,-1,-1
,tbl_mother_ttbooster.mthr_ttbuster_date,-1,tbl_mother_ttbooster.mthr_ttbuster_date,rch_pregnancy_registration_det.id
from member_details
inner join tbl_mother_ttbooster on  tbl_mother_ttbooster.member_id = member_details.unique_health_id
inner join rch_pregnancy_registration_det on rch_pregnancy_registration_det.mthr_reg_no = tbl_mother_ttbooster.mthr_reg_no
where tbl_mother_ttbooster.mthr_ttbuster_date is not null;


--update mother immunization
update member_details set immunisation_given = t.immunisation_given
from (
select member_details.member_id
,string_agg(concat(rch_immunisation_master.immunisation_given,'#',to_char(rch_immunisation_master.given_on,'DD/MM/YYYY'))
,',' order by rch_immunisation_master.given_on) as immunisation_given
from member_details
inner join rch_immunisation_master on rch_immunisation_master.pregnancy_reg_det_id = member_details.cur_preg_reg_det_id
group by member_details.member_id) as t 
where t.member_id = member_details.member_id;


--update child immunization
update member_details set immunisation_given = t.immunisation_given
from (
select member_details.member_id
,string_agg(concat(rch_immunisation_master.immunisation_given,'#',to_char(rch_immunisation_master.given_on,'DD/MM/YYYY'))
,',' order by rch_immunisation_master.given_on) as immunisation_given
from member_details
inner join rch_immunisation_master on rch_immunisation_master.member_id = member_details.member_id 
where rch_immunisation_master.member_type = 'C'
group by member_details.member_id) as t 
where t.member_id = member_details.member_id;


update member_details set lmp = now() - interval '28 days' 
where member_details.is_pregnant = true and member_details.cur_preg_reg_det_id is null and lmp is null;

INSERT INTO public.rch_pregnancy_registration_det(
             member_id,location_id,lmp_date, edd, reg_date, state, created_on, 
            created_by, modified_on, modified_by)
select member_details.member_id,member_details.area_id,member_details.lmp,member_details.lmp + interval '281 day',now(),'PREGNANT' ,now(),-1,now(),-1 
from member_details
where member_details.is_pregnant = true and member_details.cur_preg_reg_det_id is null;




update member_details SET is_pregnant = true 
--,lmp = case when member_details.lmp is null then rch_pregnancy_registration_det.lmp_date else member_details.lmp end
,cur_preg_reg_det_id = rch_pregnancy_registration_det.id
--,modified_on = now() 
from rch_pregnancy_registration_det where 
 member_details.is_wpd_entry_done is null and member_details.preg_reg_det_id is null
and rch_pregnancy_registration_det.member_id = member_details.member_id 
and rch_pregnancy_registration_det.state = 'PREGNANT'
and rch_pregnancy_registration_det.lmp_date > now() - interval '350 days';


-- anc notification
INSERT INTO public.techo_notification_master(
            notification_type_id, notification_code, location_id, location_hierchy_id, 
            family_id, member_id, schedule_date,
            action_by, state, created_by, created_on, modified_by, modified_on, 
            ref_code)
select 2,case when date_part('day',age(lmp,anc_date)) between 0 and 91 then '1' 
when date_part('day',age(lmp,anc_date)) between 92 and 189 then '2'
when date_part('day',age(lmp,anc_date)) between 190 and 245 then '3'
when date_part('day',age(lmp,anc_date)) > 246 then '4' end
,location_id,-1,family_id,member_id,anc_date,-1,'DONE_ON_EMAMTA',-1,now(),'-1',now(),cur_preg_reg_det_id
from (select member_details.family_id as family_id,member_details.member_id as member_id,member_details.cur_preg_reg_det_id,member_details.location_id
,member_details.lmp,max(rch_anc_master.created_on) as anc_date
from member_details
inner join rch_anc_master on rch_anc_master.pregnancy_reg_det_id = member_details.cur_preg_reg_det_id and member_details.preg_reg_det_id is null
where member_details.cur_preg_reg_det_id is not null
group by member_details.family_id ,member_details.member_id ,member_details.cur_preg_reg_det_id,member_details.location_id,member_details.lmp) as t;


-- lmp_notification notification
INSERT INTO public.techo_notification_master(
            notification_type_id, notification_code, location_id, location_hierchy_id, 
            family_id, member_id, schedule_date,
            state, created_by, created_on, modified_by, modified_on)
select 1,0
,case when imt_family.area_id is not null then cast(imt_family.area_id as bigint) else imt_family.location_id end ,location_master.location_hierarchy_id,imt_family.id,member_details.member_id,now(),'PENDING',-1,now(),'-1',now() 
from member_details 
inner join imt_family on imt_family.id = member_details.family_id
inner join location_master on cast(imt_family.area_id as bigint) = location_master.id
where member_details.is_pregnant = false and member_details.gender = 'F' and member_details.is_lmp_followup_done is null
and member_details.marital_status = '629'and member_details.dob > now() - interval '50 Year';

-- Anc notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select '5d1131bc-f5bc-4a4a-8d7d-6dfd3f512f0a' -- anc_config_id
,member_details.lmp,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',member_details.cur_preg_reg_det_id
 from member_details
where member_details.cur_preg_reg_det_id is not null and member_details.preg_reg_det_id is null;


-- WPD notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select 'faedb8e7-3e46-40a2-a9ac-ea7d5de944fa' -- wpd_config_id
,member_details.lmp,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',member_details.cur_preg_reg_det_id
 from member_details
where member_details.cur_preg_reg_det_id is not null and member_details.preg_reg_det_id is null;


-- PNC notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select '9b1a331b-fac5-48f0-908e-ef545e0b0c52' -- pnc_config_id
,rch_wpd_mother_master.date_of_delivery,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',rch_wpd_mother_master.pregnancy_reg_det_id
 from member_details
 inner join rch_wpd_mother_master on rch_wpd_mother_master.member_id = member_details.member_id and rch_wpd_mother_master.date_of_delivery > now() - interval '60 day';

-- Child service notification
INSERT INTO public.event_mobile_notification_pending(
            notification_configuration_type_id, base_date, family_id, 
            member_id, created_by, created_on, modified_by, modified_on, 
            is_completed, state, ref_code)
select 'f51c8c4f-6b2b-4dcb-8e64-ada1a3044a67' -- child_service_id
,member_details.dob,member_details.family_id,member_details.member_id,-1,now(),-1,now(),false,'PENDING',-1
 from member_details
 where member_details.dob > now() - interval '5 year';


-- update mother_id
update member_details set mother_id = mother.member_id from member_details mother,tbl_child 
where tbl_child.cld_huid = member_details.unique_health_id and mother.unique_health_id = tbl_child.mot_huid;



update rch_member_service_data_sync_detail set is_pregnant_in_emamta = member_details.is_pregnant,emamta_lmp = member_details.lmp from member_details 
where rch_member_service_data_sync_detail.member_id = member_details.member_id and member_details.gender = 'F' ;

update member_details set sync_status = (case when gender = 'F' 
and (rch_member_service_data_sync_detail.is_pregnant_in_imtecho is null or  rch_member_service_data_sync_detail.is_pregnant_in_imtecho = false) 
and rch_member_service_data_sync_detail.is_pregnant_in_emamta = true then 'R' else null end) from rch_member_service_data_sync_detail
where rch_member_service_data_sync_detail.member_id = member_details.member_id;

update rch_pregnancy_registration_det set state = 'DELIVERY_DATA_NOT_FOUND'
where id in (select rch_pregnancy_registration_det.id from rch_pregnancy_registration_det
left join member_details on rch_pregnancy_registration_det.id = member_details.cur_preg_reg_det_id
where rch_pregnancy_registration_det.state = 'PREGNANT'
and member_details.member_id is null and rch_pregnancy_registration_det.member_id in (select member_id from member_details));

NEW.is_pregnant = (select is_pregnant from member_details);
NEW.lmp = (select lmp from member_details);
NEW.cur_preg_reg_det_id = (select cur_preg_reg_det_id from member_details);
NEW.anc_visit_dates = (select anc_visit_dates from member_details);
NEW.immunisation_given = (select immunisation_given from member_details);
NEW.mother_id = (select mother_id from member_details);
NEW.sync_status = (select sync_status from member_details);


drop table member_details;
drop table temp_child_details;


end if;
end if;
    case
	when TG_OP != 'INSERT' and new.state = old.state
	then return new;

	when new.state in ('com.argusoft.imtecho.member.state.unverified') 
	then new.basic_state := 'UNVERIFIED';

	when new.state in ('com.argusoft.imtecho.member.state.archived.fhsr.verified',
		'com.argusoft.imtecho.member.state.archived.fhw.reverified',
		'com.argusoft.imtecho.member.state.archived',
		'com.argusoft.imtecho.member.state.archived.mo.verified') 
	then new.basic_state := 'ARCHIVED';

	when new.state in ('com.argusoft.imtecho.member.state.verified',
		'com.argusoft.imtecho.member.state.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.fhw.reverified') 
	then new.basic_state := 'VERIFIED';

	when new.state in ('com.argusoft.imtecho.member.state.dead.fhsr.reverification',
		'com.argusoft.imtecho.member.state.dead.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.mo.reverification',
		'com.argusoft.imtecho.member.state.archived.fhsr.reverification') 
	then new.basic_state := 'REVERIFICATION';

	when new.state in ('com.argusoft.imtecho.member.state.new',
		'com.argusoft.imtecho.member.state.new.fhw.reverified') 
	then new.basic_state := 'NEW';

	when new.state in ('com.argusoft.imtecho.member.state.dead.fhw.reverified',
		'com.argusoft.imtecho.member.state.dead.mo.verified',
		'com.argusoft.imtecho.member.state.dead',
		'com.argusoft.imtecho.member.state.dead.mo.fhw.reverified',
		'com.argusoft.imtecho.member.state.dead.fhsr.verified') 
	then new.basic_state := 'DEAD';

	when new.state in ('com.argusoft.imtecho.member.state.orphan') 
	then new.basic_state := 'ORPHAN';
        
        else
	     new.basic_state := 'UNHANDLED';
	
    end case;
    return new;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;