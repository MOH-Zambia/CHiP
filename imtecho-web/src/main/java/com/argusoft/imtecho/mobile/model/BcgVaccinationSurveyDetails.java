package com.argusoft.imtecho.mobile.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import lombok.Getter;
import lombok.Setter;

import javax.persistence.*;

@Entity
@Table(name = "bcg_vaccination_survey_details")
@Getter
@Setter
public class BcgVaccinationSurveyDetails extends EntityAuditInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Basic(optional = false)
    @Column(name = "id")
    private Integer id;

    @Column(name = "member_id")
    private Integer memberId;

    @Column(name = "tb_treatment")
    private Boolean tbTreatment;

    @Column(name = "tb_prevent_therapy")
    private Boolean tbPreventTherapy;

    @Column(name = "tb_diagnosed")
    private Boolean tbDiagnosed;

    @Column(name = "cough_for_two_weeks")
    private Boolean coughForTwoWeeks;

    @Column(name = "fever_for_two_weeks")
    private Boolean feverForTwoWeeks;

    @Column(name = "significant_weight_loss")
    private Boolean significantWeightLoss;

    @Column(name = "blood_in_sputum")
    private Boolean bloodInSputum;

    @Column(name = "consent_unavailable")
    private Boolean consentUnavailable;

    @Column(name = "bed_ridden")
    private Boolean bedRidden;

    @Column(name = "is_pregnant")
    private Boolean isPregnant;

    @Column(name = "is_hiv")
    private Boolean isHiv;

    @Column(name = "is_cancer")
    private Boolean isCancer;

    @Column(name = "on_medication")
    private Boolean onMedication;

    @Column(name = "organ_transplant")
    private Boolean organTransplant;

    @Column(name = "blood_transfusion")
    private Boolean bloodTransfusion;

    @Column(name = "bcg_allergy")
    private Boolean bcgAllergy;

    @Column(name = "is_high_risk")
    private Boolean isHighRisk;

    @Column(name = "beneficiary_type")
    private String beneficiaryType;

    @Column(name = "bcg_willing")
    private Boolean bcgWilling;

    @Column(name = "reason_for_not_willing")
    private String reasonForNotWilling;

    @Column(name = "nikshay_id")
    private String nikshayId;

    @Column(name = "hic")
    private String hic;

    @Column(name = "bcg_eligible")
    private Boolean bcgEligible;

    @Column(name = "height")
    private Integer height;

    @Column(name = "weight")
    private Float weight;

    @Column(name = "bmi")
    private Float bmi;

    @Column(name = "location_id")
    private Integer locationId;

    @Column(name = "other_reason")
    private String otherReason;

    @Column(name = "filled_from")
    private String filledFrom;

    @Column(name = "bcg_eligible_filled")
    private Boolean bcgEligibleFilled;
    public static class Fields {
        public static final String MEMBER_ID = "memberId";
    }

}
