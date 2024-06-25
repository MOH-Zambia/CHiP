DELETE FROM QUERY_MASTER WHERE CODE='retrieve_lower_level_not_available_rch_locations';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_lower_level_not_available_rch_locations',
'id,limit,offset,selectedTypes',
'
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
        lm.id in (select child_id from location_hierchy_closer_det where parent_id = #id# and child_id != #id# and child_loc_type in (#selectedTypes#))
        and (alsm.id is null or (alsm.id is not null and cast((select rch_code from location_master where id = lm.parent) as text) != alsm.parent_rch_code))
    order by ltm.level
    limit #limit# offset #offset#
',
'Retrieve Lower Level Not Available RCH Locations',
true, 'ACTIVE');