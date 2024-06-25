package com.argusoft.sewa.android.app.dtos;

import java.util.LinkedList;

public class HouseHoldLineListMobileDto {
    private String currentLatitude;
    private String currentLongitude;
    private Integer locationId;
    private Integer familyNumber;
    private String familyHead;
    private String familyAvailable;
    private String houseNumber;
    private String houseAddress;
    private String toiletType;
    private Boolean cookingPractices;
    private Boolean handwashAvailable;
    private Boolean isWasteDisposalAvailable;
    private String[] wasteDisposalType;
    private Boolean isWaterSafe;
    private String waterSource;
    private Boolean storageStandards;
    private Boolean dishrackAvailable;
    private Boolean insectsFound;
    private Boolean rodentsFound;
    private Boolean livestockShelterFound;
    private Integer mosquitoNetAvailable;
    private Boolean isIECGiven;
    private LinkedList<MemberDetails> memberDetails;
    private String uuid;
    private String motherRelation;
    private String husbandRelation;


    public String getCurrentLatitude() {
        return currentLatitude;
    }

    public void setCurrentLatitude(String currentLatitude) {
        this.currentLatitude = currentLatitude;
    }

    public String getCurrentLongitude() {
        return currentLongitude;
    }

    public void setCurrentLongitude(String currentLongitude) {
        this.currentLongitude = currentLongitude;
    }

    public Integer getLocationId() {
        return locationId;
    }

    public void setLocationId(Integer locationId) {
        this.locationId = locationId;
    }

    public Integer getFamilyNumber() {
        return familyNumber;
    }

    public void setFamilyNumber(Integer familyNumber) {
        this.familyNumber = familyNumber;
    }

    public String getFamilyHead() {
        return familyHead;
    }

    public void setFamilyHead(String familyHead) {
        this.familyHead = familyHead;
    }

    public String getFamilyAvailable() {
        return familyAvailable;
    }

    public void setFamilyAvailable(String familyAvailable) {
        this.familyAvailable = familyAvailable;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getHouseAddress() {
        return houseAddress;
    }

    public void setHouseAddress(String houseAddress) {
        this.houseAddress = houseAddress;
    }

    public String getToiletType() {
        return toiletType;
    }

    public void setToiletType(String toiletType) {
        this.toiletType = toiletType;
    }

    public Boolean getCookingPractices() {
        return cookingPractices;
    }

    public void setCookingPractices(Boolean cookingPractices) {
        this.cookingPractices = cookingPractices;
    }

    public Boolean getHandwashAvailable() {
        return handwashAvailable;
    }

    public void setHandwashAvailable(Boolean handwashAvailable) {
        this.handwashAvailable = handwashAvailable;
    }

    public Boolean getWasteDisposalAvailable() {
        return isWasteDisposalAvailable;
    }

    public void setWasteDisposalAvailable(Boolean wasteDisposalAvailable) {
        isWasteDisposalAvailable = wasteDisposalAvailable;
    }

    public String[] getWasteDisposalType() {
        return wasteDisposalType;
    }

    public void setWasteDisposalType(String[] wasteDisposalType) {
        this.wasteDisposalType = wasteDisposalType;
    }

    public Boolean getWaterSafe() {
        return isWaterSafe;
    }

    public void setWaterSafe(Boolean waterSafe) {
        isWaterSafe = waterSafe;
    }

    public String getWaterSource() {
        return waterSource;
    }

    public void setWaterSource(String waterSource) {
        this.waterSource = waterSource;
    }

    public Boolean getStorageStandards() {
        return storageStandards;
    }

    public void setStorageStandards(Boolean storageStandards) {
        this.storageStandards = storageStandards;
    }

    public Boolean getDishrackAvailable() {
        return dishrackAvailable;
    }

    public void setDishrackAvailable(Boolean dishrackAvailable) {
        this.dishrackAvailable = dishrackAvailable;
    }

    public Boolean getInsectsFound() {
        return insectsFound;
    }

    public void setInsectsFound(Boolean insectsFound) {
        this.insectsFound = insectsFound;
    }

    public Boolean getRodentsFound() {
        return rodentsFound;
    }

    public void setRodentsFound(Boolean rodentsFound) {
        this.rodentsFound = rodentsFound;
    }

    public Boolean getLivestockShelterFound() {
        return livestockShelterFound;
    }

    public void setLivestockShelterFound(Boolean livestockShelterFound) {
        this.livestockShelterFound = livestockShelterFound;
    }

    public Integer getMosquitoNetAvailable() {
        return mosquitoNetAvailable;
    }

    public void setMosquitoNetAvailable(Integer mosquitoNetAvailable) {
        this.mosquitoNetAvailable = mosquitoNetAvailable;
    }

    public Boolean getIECGiven() {
        return isIECGiven;
    }

    public void setIECGiven(Boolean IECGiven) {
        isIECGiven = IECGiven;
    }

    public LinkedList<MemberDetails> getMemberDetails() {
        return memberDetails;
    }

    public void setMemberDetails(LinkedList<MemberDetails> memberDetails) {
        this.memberDetails = memberDetails;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public String getMotherRelation() {
        return motherRelation;
    }

    public void setMotherRelation(String motherRelation) {
        this.motherRelation = motherRelation;
    }

    public String getHusbandRelation() {
        return husbandRelation;
    }

    public void setHusbandRelation(String husbandRelation) {
        this.husbandRelation = husbandRelation;
    }

    public static class MemberDetails {
        private Integer memberId;
        private String memberName;
        private String motherName;
        private String husbandName;
        private String memberStatus;
        private Boolean isHof;
        private String relationWithHof;
        private String firstName;
        private String middleName;
        private String lastName;
        private String nextOfKin;
        private String religion;
        private String identityProof;
        private String NRCNumber;
        private String passportNumber;
        private String birthCertificateNumber;
        private String gender;
        private Integer maritalStatus;
        private Long dob;
        private Long age;
        private String mobileNumber;
        private Boolean menstruationArrived;
        private Boolean hysterectomyArrived;
        private Boolean menopauseArrived;
        private Long lmpDate;
        private Boolean isLivingWithPartner;
        private Long livingWithPartner;
        private Integer educationStatus;
        private Boolean isWomanPregnant;
        private Boolean isChildGoingToSchool;
        private String childStandard;
        private Boolean familyPlanning;
        private String[] chronicDisease;
        private Boolean onTreatment;
        private String[] chronicDiseaseTreatment;
        private String otherChronicDiseaseTreatment;
        private String otherChronicDisease;
        private String submitForm;
        private String memberUuid;
        private String familyUuid;
        private Boolean memberDead;

        public Integer getMemberId() {
            return memberId;
        }

        public void setMemberId(Integer memberId) {
            this.memberId = memberId;
        }

        public String getMemberName() {
            return memberName;
        }

        public void setMemberName(String memberName) {
            this.memberName = memberName;
        }

        public String getMotherName() {
            return motherName;
        }

        public void setMotherName(String motherName) {
            this.motherName = motherName;
        }

        public String getHusbandName() {
            return husbandName;
        }

        public void setHusbandName(String husbandName) {
            this.husbandName = husbandName;
        }

        public String getMemberStatus() {
            return memberStatus;
        }

        public void setMemberStatus(String memberStatus) {
            this.memberStatus = memberStatus;
        }

        public Boolean getHof() {
            return isHof;
        }

        public void setHof(Boolean hof) {
            isHof = hof;
        }

        public Boolean getWomanPregnant() {
            return isWomanPregnant;
        }

        public void setWomanPregnant(Boolean womanPregnant) {
            isWomanPregnant = womanPregnant;
        }

        public String getRelationWithHof() {
            return relationWithHof;
        }

        public void setRelationWithHof(String relationWithHof) {
            this.relationWithHof = relationWithHof;
        }

        public String getFirstName() {
            return firstName;
        }

        public void setFirstName(String firstName) {
            this.firstName = firstName;
        }

        public String getMiddleName() {
            return middleName;
        }

        public void setMiddleName(String middleName) {
            this.middleName = middleName;
        }

        public String getLastName() {
            return lastName;
        }

        public void setLastName(String lastName) {
            this.lastName = lastName;
        }

        public String getNextOfKin() {
            return nextOfKin;
        }

        public void setNextOfKin(String nextOfKin) {
            this.nextOfKin = nextOfKin;
        }

        public String getReligion() {
            return religion;
        }

        public void setReligion(String religion) {
            this.religion = religion;
        }

        public String getIdentityProof() {
            return identityProof;
        }

        public void setIdentityProof(String identityProof) {
            this.identityProof = identityProof;
        }

        public String getNRCNumber() {
            return NRCNumber;
        }

        public void setNRCNumber(String NRCNumber) {
            this.NRCNumber = NRCNumber;
        }

        public String getPassportNumber() {
            return passportNumber;
        }

        public void setPassportNumber(String passportNumber) {
            this.passportNumber = passportNumber;
        }

        public String getBirthCertificateNumber() {
            return birthCertificateNumber;
        }

        public void setBirthCertificateNumber(String birthCertificateNumber) {
            this.birthCertificateNumber = birthCertificateNumber;
        }

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public Integer getMaritalStatus() {
            return maritalStatus;
        }

        public void setMaritalStatus(Integer maritalStatus) {
            this.maritalStatus = maritalStatus;
        }

        public Long getDob() {
            return dob;
        }

        public void setDob(Long dob) {
            this.dob = dob;
        }

        public Long getAge() {
            return age;
        }

        public void setAge(Long age) {
            this.age = age;
        }

        public String getMobileNumber() {
            return mobileNumber;
        }

        public void setMobileNumber(String mobileNumber) {
            this.mobileNumber = mobileNumber;
        }

        public Boolean getMenstruationArrived() {
            return menstruationArrived;
        }

        public void setMenstruationArrived(Boolean menstruationArrived) {
            this.menstruationArrived = menstruationArrived;
        }

        public Boolean getHysterectomyArrived() {
            return hysterectomyArrived;
        }

        public void setHysterectomyArrived(Boolean hysterectomyArrived) {
            this.hysterectomyArrived = hysterectomyArrived;
        }

        public Boolean getMenopauseArrived() {
            return menopauseArrived;
        }

        public void setMenopauseArrived(Boolean menopauseArrived) {
            this.menopauseArrived = menopauseArrived;
        }

        public Long getLmpDate() {
            return lmpDate;
        }

        public void setLmpDate(Long lmpDate) {
            this.lmpDate = lmpDate;
        }

        public Boolean getLivingWithPartner() {
            return isLivingWithPartner;
        }

        public void setLivingWithPartner(Long livingWithPartner) {
            this.livingWithPartner = livingWithPartner;
        }

        public Integer getEducationStatus() {
            return educationStatus;
        }

        public void setEducationStatus(Integer educationStatus) {
            this.educationStatus = educationStatus;
        }

        public Boolean getChildGoingToSchool() {
            return isChildGoingToSchool;
        }

        public void setChildGoingToSchool(Boolean childGoingToSchool) {
            isChildGoingToSchool = childGoingToSchool;
        }

        public String getChildStandard() {
            return childStandard;
        }

        public void setChildStandard(String childStandard) {
            this.childStandard = childStandard;
        }

        public Boolean getFamilyPlanning() {
            return familyPlanning;
        }

        public void setFamilyPlanning(Boolean familyPlanning) {
            this.familyPlanning = familyPlanning;
        }

        public String[] getChronicDisease() {
            return chronicDisease;
        }

        public void setChronicDisease(String[] chronicDisease) {
            this.chronicDisease = chronicDisease;
        }

        public Boolean getOnTreatment() {
            return onTreatment;
        }

        public void setOnTreatment(Boolean onTreatment) {
            this.onTreatment = onTreatment;
        }

        public String[] getChronicDiseaseTreatment() {
            return chronicDiseaseTreatment;
        }

        public void setChronicDiseaseTreatment(String[] chronicDiseaseTreatment) {
            this.chronicDiseaseTreatment = chronicDiseaseTreatment;
        }

        public String getOtherChronicDiseaseTreatment() {
            return otherChronicDiseaseTreatment;
        }

        public void setOtherChronicDiseaseTreatment(String otherChronicDiseaseTreatment) {
            this.otherChronicDiseaseTreatment = otherChronicDiseaseTreatment;
        }

        public String getOtherChronicDisease() {
            return otherChronicDisease;
        }

        public void setOtherChronicDisease(String otherChronicDisease) {
            this.otherChronicDisease = otherChronicDisease;
        }

        public String getSubmitForm() {
            return submitForm;
        }

        public void setSubmitForm(String submitForm) {
            this.submitForm = submitForm;
        }

        public void setLivingWithPartner(Boolean livingWithPartner) {
            isLivingWithPartner = livingWithPartner;
        }

        public String getMemberUuid() {
            return memberUuid;
        }

        public void setMemberUuid(String memberUuid) {
            this.memberUuid = memberUuid;
        }

        public String getFamilyUuid() {
            return familyUuid;
        }

        public void setFamilyUuid(String familyUuid) {
            this.familyUuid = familyUuid;
        }

        public Boolean getMemberDead() {
            return memberDead;
        }

        public void setMemberDead(Boolean memberDead) {
            this.memberDead = memberDead;
        }
    }
}
