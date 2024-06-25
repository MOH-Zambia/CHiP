package com.argusoft.sewa.android.app.constants;

import com.argusoft.sewa.android.app.R;

import java.util.HashMap;
import java.util.Map;

public class MenuConstants {

    private MenuConstants() {
        throw new IllegalStateException("Utility Class");
    }


    public static final String HOUSE_HOLD_LINE_LIST = "HOUSE_HOLD_LINE_LIST";
    public static final String CBV_NOTIFICATION = "CBV_NOTIFICATION";
    public static final String FHW_HIGH_RISK_WOMEN_AND_CHILD = "FHW_HIGH_RISK_WOMEN_AND_CHILD";
    public static final String FHW_WORK_REGISTER = "FHW_WORK_REGISTER";
    public static final String FHW_WORK_STATUS = "FHW_WORK_STATUS";
    public static final String LEARNING_MANAGEMENT_SYSTEM = "LEARNING_MANAGEMENT_SYSTEM";
    public static final String LMS_PROGRESS_REPORT = "LMS_PROGRESS_REPORT";
    public static final String CBV_MY_PEOPLE = "CBV_MY_PEOPLE";
    public static final String STOCK_MANAGEMENT = "STOCK_MANAGEMENT";
    public static final String ANNOUNCEMENTS = "ANNOUNCEMENTS";
    public static final String LIBRARY = "LIBRARY";
    public static final String WORK_LOG = "WORK_LOG";
    public static final String CBV_WORK_STATUS="CBV_WORK_STATUS";

    private static Map<String, Integer> menuIcons;

    public static Integer getMenuIcons(String constant) {
        if (constant == null)
            return null;

        if (menuIcons == null) {
            menuIcons = new HashMap<>();
            menuIcons.put(HOUSE_HOLD_LINE_LIST, R.drawable.z_fam);
            menuIcons.put(CBV_NOTIFICATION, R.drawable.schedule);
            menuIcons.put(FHW_HIGH_RISK_WOMEN_AND_CHILD, R.drawable.high_risk_mother_child);
            menuIcons.put(LEARNING_MANAGEMENT_SYSTEM, R.drawable.menu_lms);
            menuIcons.put(LMS_PROGRESS_REPORT, R.drawable.menu_lms_report);
            menuIcons.put(CBV_WORK_STATUS, R.drawable.work_status);
            menuIcons.put(WORK_LOG, R.drawable.work_status);
            menuIcons.put(CBV_MY_PEOPLE, R.drawable.z_preg);
            menuIcons.put(STOCK_MANAGEMENT, R.drawable.stock_management);
        }

        if (menuIcons.containsKey(constant.trim())) {
            return menuIcons.get(constant.trim());
        }
        return null;
    }

    public static String getFormCodeFromMenuConstant(String menu) {
        if (menu == null) {
            return null;
        }

        switch (menu) {
           // add form type which requires training here
            default:
                return null;
        }
    }
}
