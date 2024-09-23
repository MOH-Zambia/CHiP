package com.argusoft.imtecho.fhir.mapper;

import com.argusoft.imtecho.fhs.dto.ClientMemberDto;
import com.argusoft.imtecho.fhs.dto.HouseholdDto;
import org.hl7.fhir.r4.model.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * FhirHouseHoldMapper is a mapper class for mapping HouseholdDto objects into FHIR resources.
 * It converts household and member details into FHIR Location, Group, Observation, and Composition resources,
 * and bundles them into a FHIR Bundle for interoperability in healthcare systems.
 */
public class FhirHouseHoldMapper {

    private FhirHouseHoldMapper(){

    }

    /**
     * Creates a Composition resource for the given HouseholdDto.
     *
     * @param householdDto the household data transfer object
     * @param location the FHIR Location resource
     * @param group the FHIR Group resource representing household members
     * @param observations the list of FHIR Observation resources
     * @return a FHIR Composition resource representing the household summary
     */
    private static Composition createComposition(HouseholdDto householdDto, Location location, Group group, List<Observation> observations) {
        Composition composition = new Composition();
        composition.setId(UUID.randomUUID().toString());
        composition.setStatus(Composition.CompositionStatus.FINAL);
        composition.setDate(new Date());
        composition.setType(new CodeableConcept().addCoding(new Coding().setSystem("http://loinc.org").setCode("10157-6").setDisplay("Family history")));

        if(!householdDto.getMembers().isEmpty()) {
            composition.setSubject(new Reference("Group/" + group.getId()));
        }
        composition.setTitle("Family Summary");

        Composition.SectionComponent section = composition.addSection();
        section.setTitle("Household Details");

        section.addEntry(new Reference("Location/" + location.getId()));

        for (Observation observation : observations) {
            section.addEntry(new Reference("Observation/" + observation.getId()));
        }

        return composition;
    }

    /**
     * Maps HouseholdDto to a FHIR Location resource.
     *
     * @param householdDto the household data transfer object
     * @return a FHIR Location resource
     */
    private static Location mapToLocation(HouseholdDto householdDto) {
        Location location = new Location();
        location.setId(UUID.randomUUID().toString());
        location.setAddress(new Address()
                .addLine(householdDto.getHouseNumber())
                .addLine(householdDto.getAddress1()));
        location.setPosition(new Location.LocationPositionComponent()
                .setLatitude(Double.valueOf(householdDto.getLatitude()))
                .setLongitude(Double.valueOf(householdDto.getLongitude())));
        return location;
    }

    /**
     * Maps HouseholdDto to a FHIR Group resource.
     *
     * @param householdDto the household data transfer object
     * @return a FHIR Group resource
     */
    private static Group mapToGroup(HouseholdDto householdDto) {
        Group group = new Group();
        group.setId(UUID.randomUUID().toString());
        group.setType(Group.GroupType.PERSON);
        group.setActual(true);

        for (ClientMemberDto memberDto : householdDto.getMembers()) {
            Group.GroupMemberComponent member = new Group.GroupMemberComponent();
            member.setEntity(new Reference("Patient/" + memberDto.getId()));
            group.addMember(member);
        }
        return group;
    }

    /**
     * Maps HouseholdDto to a list of FHIR Observation resources.
     *
     * @param householdDto the household data transfer object
     * @return a list of FHIR Observation resources
     */
    private static List<Observation> mapToObservations(HouseholdDto householdDto) {
        List<Observation> observations = new ArrayList<>();

        addObservationIfNotNull(observations, "outdoorCookingPractice", householdDto.getOutdoorCookingPractice());
        addObservationIfNotNull(observations, "typeOfToilet", householdDto.getTypeOfToilet());
        addObservationIfNotNull(observations, "drinkingWaterSource", householdDto.getDrinkingWaterSource());
        addObservationIfNotNull(observations, "handwashAvailable", householdDto.getHandwashAvailable());
        addObservationIfNotNull(observations, "otherWasteDisposal", householdDto.getOtherWasteDisposal());
        addObservationIfNotNull(observations, "storageMeetsStandard", householdDto.getStorageMeetsStandard());
        addObservationIfNotNull(observations, "waterSafetyMeetsStandard", householdDto.getWaterSafetyMeetsStandard());
        addObservationIfNotNull(observations, "dishrackAvailable", householdDto.getDishrackAvailable());
        addObservationIfNotNull(observations, "complaintOfInsects", householdDto.getComplaintOfInsects());
        addObservationIfNotNull(observations, "complaintOfRodents", householdDto.getComplaintOfRodents());
        addObservationIfNotNull(observations, "separateLivestockShelter", householdDto.getSeparateLivestockShelter());
        addObservationIfNotNull(observations, "noOfMosquitoNetsAvailable", householdDto.getNoOfMosquitoNetsAvailable());
        addObservationIfNotNull(observations, "isIecGiven", householdDto.getIsIecGiven());

        return observations;
    }

    /**
     * Adds an Observation resource to the list if the value is not null.
     *
     * @param observations the list of FHIR Observation resources
     * @param code the code for the Observation
     * @param value the value of the Observation
     */
    private static void addObservationIfNotNull(List<Observation> observations, String code, Object value) {
        if (value != null) {
            observations.add(createObservation(code, value));
        }
    }

    /**
     * Creates a FHIR Observation resource.
     *
     * @param code the code for the Observation
     * @param value the value of the Observation
     * @return a FHIR Observation resource
     */
    private static Observation createObservation(String code, Object value) {
        Observation observation = new Observation();
        observation.setId(UUID.randomUUID().toString());
        observation.getCode().setText(code);

        if (value instanceof Boolean) {
            observation.setValue(new BooleanType((Boolean) value));
        } else if (value instanceof String) {
            observation.setValue(new StringType((String) value));
        } else if (value instanceof Integer) {
            observation.setValue(new IntegerType((Integer) value));
        }
        return observation;
    }

    /**
     * Creates a FHIR Bundle resource for the given HouseholdDto.
     *
     * @param householdDto the household data transfer object
     * @return a FHIR Bundle resource
     */
    public static Bundle createBundle(HouseholdDto householdDto) {
        Bundle bundle = new Bundle();
        bundle.setType(Bundle.BundleType.DOCUMENT);

        Location location = mapToLocation(householdDto);
        Group group = mapToGroup(householdDto);

        List<Observation> observations = mapToObservations(householdDto);
        Composition composition = createComposition(householdDto, location, group, observations);
        bundle.addEntry(new Bundle.BundleEntryComponent().setFullUrl("Composition/" + composition.getId()).setResource(composition));


        bundle.addEntry(new Bundle.BundleEntryComponent().setFullUrl("Location/" + location.getId()).setResource(location));

        if(!householdDto.getMembers().isEmpty()) {
            bundle.addEntry(new Bundle.BundleEntryComponent().setFullUrl("Group/" + group.getId()).setResource(group));
        }

        for (Observation observation : observations) {
            bundle.addEntry(new Bundle.BundleEntryComponent().setFullUrl("Observation/" + observation.getId()).setResource(observation));
        }

        for (ClientMemberDto memberDto : householdDto.getMembers()) {
            Patient patient = FhirClientMapper.convertToPatient(memberDto);
            bundle.addEntry(new Bundle.BundleEntryComponent().setFullUrl("Patient/" + patient.getId()).setResource(patient));
        }

        return bundle;
    }

    /**
     * Converts a list of HouseholdDto objects to a list of FHIR Bundles.
     *
     * @param households the list of HouseholdDto objects to convert
     * @return a list of FHIR Bundles
     */
    public static List<Bundle> getBundles(List<HouseholdDto> households) {
        List<Bundle> bundles = new ArrayList<>();
        for (HouseholdDto householdDto : households) {
            Bundle bundle = createBundle(householdDto);
            bundles.add(bundle);
        }
        return bundles;
    }
}
