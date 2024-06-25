--Trigger For ANC

drop trigger if exists rch_anc_hmis_update on rch_anc_master;

create or replace function rch_anc_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

	if new.health_infrastructure_id is not null then
		select rch_anc_master.health_infrastructure_id,
		health_infrastructure_details.type
		into _health_infra_id, _health_infra_type
		from rch_anc_master
		inner join health_infrastructure_details on rch_anc_master.health_infrastructure_id = health_infrastructure_details.id
		where rch_anc_master.id = new.id;
	elsif new.delivery_place in ('HOSP','MAMTA_DAY') then
		with health_infra_detail as (
			select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
			from location_hierchy_closer_det lh,health_infrastructure_details hid
			where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
			order by lh.child_id,lh.depth
		)
		select health_infra_detail.health_infra_id,
		health_infra_detail.type
		into _health_infra_id, _health_infra_type
		from rch_anc_master
		inner join health_infra_detail on rch_anc_master.location_id = health_infra_detail.location_id
		where rch_anc_master.id = new.id;
	else
		select null,null into _health_infra_id,_health_infra_type;
	end if;

	update rch_anc_master
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger rch_anc_hmis_update after insert on rch_anc_master for each row execute procedure rch_anc_hmis_updation();

--Trigger for PNC

drop trigger if exists rch_pnc_hmis_update on rch_pnc_master;

create or replace function rch_pnc_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

	if new.health_infrastructure_id is not null then
		select rch_pnc_master.health_infrastructure_id,
		health_infrastructure_details.type
		into _health_infra_id, _health_infra_type
		from rch_pnc_master
		inner join health_infrastructure_details on rch_pnc_master.health_infrastructure_id = health_infrastructure_details.id
		where rch_pnc_master.id = new.id;
	elsif new.delivery_place in ('HOSP','MAMTA_DAY') then
		with health_infra_detail as (
			select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
			from location_hierchy_closer_det lh,health_infrastructure_details hid
			where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
			order by lh.child_id,lh.depth
		)
		select health_infra_detail.health_infra_id,
		health_infra_detail.type
		into _health_infra_id, _health_infra_type
		from rch_pnc_master
		inner join health_infra_detail on rch_pnc_master.location_id = health_infra_detail.location_id
		where rch_pnc_master.id = new.id;
	else
		select null,null into _health_infra_id,_health_infra_type;
	end if;

	update rch_pnc_master
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger rch_pnc_hmis_update after insert on rch_pnc_master for each row execute procedure rch_pnc_hmis_updation();

--Trigger for CSV

drop trigger if exists rch_csv_hmis_update on rch_child_service_master;

create or replace function rch_csv_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

	if new.health_infrastructure_id is not null then
		select rch_child_service_master.health_infrastructure_id,
		health_infrastructure_details.type
		into _health_infra_id, _health_infra_type
		from rch_child_service_master
		inner join health_infrastructure_details on rch_child_service_master.health_infrastructure_id = health_infrastructure_details.id
		where rch_child_service_master.id = new.id;
	elsif new.delivery_place in ('HOSP','MAMTA_DAY') then
		with health_infra_detail as (
			select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
			from location_hierchy_closer_det lh,health_infrastructure_details hid
			where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
			order by lh.child_id,lh.depth
		)
		select health_infra_detail.health_infra_id,
		health_infra_detail.type
		into _health_infra_id, _health_infra_type
		from rch_child_service_master
		inner join health_infra_detail on rch_child_service_master.location_id = health_infra_detail.location_id
		where rch_child_service_master.id = new.id;
	else
		select null,null into _health_infra_id,_health_infra_type;
	end if;

	update rch_child_service_master
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger rch_csv_hmis_update after insert on rch_child_service_master for each row execute procedure rch_csv_hmis_updation();

--Trigger for immunisation

drop trigger if exists rch_immunisation_hmis_update on rch_immunisation_master;

create or replace function rch_immunisation_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    select case when rch_immunisation_master.visit_type = 'FHW_ANC' then rch_anc_master.hmis_health_infra_id
                when rch_immunisation_master.visit_type = 'FHW_WPD' then rch_wpd_mother_master.health_infrastructure_id
                when rch_immunisation_master.visit_type = 'FHW_PNC' then rch_pnc_master.hmis_health_infra_id
                when rch_immunisation_master.visit_type = 'FHW_CS' then rch_child_service_master.hmis_health_infra_id
                else null end as health_infra_id,
           case when rch_immunisation_master.visit_type = 'FHW_ANC' then rch_anc_master.hmis_health_infra_type
                when rch_immunisation_master.visit_type = 'FHW_WPD' then rch_wpd_mother_master.type_of_hospital
                when rch_immunisation_master.visit_type = 'FHW_PNC' then rch_pnc_master.hmis_health_infra_type
                when rch_immunisation_master.visit_type = 'FHW_CS' then rch_child_service_master.hmis_health_infra_type
                else null end as health_infra_type
    into _health_infra_id, _health_infra_type
    from rch_immunisation_master
    left join rch_anc_master on rch_immunisation_master.visit_id = rch_anc_master.id and rch_immunisation_master.visit_type = 'FHW_ANC'
    left join rch_wpd_mother_master on rch_immunisation_master.visit_id = rch_wpd_mother_master.id and rch_immunisation_master.visit_type = 'FHW_WPD'
    left join rch_pnc_master on rch_immunisation_master.visit_id = rch_pnc_master.id and rch_immunisation_master.visit_type = 'FHW_PNC'
    left join rch_child_service_master on rch_immunisation_master.visit_id = rch_child_service_master.id and rch_immunisation_master.visit_type = 'FHW_CS'
    where rch_immunisation_master.id = new.id;

	update rch_child_service_master
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger rch_immunisation_hmis_update after insert on rch_immunisation_master for each row execute procedure rch_immunisation_hmis_updation();

--Trigger for Hypertension

drop trigger if exists ncd_hypertension_hmis_update on ncd_member_hypertension_detail;

create or replace function ncd_hypertension_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with health_infra_detail as (
        select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
        from location_hierchy_closer_det lh,health_infrastructure_details hid
        where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
        order by lh.child_id,lh.depth
    )
    select case when ncd_member_referral.referred_from_health_infrastructure_id is not null then ncd_member_referral.referred_from_health_infrastructure_id
                else health_infra_detail.health_infra_id end as health_infra_id,
           case when ncd_member_referral.referred_from_health_infrastructure_id is not null then health_infrastructure_details.type
                else health_infra_detail.type end as health_infra_type
    into _health_infra_id, _health_infra_type
    from ncd_member_hypertension_detail
    left join health_infra_detail on health_infra_detail.location_id = ncd_member_hypertension_detail.location_id
    left join ncd_member_referral on ncd_member_hypertension_detail.referral_id = ncd_member_referral.id
    left join health_infrastructure_details on health_infrastructure_details.id = ncd_member_referral.referred_from_health_infrastructure_id
    where ncd_member_hypertension_detail.id = new.id;

	update ncd_member_hypertension_detail
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_hypertension_hmis_update after insert on ncd_member_hypertension_detail for each row execute procedure ncd_hypertension_hmis_updation();

--Trigger for Diabetes

drop trigger if exists ncd_diabetes_hmis_update on ncd_member_diabetes_detail;

create or replace function ncd_diabetes_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with health_infra_detail as (
        select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
        from location_hierchy_closer_det lh,health_infrastructure_details hid
        where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
        order by lh.child_id,lh.depth
    )
    select case when ncd_member_referral.referred_from_health_infrastructure_id is not null then ncd_member_referral.referred_from_health_infrastructure_id
                else health_infra_detail.health_infra_id end as health_infra_id,
           case when ncd_member_referral.referred_from_health_infrastructure_id is not null then health_infrastructure_details.type
                else health_infra_detail.type end as health_infra_type
    into _health_infra_id, _health_infra_type
    from ncd_member_diabetes_detail
    left join health_infra_detail on health_infra_detail.location_id = ncd_member_diabetes_detail.location_id
    left join ncd_member_referral on ncd_member_diabetes_detail.referral_id = ncd_member_referral.id
    left join health_infrastructure_details on health_infrastructure_details.id = ncd_member_referral.referred_from_health_infrastructure_id
    where ncd_member_diabetes_detail.id = new.id;

	update ncd_member_diabetes_detail
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_diabetes_hmis_update after insert on ncd_member_diabetes_detail for each row execute procedure ncd_diabetes_hmis_updation();

--Trigger for Oral

drop trigger if exists ncd_oral_hmis_update on ncd_member_oral_detail;

create or replace function ncd_oral_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with health_infra_detail as (
        select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
        from location_hierchy_closer_det lh,health_infrastructure_details hid
        where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
        order by lh.child_id,lh.depth
    )
    select case when ncd_member_referral.referred_from_health_infrastructure_id is not null then ncd_member_referral.referred_from_health_infrastructure_id
                else health_infra_detail.health_infra_id end as health_infra_id,
           case when ncd_member_referral.referred_from_health_infrastructure_id is not null then health_infrastructure_details.type
                else health_infra_detail.type end as health_infra_type
    into _health_infra_id, _health_infra_type
    from ncd_member_oral_detail
    left join health_infra_detail on health_infra_detail.location_id = ncd_member_oral_detail.location_id
    left join ncd_member_referral on ncd_member_oral_detail.referral_id = ncd_member_referral.id
    left join health_infrastructure_details on health_infrastructure_details.id = ncd_member_referral.referred_from_health_infrastructure_id
    where ncd_member_oral_detail.id = new.id;

	update ncd_member_oral_detail
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_oral_hmis_update after insert on ncd_member_oral_detail for each row execute procedure ncd_oral_hmis_updation();

--Trigger for Breast

drop trigger if exists ncd_breast_hmis_update on ncd_member_breast_detail;

create or replace function ncd_breast_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with health_infra_detail as (
        select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
        from location_hierchy_closer_det lh,health_infrastructure_details hid
        where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
        order by lh.child_id,lh.depth
    )
    select case when ncd_member_referral.referred_from_health_infrastructure_id is not null then ncd_member_referral.referred_from_health_infrastructure_id
                else health_infra_detail.health_infra_id end as health_infra_id,
           case when ncd_member_referral.referred_from_health_infrastructure_id is not null then health_infrastructure_details.type
                else health_infra_detail.type end as health_infra_type
    into _health_infra_id, _health_infra_type
    from ncd_member_breast_detail
    left join health_infra_detail on health_infra_detail.location_id = ncd_member_breast_detail.location_id
    left join ncd_member_referral on ncd_member_breast_detail.referral_id = ncd_member_referral.id
    left join health_infrastructure_details on health_infrastructure_details.id = ncd_member_referral.referred_from_health_infrastructure_id
    where ncd_member_breast_detail.id = new.id;

	update ncd_member_breast_detail
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_breast_hmis_update after insert on ncd_member_breast_detail for each row execute procedure ncd_breast_hmis_updation();

--Trigger for Cervical

drop trigger if exists ncd_cervical_hmis_update on ncd_member_cervical_detail;

create or replace function ncd_cervical_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with health_infra_detail as (
        select distinct on(lh.child_id)lh.child_id as location_id,hid.id as health_infra_id,hid.type
        from location_hierchy_closer_det lh,health_infrastructure_details hid
        where hid.location_id = lh.parent_id and hid.type in (1061,1062,1063)
        order by lh.child_id,lh.depth
    )
    select case when ncd_member_referral.referred_from_health_infrastructure_id is not null then ncd_member_referral.referred_from_health_infrastructure_id
                else health_infra_detail.health_infra_id end as health_infra_id,
           case when ncd_member_referral.referred_from_health_infrastructure_id is not null then health_infrastructure_details.type
                else health_infra_detail.type end as health_infra_type
    into _health_infra_id, _health_infra_type
    from ncd_member_cervical_detail
    left join health_infra_detail on health_infra_detail.location_id = ncd_member_cervical_detail.location_id
    left join ncd_member_referral on ncd_member_cervical_detail.referral_id = ncd_member_referral.id
    left join health_infrastructure_details on health_infrastructure_details.id = ncd_member_referral.referred_from_health_infrastructure_id
    where ncd_member_cervical_detail.id = new.id;

	update ncd_member_cervical_detail
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_cervical_hmis_update after insert on ncd_member_cervical_detail for each row execute procedure ncd_cervical_hmis_updation();

--Trigger for member_disease_diagnosis

drop trigger if exists ncd_disease_diagnosis_hmis_update on ncd_member_diseases_diagnosis;

create or replace function ncd_disease_diagnosis_hmis_updation() returns trigger as $$

declare
	_health_infra_id integer;
	_health_infra_type integer;

begin

    with details as (
        select *
        from ncd_member_referral
        where member_id = new.member_id
        and disease_code = new.disease_code
        and referred_from_health_infrastructure_id is not null
        order by id
        limit 1
    )
    select ncd_member_referral.referred_from_health_infrastructure_id,
    health_infrastructure_details.type
    into _health_infra_id, _health_infra_type
    from details
    inner join ncd_member_referral on details.id = ncd_member_referral.id
    inner join health_infrastructure_details on ncd_member_referral.referred_from_health_infrastructure_id = health_infrastructure_details.id;

	update ncd_member_diseases_diagnosis
	set hmis_health_infra_id = _health_infra_id,
	hmis_health_infra_type = _health_infra_type
	where id = new.id;

	return null;

end;
$$ language plpgsql;

create trigger ncd_disease_diagnosis_hmis_update after insert on ncd_member_diseases_diagnosis for each row execute procedure ncd_disease_diagnosis_hmis_updation();