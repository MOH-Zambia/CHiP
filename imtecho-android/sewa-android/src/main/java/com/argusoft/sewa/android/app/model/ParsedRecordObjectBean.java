package com.argusoft.sewa.android.app.model;

import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import org.json.JSONObject;

import java.io.Serializable;

@DatabaseTable
public class ParsedRecordObjectBean extends BaseEntity implements Serializable {

    @DatabaseField
    private String checksum;
    @DatabaseField
    private Long dateOfMobile;
    @DatabaseField
    private String token;
    @DatabaseField
    private Long userId;
    @DatabaseField
    private Long memberId;
    @DatabaseField
    private Boolean hasMedia;
    @DatabaseField
    private String mediaPaths;
    @DatabaseField
    private String answerEntity;
    @DatabaseField
    private String custumType = "-1";
    @DatabaseField
    private String relatedInstance;
    @DatabaseField
    private Long formFilledUpTime;
    @DatabaseField
    private Long notificationId;
    @DatabaseField
    private String morbidityAnswer = "-1";
    @DatabaseField
    private String answer;
    @DatabaseField
    private String recordUrl;

    public String getChecksum() {
        return checksum;
    }

    public void setChecksum(String checksum) {
        this.checksum = checksum;
    }

    public Long getDateOfMobile() {
        return dateOfMobile;
    }

    public void setDateOfMobile(Long dateOfMobile) {
        this.dateOfMobile = dateOfMobile;
    }

    public String getAnswerEntity() {
        return answerEntity;
    }

    public void setAnswerEntity(String answerEntity) {
        this.answerEntity = answerEntity;
    }

    public String getCustumType() {
        return custumType;
    }

    public void setCustumType(String custumType) {
        this.custumType = custumType;
    }

    public String getRelatedInstance() {
        return relatedInstance;
    }

    public void setRelatedInstance(String relatedInstance) {
        this.relatedInstance = relatedInstance;
    }

    public Long getFormFilledUpTime() {
        return formFilledUpTime;
    }

    public void setFormFilledUpTime(Long formFilledUpTime) {
        this.formFilledUpTime = formFilledUpTime;
    }

    public Long getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(Long notificationId) {
        this.notificationId = notificationId;
    }

    public String getMorbidityAnswer() {
        return morbidityAnswer;
    }

    public void setMorbidityAnswer(String morbidityAnswer) {
        this.morbidityAnswer = morbidityAnswer;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public String getRecordUrl() {
        return recordUrl;
    }

    public void setRecordUrl(String recordUrl) {
        this.recordUrl = recordUrl;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Boolean getHasMedia() {
        return hasMedia;
    }

    public void setHasMedia(Boolean hasMedia) {
        this.hasMedia = hasMedia;
    }

    public String getMediaPaths() {
        return mediaPaths;
    }

    public void setMediaPaths(String mediaPaths) {
        this.mediaPaths = mediaPaths;
    }


    public ParsedRecordObjectBean() {

    }

    ;

    @Override
    public boolean equals(Object o) {
        return super.equals(o);
    }

    @Override
    public int hashCode() {
        return super.hashCode();
    }

    public ParsedRecordObjectBean(boolean forQuery) {
        if (forQuery) {
            custumType = null;
            morbidityAnswer = null;
        }
    }

    @Override
    public String toString() {
        return "ParsedRecordObjectBean{" +
                "checksum='" + checksum + '\'' +
                ", dateOfMobile=" + dateOfMobile +
                ", token='" + token + '\'' +
                ", userId=" + userId +
                ", memberId=" + memberId +
                ", hasMedia=" + hasMedia +
                ", mediaPaths='" + mediaPaths + '\'' +
                ", answerEntity='" + answerEntity + '\'' +
                ", custumType='" + custumType + '\'' +
                ", relatedInstance='" + relatedInstance + '\'' +
                ", formFilledUpTime=" + formFilledUpTime +
                ", notificationId=" + notificationId +
                ", morbidityAnswer='" + morbidityAnswer + '\'' +
                ", answer=" + answer +
                ", recordUrl='" + recordUrl + '\'' +
                '}';
    }

    public String pack() {
        // added check sum
        StringBuilder data = new StringBuilder(checksum);
        data.append(GlobalTypes.BEAN_SEPARATOR);

        // added date
        data.append(dateOfMobile);
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added answer entity
        data.append(answerEntity);
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added custum type
        if (custumType != null) {
            data.append(custumType);
        } else {
            data.append("-1");
        }
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added related instance
        if (relatedInstance != null) {
            data.append(relatedInstance);
        } else {
            data.append("-1");
        }
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added form fiilled up time
        data.append(formFilledUpTime);
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added notification id
        if (notificationId != null) {
            data.append(notificationId);
        } else {
            data.append(Long.valueOf(Long.parseLong("-1")));
        }
        data.append(GlobalTypes.BEAN_SEPARATOR);

        //added morbidity
        if (morbidityAnswer != null) {
            data.append(morbidityAnswer);
        } else {
            data.append("-1");
        }
        data.append(GlobalTypes.BEAN_SEPARATOR);

        // added final ansewer
        data.append(answer);

        return data.toString();
    }


}