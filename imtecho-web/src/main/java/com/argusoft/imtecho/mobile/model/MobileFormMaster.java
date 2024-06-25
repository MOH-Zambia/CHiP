package com.argusoft.imtecho.mobile.model;

import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "mobile_form_master")
public class MobileFormMaster {

    @EmbeddedId
    private MobileFormMasterPKey mobileFormMasterPKey;
    private String title;
    private String subtitle;
    private String instruction;
    private String question;
    private String type;
    @Column(name="is_mandatory")
    private Boolean isMandatory;
    @Column(name="mandatory_message")
    private String mandatoryMessage;
    private Integer length;
    private String validation;
    private String formula;
    private String datamap;
    private String options;
    private Integer next;
    private String subform;
    @Column(name="related_property_name")
    private String relatedPropertyName;
    @Column(name="is_hidden")
    private Boolean isHidden;
    private String event;
    private Integer binding;
    private Integer page;
    private String hint;
    @Column(name="help_video")
    private String helpVideo;
    private Integer row;
    @Column(name="list_value_field_key")
    private String listValueFieldKey;

    public MobileFormMasterPKey getMobileFormMasterPKey() {
        return mobileFormMasterPKey;
    }

    public void setMobileFormMasterPKey(MobileFormMasterPKey mobileFormMasterPKey) {
        this.mobileFormMasterPKey = mobileFormMasterPKey;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public String getInstruction() {
        return instruction;
    }

    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Boolean getMandatory() {
        return isMandatory;
    }

    public void setMandatory(Boolean mandatory) {
        isMandatory = mandatory;
    }

    public String getMandatoryMessage() {
        return mandatoryMessage;
    }

    public void setMandatoryMessage(String mandatoryMessage) {
        this.mandatoryMessage = mandatoryMessage;
    }

    public Integer getLength() {
        return length;
    }

    public void setLength(Integer length) {
        this.length = length;
    }

    public String getValidation() {
        return validation;
    }

    public void setValidation(String validation) {
        this.validation = validation;
    }

    public String getFormula() {
        return formula;
    }

    public void setFormula(String formula) {
        this.formula = formula;
    }

    public String getDatamap() {
        return datamap;
    }

    public void setDatamap(String datamap) {
        this.datamap = datamap;
    }

    public String getOptions() {
        return options;
    }

    public void setOptions(String options) {
        this.options = options;
    }

    public Integer getNext() {
        return next;
    }

    public void setNext(Integer next) {
        this.next = next;
    }

    public String getSubform() {
        return subform;
    }

    public void setSubform(String subform) {
        this.subform = subform;
    }

    public String getRelatedPropertyName() {
        return relatedPropertyName;
    }

    public void setRelatedPropertyName(String relatedPropertyName) {
        this.relatedPropertyName = relatedPropertyName;
    }

    public Boolean getHidden() {
        return isHidden;
    }

    public void setHidden(Boolean hidden) {
        isHidden = hidden;
    }

    public String getEvent() {
        return event;
    }

    public void setEvent(String event) {
        this.event = event;
    }

    public Integer getBinding() {
        return binding;
    }

    public void setBinding(Integer binding) {
        this.binding = binding;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public String getHint() {
        return hint;
    }

    public void setHint(String hint) {
        this.hint = hint;
    }

    public String getHelpVideo() {
        return helpVideo;
    }

    public void setHelpVideo(String helpVideo) {
        this.helpVideo = helpVideo;
    }

    public Integer getRow() {
        return row;
    }

    public void setRow(Integer row) {
        this.row = row;
    }

    public String getListValueFieldKey() {
        return listValueFieldKey;
    }

    public void setListValueFieldKey(String listValueFieldKey) {
        this.listValueFieldKey = listValueFieldKey;
    }
}
