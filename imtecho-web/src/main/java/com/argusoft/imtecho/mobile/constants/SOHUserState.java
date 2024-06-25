package com.argusoft.imtecho.mobile.constants;

public enum  SOHUserState {
    ACTIVE("ACTIVE"),
    OTP_SEND("OTP_SEND"),
    PENDING("PENDING"),
    CODE_GENERATED("CODE_GENERATED"),
    INACTIVE("INACTIVE");
    private String state;

    SOHUserState(String state){
        this.state = state;
    }

    public String getState() {
        return state;
    }
}
