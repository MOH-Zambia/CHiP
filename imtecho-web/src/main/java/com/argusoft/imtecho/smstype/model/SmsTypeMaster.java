package com.argusoft.imtecho.smstype.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * <p>
 * Define sms_type_master entity
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:22 PM
 */
@Entity
@Table(name = "sms_type_master")
@Data
public class SmsTypeMaster extends EntityAuditInfo implements Serializable {
    @Id
    @Column(name = "sms_type")
    private String smsType;

    @Column(name = "sms_text")
    private String smsText;

    @Column(name = "discription")
    private String discription;

    @Column(name = "state")
    @Enumerated(EnumType.STRING)
    private State state;

    @Column(name = "template_id")
    private String templateId;

    public enum State {
        ACTIVE,
        INACTIVE
    }

    public static class Fields {
        private Fields() {
        }

        public static final String SMS_TYPE = "smsType";
        public static final String SMS_TEXT = "smsText";
        public static final String DISCRIPTION = "discription";
        public static final String STATE = "state";
        public static final String TEMPLATE_ID = "templateId";

    }

}
