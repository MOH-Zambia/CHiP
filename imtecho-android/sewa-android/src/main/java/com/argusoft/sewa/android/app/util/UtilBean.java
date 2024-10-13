package com.argusoft.sewa.android.app.util;

import static android.text.Spanned.SPAN_EXCLUSIVE_EXCLUSIVE;
import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.context;

import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.style.BulletSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.core.content.res.ResourcesCompat;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyArrayAdapter;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.FhsConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.NotificationConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.FormulaTagBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.databean.OptionTagBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.LabelBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.morbidities.constants.MorbiditiesConstant;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;

import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import org.joda.time.LocalDateTime;
import org.joda.time.Months;
import org.joda.time.Period;
import org.joda.time.PeriodType;
import org.joda.time.Weeks;
import org.joda.time.Years;
import org.joda.time.format.PeriodFormat;
import org.joda.time.format.PeriodFormatter;

import java.io.File;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collection;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Pattern;

/**
 * @author kelvin
 */
public class UtilBean {

    private UtilBean() {
        throw new IllegalStateException("Utility Class");
    }

    public static MyAlertDialog dialogForExit;

    // Morbidity UtilBean is moved here.
    public static final long MINUTE_LONG_VALUE = (60 * 1000L);
    public static final long HOUR_LONG_VALUE = (MINUTE_LONG_VALUE * 60);
    public static final long DAY_LONG_VALUE = (HOUR_LONG_VALUE * 24);
    public static final long YEAR_LONG_VALUE = (DAY_LONG_VALUE * 365);

    public static final JsonSerializer<Date> JSON_DATE_SERIALIZER = (src, typeOfSrc, context) -> src == null ? null : new JsonPrimitive(src.getTime());

    private static final Map<String, Integer> VACCINATION_SORT_MAP = new HashMap<>();
    private static final Map<String, Integer> Z_VACCINATION_SORT_MAP = new HashMap<>();

    static {
        VACCINATION_SORT_MAP.put(RchConstants.HEPATITIS_B_0, 1);
        VACCINATION_SORT_MAP.put(RchConstants.VITAMIN_K, 2);
        VACCINATION_SORT_MAP.put(RchConstants.BCG, 3);
        VACCINATION_SORT_MAP.put(RchConstants.OPV_0, 4);
        VACCINATION_SORT_MAP.put(RchConstants.OPV_1, 5);
        VACCINATION_SORT_MAP.put(RchConstants.ROTA_VIRUS_1, 6);
        VACCINATION_SORT_MAP.put(RchConstants.PENTA_1, 7);
        VACCINATION_SORT_MAP.put(RchConstants.DPT_1, 8);
        VACCINATION_SORT_MAP.put(RchConstants.F_IPV_1_01, 9);
        VACCINATION_SORT_MAP.put(RchConstants.OPV_2, 10);
        VACCINATION_SORT_MAP.put(RchConstants.ROTA_VIRUS_2, 11);
        VACCINATION_SORT_MAP.put(RchConstants.PENTA_2, 12);
        VACCINATION_SORT_MAP.put(RchConstants.DPT_2, 13);
        VACCINATION_SORT_MAP.put(RchConstants.OPV_3, 14);
        VACCINATION_SORT_MAP.put(RchConstants.ROTA_VIRUS_3, 15);
        VACCINATION_SORT_MAP.put(RchConstants.PENTA_3, 16);
        VACCINATION_SORT_MAP.put(RchConstants.DPT_3, 17);
        VACCINATION_SORT_MAP.put(RchConstants.F_IPV_2_01, 18);
        VACCINATION_SORT_MAP.put(RchConstants.F_IPV_2_05, 19);
        VACCINATION_SORT_MAP.put(RchConstants.MEASLES_RUBELLA_1, 20);
        VACCINATION_SORT_MAP.put(RchConstants.MEASLES_RUBELLA_2, 21);
        VACCINATION_SORT_MAP.put(RchConstants.OPV_BOOSTER, 22);
        VACCINATION_SORT_MAP.put(RchConstants.DPT_BOOSTER, 23);
        VACCINATION_SORT_MAP.put(RchConstants.VITAMIN_A, 24);
    }

    static {
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_BCG, 1);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_50000, 2);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_100000, 3);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_1, 4);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_2, 5);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_3, 6);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_4, 7);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_5, 8);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_6, 9);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_7, 10);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_VITTAMIN_A_200000_8, 11);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_OPV_0, 12);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_OPV_1, 13);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_ROTA_VACCINE_1, 14);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_PCV_1, 15);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_DPT_HEB_HIB_1, 16);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_OPV_2, 17);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_ROTA_VACCINE_2, 18);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_PCV_2, 19);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_OPV_3, 20);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_PCV_3, 21);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_DPT_HEB_HIB_2, 22);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_DPT_HEB_HIB_3, 23);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_OPV_4, 24);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_MEASLES_RUBELLA_1, 25);
        Z_VACCINATION_SORT_MAP.put(RchConstants.Z_MEASLES_RUBELLA_2, 26);
    }

    public static final Comparator<String> VACCINATION_COMPARATOR = (o1, o2) -> {
        Integer one = VACCINATION_SORT_MAP.get(o1);
        Integer two = VACCINATION_SORT_MAP.get(o2);
        if (one != null && two != null) {
            return one.compareTo(two);
        }
        return 0;
    };

    public static final Comparator<String> Z_VACCINATION_COMPARATOR = (o1, o2) -> {
        Integer one = Z_VACCINATION_SORT_MAP.get(o1);
        Integer two = Z_VACCINATION_SORT_MAP.get(o2);
        if (one != null && two != null) {
            return one.compareTo(two);
        }
        return 0;
    };

    public static int getNumberOfYears(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Years.yearsBetween(dateTime1, dateTime2).getYears();
    }


    private static Map<String, String> malnutritionGradeMapBoy;
    private static Map<String, String> malnutritionGradeMapGirl;
    private static Map<String, String> dosageHashTable;
    private static Map<String, String> entityFullFormNames;

    private static Map<String, String> gradeMapForBoysZambia;
    private static Map<String, String> gradeMapForGirlsZambia;


    public static boolean isNotInGivenRange(int givenValue, int lowerBoundary, int upperBoundary) {
        return givenValue > lowerBoundary && givenValue < upperBoundary;
    }

    public static Map<String, String> getMalnutritionGradeMapForBOYS() {
        if (malnutritionGradeMapBoy == null) {
            malnutritionGradeMapBoy = new HashMap<>();
            malnutritionGradeMapBoy.put("0", "2.1~2.5");
            malnutritionGradeMapBoy.put("1", "3.0~3.5");
            malnutritionGradeMapBoy.put("2", "3.8~4.3");
            malnutritionGradeMapBoy.put("3", "4.5~5.0");
            malnutritionGradeMapBoy.put("4", "4.9~5.6");
            malnutritionGradeMapBoy.put("5", "5.3~6.0");
            malnutritionGradeMapBoy.put("6", "5.7~6.4");
            malnutritionGradeMapBoy.put("7", "5.9~6.7");
            malnutritionGradeMapBoy.put("8", "6.2~6.9");
            malnutritionGradeMapBoy.put("9", "6.4~7.1");
            malnutritionGradeMapBoy.put("10", "6.6~7.3");
            malnutritionGradeMapBoy.put("11", "6.8~7.5");
            malnutritionGradeMapBoy.put("12", "6.9~7.7");
            malnutritionGradeMapBoy.put("13", "7.1~7.9");
            malnutritionGradeMapBoy.put("14", "7.2~8.1");
            malnutritionGradeMapBoy.put("15", "7.4~8.2");
            malnutritionGradeMapBoy.put("16", "7.5~8.4");
            malnutritionGradeMapBoy.put("17", "7.6~8.6");
            malnutritionGradeMapBoy.put("18", "7.8~8.8");
            malnutritionGradeMapBoy.put("19", "8.0~8.9");
            malnutritionGradeMapBoy.put("20", "8.1~9.1");
            malnutritionGradeMapBoy.put("21", "8.3~9.2");
            malnutritionGradeMapBoy.put("22", "8.3~9.4");
            malnutritionGradeMapBoy.put("23", "8.4~9.5");
            malnutritionGradeMapBoy.put("24", "8.5~9.7");
            malnutritionGradeMapBoy.put("25", "8.6~9.8");
            malnutritionGradeMapBoy.put("26", "8.8~10.0");
            malnutritionGradeMapBoy.put("27", "9.0~10.1");
            malnutritionGradeMapBoy.put("28", "9.1~10.2");
            malnutritionGradeMapBoy.put("29", "9.2~10.3");
            malnutritionGradeMapBoy.put("30", "9.3~10.5");
            malnutritionGradeMapBoy.put("31", "9.4~10.6");
            malnutritionGradeMapBoy.put("32", "9.5~10.7");
            malnutritionGradeMapBoy.put("33", "9.7~10.9");
            malnutritionGradeMapBoy.put("34", "9.8~11.0");
            malnutritionGradeMapBoy.put("35", "9.9~11.1");
            malnutritionGradeMapBoy.put("36", "10.0~11.3");
            malnutritionGradeMapBoy.put("37", "10.1~11.4");
            malnutritionGradeMapBoy.put("38", "10.2~11.5");
            malnutritionGradeMapBoy.put("39", "10.3~11.6");
            malnutritionGradeMapBoy.put("40", "10.4~11.7");
            malnutritionGradeMapBoy.put("41", "10.5~11.9");
            malnutritionGradeMapBoy.put("42", "10.6~12.0");
            malnutritionGradeMapBoy.put("43", "10.7~12.1");
            malnutritionGradeMapBoy.put("44", "10.8~12.2");
            malnutritionGradeMapBoy.put("45", "10.9~12.3");
            malnutritionGradeMapBoy.put("46", "11.0~12.5");
            malnutritionGradeMapBoy.put("47", "11.1~12.6");
            malnutritionGradeMapBoy.put("48", "11.2~12.7");
            malnutritionGradeMapBoy.put("49", "11.3~12.8");
            malnutritionGradeMapBoy.put("50", "11.4~12.9");
            malnutritionGradeMapBoy.put("51", "11.5~13.0");
            malnutritionGradeMapBoy.put("52", "11.6~13.1");
            malnutritionGradeMapBoy.put("53", "11.7~13.3");
            malnutritionGradeMapBoy.put("54", "11.8~13.4");
            malnutritionGradeMapBoy.put("55", "11.9~13.5");
            malnutritionGradeMapBoy.put("56", "12.0~13.6");
            malnutritionGradeMapBoy.put("57", "12.1~13.7");
            malnutritionGradeMapBoy.put("58", "12.2~13.8");
            malnutritionGradeMapBoy.put("59", "12.3~13.9");
            malnutritionGradeMapBoy.put("60", "12.4~14.1");
        }
        return malnutritionGradeMapBoy;
    }

    public static Map<String, String> getMalnutritionGradeMapForGIRLS() {
        if (malnutritionGradeMapGirl == null) {
            malnutritionGradeMapGirl = new HashMap<>();
            malnutritionGradeMapGirl.put("0", "2.0~2.4");
            malnutritionGradeMapGirl.put("1", "2.7~3.1");
            malnutritionGradeMapGirl.put("2", "3.4~3.9");
            malnutritionGradeMapGirl.put("3", "4.0~4.5");
            malnutritionGradeMapGirl.put("4", "4.4~5.0");
            malnutritionGradeMapGirl.put("5", "4.8~5.4");
            malnutritionGradeMapGirl.put("6", "5.1~5.7");
            malnutritionGradeMapGirl.put("7", "5.3~6.0");
            malnutritionGradeMapGirl.put("8", "5.6~6.4");
            malnutritionGradeMapGirl.put("9", "5.8~6.5");
            malnutritionGradeMapGirl.put("10", "5.9~6.7");
            malnutritionGradeMapGirl.put("11", "6.1~6.9");
            malnutritionGradeMapGirl.put("12", "6.2~7.0");
            malnutritionGradeMapGirl.put("13", "6.4~7.2");
            malnutritionGradeMapGirl.put("14", "6.5~7.4");
            malnutritionGradeMapGirl.put("15", "6.7~7.6");
            malnutritionGradeMapGirl.put("16", "6.8~7.8");
            malnutritionGradeMapGirl.put("17", "7.0~7.9");
            malnutritionGradeMapGirl.put("18", "7.2~8.1");
            malnutritionGradeMapGirl.put("19", "7.3~8.2");
            malnutritionGradeMapGirl.put("20", "7.5~8.4");
            malnutritionGradeMapGirl.put("21", "7.6~8.6");
            malnutritionGradeMapGirl.put("22", "7.7~8.7");
            malnutritionGradeMapGirl.put("23", "7.9~8.9");
            malnutritionGradeMapGirl.put("24", "8.0~9.0");
            malnutritionGradeMapGirl.put("25", "8.2~9.2");
            malnutritionGradeMapGirl.put("26", "8.3~9.4");
            malnutritionGradeMapGirl.put("27", "8.5~9.5");
            malnutritionGradeMapGirl.put("28", "8.6~9.7");
            malnutritionGradeMapGirl.put("29", "8.8~9.8");
            malnutritionGradeMapGirl.put("30", "8.9~10.0");
            malnutritionGradeMapGirl.put("31", "9.0~10.1");
            malnutritionGradeMapGirl.put("32", "9.2~10.3");
            malnutritionGradeMapGirl.put("33", "9.3~10.4");
            malnutritionGradeMapGirl.put("34", "9.4~10.5");
            malnutritionGradeMapGirl.put("35", "9.5~10.7");
            malnutritionGradeMapGirl.put("36", "9.6~10.8");
            malnutritionGradeMapGirl.put("37", "9.7~11.0");
            malnutritionGradeMapGirl.put("38", "9.8~11.1");
            malnutritionGradeMapGirl.put("39", "9.9~11.2");
            malnutritionGradeMapGirl.put("40", "10.0~11.4");
            malnutritionGradeMapGirl.put("41", "10.2~11.5");
            malnutritionGradeMapGirl.put("42", "10.3~11.6");
            malnutritionGradeMapGirl.put("43", "10.4~11.8");
            malnutritionGradeMapGirl.put("44", "10.5~11.9");
            malnutritionGradeMapGirl.put("45", "10.6~12.0");
            malnutritionGradeMapGirl.put("46", "10.7~12.1");
            malnutritionGradeMapGirl.put("47", "10.8~12.2");
            malnutritionGradeMapGirl.put("48", "10.9~12.4");
            malnutritionGradeMapGirl.put("49", "11.0~12.5");
            malnutritionGradeMapGirl.put("50", "11.1~12.6");
            malnutritionGradeMapGirl.put("51", "11.2~12.7");
            malnutritionGradeMapGirl.put("52", "11.3~12.8");
            malnutritionGradeMapGirl.put("53", "11.4~12.9");
            malnutritionGradeMapGirl.put("54", "11.5~13.1");
            malnutritionGradeMapGirl.put("55", "11.6~13.2");
            malnutritionGradeMapGirl.put("56", "11.7~13.3");
            malnutritionGradeMapGirl.put("57", "11.8~13.4");
            malnutritionGradeMapGirl.put("58", "11.9~13.5");
            malnutritionGradeMapGirl.put("59", "12.0~13.1");
            malnutritionGradeMapGirl.put("60", "12.1~13.2");
        }
        return malnutritionGradeMapGirl;
    }

    public static Map<String, String> getMalnutritionGradeForBOYSZambia() {
        if (gradeMapForBoysZambia == null) {
            gradeMapForBoysZambia = new HashMap<>();
            gradeMapForBoysZambia.put("0", "2.0~3.0~4.0~5.0");
            gradeMapForBoysZambia.put("1", "2.0~3.0~4.0~5.0");
            gradeMapForBoysZambia.put("2", "3.0~4.5~6.0~7.0");
            gradeMapForBoysZambia.put("3", "4.0~6.0~7.3~8.0");
            gradeMapForBoysZambia.put("4", "5.0~7.5~9.0~10.2");
            gradeMapForBoysZambia.put("5", "5.0~7.5~9.2~10.3");
            gradeMapForBoysZambia.put("6", "5.5~8.0~10.0~11.0");
            gradeMapForBoysZambia.put("7", "5.8~8.2~10.0~11.2");
            gradeMapForBoysZambia.put("8", "6.0~8.5~10.3~11.5");
            gradeMapForBoysZambia.put("9", "6.2~8.8~10.7~12.0");
            gradeMapForBoysZambia.put("10", "6.5~9.0~11.0~12.3");
            gradeMapForBoysZambia.put("11", "6.8~9.5~11.3~12.6");
            gradeMapForBoysZambia.put("12", "7.1~9.9~11.6~12.9");
            gradeMapForBoysZambia.put("13", "7.3~10.0~11.8~13.3");
            gradeMapForBoysZambia.put("14", "7.3~10.5~12.0~13.5");
            gradeMapForBoysZambia.put("15", "7.5~10.5~12.1~13.9");
            gradeMapForBoysZambia.put("16", "7.5~10.7~12.3~14.1");
            gradeMapForBoysZambia.put("17", "7.7~10.9~12.7~14.4");
            gradeMapForBoysZambia.put("18", "7.9~11.0~13.0~14.6");
            gradeMapForBoysZambia.put("19", "8.0~11.0~13.3~14.9");
            gradeMapForBoysZambia.put("20", "8.1~11.2~13.6~15.3");
            gradeMapForBoysZambia.put("21", "8.1~11.3~13.8~15.6");
            gradeMapForBoysZambia.put("22", "8.2~11.5~14.1~15.8");
            gradeMapForBoysZambia.put("23", "8.3~11.7~14.4~16.2");
            gradeMapForBoysZambia.put("24", "8.3~11.9~14.7~16.5");
            gradeMapForBoysZambia.put("25", "8.5~12.0~15.0~16.9");
            gradeMapForBoysZambia.put("26", "8.5~12.3~15.2~17.2");
            gradeMapForBoysZambia.put("27", "8.7~12.4~15.5~17.6");
            gradeMapForBoysZambia.put("28", "9.0~12.5~15.8~17.9");
            gradeMapForBoysZambia.put("29", "9.1~12.7~16.1~18.0");
            gradeMapForBoysZambia.put("30", "9.3~13.0~16.5~18.3");
            gradeMapForBoysZambia.put("31", "9.3~13.5~17.0~19.0");
            gradeMapForBoysZambia.put("32", "9.4~13.7~17.3~19.2");
            gradeMapForBoysZambia.put("33", "9.5~13.8~17.6~19.4");
            gradeMapForBoysZambia.put("34", "9.6~13.9~17.9~19.7");
            gradeMapForBoysZambia.put("35", "9.7~14.0~18.0~20.0");
            gradeMapForBoysZambia.put("36", "9.9~14.2~18.1~20.2");
            gradeMapForBoysZambia.put("37", "10.1~14.4~18.4~20.4");
            gradeMapForBoysZambia.put("38", "10.2~14.6~18.5~20.8");
            gradeMapForBoysZambia.put("39", "10.3~14.8~18.7~21.0");
            gradeMapForBoysZambia.put("40", "10.5~15.0~18.9~21.4");
            gradeMapForBoysZambia.put("41", "10.6~15.1~19.2~21.6");
            gradeMapForBoysZambia.put("42", "10.7~15.3~19.5~22.0");
            gradeMapForBoysZambia.put("43", "10.8~15.5~19.6~22.5");
            gradeMapForBoysZambia.put("44", "10.9~15.6~19.9~22.7");
            gradeMapForBoysZambia.put("45", "10.9~15.8~20.0~23.0");
            gradeMapForBoysZambia.put("46", "11.0~16.0~20.2~23.5");
            gradeMapForBoysZambia.put("47", "11.1~16.1~20.5~23.8");
            gradeMapForBoysZambia.put("48", "11.2~16.3~20.6~24.0");
            gradeMapForBoysZambia.put("49", "11.3~16.5~20.7~24.2");
            gradeMapForBoysZambia.put("50", "11.5~16.7~20.9~24.5");
            gradeMapForBoysZambia.put("51", "11.6~16.8~21.0~24.8");
            gradeMapForBoysZambia.put("52", "11.6~17.0~21.3~25.3");
            gradeMapForBoysZambia.put("53", "11.7~17.2~21.5~25.7");
            gradeMapForBoysZambia.put("54", "11.9~17.3~21.7~26.0");
            gradeMapForBoysZambia.put("55", "12.0~17.4~21.9~26.5");
            gradeMapForBoysZambia.put("56", "12.1~17.6~22.3~26.9");
            gradeMapForBoysZambia.put("57", "12.2~17.8~22.5~27.3");
            gradeMapForBoysZambia.put("58", "12.3~18.0~22.7~27.7");
            gradeMapForBoysZambia.put("59", "12.5~18.2~22.9~28.2");
            gradeMapForBoysZambia.put("60", "12.5~18.3~23.0~29.2");
        }
        return gradeMapForBoysZambia;
    }

    public static Map<String, String> getMalnutritionGradeForGIRLSZambia() {
        if (gradeMapForGirlsZambia == null) {
            gradeMapForGirlsZambia = new HashMap<>();
            gradeMapForGirlsZambia.put("0", "2.0~3.5~4.5~5.4");
            gradeMapForGirlsZambia.put("1", "2.0~4.5~4.5~5.4");
            gradeMapForGirlsZambia.put("2", "2.9~5.5~6.0~6.3");
            gradeMapForGirlsZambia.put("3", "3.5~6.0~7.0~7.5");
            gradeMapForGirlsZambia.put("4", "4.1~6.5~7.8~8.6");
            gradeMapForGirlsZambia.put("5", "4.5~7.1~8.5~9.5");
            gradeMapForGirlsZambia.put("6", "5.0~7.5~9.0~10.2");
            gradeMapForGirlsZambia.put("7", "5.3~7.8~9.5~10.8");
            gradeMapForGirlsZambia.put("8", "5.5~8.1~9.9~11.3");
            gradeMapForGirlsZambia.put("9", "5.7~8.3~10.4~11.6");
            gradeMapForGirlsZambia.put("10", "5.9~8.5~10.7~12.2");
            gradeMapForGirlsZambia.put("11", "6.0~8.8~11.0~12.5");
            gradeMapForGirlsZambia.put("12", "6.2~8.9~11.3~12.8");
            gradeMapForGirlsZambia.put("13", "6.4~9.0~11.6~13.3");
            gradeMapForGirlsZambia.put("14", "6.5~9.2~12.0~13.6");
            gradeMapForGirlsZambia.put("15", "6.7~9.5~12.2~13.8");
            gradeMapForGirlsZambia.put("16", "6.9~9.7~12.6~14.2");
            gradeMapForGirlsZambia.put("17", "7.0~10.0~12.8~14.6");
            gradeMapForGirlsZambia.put("18", "7.1~10.2~13.0~14.9");
            gradeMapForGirlsZambia.put("19", "7.2~10.5~13.3~15.3");
            gradeMapForGirlsZambia.put("20", "7.5~10.6~13.5~15.6");
            gradeMapForGirlsZambia.put("21", "7.6~10.8~13.8~15.9");
            gradeMapForGirlsZambia.put("22", "7.8~11.0~14.1~16.3");
            gradeMapForGirlsZambia.put("23", "7.9~11.2~14.5~16.5");
            gradeMapForGirlsZambia.put("24", "8.0~11.5~14.7~16.8");
            gradeMapForGirlsZambia.put("25", "8.1~11.7~15.0~17.2");
            gradeMapForGirlsZambia.put("26", "8.3~11.8~15.3~17.5");
            gradeMapForGirlsZambia.put("27", "8.5~12.0~15.6~17.8");
            gradeMapForGirlsZambia.put("28", "8.6~12.2~15.8~18.2");
            gradeMapForGirlsZambia.put("29", "8.7~12.5~16.1~18.5");
            gradeMapForGirlsZambia.put("30", "8.9~12.6~16.4~18.8");
            gradeMapForGirlsZambia.put("31", "9.0~12.8~16.6~19.1");
            gradeMapForGirlsZambia.put("32", "9.1~13.0~17.0~19.4");
            gradeMapForGirlsZambia.put("33", "9.2~13.2~17.2~19.8");
            gradeMapForGirlsZambia.put("34", "9.3~13.5~17.5~20.0");
            gradeMapForGirlsZambia.put("35", "9.4~13.6~17.8~20.4");
            gradeMapForGirlsZambia.put("36", "9.5~13.8~18.0~20.7");
            gradeMapForGirlsZambia.put("37", "9.7~14.0~18.3~21.0");
            gradeMapForGirlsZambia.put("38", "9.8~14.2~18.5~21.3");
            gradeMapForGirlsZambia.put("39", "10.0~14.4~18.8~21.6");
            gradeMapForGirlsZambia.put("40", "10.1~14.6~19.1~22.0");
            gradeMapForGirlsZambia.put("41", "10.2~14.8~19.4~22.4");
            gradeMapForGirlsZambia.put("42", "10.2~15.0~19.6~22.8");
            gradeMapForGirlsZambia.put("43", "10.4~15.1~20.0~23.1");
            gradeMapForGirlsZambia.put("44", "10.5~15.3~20.3~23.5");
            gradeMapForGirlsZambia.put("45", "10.6~15.5~20.5~23.8");
            gradeMapForGirlsZambia.put("46", "10.7~15.7~20.8~24.2");
            gradeMapForGirlsZambia.put("47", "10.8~15.9~21.1~24.6");
            gradeMapForGirlsZambia.put("48", "10.9~16.0~21.5~25.0");
            gradeMapForGirlsZambia.put("49", "11.0~16.1~21.7~25.3");
            gradeMapForGirlsZambia.put("50", "11.0~16.3~22.0~25.6");
            gradeMapForGirlsZambia.put("51", "11.1~16.5~22.3~26.0");
            gradeMapForGirlsZambia.put("52", "11.2~16.8~22.5~26.5");
            gradeMapForGirlsZambia.put("53", "11.3~17.0~22.8~26.8");
            gradeMapForGirlsZambia.put("54", "11.5~17.2~23.1~27.2");
            gradeMapForGirlsZambia.put("55", "11.6~17.4~23.4~27.5");
            gradeMapForGirlsZambia.put("56", "11.7~17.6~23.7~27.9");
            gradeMapForGirlsZambia.put("57", "11.8~17.8~24.0~28.3");
            gradeMapForGirlsZambia.put("58", "11.9~17.9~24.2~28.6");
            gradeMapForGirlsZambia.put("59", "12.0~18.0~24.5~29.0");
            gradeMapForGirlsZambia.put("60", "12.0~18.2~24.8~29.5");
        }
        return gradeMapForGirlsZambia;
    }


    public static String findMalnutritionGrade(String gender, int age, float weight) {
        String malnutritionGrade = GlobalTypes.LOWER_MALNUTRITION_GRADE;

        float lowerBoundaryOfWeight = 0f;
        float upperBoundaryOfWeight = 0f;

        if (gender.equalsIgnoreCase(GlobalTypes.MALE)) {
            String boundaryString = getMalnutritionGradeMapForBOYS().get(String.valueOf(age));
            if (boundaryString != null) {
                int indexOfSeparator = boundaryString.indexOf('~');
                lowerBoundaryOfWeight = Float.parseFloat(boundaryString.substring(0, indexOfSeparator));
                upperBoundaryOfWeight = Float.parseFloat(boundaryString.substring(indexOfSeparator + 1));
            }
        } else {
            String boundaryString = getMalnutritionGradeMapForGIRLS().get(String.valueOf(age));
            if (boundaryString != null) {
                int indexOfSeparator = boundaryString.indexOf('~');
                lowerBoundaryOfWeight = Float.parseFloat(boundaryString.substring(0, indexOfSeparator));
                upperBoundaryOfWeight = Float.parseFloat(boundaryString.substring(indexOfSeparator + 1));
            }
        }
        if (weight >= lowerBoundaryOfWeight) {
            if (weight <= upperBoundaryOfWeight) {
                malnutritionGrade = GlobalTypes.MIDDLE_MALNUTRITION_GRADE;
            } else {
                malnutritionGrade = GlobalTypes.UPPER_MALNUTRITION_GRADE;
            }
        }
        return malnutritionGrade;
    }

    public static String findMalnutritionGradeZambia(String gender, int age, float weight) {
        String malnutritionGrade = GlobalTypes.LOWER_MALNUTRITION_GRADE;

        float lowerBoundaryOfWeight = 0f;
        float midBoundaryOfWeight = 0f;
        float upperBoundaryOfWeight = 0f;
        float higherUpperBoundaryOfWeight = 0f;

        if (CommonUtil.getGenderValueFromAnswer(gender).equalsIgnoreCase(GlobalTypes.MALE)) {
            String boundaryString = getMalnutritionGradeForBOYSZambia().get(String.valueOf(age));
            if (boundaryString != null) {
                String[] weightValues = boundaryString.split("~");
                lowerBoundaryOfWeight = Float.parseFloat(weightValues[0]);
                midBoundaryOfWeight = Float.parseFloat(weightValues[1]);
                upperBoundaryOfWeight = Float.parseFloat(weightValues[2]);
                higherUpperBoundaryOfWeight = Float.parseFloat(weightValues[3]);
            }
        } else {
            String boundaryString = getMalnutritionGradeForGIRLSZambia().get(String.valueOf(age));
            if (boundaryString != null) {
                String[] weightValues = boundaryString.split("~");
                lowerBoundaryOfWeight = Float.parseFloat(weightValues[0]);
                midBoundaryOfWeight = Float.parseFloat(weightValues[1]);
                upperBoundaryOfWeight = Float.parseFloat(weightValues[2]);
                higherUpperBoundaryOfWeight = Float.parseFloat(weightValues[3]);
            }
        }

        if (weight <= lowerBoundaryOfWeight) {
            malnutritionGrade = GlobalTypes.SEVERELY_MALNOURISHED;
        }

        if (weight > lowerBoundaryOfWeight && weight <= midBoundaryOfWeight) {
            malnutritionGrade = GlobalTypes.MALNOURISHED;
        }

        if (weight > midBoundaryOfWeight && weight <= upperBoundaryOfWeight) {
            malnutritionGrade = GlobalTypes.IDEAL;
        }

        if (weight > upperBoundaryOfWeight && weight <= higherUpperBoundaryOfWeight) {
            malnutritionGrade = GlobalTypes.OBESE;
        }

        if (weight > higherUpperBoundaryOfWeight) {
            malnutritionGrade = GlobalTypes.SEVERELY_OBESE;
        }

        return malnutritionGrade;
    }

    /* For displaying weight on diagnosis screen during PNC visit */
    public static String checkWeightForPNCMorbidity(String question, String weight, String loop) {
        if (weight != null && !weight.equals("") && !weight.equals(GlobalTypes.NO_WEIGHT)) {
            if (Float.parseFloat(weight) > 0.0 && Float.parseFloat(weight) < 1.5) {
                return weight;//
            } else {
                /* Consider if no other morbidity of child is detect during this visit*/
                String tmpDataObj = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_CHILD_FIRST_PNC_DONE);
                if (tmpDataObj != null && tmpDataObj.equalsIgnoreCase("false")) {
                    Float newBornWeight = null;
                    String cryStatus;
                    if (Integer.parseInt(loop) == 0) {
                        String prevWeight = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_LAST_WEIGHT);
                        if (prevWeight != null) {
                            newBornWeight = Float.parseFloat(prevWeight);
                        }
                        cryStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.WHEN_DID_BABY_CRY);
                    } else {
                        cryStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.WHEN_DID_BABY_CRY + loop);
                        String prevWeight = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_LAST_WEIGHT + loop);
                        if (prevWeight != null) {
                            newBornWeight = Float.parseFloat(prevWeight);
                        }
                    }
                    if ((newBornWeight != null && newBornWeight >= 2.0 && newBornWeight < 2.5)
                            || (cryStatus != null && cryStatus.equalsIgnoreCase(MorbiditiesConstant.CRY_AFTER_EFFORTS))) {
                        return null;
                    }
                }
                if (SharedStructureData.isEmptyMapAllMorbidities(question, loop)) {
                    return pncWeightCheck(weight, loop);
                }
            }

        }
        return null;
    }

    public static String pncWeightCheck(String weight, String loop) {
        String age;
        Boolean includeWeight = Boolean.FALSE;

        if (Integer.parseInt(loop) == 0) {
            age = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_DOB);
        } else {
            age = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_DOB + loop);
        }

        if (age != null) {
            String[] split = UtilBean.split(age, GlobalTypes.KEY_VALUE_SEPARATOR);
            Long ageOfChild = null;

            if (split.length == 3 && split[0] != null && !split[0].trim().equalsIgnoreCase("") && split[1] != null && !split[1].trim().equalsIgnoreCase("") && split[2] != null && !split[2].trim().equalsIgnoreCase("")) {
                ageOfChild = UtilBean.getMilliSeconds(Integer.parseInt(split[0]), Integer.parseInt(split[1]), Integer.parseInt(split[2]));
            }
            if (Float.parseFloat(weight) >= 1.5 && Float.parseFloat(weight) < 1.999 && ageOfChild != null && ageOfChild <= getMilliSeconds(0, 0, 15)) {
                includeWeight = Boolean.TRUE;
            }
            if (Float.parseFloat(weight) > 0.0 && Float.parseFloat(weight) < 2.1 && ageOfChild != null && ageOfChild >= getMilliSeconds(0, 0, 15) && ageOfChild <= getMilliSeconds(0, 0, 21)) {
                includeWeight = Boolean.TRUE;
            }
            if (Float.parseFloat(weight) > 0.0 && Float.parseFloat(weight) < 2.2 && ageOfChild != null && ageOfChild >= getMilliSeconds(0, 0, 22) && ageOfChild <= getMilliSeconds(0, 0, 27)) {
                includeWeight = Boolean.TRUE;
            }
            if (Float.parseFloat(weight) > 0.0 && Float.parseFloat(weight) < 2.3 && ageOfChild != null && ageOfChild > getMilliSeconds(0, 0, 27)) { /* irrespective of year n month */
                includeWeight = Boolean.TRUE;
            }
        }
        if (Boolean.TRUE.equals(includeWeight)) {
            return weight;
        }
        return null;
    }

    public static void addLBWorAsphyxiaIntoLICForFirstPNC(String loop) {
        String tempDataObj = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_CHILD_FIRST_PNC_DONE);
        if (tempDataObj != null && tempDataObj.equalsIgnoreCase("false")) {
            Float newBornWeight = null;
            String cryStatus;
            if (Integer.parseInt(loop) == 0) {
                String prevWeight = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_LAST_WEIGHT);
                if (prevWeight != null) {
                    newBornWeight = Float.parseFloat(prevWeight);
                }
                cryStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.WHEN_DID_BABY_CRY);
            } else {
                cryStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.WHEN_DID_BABY_CRY + loop);
                String prevWeight = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.CHILD_LAST_WEIGHT + loop);
                if (prevWeight != null) {
                    newBornWeight = Float.parseFloat(prevWeight);
                }
            }
            if ((newBornWeight != null && newBornWeight >= 2.0 && newBornWeight < 2.5)
                    || (cryStatus != null && cryStatus.equalsIgnoreCase(MorbiditiesConstant.CRY_AFTER_EFFORTS))) {
                if (newBornWeight != null && newBornWeight >= 2.0 && newBornWeight < 2.5) {
                    SharedStructureData.addItemInLICList("Birth weight:", newBornWeight.toString(), loop);
                }
                if (cryStatus != null && cryStatus.equalsIgnoreCase(MorbiditiesConstant.CRY_AFTER_EFFORTS)) {
                    SharedStructureData.addItemInLICList("When did the baby cry?", MorbiditiesConstant.getStaticValueAndKeyMap().get(MorbiditiesConstant.CRY_AFTER_EFFORTS), loop);
                }
            }
        }
    }

    public static List<String> getListFromStringBySeparator(String value, String separator) {
        if (value != null && value.trim().length() > 0 && separator != null && separator.trim().length() > 0) {
            return Arrays.asList(split(value.trim(), separator.trim()));
        }
        return new ArrayList<>();
    }

    public static Boolean getBooleanValue(String tOrF) {
        if (tOrF != null) {
            if (tOrF.trim().equalsIgnoreCase(MorbiditiesConstant.TRUE) || tOrF.trim().equalsIgnoreCase("true")) {
                return Boolean.TRUE;
            } else {
                return Boolean.FALSE;
            }
        } else {
            return null;
        }
    }

    public static float fahrenheitToCelsius(float fahrenheit) {
        return ((fahrenheit - 32) * 5) / 9;
    }

    public static List<String> getListOfOptions(List<OptionDataBean> options) {
        List<String> stringOptions = new ArrayList<>();
        if (options != null && !options.isEmpty()) {
            for (OptionDataBean optionTagBean : options) {
                stringOptions.add(optionTagBean.getValue());
            }
        }
        return stringOptions;
    }

    public static List<OptionDataBean> getOptionsOrDataMap(QueFormBean queFormBean, boolean isSpinner) {
        List<OptionDataBean> options = new ArrayList<>();
        OptionDataBean firstOption = new OptionDataBean();
        if (isSpinner) {
            firstOption.setKey("-1");
            firstOption.setValue(GlobalTypes.SELECT);
            options.add(firstOption);
        }

        if (queFormBean.getDatamap() != null && queFormBean.getDatamap().length() > 0) {
            if (queFormBean.getDatamap().equalsIgnoreCase("Countries list")) {
                OptionDataBean withinIndia = new OptionDataBean();
                withinIndia.setKey("0");
                withinIndia.setValue("Within India");
                options.add(withinIndia);
            }

            List<FieldValueMobDataBean> labelDataBeans = UtilBean.getDataMapValues(queFormBean.getDatamap());
            if (labelDataBeans != null && !labelDataBeans.isEmpty()) {
                for (FieldValueMobDataBean labelDataBean : labelDataBeans) {
                    OptionDataBean option = new OptionDataBean();
                    option.setKey(String.valueOf(labelDataBean.getIdOfValue()));
                    option.setValue(labelDataBean.getValue());
                    option.setNext(null);
                    option.setRelatedProperty(null);
                    option.setListOrder(labelDataBean.getListOrder());
                    options.add(option);
                }
            }
        }

        if (queFormBean.getOptions() != null && !queFormBean.getOptions().isEmpty()) {
            for (OptionTagBean optionTagBean : queFormBean.getOptions()) {
                if (optionTagBean.getKey() != null && optionTagBean.getValue() != null) {
                    OptionDataBean option = new OptionDataBean();
                    option.setKey(optionTagBean.getKey());
                    option.setValue(optionTagBean.getValue());
                    option.setNext(optionTagBean.getNext());
                    option.setRelatedProperty(optionTagBean.getRelatedpropertyname());
                    options.add(option);
                    firstOption.setRelatedProperty(option.getRelatedProperty());
                }
            }
        }

        List<FormulaTagBean> formulas = queFormBean.getFormulas();
        if (formulas != null && !formulas.isEmpty()) {
            String formulaValue = formulas.get(0).getFormulavalue();
            String[] split = UtilBean.split(formulaValue, GlobalTypes.KEY_VALUE_SEPARATOR);
            if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_DEFAULT_MIDDLE_NAMES_CBDS)) {
                options.addAll(SharedStructureData.middleNameList);
            } else if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_DEFAULT_MEMBERS_UNDER_20_MS)) {
                options.addAll(SharedStructureData.membersUnderTwenty);
            } else if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_GIVEN_VACCINES_TO_CHILD)) {
                options.addAll(SharedStructureData.givenVaccinesToChild);
            } else if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_MEMBERS_FROM_3_TO_6_YEARS)) {
                options.addAll(SharedStructureData.childrenFrom3To6Years);
            } else if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_BASIC_MEDICINE_LIST)) {
                options.addAll(SharedStructureData.basicMedicineList);
            } else if (Arrays.toString(split).contains(FormulaConstants.FORMULA_SET_DEFAULT_NON_HOF_MEMBER_NAMES_CBDS)) {
                options.addAll(SharedStructureData.nonHofMemberNameList);
            }
        }
        return options;
    }

    public static Map<String, String> convertStringToMap(String input) {
        Map<String, String> resultMap = new HashMap<>();

        // Remove curly braces from the string
        input = input.replaceAll("[{}]", "");

        // Split the string by comma to get key-value pairs
        String[] pairs = input.split(",");

        for (String pair : pairs) {
            // Split each pair by # to get key and value
            String[] keyValue = pair.split(":");

            // Remove quotes from key and value
            String key = keyValue[0].replaceAll("\"", "");
            String value = keyValue[1].replaceAll("\"", "");

            // Add key-value pair to the map
            resultMap.put(key, value);
        }

        return resultMap;
    }

    public static ArrayAdapter<String> createAdapter(List<String> options) {
        MyArrayAdapter myArrayAdapter = new MyArrayAdapter(SharedStructureData.context, R.layout.spinner_item_top, options);
        myArrayAdapter.setDropDownViewResource(R.layout.spinner_item_dropdown);
        return myArrayAdapter;
    }

    public static List<FieldValueMobDataBean> getDataMapValues(String dataMap) {
        if (dataMap != null && dataMap.trim().length() > 0) {
            List<FieldValueMobDataBean> labelDataBeans = SharedStructureData.mapDataMapLabelBean.get(dataMap);
            if (labelDataBeans == null || labelDataBeans.isEmpty()) {
                labelDataBeans = SharedStructureData.sewaService.getFieldValueMobDataBeanByDataMap(dataMap);
            }
            return labelDataBeans;
        }
        return new ArrayList<>();
    }

    public static String getIronFolicAcidTablet(int ageMonths) {
        String dosage = null;
        if (ageMonths > 6 && ageMonths <= 24) {
            dosage = getDosageHashTable().get(GlobalTypes.IRON_FOLIC_ACID_TABLET_DOSAGE_GT_6_MONTHS);
        }
        return dosage;
    }

    private static Map<String, String> getDosageHashTable() {
        if (dosageHashTable == null) {
            dosageHashTable = new HashMap<>();
            dosageHashTable.put(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_LT_4_MONTHS, "200 - 400 ml (2 cups)");
            dosageHashTable.put(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_LT_4_TO_12_MONTHS, "400 - 700 ml (3 cups)");
            dosageHashTable.put(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_GT_12_MONTHS, "700 - 900 ml (5 cups)");
            dosageHashTable.put(GlobalTypes.DIARRHOEA_WO_DEHYDRATION_LT_2_MONTHS, "5 teaspoon of ORS for every episode of diarrohea");
            dosageHashTable.put(GlobalTypes.DIARRHOEA_WO_DEHYDRATION_GT_2_MONTHS, "200 ml of ORS for every episode of diarrohea (1/2 cup)");
            dosageHashTable.put(GlobalTypes.CHLOROQUINE_TABLET_DOSAGE_0_TO_1_YEAR, "1/2 tablet");
            dosageHashTable.put(GlobalTypes.CHLOROQUINE_TABLET_DOSAGE_GT_1_YEAR, "1 tablet");
            dosageHashTable.put(GlobalTypes.PCM_TABLET_DOSAGE_GT_2_MONTHS, "1/4 tablet");
            dosageHashTable.put(GlobalTypes.VITAMIN_A_DOSAGE_6_TO_12_MONTHS, "Vitamin A 1  lac IU");
            dosageHashTable.put(GlobalTypes.VITAMIN_A_DOSAGE_GT_12_MONTHS, "Vitamin A 2 lac IU");
            dosageHashTable.put(GlobalTypes.IRON_FOLIC_ACID_TABLET_DOSAGE_GT_6_MONTHS, "1 tablet daily for 14 days daily");
        }
        return dosageHashTable;
    }

    public static String getPCMTabletDosage(int ageMonths) {
        String dosage = null;
        if (ageMonths > 2 && ageMonths <= 24) {
            dosage = getDosageHashTable().get(GlobalTypes.PCM_TABLET_DOSAGE_GT_2_MONTHS);
        }
        return dosage;
    }

    public static String getDosageForDiarrhoeaWithDehydration(int ageMonths) {
        String dosage = null;
        if (ageMonths <= 4) {
            dosage = getDosageHashTable().get(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_LT_4_MONTHS);
        } else if (ageMonths > 12 && ageMonths <= 24) {
            dosage = getDosageHashTable().get(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_GT_12_MONTHS);
        } else if (ageMonths <= 12) {
            dosage = getDosageHashTable().get(GlobalTypes.DIARRHOEA_WITH_DEHYDRATION_LT_4_TO_12_MONTHS);
        }
        return dosage;
    }

    public static String getDosageForDiarrhoeaWithoutDehydration(int ageMonths) {
        String dosage = null;
        if (ageMonths <= 2) {
            dosage = getDosageHashTable().get(GlobalTypes.DIARRHOEA_WO_DEHYDRATION_LT_2_MONTHS);
        } else if (ageMonths <= 24) {
            dosage = getDosageHashTable().get(GlobalTypes.DIARRHOEA_WO_DEHYDRATION_GT_2_MONTHS);
        }
        return dosage;
    }

    public static String getVitaminADosage(int ageMonths) {
        String dosage = null;
        if (ageMonths > 6 && ageMonths <= 12) {
            dosage = getDosageHashTable().get(GlobalTypes.VITAMIN_A_DOSAGE_6_TO_12_MONTHS);
        } else if (ageMonths > 12) {
            dosage = getDosageHashTable().get(GlobalTypes.VITAMIN_A_DOSAGE_GT_12_MONTHS);
        }
        return dosage;
    }

    public static String getChloroquineTabletDosage(int ageMonths) {
        String dosage;
        if (ageMonths <= 12) {
            dosage = getDosageHashTable().get(GlobalTypes.CHLOROQUINE_TABLET_DOSAGE_0_TO_1_YEAR);
        } else {
            dosage = getDosageHashTable().get(GlobalTypes.CHLOROQUINE_TABLET_DOSAGE_GT_1_YEAR);
        }
        return dosage;
    }

    public static float calculateYearsBetweenDates(long startDate, long endDate) {
        long difference = startDate - endDate;
        return ((float) difference / YEAR_LONG_VALUE);
    }

    public static int calculateMonthsBetweenDates(Date a, Date b) {
        Calendar cal = Calendar.getInstance();
        if (a.before(b)) {
            cal.setTime(a);
        } else {
            cal.setTime(b);
            b = a;
        }
        int c = 0;
        while (cal.getTime().before(b)) {
            cal.add(Calendar.MONTH, 1);
            c++;
        }
        return c - 1;
    }

    public static String setWeightDisplay(String stringToDisplay) {
        if (stringToDisplay != null && stringToDisplay.length() > 0 && stringToDisplay.contains(".")) {
            String[] displayData;
            displayData = split(stringToDisplay, ".");
            if (displayData.length == 2) {
                return displayData[0] + "  Kgs  " + displayData[1] + "00  Gms  ";
            }
        }
        return getMyLabel(GlobalTypes.NOT_AVAILABLE);
    }

    public static int calculateAge(Date dob) {
        // Create a Calendar instance and set it to the birth date
        Calendar dobCalendar = Calendar.getInstance();
        dobCalendar.setTime(dob);

        // Get the current year
        Calendar currentCalendar = Calendar.getInstance();
        int currentYear = currentCalendar.get(Calendar.YEAR);

        // Get the birth year
        int birthYear = dobCalendar.get(Calendar.YEAR);

        // Calculate the age by subtracting the birth year from the current year
        return currentYear - birthYear;
    }

    public static String getMyLabel(String labelString) {
        if (labelString == null || labelString.trim().length() == 0) {
            return labelString;
        }
        String convertedStr = replace(labelString, "[ \n]", "");

        LabelBean labelBean = new LabelBean();
        labelBean.setLabelKey(convertedStr);
        if (SewaTransformer.loginBean != null) {
            labelBean.setLanguage(SewaTransformer.loginBean.getLanguageCode());
        } else {
            labelBean.setLanguage(LabelConstants.ENGLISH_LANGUAGE_CODE); // default language
        }

        if (SharedStructureData.listLabelBeans != null) {
            labelBean = SharedStructureData.listLabelBeans.get(labelBean.getMapIndex());
            if (labelBean != null) {
                return labelBean.getLabelValue();
            }
        }
        return labelString;
    }

    public static boolean isFileExists(String path) {
        if (path != null) {
            try {
                File file = new File(path);
                return file.exists();
            } catch (Exception e) {
                return false;
            }
        }
        return false;
    }

    public static String replace(String actualString, String searchString, String replacementString) {
        return actualString.replaceAll(searchString, replacementString);
    }

    public static String stringListJoin(Collection<String> list, String separator) {
        if (list != null && !list.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                sb.append(item);
            }
            return sb.toString();
        } else {
            return null;
        }
    }

    public static String stringListJoin(List<String> list, String separator, boolean isInternationalise) {
        if (list != null && !list.isEmpty()) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                if (isInternationalise) {
                    sb.append(getMyLabel(item));
                } else {
                    sb.append(item);
                }
            }
            return sb.toString();
        } else {
            return null;
        }
    }

    public static String arrayJoinToString(String[] list, String separator) {
        if (list != null && list.length > 0) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                sb.append(item);
            }
            return sb.toString();
        }
        return null;
    }

    public static String arrayJoinToString(long[] list, String separator) {
        if (list != null && list.length > 0) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (long item : list) {
                if (first) {
                    first = false;
                } else {
                    sb.append(separator);
                }
                sb.append(item);
            }
            return sb.toString();
        }
        return null;
    }

    public static Map<String, String> getFullFormOfEntity() {
        if (entityFullFormNames == null) {
            entityFullFormNames = new HashMap<>();
            entityFullFormNames.put(FormConstants.ANC_MORBIDITY, "ANC Morbidity");
            entityFullFormNames.put(FormConstants.CHILD_CARE_MORBIDITY, "Child Care Morbidity");
            entityFullFormNames.put(FormConstants.PNC_MORBIDITY, "PNC Morbidity");
            //TeCHO FHW FHS
            entityFullFormNames.put(FormConstants.FAMILY_HEALTH_SURVEY, "Family Health Survey");
            entityFullFormNames.put(FormConstants.ADOLESCENT_HEALTH_SCREENING, "Adolescent Health Screening");
            entityFullFormNames.put(FormConstants.CFHC, "Comprehensive Family Health Census");
            entityFullFormNames.put(FormConstants.CAM_FHS, "Family Health Survey");
            entityFullFormNames.put(FormConstants.CAM_ANC, "Ante Natal Care Visit");
            entityFullFormNames.put(FormConstants.CAM_WPD, "Pregnancy Outcome Visit (POV)");
            entityFullFormNames.put(FormConstants.CAM_RIM, "Reproductive Info Modification Visit");
            entityFullFormNames.put(FormConstants.CAM_FHS_MEMBER_UPDATE, "Update Member Information");
            entityFullFormNames.put(FormConstants.HOUSE_HOLD_LINE_LIST, "Household Line List");
            entityFullFormNames.put(FormConstants.HOUSE_HOLD_LINE_LIST_NEW, "Household Line List");
            entityFullFormNames.put(FormConstants.FAMILY_FOLDER, "Family Folder");
            entityFullFormNames.put(FormConstants.FAMILY_FOLDER_MEMBER_UPDATE, "Update Member Information");
            entityFullFormNames.put(FormConstants.LOCKED_FAMILY, "Locked Family");
            entityFullFormNames.put(FormConstants.AADHAR_UPDATION, "Aadhar Updation");
            entityFullFormNames.put(FormConstants.AADHAR_PHONE_UPDATION, "Aadhar and Phone Updation");
            entityFullFormNames.put(FormConstants.PHONE_UPDATION, "Phone Updation");
            entityFullFormNames.put(FormConstants.FHSR_PHONE_UPDATE, "Phone Number Verification");
            entityFullFormNames.put(FormConstants.FHS_ADD_MEMBER, "Add New Member");
            entityFullFormNames.put(FormConstants.FHS_MEMBER_UPDATE, "Update Member Information");
            entityFullFormNames.put(FormConstants.FHS_MEMBER_UPDATE_NEW, "Update Member Information");
            entityFullFormNames.put(FormConstants.MOBILE_NUMBER_VERIFICATION, "Mobile Number Verification");
            //TeCHO FHW RCH
            entityFullFormNames.put(FormConstants.LMP_FOLLOW_UP, "Follow Up");
            entityFullFormNames.put(FormConstants.TECHO_FHW_RIM, "Reproductive Info Modification Visit");
            entityFullFormNames.put(FormConstants.CHIP_FP_FOLLOW_UP, "Family Planning Follow Up Visit");
            entityFullFormNames.put(FormConstants.TECHO_FHW_ANC, "Ante Natal Care Visit");
            entityFullFormNames.put(FormConstants.TECHO_FHW_WPD, "Pregnancy Outcome Visit (POV)");
            entityFullFormNames.put(FormConstants.TECHO_WPD_DISCHARGE, "Discharge Date Entry for WPD");
            entityFullFormNames.put(FormConstants.TECHO_FHW_PNC, "Post Natal Care Visit");
            entityFullFormNames.put(FormConstants.TECHO_FHW_CI, "Child Immunisation Visit");
            entityFullFormNames.put(FormConstants.TECHO_FHW_CS, "Child Services Visit");
            entityFullFormNames.put(FormConstants.TECHO_CS_APPETITE_TEST, "Appetite Test Alert For Child");
            entityFullFormNames.put(FormConstants.TECHO_FHW_VAE, "Vaccine Adverse Effect Visit");
            entityFullFormNames.put(FormConstants.TECHO_MIGRATION_IN, "Migration In");
            entityFullFormNames.put(FormConstants.TECHO_MIGRATION_OUT, "Migration Out");
            entityFullFormNames.put(FormConstants.TECHO_MIGRATION_IN_CONFIRMATION, "Migration In Confirmation");
            entityFullFormNames.put(FormConstants.TECHO_MIGRATION_OUT_CONFIRMATION, "Migration Out Confirmation");
            entityFullFormNames.put(FormConstants.TECHO_MIGRATION_REVERTED, "Reverted Migration");
            entityFullFormNames.put(FormConstants.TECHO_FAMILY_MIGRATION_REVERTED, "Reverted Family Migration");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN, "Migration-in Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT, "Migration-out Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN, "Family Migration-in Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_OUT, "Family Migration-out Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_READ_ONLY, "Read Only Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_TT2, "TT2 Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_IRON_SUCROSE, "Iron Sucrose Alert");
            entityFullFormNames.put(NotificationConstants.FHW_NOTIFICATION_SAM_SCREENING, "SAM Screening");
            entityFullFormNames.put(NotificationConstants.FHW_WORK_PLAN_MAMTA_DAY, "Mamta Day Workplan");
            entityFullFormNames.put(NotificationConstants.FHW_WORK_PLAN_OTHER_SERVICES, "Other Services Workplan");
            entityFullFormNames.put(NotificationConstants.FHW_WORK_PLAN_ASHA_REPORTED_EVENT, "Confirmation of ASHA reported Events");
            entityFullFormNames.put(FormConstants.DNHDD_FHW_SAM_SCREENING, "SAM Screening");
            entityFullFormNames.put(FormConstants.DNHDD_CMAM_FOLLOWUP, "CMAM followup");
            //TeCHO FHW NCD
            entityFullFormNames.put(FormConstants.NCD_FHW_HYPERTENSION, "Hypertension Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_DIABETES, "Diabetes Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_ORAL, "Oral Cancer Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_BREAST, "Breast Cancer Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_CERVICAL, "Cervical Cancer Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_MENTAL_HEALTH, "Mental Health Screening");
            entityFullFormNames.put(FormConstants.NCD_FHW_HEALTH_SCREENING, "Health Screening");
            entityFullFormNames.put(FormConstants.NCD_PERSONAL_HISTORY, "Personal History");
            entityFullFormNames.put(FormConstants.NCD_FHW_DIABETES_CONFIRMATION, "NCD Diabetes Confirmation");
            entityFullFormNames.put(FormConstants.NCD_FHW_WEEKLY_CLINIC, "NCD Weekly Clinic Visit");
            entityFullFormNames.put(FormConstants.NCD_FHW_WEEKLY_HOME, "NCD Weekly Home Visit");
            entityFullFormNames.put(FormConstants.NCD_MO_CONFIRMED, "NCD MO Confirmed Screening");
            entityFullFormNames.put(FormConstants.NCD_URINE_TEST, "NCD Urine Test");
            entityFullFormNames.put(FormConstants.DNHDD_NCD_CBAC_AND_NUTRITION, "CBAC Screening and Nutrition");
            entityFullFormNames.put(FormConstants.DNHDD_NCD_HYPERTENSION_DIABETES_AND_MENTAL_HEALTH, "Hypertension,Diabetes and Mental Health");
            entityFullFormNames.put(FormConstants.CANCER_SCREENING, "Cancer Screening");
            entityFullFormNames.put(FormConstants.ANEMIA_SURVEY, "Anemia Survey");
            entityFullFormNames.put(FormConstants.ANEMIA_PROTOCOL_DEVIATION, "Anemia Protocol Deviation");
            entityFullFormNames.put(FormConstants.ANEMIA_CRF, "Adverse Event Case Report");
            entityFullFormNames.put(FormConstants.NCD_CVC_CLINIC, "NCD CVC Clinic Visit");
            entityFullFormNames.put(FormConstants.NCD_CVC_HOME, "NCD CVC Home Visit");
            entityFullFormNames.put(FormConstants.NCD_RETINOPATHY_TEST, "NCD Retinopathy Test");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_NCD_ECG_TEST, "NCD ECG Test");
            entityFullFormNames.put(FormConstants.DNHDD_ANEMIA_SURVEY, "Anemia Survey");
            entityFullFormNames.put(FormConstants.SICKLE_CELL_SURVEY, "Sickle Cell Survey");
            entityFullFormNames.put(FormConstants.SICKLE_CELL_ADD_FAMILY, "Sickle Cell New Family");
            entityFullFormNames.put(FormConstants.SICKLE_CELL_ADD_NEW_MEMBER, "Sickle Cell New Member");
            entityFullFormNames.put(FormConstants.HU_SURVEY, "Hydroxyurea Survey");
            entityFullFormNames.put(FormConstants.HU_MEDICAL_ASSESSMENT, "Hydroxyurea Medical Assessment");
            entityFullFormNames.put(FormConstants.HU_FOLLOW_UP, "Hydroxyurea Follow Up");
            entityFullFormNames.put(FormConstants.HU_PREG_OUTCOME, "Hydroxyurea Pregnancy Outcome");
            //TeCHO ASHA NCD
            entityFullFormNames.put(FormConstants.NCD_ASHA_CBAC, "NCD CBAC Screening");
            //Techo ASHA RCH
            entityFullFormNames.put(FormConstants.ASHA_LMPFU, "LMP Follow Up Visit");
            entityFullFormNames.put(FormConstants.ASHA_PNC, "Post Natal Care Visit");
            entityFullFormNames.put(FormConstants.ASHA_CS, "Child Services Visit");
            entityFullFormNames.put(FormConstants.ASHA_NPCB, "NPCB Screening");
            entityFullFormNames.put(FormConstants.ASHA_ANC, "Ante Natal Care Visit");
            entityFullFormNames.put(FormConstants.ASHA_WPD, "Work Plan Delivery Visit");
            // Techo ASHA FHS
            entityFullFormNames.put(FormConstants.ASHA_REPORT_FAMILY_MIGRATION, "Report Family Migration");
            entityFullFormNames.put(FormConstants.ASHA_REPORT_FAMILY_SPLIT, "Report Family Split");
            entityFullFormNames.put(FormConstants.ASHA_REPORT_MEMBER_MIGRATION, "Report Member Migration");
            entityFullFormNames.put(FormConstants.ASHA_REPORT_MEMBER_DEATH, "Report Member Death");
            entityFullFormNames.put(FormConstants.ASHA_REPORT_MEMBER_DELIVERY, "Report Member Delivery");

            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_PREGNANCY_CONF, "Pregnancy Confirmation");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_DEATH_CONF, "Death Confirmation");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_DELIVERY_CONF, "Delivery Confirmation");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_MEMBER_MIGRATION, "Process Member Migration");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_FAMILY_MIGRATION, "Process Family Migration");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FHW_FAMILY_SPLIT, "Process Family Split");

            entityFullFormNames.put(NotificationConstants.ASHA_NOTIFICATION_READ_ONLY, "Read Only Alert");

            entityFullFormNames.put(FormConstants.FAMILY_MIGRATION_OUT, "Family Migration OUT");
            entityFullFormNames.put(FormConstants.FAMILY_MIGRATION_IN_CONFIRMATION, "Family Migration IN Confirmation");
            entityFullFormNames.put(FormConstants.TECHO_AWW_CS, "Child Service Visit");
            entityFullFormNames.put(FormConstants.TECHO_AWW_THR, "Take Home Ration");
            entityFullFormNames.put(FormConstants.TECHO_AWW_HEIGHT_GROWTH_GRAPH, "Child Height growth chart");
            entityFullFormNames.put(FormConstants.TECHO_AWW_WEIGHT_GROWTH_GRAPH, "Child Weight growth chart");
            entityFullFormNames.put(FormConstants.TECHO_AWW_DAILY_NUTRITION, "Daily Nutrition");
            entityFullFormNames.put(FormConstants.FHW_SAM_SCREENING_REF, "SAM Screening Referral");
            entityFullFormNames.put(FormConstants.ASHA_SAM_SCREENING, "SAM Screening");
            entityFullFormNames.put(FormConstants.CMAM_FOLLOWUP, "CMAM followup");
            entityFullFormNames.put(FormConstants.FHW_MONTHLY_SAM_SCREENING, "Monthly SAM Screening");
            entityFullFormNames.put(FormConstants.PREGNANCY_STATUS, "Pregnancy Status");
            entityFullFormNames.put(FormConstants.GERIATRICS_MEDICATION_ALERT, "Geriatrics Medication");
            entityFullFormNames.put(FormConstants.TRAVELLERS_SCREENING, "Travellers' Screening");
            entityFullFormNames.put(FormConstants.IDSP_MEMBER, "IDSP MEMBER");
            entityFullFormNames.put(FormConstants.IDSP_MEMBER_2, "Member Surveillance");
            entityFullFormNames.put(FormConstants.IDSP_FAMILY_2, "Family Surveillance");
            entityFullFormNames.put(FormConstants.IDSP_NEW_FAMILY, "Surveillance New Family");
            entityFullFormNames.put(FormConstants.OFFLINE_ABHA_NUMBER_CREATIONS, "Offline ABHA Number Creation");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT, "NCD Home Visit");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT, "NCD Clinic Visit");
            entityFullFormNames.put(FormConstants.CHARDHAM_MEMBER_SCREENING, "Chardham Member Screening");
            entityFullFormNames.put(FormConstants.NCD_ECG_REPORT, "ECG Report");
            entityFullFormNames.put(FormConstants.HIV_POSITIVE, "HIV Positive");
            entityFullFormNames.put(FormConstants.HIV_SCREENING, "HIV Screening");
            entityFullFormNames.put(FormConstants.KNOWN_POSITIVE, "Known Positive");
            entityFullFormNames.put(FormConstants.OCR_KNOWN_POSITIVE, "Known Positive (OCR)");
            entityFullFormNames.put(FormConstants.HIV_SCREENING_FU, "Hiv Screening Followup");
            entityFullFormNames.put(FormConstants.STOCK_MANAGEMENT, "Pharmacy");
            entityFullFormNames.put(FormConstants.EMTCT, "EMTCT");
            entityFullFormNames.put(FormConstants.CHIP_ACTIVE_MALARIA, "Active Malaria");
            entityFullFormNames.put(FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP, "Active Malaria Follow Up");
            entityFullFormNames.put(FormConstants.CHIP_PASSIVE_MALARIA, "Passive Malaria");
            entityFullFormNames.put(FormConstants.MALARIA_NON_INDEX, "Active Malaria Surveillance");
            entityFullFormNames.put(FormConstants.MALARIA_INDEX, "Active Malaria Surveillance");
            entityFullFormNames.put(FormConstants.CHIP_COVID_SCREENING, "Covid-19 Screening");
            entityFullFormNames.put(FormConstants.CHIP_TB, "Tuberculosis Screening");
            entityFullFormNames.put(FormConstants.CHIP_TB_FOLLOW_UP, "Tuberculosis Follow Up Visit");
            entityFullFormNames.put(FormConstants.BCG_VACCINATION_SURVEY, "ADULT BCG VACCINATION SURVEY");
            entityFullFormNames.put(FormConstants.BCG_ELIGIBLE, "BCG Eligible Visit");
            entityFullFormNames.put(FormConstants.CHIP_INDEX_INVESTIGATION, "Entomological Investigation");

            // Dnhdd FHW sam screening notifications
            entityFullFormNames.put(NotificationConstants.NUTRITION_NOTIFICATIONS, "Nutrition notifications");
            entityFullFormNames.put(NotificationConstants.SUSPECTED_SAM_FROM_ASHA, "Suspected SAM");
            entityFullFormNames.put(NotificationConstants.SUSPECTED_MAM_FROM_ASHA, "Suspected MAM");
            entityFullFormNames.put(NotificationConstants.CMAM_FOR_CONFIRMED_SAM, "CMAM for confirmed SAM children");
            entityFullFormNames.put(NotificationConstants.CMAM_FOR_CONFIRMED_MAM, "CMAM for confirmed MAM children");

            //CHIP notifications
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_TB_FOLLOW_UP, "TB Follow Up Visit");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA, "Active Malaria Followup Visits");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT, "Family Planning Followup Visits");
            entityFullFormNames.put(NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT, "HIV Negative Followup Visits");

            entityFullFormNames.put(FormConstants.SURVEILLANCE_PREG_REG, "Pregnancy Registration");
            entityFullFormNames.put(FormConstants.SURVEILLANCE_PREG_OUTCOME, "Pregnancy Outcome Visits");
            entityFullFormNames.put(FormConstants.SURVEILLANCE_CHILD_DEATH, "Child Info. Visit");
            entityFullFormNames.put(FormConstants.SURVEILLANCE_ADD_FAMILY, "Family Survey");
            entityFullFormNames.put(FormConstants.CHIP_GBV_SCREENING, "Gender Based Violence");
            entityFullFormNames.put(FormConstants.OCR_ACTIVE_MALARIA, "Active Malaria (OCR)");
            entityFullFormNames.put(FormConstants.OCR_PASSIVE_MALARIA, "Passive Malaria (OCR)");
            entityFullFormNames.put(FormConstants.OCR_COVID_SCREENING, "Covid Screening (OCR)");
            entityFullFormNames.put(FormConstants.OCR_TB_SCREENING, "TB Screening (OCR)");
            entityFullFormNames.put(FormConstants.OCR_LMPFU, "LMPFU (OCR)");
            entityFullFormNames.put(FormConstants.OCR_FAMILY_PLANNING, "Family Planning (OCR)");
            entityFullFormNames.put(FormConstants.OCR_HIV_POSITIVE, "HIV Positive (OCR)");
            entityFullFormNames.put(FormConstants.OCR_EMTCT, "EMTCT (OCR)");
            entityFullFormNames.put(FormConstants.OCR_ANC, "ANC (OCR)");
            entityFullFormNames.put(FormConstants.OCR_CHILD_HIV_SCREENING, "CHILD HIV SCREENING (OCR)");
            entityFullFormNames.put(FormConstants.OCR_ADULT_HIV_SCREENING, "ADULT HIV SCREENING (OCR)");
            entityFullFormNames.put(FormConstants.OCR_ADD_MEMBER, "Add Member (OCR)");
            entityFullFormNames.put(FormConstants.OCR_UPDATE_MEMBER, "Member Update (OCR)");
            entityFullFormNames.put(FormConstants.OCR_HOUSEHOLD_LINE_LIST, "Add Family (OCR)");
            entityFullFormNames.put(FormConstants.OCR_WPD, "POV (OCR)");
            entityFullFormNames.put(FormConstants.OCR_PNC, "PNC (OCR)");
            entityFullFormNames.put(FormConstants.OCR_CS, "CHILD SERVICE (OCR)");
            entityFullFormNames.put(FormConstants.OCR_GBV, "GBV (OCR)");
            entityFullFormNames.put(FormConstants.OCR_MALARIA_NON_INDEX, "Malaria Non Index Case (OCR)");
            entityFullFormNames.put(FormConstants.OCR_MALARIA_INDEX, "Malaria Index Case (OCR)");
        }
        return entityFullFormNames;
    }

    /**
     * isAlphaNumericWithSpace method checks Whether the String contains
     * ALPHANUMERIC value with space or not.
     *
     * @param string The String which needs to be checked
     * @return true if Given String only contains AlphaNumeric value and space
     * else return false.
     */
    public static boolean isAlphaNumericWithSpace(String string) {
        if (string != null && string.trim().length() > 0) {
            String specialChars = "!~.;-^*:_|@#%+";
            String pattern = ".*[" + Pattern.quote(specialChars) + "].*";
            return !string.matches(pattern);
        }
        return true;
    }

    public static boolean isValidNRCFormat(String string) {
        if (string != null && !string.trim().isEmpty()) {
            String pattern = "^\\d{6}/\\d{2}/[1-3]$";
            return string.matches(pattern);
        }
        return true;
    }

    public static int calculateAge(LocalDate dob) {
        LocalDate currentDate = LocalDate.now();
        if (dob != null) {
            int age = currentDate.getYear() - dob.getYear();
            // If birth date is greater than today's date (in the current year), then subtract one year
            if ((dob.getMonthOfYear() > currentDate.getMonthOfYear()) ||
                    (dob.getMonthOfYear() == currentDate.getMonthOfYear() && dob.getDayOfMonth() > currentDate.getDayOfMonth())) {
                age--;
            }
            return age;
        }
        return -1;
    }


    public static boolean isValidPassportFormat(String string, boolean isInternational) {
        if (string != null && string.trim().length() > 0) {
            String pattern;
            if (isInternational) {
                pattern = "^[a-zA-Z0-9]{4,30}$";
            } else {
                pattern = "^[A-Z]{2}\\d{6}$";
            }
            return string.matches(pattern);
        }
        return true;
    }

    public static boolean isValidBirthCertificateFormat(String string, boolean isInternational) {
        if (string != null && string.trim().length() > 0) {
            String pattern;
            if (isInternational) {
                pattern = "^[A-Za-z0-9]{6,16}$";
            } else {
                pattern = "^[A-Z]{4}/\\d{4}/\\d{4}$";
            }
            return string.matches(pattern);
        }
        return true;
    }

    public static boolean isValidNumber(String validation, float number, float from) {
        if ((validation != null)) {
            if (validation.equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN)) {
                return (number > from);
            } else if (validation.equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN)) {
                return (number < from);
            } else if (validation.equalsIgnoreCase(FormulaConstants.VALIDATION_GREATER_THAN_EQUAL)) {
                return (number >= from);
            } else if (validation.equalsIgnoreCase(FormulaConstants.VALIDATION_LESS_THAN_EQUAL)) {
                return (number <= from);
            } else {
                return false;
            }
        }
        return false;
    }

    public static boolean isFutureDate(long date) {
        if (date > 0) {
            Calendar cal = Calendar.getInstance();
            clearTimeFromDate(cal);
            long today = cal.getTimeInMillis();

            cal.setTimeInMillis(date);
            clearTimeFromDate(cal);
            long enterDate = cal.getTimeInMillis();
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                if (today == enterDate) {
                    return false;
                } else {

                    return today < enterDate;
                }
            }
            return today < enterDate;
        }
        return false;
    }

    public static boolean isPastDate(long date) {
        if (date > 0) {
            Calendar cal = Calendar.getInstance();
            clearTimeFromDate(cal);
            long today = cal.getTimeInMillis();

            cal.setTimeInMillis(date);
            clearTimeFromDate(cal);
            long enterDate = cal.getTimeInMillis();

            return today > enterDate;
        }
        return false;
    }

    public static boolean isToday(long date) {
        if (date > 0) {
            Calendar cal = Calendar.getInstance();
            clearTimeFromDate(cal);
            long today = cal.getTimeInMillis();

            cal.setTimeInMillis(date);
            clearTimeFromDate(cal);
            long enterDate = cal.getTimeInMillis();

            return today == enterDate;
        }
        return false;
    }

    public static Calendar clearTimeFromDate(Calendar today) {
        today.set(Calendar.MILLISECOND, 0);
        today.set(Calendar.SECOND, 0);
        today.set(Calendar.MINUTE, 0);
        today.set(Calendar.HOUR_OF_DAY, 0);
        return today;
    }

    public static Date clearTimeFromDate(Date date) {
        if (date != null) {
            Calendar calendar = Calendar.getInstance();
            calendar.setTime(date);
            calendar.set(Calendar.MILLISECOND, 0);
            calendar.set(Calendar.SECOND, 0);
            calendar.set(Calendar.MINUTE, 0);
            calendar.set(Calendar.HOUR_OF_DAY, 0);

            return calendar.getTime();
        }
        return null;
    }

    public static boolean isDateIn(long date, String[] validationMethod, long customTodayDate) {
        if (date != 0) {
            Calendar enterDate = Calendar.getInstance();
            enterDate.setTimeInMillis(date);
            clearTimeFromDate(enterDate);
            long checkThisDate = enterDate.getTimeInMillis();

            Calendar today = Calendar.getInstance();
            if (customTodayDate > 0) {
                today.setTimeInMillis(customTodayDate);
            }

            clearTimeFromDate(today);
            long todayTime = today.getTimeInMillis();

            int year;
            int month;
            int day;

            if (validationMethod != null && validationMethod.length >= 5) {
                try {
                    year = Integer.parseInt(validationMethod[2]);
                    month = Integer.parseInt(validationMethod[3]);
                    day = Integer.parseInt(validationMethod[4]);
                } catch (Exception e) {
                    year = 0;
                    month = 0;
                    day = 0;
                }
                if (validationMethod[1].equalsIgnoreCase("Sub")) {
                    long minRange = calculateDateMinus(todayTime, year, month, day);
                    return minRange <= checkThisDate && checkThisDate <= todayTime;
                } else if (validationMethod[1].equalsIgnoreCase("Add")) {
                    long maxRange = calculateDatePlus(todayTime, year, month, day);
                    return todayTime <= checkThisDate && checkThisDate <= maxRange;
                }
            }
        }
        return false;
    }

    public static boolean isDateOut(long date, String[] validationMethod, long customTodayDate) {
        if (date != 0) {
            Calendar enterDate = Calendar.getInstance();
            enterDate.setTimeInMillis(date);
            clearTimeFromDate(enterDate);
            long checkThisDate = enterDate.getTimeInMillis();

            Calendar today = Calendar.getInstance();
            if (customTodayDate > 0) {
                today.setTimeInMillis(customTodayDate);
            }

            clearTimeFromDate(today);
            long todayTime = today.getTimeInMillis();

            int year;
            int month;
            int day;
            if (validationMethod != null && validationMethod.length >= 5) {
                try {
                    year = Integer.parseInt(validationMethod[2]);
                    month = Integer.parseInt(validationMethod[3]);
                    day = Integer.parseInt(validationMethod[4]);
                } catch (Exception e) {
                    year = 0;
                    month = 0;
                    day = 0;
                }

                if (validationMethod[1].equalsIgnoreCase("Sub")) {
                    long minRange = calculateDateMinus(todayTime, year, month, day);
                    return minRange >= checkThisDate || checkThisDate > todayTime;
                } else if (validationMethod[1].equalsIgnoreCase("Add")) {
                    long maxRange = calculateDatePlus(todayTime, year, month, day);
                    return todayTime > checkThisDate || checkThisDate >= maxRange;
                }
            }
        }
        return false;
    }

    public static String[] split(String original, String separator) {
        if (original != null) {
            if (separator != null && separator.length() == 1) {
                return original.split("[" + separator + "]");
            } else if (separator != null) {
                return original.split(separator);
            }
        }
        return new String[0];
    }

    //as suggested by mayank sir month is taken as 30 and year is taken as 365 days
    public static long getMilliSeconds(int yearsToMinus, int monthsToMinus, int daysToMinus) {
        return (DAY_LONG_VALUE * ((365L * yearsToMinus) + (30L * monthsToMinus) + (daysToMinus)));
    }

    public static long calculateDatePlus(long enterDate, int years, int months, int days) {
        return addYearsMonthsDays(enterDate, years, months, days);
    }

    public static long calculateDateMinus(long enterDate, int years, int months, int days) {
        return addYearsMonthsDays(enterDate, (-1 * years), (-1 * months), (-1 * days));
    }

    public static long addYearsMonthsDays(long enterDate, int years, int months, int days) {
        Calendar cal = Calendar.getInstance();
        if (enterDate > 0) {
            cal.setTimeInMillis(enterDate);
        }
        clearTimeFromDate(cal);
        if (days != 0) {
            cal.add(Calendar.DAY_OF_MONTH, (days));
        }
        if (months != 0) {
            cal.add(Calendar.MONTH, (months));
        }
        if (years != 0) {
            cal.add(Calendar.YEAR, (years));
        }
        return cal.getTimeInMillis();
    }

    // for gestationalWeek no=7 (it will return week)
    // else no=1 (it will return no of day)
    public static int noOfDayFromDate(long date, int no) {
        Calendar calendar = Calendar.getInstance();
        clearTimeFromDate(calendar);
        long difference = calendar.getTimeInMillis() - date;
        return (int) (difference / (DAY_LONG_VALUE * no));
    }

    /**
     * function to convert date to string
     *
     * @param date             Date which is to be converted in string
     * @param displayTime      If displayTime is true, time is merged to return
     * @param displayMonthName If displayMonthName is true, month name is
     *                         displayed instead of number string. time is in 12 hour format
     * @param displayYear      If displayYear is true, Year will be displayed
     * @return returns the date in format mm/dd/yyyy hh:mm [am/pm]
     */
    public static String convertDateToString(long date, boolean displayTime, boolean displayMonthName, boolean displayYear) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(date);
        String day = Integer.toString(cal.get(Calendar.DAY_OF_MONTH));
        if (day.length() == 1) {
            day = "0" + day;
        }
        StringBuilder dateString = new StringBuilder(day);
        if (displayMonthName) {
            dateString.append(" ");
        } else {
            dateString.append(GlobalTypes.DATE_STRING_SEPARATOR);
        }

        String month = Integer.toString((cal.get(Calendar.MONTH) + 1));
        if (month.length() == 1) {
            month = "0" + month;
        }
        if (displayMonthName) {
            switch (month) {
                case "01":
                    month = GlobalTypes.MONTH_JANUARY;
                    break;
                case "02":
                    month = GlobalTypes.MONTH_FEBRUARY;
                    break;
                case "03":
                    month = GlobalTypes.MONTH_MARCH;
                    break;
                case "04":
                    month = GlobalTypes.MONTH_APRIL;
                    break;
                case "05":
                    month = GlobalTypes.MONTH_MAY;
                    break;
                case "06":
                    month = GlobalTypes.MONTH_JUNE;
                    break;
                case "07":
                    month = GlobalTypes.MONTH_JULY;
                    break;
                case "08":
                    month = GlobalTypes.MONTH_AUGUST;
                    break;
                case "09":
                    month = GlobalTypes.MONTH_SEPTEMBER;
                    break;
                case "10":
                    month = GlobalTypes.MONTH_OCTOBER;
                    break;
                case "11":
                    month = GlobalTypes.MONTH_NOVEMBER;
                    break;
                case "12":
                    month = GlobalTypes.MONTH_DECEMBER;
                    break;
                default:
            }
        }
        if (displayMonthName) {
            dateString.append(getMyLabel(month.substring(0, 3)));
            dateString.append(", ");
        } else {
            dateString.append(getMyLabel(month));
            dateString.append(GlobalTypes.DATE_STRING_SEPARATOR);
        }
        if (displayYear) {
            dateString.append(cal.get(Calendar.YEAR));
        }
        if (displayTime) {
            String min = Integer.toString(cal.get(Calendar.MINUTE));
            if (min.length() == 1) {
                min = "0" + min;
            }

            String hour = Integer.toString(cal.get(Calendar.HOUR));
            if (hour.length() == 1) {
                if (hour.equals("0") && cal.get(Calendar.AM_PM) == Calendar.PM) {
                    hour = "12";
                } else {
                    hour = "0" + hour;
                }
            }
            dateString.append(" ").append(hour).append(":").append(min).append(" ").append((cal.get(Calendar.AM_PM) == Calendar.AM ? "AM" : "PM"));
        }
        return dateString.toString();
    }

    public static int[] calculateAgeYearMonthDay(long dateDiff) {
        LocalDate dob = new LocalDate(dateDiff);
        LocalDate date = new LocalDate();

        Period period = new Period(dob, date, PeriodType.yearMonthDay());
        return new int[]{period.getYears(), period.getMonths(), period.getDays()};
    }


    //This method calculate age up to mentioned date
    public static int[] calculateAgeYearMonthDayOnGivenDate(Long dobDate, Long givenDate) {
        if (dobDate != null && givenDate != null && dobDate.compareTo(givenDate) <= 0) {
            LocalDate dob = new LocalDate(dobDate);
            LocalDate mentionedDate = new LocalDate(givenDate);

            Period period = new Period(dob, mentionedDate, PeriodType.yearMonthDay());
            return new int[]{period.getYears(), period.getMonths(), period.getDays()};
        }
        return new int[]{0, 0, 0};
    }

    public static int[] calculateMonthOnGivenDate(Long dobDate, Long givenDate) {
        if (dobDate != null && givenDate != null && dobDate.compareTo(givenDate) <= 0) {
            LocalDate dob = new LocalDate(dobDate);
            LocalDate mentionedDate = new LocalDate(givenDate);

            Period period = new Period(dob, mentionedDate, PeriodType.yearMonthDay());
            return new int[]{period.getMonths()};
        }
        return new int[]{0};
    }



    public static int calculateMonthsBetweenDates(Long dobDate, Long givenDate) {
        if (dobDate != null && givenDate != null && dobDate.compareTo(givenDate) <= 0) {
            // Convert milliseconds to LocalDate
            LocalDate dob = new LocalDate(dobDate);
            LocalDate mentionedDate = new LocalDate(givenDate);

            int yearsDifference = mentionedDate.getYear() - dob.getYear();
            int monthsDifference = mentionedDate.getMonthOfYear() - dob.getMonthOfYear();

            return yearsDifference * 12 + monthsDifference;
        }
        return 0; // Return 0 if dates are invalid or startDate is after endDate
    }



    public static int[] calculateWeekDaysGapBetweenDates(Long beforeDate, Long afterDate) {
        DateTime dateTime1 = new DateTime(beforeDate);
        DateTime dateTime2 = new DateTime(afterDate);

        int totalDays = Days.daysBetween(dateTime1, dateTime2).getDays() + 1;
        int weeks = 0;
        int days = 0;
        if (totalDays > 0) {
            weeks = totalDays / 7;
            days = totalDays % 7;
        }
        return new int[]{weeks, days};
    }

    public static String getAgeDisplay(int yr, int month, int day) {
        StringBuilder str = new StringBuilder();
        if (yr == 1) {
            str.append(yr).append(" ").append(getMyLabel(GlobalTypes.YEAR)).append(" ");
        }
        if (yr > 1) {
            str.append(yr).append(" ").append(getMyLabel(GlobalTypes.YEAR)).append("s ");
        }
        if (month == 1) {
            str.append(month).append(" ").append(getMyLabel(GlobalTypes.MONTH)).append(" ");
        }
        if (month > 1) {
            str.append(month).append(" ").append(getMyLabel(GlobalTypes.MONTH)).append("s ");
        }
        if (day == 1) {
            str.append(day).append(" ").append(getMyLabel(GlobalTypes.DAY)).append(" ");
        }
        if (day > 1) {
            str.append(day).append(" ").append(getMyLabel(GlobalTypes.DAY)).append("s ");
        }
        if (day == 0 && month == 0 && yr == 0) {
            str.append(getMyLabel("Born today"));
        }
        if (str.length() > 0) {
            return str.toString();
        }
        return null;
    }

    public static String getAgeDisplayOnGivenDate(Date dobDate, Date givenDate) {
        if (dobDate != null && givenDate != null && dobDate.compareTo(givenDate) <= 0) {
            LocalDate dob = new LocalDate(dobDate);
            LocalDate mentionedDate = new LocalDate(givenDate);

            Period period = new Period(dob, mentionedDate, PeriodType.yearMonthDay());

            StringBuilder str = new StringBuilder();
            if (period.getYears() == 1) {
                str.append(period.getYears()).append(" ").append(getMyLabel(GlobalTypes.YEAR)).append(" ");
            }
            if (period.getYears() > 1) {
                str.append(period.getYears()).append(" ").append(getMyLabel(GlobalTypes.YEAR)).append("s ");
            }
            if (period.getMonths() == 1) {
                str.append(period.getMonths()).append(" ").append(getMyLabel(GlobalTypes.MONTH)).append(" ");
            }
            if (period.getMonths() > 1) {
                str.append(period.getMonths()).append(" ").append(getMyLabel(GlobalTypes.MONTH)).append("s ");
            }
            if (period.getDays() == 1) {
                str.append(period.getDays()).append(" ").append(getMyLabel(GlobalTypes.DAY)).append(" ");
            }
            if (period.getDays() > 1) {
                str.append(period.getDays()).append(" ").append(getMyLabel(GlobalTypes.DAY)).append("s ");
            }
            if (period.getDays() == 0 && period.getMonths() == 0 && period.getYears() == 0) {
                str.append(getMyLabel("Born today"));
            }
            if (str.length() > 0) {
                return str.toString();
            }
        }
        return null;
    }

    public static int getDpsAccordingScreenHeight(Context context, int percentage) {
        if (context != null) {
            return (int) ((context.getResources().getDisplayMetrics().heightPixels) * (percentage / 100.0));
        }
        return percentage;
    }

    public static int getDpsAccordingScreenWidthHeight(Context context, float factor) {
        if (context != null) {
            return (int) ((context.getResources().getDisplayMetrics().xdpi + context.getResources().getDisplayMetrics().ydpi) * (factor / 100));
        }
        return (int) factor;
    }

    public static String getLastUpdatedTime(long aLong) {
        Calendar lastUpdate = Calendar.getInstance();
        lastUpdate.setTimeInMillis(aLong);
        clearTimeFromDate(lastUpdate);
        Calendar currentDay = Calendar.getInstance();
        clearTimeFromDate(currentDay);
        String returnValue = " " + getMyLabel("Last Updated Time :") + " ";
        if (lastUpdate.getTimeInMillis() == currentDay.getTimeInMillis()) {
            lastUpdate.setTimeInMillis(aLong);
            return returnValue + getMyLabel("Today") + new SimpleDateFormat("(hh:mm a)", Locale.getDefault()).format(lastUpdate.getTime());
        }
        currentDay.add(Calendar.DAY_OF_MONTH, -1);
        if (lastUpdate.getTimeInMillis() == currentDay.getTimeInMillis()) {
            lastUpdate.setTimeInMillis(aLong);
            return returnValue + getMyLabel("Yesterday") + new SimpleDateFormat("(hh:mm a)", Locale.getDefault()).format(lastUpdate.getTime());
        }
        lastUpdate.setTimeInMillis(aLong);
        if (aLong > 0) {
            return returnValue + new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT + " hh:mm a", Locale.getDefault()).format(lastUpdate.getTime());
        } else {
            return returnValue + UtilBean.getMyLabel("Not updated till now");
        }
    }

    public static void deleteFile(String filePath) {
        try {
            File file = new File(filePath);
            file.delete();
        } catch (Exception e) {
            Log.e("UtilBean", "File " + filePath + " is not deleted", e);
        }
    }

    public static Date getDateAfterNoOfDays(Date date, int noOfDays) {
        Calendar dateCal = Calendar.getInstance();
        if (date != null) {
            dateCal.setTime(date);
            dateCal.set(Calendar.DAY_OF_MONTH, dateCal.get(Calendar.DAY_OF_MONTH) + noOfDays);
        }
        return dateCal.getTime();
    }

    public static int getNumberOfMonths(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Months.monthsBetween(dateTime1, dateTime2).getMonths();
    }

    public static int getNumberOfWeeks(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Weeks.weeksBetween(dateTime1, dateTime2).getWeeks();
    }

    public static int getNumberOfDays(Date fromDate, Date toDate) {
        DateTime dateTime1 = new DateTime(fromDate);
        DateTime dateTime2 = new DateTime(toDate);

        return Days.daysBetween(dateTime1, dateTime2).getDays() + 1;
    }

    public static TextView getMembersListForDisplay(Context context, FamilyDataBean familyDataBeanDefault) {
        FamilyDataBean familyDataBean = SharedStructureData.currentFamilyDataBean;
        if (familyDataBeanDefault != null) {
            familyDataBean = familyDataBeanDefault;
        }

        MaterialTextView textView = new MaterialTextView(context, null, R.style.CustomAnswerView);
        textView.setPadding(0, 0, 0, 15);

        if (familyDataBean == null || familyDataBean.getMembers() == null || familyDataBean.getMembers().isEmpty()) {
            textView.setText(String.format("%s!", UtilBean.getMyLabel("No members registered in the family")));
            return textView;
        }

        int count = familyDataBean.getMembers().size();
        for (MemberDataBean memberDataBean : familyDataBean.getMembers()) {
            String stringBuilder = memberDataBean.getUniqueHealthId() + " - " + UtilBean.getMemberFullName(memberDataBean);

            String replace = stringBuilder.replace(" null", "");
            replace = replace.replace("null ", "");
            replace = replace.trim();

            Spannable word = new SpannableString(replace);
            word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.detailsTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);

            Typeface typeface = ResourcesCompat.getFont(context, R.font.roboto_bold);
            if (typeface != null) {
                word.setSpan(new StyleSpan(typeface.getStyle()), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            if (memberDataBean.getFamilyHeadFlag() != null && memberDataBean.getFamilyHeadFlag()) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.hofTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            } else if (memberDataBean.getGender() != null && memberDataBean.getGender().equals(GlobalTypes.FEMALE)
                    && Boolean.TRUE.equals(memberDataBean.getIsPregnantFlag())) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.pregnantWomenTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            } else if (memberDataBean.getDob() != null && calculateAgeYearMonthDay(memberDataBean.getDob())[0] < 5) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.childrenTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            if (memberDataBean.getState() != null && (memberDataBean.getState().equalsIgnoreCase(FhsConstants.CFHC_MEMBER_STATE_DEAD) || memberDataBean.getState().equalsIgnoreCase("com.argusoft.imtecho.member.state.dead"))) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.deadTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            count--;
            textView.append(word);
            if (count != 0) {
                textView.append("\n");
            }
        }
        return textView;
    }

    public static LinearLayout getMembersListForDisplay(Context context, FamilyDataBean familyDataBeanDefault, View.OnClickListener onClickListener) {
        FamilyDataBean familyDataBean = SharedStructureData.currentFamilyDataBean;
        if (familyDataBeanDefault != null) {
            familyDataBean = familyDataBeanDefault;
        }

        LinearLayout layout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        MaterialTextView noRecordTextView = new MaterialTextView(context, null, R.style.CustomAnswerView);
        noRecordTextView.setPadding(0, 0, 0, 15);

        if (familyDataBean == null || familyDataBean.getMembers() == null || familyDataBean.getMembers().isEmpty()) {
            noRecordTextView.setText(String.format("%s!", UtilBean.getMyLabel("No members registered in the family")));
            layout.addView(noRecordTextView);
            return layout;
        }

        for (MemberDataBean memberDataBean : familyDataBean.getMembers()) {
            MaterialTextView textView = new MaterialTextView(context, null, R.style.CustomAnswerView);
            textView.setId(IdConstants.MEMBER_TEXTVIEW_ID);
            textView.setPadding(0, 20, 0, 20);
            textView.setTextSize(16);
            textView.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            String stringBuilder;
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                if (memberDataBean.getState() != null && (memberDataBean.getState().equalsIgnoreCase(FhsConstants.CFHC_MEMBER_STATE_DEAD) || memberDataBean.getState().equalsIgnoreCase("com.argusoft.imtecho.member.state.dead"))) {
                    stringBuilder = memberDataBean.getUniqueHealthId() + " - " + UtilBean.getMemberFullName(memberDataBean) + " | " + memberDataBean.getGender() + " (Deceased)";
                } else {
                    stringBuilder = memberDataBean.getUniqueHealthId() + " - " + UtilBean.getMemberFullName(memberDataBean) + " | " + memberDataBean.getGender();
                }
            } else {
                stringBuilder = memberDataBean.getUniqueHealthId() + " - " + UtilBean.getMemberFullName(memberDataBean) + " | " + memberDataBean.getGender();
            }

            String replace = stringBuilder.replace(" null", "");
            replace = replace.replace("null ", "");
            replace = replace.trim();

            Spannable word = new SpannableString(replace);
            word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.black)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);

            Typeface typeface = ResourcesCompat.getFont(context, R.font.roboto_bold);
            if (typeface != null) {
                word.setSpan(new StyleSpan(typeface.getStyle()), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            if (memberDataBean.getFamilyHeadFlag() != null && memberDataBean.getFamilyHeadFlag()) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.hofTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            } else if (memberDataBean.getGender() != null && memberDataBean.getGender().equals(GlobalTypes.FEMALE)
                    && Boolean.TRUE.equals(memberDataBean.getIsPregnantFlag())) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.pregnantWomenTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            } else if (memberDataBean.getDob() != null && calculateAgeYearMonthDay(memberDataBean.getDob())[0] < 5) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.childrenTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            if (memberDataBean.getState() != null && (memberDataBean.getState().equalsIgnoreCase(FhsConstants.CFHC_MEMBER_STATE_DEAD) || memberDataBean.getState().equalsIgnoreCase("com.argusoft.imtecho.member.state.dead"))) {
                word.setSpan(new ForegroundColorSpan(ContextCompat.getColor(context, R.color.deadTextColor)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
            }

            LinearLayout imageLayout = new LinearLayout(context);
            imageLayout.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT));
            imageLayout.setOrientation(LinearLayout.HORIZONTAL);
            if (memberDataBean.isAadharUpdated() == true) {
                ImageView aadharIcon = new ImageView(context);
                aadharIcon.setImageResource(R.drawable.ic_tab_aadhar_card);
                imageLayout.addView(aadharIcon);
            }
            /*if (memberDataBean.getMobileNumber() != null) {
                ImageView smartphoneIcon = new ImageView(context);
                smartphoneIcon.setImageResource(R.drawable.ic_tab_smartphone);
                imageLayout.addView(smartphoneIcon);
            }*/
            if (imageLayout.getChildCount() > 0) {
                imageLayout.measure(View.MeasureSpec.UNSPECIFIED, View.MeasureSpec.UNSPECIFIED);
                imageLayout.layout(0, 0, imageLayout.getMeasuredWidth(), imageLayout.getMeasuredHeight());
                imageLayout.setDrawingCacheEnabled(true);
                imageLayout.buildDrawingCache();
                Bitmap bitmap = Bitmap.createBitmap(imageLayout.getDrawingCache());
                imageLayout.setDrawingCacheEnabled(false);
                Drawable drawable = new BitmapDrawable(context.getResources(), bitmap);
                drawable.setBounds(0, 0, drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight());

                textView.setCompoundDrawablesWithIntrinsicBounds(null, null, drawable, null);
            }
            textView.setCompoundDrawablePadding(15);
            textView.append(word);
            textView.setTag(memberDataBean);
            textView.setOnClickListener(onClickListener);
            layout.addView(textView);
        }
        return layout;
    }

    public static TextView getMemberFullNameForDisplay(Context context) {
        FamilyDataBean familyDataBean = SharedStructureData.currentFamilyDataBean;

        MaterialTextView textView = new MaterialTextView(context);
        textView.setTextAppearance(context, R.style.CustomAnswerView);

        if (familyDataBean != null) {
            for (MemberDataBean memberDataBean : familyDataBean.getMembers()) {

                if (memberDataBean.getUniqueHealthId().equals(SharedStructureData.currentMemberUHId)) {
                    String stringBuilder = UtilBean.getMemberFullName(memberDataBean);

                    String replace = stringBuilder.replace(" null", "");
                    replace = replace.replace("null ", "");
                    replace = replace.trim();

                    Spannable word = new SpannableString(replace);

                    if (memberDataBean.getFamilyHeadFlag() != null && memberDataBean.getFamilyHeadFlag()) {
                        word.setSpan(new ForegroundColorSpan(Color.rgb(48, 112, 6)), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
                    } else if (memberDataBean.getGender() != null && memberDataBean.getGender().equals(GlobalTypes.FEMALE)
                            && (memberDataBean.getIsPregnantFlag() != null && memberDataBean.getIsPregnantFlag())) {
                        word.setSpan(new ForegroundColorSpan(Color.RED), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
                    } else if (memberDataBean.getDob() != null && calculateAgeYearMonthDay(memberDataBean.getDob())[0] < 5) {
                        word.setSpan(new ForegroundColorSpan(Color.BLUE), 0, word.length(), SPAN_EXCLUSIVE_EXCLUSIVE);
                    }

                    textView.append(word);
                }
            }
        }
        return textView;
    }

    public static String getMemberFullName(MemberBean memberBean) {
        StringBuilder sb = new StringBuilder();
        if (memberBean.getFirstName() != null) {
            sb.append(memberBean.getFirstName());
        }
        if (memberBean.getMiddleName() != null) {
            sb.append(" ");
            sb.append(memberBean.getMiddleName());
        }
        if (memberBean.getLastName() != null) {
            sb.append(" ");
            sb.append(memberBean.getLastName());
        }
        if (sb.length() > 0) {
            return sb.toString();
        } else {
            return "";
        }
    }

    public static String getMemberFullName(MemberDataBean memberBean) {
        StringBuilder sb = new StringBuilder();
        if (memberBean.getFirstName() != null) {
            sb.append(memberBean.getFirstName());
        }
        if (memberBean.getMiddleName() != null) {
            sb.append(" ");
            sb.append(memberBean.getMiddleName());
        }
        if (memberBean.getLastName() != null) {
            sb.append(" ");
            sb.append(memberBean.getLastName());
        }
        if (sb.length() > 0) {
            return sb.toString();
        } else {
            return "";
        }
    }

    public static String getMemberFullNameWithGrandFatherName(MemberDataBean memberBean) {
        StringBuilder sb = new StringBuilder();
        if (memberBean.getFirstName() != null) {
            sb.append(memberBean.getFirstName());
        }
        if (memberBean.getMiddleName() != null) {
            sb.append(" ");
            sb.append(memberBean.getMiddleName());
        }
        if (memberBean.getGrandfatherName() != null) {
            sb.append(" ");
            sb.append(memberBean.getGrandfatherName());
        }
        if (memberBean.getLastName() != null) {
            sb.append(" ");
            sb.append(memberBean.getLastName());
        }
        if (sb.length() > 0) {
            return sb.toString();
        } else {
            return "";
        }
    }

    public static String convertLatLngToPlusCode(double latitude, double longitude, int codeLength) {
        try {
            return OpenLocationCode.encode(latitude, longitude, codeLength);
        } catch (IllegalArgumentException e) {
            return e.getMessage();
        }
    }

    public static Bitmap getBitmapFromView(View view) {
        //Define a bitmap with the same size as the view
        Bitmap returnedBitmap = Bitmap.createBitmap(view.getWidth(), view.getHeight(), Bitmap.Config.ARGB_8888);
        //Bind a canvas to it
        Canvas canvas = new Canvas(returnedBitmap);
        //Get the view's background
        Drawable bgDrawable = view.getBackground();
        if (bgDrawable != null)
            //has background drawable, then draw it on the canvas
            bgDrawable.draw(canvas);
        else
            //does not have background drawable, then draw white background on the canvas
            canvas.drawColor(Color.WHITE);
        // draw the view on the canvas
        view.draw(canvas);
        //return the bitmap
        return returnedBitmap;
    }

    public static String getFamilyFullAddress(FamilyDataBean familyDataBean) {
        StringBuilder stringBuilder = new StringBuilder();
        if (familyDataBean.getAddress1() != null || familyDataBean.getAddress2() != null) {
            if (familyDataBean.getAddress1() != null) {
                stringBuilder.append(familyDataBean.getAddress1());
                if (familyDataBean.getAddress2() != null) {
                    stringBuilder.append(" ");
                    stringBuilder.append(familyDataBean.getAddress2());
                }
            } else {
                if (familyDataBean.getAddress2() != null) {
                    stringBuilder.append(familyDataBean.getAddress2());
                }
            }
        } else {
            stringBuilder.append(UtilBean.getMyLabel(GlobalTypes.NOT_AVAILABLE));
        }
        return stringBuilder.toString();
    }

    public static String getFamilyFullAddress(FamilyBean familyDataBean) {
        StringBuilder stringBuilder = new StringBuilder();
        if (familyDataBean.getAddress1() != null || familyDataBean.getAddress2() != null) {
            if (familyDataBean.getAddress1() != null) {
                stringBuilder.append(familyDataBean.getAddress1());
                if (familyDataBean.getAddress2() != null) {
                    stringBuilder.append(" ");
                    stringBuilder.append(familyDataBean.getAddress2());
                }
            } else {
                if (familyDataBean.getAddress2() != null) {
                    stringBuilder.append(familyDataBean.getAddress2());
                }
            }
        } else {
            stringBuilder.append(UtilBean.getMyLabel(GlobalTypes.NOT_AVAILABLE));
        }
        return stringBuilder.toString();
    }


    public static String getTitleText(String title) {
        return UtilBean.getMyLabel(title);
    }

    public static String calculateBmi(Integer height, Float weight) {
        if (height != null && height > 0 && weight != null && weight > 0) {
            float heightInMetres = height / 100f;

            float bmi = weight / heightInMetres;
            bmi = bmi / heightInMetres;
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.ACTUAL_BMI_VALUE, String.valueOf(bmi));
            if (bmi <= 18f) {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_BMI_LE_18, "F");
            } else {
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_BMI_LE_18, "T");
            }

            return Float.toString(bmi);
        }
        return null;
    }

    public static SpannableString addBullet(String text) {
        SpannableString spannable = new SpannableString(text);
        spannable.setSpan(new BulletSpan(15), 0, text.length(), 0);
        return spannable;
    }


    public static void showAlertAndExit(final String msg, final Context context) {
        final Activity activity = (Activity) context;
        activity.runOnUiThread(() -> {
            View.OnClickListener listener = v -> {
                dialogForExit.dismiss();
                activity.finish();
            };
            dialogForExit = new MyAlertDialog(context, false, msg, listener, DynamicUtils.BUTTON_OK);
            dialogForExit.show();
        });
    }

    public static String getNotAvailableIfNull(String text) {
        if (text != null && !text.isEmpty()) {
            return text;
        }
        return GlobalTypes.NOT_AVAILABLE;
    }

    public static String getNotAvailableIfNull(Object object) {
        if (object != null && !object.toString().isEmpty()) {
            return object.toString();
        }
        return GlobalTypes.NOT_AVAILABLE;
    }

    public static String returnYesNoNotAvailableFromBoolean(Boolean bool) {
        if (Boolean.TRUE.equals(bool)) {
            return LabelConstants.YES;
        } else if (Boolean.FALSE.equals(bool)) {
            return LabelConstants.NO;
        } else {
            return LabelConstants.NOT_AVAILABLE;
        }
    }

    public static String returnYesNoNotAvailableFromBoolean(Object object) {
        if (object != null) {
            if (Boolean.parseBoolean(object.toString())) {
                return LabelConstants.YES;
            } else {
                return LabelConstants.NO;
            }
        } else {
            return LabelConstants.NOT_AVAILABLE;
        }
    }

    public static String returnKeyFromBoolean(Object object) {
        if (object != null) {
            if (Boolean.parseBoolean(object.toString())) {
                return "1";
            } else {
                return "2";
            }
        } else {
            return null;
        }
    }

    public static List<String> getBlockedMobileNumbers() {
        List<String> blockedMobileNumbers = new ArrayList<>();
        blockedMobileNumbers.add("9999999999");
        blockedMobileNumbers.add("8888888888");
        blockedMobileNumbers.add("7777777777");
        blockedMobileNumbers.add("6666666666");
        blockedMobileNumbers.add("5555555555");
        return blockedMobileNumbers;
    }

    public static List<String> getSupportedExtensions() {
        List<String> supportedExtensions = new ArrayList<>();
        supportedExtensions.add("3gp");
        supportedExtensions.add("mp4");
        supportedExtensions.add("jpg");
        supportedExtensions.add("png");
        supportedExtensions.add("mp3");
        supportedExtensions.add("pdf");
        return supportedExtensions;
    }

    public static String getFormattedTime(int time) {
        if (time < 10) {
            return String.format(Locale.getDefault(), "%02d", time);
        } else {
            return Integer.toString(time);
        }
    }

    public static String getRelatedPropertyNameWithLoopCounter(String relatedPropertyName, int loopCounter) {
        if (loopCounter > 0) {
            return relatedPropertyName + loopCounter;
        } else {
            return relatedPropertyName;
        }
    }

    public static void restartApplication(Context context) {
        PackageManager packageManager = context.getPackageManager();
        Intent intent = packageManager.getLaunchIntentForPackage(context.getPackageName());
        if (intent != null) {
            ComponentName componentName = intent.getComponent();
            Intent mainIntent = Intent.makeRestartActivityTask(componentName);
            context.startActivity(mainIntent);
        }
        Runtime.getRuntime().exit(0);
    }

    public static String getGenderLabelFromValue(String gender) {
        if (gender == null) {
            return null;
        }
        switch (gender) {
            case GlobalTypes.MALE:
                return LabelConstants.MALE;
            case GlobalTypes.FEMALE:
                return LabelConstants.FEMALE;
            case GlobalTypes.TRANSGENDER:
                return LabelConstants.TRANSGENDER;
            case GlobalTypes.OTHER:
                return LabelConstants.OTHER;
            default:
                return gender;
        }
    }

    public static String getGenderValueAs123FromGender(String gender) {
        if (gender == null) {
            return null;
        }
        switch (gender) {
            case GlobalTypes.MALE:
                return "1";
            case GlobalTypes.FEMALE:
                return "2";
            case GlobalTypes.TRANSGENDER:
                return "3";
            default:
                return "0";
        }
    }

    public static String getDifferenceBetweenTwoDates(Date from, Date to) {
        if (from != null && to != null && from.compareTo(to) <= 0) {
            LocalDateTime fromDate = new LocalDateTime(from);
            LocalDateTime toDate = new LocalDateTime(to);

            Period period = new Period(fromDate, toDate, PeriodType.yearMonthDayTime());
            PeriodFormatter formatter = PeriodFormat.getDefault();

            return formatter.print(period);
        }
        return null;
    }

    public static String getFinancialYearFromDate(Date date) {
        Calendar instance = Calendar.getInstance();

        if (date != null) {
            instance.setTime(date);
        }

        int year = instance.get(Calendar.MONTH) < 3 ? instance.get(Calendar.YEAR) - 1 : instance.get(Calendar.YEAR);
        return year + "-" + (year + 1);
    }

    public static Date getStartOfFinancialYear(Date date) {
        Calendar cal = Calendar.getInstance();
        if (date != null) {
            cal.setTime(date);
        }

        int year = cal.get(Calendar.MONTH) < 3 ? cal.get(Calendar.YEAR) - 1 : cal.get(Calendar.YEAR);
        cal.set(Calendar.YEAR, year);
        cal.set(Calendar.MONTH, 3);
        cal.set(Calendar.DATE, 1);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        return cal.getTime();
    }

    public static String addCommaSeparatedStringIfNotExists(String previousString, String stringToAdd) {
        if (previousString == null || previousString.isEmpty()) {
            return stringToAdd;
        } else if (previousString.contains(stringToAdd)) {
            return previousString;
        } else {
            return previousString + "," + stringToAdd;
        }
    }

    public static Date endOfDay(Date date) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 23);
        cal.set(Calendar.MINUTE, 59);
        cal.set(Calendar.SECOND, 59);
        cal.set(Calendar.MILLISECOND, 999);

        return cal.getTime();
    }

    public static String aadhaarNumber(String answer) {
        if (answer == null) {
            return null;
        }
        answer = answer.trim();

        if (!Pattern.compile("^[0-9]{12}$").matcher(answer).matches()) {
            return "Aadhaar number must contains 12 digit numbers only";
        }

        int[][] d = {
                {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
                {1, 2, 3, 4, 0, 6, 7, 8, 9, 5},
                {2, 3, 4, 0, 1, 7, 8, 9, 5, 6},
                {3, 4, 0, 1, 2, 8, 9, 5, 6, 7},
                {4, 0, 1, 2, 3, 9, 5, 6, 7, 8},
                {5, 9, 8, 7, 6, 0, 4, 3, 2, 1},
                {6, 5, 9, 8, 7, 1, 0, 4, 3, 2},
                {7, 6, 5, 9, 8, 2, 1, 0, 4, 3},
                {8, 7, 6, 5, 9, 3, 2, 1, 0, 4},
                {9, 8, 7, 6, 5, 4, 3, 2, 1, 0}
        };

        int[][] p = {
                {0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
                {1, 5, 7, 6, 2, 8, 3, 0, 9, 4},
                {5, 8, 0, 3, 7, 9, 6, 1, 4, 2},
                {8, 9, 1, 6, 0, 4, 3, 5, 2, 7},
                {9, 4, 5, 3, 1, 2, 6, 8, 7, 0},
                {4, 2, 8, 6, 5, 7, 3, 9, 0, 1},
                {2, 7, 9, 3, 8, 0, 6, 4, 1, 5},
                {7, 0, 4, 6, 9, 1, 3, 2, 5, 8}
        };

        int c = 0;
        int l = answer.length();
        for (int t = 0; t < l; t++) {
            c = d[c][p[(t % 8)][Integer.parseInt(answer.charAt(l - t - 1) + "")]];
        }

        if (c != 0) {
            return "Please enter valid aadhaar number";
        }

        return null;
    }

    public static String getLMSFileName(Long mediaId, String fileName) {
        return mediaId == null ? null : String.format("%s_%s%s", "LMS_MEDIA", mediaId, fileName.substring(fileName.lastIndexOf(".")));
    }

    public static String getTimeSpentFromMillis(Long timeSpentInMillis) {
        long secondsInMilli = 1000;
        long minutesInMilli = secondsInMilli * 60;
        long hoursInMilli = minutesInMilli * 60;
        long daysInMilli = hoursInMilli * 24;

        long elapsedDays = timeSpentInMillis / daysInMilli;
        timeSpentInMillis = timeSpentInMillis % daysInMilli;

        long elapsedHours = timeSpentInMillis / hoursInMilli;
        timeSpentInMillis = timeSpentInMillis % hoursInMilli;

        long elapsedMinutes = timeSpentInMillis / minutesInMilli;
        timeSpentInMillis = timeSpentInMillis % minutesInMilli;

        long elapsedSeconds = timeSpentInMillis / secondsInMilli;

        String duration = "";
        if (elapsedDays != 0) {
            duration = String.format("%sd", elapsedDays);
        }

        if (elapsedHours != 0) {
            duration = String.format("%s %sh", duration, elapsedHours);
        }

        if (elapsedMinutes != 0) {
            duration = String.format("%s %sm", duration, elapsedMinutes);
        }

        duration = String.format("%s %ss", duration, elapsedSeconds);
        return duration.trim();
    }

    public static boolean videoFileIsCorrupted(Context myContext, String path) {
        MediaMetadataRetriever retriever = new MediaMetadataRetriever();
        try {
            retriever.setDataSource(myContext, Uri.parse(path));
            String hasVideo = retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_HAS_VIDEO);
            retriever.release();
            return "yes".equals(hasVideo);
        } catch (Exception e) {
            e.printStackTrace();
            try {
                retriever.release();
            } catch (IOException ex) {
                throw new RuntimeException(ex);
            }
            return false;
        }
    }

    public static String getTreatmentStatus(String status) {
        if (status != null) {
            if (status.equalsIgnoreCase(LabelConstants.CPHC)) {
                return "CPHC treatment";
            } else if (status.equalsIgnoreCase(LabelConstants.OUTSIDE)) {
                return "Outside treatment";
            }
        }
        return LabelConstants.NOT_AVAILABLE;
    }

    public static void setCbacTextColor(TextView textView, int score) {
        if (score < 3) {
            textView.setTextColor(ContextCompat.getColor(context, R.color.hofTextColor));
        } else if (score < 4) {
            textView.setTextColor(ContextCompat.getColor(context, R.color.orange));
        } else {
            textView.setTextColor(ContextCompat.getColor(context, R.color.pregnantWomenTextColor));
        }
    }

    public static void setBmiTextColorAndText(MaterialTextView tv, String bmi) {
        float bmiValue = Float.parseFloat(bmi);
        if (bmiValue < 18.5) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.childrenTextColor));
            String bmiText = bmi + "<br/>" + "Under Weight";
            tv.setText(Html.fromHtml(bmiText));
        } else if (bmiValue >= 18.5 && bmiValue <= 24.9) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.hofTextColor));
            String bmiText = bmi + "<br/>" + "Normal Weight";
            tv.setText(Html.fromHtml(bmiText));
        } else if (bmiValue >= 25 && bmiValue <= 29.9) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.yellow));
            String bmiText = bmi + "<br/>" + "Pre-Obesity";
            tv.setText(Html.fromHtml(bmiText));
        } else if (bmiValue >= 30 && bmiValue <= 34.9) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.notificationBadgeBackground));
            String bmiText = bmi + "<br/>" + "Obesity class I";
            tv.setText(Html.fromHtml(bmiText));
        } else if (bmiValue >= 35 && bmiValue <= 39.9) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.orange));
            String bmiText = bmi + "<br/>" + "Obesity class II";
            tv.setText(Html.fromHtml(bmiText));
        } else if (bmiValue >= 40) {
            tv.setTextColor(ContextCompat.getColor(context, R.color.pregnantWomenTextColor));
            String bmiText = bmi + "<br/>" + "Obesity class III";
            tv.setText(Html.fromHtml(bmiText));
        } else {
            tv.setTextColor(ContextCompat.getColor(context, R.color.black));
        }
    }

    public static void setTextColourAsPerStatus(TextView textView, String status) {
        if (status != null) {
            if (status.equalsIgnoreCase("No Anemia")) {
                textView.setTextColor(ContextCompat.getColor(context, R.color.hofTextColor));
            } else if (status.equalsIgnoreCase("Mild Anemia")) {
                textView.setTextColor(ContextCompat.getColor(context, R.color.yellow));
            } else if (status.equalsIgnoreCase("Moderate Anemia")) {
                textView.setTextColor(ContextCompat.getColor(context, R.color.orange));
            } else if (status.equalsIgnoreCase("Severe Anemia")) {
                textView.setTextColor(ContextCompat.getColor(context, R.color.pregnantWomenTextColor));
            }
        }

    }

    public static String getBmiCategoryFromValue(Float bmi) {
        String bmiCategory;
        if (bmi < 18.5) {
            bmiCategory = "Under Weight";
        } else if (bmi >= 18.5 && bmi <= 24.9) {
            bmiCategory = "Normal";
        } else if (bmi >= 25 && bmi <= 29.9) {
            bmiCategory = "Pre-Obesity";
        } else if (bmi >= 30 && bmi <= 34.9) {
            bmiCategory = "Obesity class I";
        } else if (bmi >= 35 && bmi <= 39.9) {
            bmiCategory = "Obesity class II";
        } else {
            bmiCategory = "Obesity class III";
        }
        return bmiCategory;
    }

    public static Map<String, Date> getImmunisationDateMap(String givenImmunisations) {
        Map<String, Date> immunisationDateMap = new HashMap<>();
        if (givenImmunisations != null && givenImmunisations.length() > 0) {
            StringTokenizer vaccineTokenizer = new StringTokenizer(givenImmunisations, ",");
            int counterVitaminA = 1;
            while (vaccineTokenizer.hasMoreElements()) {
                String[] vaccine = vaccineTokenizer.nextToken().split("#");
                String givenVaccineName = vaccine[0].trim();
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
                    if (givenVaccineName.equals(RchConstants.VITAMIN_A)) {
                        Date givenDate = immunisationDateMap.get(givenVaccineName);
                        if (givenDate == null || givenDate.before(sdf.parse(vaccine[1]))) {
                            immunisationDateMap.put(givenVaccineName.concat("_").concat(String.valueOf(counterVitaminA)), sdf.parse(vaccine[1]));
                            counterVitaminA++;
                        }
                    } else {
                        immunisationDateMap.put(givenVaccineName, sdf.parse(vaccine[1]));
                    }

                } catch (ParseException e) {
                    android.util.Log.e("UtilBean", null, e);
                }
            }
        }
        return immunisationDateMap;
    }

    public static String getLastStringFromCommaSeparatedString(String commaSeparatedString) {
        if (commaSeparatedString != null && !commaSeparatedString.isEmpty()) {
            String[] values = commaSeparatedString.split(",");
            return values[values.length - 1];
        }
        return null;
    }

    public static Boolean checkIfSecondTrimester(Long lmpDate) {
        if (lmpDate != null) {
            Date lmp = new Date(lmpDate);

            Calendar instance = Calendar.getInstance();
            instance.add(Calendar.MONTH, -3);

            return instance.getTime().after(lmp);
        }
        return false;
    }

    public static String getSickleCellStatusFromConstant(String status) {
        if (status != null && !status.trim().isEmpty()) {
            switch (status) {
                case "SICKLE_CELL_DISEASE":
                    return "Sickle Cell Disease";
                case "SICKLE_CELL_TRAIT":
                    return "Sickle Cell Trait";
                case "THALASSEMIA_MINOR":
                    return "Thalassemia Minor";
                case "THALASSEMIA_MAJOR":
                    return "Thalassemia Major";
                case "TESTED_NEG":
                    return "Tested Negative";
                case "NOT_TESTED":
                case "NOT_DONE":
                    return "Not Tested";
                case "NORMAL":
                    return "Normal";
                default:
                    return LabelConstants.NOT_AVAILABLE;
            }
        }
        return LabelConstants.NOT_AVAILABLE;
    }

    public static String getResidentStatusFromConstant(String status) {
        if (status != null && !status.trim().isEmpty()) {
            switch (status) {
                case "DOMICILE":
                    return "Domicile - Residing in UT for more than 10 years";
                case "MIGRATED_RESIDENT":
                    return "Migrated UT Resident between 6 months and 10 years";
                case "MIGRANT":
                    return "Migrant - Residing in UT for less than 6 months";
                default:
                    return LabelConstants.NOT_AVAILABLE;
            }
        }
        return LabelConstants.NOT_AVAILABLE;
    }

}
