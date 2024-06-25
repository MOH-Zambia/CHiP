package com.argusoft.sewa.android.app.OCR;

import java.util.List;

public class MultipleOcrPage {

    private Integer page;
    private List<OcrQuestionBeanDto> questionsConfigurations;

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public List<OcrQuestionBeanDto> getQuestionsConfigurations() {
        return questionsConfigurations;
    }

    public void setQuestionsConfigurations(List<OcrQuestionBeanDto> questionsConfigurations) {
        this.questionsConfigurations = questionsConfigurations;
    }
}