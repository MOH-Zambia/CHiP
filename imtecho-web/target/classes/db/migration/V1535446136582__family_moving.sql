update query_master set query = 'update imt_family f 
set state = ''com.argusoft.imtecho.family.state.unverified'',
location_id = case when #locationId# is not null then #locationId# else f.location_id end,modified_on = now(),modified_by = #userId#
where f.family_id in (#familyIds#)'
where code = 'family_unverified_marking';
