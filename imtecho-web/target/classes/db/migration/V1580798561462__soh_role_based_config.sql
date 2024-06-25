update menu_config set feature_json = '{"normal":false,"advanced":false}' where menu_name = 'Element Configuration' and navigation_state = 'techo.manage.sohElementConfiguration';

alter table soh_element_configuration
drop COLUMN IF EXISTS is_hidden,
add COLUMN is_hidden boolean;


-- SOH Element analysis query

delete from query_master where code='soh_element_analysis';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'soh_element_analysis', 'elementName,upperBound,lowerBound,upperBoundForRural,lowerBoundForRural,target,targetMid,targetForUrban,targetForRural,targetMidEnable,timelineType','
    with configurations as
    (
        select
        id,
        element_name,
        element_display_short_name,
        element_display_name,
        case
            when ''#upperBound#'' = ''null'' then upper_bound
            else #upperBound#
        end as upper_bound,
        case
            when ''#lowerBound#'' = ''null'' then lower_bound
            else #lowerBound#
        end as lower_bound,
        case
            when ''#upperBoundForRural#'' = ''null'' then upper_bound_for_rural
            else #upperBoundForRural#
        end as upper_bound_for_rural,
        case
            when ''#lowerBoundForRural#'' = ''null'' then lower_bound_for_rural
            else #lowerBoundForRural#
        end as lower_bound_for_rural,
        is_small_value_positive,
        field_name,
        module,
        case
            when ''#target#'' = ''null'' then target
            else #target#
        end as target,
        case
            when ''#targetForRural#'' = ''null'' then target_for_rural
            else #targetForRural#
        end as target_for_rural,
        case
            when ''#targetForUrban#'' = ''null'' then target_for_urban
            else #targetForUrban#
        end as target_for_urban,
        case
            when ''#targetMid#'' = ''null'' then target_mid
            else #targetMid#
        end as target_mid,
        created_by,
        created_on,
        modified_on,
        modified_by,
        is_public,
        element_display_name_postfix,
        case
            when ''#targetMidEnable#'' = ''null'' then target_mid_enable
            else #targetMidEnable#
        end as target_mid_enable,
        tabs_json,
        element_order
        from soh_element_configuration
        where element_name=''#elementName#''
    ),
    percentages as (
        select
        location_id,
        analytics.timeline_type,
        config.*,

        -- for calculate the value
        case
            when (analytics.element_name =''IMR'' and analytics.chart1 != 0) THEN (analytics.value * 1000 / analytics.chart1)
            when (analytics.element_name =''MMR'' and analytics.chart1 != 0) THEN (analytics.value * 100000 / analytics.chart1)
            when (analytics.element_name =''ID'' and analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''SR'' and analytics.male != 0) THEN (analytics.female * 1000 / analytics.male)
            when (analytics.element_name =''SAM'' and analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''LBW'' and analytics.value != 0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value)
            when (analytics.element_name =''PREG_REG'' and analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''FI'' and analytics.chart1 != 0) THEN ((analytics.value) * 100 / analytics.chart1)
            when (analytics.element_name =''Anemia'' and (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) != 0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4))
            when (analytics.element_name =''VERIFICATION_SERVICE'' and analytics.value != 0) THEN ((analytics.chart1 * 100) / analytics.value)
            when (analytics.element_name =''PREG_VERIFICATION_SERVICE'' and analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''AVG_SERVICE_DURATION'' and  analytics.value != 0) THEN ((analytics.chart1) / analytics.value)
            when (analytics.element_name =''NCD_HYPERTENSION'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_HYPERTENSION_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES_CONFIRM'' and analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100)/ config.target
            else 0
        end as calculatedTarget,

        -- for percentage calculation
        case
            when (analytics.element_name =''IMR'' and  analytics.chart1 != 0) THEN ((analytics.value * 1000 / analytics.chart1) * 100) / config.target
            when (analytics.element_name =''MMR'' and  analytics.chart1 != 0) THEN ((analytics.value * 100000 / analytics.chart1) * 100) / config.target
            when (analytics.element_name =''ID'' and  analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''SR'' and  analytics.male != 0) THEN (analytics.female * 1000 / analytics.male)
            when (analytics.element_name =''SAM'' and  analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''LBW'' and  analytics.value != 0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value)
            when (analytics.element_name =''PREG_REG'' and  analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''FI'' and  analytics.chart1 != 0) THEN ((analytics.value) * 100 / analytics.chart1)
            when (analytics.element_name =''Anemia'' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) != 0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4))
            when (analytics.element_name =''VERIFICATION_SERVICE'' and  analytics.value != 0) THEN ((analytics.chart1 * 100) / analytics.value)
            when (analytics.element_name =''PREG_VERIFICATION_SERVICE'' and  analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''AVG_SERVICE_DURATION'' and  analytics.value != 0) THEN ((analytics.chart1) / analytics.value)
            when (analytics.element_name =''NCD_HYPERTENSION'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_HYPERTENSION_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
        end as percentage,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (target_for_rural is null or target_for_rural = 0) then config.target
                    else target_for_rural
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (target_for_urban is null or target_for_urban = 0) then config.target
                    else target_for_urban
                end
            when location.type in (''S'') then config.target
            else config.target
        end as target_1,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (lower_bound is null or lower_bound = 0) then config.lower_bound
                    else lower_bound
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (lower_bound_for_rural is null or lower_bound_for_rural = 0) then lower_bound
                    else config.lower_bound_for_rural
                end
            when location.type in (''S'') then config.lower_bound
            else config.lower_bound
        end as lower_bound_1,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (upper_bound is null or upper_bound = 0) then config.upper_bound
                    else upper_bound
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (upper_bound_for_rural is null or upper_bound_for_rural = 0) then upper_bound
                    else config.upper_bound_for_rural
                end
            when location.type in (''S'') then config.upper_bound
            else config.upper_bound
        end as upper_bound_1

        from soh_timeline_analytics analytics
        inner join location_master location on location.id = analytics.location_id
        inner join configurations config on analytics.element_name = config.element_name
        where analytics.location_id in (select child_id from location_hierchy_closer_det where parent_id = 2 and child_loc_type in (''D'',''C''))
        and analytics.timeline_type = ''#timelineType#''
    ),

    calculations as(
        select
        calculatedTarget as "calculatedTarget",
        case
            when calculatedTarget < lower_bound_1 then ''UNDER_REPORTING''
            when calculatedTarget > upper_bound_1  then ''OVER_REPORTING''
            when calculatedTarget >= lower_bound_1 AND calculatedTarget <= upper_bound_1 then ''AS_EXPECTED_REPORTING''
        end as "reporting",
        case
            when is_small_value_positive then
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then ''YELLOW''
                    when percentages.target_1 > calculatedTarget  then ''GREEN''
                    else ''RED''
                end
            else
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then ''YELLOW''
                    when percentages.target_1 <= calculatedTarget then ''GREEN''
                    else ''RED''
                end
        end as "color",
        case
            when is_small_value_positive then
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then 2
                    when percentages.target_1 > calculatedTarget then 1
                    else 3
                end
            else
            case
                when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then 2
                when percentages.target_1 <= calculatedTarget then 1
                else 3
            end
        end as "sortPriority",
        element_name as "elementName",
        percentage as "percentage",
        location_id as "locationId",
        percentages.timeline_type as "timelineType"
        from percentages
        order by "sortPriority"
    )
    select
    cal.*,
    lm.name as "locationName"
    from calculations cal
    inner join location_master lm on cal."locationId" = lm.id
', true, 'ACTIVE', 'SoH Element Analysis');
