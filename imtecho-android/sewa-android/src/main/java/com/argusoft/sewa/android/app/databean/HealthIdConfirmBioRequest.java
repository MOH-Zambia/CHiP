package com.argusoft.sewa.android.app.databean;

/**
 * <p>
 * Defined fields for health id verification using aadhar biometric details
 * </p>
 *
 */
public class HealthIdConfirmBioRequest {
    private String authType;
    private String bioType;
    private String pid;
    private String txnId;

    public String getAuthType() {
        return authType;
    }

    public void setAuthType(String authType) {
        this.authType = authType;
    }

    public String getBioType() {
        return bioType;
    }

    public void setBioType(String bioType) {
        this.bioType = bioType;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getTxnId() {
        return txnId;
    }

    public void setTxnId(String txnId) {
        this.txnId = txnId;
    }
}
