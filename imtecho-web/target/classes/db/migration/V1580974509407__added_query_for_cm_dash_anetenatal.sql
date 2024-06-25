delete from query_master where code='cm_dashboard_antenatal_corticosteroid';


insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cm_dashboard_antenatal_corticosteroid','finacial_year','
with dates as (
select to_date(case when ''#finacial_year#'' = ''null'' then null else concat(''03-31-'',substr(''#finacial_year#'',1,4)) end,''MM-DD-YYYY'') from_date
,to_date(case when ''#finacial_year#'' = ''null'' then null else concat(''04-01-'',substr(''#finacial_year#'',6,10)) end,''MM-DD-YYYY'') to_date
),ldp as(
  select location_hierchy_closer_det.parent_id as loc_id,
    coalesce(sum(del_reg_still_live_birth),0) as preg_reg,
    coalesce(sum(del_less_eq_34),0) as del_less_eq_34,
    coalesce(sum(del_bet_35_37),0) as del_bet_35_37,
    coalesce(sum(del_greater_37),0) as del_greater_37,
    coalesce(sum(cortico_steroid),0) as cortico_steroid
  from rch_delivery_date_base_location_wise_data_point,location_hierchy_closer_det,dates
  where rch_delivery_date_base_location_wise_data_point.location_id = location_hierchy_closer_det.child_id 
  and location_hierchy_closer_det.parent_id in (select id from location_master where type in(''P'', ''U''))
  and month_year between dates.from_date and dates.to_date
  group by location_hierchy_closer_det.parent_id
 ),
loc as (
	select distinct loc_id from ldp
),
loc_det as (
   select
        case 
            when lm.type in (''D'', ''C'') then ''D''
            when lm.type in (''T'', ''B'', ''Z'') then ''T''
            when lm.type in (''P'', ''U'') then ''P''
            when lm.type in (''V'', ''AA'') then ''V''
            when lm.type in (''A'') then ''A''
            else lm.type end,
        lm.id as loc_id,
        lh.location_id,
        s.english_name as stateName,
        s.location_code as stateCode,
        d.english_name as districtName,
        case when lm.type = ''S'' then 0 else d.location_code end as districtCode,
        b.english_name as talukaName,
        b.cm_dashboard_code as talukaCode,
        p.english_name as facilityName,
        case when p.type = ''P'' then 1 when p.type = ''U'' then 3 else null end as facilityCode,
        sc.english_name as subCenterName,
        v.english_name as villageName,
        a.english_name as areaName
    from loc 
    inner join location_master lm
    on lm.id = loc.loc_id
    left join location_level_hierarchy_master lh
    on lh.id = lm.location_hierarchy_id
    left join location_master s
    on lh.level1 = s.id and s.state = ''ACTIVE'' and s.name not ilike ''%delete%''
    left join location_master d
    on lh.level3 = d.id and d.state = ''ACTIVE'' and d.name not ilike ''%delete%''
    left join location_master b
    on lh.level4 = b.id and b.state = ''ACTIVE'' and b.name not ilike ''%delete%''
    left join location_master p
    on lh.level5 = p.id and p.state = ''ACTIVE'' and p.name not ilike ''%delete%''
    left join location_master sc
    on lh.level6 = sc.id and sc.state = ''ACTIVE'' and sc.name not ilike ''%delete%''
    left join location_master v
    on lh.level7 = v.id and v.state = ''ACTIVE'' and v.name not ilike ''%delete%''
    left join location_master a
    on lh.level8 = a.id and a.state = ''ACTIVE'' and a.name not ilike ''%delete%''
    where lm.state = ''ACTIVE'' and lm.name not ilike ''%delete%'' 

),
 antenatal_corticosteroid as (
select
    cast(''#finacial_year#'' as text) as financialYear,
    loc_det.type as "locationLevel",
    loc_det.districtCode as "districtCode",
    loc_det.districtName as "districtName",
    loc_det.talukaCode as "talukaCode",
    loc_det.talukaName as "talukaName",
    loc_det.facilityName as "facilityName",
    loc_det.facilityCode as "facilityCode",
    loc_det.subCenterName as "subCenterName",
    loc_det.villageName as "villageName",
    loc_det.areaName as "areaName",
	coalesce(preg_reg,0) as "totalDeliveryRegdDuringTheYear",
    coalesce(del_less_eq_34,0) as "deliveryBefore34Weeks", 
	round(case when preg_reg = 0 then 0 else del_less_eq_34*100.0/preg_reg end,2) as "perDeliveryBefore34Weeks",
    coalesce(del_bet_35_37,0) as "deliveryBetween34-37Weeks", 
	round(case when preg_reg = 0 then 0 else del_bet_35_37*100.0/preg_reg end,2) as "perDeliveryBetween34-37Weeks",
    coalesce(del_greater_37,0) as "deliveryAfter37Weeks", 
    round(case when preg_reg = 0 then 0 else del_greater_37*100.0/preg_reg end,2) as "perDeliveryAfter37Weeks",
    coalesce(cortico_steroid,0) as "noOfAntenatalCorticosteroidGivenToDeliveryBefore34Weeks",
	round(case when del_less_eq_34 = 0 then 0 else cortico_steroid*100.0/del_less_eq_34 end,2) as "perNoOfAntenatalCorticosteroidGivenBefore34Weeks",
	current_date as "asOnDate"
from ldp
inner join loc_det on ldp.loc_id = loc_det.loc_id 
)

select * from antenatal_corticosteroid;
',true,'ACTIVE');