package com.argusoft.sewa.android.app.OCR;

public class OcrQuestionBeanDto {
    private String question;
    private String fieldName;
    private String fieldType;
    private Integer lineNumber;
    private String splitByForExtractingAnswer;

    public OcrQuestionBeanDto(String question, String fieldName, String fieldType, Integer lineNumber, String splitByForExtractingAnswer) {
        this.question = question;
        this.fieldName = fieldName;
        this.fieldType = fieldType;
        this.lineNumber = lineNumber;
        this.splitByForExtractingAnswer = splitByForExtractingAnswer;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getFieldName() {
        return fieldName;
    }

    public void setFieldName(String fieldName) {
        this.fieldName = fieldName;
    }

    public String getFieldType() {
        return fieldType;
    }

    public void setFieldType(String fieldType) {
        this.fieldType = fieldType;
    }

    public Integer getLineNumber() {
        return lineNumber;
    }

    public void setLineNumber(Integer lineNumber) {
        this.lineNumber = lineNumber;
    }

    public String getSplitByForExtractingAnswer() {
        return splitByForExtractingAnswer;
    }

    public void setSplitByForExtractingAnswer(String splitByForExtractingAnswer) {
        this.splitByForExtractingAnswer = splitByForExtractingAnswer;
    }
}
