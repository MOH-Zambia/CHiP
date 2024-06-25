
insert into menu_group(group_name, active, group_type)
select 'RCH Data Push', true, 'manage'
where not exists (select id from menu_group where group_name = 'RCH Data Push' and group_type = 'manage');

update menu_config set group_id = (select id from menu_group where group_name = 'RCH Data Push' and group_type = 'manage')
where menu_name in ('RCH Locations','Manage Location Wards') and menu_type = 'manage';

--
DELETE FROM QUERY_MASTER WHERE CODE='retrieval_next_level_rch_locations';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieval_next_level_rch_locations',
'id',
'
    select
    lm.id as "id",
    lm.name as "name",
    lm.english_name as "englishName",
    lm.type as "type",
    lm.parent as "parentId",
    (select type from location_master where id = lm.parent) as "parentType",
    lm.rch_code as "rchCode",
    get_location_hierarchy(lm.id) as "techoLocationHierarchy",
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
',
'Retrieval Next Level RCH Locations',
true, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_location_hierarchy';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_rch_location_hierarchy',
'anmolLocationMasterId',
'
    with recursive parent_rch_locations as (
        select
            alsm."type",
            alsm."name",
            alsm.english_name,
            alsm.rch_code,
            alsm.parent_type,
            alsm.parent_rch_code,
            case
                when alsm.type = ''V'' then 7
                when alsm.type = ''SF'' then 6
                when alsm.type in (''F'', ''FU'') then 5
                when alsm.type = ''T'' then 4
                when alsm.type = ''D'' then 3
                when alsm.type = ''S'' then 1
            end as level
        from
            anmol_location_master alsm
        where
            alsm.id = #anmolLocationMasterId#
        union
        select
            alsm2."type",
            alsm2."name",
            alsm2.english_name,
            alsm2.rch_code,
            alsm2.parent_type,
            alsm2.parent_rch_code,
            case
                when alsm2.type = ''V'' then 7
                when alsm2.type = ''SF'' then 6
                when alsm2.type in (''F'', ''FU'') then 5
                when alsm2.type = ''T'' then 4
                when alsm2.type = ''D'' then 3
                when alsm2.type = ''S'' then 1
            end as level
        from
            anmol_location_master alsm2
        inner join parent_rch_locations pl on
            alsm2.rch_code = pl.parent_rch_code
            and
            case
                when pl.type = ''V'' then alsm2.type = ''SF''
                when pl.type = ''SF'' then alsm2.type in (''F'', ''FU'')
                when pl.type in (''F'', ''FU'') then alsm2.type = ''T''
                when pl.type = ''T'' then alsm2.type = ''D''
                when pl.type = ''D'' then alsm2.type = ''S''
                when pl.type = ''S'' then false
                else false
            end
    )
    select
        string_agg(prl.name,'' > '' order by prl.level) as "rchLocationHierarchy"
    from
        parent_rch_locations prl;
',
'Retrieve RCH Location Hierarchy',
true, 'ACTIVE');