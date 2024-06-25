-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3222

-- menu_config

INSERT INTO menu_config(group_id, active, menu_name, navigation_state, menu_type, only_admin)
SELECT null, true, 'RCH Locations', 'techo.manage.rchLocations', 'manage', false
WHERE NOT EXISTS (SELECT 1 FROM menu_config WHERE menu_name = 'RCH Locations');

-- rch location retrieval

delete from query_master where code='retrieval_next_level_rch_locations';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieval_next_level_rch_locations', 'id', '
    select
    lm.id as "id",
    lm.name as "name",
    lm.english_name as "englishName",
    lm.type as "type",
    lm.parent as "parentId",
    (select type from location_master where id = lm.parent) as "parentType",
    lm.rch_code as "rchCode",
    ltm.level as "level",
    alsm.id as "anmolId",
    alsm.name as "anmolName",
    alsm.english_name as "anmolEnglishName",
    alsm.type as "anmolType",
    alsm.techo_location_type as "anmolTechoType",
    alsm.rch_code as "anmolRchCode",
    alsm.parent_type as "anmolParentType",
    alsm.techo_parent_location_type as "anmolTechoParentType",
    alsm.parent_rch_code as "anmolParentRchCode",
    alsm.asha_id as "ashaId",
    alsm.anm_id as "anmId",
    alsm2.rch_code as "parentRchCode",
    case
        when alsm.id is not null and cast((select rch_code from location_master where id = lm.parent) as text) != alsm.parent_rch_code then true
        else false
    end as "isParentRchCodeMismatch"
    from location_master lm
    inner join location_type_master ltm on ltm.type = lm.type
    left join anmol_location_master alsm on
        alsm.rch_code = cast(lm.rch_code as text)
        and (
            case
			    when lm.type in (''S'') and alsm.type in (''S'') then true
                when lm.type in (''D'', ''C'') and alsm.type in (''D'') then true
                when lm.type in (''B'', ''Z'') and alsm.type in (''T'') then true
                when lm.type in (''P'') and alsm.type in (''F'') then true
                when lm.type in (''U'') and alsm.type in (''FU'') then true
                when lm.type in (''SC'', ''ANM'') and alsm.type in (''SF'') then true
                when lm.type in (''V'', ''ANG'') and alsm.type in (''V'') then true
                else false
            end
        )
    left join anmol_location_master alsm2 on
	    alsm2.rch_code =
        case
            when (select "type" from location_master where id = #id#) in (''S'', ''R'') then
                cast((
                    select lm2.rch_code from location_master lm2 where lm2.id = (select lm3.parent from location_master lm3 where lm3.id = lm.parent))
                as text)
            else cast((select lm2.rch_code from location_master lm2 where lm2.id = lm.parent) as text)
        end
		and
		case
            when lm.type in (''D'', ''C'') and alsm2.type in (''S'') then true
            when lm.type in (''B'', ''Z'') and alsm2.type in (''D'') then true
            when lm.type in (''P'', ''U'') and alsm2.type in (''T'') then true
            when lm.type in (''SC'', ''ANM'') and alsm2.type in (''F'', ''FU'') then true
            when lm.type in (''V'', ''ANG'') and alsm2.type in (''SF'') then true
            else false
        end
    where
    case
        when (select "type" from location_master where id = #id#) = ''S'' then lm.parent in (select lm2.id from location_master lm2 where lm2.parent = #id#)
        else lm.parent = #id#
    end
', true, 'ACTIVE', 'Retrieval Next Level RCH Locations');

-- retrieve_rch_location_by_rch_code_and_type

delete from query_master where code='retrieve_rch_location_by_rch_code_and_type';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_rch_location_by_rch_code_and_type', 'anmolId,rchCode,type', '

select
    *
from
    anmol_location_master
where
    (case
        when ''#type#'' in (''S'') and type in (''S'') then true
        when ''#type#'' in (''D'', ''C'') and type in (''D'') then true
        when ''#type#'' in (''B'', ''Z'') and type in (''T'') then true
        when ''#type#'' in (''P'') and type in (''F'') then true
        when ''#type#'' in (''U'') and type in (''FU'') then true
        when ''#type#'' in (''SC'', ''ANM'') and type in (''SF'') then true
        when ''#type#'' in (''V'', ''ANG'') and type in (''V'') then true
        else false
    end)
    and rch_code = ''#rchCode#''
    and (id != #anmolId# or ''#anmolId#'' = ''null'');

', true, 'ACTIVE', 'Retrieve RCH Location By RCH Code And Type');

-- update rch location

delete from query_master where code='update_rch_location';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_rch_location', 'locationId,oldRchCode,newRchCode,locationLevel,ashaId,anmId,updateParentRchCodeInMapping,newParentRchCode,anmolType,loggedInUserId', '
    begin;

    -- update rch_code in anmol_location_master (in current and child locations)

    UPDATE
    anmol_location_master
    SET
    rch_code = ''#newRchCode#'',
    parent_rch_code = case when #updateParentRchCodeInMapping# = true then ''#newParentRchCode#'' else parent_rch_code end,
    asha_id = cast(case when #locationLevel# = 7 then #ashaId# else null end as numeric),
    anm_id = cast(case when #locationLevel# = 7 then #anmId# else null end as numeric),
    modified_by = #loggedInUserId#,
    modified_on = now()
    where rch_code = ''#oldRchCode#''
    and type = ''#anmolType#'';

    UPDATE
    anmol_location_master
    SET
    parent_rch_code=''#newRchCode#'',
    modified_by = #loggedInUserId#,
    modified_on = now()
    where parent_rch_code = ''#oldRchCode#''
    and parent_type = ''#anmolType#'';

    -- update rch_code in anmol_location_mapping

    UPDATE
    anmol_location_mapping
    set
        state_code = case when #locationLevel# = 1 then #newRchCode# else state_code end,
        district_code = case when #locationLevel# = 3 then ''#newRchCode#'' else district_code end,
        taluka_code = case when #locationLevel# = 4 then ''#newRchCode#'' else taluka_code end,
        health_facility_code = case when #locationLevel# = 5 then #newRchCode# else health_facility_code end,
        health_subfacility_code = case when #locationLevel# = 6 then #newRchCode# else health_subfacility_code end,
        village_code = case when #locationLevel# = 7 then ''#newRchCode#'' else village_code end,
        asha_id = case when #locationLevel# = 7 then #ashaId# else asha_id end,
        anm_id = case when #locationLevel# = 7 then #anmId# else anm_id end,
        modified_by = #loggedInUserId#,
        modified_on = now()
    WHERE
    case
        when #locationLevel# = 1 then state_code = #oldRchCode#
        when #locationLevel# = 3 then district_code = ''#oldRchCode#''
        when #locationLevel# = 4 then taluka_code = ''#oldRchCode#''
        when #locationLevel# = 5 then health_facility_code = #oldRchCode#
        when #locationLevel# = 6 then health_subfacility_code = #oldRchCode#
        when #locationLevel# = 7 then village_code = ''#oldRchCode#''
        else false
    end;

    -- update parent rch_code in anmol_location_mapping if updateParentRchCodeInMapping flag is true

    UPDATE
    anmol_location_mapping
    set
        state_code = case when #locationLevel# = 3 then #newParentRchCode# else state_code end,
        district_code = case when #locationLevel# = 4 then ''#newParentRchCode#'' else district_code end,
        taluka_code = case when #locationLevel# = 5 then ''#newParentRchCode#'' else taluka_code end,
        health_facility_code = case when #locationLevel# = 6 then #newParentRchCode# else health_facility_code end,
        health_subfacility_code = case when #locationLevel# = 7 then #newParentRchCode# else health_subfacility_code end,
        modified_by = #loggedInUserId#,
        modified_on = now()
    WHERE
    #updateParentRchCodeInMapping# = true
    and case
            when #locationLevel# = 1 then state_code = #oldRchCode#
            when #locationLevel# = 3 then district_code = ''#oldRchCode#''
            when #locationLevel# = 4 then taluka_code = ''#oldRchCode#''
            when #locationLevel# = 5 then health_facility_code = #oldRchCode#
            when #locationLevel# = 6 then health_subfacility_code = #oldRchCode#
            when #locationLevel# = 7 then village_code = ''#oldRchCode#''
            else false
        end;

    -- update location_master

    UPDATE
    location_master
    SET
    rch_code=#newRchCode#,
    modified_by = #loggedInUserId#,
    modified_on = now()
    WHERE id=#locationId#;

    commit;
', false, 'ACTIVE', 'Update RCH Location');


-- insert rch location

delete from query_master where code='insert_rch_location';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'insert_rch_location', 'locationId,rchCode,parentRchCode,locationLevel,ashaId,anmId,name,englishName,techoLocationType,techoParentLocationType,loggedInUserId', '
    begin;

    -- insert record in anmol_location_master

    insert
	into
	anmol_location_master ("name", english_name, "type", techo_location_type, rch_code, parent_type, techo_parent_location_type, parent_rch_code, asha_id, anm_id, created_by, created_on, modified_by, modified_on)
	values (
	    ''#name#'',
	    ''#englishName#'',
		case
			when #locationLevel# = 1 then ''S''
			when #locationLevel# = 3 then ''D''
			when #locationLevel# = 4 then ''T''
			when #locationLevel# = 5 and ''#techoLocationType#'' = ''P'' then ''F''
			when #locationLevel# = 5 and ''#techoLocationType#'' = ''U'' then ''FU''
			when #locationLevel# = 6 then ''SF''
			when #locationLevel# = 7 then ''V''
			else null
		end,
		''#techoLocationType#'',
		''#rchCode#'',
		case
			when #locationLevel# = 1 then ''''
			when #locationLevel# = 3 then ''S''
			when #locationLevel# = 4 then ''D''
			when #locationLevel# = 5 then ''T''
			when #locationLevel# = 6 and ''#techoParentLocationType#'' = ''P'' then ''F''
			when #locationLevel# = 6 and ''#techoParentLocationType#'' = ''U'' then ''FU''
			when #locationLevel# = 7 then ''SF''
			else null
		end,
		''#techoParentLocationType#'',
		''#parentRchCode#'',
        cast(case
            when #locationLevel# = 7 then #ashaId#
            else null
        end as numeric),
        cast(case
            when #locationLevel# = 7 then #anmId#
            else null
        end as numeric),
        #loggedInUserId#,
        now(),
        #loggedInUserId#,
        now()
    );

    -- update location_master

    UPDATE
    location_master
    SET
    rch_code = #rchCode#,
    modified_by = #loggedInUserId#,
    modified_on = now()
    WHERE id = #locationId#;

    commit;
', false, 'ACTIVE', 'Insert RCH Location');

-- insert rch location

delete from query_master where code='insert_rch_location_hierarchy';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'insert_rch_location_hierarchy', 'locationId,rchCode,parentRchCode,ashaId,anmId,healthFacilityType,loggedInUserId', '

    -- insert location hierarchy in anmol_location_mapping

    -- 1) get location hierarchy from anmol_location_master by recursive query

    with anmol_location_mapping_hierarchy as (
        select
        s.rch_code as state_code,
        d.rch_code as district_code,
        t.rch_code as taluka_code,
        hb.rch_code as health_block_code,
        f.rch_code as health_facility_code,
        sf.rch_code as health_subfacility_code,
        village.rch_code as village_code
        from anmol_location_master village
        left join anmol_location_master sf on village.parent_rch_code = sf.rch_code and sf.type = ''SF''
        left join anmol_location_master f on sf.parent_rch_code = f.rch_code and f.type in (''F'', ''FU'')
        left join anmol_location_master t on f.parent_rch_code = t.rch_code and t.type = ''T''
        left join anmol_location_master d on t.parent_rch_code = d.rch_code and d.type = ''D''
        left join anmol_location_master s on d.parent_rch_code = s.rch_code and s.type = ''S''
        left join anmol_location_master hb on hb.parent_rch_code = t.rch_code and hb.type = ''HB''
        where village.rch_code = ''#rchCode#'' and village.type = ''V''
    )

    -- 2) insert records with the given location hierarchy

    INSERT
    into
    anmol_location_mapping
    (district_code, taluka_code, village_code, health_facility_code, health_subfacility_code, health_block_code, health_facility_type, asha_id, anm_id, state_code, location_id, created_by, created_on, modified_by, modified_on)
    select
        (select district_code from anmol_location_mapping_hierarchy) as district_code,
        (select taluka_code from anmol_location_mapping_hierarchy) as taluka_code,
        (select village_code from anmol_location_mapping_hierarchy) as village_code,
        (cast((select health_facility_code from anmol_location_mapping_hierarchy) as numeric)) as health_facility_code,
        (cast((select health_subfacility_code from anmol_location_mapping_hierarchy) as numeric)) as health_subfacility_code,
        (cast((select health_block_code from anmol_location_mapping_hierarchy) as numeric)) as health_block_code,
        #healthFacilityType#,
        #ashaId#,
        #anmId#,
        (cast((select state_code from anmol_location_mapping_hierarchy) as numeric)) as state_code,
        lm.id,
        #loggedInUserId#,
        now(),
        #loggedInUserId#,
        now()
    from
        location_master lm where parent = #locationId# or id = #locationId#;

', false, 'ACTIVE', 'Insert RCH Location Hierarchy');

--

delete from query_master where code='retrieve_lower_level_not_available_rch_locations_count';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_lower_level_not_available_rch_locations_count', 'id', '
    select
    count(*) as "totalCount",
	count(case when lm.type = ''S'' then 1 else null end) as "stateCount",
	count(case when lm.type = ''D'' then 1 else null end) as "districtCount",
	count(case when lm.type = ''C'' then 1 else null end) as "corporationCount",
	count(case when lm.type = ''B'' then 1 else null end) as "blockCount",
	count(case when lm.type = ''Z'' then 1 else null end) as "zoneCount",
	count(case when lm.type = ''P'' then 1 else null end) as "phcCount",
	count(case when lm.type = ''U'' then 1 else null end) as "uphcCount",
	count(case when lm.type = ''SC'' then 1 else null end) as "subCenterCount",
	count(case when lm.type = ''ANM'' then 1 else null end) as "anmAreaCount",
	count(case when lm.type = ''V'' then 1 else null end) as "villageCount",
	count(case when lm.type = ''ANG'' then 1 else null end) as "anganwadiAreaCount",
	get_location_hierarchy(#id#) as "locationHierarchy"
    from location_master lm
    inner join location_type_master ltm on ltm.type = lm.type
    left join anmol_location_master alsm on
        alsm.rch_code = cast(lm.rch_code as text)
        and (
            case
			    when lm.type in (''S'') and alsm.type in (''S'') then true
                when lm.type in (''D'', ''C'') and alsm.type in (''D'') then true
                when lm.type in (''B'', ''Z'') and alsm.type in (''T'') then true
                when lm.type in (''P'') and alsm.type in (''F'') then true
                when lm.type in (''U'') and alsm.type in (''FU'') then true
                when lm.type in (''SC'', ''ANM'') and alsm.type in (''SF'') then true
                when lm.type in (''V'', ''ANG'') and alsm.type in (''V'') then true
                else false
            end
        )
    where
        lm.id in (select child_id from location_hierchy_closer_det where parent_id = #id# and child_id != #id# and child_loc_type in (''S'', ''D'', ''C'', ''B'', ''Z'', ''P'', ''U'', ''SC'', ''ANM'', ''V'', ''ANG''))
        and (alsm.id is null or (alsm.id is not null and cast((select rch_code from location_master where id = lm.parent) as text) != alsm.parent_rch_code))
', true, 'ACTIVE', 'Retrieve Lower Level Not Available RCH Locations Count');

--

delete from query_master where code='retrieve_lower_level_not_available_rch_locations';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_lower_level_not_available_rch_locations', 'id,limit,offset', '
    select
    lm.id,
    lm.name,
    lm.english_name as "englishName",
    lm.type,
    lm.parent,
    lm.rch_code as "rchCode",
    alsm.id as "anmolId",
    ltm.level,
    get_location_hierarchy(lm.id) as "locationHierarchy",
    case
        when (alsm.id is not null and cast((select rch_code from location_master where id = lm.parent) as text) != alsm.parent_rch_code) then true
        else false
    end as "isParentRchCodeMismatch"
    from location_master lm
    inner join location_type_master ltm on ltm.type = lm.type
    left join anmol_location_master alsm on
        alsm.rch_code = cast(lm.rch_code as text)
        and (
            case
			    when lm.type in (''S'') and alsm.type in (''S'') then true
                when lm.type in (''D'', ''C'') and alsm.type in (''D'') then true
                when lm.type in (''B'', ''Z'') and alsm.type in (''T'') then true
                when lm.type in (''P'') and alsm.type in (''F'') then true
                when lm.type in (''U'') and alsm.type in (''FU'') then true
                when lm.type in (''SC'', ''ANM'') and alsm.type in (''SF'') then true
                when lm.type in (''V'', ''ANG'') and alsm.type in (''V'') then true
                else false
            end
        )
    where
        lm.id in (select child_id from location_hierchy_closer_det where parent_id = #id# and child_id != #id# and child_loc_type in (''S'', ''D'', ''C'', ''B'', ''Z'', ''P'', ''U'', ''SC'', ''ANM'', ''V'', ''ANG''))
        and (alsm.id is null or (alsm.id is not null and cast((select rch_code from location_master where id = lm.parent) as text) != alsm.parent_rch_code))
    order by ltm.level
    limit #limit# offset #offset#
', true, 'ACTIVE', 'Retrieve Lower Level Not Available RCH Locations');
