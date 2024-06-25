DELETE FROM public.query_master where code = '108_pickup_highrisk';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, '108_pickup_highrisk', 'from_date,to_date', 
    'with highriskusr as (
select id , member_id, gvk_call_state, schedule_date, call_attempt, diseases,
call_response_message,pickup_schedule_date,gvk_call_previous_state,treatment_performed_info 
from gvk_high_risk_follow_up_usr_info where gvk_call_state in 
(''com.argusoft.imtecho.gvk.call.beneficiary-not-visited-phc-pickedup-schedule'',
''com.argusoft.imtecho.gvk.call.pickedup-schedule'',
''com.argusoft.imtecho.gvk.call.beneficiary-not-pickedup-by-108-pickedup-schedule'',
''com.argusoft.imtecho.gvk.call.pickedup-schedule-for-next-visit'')
and pickup_schedule_date between 
	cast(case when #from_date# is null then ''01/10/1970'' else ''#from_date#'' end as date)
	and 
	cast(case when #to_date# is null then ''01/10/1970'' else ''#to_date#'' end as date)
order by pickup_schedule_date desc
)
,display_det as(
select row_number() over() as "Sr no.", 
mem.first_name || '' '' || mem.middle_name || '' '' || mem.last_name || '' ('' || mem.unique_health_id || '')'' as "Name of Beneficiary (Member ID)",
case when mem.mobile_number != null then mem.mobile_number else (case when coninfo.mobile_number is null then ''N/A'' else coninfo.mobile_number end) end as "Phone number of Beneficiary",
string_agg(lm.name,''> '' order by lhcd.depth desc) as "Location",
concat(fam.house_number, '','', fam.address1, '','', fam.address2) as "Address",
(case when hrisk.diseases like ''%SAM%'' then hid_sncu.name || ''('' || hid_sncu.address || '')''  
	when hrisk.diseases like ''%Very Low Birth Weight%'' then hid_cmtc.name || ''('' || hid_cmtc.address || '')''
	else '''' end) as "Health Infrastructure" ,
case when fhwnam.first_name is null then ''N/A'' else concat(fhwnam.first_name, '' '', fhwnam.middle_name, '' '', fhwnam.last_name, '' ('', fhwnam.contact_number , '')'') end as "FHW Name",
case when ashanam.first_name is null then ''N/A'' else concat(ashanam.first_name, '' '', ashanam.middle_name, '' '', ashanam.last_name, '' ('', ashanam.contact_number , '')'') end as "Asha Name",
hrisk.diseases as "High Risk", 
to_char(hrisk.pickup_schedule_date, ''DD/MM/YYYY HH:MI:SS AM'') as "Schedule (Date and Time)"
from highriskusr hrisk 
inner join imt_member mem on hrisk.member_id = mem.id 
inner join imt_family fam on mem.family_id = fam.family_id
left join imt_member hof on fam.hof_id = hof.id 
left join imt_member coninfo on fam.contact_person_id = coninfo.id 
left join um_user_location fhw on fam.location_id = fhw.loc_id  and fhw.state = ''ACTIVE'' 
left join um_user fhwnam on fhw.user_id = fhwnam.id and fhwnam.role_id = 30 and fhwnam.state = ''ACTIVE'' 
left join um_user_location ashaLoc on fam.area_id = ashaLoc.loc_id  and ashaLoc.state = ''ACTIVE'' 
left join um_user ashanam on ashaLoc.user_id = ashanam.id and ashanam.role_id = 24 and ashanam.state = ''ACTIVE''
left join location_hierchy_closer_det lhcd on (case when fam.area_id is null then fam.location_id else cast(fam.area_id as bigint) end) = lhcd.child_id 
left join location_master lm on lm.id = lhcd.parent_id 
left join location_type_master loc_name on lm.type = loc_name.type 
left join location_hierchy_closer_det loc_hel on (case when fam.area_id is null then fam.location_id else cast(fam.area_id as bigint) end) = loc_hel.child_id  and loc_hel.parent_loc_type in (''B'',''Z'') 
left join health_infrastructure_details hid_sncu on loc_hel.parent_id = hid_sncu.location_id and ( hid_sncu.is_sncu = true) 
left join health_infrastructure_details hid_cmtc on loc_hel.parent_id = hid_cmtc.location_id and ( hid_cmtc.is_cmtc = true ) 
where mem.basic_state = ''VERIFIED'' 
group by mem.unique_health_id,mem.first_name ,mem.middle_name,mem.last_name,mem.mobile_number,
coninfo.first_name,coninfo.middle_name,coninfo.last_name,coninfo.mobile_number,fam.house_number,fam.address1,fam.address2,
fhwnam.contact_number,fhwnam.first_name,fhwnam.middle_name,fhwnam.last_name,hid_sncu.name,hid_sncu.address,hid_cmtc.name,hid_cmtc.address,
ashanam.contact_number,ashanam.first_name,ashanam.middle_name,ashanam.last_name,hrisk.diseases,hrisk.pickup_schedule_date,hrisk.schedule_date
) select * from display_det;', 
true, 'ACTIVE', 'It will give the list of beneficiary which will be picked up by 108 on selected date');