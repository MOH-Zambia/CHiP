package com.argusoft.sewa.android.app.util;

import static com.argusoft.sewa.android.app.util.UtilBean.clearTimeFromDate;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.MedicineListItemDataBean;
import com.argusoft.sewa.android.app.databean.ValidationTagBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.TimeUnit;

/**
 * Created by prateek on 10/8/19
 */
public class ValidationFormulaUtil {

    private ValidationFormulaUtil() {
        throw new IllegalStateException("Utility Class");
    }

    public static String alphanumericWithSpace(String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (!UtilBean.isAlphaNumericWithSpace(answer)) {
            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                validationMessage = validation.getMessage();
            } else {
                validationMessage = "Must alphanumeric and space";
            }
        }
        return validationMessage;
    }

    public static String nrcNumberFormat(String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (!UtilBean.isValidNRCFormat(answer)) {
            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                validationMessage = validation.getMessage();
            } else {
                validationMessage = "Invalid NRC Number";
            }
        }
        return validationMessage;
    }

    public static String passportNumberFormat(String[] split, String answer, ValidationTagBean validation) {
        if (split.length > 0) {
            String idProof = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            String validationMessage = null;
            if (idProof != null && !UtilBean.isValidPassportFormat(answer, idProof.contains("INTL"))) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    if (idProof.contains("INTL")) {
                        validationMessage = UtilBean.getMyLabel("Invalid international passport number");
                    } else {
                        validationMessage = UtilBean.getMyLabel("Passport has to be of format AB123456 ");
                    }
                }
            }
            return validationMessage;
        }
        return null;
    }

    public static String birthCertificateNumberFormat(String[] split, String answer, ValidationTagBean validation) {
        if (split.length > 0) {
            String idProof = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            String validationMessage = null;
            if (idProof != null && !UtilBean.isValidBirthCertificateFormat(answer, idProof.contains("INTL"))) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    if (idProof.contains("INTL")) {
                        validationMessage = "Birth certificate should contain 6 to 16 digits containing alphanumeric characters";
                    } else {
                        validationMessage = "Birth certificate has to be of format ABCD/1234/5678";
                    }

                }
            }
            return validationMessage;
        }
        return null;
    }

    public static String isFutureDate(String[] split, String answer, ValidationTagBean validation) {
        try {
            long date;
            try {
                if (split.length > 2) {
                    if (split[1] != null && split[2] != null) {
                        String[] answer1 = UtilBean.split(answer.trim(), split[1].trim());
                        int index;
                        try {
                            index = Integer.parseInt(split[2].trim());
                        } catch (NumberFormatException e) {
                            index = 1;
                        }
                        if (answer1.length > index) {
                            date = Long.parseLong(answer1[index].trim());
                        } else {
                            date = Long.parseLong(answer.trim());
                        }
                    } else {
                        date = Long.parseLong(answer.trim());
                    }
                } else {
                    date = Long.parseLong(answer.trim());
                }
            } catch (NumberFormatException e) {
                date = 0L;
            }
            if (UtilBean.isFutureDate(date)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();
                } else {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        } catch (Exception e) {
            return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
        }

        return null;
    }

    public static String isPastDate(String[] split, String answer, ValidationTagBean validation) {
        try {
            long date;
            try {
                if (split.length > 2) {
                    if (split[1] != null && split[2] != null) {
                        String[] answer1 = UtilBean.split(answer.trim(), split[1].trim());
                        int index;
                        try {
                            index = Integer.parseInt(split[2].trim());
                        } catch (Exception e) {
                            index = 1;
                        }
                        if (answer1.length > index) {
                            date = Long.parseLong(answer1[index].trim());
                        } else {
                            date = Long.parseLong(answer.trim());
                        }
                    } else {
                        date = Long.parseLong(answer.trim());
                    }
                } else {
                    date = Long.parseLong(answer.trim());
                }
            } catch (Exception e) {
                date = 0L;
            }
            if (UtilBean.isPastDate(date)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();

                } else {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        } catch (Exception e) {
            return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
        }

        return null;
    }

    public static String isNotToday(String[] split, String answer, ValidationTagBean validation) {
        try {
            long date;
            try {
                if (split.length > 2) {
                    if (split[1] != null && split[2] != null) {
                        String[] answer1 = UtilBean.split(answer.trim(), split[1].trim());
                        int index;
                        try {
                            index = Integer.parseInt(split[2].trim());
                        } catch (Exception e) {
                            index = 1;
                        }
                        if (answer1.length > index) {
                            date = Long.parseLong(answer1[index].trim());
                        } else {
                            date = Long.parseLong(answer.trim());
                        }
                    } else {
                        date = Long.parseLong(answer.trim());
                    }
                } else {
                    date = Long.parseLong(answer.trim());
                }
            } catch (Exception e) {
                date = 0L;
            }
            if (UtilBean.isToday(date)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();

                } else {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        } catch (Exception e) {
            return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
        }
        return null;
    }

    public static String isDateIn(String[] split, String answer, ValidationTagBean validation) {
        try {
            long date;
            try {
                if (split.length > 6) {
                    if (split[5] != null && split[6] != null) {
                        String[] answer1 = UtilBean.split(answer.trim(), split[5].trim());
                        int index;
                        try {
                            index = Integer.parseInt(split[6].trim());
                        } catch (Exception e) {
                            index = 1;
                        }
                        if (answer1.length > index) {
                            date = Long.parseLong(answer1[index].trim());
                        } else {
                            date = Long.parseLong(answer.trim());
                        }
                    } else {
                        date = Long.parseLong(answer.trim());
                    }
                } else {
                    date = Long.parseLong(answer.trim());
                }
            } catch (Exception e) {
                date = 0L;
            }
            long customTodayDate = 0;
            if (split.length == 6) {
                String tmpObj = SharedStructureData.relatedPropertyHashTable.get(split[5]);
                if (tmpObj != null) {
                    customTodayDate = Long.parseLong(tmpObj);
                }
            }

            if (!UtilBean.isDateIn(date, split, customTodayDate)) { // check if submitted date is in between calculated date from given parameters. (here range is given in months. EG : isDateIn-Sub-1-2-3 means is submitted date is between today and date before 1 year 2 months 3 days?), returns true if in range
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();

                } else {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        } catch (Exception e) {
            return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
        }
        return null;
    }

    public static String isDateOut(String[] split, String answer, ValidationTagBean validation) {
        try {
            long date;
            try {
                if (split.length > 6) {
                    if (split[5] != null && split[6] != null) {
                        String[] answer1 = UtilBean.split(answer.trim(), split[5].trim());
                        int index;
                        try {
                            index = Integer.parseInt(split[6].trim());
                        } catch (Exception e) {
                            index = 1;
                        }
                        if (answer1.length > index) {
                            date = Long.parseLong(answer1[index].trim());
                        } else {
                            date = Long.parseLong(answer.trim());
                        }
                    } else {
                        date = Long.parseLong(answer.trim());
                    }
                } else {
                    date = Long.parseLong(answer.trim());
                }
            } catch (Exception e) {
                date = 0L;
            }

            long customTodayDate = 0;
            if (split.length == 6) {
                String tmpData = SharedStructureData.relatedPropertyHashTable.get(split[5]);
                if (tmpData != null) {
                    customTodayDate = Long.parseLong(tmpData);
                }
            }

            // check if submitted date is not in between calculated date from given parameters. (here range is given in months. EG : isDateIn-Sub-1-2-3 means is submitted date is not between today and date before 1 year 2 months 3 days?), returns true if in range
            if (!UtilBean.isDateOut(date, split, customTodayDate)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();

                } else {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        } catch (Exception e) {
            return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
        }

        return null;
    }

    public static String comapreDateWithGivenDate(String[] split, String answer, int counter, ValidationTagBean validation) {
        if (split[1] != null && split[1].trim().length() > 0) {
            if (counter > 0) {
                split[1] += counter;
            }
            String getValue = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (getValue != null && getValue.trim().length() > 0) {
                try {
                    long enterDate;
                    long comparedDate = Long.parseLong(getValue);
                    if (split.length == 4 && split[2] != null && split[2].trim().length() > 0 && split[3] != null && split[3].trim().length() > 0) {
                        String[] splitAnswer = answer.split(split[2]);
                        int index = Integer.parseInt(split[3]);
                        if (splitAnswer.length > index) {
                            answer = splitAnswer[index];
                        }
                    }
                    enterDate = Long.parseLong(answer);

                    Calendar enterDateCal = Calendar.getInstance();
                    enterDateCal.setTimeInMillis(enterDate);
                    enterDate = UtilBean.clearTimeFromDate(enterDateCal).getTimeInMillis();

                    Calendar clearTimeFromDate = Calendar.getInstance();
                    clearTimeFromDate.setTimeInMillis(comparedDate);
                    comparedDate = UtilBean.clearTimeFromDate(clearTimeFromDate).getTimeInMillis();
                    if (enterDate < comparedDate) {
                        if (validation.getMessage().contains("$s")) {
                            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
                            return String.format(validation.getMessage(), format.format(comparedDate));
                        }
                        return validation.getMessage();
                    }
                } catch (Exception e) {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        }
        return null;
    }

    public static String comapreDateWithGivenDateAfter(String[] split, String answer, int counter, ValidationTagBean validation) {
        if (split[1] != null && split[1].trim().length() > 0) {
            if (counter > 0) {
                split[1] += counter;
            }
            String getValue = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (getValue != null && getValue.trim().length() > 0) {
                try {
                    long enterDate;
                    long comparedDate = Long.parseLong(getValue);
                    if (split.length == 4 && split[2] != null && split[2].trim().length() > 0 && split[3] != null && split[3].trim().length() > 0) {
                        String[] splitAnswer = answer.split(split[2]);
                        int index = Integer.parseInt(split[3]);
                        if (splitAnswer.length > index) {
                            answer = splitAnswer[index];
                        }
                    }
                    enterDate = Long.parseLong(answer);

                    Calendar enterDateCal = Calendar.getInstance();
                    enterDateCal.setTimeInMillis(enterDate);
                    enterDate = UtilBean.clearTimeFromDate(enterDateCal).getTimeInMillis();

                    Calendar comparedDateCal = Calendar.getInstance();
                    comparedDateCal.setTimeInMillis(comparedDate);
                    comparedDate = UtilBean.clearTimeFromDate(comparedDateCal).getTimeInMillis();
                    if (enterDate > comparedDate) {
                        return validation.getMessage();
                    }
                } catch (Exception e) {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        }
        return null;
    }

    public static String comapreDateBefore(String[] split, String answer, int counter, ValidationTagBean validation) {
        if (split[1] != null && split[1].trim().length() > 0) {
            if (counter > 0) {
                split[1] += counter;
            }
            String getValue = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (getValue != null && getValue.trim().length() > 0) {
                try {
                    long enterDate;
                    long comparedDate = Long.parseLong(getValue);
                    if (split.length == 4 && split[2] != null && split[2].trim().length() > 0 && split[3] != null && split[3].trim().length() > 0) {
                        String[] splitAnswer = answer.split(split[2]);
                        int index = Integer.parseInt(split[3]);
                        if (splitAnswer.length > index) {
                            answer = splitAnswer[index];
                        }
                    }
                    //for SRDB
                    if (answer.indexOf('T') > -1) {
                        enterDate = Long.parseLong(answer.substring(2));
                    } else {
                        enterDate = Long.parseLong(answer);
                    }

                    Calendar enterDateCal = Calendar.getInstance();
                    enterDateCal.setTimeInMillis(enterDate);
                    enterDate = UtilBean.clearTimeFromDate(enterDateCal).getTimeInMillis();

                    Calendar clearTimeFromDate = Calendar.getInstance();
                    clearTimeFromDate.setTimeInMillis(comparedDate);
                    comparedDate = UtilBean.clearTimeFromDate(clearTimeFromDate).getTimeInMillis();
                    if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                        if (enterDate < comparedDate) {
                            return validation.getMessage();
                        } else {
                            return null;
                        }
                    }
                    if (enterDate <= comparedDate) {
                        return validation.getMessage();
                    }
                } catch (Exception e) {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        }
        return null;
    }

    public static String comapreDateAfter(String[] split, String answer, int counter, ValidationTagBean validation) {
        if (split[1] != null && split[1].trim().length() > 0) {
            if (counter > 0) {
                split[1] += counter;
            }
            String getValue = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (getValue != null && getValue.trim().length() > 0) {
                try {
                    long enterDate;
                    long comparedDate = Long.parseLong(getValue);
                    if (split.length == 4 && split[2] != null && split[2].trim().length() > 0 && split[3] != null && split[3].trim().length() > 0) {
                        String[] splitAnswer = answer.split(split[2]);
                        int index = Integer.parseInt(split[3]);
                        if (splitAnswer.length > index) {
                            answer = splitAnswer[index];
                        }
                    }
                    enterDate = Long.parseLong(answer);

                    Calendar enterDateCal = Calendar.getInstance();
                    enterDateCal.setTimeInMillis(enterDate);
                    enterDate = UtilBean.clearTimeFromDate(enterDateCal).getTimeInMillis();

                    Calendar comparedDateCal = Calendar.getInstance();
                    comparedDateCal.setTimeInMillis(comparedDate);
                    comparedDate = UtilBean.clearTimeFromDate(comparedDateCal).getTimeInMillis();
                    if (enterDate >= comparedDate) {
                        return validation.getMessage();
                    }
                } catch (Exception e) {
                    return GlobalTypes.MSG_VALIDATION_INVALID_DATE;
                }
            }
        }
        return null;
    }

    public static String containsCharacterPipeline(String answer, ValidationTagBean validation) {
        // check if text contains |, returns true if contains
        if (answer != null && answer.contains("|")) {
            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                return validation.getMessage();
            } else {
                return GlobalTypes.MSG_VALIDATION_PIPELINE_MSG;
            }
        }
        return null;
    }

    public static String greaterThen0(String answer, ValidationTagBean validation) {
        String validationMessage = null;

        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (NumberFormatException e) {
                number = 0;
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN, number, 0)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = "Number is not greater than 0";
                }
            }
        } catch (Exception e) {
            validationMessage = "Number is not greater than 0";
        }

        return validationMessage;
    }

    public static String greaterThan(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;

        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (NumberFormatException e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                try {
                    from = Float.parseFloat(split[1].trim());
                } catch (NumberFormatException e) {
                    from = 0;
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }
        return validationMessage;
    }

    public static String greaterThanEq(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;

        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                try {
                    from = Float.parseFloat(split[1].trim());
                } catch (Exception e) {
                    from = 0;
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }
        return validationMessage;
    }

    public static String lessThan(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;

        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                try {
                    from = Float.parseFloat(split[1].trim());
                } catch (Exception e) {
                    from = 0;
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_LESS_THAN, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }
        return validationMessage;
    }

    public static String lessThanEq(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                try {
                    from = Float.parseFloat(split[1].trim());
                } catch (Exception e) {
                    from = 0;
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_LESS_THAN_EQUAL, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String lessThanEqRelatedProperty(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                String tmpData = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (tmpData != null) {
                    try {
                        from = Float.parseFloat(tmpData);
                    } catch (Exception e) {
                        from = 0;
                    }
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_LESS_THAN_EQUAL, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String greaterThanEqRelatedProperty(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                String tmpData = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (tmpData != null) {
                    try {
                        from = Float.parseFloat(tmpData);
                    } catch (Exception e) {
                        from = 0;
                    }
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String lessThanRelatedProperty(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                String tmpData = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (tmpData != null) {
                    try {
                        from = Float.parseFloat(tmpData);
                    } catch (Exception e) {
                        from = 0;
                    }
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_LESS_THAN, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String greaterThanRelatedProperty(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            if (split[1] != null && split[1].length() > 0) {
                String tmpData = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (tmpData != null) {
                    try {
                        from = Float.parseFloat(tmpData);
                    } catch (Exception e) {
                        from = 0;
                    }
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN, number, from)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String between(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        try {
            float number;
            try {
                number = Float.parseFloat(answer.trim());
            } catch (Exception e) {
                number = 0;
            }
            float from = 0.0f;
            float to = 0.0f;
            String[] range = UtilBean.split(split[1], GlobalTypes.COMMA);
            if (range.length == 2) {
                try {
                    from = Float.parseFloat(range[0].trim());
                    to = Float.parseFloat(range[1].trim());
                } catch (Exception e) {
                    from = 0;
                    to = 0;
                }
            }
            if (!UtilBean.isValidNumber(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL, number, from) || !UtilBean.isValidNumber(FormulaConstants.VALIDATION_LESS_THAN_EQUAL, number, to)) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    validationMessage = validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        } catch (Exception e) {
            return LabelConstants.INVALID_VALUE;
        }

        return validationMessage;
    }

    public static String checkInputLength(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (split.length > 1 && split[1] != null) {
            String[] answerArray = answer.split("");
            if (answerArray.length - 1 < Integer.parseInt(split[1])) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
        }
        return validationMessage;
    }

    public static String mobileNumber(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (split.length > 3 && split[3].equals("CAM")) {
            int minLength = Integer.parseInt(split[1]);
            int maxLength = Integer.parseInt(split[2]);
            if (answer.trim().length() < minLength || answer.trim().length() > maxLength) {
                if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                    return validation.getMessage();
                } else {
                    validationMessage = LabelConstants.INVALID_VALUE;
                }
            }
            long count = SharedStructureData.sewaFhsService.getMobileNumberCount(answer);
            if (count > 3) {
                validationMessage = "Mobile number is already registered with other family. Please enter another number.";
            }

            if (UtilBean.getBlockedMobileNumbers().contains(answer)) {
                validationMessage = "The mobile number is blocked. Please enter another number";
            }
        } else {
            if (split.length > 1 && !split[1].equals("10")) {
                int length = Integer.parseInt(split[1]);
                if (answer.trim().length() != length) {
                    if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                        return validation.getMessage();
                    } else {
                        validationMessage = LabelConstants.INVALID_VALUE;
                    }
                }
            } else {
                if (answer.trim().length() != 10) {
                    validationMessage = "Mobile number must contain 10 digits.";
                    return validationMessage;
                }


                char c = answer.charAt(0);
                if (String.valueOf(c).matches("[012345]")) {
                    if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                        return validation.getMessage();
                    } else {
                        validationMessage = "Mobile number can't start from 0 to 5";
                    }
                }

                long count = SharedStructureData.sewaFhsService.getMobileNumberCount(answer);
                if (count > 3) {
                    validationMessage = "Mobile number is already registered with other family. Please enter another number.";
                }

                if (UtilBean.getBlockedMobileNumbers().contains(answer)) {
                    validationMessage = "The mobile number is blocked. Please enter another number";
                }
            }
        }

        return validationMessage;
    }

    public static String mobileNumberZambia(String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (answer.startsWith("0")) {
            answer = answer.substring(1);
        }

        if (answer.trim().length() < 9) {
            validationMessage = "Mobile number must contain 10 to 13 digits.";
            return validationMessage;
        }

        if (answer.trim().length() > 13) {
            validationMessage = "Mobile number must contain 10 to 13 digits.";
            return validationMessage;
        }

//        char c = answer.charAt(0);
//        if (String.valueOf(c).matches("[012345]")) {
//            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
//                return validation.getMessage();
//            } else {
//                validationMessage = "Mobile number can't start from 0 to 5";
//            }
//        }

        long count = SharedStructureData.sewaFhsService.getMobileNumberCount(answer);
        if (count > 3) {
            validationMessage = "Mobile number is already registered with other family. Please enter another number.";
        }

        if (UtilBean.getBlockedMobileNumbers().contains(answer)) {
            validationMessage = "The mobile number is blocked. Please enter another number";
        }
        return validationMessage;
    }

    public static String aadhaarNumber(String answer) {
        String validationMessage = null;
        if (answer == null) {
            validationMessage = "Please enter aadhaar number.";
            return validationMessage;
        }
        validationMessage = UtilBean.aadhaarNumber(answer);
        return validationMessage;
    }

    public static String inputLengthRange(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (split.length > 1) {
            String[] inputRange = split[1].split(",");
            if (inputRange.length == 2) {
                int from = Integer.parseInt(inputRange[0]);
                int to = Integer.parseInt(inputRange[1]);
                if (answer.trim().length() < from || answer.trim().length() > to) {
                    if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                        return validation.getMessage();
                    } else {
                        validationMessage = LabelConstants.INVALID_VALUE;
                    }
                }
            }
        }
        return validationMessage;
    }

    public static String maxLength(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (answer.trim().length() > Integer.parseInt(split[1])) {
            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                return validation.getMessage();
            } else {
                validationMessage = LabelConstants.INVALID_VALUE;
            }
        }
        return validationMessage;
    }

    public static String length(String[] split, String answer, ValidationTagBean validation) {
        String validationMessage = null;
        if (answer.trim().length() != Integer.parseInt(split[1])) {
            if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                return validation.getMessage();
            } else {
                validationMessage = LabelConstants.INVALID_VALUE;
            }
        }

        return validationMessage;
    }

    public static String onlyOneHead(ValidationTagBean validation) {
        String familyFound = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND);
        if (familyFound != null && familyFound.equals("1")) {
            if (SharedStructureData.loopBakCounter == 0) {
                String headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG);
                if (headAnswer != null && headAnswer.equals("2")) {
                    return validation.getMessage();
                }
            } else {
                int headsDeclared = 0;
                for (int i = 0; i < SharedStructureData.loopBakCounter + 1; i++) {
                    String headAnswer;
                    String statusAnswer;
                    if (i == 0) {
                        headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG);
                        statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                    } else {
                        headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG + i);
                        statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS + i);
                    }
                    if ((statusAnswer == null && headAnswer != null && headAnswer.equals("1"))
                            || (headAnswer != null && statusAnswer != null && headAnswer.equals("1") && statusAnswer.equals("1"))) {
                        headsDeclared++;
                    }

                }
                if (headsDeclared != 1) {
                    return validation.getMessage();
                }
            }
        }
        return null;
    }

    public static String checkHeadMemberAge(String[] split, ValidationTagBean validation) {
        String familyFound = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND);
        if (familyFound != null && familyFound.equals("1")) {
            String dob = null;
            for (int i = 0; i < SharedStructureData.loopBakCounter + 1; i++) {
                String headAnswer;
                String statusAnswer;
                String dob1;
                if (i == 0) {
                    headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG);
                    statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                    dob1 = SharedStructureData.relatedPropertyHashTable.get("dob");
                } else {
                    headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG + i);
                    statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS + i);
                    dob1 = SharedStructureData.relatedPropertyHashTable.get("dob" + i);
                }
                if ((statusAnswer == null && headAnswer != null && headAnswer.equals("1"))
                        || (headAnswer != null && statusAnswer != null && headAnswer.equals("1") && statusAnswer.equals("1"))) {
                    dob = dob1;
                }
            }
            if (split.length > 1) {
                // Used in Family Folder - Age 14
                if (dob != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.add(Calendar.YEAR, -(Integer.parseInt(split[1])));
                    if (new Date(Long.parseLong(dob)).after(calendar.getTime())) {
                        return validation.getMessage();
                    }
                }
            } else {
                if (dob != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.add(Calendar.YEAR, -18);
                    if (new Date(Long.parseLong(dob)).after(calendar.getTime())) {
                        return validation.getMessage();
                    }
                }
            }
        }
        return null;
    }

    public static String maritalStatusValidation(String answer, int counter, ValidationTagBean validation) {
        String tempObj;
        if (counter == 0) {
            tempObj = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ANS_12);
        } else {
            tempObj = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ANS_12 + counter);
        }
        if (tempObj != null && ((tempObj.equals("1") && answer.equals("641"))
                || (tempObj.equals("2") && answer.equals("643")))) {
            return validation.getMessage();
        }

        return null;
    }

    public static String checkHofRelationWithMaritalStatus(String[] split, String answer, int counter, ValidationTagBean validation) {
        if (split.length > 1) {
            String property = UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], counter);
            property = SharedStructureData.relatedPropertyHashTable.get(property);

            if (property == null) {
                return null;
            }

            switch (split[1]) {
                case RelatedPropertyNameConstants.ANS_12:
                    if ((property.equals("1") && answer.equals("641"))
                            || (property.equals("2") && answer.equals("643"))) {
                        return validation.getMessage();
                    }
                    break;
                case RelatedPropertyNameConstants.RELATION_WITH_HOF:
                    if (!answer.equals("629") && (FhsConstants.RELATION_WIFE.equalsIgnoreCase(property)
                            || FhsConstants.RELATION_HUSBAND.equalsIgnoreCase(property))) {
                        return validation.getMessage();
                    } else if (answer.equals("630") && (FhsConstants.RELATION_DAUGHTER_IN_LAW.equalsIgnoreCase(property)
                            || FhsConstants.RELATION_SON_IN_LAW.equalsIgnoreCase(property))) {
                        return validation.getMessage();
                    }
                    break;
                default:
            }
        }

        return null;
    }


    public static String villageSelectionCheck(String answer, ValidationTagBean validation) {
        String locationId = SharedStructureData.relatedPropertyHashTable.get("locationId");
        if (locationId != null && locationId.equalsIgnoreCase(answer)) {
            return validation.getMessage();
        }
        return null;
    }

    public static String motherChildComponentValidation(String answer, ValidationTagBean validation) {
        String tmpObj = SharedStructureData.relatedPropertyHashTable.get("numberOfMemberForMotherSelection");
        if (tmpObj != null) {
            int size = Integer.parseInt(tmpObj);
            Gson gson = new Gson();
            Map<String, String> answerMap = gson.fromJson(answer, new TypeToken<HashMap<String, String>>() {
            }.getType());
            if (size != answerMap.size()) {
                return validation.getMessage();
            }
            for (Map.Entry<String, String> entry : answerMap.entrySet()) {
                if (entry.getKey().equals(entry.getValue())) {
                    return UtilBean.getMyLabel("Mother and Child selection for a child is not valid.");
                }
            }
        }
        return null;
    }

    public static String vaccinationValidationChild(String answer) {
        Date dob = null;
        String dDateObj = SharedStructureData.relatedPropertyHashTable.get("deliveryDate");
        String dobObj = SharedStructureData.relatedPropertyHashTable.get("dob");
        if (SharedStructureData.formType != null && (SharedStructureData.formType.equals(FormConstants.TECHO_FHW_WPD)
                || SharedStructureData.formType.equals(FormConstants.CAM_WPD)
                || SharedStructureData.formType.equals(FormConstants.TECHO_FHW_PNC)) && dDateObj != null) {
            dob = new Date(Long.parseLong(dDateObj));
        } else if (dobObj != null) {
            dob = new Date(Long.parseLong(dobObj));
        }

        if (dob != null) {
            Date givenDate = new Date(Long.parseLong(answer));
            SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(SharedStructureData.context);
            String currentVaccine = sharedPref.getString("currentVaccine", null);
            if (currentVaccine != null) {
                if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                    return SharedStructureData.immunisationService.vaccinationValidationForChildZambia(dob, givenDate, currentVaccine.trim(), SharedStructureData.vaccineGivenDateMap, null);
                } else {
                    return SharedStructureData.immunisationService.vaccinationValidationForChild(dob, givenDate, currentVaccine.trim(), SharedStructureData.vaccineGivenDateMap);
                }
            }
        }
        return null;
    }

    public static String checkNumberFormatException(String answer) {
        try {
            Long.parseLong(answer);
        } catch (NumberFormatException ex) {
            return answer + UtilBean.getMyLabel(" is not a number.");
        }
        return null;
    }

    public static String checkSingleECMemberFamily() {
        String familyStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND);
        if (SharedStructureData.loopBakCounter == 0 && "1".equals(familyStatus)) {
            String dob = SharedStructureData.relatedPropertyHashTable.get("dob");
            String gender = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.ANS_12);
            String status = SharedStructureData.relatedPropertyHashTable.get("defaultMaritalStatus");

            if (dob != null) {
                Date dobDate = new Date(Long.parseLong(dob));
                Calendar calendar = Calendar.getInstance();
                calendar.add(Calendar.YEAR, -15);
                Date before15Years = calendar.getTime();
                calendar.add(Calendar.YEAR, -34);
                Date before49Years = calendar.getTime();
                if (gender != null && gender.equals("2")
                        && status != null && status.equals("629")
                        && dobDate.after(before49Years) && dobDate.before(before15Years)) {
                    return UtilBean.getMyLabel("Single Eligible Couple Member cannot be added as a Family. "
                            + "Please enter the full family details. "
                            + "If this member belongs to another family, use the family update feature.");
                }
            }
        }
        return null;
    }

    public static String checkAgeForNotUnmarried(String answer, int counter, ValidationTagBean validation) {
        String status;
        if (counter == 0) {
            status = SharedStructureData.relatedPropertyHashTable.get("defaultMaritalStatus");
        } else {
            status = SharedStructureData.relatedPropertyHashTable.get("defaultMaritalStatus" + counter);
        }
        List<FieldValueMobDataBean> labelDataBeans = SharedStructureData.sewaService.getFieldValueMobDataBeanByDataMap("maritalStatusList");
        FieldValueMobDataBean selectedStatus = null;
        for (FieldValueMobDataBean data : labelDataBeans) {
            if (data.getIdOfValue() == Integer.parseInt(status)) {
                selectedStatus = data;
            }
        }

        if (answer != null) {
            Date dobDate = new Date(Long.parseLong(answer));
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, -18);
            Date before18Years = calendar.getTime();
            if (status != null && status.equals("2677") && dobDate.after(before18Years)) {
                return UtilBean.getMyLabel("Age can't be less than 18 years for Live-in relationship person");
            }
            calendar = Calendar.getInstance();
            calendar.add(Calendar.YEAR, -15);
            Date before15Years = calendar.getTime();
            if (status != null && !status.equals("630")
                    && dobDate.after(before15Years)) {
                return UtilBean.getMyLabel(validation.getMessage() + " for " + selectedStatus.getValue().toLowerCase() + " person.");
            }
        }
        return null;
    }

    public static String checkAgeOfChildIsNotGreaterThanParent(int counter, String answer, ValidationTagBean validation) {
        String hofDobProperty = SharedStructureData.relatedPropertyHashTable.get("hofDob");
        String relationWithHofProperty = SharedStructureData.relatedPropertyHashTable.get(UtilBean.getRelatedPropertyNameWithLoopCounter("relationWithHOF", counter));

        if (hofDobProperty != null && relationWithHofProperty != null && answer != null) {
            Date hofDobDate = new Date(Long.parseLong(hofDobProperty));
            Date childRelationDobDate = new Date(Long.parseLong(answer));
            if (FhsConstants.CHILDREN_RELATION.contains(relationWithHofProperty)
                    && childRelationDobDate.before(hofDobDate)) {
                return validation.getMessage();
            }
            if (FhsConstants.ELDER_RELATION.contains(relationWithHofProperty)
                    && childRelationDobDate.after(hofDobDate)) {
                return validation.getMessage();
            }
        }
        return null;
    }

    public static String validateDuration(String[] split, String answer, int counter, ValidationTagBean validation) {
        String validationMessage = null;
        if (split.length > 0) {
            if (split[1] != null && split[2] != null && split[3] != null && split[4] != null && answer != null) {
                String property = UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], counter);
                String tmpObj = SharedStructureData.relatedPropertyHashTable.get(property);
                String years = UtilBean.getRelatedPropertyNameWithLoopCounter(split[3], counter);
                String durationInYears = SharedStructureData.relatedPropertyHashTable.get(years);
                String months = UtilBean.getRelatedPropertyNameWithLoopCounter(split[4], counter);
                String durationInMonths = SharedStructureData.relatedPropertyHashTable.get(months);

                if (tmpObj == null) {
                    return null;
                }
                if (split[2] == null) {
                    split[2] = "0";
                }
                if (split[5] != null && durationInMonths != null && durationInYears != null) {
                    if (split[5].equalsIgnoreCase("F") && durationInYears.equalsIgnoreCase("0") && durationInMonths.equalsIgnoreCase("0")) {
                        return "Years and months both can't be zero";
                    }
                }
                if (durationInYears == null) {
                    durationInYears = "0";
                }
                if (durationInMonths == null) {
                    durationInMonths = "0";
                }
                Calendar duration = Calendar.getInstance();
                duration.add(Calendar.MONTH, -(Integer.parseInt(durationInMonths)));
                duration.add(Calendar.YEAR, -((Integer.parseInt(durationInYears)) + Integer.parseInt(split[2])));
                Date date = duration.getTime();
                Long dobDate = Long.parseLong(tmpObj);
                Long durationDate = date.getTime();
                if (dobDate.compareTo(durationDate) >= 0) {
                    if (validation.getMessage() != null && validation.getMessage().trim().length() > 0) {
                        validationMessage = validation.getMessage();
                    } else {
                        validationMessage = LabelConstants.INVALID_VALUE;
                    }
                }
                return validationMessage;
            }
            return null;
        }
        return null;
    }


    public static String checkDate(String[] split, String answer, int counter, ValidationTagBean validation) {
        //checkDate-after-loop-relatedPropertyName-Add-1-1-1
        //checkDate-before-noloop-relatedPropertyName-Sub-1-1-1
        if (answer == null || answer.isEmpty()) {
            return null;
        }
        Date selectedDate = new Date(Long.parseLong(answer));
        Date checkDate = null;

        if (split.length >= 4) {
            if (split[2].equalsIgnoreCase("loop")) {
                split[3] = UtilBean.getRelatedPropertyNameWithLoopCounter(split[3], counter);
            }
            String checkDateStr = SharedStructureData.relatedPropertyHashTable.get(split[3]);
            if (checkDateStr != null) {
                checkDate = new Date(Long.parseLong(checkDateStr));
            }
        }
        if (checkDate != null && split.length == 8) {
            if (split[4].equalsIgnoreCase("Add")) {
                checkDate = new Date(UtilBean.addYearsMonthsDays(
                        checkDate.getTime(), Integer.parseInt(split[5]),
                        Integer.parseInt(split[6]), Integer.parseInt(split[7])));
            }
            if (split[4].equalsIgnoreCase("Sub")) {
                checkDate = new Date(UtilBean.addYearsMonthsDays(
                        checkDate.getTime(), -1 * Integer.parseInt(split[5]),
                        -1 * Integer.parseInt(split[6]), -1 * Integer.parseInt(split[7])));
            }
        }

        checkDate = UtilBean.clearTimeFromDate(checkDate);
        selectedDate = UtilBean.clearTimeFromDate(selectedDate);

        if (checkDate == null) {
            return null;
        }

        if ((split[1].equalsIgnoreCase("after") && selectedDate.after(checkDate))
                || (split[1].equalsIgnoreCase("before") && selectedDate.before(checkDate))) {
            return validation.getMessage() != null ? validation.getMessage() : "Selected date is not valid";
        }
        return null;
    }

    public static String checkDaysGapDeliveryDate(String[] split, ValidationTagBean validation) {
        int numberOfDays = 2;
        if (split.length == 2) {
            numberOfDays = Integer.parseInt(split[1]);
        }

        if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HEALTH_INFRASTRUCTURE_TYPE_ID) == null) {
            return null;
        }

        if (RchConstants.PHI_INSTITUTIONS_TYPE_ID_FOR_2_DAYS_DEL_GAP.contains(
                SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HEALTH_INFRASTRUCTURE_TYPE_ID))) {
            String deliveryDate = SharedStructureData.relatedPropertyHashTable.get("deliveryDate");
            Calendar todayCalendar = Calendar.getInstance();
            clearTimeFromDate(todayCalendar);
            todayCalendar.add(Calendar.DATE, -numberOfDays);
            if (deliveryDate != null && todayCalendar.getTime().getTime() < Long.parseLong(deliveryDate)) {
                return validation.getMessage();
            }
        }

        return null;
    }

    // checkServiceDateForHealthInfra-serviceDate-govtHospDayValidation-pvtHospDayValidation
    public static String checkServiceDateForHealthInfra(String[] split, ValidationTagBean validation) {
        String healthInfrastructureTypeId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HEALTH_INFRASTRUCTURE_TYPE_ID);
        if (healthInfrastructureTypeId != null) {
            Date serviceDate = new Date();
            Date lastValidDate;
            if (split.length > 1) {
                String serviceDateString = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (serviceDateString != null) {
                    serviceDate = new Date(Long.parseLong(serviceDateString));
                }
            }

            int govtHospDayValidation = 15;
            int pvtHospDayValidation = 30;
            if (split.length > 2) {
                govtHospDayValidation = Integer.parseInt(split[2]);
            }
            if (split.length > 3) {
                pvtHospDayValidation = Integer.parseInt(split[3]);
            }

            if (RchConstants.GOVERNMENT_INSTITUTIONS.contains(Long.valueOf(healthInfrastructureTypeId))) {
                Calendar instance = Calendar.getInstance();
                instance.add(Calendar.DATE, govtHospDayValidation * -1);
                lastValidDate = instance.getTime();
            } else {
                Calendar instance = Calendar.getInstance();
                instance.add(Calendar.DATE, pvtHospDayValidation * -1);
                lastValidDate = instance.getTime();
            }

            if (serviceDate.before(lastValidDate)) {
                return validation.getMessage();
            }
        }
        return null;
    }

    public static String checkServiceDateForHomeVisit(String[] split, String answer, ValidationTagBean validation) {
        if (!answer.equalsIgnoreCase("HOSP")) {
            Date serviceDate;
            Date lastValidDate;
            if (split.length > 1) {
                String serviceDateString = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                if (serviceDateString != null) {
                    serviceDate = new Date(Long.parseLong(serviceDateString));
                } else {
                    serviceDate = new Date();
                }
            } else {
                serviceDate = new Date();
            }

            Calendar instance = Calendar.getInstance();
            instance.add(Calendar.DATE, -15);
            lastValidDate = instance.getTime();

            if (serviceDate.before(lastValidDate)) {
                return validation.getMessage();
            }
        }
        return null;
    }

    public static String checkIntegerPlus(String[] split, String answer, ValidationTagBean validation) {
        if (split.length > 1) {
            String relatedProperyName = split[1];
            String previousValue = SharedStructureData.relatedPropertyHashTable.get(relatedProperyName);
            if (previousValue != null) {
                int previous = Integer.parseInt(previousValue);
                int current = Integer.parseInt(answer);
                if (current < previous) {
                    return validation.getMessage();
                }
            }
        }
        return null;
    }

    public static String familyPlanningDateValidation(String[] split, String answer, ValidationTagBean validation) {
        // familyPlanningDateValidation-lastMethodOfContraception-serviceDate-lastDeliveryDate
        if (split.length > 1) {
            String familyPlanningRelatedPropertyName = split[1];
            String familyPlanning = SharedStructureData.relatedPropertyHashTable.get(familyPlanningRelatedPropertyName);
            if (familyPlanning != null) {
                Calendar instance = Calendar.getInstance();
                if (split.length > 2) {
                    String serviceDate = SharedStructureData.relatedPropertyHashTable.get(split[2]);
                    if (serviceDate != null && !serviceDate.equalsIgnoreCase("null")) {
                        instance.setTimeInMillis(Long.parseLong(serviceDate));
                    }
                }

                Date serviceDate = instance.getTime();
                Date insertionDate = new Date(Long.parseLong(answer));
                Date validationDate;

                switch (familyPlanning) {
                    case RchConstants.IUCD_10_YEARS:
                        instance.add(Calendar.YEAR, -10);
                        validationDate = instance.getTime();

                        if (insertionDate.before(validationDate) || insertionDate.after(serviceDate)) {
                            return validation.getMessage();
                        }
                        break;

                    case RchConstants.IUCD_5_YEARS:
                        instance.add(Calendar.YEAR, -5);
                        validationDate = instance.getTime();

                        if (insertionDate.before(validationDate) || insertionDate.after(serviceDate)) {
                            return validation.getMessage();
                        }
                        break;

                    case RchConstants.ANTARA:
                        instance.add(Calendar.MONTH, -3);
                        validationDate = instance.getTime();

                        if (insertionDate.after(serviceDate) || insertionDate.before(validationDate)) {
                            return validation.getMessage();
                        }
                        break;

                    case RchConstants.PPIUCD:
                        if (split.length > 3) {
                            String lastDeliveryDateString = SharedStructureData.relatedPropertyHashTable.get(split[3]);
                            if (lastDeliveryDateString != null && !lastDeliveryDateString.equalsIgnoreCase("null")) {
                                instance.setTimeInMillis(Long.parseLong(lastDeliveryDateString));
                                Date lastDeliveryDate = instance.getTime();
                                instance.add(Calendar.DATE, 2);
                                validationDate = instance.getTime();

                                if (insertionDate.after(validationDate) || insertionDate.before(lastDeliveryDate)) {
                                    return validation.getMessage();
                                }
                            } else {
                                return validation.getMessage();
                            }
                        }
                        break;

                    case RchConstants.PAIUCD:
                        if (split.length > 3) {
                            String lastDeliveryDateString = SharedStructureData.relatedPropertyHashTable.get(split[3]);
                            if (lastDeliveryDateString != null && !lastDeliveryDateString.equalsIgnoreCase("null")) {
                                instance.setTimeInMillis(Long.parseLong(lastDeliveryDateString));
                                Date lastDeliveryDate = instance.getTime();
                                instance.add(Calendar.DATE, 12);
                                validationDate = instance.getTime();

                                if (insertionDate.after(validationDate) || insertionDate.before(lastDeliveryDate)) {
                                    return validation.getMessage();
                                }
                            } else {
                                return validation.getMessage();
                            }
                        }
                        break;

                    default:
                        return null;
                }
            }
        }
        return null;
    }

    public static String checkGivenSachets(String[] split, String answer, ValidationTagBean validation) {
        if (split.length == 2 && answer != null) {
            String tmpObj = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (tmpObj != null) {
                int toBeGiven = Integer.parseInt(tmpObj);
                if (Integer.parseInt(answer) > toBeGiven) {
                    return validation.getMessage();
                }
            }
        } else {
            return UtilBean.getMyLabel("Please enter valid given sachets.");
        }
        return null;
    }

    public static String checkConsumedSachets(String[] split, String answer, ValidationTagBean validation) {
        if (split.length == 2 && answer != null) {
            String tmpObj = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (tmpObj != null && Integer.parseInt(tmpObj) < Integer.parseInt(answer)) {
                return validation.getMessage();
            }
        }
        return null;
    }

    public static String checkHofRelationWithGender(String[] split, String answer, int counter, ValidationTagBean validation) {
        // checkHofRelationWithGender-relatedPropertyToTestWith

        if (split.length > 1) {
            String property = UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], counter);
            property = SharedStructureData.relatedPropertyHashTable.get(property);

            String hofGender = null;
            for (int i = 0; i < counter; i++) {
                String isFamilyHeadFlag = SharedStructureData.relatedPropertyHashTable.get(UtilBean.getRelatedPropertyNameWithLoopCounter(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG, i));
                if ("1".equals(isFamilyHeadFlag)) {
                    hofGender = SharedStructureData.relatedPropertyHashTable.get(UtilBean.getRelatedPropertyNameWithLoopCounter(RelatedPropertyNameConstants.ANS_12, i));
                }
            }

            if (hofGender == null) {
                hofGender = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.HOF_GENDER);
            }

//            if (property == null) {
//                return null;
//            }

            boolean husbandValidationForMale = "1".equals(hofGender) && answer.equals(FhsConstants.RELATION_HUSBAND);
            boolean wifeValidationForFemale = "2".equals(hofGender) && answer.equals(FhsConstants.RELATION_WIFE);

            switch (split[1]) {
                case RelatedPropertyNameConstants.HOF_GENDER:
                    if (husbandValidationForMale) {
                        return validation.getMessage();
                    }

                    if (wifeValidationForFemale) {
                        return validation.getMessage();
                    }
                    break;
                case RelatedPropertyNameConstants.ANS_12:
                    if (husbandValidationForMale) {
                        return validation.getMessage();
                    }

                    if (wifeValidationForFemale) {
                        return validation.getMessage();
                    }

                    if ((property != null && property.equals("1") && FhsConstants.FEMALE_RELATION.contains(answer))
                            || (property != null && property.equals("2") && FhsConstants.MALE_RELATION.contains(answer))) {
                        return validation.getMessage();
                    }
                    break;
                case RelatedPropertyNameConstants.RELATION_WITH_HOF:
                    if ((answer.equals("1") && FhsConstants.FEMALE_RELATION.contains(property))
                            || (answer.equals("2") && FhsConstants.MALE_RELATION.contains(property))) {
                        return validation.getMessage();
                    }
                    break;
                default:
            }
        }

        return null;
    }

    public static String validateMedicineDetail(String answer, ValidationTagBean validation) {

        if (answer != null) {
            List<MedicineListItemDataBean> medicineDetails = new Gson().fromJson(answer, new TypeToken<List<MedicineListItemDataBean>>() {
            }.getType());
            if (medicineDetails != null && !medicineDetails.isEmpty()) {
                for (MedicineListItemDataBean medicine : medicineDetails) {
                    if (medicine.getDuration() == null || medicine.getFrequency() == null) {
                        return validation.getMessage();
                    }
                    if (medicine.getDuration() == 0 || medicine.getFrequency() == 0) {
                        return UtilBean.getMyLabel(LabelConstants.INVALID_VALUE);
                    }
                }
            }
        }
        return null;
    }

    public static String validateWeddingDate(String[] split, String answer, int counter, ValidationTagBean validation) {

        if (split.length > 1) {
            String property = UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], counter);
            property = SharedStructureData.relatedPropertyHashTable.get(property);

            if (property == null) {
                return null;
            }

            if (answer != null) {
                Date dobDate = new Date(Long.parseLong(property));
                Date weddingDate = new Date(Long.parseLong(answer));
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(dobDate);
                calendar.add(Calendar.YEAR, 15);
                Date after15Years = calendar.getTime();
                if (weddingDate.before(after15Years)) {
                    return UtilBean.getMyLabel(validation.getMessage());
                }
            }
        }
        return null;
    }

    public static String validateDiabetesValue(String[] split, String answer, ValidationTagBean validation) {
        if (split.length > 1) {
            String property = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if ((answer == null || answer.isEmpty()) && (property == null || property.isEmpty())) {
                return UtilBean.getMyLabel(validation.getMessage());
            }
        }
        return null;
    }

    public static String checkChardhamIsPregnantWithGender(String[] split, String answer, int counter, ValidationTagBean validation) {
        // checkHofRelationWithGender-relatedPropertyToTestWith

        if (split.length > 1) {
            String property = UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], counter);
            String isPregnant = UtilBean.getRelatedPropertyNameWithLoopCounter(split[2], counter);
            property = SharedStructureData.relatedPropertyHashTable.get(property);
            isPregnant = SharedStructureData.relatedPropertyHashTable.get(isPregnant);

            if (property == null || isPregnant == null) {
                return null;
            }

            if (RelatedPropertyNameConstants.CHARDHAM_MEMBER_GENDER.equals(split[1])) {
                if (property.equals("1") && isPregnant.equals("1") || property.equals("3") && isPregnant.equals("1")) {
                    return validation.getMessage();
                }
            }
        }

        return null;
    }

    public static String checkAadharConsent(String[] split, int counter, ValidationTagBean validation) {
        if (split.length <= 1) {
            return null;
        }

        int queId = Integer.parseInt(split[1]);
        QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(DynamicUtils.getLoopId(queId, counter));
        if (Objects.requireNonNull(queFormBean).getAnswer() != null) {
            if (split.length > 2) {
                List<String> answers = Arrays.asList(queFormBean.getAnswer().toString().split(","));
                for (int i = 2; i < split.length; i++) {
                    if (!answers.contains(split[i])) {
                        return validation.getMessage() != null ? validation.getMessage() : "Please provide consent by checking the box";
                    }
                }
            } else {
                return validation.getMessage() != null ? validation.getMessage() : "Please provide consent by checking the box";
            }
        } else {
            return validation.getMessage() != null ? validation.getMessage() : "Please provide consent by checking the box";
        }

        return null;
    }

    public static String checkAvailableTablets(String[] split, String answer, ValidationTagBean validation) {
        if (split.length <= 1) {
            return null;
        }
        String medicineConstant = split[1];
        String type = split[2];

        // Check if the medicineConstant exists in the hash table, or if it is Albendazole
        if (SharedStructureData.relatedPropertyHashTable.get(medicineConstant) == null
                && !answer.equalsIgnoreCase("0")) {
            if (medicineConstant.equalsIgnoreCase(LabelConstants.ALBENDAZOLE)) {
                return null;
            }
            return UtilBean.getMyLabel(validation.getMessage());
        }

        if (!SharedStructureData.relatedPropertyHashTable.containsKey(medicineConstant)) {
            return null;
        }

        String medicine = SharedStructureData.relatedPropertyHashTable.get(medicineConstant);
        int tabletAmount = 0;

        // Parse the medicine amount, if it exists
        if (medicine.matches("\\d+")) {
            tabletAmount = Integer.parseInt(medicine);
        } else if (SharedStructureData.relatedPropertyHashTable.containsKey(medicine)) {
            tabletAmount = Integer.parseInt(SharedStructureData.relatedPropertyHashTable.get(medicine));
        }

        switch (type) {
            case LabelConstants.DATE_FOR_MEDICINE:
                if (tabletAmount == 0 && !answer.equalsIgnoreCase("0")) {
                    return UtilBean.getMyLabel(validation.getMessage());
                }
                return null;

            case LabelConstants.NUMBER:
                // Allow if answer is 0 or answer <= tabletAmount
                if (Integer.parseInt(answer) > tabletAmount && !answer.equals("0")) {
                    return UtilBean.getMyLabel(validation.getMessage());
                }
                return null;

            case LabelConstants.BOOL:
                // Allow when answer is 0 or tabletAmount > 0
                if (answer.equalsIgnoreCase("1") && tabletAmount == 0) {
                    return UtilBean.getMyLabel(validation.getMessage());
                }
                return null;

            case LabelConstants.LIST:
                // Allow when answer is NONE or tabletAmount > 0
                if (!answer.equalsIgnoreCase("NONE") && tabletAmount == 0 && !answer.equals("0")) {
                    return UtilBean.getMyLabel(validation.getMessage());
                }
        }
        return null;
    }

    public static String checkGivenDateForCovid(String[] split, String answer, ValidationTagBean validation) {
        if (split.length > 1) {
            String doseOne = SharedStructureData.relatedPropertyHashTable.get(split[1]);
            if (doseOne == null) {
                return "Enter dose one";
            }
            Date doseOneDate = new Date(Long.parseLong(doseOne));
            if (split.length > 2) {
                String vaccineName = SharedStructureData.relatedPropertyHashTable.get(split[2]);
                switch (vaccineName) {
                    case RelatedPropertyNameConstants.PFIZER:
                        Date doseTwoDate = new Date(Long.parseLong(answer));
                        Long difference = TimeUnit.MILLISECONDS.toDays(doseTwoDate.getTime() - doseOneDate.getTime());
                        if (difference < 21) {
                            return "Dose 2 can't be before 21 days of dose 1";
                        }
                        break;
                    case RelatedPropertyNameConstants.MODERNA:
                        doseTwoDate = new Date(Long.parseLong(answer));
                        difference = TimeUnit.MILLISECONDS.toDays(doseTwoDate.getTime() - doseOneDate.getTime());
                        if (difference < 28) {
                            return "Dose 2 can't be before 28 days of dose 1";
                        }
                        break;
                    case RelatedPropertyNameConstants.OXFORD:
                    case RelatedPropertyNameConstants.ASTRAZENECA:
                        doseTwoDate = new Date(Long.parseLong(answer));
                        difference = TimeUnit.MILLISECONDS.toDays(doseTwoDate.getTime() - doseOneDate.getTime());
                        int numberOfWeeks = (int) Math.floor(difference / 7);
                        if (numberOfWeeks < 4) {
                            return "Dose 2 can't be before 4 weeks of dose 1";
                        } else if (numberOfWeeks > 12) {
                            return "Dose 2 can't be after 12 weeks of dose 1";
                        }
                        break;
                    case RelatedPropertyNameConstants.SINOPHARM:
                        doseTwoDate = new Date(Long.parseLong(answer));
                        difference = TimeUnit.MILLISECONDS.toDays(doseTwoDate.getTime() - doseOneDate.getTime());
                        if (difference < 21) {
                            return "Dose 2 can't be before 21 days of dose 1";
                        } else if (difference > 28) {
                            return "Dose 2 can't be after 28 days of dose 1";
                        }
                        break;
                }
            }
        }
        return null;
    }
}
