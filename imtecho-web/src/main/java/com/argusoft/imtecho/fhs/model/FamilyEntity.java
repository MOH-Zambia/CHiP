package com.argusoft.imtecho.fhs.model;

import com.argusoft.imtecho.common.model.EntityAuditInfo;
import com.argusoft.imtecho.common.util.IJoinEnum;
import com.argusoft.imtecho.mobile.mapper.MemberDataBeanMapper;
import lombok.Getter;
import lombok.Setter;
//import lombok.Setter;

import javax.persistence.*;
import javax.persistence.criteria.JoinType;
import java.io.Serializable;
import java.util.Set;

/**
 * <p>
 * Define imt_family entity and its fields.
 * </p>
 *
 * @author kunjan
 * @since 26/08/20 11:00 AM
 */
@Getter
@Setter
@Entity
@Table(name = "imt_family")
public class FamilyEntity extends EntityAuditInfo implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Integer id;

    @Column(name = "family_id")
    private String familyId;

    @Column(name = "house_number")
    private String houseNumber;

    @Column(name = "location_id")
    private Integer locationId;

    @Column
    private String religion;

    @Column(name = "toilet_available_flag")
    private Boolean toiletAvailableFlag;

    @Column(name = "is_verified_flag")
    private Boolean isVerifiedFlag;

    @Column
    private String state;

    @Column(name = "assigned_to")
    private Integer assignedTo;

    @Column
    private String address1;

    @Column
    private String address2;

    @Column(name = "area_id")
    private Integer areaId;

    @Column(name = "vulnerable_flag")
    private Boolean vulnerableFlag;

    @Column(name = "migratory_flag")
    private Boolean migratoryFlag;

    @Column
    private String latitude;

    @Column
    private String longitude;

    @Column(name = "comment", length = 4000)
    private String comment;

    @Column(name = "current_state")
    private Integer currentState;

    @Column(name = "is_report")
    private Boolean isReport;

    @Column(name = "contact_person_id")
    private Integer contactPersonId;

    @Column(name = "hof_id")
    private Integer headOfFamily;

    @Column(name = "additional_info")
    private String additionalInfo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "current_state", referencedColumnName = "id", insertable = false, updatable = false)
    private FamilyStateDetailEntity currentStateDetail;

    @Column(name = "merged_with")
    private String mergedWith;

    @Column(name = "any_member_cbac_done")
    private Boolean anyMemberCbacDone;

    @Column(name = "type_of_house")
    private String typeOfHouse;

    @Column(name = "type_of_toilet")
    private String typeOfToilet;

    @Column(name = "other_toilet")
    private String otherToilet;

    @Column(name = "electricity_availability")
    private String electricityAvailability;

    @Column(name = "drinking_water_source")
    private String drinkingWaterSource;

    @Column(name = "other_water_source")
    private String otherWaterSource;

    @Column(name = "fuel_for_cooking")
    private String fuelForCooking;

    @ElementCollection(fetch = FetchType.EAGER)
    @CollectionTable(name = "imt_family_vehicle_detail_rel", joinColumns = @JoinColumn(name = "family_id"))
    @Column(name = "vehicle_details")
    private Set<String> vehicleDetails;

    @Column(name = "other_motorized_vehicle")
    private String otherMotorizedVehicle;

    @Column(name = "house_ownership_status")
    private String houseOwnershipStatus;

    @Column(name = "annual_income")
    private String annualIncome;

    @Column(name = "remarks")
    private String remarks;

    @Column(name = "eligible_women_count")
    private Integer eligibleWomenCount;

    @Column(name = "eligible_children_count")
    private Integer eligibleChildrenCount;

    @Column(name = "is_hold_id_poor")
    private Boolean isHoldIdPoor;

    @Column(name = "split_from")
    private Integer splitFrom;

    @Column(name = "is_providing_consent")
    private Boolean isProvidingConsent;

    @Column(name = "vulnerability_criteria")
    private String vulnerabilityCriteria;

    @Column(name = "other_type_of_house")
    private String otherTypeOfHouse;

    @Column(name = "residence_status")
    private String residenceStatus;

    @Column(name = "native_state")
    private String nativeState;

    @Column(name = "vehicle_availability_flag")
    private Boolean vehicleAvailabilityFlag;

    @Column(name = "anyone_travelled_foreign")
    private Boolean anyoneTravelledForeign;

    @Column(name = "family_uuid")
    private String familyUuid;

    @Column(name = "outdoor_cooking_practices")
    private Boolean outdoorCookingPractices;

    @Column(name = "waste_disposal_available")
    private Boolean wasteDisposalAvailable;

    @Column(name = "other_waste_disposal")
    private String otherWasteDisposal;

    @Column(name = "handwash_available")
    private Boolean handwashAvailable;

    @Column(name = "storage_meets_standard")
    private Boolean storageMeetsStandard;

    @Column(name = "water_safety_meets_standard")
    private Boolean waterSafetyMeetsStandard;

    @Column(name = "dishrack_available")
    private Boolean dishrackAvailable;

    @Column(name = "complaint_of_insects")
    private Boolean complaintOfInsects;

    @Column(name = "complaint_of_rodents")
    private Boolean complaintOfRodents;

    @Column(name = "separate_livestock_shelter")
    private Boolean separateLivestockShelter;

    @Column(name = "no_of_mosquito_nets_available")
    private Integer noOfMosquitoNetsAvailable;

    @Column(name = "waste_disposal_method")
    private String wasteDisposalMethod;

    private transient Set<Integer> wasteDisposalDetails;

    @Column(name = "is_iec_given")
    private Boolean isIecGiven;

    public void setWasteDisposalDetails(Set<Integer> wasteDisposalDetails) {
        this.wasteDisposalDetails = wasteDisposalDetails;
        setWasteDisposalMethod(MemberDataBeanMapper.convertSetToCommaSeparatedString(this.wasteDisposalDetails, ","));
    }

    public static class Fields {

        private Fields() {
            throw new IllegalStateException("Utility Class");
        }

        public static final String ID = "id";
        public static final String FAMILY_ID = "familyId";
        public static final String FAMILY_UUID = "familyUuid";
        public static final String LOCATION_ID = "locationId";
        public static final String IS_VERIFIED_FLAG = "isVerifiedFlag";
        public static final String STATE = "state";
        public static final String ASSIGNED_TO = "assignedTo";
        public static final String AREA_ID = "areaId";
        public static final String CURRENT_STATE_DETAIL = "currentStateDetail";
        public static final String MEMBER_DETAILS = "memberDetails";
        public static final String REMARKS = "remarks";
        public static final String USER_ID = "userId";
        public static final String STATES = "states";
        public static final String MEMBER_VERIFIED = "memberVerified";
    }

    public enum FamilyEntityJoin implements IJoinEnum {

        MEMBER_DETAILS(Fields.MEMBER_DETAILS, Fields.MEMBER_DETAILS, JoinType.INNER),
        CURRENT_STATE_DETAIL(Fields.CURRENT_STATE_DETAIL, Fields.CURRENT_STATE_DETAIL, JoinType.INNER),
        CHRONIC_DISEASE_DETAILS(Fields.MEMBER_DETAILS + "." + MemberEntity.Fields.CHRONIC_DISEASE_DETAILS, MemberEntity.Fields.CHRONIC_DISEASE_DETAILS, JoinType.LEFT),
        CONGENITAL_ANOMALY_DETAILS(Fields.MEMBER_DETAILS + "." + MemberEntity.Fields.CONGENITAL_ANOMALY_DETAILS, MemberEntity.Fields.CONGENITAL_ANOMALY_DETAILS, JoinType.LEFT),
        CURRENT_DISEASE_DETAILS(Fields.MEMBER_DETAILS + "." + MemberEntity.Fields.CURRENT_DISEASE_DETAILS, MemberEntity.Fields.CURRENT_DISEASE_DETAILS, JoinType.LEFT),
        EYE_ISSUE_DETAILS(Fields.MEMBER_DETAILS + "." + MemberEntity.Fields.EYE_ISSUE_DETAILS, MemberEntity.Fields.EYE_ISSUE_DETAILS, JoinType.LEFT),
        CURRENT_MEMBER_STATE_DETAIL(Fields.MEMBER_DETAILS + "." + MemberEntity.Fields.CURRENT_STATE_DETAIL, "member" + MemberEntity.Fields.CURRENT_STATE_DETAIL, JoinType.INNER);

        private String value;
        private String alias;
        private JoinType joinType;

        public String getValue() {
            return value;
        }

        public String getAlias() {
            return alias;
        }

        public JoinType getJoinType() {
            return joinType;
        }

        FamilyEntityJoin(String value, String alias, JoinType joinType) {
            this.value = value;
            this.alias = alias;
            this.joinType = joinType;
        }
    }


    @Override
    public String toString() {
        return "FamilyEntity{" +
                "id=" + id +
                ", familyId='" + familyId + '\'' +
                ", houseNumber='" + houseNumber + '\'' +
                ", locationId=" + locationId +
                ", religion='" + religion + '\'' +
                ", toiletAvailableFlag=" + toiletAvailableFlag +
                ", isVerifiedFlag=" + isVerifiedFlag +
                ", state='" + state + '\'' +
                ", assignedTo=" + assignedTo +
                ", address1='" + address1 + '\'' +
                ", address2='" + address2 + '\'' +
                ", areaId=" + areaId +
                ", vulnerableFlag=" + vulnerableFlag +
                ", migratoryFlag=" + migratoryFlag +
                ", latitude='" + latitude + '\'' +
                ", longitude='" + longitude + '\'' +
                ", comment='" + comment + '\'' +
                ", currentState=" + currentState +
                ", isReport=" + isReport +
                ", contactPersonId=" + contactPersonId +
                ", headOfFamily=" + headOfFamily +
                ", additionalInfo='" + additionalInfo + '\'' +
                ", currentStateDetail=" + currentStateDetail +
                ", mergedWith='" + mergedWith + '\'' +
                ", anyMemberCbacDone=" + anyMemberCbacDone +
                ", typeOfHouse='" + typeOfHouse + '\'' +
                ", typeOfToilet='" + typeOfToilet + '\'' +
                ", otherToilet='" + otherToilet + '\'' +
                ", electricityAvailability='" + electricityAvailability + '\'' +
                ", drinkingWaterSource='" + drinkingWaterSource + '\'' +
                ", otherWaterSource='" + otherWaterSource + '\'' +
                ", fuelForCooking='" + fuelForCooking + '\'' +
                ", vehicleDetails=" + vehicleDetails +
                ", otherMotorizedVehicle='" + otherMotorizedVehicle + '\'' +
                ", houseOwnershipStatus='" + houseOwnershipStatus + '\'' +
                ", annualIncome='" + annualIncome + '\'' +
                ", remarks='" + remarks + '\'' +
                ", eligibleWomenCount=" + eligibleWomenCount +
                ", eligibleChildrenCount=" + eligibleChildrenCount +
                ", isHoldIdPoor=" + isHoldIdPoor +
                ", splitFrom=" + splitFrom +
                ", isProvidingConsent=" + isProvidingConsent +
                ", vulnerabilityCriteria='" + vulnerabilityCriteria + '\'' +
                ", otherTypeOfHouse='" + otherTypeOfHouse + '\'' +
                ", residenceStatus='" + residenceStatus + '\'' +
                ", nativeState='" + nativeState + '\'' +
                ", vehicleAvailabilityFlag=" + vehicleAvailabilityFlag +
                ", anyoneTravelledForeign=" + anyoneTravelledForeign +
                ", familyUuid='" + familyUuid + '\'' +
                ", outdoorCookingPractices=" + outdoorCookingPractices +
                ", wasteDisposalAvailable=" + wasteDisposalAvailable +
                ", otherWasteDisposal='" + otherWasteDisposal + '\'' +
                ", handwashAvailable=" + handwashAvailable +
                ", storageMeetsStandard=" + storageMeetsStandard +
                ", waterSafetyMeetsStandard=" + waterSafetyMeetsStandard +
                ", dishrackAvailable=" + dishrackAvailable +
                ", complaintOfInsects=" + complaintOfInsects +
                ", complaintOfRodents=" + complaintOfRodents +
                ", separateLivestockShelter=" + separateLivestockShelter +
                ", noOfMosquitoNetsAvailable=" + noOfMosquitoNetsAvailable +
                ", wasteDisposalMethod='" + wasteDisposalMethod + '\'' +
                ", wasteDisposalDetails=" + wasteDisposalDetails +
                ", isIecGiven=" + isIecGiven +
                '}';
    }
}
