package com.argusoft.imtecho.fhir.mapper;

import com.argusoft.imtecho.fhir.util.FhirUtil;
import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import org.hl7.fhir.r4.model.*;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * Mapper class for mapping ClientMemberDto objects to FHIR Patient and related resources.
 * This class provides methods to convert ClientMemberDto data into FHIR-compliant formats,
 * including Patients, Observations, and Compositions.
 */

public class FhirClientMapper {

    private FhirClientMapper(){

    }

    static String IP = FhirUtil.getUri();

    /**
     * Converts a ClientMemberDto object into a FHIR Patient resource.
     *
     * @param memberDto the ClientMemberDto object to convert
     * @return a FHIR Patient resource
     */
    public static Patient convertToPatient(ClientMemberDto memberDto) {
        Patient patient = new Patient();

        patient.setId(memberDto.getId().toString());

        patient.addIdentifier()
                .setSystem(IP)
                .setValue(memberDto.getUniqueHealthId());

        HumanName name = patient.addName();
        name.setFamily(memberDto.getLastName());
        name.addGiven(memberDto.getFirstName());
        if (memberDto.getMiddleName() != null) {
            name.addGiven(memberDto.getMiddleName());
        }

        patient.setGender(memberDto.getGender().equalsIgnoreCase("M") ? Enumerations.AdministrativeGender.MALE : Enumerations.AdministrativeGender.FEMALE);

        patient.setBirthDate(memberDto.getDob());

        if (memberDto.getMaritalStatus() != null) {
            String maritalStatusDisplay = switch (memberDto.getMaritalStatus().toLowerCase()) {
                case "single" -> "never married";
                case "widow", "widower", "widowed" -> "widowed";
                default -> "";
            };

            String maritalStatusCode = switch (memberDto.getMaritalStatus().toLowerCase()) {
                case "annulled" -> "A";
                case "divorced" -> "D";
                case "interlocutory" -> "I";
                case "legally separated" -> "L";
                case "married" -> "M";
                case "polygamous" -> "P";
                case "never married", "single" -> "S";
                case "domestic partner" -> "T";
                case "unmarried" -> "U";
                case "widowed" -> "W";
                default -> "UNK";
            };

            CodeableConcept maritalStatus = new CodeableConcept();
            maritalStatus.addCoding()
                    .setSystem("http://terminology.hl7.org/CodeSystem/v3-MaritalStatus")
                    .setCode(maritalStatusCode)
                    .setDisplay(maritalStatusDisplay);
            patient.setMaritalStatus(maritalStatus);
        }

        if (memberDto.getMobileNumber() != null && !memberDto.getMobileNumber().isEmpty()) {
            ContactPoint contactPoint = patient.addTelecom();
            contactPoint.setSystem(ContactPoint.ContactPointSystem.PHONE)
                    .setValue(memberDto.getMobileNumber());
        }



        return patient;
    }

    /**
     * Creates a FHIR Composition resource to encapsulate a patient's health summary.
     *
     * @param patient                   the Patient resource
     * @param vitalSignsObservations    a list of vital signs observations
     * @param womensHealthObservations  a list of women's health observations
     * @param lifestyleObservations     a list of lifestyle observations
     * @param wellnessObservations      a list of wellness observations
     * @return a FHIR Composition resource
     */
    private static Composition createComposition(Patient patient, List<Observation> vitalSignsObservations, List<Observation> womensHealthObservations, List<Observation> lifestyleObservations, List<Observation> wellnessObservations) {
        Composition composition = new Composition();
        composition.setId(UUID.randomUUID().toString());
        composition.setStatus(Composition.CompositionStatus.FINAL);
        composition.setType(new CodeableConcept().addCoding(new Coding()
                .setSystem("http://loinc.org")
                .setCode("60591-5")
                .setDisplay("Patient Summary")));
        composition.setSubject(new Reference("Patient/" + patient.getIdElement().getIdPart()));

        // Add sections to the Composition
        addSection(composition, "Vital Signs", vitalSignsObservations);
        addSection(composition, "Women's Health", womensHealthObservations);
        addSection(composition, "Lifestyle", lifestyleObservations);
        addSection(composition, "Others", wellnessObservations);

        return composition;
    }

    /**
     * Adds a section to a FHIR Composition resource.
     *
     * @param composition the Composition resource
     * @param title       the title of the section
     * @param observations a list of observations to include in the section
     */
    private static void addSection(Composition composition, String title, List<Observation> observations) {
        if (!observations.isEmpty()) {
            Composition.SectionComponent section = composition.addSection();
            section.setTitle(title);
            for (Observation observation : observations) {
                section.addEntry(new Reference(observation.getResourceType().name() + "/" + observation.getIdElement().getIdPart()));
            }
        }
    }

    /**
     * Creates a list of vital signs observations from a ClientMemberDto object.
     *
     * @param memberDto the ClientMemberDto object
     * @return a list of FHIR Observation resources
     */
    private static List<Observation> createVitalSignsObservations(ClientMemberDto memberDto) {
        List<Observation> observations = new ArrayList<>();

        if (memberDto.getHaemoglobin() != null) {
            Observation haemoglobinObservation = new Observation();
            haemoglobinObservation.setId(UUID.randomUUID().toString());
            haemoglobinObservation.setStatus(Observation.ObservationStatus.FINAL);
            haemoglobinObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("718-7")
                    .setDisplay("Haemoglobin")));
            haemoglobinObservation.setValue(new Quantity()
                    .setValue(memberDto.getHaemoglobin())
                    .setUnit("g/dL"));
            observations.add(haemoglobinObservation);
        }

        if (memberDto.getWeight() != null) {
            Observation weightObservation = new Observation();
            weightObservation.setId(UUID.randomUUID().toString());
            weightObservation.setStatus(Observation.ObservationStatus.FINAL);

            CodeableConcept category = new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://terminology.hl7.org/CodeSystem/observation-category")
                    .setCode("vital-signs")
                    .setDisplay("Vital Signs"));
            weightObservation.setCategory(Collections.singletonList(category));

            weightObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("29463-7")
                    .setDisplay("Body Weight")));

            weightObservation.setValue(new Quantity()
                    .setValue(memberDto.getWeight())
                    .setUnit("kg")
                    .setSystem("http://unitsofmeasure.org")
                    .setCode("kg"));

            observations.add(weightObservation);
        }


        if (memberDto.getBloodGroup() != null) {
            Observation bloodGroupObservation = new Observation();
            bloodGroupObservation.setId(UUID.randomUUID().toString());
            bloodGroupObservation.setStatus(Observation.ObservationStatus.FINAL);
            bloodGroupObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("883-9")
                    .setDisplay("Blood Group")));
            bloodGroupObservation.setValue(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://terminology.hl7.org/CodeSystem/v2-0201")
                    .setCode(memberDto.getBloodGroup())));
            observations.add(bloodGroupObservation);
        }


        return observations;
    }

    /**
     * Creates a list of women's health observations from a ClientMemberDto object.
     *
     * @param memberDto the ClientMemberDto object
     * @return a list of FHIR Observation resources
     */
    private static List<Observation> createWomensHealthObservations(ClientMemberDto memberDto) {
        List<Observation> observations = new ArrayList<>();

        if (memberDto.getLmpDate() != null) {
            Observation lmpObservation = new Observation();
            lmpObservation.setId(UUID.randomUUID().toString());
            lmpObservation.setStatus(Observation.ObservationStatus.FINAL);
            lmpObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("8665-2")
                    .setDisplay("Last menstrual period start date")));
            lmpObservation.setEffective(new DateTimeType(memberDto.getLmpDate()));
            observations.add(lmpObservation);
        }

        if (memberDto.getEdd() != null) {
            Observation eddObservation = new Observation();
            eddObservation.setId(UUID.randomUUID().toString());
            eddObservation.setStatus(Observation.ObservationStatus.FINAL);
            eddObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("11778-8")
                    .setDisplay("Expected date of delivery")));
            eddObservation.setEffective(new DateTimeType(memberDto.getEdd()));
            observations.add(eddObservation);
        }

        if (memberDto.getIsPregnantFlag() != null) {
            Observation pregnancyObservation = new Observation();
            pregnancyObservation.setId(UUID.randomUUID().toString());
            pregnancyObservation.setStatus(Observation.ObservationStatus.FINAL);
            pregnancyObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("82810-3")
                    .setDisplay("Pregnancy status")));
            pregnancyObservation.setValue(new BooleanType(memberDto.getIsPregnantFlag()));
            observations.add(pregnancyObservation);
        }

        if (memberDto.getMenopauseArrived() != null) {
            Observation menopauseObservation = new Observation();
            menopauseObservation.setId(UUID.randomUUID().toString());
            menopauseObservation.setStatus(Observation.ObservationStatus.FINAL);
            menopauseObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("8251-1")
                    .setDisplay("Menopause status")));
            menopauseObservation.setValue(new BooleanType(memberDto.getMenopauseArrived()));
            observations.add(menopauseObservation);
        }


        return observations;
    }

    /**
     * Creates a list of lifestyle observations from a ClientMemberDto object.
     *
     * @param memberDto the ClientMemberDto object
     * @return a list of FHIR Observation resources
     */
    private static List<Observation> createLifestyleObservations(ClientMemberDto memberDto) {
        List<Observation> observations = new ArrayList<>();

        if (memberDto.getMemberReligion() != null) {
            Observation religionObservation = new Observation();
            religionObservation.setId(UUID.randomUUID().toString());
            religionObservation.setStatus(Observation.ObservationStatus.FINAL);
            religionObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setCode("REL")
                    .setDisplay("Religion")));
            religionObservation.setValue(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://hl7.org/fhir/v3/ReligiousAffiliation")
                    .setCode(memberDto.getMemberReligion())));
            observations.add(religionObservation);
        }

        if (memberDto.getImmunisationGiven() != null) {
            Observation immunisationObservation = new Observation();
            immunisationObservation.setId(UUID.randomUUID().toString());
            immunisationObservation.setStatus(Observation.ObservationStatus.FINAL);
            immunisationObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("30956-7")
                    .setDisplay("Immunisation given")));
            immunisationObservation.setValue(new StringType(memberDto.getImmunisationGiven()));
            observations.add(immunisationObservation);
        }

        if (memberDto.getLastMethodOfContraception() != null) {
            Observation contraceptionObservation = new Observation();
            contraceptionObservation.setId(UUID.randomUUID().toString());
            contraceptionObservation.setStatus(Observation.ObservationStatus.FINAL);
            contraceptionObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("8251-1")
                    .setDisplay("Last method of contraception")));
            contraceptionObservation.setValue(new StringType(memberDto.getLastMethodOfContraception()));
            observations.add(contraceptionObservation);
        }


        return observations;
    }

    /**
     * Creates a list of wellness observations from a ClientMemberDto object.
     *
     * @param memberDto the ClientMemberDto object
     * @return a list of FHIR Observation resources
     */
    private static List<Observation> createWellnessObservations(ClientMemberDto memberDto) {
        List<Observation> observations = new ArrayList<>();

        if (memberDto.getCongenitalAnomaly() != null) {
            Observation congenitalAnomalyObservation = new Observation();
            congenitalAnomalyObservation.setId(UUID.randomUUID().toString());
            congenitalAnomalyObservation.setStatus(Observation.ObservationStatus.FINAL);
            congenitalAnomalyObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("CONGENITAL")
                    .setDisplay("Congenital anomaly")));
            congenitalAnomalyObservation.setValue(new StringType(memberDto.getCongenitalAnomaly()));
            observations.add(congenitalAnomalyObservation);
        }

        if (memberDto.getChronicDisease() != null) {
            Observation chronicDiseaseObservation = new Observation();
            chronicDiseaseObservation.setId(UUID.randomUUID().toString());
            chronicDiseaseObservation.setStatus(Observation.ObservationStatus.FINAL);
            chronicDiseaseObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("CHRONIC")
                    .setDisplay("Chronic disease")));
            chronicDiseaseObservation.setValue(new StringType(memberDto.getChronicDisease()));
            observations.add(chronicDiseaseObservation);
        }

        if (memberDto.getCurrentDisease() != null) {
            Observation currentDiseaseObservation = new Observation();
            currentDiseaseObservation.setId(UUID.randomUUID().toString());
            currentDiseaseObservation.setStatus(Observation.ObservationStatus.FINAL);
            currentDiseaseObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("CURRENT")
                    .setDisplay("Current disease")));
            currentDiseaseObservation.setValue(new StringType(memberDto.getCurrentDisease()));
            observations.add(currentDiseaseObservation);
        }

        if (memberDto.getHysterectomyDone() != null) {
            Observation hysterectomyObservation = new Observation();
            hysterectomyObservation.setId(UUID.randomUUID().toString());
            hysterectomyObservation.setStatus(Observation.ObservationStatus.FINAL);
            hysterectomyObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("8251-1")
                    .setDisplay("Hysterectomy status")));
            hysterectomyObservation.setValue(new BooleanType(memberDto.getHysterectomyDone()));
            observations.add(hysterectomyObservation);
        }

        if (memberDto.getPhysicalDisability() != null) {
            Observation physicalDisabilityObservation = new Observation();
            physicalDisabilityObservation.setId(UUID.randomUUID().toString());
            physicalDisabilityObservation.setStatus(Observation.ObservationStatus.FINAL);
            physicalDisabilityObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("PHYSICAL")
                    .setDisplay("Physical disability")));
            physicalDisabilityObservation.setValue(new StringType(memberDto.getPhysicalDisability()));
            observations.add(physicalDisabilityObservation);
        }

        if (memberDto.getOtherDisability() != null) {
            Observation otherDisabilityObservation = new Observation();
            otherDisabilityObservation.setId(UUID.randomUUID().toString());
            otherDisabilityObservation.setStatus(Observation.ObservationStatus.FINAL);
            otherDisabilityObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("OTHER")
                    .setDisplay("Other disability")));
            otherDisabilityObservation.setValue(new StringType(memberDto.getOtherDisability()));
            observations.add(otherDisabilityObservation);
        }

        if (memberDto.getChronicDiseaseTreatment() != null) {
            Observation chronicDiseaseTreatmentObservation = new Observation();
            chronicDiseaseTreatmentObservation.setId(UUID.randomUUID().toString());
            chronicDiseaseTreatmentObservation.setStatus(Observation.ObservationStatus.FINAL);
            chronicDiseaseTreatmentObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("TREATMENT")
                    .setDisplay("Chronic disease treatment")));
            chronicDiseaseTreatmentObservation.setValue(new StringType(memberDto.getChronicDiseaseTreatment()));
            observations.add(chronicDiseaseTreatmentObservation);
        }

        if (memberDto.getOtherChronicDiseaseTreatment() != null) {
            Observation otherChronicDiseaseTreatmentObservation = new Observation();
            otherChronicDiseaseTreatmentObservation.setId(UUID.randomUUID().toString());
            otherChronicDiseaseTreatmentObservation.setStatus(Observation.ObservationStatus.FINAL);
            otherChronicDiseaseTreatmentObservation.setCode(new CodeableConcept().addCoding(new Coding()
                    .setSystem("http://loinc.org")
                    .setCode("TREATMENT")
                    .setDisplay("Other chronic disease treatment")));
            otherChronicDiseaseTreatmentObservation.setValue(new StringType(memberDto.getOtherChronicDiseaseTreatment()));
            observations.add(otherChronicDiseaseTreatmentObservation);
        }
        return observations;
    }

    /**
     * Adds a list of Observation resources to a FHIR Bundle.
     *
     * @param bundle       the FHIR Bundle
     * @param observations a list of Observation resources to add
     */
    private static void addObservationsToBundle(Bundle bundle, List<Observation> observations) {
        for (Observation observation : observations) {
            bundle.addEntry(new Bundle.BundleEntryComponent()
                    .setFullUrl("Observation/" + observation.getIdElement().getIdPart())
                    .setResource(observation));
        }
    }

    /**
     * Maps a ClientMemberDto object to a FHIR Bundle containing Patient, Composition, and Observation resources.
     *
     * @param memberDto the ClientMemberDto object
     * @return a FHIR Bundle containing the mapped resources
     */
    public static Bundle createBundle(ClientMemberDto memberDto) {
        Bundle bundle = new Bundle();
        bundle.setType(Bundle.BundleType.COLLECTION);

        Patient patient = convertToPatient(memberDto);


        List<Observation> vitalSignsObservations = createVitalSignsObservations(memberDto);
        List<Observation> womensHealthObservations = createWomensHealthObservations(memberDto);
        List<Observation> lifestyleObservations = createLifestyleObservations(memberDto);
        List<Observation> wellnessObservations = createWellnessObservations(memberDto);

        Composition composition = createComposition(patient, vitalSignsObservations, womensHealthObservations, lifestyleObservations, wellnessObservations);

        bundle.addEntry(new Bundle.BundleEntryComponent()
                .setFullUrl("Composition/" + composition.getIdElement().getIdPart())
                .setResource(composition));

        bundle.addEntry(new Bundle.BundleEntryComponent()
                .setFullUrl("Patient/" + patient.getIdElement().getIdPart())
                .setResource(patient));

        addObservationsToBundle(bundle, vitalSignsObservations);
        addObservationsToBundle(bundle, womensHealthObservations);
        addObservationsToBundle(bundle, lifestyleObservations);
        addObservationsToBundle(bundle, wellnessObservations);

        return bundle;
    }

    /**
     * Converts a list of ClientMemberDto objects to a list of FHIR Bundles.
     *
     * @param members the list of ClientMemberDto objects to convert
     * @return a list of FHIR Bundles, each containing resources for a single ClientMemberDto
     */
    public static List<Bundle> getPatientBundles(List<ClientMemberDto> members) {
        List<Bundle> bundles = new ArrayList<>();
        for (ClientMemberDto memberDto : members) {
            Bundle bundle = createBundle(memberDto);
            bundles.add(bundle);
        }
        return bundles;
    }

}
