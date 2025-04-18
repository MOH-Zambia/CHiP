package com.argusoft.imtecho.chip.model;

import com.argusoft.imtecho.rch.model.VisitCommonFields;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

@Getter
@Setter
@Entity
@Table(name = "event_based_care_module")
public class EventBasedCareModule extends VisitCommonFields implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    private Integer id;
    @Column(name = "service_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date serviceDate;
    @Column(name = "member_status")
    private String memberStatus;
    @Column(name = "events_reported")
    private String eventsReported;
    @Column(name = "other_events_reported")
    private String otherEventsReported;
    @Column(name = "similar_symptoms_household")
    private Boolean similarSymptomsHousehold;
    @Column(name = "notify_facility")
    private Boolean notifyFacility;
    @Column(name = "facility")
    private String facility;
    @Column(name = "referral_required")
    private Boolean referralRequired;
    @Column(name = "is_iec_given")
    private Boolean isIecGiven;
}
