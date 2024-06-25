package com.argusoft.imtecho.smstype.dto;

import com.argusoft.imtecho.smstype.model.SmsTypeMaster.State;
import lombok.Data;

import java.util.Date;

/**
 * <p>
 * Dto for sms type
 * </p>
 *
 * @author monika
 * @since 10/03/21 12:23 PM
 */
@Data
public class SmsTypeMasterDto {

    private String smsType;
    private String smsText;
    private String discription;
    private State state;
    private String templateId;
    private Date createdOn;
    private Integer createdBy;
    private Date modifiedOn;
    private Integer modifiedBy;

}
