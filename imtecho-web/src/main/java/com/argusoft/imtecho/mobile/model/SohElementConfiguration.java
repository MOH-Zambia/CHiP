package com.argusoft.imtecho.mobile.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Entity
@Table(name = "soh_element_configuration")
public class SohElementConfiguration extends EntityAuditInfo implements Serializable {

    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "element_name")
    private String elementName;

    @Column(name = "element_display_short_name")
    private String elementDisplayShortName;

    @Column(name = "element_display_name")
    private String elementDisplayName;

    @Column(name = "element_display_name_postfix")
    private String elementDisplayNamePostfix;

    @Column(name = "enable_reporting")
    private Boolean enableReporting;

    @Column(name = "upper_bound", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float upperBound;

    @Column(name = "lower_bound", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float lowerBound;

    @Column(name = "upper_bound_for_rural", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float upperBoundForRural;

    @Column(name = "lower_bound_for_rural", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float lowerBoundForRural;

    @Column(name = "is_small_value_positive")
    private Boolean isSmallValuePositive;

    @Column(name = "field_name")
    private String fieldName;

    @Column(name = "module")
    private String module;

    @Column(name = "target", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float target;

    @Column(name = "target_for_rural", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float targetForRural;

    @Column(name = "target_for_urban", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float targetForUrban;

    @Column(name = "target_mid", columnDefinition = "numeric", precision = 6, scale = 2)
    private Float targetMid;

    @Column(name = "target_mid_enable")
    private Boolean targetMidEnable;

    @Column(name = "is_public")
    private Boolean isPublic;

    @Column(name = "is_hidden")
    private Boolean isHidden;

    @Column(name = "element_order")
    private String elementOrder;

    @Column(name = "file_id")
    private Integer fileId;

    @Column(name = "tabs_json")
    private String tabsJson;

    @Column(name = "is_timeline_enable")
    private Boolean isTimelineEnable;

    @Column(name = "last_updated_analytics")
    private Date lastUpdatedAnalytics;

    @Column(name = "state")
    private String state;

    @Column(name = "footer_description")
    private String footerDescription;

    @Column(name="rank_field_name")
    private String rankFieldName;

    @Column(name = "is_filter_enable")
    private Boolean isFilterEnable;

    @Column(name = "show_in_menu")
    private Boolean showInMenu;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getElementName() {
        return elementName;
    }

    public void setElementName(String elementName) {
        this.elementName = elementName;
    }

    public String getElementDisplayShortName() {
        return elementDisplayShortName;
    }

    public void setElementDisplayShortName(String elementDisplayShortName) {
        this.elementDisplayShortName = elementDisplayShortName;
    }

    public String getElementDisplayName() {
        return elementDisplayName;
    }

    public void setElementDisplayName(String elementDisplayName) {
        this.elementDisplayName = elementDisplayName;
    }

    public Boolean getEnableReporting() {
        return enableReporting;
    }

    public void setEnableReporting(Boolean enableReporting) {
        this.enableReporting = enableReporting;
    }

    public Float getUpperBound() {
        return upperBound;
    }

    public void setUpperBound(Float upperBound) {
        this.upperBound = upperBound;
    }

    public Float getLowerBound() {
        return lowerBound;
    }

    public void setLowerBound(Float lowerBound) {
        this.lowerBound = lowerBound;
    }

    public Float getUpperBoundForRural() {
        return upperBoundForRural;
    }

    public void setUpperBoundForRural(Float upperBoundForRural) {
        this.upperBoundForRural = upperBoundForRural;
    }

    public Float getLowerBoundForRural() {
        return lowerBoundForRural;
    }

    public void setLowerBoundForRural(Float lowerBoundForRural) {
        this.lowerBoundForRural = lowerBoundForRural;
    }

    public Boolean getIsSmallValuePositive() {
        return isSmallValuePositive;
    }

    public void setIsSmallValuePositive(Boolean isSmallValuePositive) {
        this.isSmallValuePositive = isSmallValuePositive;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public Float getTarget() {
        return target;
    }

    public void setTarget(Float target) {
        this.target = target;
    }

    public Float getTargetForRural() {
        return targetForRural;
    }

    public void setTargetForRural(Float targetForRural) {
        this.targetForRural = targetForRural;
    }

    public Float getTargetForUrban() {
        return targetForUrban;
    }

    public void setTargetForUrban(Float targetForUrban) {
        this.targetForUrban = targetForUrban;
    }

    public Float getTargetMid() {
        return targetMid;
    }

    public void setTargetMid(Float targetMid) {
        this.targetMid = targetMid;
    }

    public String getElementDisplayNamePostfix() {
        return elementDisplayNamePostfix;
    }

    public void setElementDisplayNamePostfix(String elementDisplayNamePostfix) {
        this.elementDisplayNamePostfix = elementDisplayNamePostfix;
    }

    public Boolean getTargetMidEnable() {
        return targetMidEnable;
    }

    public void setTargetMidEnable(Boolean targetMidEnable) {
        this.targetMidEnable = targetMidEnable;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public Boolean getIsHidden() {
        return isHidden;
    }

    public void setIsHidden(Boolean isHidden) {
        this.isHidden = isHidden;
    }

    public String getElementOrder() {
        return elementOrder;
    }

    public void setElementOrder(String elementOrder) {
        this.elementOrder = elementOrder;
    }

    public Integer getFileId() {
        return fileId;
    }

    public void setFileId(Integer fileId) {
        this.fileId = fileId;
    }

    public String getTabsJson() {
        return tabsJson;
    }

    public void setTabsJson(String tabsJson) {
        this.tabsJson = tabsJson;
    }

    public Boolean getIsTimelineEnable() {
        return isTimelineEnable;
    }

    public void setIsTimelineEnable(Boolean isTimelineEnable) {
        this.isTimelineEnable = isTimelineEnable;
    }

    public Date getLastUpdatedAnalytics() {
        return lastUpdatedAnalytics;
    }

    public void setLastUpdatedAnalytics(Date lastUpdatedAnalytics) {
        this.lastUpdatedAnalytics = lastUpdatedAnalytics;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getFooterDescription() {
        return footerDescription;
    }

    public void setFooterDescription(String footerDescription) {
        this.footerDescription = footerDescription;
    }

    public Boolean getIsFilterEnable() {
        return isFilterEnable;
    }

    public void setIsFilterEnable(Boolean isFilterEnable) {
        this.isFilterEnable = isFilterEnable;
    }

    public Boolean getShowInMenu() {
        return showInMenu;
    }

    public void setShowInMenu(Boolean showInMenu) {
        this.showInMenu = showInMenu;
    }

    public String getRankFieldName() {
        return rankFieldName;
    }

    public void setRankFieldName(String rankFieldName) {
        this.rankFieldName = rankFieldName;
    }
}
