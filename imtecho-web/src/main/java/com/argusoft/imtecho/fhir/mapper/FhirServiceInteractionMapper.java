package com.argusoft.imtecho.fhir.mapper;

import com.argusoft.imtecho.fhs.dto.*;
import org.hl7.fhir.r4.model.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * Mapper class for mapping interaction data to FHIR resources.
 * This class provides methods to create FHIR Bundles from various types of interaction data,
 * including Malaria, Tuberculosis, COVID, HIV, ANC, Child Services, PNC, and WPD details.
 */
public class FhirServiceInteractionMapper {

    private FhirServiceInteractionMapper(){

    }

    /**
     * Creates a FHIR Composition resource from the given InteractionDto.
     * @param interaction The InteractionDto containing the interaction data.
     * @return A Composition resource with details from the InteractionDto.
     */
    private static Composition createComposition(InteractionDto interaction) {
        Composition composition = new Composition();
        composition.setId(UUID.randomUUID().toString());
        composition.setStatus(Composition.CompositionStatus.FINAL);
        composition.setType(new CodeableConcept().addCoding(new Coding().setSystem("http://loinc.org").setCode("34133-9").setDisplay("Summary of episode note")));
        composition.setSubject(new Reference("Patient/" + interaction.getMemberId()));
        composition.setDate(new Date());
        composition.setTitle("Service Interaction Summary");

        return composition;
    }

    /**
     * Creates a list of FHIR Observation resources for malaria details.
     * @param malariaDto The MalariaDto containing malaria-related details.
     * @return A list of Observations related to malaria.
     */
    private static List<Observation> createMalariaObservations(MalariaDto malariaDto) {
        List<Observation> observations = new ArrayList<>();

        if (malariaDto.getActiveMalariaSymptoms() != null) {
            observations.add(createObservation("70569-9", "Plasmodium sp Ag [Identifier] in Blood by Rapid immunoassay", new StringType(malariaDto.getActiveMalariaSymptoms())));
        }
        if (malariaDto.getRdtTestStatus() != null) {
            observations.add(createObservation("30954-2", "Relevant diagnostic tests/laboratory data Narrative", new StringType(malariaDto.getRdtTestStatus())));
        }
        if (malariaDto.getIsTreatmentGiven() != null) {
            observations.add(createObservation("18776-5", "Plan of care note", new BooleanType(malariaDto.getIsTreatmentGiven())));
        }
        if (malariaDto.getMalariaType() != null) {
            observations.add(createObservation("LL2041-3", "Malaria", new StringType(malariaDto.getMalariaType())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for tuberculosis details.
     * @param tbDto The TuberculosisDto containing tuberculosis-related details.
     * @return A list of Observations related to tuberculosis.
     */
    private static List<Observation> createTbObservations(TuberculosisDto tbDto) {
        List<Observation> observations = new ArrayList<>();

        if (tbDto.getTbSymptoms() != null) {
            observations.add(createObservation("45241-7", "Tuberculosis status", new StringType(tbDto.getTbSymptoms())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for COVID-19 details.
     * @param covidDto The CovidDto containing COVID-19-related details.
     * @return A list of Observations related to COVID-19.
     */
    private static List<Observation> createCovidObservations(CovidDto covidDto) {
        List<Observation> observations = new ArrayList<>();

        if (covidDto.getIsDoseOneTaken() != null) {
            observations.add(createObservation("97073-1", "Received COVID-19 vaccine", new BooleanType(covidDto.getIsDoseOneTaken())));
        }
        if (covidDto.getDoseOneName() != null) {
            observations.add(createObservation("97155-6", "SARS coronavirus 2 (COVID-19) immunization status", new StringType(covidDto.getDoseOneName())));
        }
        if (covidDto.getIsDoseTwoTaken() != null) {
            observations.add(createObservation("97073-1", "Received COVID-19 vaccine", new BooleanType(covidDto.getIsDoseTwoTaken())));
        }
        if (covidDto.getDoseTwoName() != null) {
            observations.add(createObservation("97155-6", "SARS coronavirus 2 (COVID-19) immunization status", new StringType(covidDto.getDoseTwoName())));
        }
        if (covidDto.getIsBoosterDoseGiven() != null) {
            observations.add(createObservation("97073-1", "Received COVID-19 vaccine", new BooleanType(covidDto.getIsBoosterDoseGiven())));
        }
        if (covidDto.getBoosterName() != null) {
            observations.add(createObservation("97155-6", "SARS coronavirus 2 (COVID-19) immunization status", new StringType(covidDto.getBoosterName())));
        }
        if (covidDto.getAnyReactions() != null) {
            observations.add(createObservation("55140-8", "Vaccine Adverse Event Reporting System (VAERS) panel", new BooleanType(covidDto.getAnyReactions())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for antenatal care details.
     * @param ancDto The AncDto containing antenatal care-related details.
     * @return A list of Observations related to antenatal care.
     */
    private static List<Observation> createAncObservations(AncDto ancDto) {
        List<Observation> observations = new ArrayList<>();

        if (ancDto.getLmp() != null) {
            observations.add(createObservation("8665-2", "Last menstrual period start date", new DateTimeType(ancDto.getLmp())));
        }
        if (ancDto.getSystolicBp() != null) {
            observations.add(createObservation("8480-6", "Systolic blood pressure", new IntegerType(ancDto.getSystolicBp())));
        }
        if (ancDto.getDiastolicBp() != null) {
            observations.add(createObservation("8462-4", "Diastolic blood pressure", new IntegerType(ancDto.getDiastolicBp())));
        }
        if (ancDto.getFoetalMovement() != null) {
            observations.add(createObservation("11631-9", "Fetal Biophysical profile.body movement US", new StringType(ancDto.getFoetalMovement())));
        }
        if (ancDto.getFoetalHeartSound() != null) {
            observations.add(createObservation("11948-7", "Fetal Heart rate US", new BooleanType(ancDto.getFoetalHeartSound())));
        }
        if (ancDto.getHbsagTest() != null) {
            observations.add(createObservation("63557-3", "Hepatitis B virus surface Ag [Units/volume] in Serum or Plasma by Immunoassay", new StringType(ancDto.getHbsagTest())));
        }
        if (ancDto.getBloodSugarTest() != null) {
            observations.add(createObservation("76629-5", "Fasting glucose [Moles/volume] in Blood", new StringType(ancDto.getBloodSugarTest())));
        }
        if (ancDto.getSugarTestAfterFoodValue() != null) {
            observations.add(createObservation("95102-0", "Glucose post fasting and meal stimulation panel - Serum or Plasma", new IntegerType(ancDto.getSugarTestAfterFoodValue())));
        }
        if (ancDto.getSugarTestBeforeFoodValue() != null) {
            observations.add(createObservation("1556-0", "Fasting glucose [Mass/volume] in Capillary blood", new IntegerType(ancDto.getSugarTestBeforeFoodValue())));
        }
        if (ancDto.getUrineAlbumin() != null) {
            observations.add(createObservation("1754-1", "Albumin [Mass/volume] in Urine", new StringType(ancDto.getUrineAlbumin())));
        }
        if (ancDto.getUrineSugar() != null) {
            observations.add(createObservation("2350-7", "Glucose [Mass/volume] in Urine", new StringType(ancDto.getUrineSugar())));
        }
        if (ancDto.getVdrlTest() != null) {
            observations.add(createObservation("5292-8", "Reagin Ab [Presence] in Serum by VDRL", new StringType(ancDto.getVdrlTest())));
        }
        if (ancDto.getSickleCellTest() != null) {
            observations.add(createObservation("801-1", "Sickle cells [Presence] in Blood by Light microscopy", new StringType(ancDto.getSickleCellTest())));
        }
        if (ancDto.getHivTest() != null) {
            observations.add(createObservation("68961-2", "HIV 1 Ab [Presence] in Serum, Plasma or Blood by Rapid immunoassay", new StringType(ancDto.getHivTest())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for child service details.
     * @param childDto The ChildServiceDto containing child service-related details.
     * @return A list of Observations related to child services.
     */
    private static List<Observation> createChildServiceObservations(ChildServiceDto childDto) {
        List<Observation> observations = new ArrayList<>();

        if (childDto.getIsAlive() != null) {
            observations.add(createObservation("LA4247-8", "Alive", new BooleanType(childDto.getIsAlive())));
        }
        if (childDto.getComplementaryFeedingStartPeriod() != null) {
            observations.add(createObservation("67704-7", "Feeding types", new StringType(childDto.getComplementaryFeedingStartPeriod())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for Postnatal Care (PNC) child details.
     * @param pncChildDto The PncChildDetailsDto containing postnatal care child-related details.
     * @return A list of Observations related to PNC child details.
     */
    private static List<Observation> createPncChildObservations(PncChildDetailsDto pncChildDto) {
        List<Observation> observations = new ArrayList<>();

        if (pncChildDto.getChildWeight() != null) {
            observations.add(createObservation("3141-9", "Body weight Measured", new DecimalType(pncChildDto.getChildWeight())));
        }
        if (pncChildDto.getIsAlive() != null) {
            observations.add(createObservation("LA4247-8", "Alive", new BooleanType(pncChildDto.getIsAlive())));
        }
        if (pncChildDto.getDeathDate() != null) {
            observations.add(createObservation("31211-6", "Date of death", new DateType(pncChildDto.getDeathDate())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for Postnatal Care (PNC) mother details.
     * @param pncMotherDto The PncMotherDetailsDto containing postnatal care mother-related details.
     * @return A list of Observations related to PNC mother details.
     */
    private static List<Observation> createPncMotherObservations(PncMotherDetailsDto pncMotherDto) {
        List<Observation> observations = new ArrayList<>();

        if (pncMotherDto.getDateOfDelivery() != null) {
            observations.add(createObservation("11778-8", "Delivery date Estimated", new DateTimeType(pncMotherDto.getDateOfDelivery())));
        }
        if (pncMotherDto.getIronDefAnemiaInj() != null) {
            observations.add(createObservation("2498-4", "Iron [Mass/volume] in Serum or Plasma", new BooleanType(pncMotherDto.getIronDefAnemiaInj())));
        }
        if (pncMotherDto.getCheckForBreastfeeding() != null) {
            observations.add(createObservation("LL5057-6", "Currently breastfeeding | Not currenlty breastfeed", new BooleanType(pncMotherDto.getCheckForBreastfeeding())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for Women Post Delivery (WPD) mother details.
     * @param wpdMotherDto The WpdMotherDetailsDto containing post-delivery mother-related details.
     * @return A list of Observations related to WPD mother details.
     */
    private static List<Observation> createWpdMotherObservations(WpdMotherDetailsDto wpdMotherDto) {
        List<Observation> observations = new ArrayList<>();

        if (wpdMotherDto.getDateOfDelivery() != null) {
            observations.add(createObservation("11778-8", "Delivery date Estimated", new DateTimeType(wpdMotherDto.getDateOfDelivery())));
        }
        if (wpdMotherDto.getIsHighRiskCase() != null) {
            observations.add(createObservation("LA19541-4", "High risk", new BooleanType(wpdMotherDto.getIsHighRiskCase())));
        }
        if (wpdMotherDto.getDischargeDate() != null) {
            observations.add(createObservation("52525-3 ", "Discharge date", new DateTimeType(wpdMotherDto.getDischargeDate())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for Women Post Delivery (WPD) child details.
     * @param wpdChildDetailsDto The WpdChildDetailsDto containing post-delivery child-related details.
     * @return A list of Observations related to WPD child details.
     */
    private static List<Observation> createWpdChildObservations(WpdChildDetailsDto wpdChildDetailsDto) {
        List<Observation> observations = new ArrayList<>();

        if (wpdChildDetailsDto.getTypeOfDelivery() != null) {
            observations.add(createObservation("73762-7", "Final route and method of delivery [US Standard Certificate of Live Birth]", new StringType(wpdChildDetailsDto.getTypeOfDelivery())));
        }
        if (wpdChildDetailsDto.getBreastfeedingInHealthCenter() != null) {
            observations.add(createObservation("LL5057-6", "Currently breastfeeding | Not currenlty breastfeed", new BooleanType(wpdChildDetailsDto.getBreastfeedingInHealthCenter())));
        }
        if (wpdChildDetailsDto.getBabyBreatheAtBirth() != null) {
            observations.add(createObservation("57075-4", "Newborn delivery information", new BooleanType(wpdChildDetailsDto.getBabyBreatheAtBirth())));
        }

        return observations;
    }

    /**
     * Creates a list of FHIR Observation resources for HIV-related details.
     * @param hivDto The HivDto containing HIV-related details.
     * @return A list of Observations related to HIV.
     */
    private static List<Observation> createHivObservations(HivDto hivDto) {
        List<Observation> observations = new ArrayList<>();
        observations.add(createObservation("75622-1", "HIV 1 and 2 tests", new BooleanType(hivDto.isChildHivTest())));
        observations.add(createObservation("29893-5", "HIV 1 Ab [Presence] in Serum or Plasma by Immunoassay", new BooleanType(hivDto.isHivTestResult())));
        observations.add(createObservation("75325-1", "Symptom", new BooleanType(hivDto.isSymptoms())));
        observations.add(createObservation("47244-9", "Symptom, diagnosis, or opportunistic infection related to HIV treatment", new BooleanType(hivDto.isPrivatePartsSymptoms())));
        observations.add(createObservation("LL5057-6", "Currently breastfeeding | Not currenlty breastfeed", new BooleanType(hivDto.isPregnantOrBreastfeeding())));

        return observations;
    }

    /**
     * Creates a FHIR Observation resource.
     * @param code The LOINC code for the observation.
     * @param display The display name for the observation.
     * @param value The value of the observation.
     * @return An Observation resource.
     */
    private static Observation createObservation(String code, String display, Type value) {
        Observation observation = new Observation();
        observation.setId(UUID.randomUUID().toString());
        observation.setStatus(Observation.ObservationStatus.FINAL);
        observation.setCode(new CodeableConcept().addCoding(new Coding().setSystem("http://loinc.org").setCode(code).setDisplay(display)));
        observation.setValue(value);
        return observation;
    }

    /**
     * Adds a section to a FHIR Composition resource.
     * @param composition The Composition resource to which the section will be added.
     * @param title The title of the section.
     * @param observations The list of Observations to include in the section.
     */
    private static void addSection(Composition composition, String title, List<Observation> observations) {
        Composition.SectionComponent section = new Composition.SectionComponent();
        section.setTitle(title);
        for (Observation observation : observations) {
            section.addEntry(new Reference("Observation/" + observation.getId()));
        }
        composition.addSection(section);
    }

    /**
     * Creates a FHIR Bundle containing various types of Observations and a Composition resource based on the provided InteractionDto.
     * @param interaction The InteractionDto containing details to be included in the Bundle.
     * @return A FHIR Bundle containing the Composition, Patient, and Observation resources.
     */
    public static Bundle createBundle(InteractionDto interaction) {
        Bundle bundle = new Bundle();
        bundle.setType(Bundle.BundleType.DOCUMENT);

        Composition composition = createComposition(interaction);
        bundle.addEntry().setResource(composition).setFullUrl("Composition/" + composition.getId());

        Patient patient = new Patient();
        patient.setId(String.valueOf(interaction.getMemberId()));
        bundle.addEntry().setResource(patient).setFullUrl("Patient/" + patient.getId());

        for (MalariaDto malariaDto : interaction.getMalariaDetails()) {
            List<Observation> malariaObservations = createMalariaObservations(malariaDto);
            for (Observation observation : malariaObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "Malaria Observations", malariaObservations);
        }

        for (TuberculosisDto tbDto : interaction.getTbDetails()) {
            List<Observation> tbObservations = createTbObservations(tbDto);
            for (Observation observation : tbObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "TB Observations", tbObservations);
        }

        for (CovidDto covidDto : interaction.getCovidDetails()) {
            List<Observation> covidObservations = createCovidObservations(covidDto);
            for (Observation observation : covidObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "COVID Observations", covidObservations);
        }

        for (HivDto hivDto : interaction.getHivDetails()) {
            List<Observation> hivObservations = createHivObservations(hivDto);
            for (Observation observation : hivObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "HIV Observations", hivObservations);
        }

        for (AncDto ancDto : interaction.getAncDetails()) {
            List<Observation> ancObservations = createAncObservations(ancDto);
            for (Observation observation : ancObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "ANC Observations", ancObservations);
        }

        for (ChildServiceDto childServiceDto : interaction.getChildServiceDetails()) {
            List<Observation> childServiceObservations = createChildServiceObservations(childServiceDto);
            for (Observation observation : childServiceObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "Child Service Observations", childServiceObservations);
        }

        for (PncChildDetailsDto pncChildDetailsDto : interaction.getPncChildDetails()) {
            List<Observation> pncChildObservations = createPncChildObservations(pncChildDetailsDto);
            for (Observation observation : pncChildObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "PNC Child Observations", pncChildObservations);
        }

        for (PncMotherDetailsDto pncMotherDetailsDto : interaction.getPncMotherDetails()) {
            List<Observation> pncMotherObservations = createPncMotherObservations(pncMotherDetailsDto);
            for (Observation observation : pncMotherObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "PNC Mother Observations", pncMotherObservations);
        }

        for (WpdMotherDetailsDto wpdMotherDetailsDto : interaction.getWpdMotherDetails()) {
            List<Observation> wpdMotherObservations = createWpdMotherObservations(wpdMotherDetailsDto);
            for (Observation observation : wpdMotherObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "WPD Mother Observations", wpdMotherObservations);
        }

        for (WpdChildDetailsDto wpdChildDetailsDto : interaction.getWpdChildDetails()) {
            List<Observation> wpdChildObservations = createWpdChildObservations(wpdChildDetailsDto);
            for (Observation observation : wpdChildObservations) {
                bundle.addEntry().setFullUrl("Observation/" + observation.getId()).setResource(observation);
            }
            addSection(composition, "WPD Child Observations", wpdChildObservations);
        }

        return bundle;
    }

    /**
     * Creates a list of FHIR Bundles for multiple InteractionDto objects.
     * @param interactions The list of InteractionDto objects to create Bundles from.
     * @return A list of FHIR Bundles, each containing resources from an InteractionDto.
     */
    public static List<Bundle> getBundles(List<InteractionDto> interactions) {
        List<Bundle> bundles = new ArrayList<>();
        for (InteractionDto interactionDto : interactions) {
            Bundle bundle = createBundle(interactionDto);
            bundles.add(bundle);
        }
        return bundles;
    }
}
