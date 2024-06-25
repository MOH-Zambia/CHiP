package com.argusoft.sewa.android.app.core;

import com.argusoft.sewa.android.app.datastructure.QueFormBean;

import java.util.Date;
import java.util.Map;
import java.util.Set;

public interface ImmunisationService {

    Set<String> getDueImmunisationsForChild(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses);
    Set<String> getDueImmunisationsForChildDnhdd(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses);
    Set<String> getDueImmunisationsForChildZambia(Date dateOfBirth, String givenImmunisations, Date currentDate, Map<String, Date> immunisationDateMap, boolean isRemovePreviousDoses);
    String vaccinationValidationForChild(Date dob, Date givenDate, String currentVaccine, Map<String, Date> vaccineGivenDateMap);
    String vaccinationValidationForChildZambia(Date dob, Date givenDate, String currentVaccine, Map<String, Date> vaccineGivenDateMap, QueFormBean queFormBean);

    Map<Boolean, String> isImmunisationMissedOrNotValid(Date dateOfBirth, String immunisation, Date currentDate, Map<String, Date> vaccineGivenDateMap, boolean isForNextDueDate);
    Map<Boolean, String> isImmunisationMissedOrNotValidZambia(Date dateOfBirth, String immunisation, Date currentDate, Map<String, Date> vaccineGivenDateMap, boolean isForNextDueDate);

    boolean isImmunisationMissed(Date dateOfBirth, String immunisation);

}
