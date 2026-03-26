package com.argusoft.sewa.android.app.model;

import android.os.Parcel;
import android.os.Parcelable;


public class InsightBean implements Parcelable {

    private String title;
    private String description;
    private String severity;
    private String healthProgram;
    private String actionLabel;

    public InsightBean() {
    }

    protected InsightBean(Parcel in) {
        title = in.readString();
        description = in.readString();
        severity = in.readString();
        healthProgram = in.readString();
        actionLabel = in.readString(); // NEW — must match writeToParcel order
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(title);
        dest.writeString(description);
        dest.writeString(severity);
        dest.writeString(healthProgram);
        dest.writeString(actionLabel); // NEW — must match readString order above
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<InsightBean> CREATOR = new Creator<InsightBean>() {
        @Override
        public InsightBean createFromParcel(Parcel in) {
            return new InsightBean(in);
        }

        @Override
        public InsightBean[] newArray(int size) {
            return new InsightBean[size];
        }
    };

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }

    public String getHealthProgram() { return healthProgram; }
    public void setHealthProgram(String healthProgram) { this.healthProgram = healthProgram; }

    // NEW
    public String getActionLabel() { return actionLabel; }
    public void setActionLabel(String actionLabel) { this.actionLabel = actionLabel; }
}
