package com.argusoft.sewa.android.app.constants;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.util.GlobalTypes;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Created by prateek on 9/26/19
 */
public class NotificationConstants {

    private NotificationConstants() {
        throw new IllegalStateException("Utility Class");
    }

    //Notification States
    public static final String NOTIFICATION_STATE_PENDING = "PENDING";
    public static final String NOTIFICATION_STATE_RESCHEDULE = "RESCHEDULE";

    // Notification for FHW
    public static final String FHW_NOTIFICATION_LMP_FOLLOW_UP = "LMPFU";
    public static final String FHW_NOTIFICATION_ANC = "FHW_ANC";
    public static final String FHW_NOTIFICATION_PNC = "FHW_PNC";
    public static final String FHW_NOTIFICATION_CHILD_SERVICES = "FHW_CS";
    public static final String FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY = "FHW_WPD";
    public static final String FHW_NOTIFICATION_MIGRATION_IN = "MI";
    public static final String FHW_NOTIFICATION_MIGRATION_OUT = "MO";
    public static final String FHW_NOTIFICATION_FAMILY_MIGRATION_IN = "FMI";
    public static final String FHW_NOTIFICATION_FAMILY_MIGRATION_OUT = "FMO";
    public static final String FHW_NOTIFICATION_DISCHARGE = "DISCHARGE";
    public static final String FHW_NOTIFICATION_APPETITE = "APPETITE";
    public static final String FHW_NOTIFICATION_READ_ONLY = "READ_ONLY";
    public static final String FHW_NOTIFICATION_SAM_SCREENING = "SAM_SCREENING";
    public static final String FHW_NOTIFICATION_TT2 = "TT2_ALERT";
    public static final String FHW_NOTIFICATION_IRON_SUCROSE = "IRON_SUCROSE_ALERT";
    public static final String FHW_NOTIFICATION_GERIATRICS_MEDICATION = "GMA";
    public static final String FHW_NOTIFICATION_TRAVELLERS_SCREENING = "TRAVELLERS_SCREENING";
    public static final String FHW_WORK_PLAN_MAMTA_DAY = "MAMTA_DAY";
    public static final String FHW_WORK_PLAN_OTHER_SERVICES = "OTHER_SERVICES";
    public static final String FHW_WORK_PLAN_ASHA_REPORTED_EVENT = "REPORTED_EVENT_BY_ASHA";

    // Notification for ASHA
    public static final String ASHA_NOTIFICATION_READ_ONLY = "ASHA_READ_ONLY";

    //FHW Confirmation of ASHA Reported Events
    public static final String NOTIFICATION_FHW_PREGNANCY_CONF = "FHW_PREG_CONF";
    public static final String NOTIFICATION_FHW_DELIVERY_CONF = "FHW_DELIVERY_CONF";
    public static final String NOTIFICATION_FHW_DEATH_CONF = "FHW_DEATH_CONF";
    public static final String NOTIFICATION_FHW_MEMBER_MIGRATION = "FHW_MEMBER_MIGRATION";
    public static final String NOTIFICATION_FHW_FAMILY_MIGRATION = "FHW_FAMILY_MIGRATION";
    public static final String NOTIFICATION_FHW_FAMILY_SPLIT = "FHW_FAMILY_SPLIT";

    //Notification for NCD Weekly Visit
    public static final String NOTIFICATION_NCD_CLINIC_VISIT = "NCD_CLINIC_VISIT";
    public static final String NOTIFICATION_NCD_HOME_VISIT = "NCD_HOME_VISIT";
    public static final String NOTIFICATION_NCD_RETINOPATHY_TEST = "NCD_RETINOPATHY_TEST";
    public static final String NOTIFICATION_NCD_ECG_TEST = "NCD_ECG_TEST";
    public static final String NOTIFICATION_FP_FOLLOW_UP_VISIT = "FP_FOLLOW_UP_VISIT";
    public static final String NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT = "NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT";

    public static final String FHW_ADOLESCENT_HEALTH_SCREENING = "ADOLESCENT_HEALTH_SCREENING";

    //Notifications for Dnhdd fhw sam screening
    public static final String NUTRITION_NOTIFICATIONS = "NUTRITION_NOTIFICATIONS";
    public static final String SUSPECTED_SAM_FROM_ASHA = "SUSPECTED_SAM_FROM_ASHA";
    public static final String SUSPECTED_MAM_FROM_ASHA = "SUSPECTED_MAM_FROM_ASHA";
    public static final String CMAM_FOR_CONFIRMED_SAM = "CMAM_FOR_CONFIRMED_SAM";
    public static final String CMAM_FOR_CONFIRMED_MAM = "CMAM_FOR_CONFIRMED_MAM";
    public static final String CMAM_FOLLOWUP = "CMAM_FOLLOWUP";
    public static final String DNHDD_APPETITE = "DNHDD_APPETITE";
    public static final String NOTIFICATION_TB_FOLLOW_UP = "TB_FOLLOW_UP_VISIT";
    public static final String NOTIFICATION_ACTIVE_MALARIA = "ACTIVE_MALARIA_FOLLOW_UP_VISIT";
    public static final String NOTIFICATION_NEARBY_MALARIA = "ACTIVE_MALARIA_NEARBY";

    public static final List<String> ASHA_REPORTED_EVENT_NOTIFICATIONS = Collections.unmodifiableList(getAshaReportedEventNotifications());
    public static final List<String> DNHDD_SAM_NOTIFICATIONS = Collections.unmodifiableList(getDnhddFhwSamNotifications());

    private static List<String> getAshaReportedEventNotifications() {
        List<String> stringList = new ArrayList<>();
        if (!BuildConfig.FLAVOR.equalsIgnoreCase(GlobalTypes.FLAVOUR_DNHDD)) {
            stringList.add(NOTIFICATION_FHW_PREGNANCY_CONF);
            stringList.add(NOTIFICATION_FHW_DELIVERY_CONF);
        }
        stringList.add(NOTIFICATION_FHW_DEATH_CONF);
        stringList.add(NOTIFICATION_FHW_MEMBER_MIGRATION);
        stringList.add(NOTIFICATION_FHW_FAMILY_MIGRATION);
        stringList.add(NOTIFICATION_FHW_FAMILY_SPLIT);
        return stringList;
    }

    private static List<String> getDnhddFhwSamNotifications() {
        List<String> stringList = new ArrayList<>();

        stringList.add(FHW_NOTIFICATION_SAM_SCREENING);
        stringList.add(SUSPECTED_SAM_FROM_ASHA);
        stringList.add(SUSPECTED_MAM_FROM_ASHA);
        stringList.add(CMAM_FOR_CONFIRMED_SAM);
        stringList.add(CMAM_FOR_CONFIRMED_MAM);
        stringList.add(CMAM_FOLLOWUP);
//        stringList.add(DNHDD_APPETITE);
        return stringList;
    }
}
