package com.argusoft.imtecho.mobile.dao.impl;

import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import com.argusoft.imtecho.mobile.dao.SohElementConfigurationDao;
import com.argusoft.imtecho.mobile.model.SohElementConfiguration;
import org.hibernate.query.NativeQuery;
import org.hibernate.transform.Transformers;
import org.hibernate.type.StandardBasicTypes;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public class SohElementConfigurationDaoImpl extends GenericDaoImpl<SohElementConfiguration, Integer> implements SohElementConfigurationDao {

    @Override
    public List<SohElementConfiguration> getAllElements() {

        String query = "select\n" +
                "sec.id as \"id\",\n" +
                "sec.element_name as \"elementName\",\n" +
                "sec.element_display_short_name as \"elementDisplayShortName\",\n" +
                "sec.element_display_name as \"elementDisplayName\",\n" +
                "sec.element_display_name_postfix as \"elementDisplayNamePostfix\",\n" +
                "sec.enable_reporting as \"enableReporting\",\n" +
                "sec.upper_bound as \"upperBound\",\n" +
                "sec.lower_bound as \"lowerBound\",\n" +
                "sec.upper_bound_for_rural as \"upperBoundForRural\",\n" +
                "sec.lower_bound_for_rural as \"lowerBoundForRural\",\n" +
                "sec.is_small_value_positive as \"isSmallValuePositive\",\n" +
                "sec.field_name as \"fieldName\",\n" +
                "sec.module as \"module\",\n" +
                "sec.target as \"target\",\n" +
                "sec.target_for_rural as \"targetForRural\",\n" +
                "sec.target_for_urban as \"targetForUrban\",\n" +
                "sec.target_mid as \"targetMid\",\n" +
                "sec.target_mid_enable as \"targetMidEnable\",\n" +
                "sec.is_public as \"isPublic\",\n" +
                "sec.is_hidden as \"isHidden\",\n" +
                "sec.is_timeline_enable as \"isTimelineEnable\",\n" +
                "sec.element_order as \"elementOrder\",\n" +
                "sec.file_id as \"fileId\",\n" +
                "sec.tabs_json as \"tabsJson\",\n" +
                "sec.created_by as \"createdBy\",\n" +
                "sec.created_on as \"createdOn\",\n" +
                "sec.modified_by as \"modifiedBy\",\n" +
                "sec.modified_on as \"modifiedOn\",\n" +
                "sec.last_updated_analytics as \"lastUpdatedAnalytics\",\n" +
                "sec.footer_description as \"footerDescription\",\n" +
                "sec.is_filter_enable as \"isFilterEnable\",\n" +
                "sec.rank_field_name as \"rankFieldName\",\n" +
                "sec.show_in_menu as \"showInMenu\",\n" +
                "sec.state as \"state\",\n" +
                "cast(sec.element_order as numeric) as \"elemOrder\"\n" +
                "from soh_element_configuration sec\n" +
                "order by \"elemOrder\"";

        NativeQuery<SohElementConfiguration> q = getCurrentSession().createNativeQuery(query)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("elementName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayShortName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayNamePostfix", StandardBasicTypes.STRING)
                .addScalar("enableReporting", StandardBasicTypes.BOOLEAN)
                .addScalar("upperBound", StandardBasicTypes.FLOAT)
                .addScalar("lowerBound", StandardBasicTypes.FLOAT)
                .addScalar("upperBoundForRural", StandardBasicTypes.FLOAT)
                .addScalar("lowerBoundForRural", StandardBasicTypes.FLOAT)
                .addScalar("isSmallValuePositive", StandardBasicTypes.BOOLEAN)
                .addScalar("fieldName", StandardBasicTypes.STRING)
                .addScalar("module", StandardBasicTypes.STRING)
                .addScalar("target", StandardBasicTypes.FLOAT)
                .addScalar("targetForRural", StandardBasicTypes.FLOAT)
                .addScalar("targetForUrban", StandardBasicTypes.FLOAT)
                .addScalar("targetMid", StandardBasicTypes.FLOAT)
                .addScalar("targetMidEnable", StandardBasicTypes.BOOLEAN)
                .addScalar("isPublic", StandardBasicTypes.BOOLEAN)
                .addScalar("isHidden", StandardBasicTypes.BOOLEAN)
                .addScalar("isTimelineEnable", StandardBasicTypes.BOOLEAN)
                .addScalar("elementOrder", StandardBasicTypes.STRING)
                .addScalar("fileId", StandardBasicTypes.INTEGER)
                .addScalar("tabsJson", StandardBasicTypes.STRING)
                .addScalar("createdBy", StandardBasicTypes.INTEGER)
                .addScalar("createdOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("modifiedBy", StandardBasicTypes.INTEGER)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("lastUpdatedAnalytics", StandardBasicTypes.TIMESTAMP)
                .addScalar("footerDescription", StandardBasicTypes.STRING)
                .addScalar("isFilterEnable",StandardBasicTypes.BOOLEAN)
                .addScalar("rankFieldName",StandardBasicTypes.STRING)
                .addScalar("showInMenu",StandardBasicTypes.BOOLEAN)
                .addScalar("state", StandardBasicTypes.STRING);

        return q.setResultTransformer(Transformers.aliasToBean(SohElementConfiguration.class)).list();
    }

    @Override
    public List<SohElementConfiguration> getAllElementsBasedOnPermission(Integer userId) {
        String query = "with user_details as (\n" +
                "select role_id,id from um_user where id =" + userId + "\n" +
                "),\n" +
                "elements_id as ( select\n" +
                "soh_element_permissions.element_id\n" +
                "from\n" +
                "soh_element_permissions inner join user_details on true\n" +
                "where\n" +
                "(case when permission_type = 'ROLE' then reference_id = user_details.role_id end) or\n" +
                "(case when permission_type = 'USER' then reference_id = user_details.id end) or\n" +
                "permission_type = 'ALL')\n" +
                "select\n" +
                "sec.id as \"id\",\n" +
                "sec.element_name as \"elementName\",\n" +
                "sec.element_display_short_name as \"elementDisplayShortName\",\n" +
                "sec.element_display_name as \"elementDisplayName\",\n" +
                "sec.element_display_name_postfix as \"elementDisplayNamePostfix\",\n" +
                "sec.enable_reporting as \"enableReporting\",\n" +
                "sec.upper_bound as \"upperBound\",\n" +
                "sec.lower_bound as \"lowerBound\",\n" +
                "sec.upper_bound_for_rural as \"upperBoundForRural\",\n" +
                "sec.lower_bound_for_rural as \"lowerBoundForRural\",\n" +
                "sec.is_small_value_positive as \"isSmallValuePositive\",\n" +
                "sec.field_name as \"fieldName\",\n" +
                "sec.module as \"module\",\n" +
                "sec.target as \"target\",\n" +
                "sec.target_for_rural as \"targetForRural\",\n" +
                "sec.target_for_urban as \"targetForUrban\",\n" +
                "sec.target_mid as \"targetMid\",\n" +
                "sec.target_mid_enable as \"targetMidEnable\",\n" +
                "sec.is_public as \"isPublic\",\n" +
                "sec.is_hidden as \"isHidden\",\n" +
                "sec.is_timeline_enable as \"isTimelineEnable\",\n" +
                "sec.element_order as \"elementOrder\",\n" +
                "sec.file_id as \"fileId\",\n" +
                "sec.tabs_json as \"tabsJson\",\n" +
                "sec.created_by as \"createdBy\",\n" +
                "sec.created_on as \"createdOn\",\n" +
                "sec.modified_by as \"modifiedBy\",\n" +
                "sec.modified_on as \"modifiedOn\",\n" +
                "sec.last_updated_analytics as \"lastUpdatedAnalytics\",\n" +
                "sec.footer_description as \"footerDescription\",\n" +
                "sec.is_filter_enable as \"isFilterEnable\",\n" +
                "sec.rank_field_name as \"rankFieldName\",\n" +
                "sec.show_in_menu as \"showInMenu\",\n" +
                "sec.state as \"state\",\n" +
                "cast(sec.element_order as numeric) as \"elemOrder\"\n" +
                "from soh_element_configuration sec\n" +
                "where id in (select distinct(element_id) from elements_id) or is_public = true\n" +
                "order by \"elemOrder\"";

        NativeQuery<SohElementConfiguration> q = getCurrentSession().createNativeQuery(query)
                .addScalar("id", StandardBasicTypes.INTEGER)
                .addScalar("elementName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayShortName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayName", StandardBasicTypes.STRING)
                .addScalar("elementDisplayNamePostfix", StandardBasicTypes.STRING)
                .addScalar("enableReporting", StandardBasicTypes.BOOLEAN)
                .addScalar("upperBound", StandardBasicTypes.FLOAT)
                .addScalar("lowerBound", StandardBasicTypes.FLOAT)
                .addScalar("upperBoundForRural", StandardBasicTypes.FLOAT)
                .addScalar("lowerBoundForRural", StandardBasicTypes.FLOAT)
                .addScalar("isSmallValuePositive", StandardBasicTypes.BOOLEAN)
                .addScalar("fieldName", StandardBasicTypes.STRING)
                .addScalar("module", StandardBasicTypes.STRING)
                .addScalar("target", StandardBasicTypes.FLOAT)
                .addScalar("targetForRural", StandardBasicTypes.FLOAT)
                .addScalar("targetForUrban", StandardBasicTypes.FLOAT)
                .addScalar("targetMid", StandardBasicTypes.FLOAT)
                .addScalar("targetMidEnable", StandardBasicTypes.BOOLEAN)
                .addScalar("isPublic", StandardBasicTypes.BOOLEAN)
                .addScalar("isHidden", StandardBasicTypes.BOOLEAN)
                .addScalar("isTimelineEnable", StandardBasicTypes.BOOLEAN)
                .addScalar("elementOrder", StandardBasicTypes.STRING)
                .addScalar("fileId", StandardBasicTypes.INTEGER)
                .addScalar("tabsJson", StandardBasicTypes.STRING)
                .addScalar("createdBy", StandardBasicTypes.INTEGER)
                .addScalar("createdOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("modifiedBy", StandardBasicTypes.INTEGER)
                .addScalar("modifiedOn", StandardBasicTypes.TIMESTAMP)
                .addScalar("lastUpdatedAnalytics", StandardBasicTypes.TIMESTAMP)
                .addScalar("footerDescription", StandardBasicTypes.STRING)
                .addScalar("isFilterEnable",StandardBasicTypes.BOOLEAN)
                .addScalar("rankFieldName",StandardBasicTypes.STRING)
                .addScalar("showInMenu",StandardBasicTypes.BOOLEAN)
                .addScalar("state", StandardBasicTypes.STRING);

        return q.setResultTransformer(Transformers.aliasToBean(SohElementConfiguration.class)).list();

    }
}
