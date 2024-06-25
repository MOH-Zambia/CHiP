package com.argusoft.imtecho.mobile.dto;

import java.util.List;

public class SohGroupByElementsDto {

    private String module;

    private String moduleName;

    private Boolean isPublic;

    private Integer moduleOrder;

    private String state;

    private List<SohElementConfigurationDto> elements;

    private String footerDescription;

    private Boolean isElementsAvailableForDisplay;

    public String getModule() {
        return module;
    }

    public void setModule(String module) {
        this.module = module;
    }

    public String getModuleName() {
        return moduleName;
    }

    public void setModuleName(String moduleName) {
        this.moduleName = moduleName;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public List<SohElementConfigurationDto> getElements() {
        return elements;
    }

    public void setElements(List<SohElementConfigurationDto> elements) {
        this.elements = elements;
    }

    public Integer getModuleOrder() {
        return moduleOrder;
    }

    public void setModuleOrder(Integer moduleOrder) {
        this.moduleOrder = moduleOrder;
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

    public Boolean getElementsAvailableForDisplay() {
        return isElementsAvailableForDisplay;
    }

    public void setElementsAvailableForDisplay(Boolean elementsAvailableForDisplay) {
        isElementsAvailableForDisplay = elementsAvailableForDisplay;
    }
}
