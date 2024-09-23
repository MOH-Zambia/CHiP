package com.argusoft.imtecho.fhir.mapper;

import com.argusoft.imtecho.fhir.util.FhirUtil;
import com.argusoft.imtecho.fhs.dto.ReferralDto;
import org.hl7.fhir.r4.model.*;

import java.util.*;

/**
 * FhirReferralMapper is a mapper class that provides methods to convert
 * ReferralDto objects into various FHIR (Fast Healthcare Interoperability Resources)
 * resources including ServiceRequest, Patient, Composition, and Bundle.
 */
public class FhirReferralMapper {

    private FhirReferralMapper() {
    }

    static String IP = FhirUtil.getUri();

    /**
     * Converts a ReferralDto object to a FHIR ServiceRequest resource.
     *
     * @param referral the referral data transfer object
     * @return a FHIR ServiceRequest resource
     */
    public static ServiceRequest convertToServiceRequest(ReferralDto referral) {
        ServiceRequest serviceRequest = new ServiceRequest();

        serviceRequest.setId(referral.getUniqueId());
        Identifier identifier = new Identifier();
        identifier.setSystem(IP);
        identifier.setValue(referral.getUniqueId());
        serviceRequest.setIdentifier(Collections.singletonList(identifier));
        serviceRequest.setStatus(ServiceRequest.ServiceRequestStatus.ACTIVE);
        serviceRequest.setIntent(ServiceRequest.ServiceRequestIntent.ORDER);

        serviceRequest.setPriority(ServiceRequest.ServiceRequestPriority.ROUTINE);

        CodeableConcept code = new CodeableConcept();
        Coding coding = new Coding();
        coding.setSystem(IP);
        coding.setCode(referral.getTypeCode());
        coding.setDisplay(referral.getTypeDescription());
        code.addCoding(coding);
        serviceRequest.setCode(code);

        Meta meta = new Meta();
        meta.setLastUpdated(new Date());
        serviceRequest.setMeta(meta);

        Reference requesterReference = new Reference();
        requesterReference.setDisplay(referral.getReferredBy());
        serviceRequest.setRequester(requesterReference);

        serviceRequest.setAuthoredOn(referral.getReferredOn());

        if (referral.getReasons() != null) {
            CodeableConcept reasonCode = new CodeableConcept();
            reasonCode.setText(referral.getReasons());
            serviceRequest.setReasonCode(Collections.singletonList(reasonCode));
        }

        if (referral.getNotes() != null) {
            Annotation annotation = new Annotation();
            annotation.setText(referral.getNotes());
            serviceRequest.setNote(Collections.singletonList(annotation));
        }

        if (referral.getServiceArea() != null) {
            CodeableConcept category = new CodeableConcept();
            category.setText(referral.getServiceArea());
            serviceRequest.setCategory(Collections.singletonList(category));
        }

        if (referral.getLocation() != null) {
            CodeableConcept category = new CodeableConcept();
            category.setText(referral.getLocation());
            serviceRequest.setLocationCode(Collections.singletonList(category));
        }

        return serviceRequest;
    }

    /**
     * Converts a ReferralDto object to a FHIR Patient resource.
     *
     * @param referral the referral data transfer object
     * @return a FHIR Patient resource
     */
    public static Patient convertToPatient(ReferralDto referral) {
        Patient patient = new Patient();

        patient.setId(referral.getPatientId());

        Identifier identifier = new Identifier();
        identifier.setSystem(IP);
        identifier.setValue(referral.getSystemClientId());
        patient.setIdentifier(Collections.singletonList(identifier));

        HumanName name = new HumanName();
        name.setFamily(referral.getLastName());
        List<StringType> givenNames = new ArrayList<>();
        givenNames.add(new StringType(referral.getFirstName()));
        if (referral.getMiddleName() != null) {
            givenNames.add(new StringType(referral.getMiddleName()));
        }
        name.setGiven(givenNames);
        patient.setName(Collections.singletonList(name));

        if ("F".equals(referral.getGender())) {
            patient.setGender(Enumerations.AdministrativeGender.FEMALE);
        } else if ("M".equals(referral.getGender())) {
            patient.setGender(Enumerations.AdministrativeGender.MALE);
        } else {
            patient.setGender(Enumerations.AdministrativeGender.UNKNOWN);
        }

        if (referral.getDateOfBirth() != null) {
            patient.setBirthDate(referral.getDateOfBirth());
        }

        if (referral.getMobileNumber() != null) {
            ContactPoint contactPoint = new ContactPoint();
            contactPoint.setSystem(ContactPoint.ContactPointSystem.PHONE);
            contactPoint.setValue(referral.getMobileNumber());
            patient.setTelecom(Collections.singletonList(contactPoint));
        }

        if (referral.getReligion() != null) {
            patient.addExtension()
                    .setUrl("http://hl7.org/fhir/StructureDefinition/patient-religion")
                    .setValue(new DecimalType(referral.getReligion()));
        }

        if (referral.getMaritalStatus() != null) {
            CodeableConcept maritalStatus = new CodeableConcept();
            Coding coding = new Coding();
            String[] statusParts = referral.getMaritalStatus().split(" \\| ");
            coding.setCode(statusParts[0]);
            coding.setDisplay(statusParts[1]);
            maritalStatus.addCoding(coding);
            patient.setMaritalStatus(maritalStatus);
        }


        Address address = new Address();
        address.setText(referral.getLocation());
        patient.setAddress(Collections.singletonList(address));

        return patient;
    }

    /**
     * Converts a ReferralDto object to a FHIR Composition resource.
     *
     * @param referral the referral data transfer object
     * @param serviceRequest the associated ServiceRequest resource
     * @return a FHIR Composition resource
     */
    public static Composition convertToComposition(ReferralDto referral, ServiceRequest serviceRequest) {
        Composition composition = new Composition();
        composition.setId(UUID.randomUUID().toString());

        composition.setStatus(Composition.CompositionStatus.FINAL);
        composition.setType(new CodeableConcept().addCoding(
                new Coding().setSystem("http://loinc.org").setCode("11488-4").setDisplay("Consult note")
        ));
        composition.setDate(new Date());

        Reference patientReference = new Reference("Patient/" + referral.getPatientId());
        composition.setSubject(patientReference);

        Reference authorReference = new Reference();
        authorReference.setDisplay(referral.getReferredBy());
        composition.setAuthor(Collections.singletonList(authorReference));

        Composition.SectionComponent section = new Composition.SectionComponent();
        section.setTitle("Referral Details");

        section.addEntry(new Reference("ServiceRequest/" + serviceRequest.getId()));

        composition.setSection(Collections.singletonList(section));

        return composition;
    }

    /**
     * Creates a FHIR Bundle resource for the given ReferralDto.
     *
     * @param referral the referral data transfer object
     * @return a FHIR Bundle resource
     */
    public static Bundle createBundle(ReferralDto referral) {
        Bundle bundle = new Bundle();
        bundle.setType(Bundle.BundleType.COLLECTION);

        ServiceRequest serviceRequest = convertToServiceRequest(referral);
        Patient patient = convertToPatient(referral);
        Composition composition = convertToComposition(referral, serviceRequest);

        Bundle.BundleEntryComponent compositionEntry = new Bundle.BundleEntryComponent();
        compositionEntry.setFullUrl("Composition/" + composition.getId());
        compositionEntry.setResource(composition);
        bundle.addEntry(compositionEntry);

        Bundle.BundleEntryComponent serviceRequestEntry = new Bundle.BundleEntryComponent();
        serviceRequestEntry.setFullUrl("ServiceRequest/" + serviceRequest.getId());
        serviceRequestEntry.setResource(serviceRequest);
        bundle.addEntry(serviceRequestEntry);

        Bundle.BundleEntryComponent patientEntry = new Bundle.BundleEntryComponent();
        patientEntry.setFullUrl("Patient/" + patient.getId());
        patientEntry.setResource(patient);
        bundle.addEntry(patientEntry);

        return bundle;
    }

    /**
     * Converts a list of ReferralDto objects to a list of FHIR Bundles.
     *
     * @param referrals the list of referral data transfer objects
     * @return a list of FHIR Bundles
     */
    public static List<Bundle> createBundles(List<ReferralDto> referrals) {
        List<Bundle> bundles = new ArrayList<>();

        for (ReferralDto referral : referrals) {
            Bundle bundle = createBundle(referral);
            bundles.add(bundle);
        }

        return bundles;
    }

}
