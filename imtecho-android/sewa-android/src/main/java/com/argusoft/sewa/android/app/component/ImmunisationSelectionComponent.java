package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.app.DatePickerDialog;
import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.constants.FullFormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

/**
 * Defines methods for ImmunisationSelectionComponent
 *
 * @author prateek
 * @since 13/09/22 11:57 PM
 */
public class ImmunisationSelectionComponent extends LinearLayout {

    private final Context context;
    private final QueFormBean queFormBean;

    private static final String SHOW_ALL_IMMUNISATION = "showAll";
    private static final String ONLY_VITAMIN_A_IMMUNISATION = "onlyVitaminA";
    private static final String EXCLUDE_VITAMIN_A_IMMUNISATION = "excludeVitaminA";

    private String type = SHOW_ALL_IMMUNISATION;
    private Date dob;
    private Map<String, Date> allImmDateMap;
    private String givenImmunisations;
    private Map<String, Date> newImmDateMap;
    private Date currentDate = new Date();

    private List<String> dueImmunisations;
    private Map<String, MaterialTextView> immDateTextViewMap;

    // For this need to add datamap of relatedPropertyNames (dob-givenImmunisations-serviceDate-showAll)
    public ImmunisationSelectionComponent(Context context, QueFormBean queFormBean) {
        super(context);
        this.context = context;
        this.queFormBean = queFormBean;
        setBasicDataForImmunisations();
        setMainLayout();
    }

    //This constructor is not yet tested
    public ImmunisationSelectionComponent(Context context, Date dob, Map<String, Date> allImmDateMap, Date currentDate) {
        super(context);
        this.context = context;
        queFormBean = null;
        this.dob = dob;
        this.allImmDateMap = allImmDateMap;
        this.currentDate = currentDate;
        setMainLayout();
    }

    public void resetComponent() {
        removeAllViews();
        setBasicDataForImmunisations();
        setMainLayout();
    }

    private void setBasicDataForImmunisations() {
        allImmDateMap = new HashMap<>();
        currentDate = new Date();

        String datamap = queFormBean.getDatamap();

        if (datamap == null || datamap.isEmpty()) {
            return;
        }

        String[] split = datamap.split("-");

        if (split.length > 0) {
            String dobStr = SharedStructureData.relatedPropertyHashTable.get(
                    UtilBean.getRelatedPropertyNameWithLoopCounter(split[0], queFormBean.getLoopCounter())
            );
            if (dobStr != null) {
                dob = new Date(Long.parseLong(dobStr));
            }
        }

        if (split.length > 1) {
            givenImmunisations = SharedStructureData.relatedPropertyHashTable.get(
                    UtilBean.getRelatedPropertyNameWithLoopCounter(split[1], queFormBean.getLoopCounter())
            );

            if (givenImmunisations != null) {
                allImmDateMap = UtilBean.getImmunisationDateMap(givenImmunisations);
            }
        }

        if (allImmDateMap == null) {
            allImmDateMap = new HashMap<>();
        }

        SharedStructureData.vaccineGivenDateMap = allImmDateMap;

        if (split.length > 2) {
            String currDateStr = SharedStructureData.relatedPropertyHashTable.get(split[2]);
            if (currDateStr != null) {
                currentDate = new Date(Long.parseLong(currDateStr));
            }
        }

        if (split.length > 3) {
            type = split[3];
        }

    }

    private void setMainLayout() {
        newImmDateMap = new HashMap<>();
        String noVaccinesLabel = "No vaccines due";
        LinearLayout mainLayout = MyStaticComponents.getLinearLayout(context, -1, VERTICAL, new LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (dob == null) {
            mainLayout.addView(MyStaticComponents.generateAnswerView(context, UtilBean.getMyLabel(noVaccinesLabel)));
            addView(mainLayout);
            return;
        }
        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
            dueImmunisations = new ArrayList<>(SharedStructureData.immunisationService.getDueImmunisationsForChildZambia(dob, givenImmunisations, currentDate, SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true));
        } else if (GlobalTypes.FLAVOUR_DNHDD.equalsIgnoreCase(BuildConfig.FLAVOR)) {
            dueImmunisations = new ArrayList<>(SharedStructureData.immunisationService.getDueImmunisationsForChildDnhdd(dob, givenImmunisations, currentDate, SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true));
        } else {
            dueImmunisations = new ArrayList<>(SharedStructureData.immunisationService.getDueImmunisationsForChild(dob, givenImmunisations, currentDate, SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true));
        }

        if (EXCLUDE_VITAMIN_A_IMMUNISATION.equalsIgnoreCase(type)) {
            dueImmunisations.removeAll(vitaminAVaccines());
        } else if (ONLY_VITAMIN_A_IMMUNISATION.equalsIgnoreCase(type)) {
            noVaccinesLabel = "No Vitamin A doses due";
            dueImmunisations.retainAll(vitaminAVaccines());
        }

        if (dueImmunisations != null && !dueImmunisations.isEmpty()) {
            mainLayout.addView(getHeaderLayout());
            mainLayout.addView(getBodyLayout());
        } else {
            mainLayout.addView(MyStaticComponents.generateAnswerView(context, UtilBean.getMyLabel(noVaccinesLabel)));
        }
        addView(mainLayout);
    }

    private LinearLayout getHeaderLayout() {
        LinearLayout headerLayout = MyStaticComponents.getLinearLayout(context, -1, HORIZONTAL, new LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        headerLayout.setWeightSum(10f);

        LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, -1, HORIZONTAL, new LayoutParams(0, WRAP_CONTENT, 4f));
        linearLayout.setGravity(Gravity.CENTER);
        linearLayout.addView(MyStaticComponents.getListTitleView(context, UtilBean.getMyLabel("Vaccine")));
        headerLayout.addView(linearLayout);

        linearLayout = MyStaticComponents.getLinearLayout(context, -1, HORIZONTAL, new LayoutParams(0, WRAP_CONTENT, 6f));
        linearLayout.setGravity(Gravity.CENTER);
        linearLayout.addView(MyStaticComponents.getListTitleView(context, UtilBean.getMyLabel("Date")));
        headerLayout.addView(linearLayout);
        return headerLayout;
    }

    private LinearLayout getBodyLayout() {
        LinearLayout bodyLayout = MyStaticComponents.getLinearLayout(context, -1, VERTICAL, new LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        getImmunisationSelectionLayout(bodyLayout);
        return bodyLayout;
    }

    private void getImmunisationSelectionLayout(LinearLayout bodyLayout) {
        if (dueImmunisations == null || dueImmunisations.isEmpty()) {
            SewaUtil.generateToast(context, "No more vaccines due");
            return;
        }

        immDateTextViewMap = new HashMap<>();
        for (String imm : dueImmunisations) {
            LinearLayout immLayout = MyStaticComponents.getLinearLayout(context, -1, HORIZONTAL, new LayoutParams(MATCH_PARENT, WRAP_CONTENT));
            immLayout.setWeightSum(10f);

            immLayout.addView(getVaccineNameView(imm));
            immLayout.addView(getVaccineDateView(imm));
            bodyLayout.addView(immLayout);
        }
    }

    private LinearLayout getVaccineNameView(String vaccine) {
        LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, -1, HORIZONTAL, new LayoutParams(0, MATCH_PARENT, 4f));
        linearLayout.setGravity(Gravity.CENTER);
        MaterialTextView textView = MyStaticComponents.generateLabelView(context, UtilBean.getMyLabel(FullFormConstants.getFullFormOfVaccines(vaccine)));
        textView.setTextAlignment(TEXT_ALIGNMENT_CENTER);
        textView.setLayoutParams(new LayoutParams(WRAP_CONTENT, WRAP_CONTENT));
        linearLayout.addView(textView);
        return linearLayout;
    }

    private LinearLayout getVaccineDateView(String vaccine) {
        LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, -1, VERTICAL, new LayoutParams(0, WRAP_CONTENT, 6f));
        linearLayout.addView(getDateSelectorLayout(vaccine));

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
        Map<String, String> immunisationsMap = new HashMap<>();
        Map<Boolean, String> immunisationMissedMap;

        Date date1 = new Date();
        Date today = new Date();


        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValidZambia(dob, vaccine, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
        } else {
            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValid(dob, vaccine, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
        }

        for (Map.Entry<Boolean, String> entry : immunisationMissedMap.entrySet()) {
            Boolean isMissed = entry.getKey();
            String dateRange = entry.getValue();
            try {
                if (dateRange != null && !dateRange.contains("After")) {
                    String[] date = dateRange.split("-");
                    date1 = sdf.parse(date[0]);
                    if (date1 != null && !date1.after(new Date())) {
                        if (isMissed.equals(true) && date1.before(new Date())) {
                            immunisationsMap.put(vaccine, LabelConstants.MISSED + ", " + "Vaccine Valid Date Range: " + dateRange);
                        } else {
                            immunisationsMap.put(vaccine, LabelConstants.DUE_NOW + ", " + "Vaccine Valid Date Range: " + dateRange);
                        }
                    } else {
                        immunisationsMap.put(vaccine, "Vaccine Valid Date Range: " + dateRange);
                    }
                } else {
                    assert dateRange != null;
                    String[] date = dateRange.split(" ");
                    date1 = sdf.parse(date[1]);
                    if (date1 != null && !date1.after(new Date())) {
                        if (isMissed.equals(true) && date1.before(new Date())) {
                            immunisationsMap.put(vaccine, LabelConstants.MISSED + ", " + "Vaccine Valid Date Range: " + dateRange);
                        } else {
                            immunisationsMap.put(vaccine, LabelConstants.DUE_NOW + ", " + "Vaccine Valid Date Range: " + dateRange);
                        }
                    } else {
                        immunisationsMap.put(vaccine, "Vaccine Valid Date Range: " + dateRange);
                    }
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }

        MaterialTextView dueDate = new MaterialTextView(context);
        dueDate.setPadding(10, 10, 2, 10);
        dueDate.setTextSize(12);
        dueDate.setGravity(Gravity.CENTER_VERTICAL);
        if (today.before(date1)) {
            dueDate.setTextColor(ContextCompat.getColor(context, R.color.hofTextColor));
        } else if (LabelConstants.DUE_NOW.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
            dueDate.setTextColor(Color.BLUE);
        } else if (LabelConstants.MISSED.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
            dueDate.setTextColor(Color.RED);
        }
        dueDate.setText(immunisationsMap.get(vaccine));
        if (!immunisationsMap.isEmpty()) {
            linearLayout.addView(dueDate);
        }

        return linearLayout;
    }

    private LinearLayout getDateSelectorLayout(String vaccine) {
        LinearLayout dateLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.HORIZONTAL, null);
        dateLayout.setGravity(Gravity.CENTER_VERTICAL);

        MaterialTextView txtDate = MyStaticComponents.generateAnswerView(context, GlobalTypes.SELECT_DATE_TEXT);
        txtDate.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 200));
        dateLayout.addView(txtDate);

        immDateTextViewMap.put(vaccine, txtDate);

        ImageView imageCalendar = MyStaticComponents.getImageView(context, 2, R.drawable.ic_calender, null);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1);
        layoutParams.setMargins(0, 10, 0, 10);
        imageCalendar.setLayoutParams(layoutParams);
        dateLayout.addView(imageCalendar);

        ImageView imageClear = MyStaticComponents.getImageView(context, 2, R.drawable.cross, null);
        LinearLayout.LayoutParams layoutParams1 = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1);
        layoutParams1.setMargins(10, 10, 10, 10);
        imageClear.setLayoutParams(layoutParams1);
        dateLayout.addView(imageClear);
        imageClear.setVisibility(GONE);

        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            dateLayout.setBackground(ContextCompat.getDrawable(context, R.drawable.training_custom_datepicker));
        } else {
            dateLayout.setBackground(ContextCompat.getDrawable(context, R.drawable.custom_datepicker));
        }
        dateLayout.setOnClickListener(getDateSelectorClickListener(vaccine, txtDate, imageClear));
        //for bottom margin
        dateLayout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        return dateLayout;
    }

    private OnClickListener getDateSelectorClickListener(String vaccine, MaterialTextView txtDate, ImageView imageClear) {
        DatePickerDialog.OnDateSetListener dateSetListener = getDateSetListener(vaccine, txtDate, imageClear);
        return view -> {
            DatePickerDialog dp;
            if (txtDate.getText() != null) {
                String[] ddmmyyy = UtilBean.split(txtDate.getText().toString(), GlobalTypes.DATE_STRING_SEPARATOR);
                if (ddmmyyy.length == 3) {
                    dp = new DatePickerDialog(context, dateSetListener, Integer.parseInt(ddmmyyy[2]), Integer.parseInt(ddmmyyy[1]) - 1, Integer.parseInt(ddmmyyy[0]));
                } else {
                    Calendar calendar = Calendar.getInstance();
                    dp = new DatePickerDialog(context, dateSetListener, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
                }
            } else {
                Calendar calendar = Calendar.getInstance();
                dp = new DatePickerDialog(context, dateSetListener, calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH), calendar.get(Calendar.DAY_OF_MONTH));
            }

            Calendar instance = Calendar.getInstance();
            instance.set(Calendar.HOUR, 0);
            instance.set(Calendar.MINUTE, 0);
            instance.set(Calendar.SECOND, 0);
            instance.set(Calendar.MILLISECOND, 0);
            if (SewaTransformer.loginBean.getUserRole().equalsIgnoreCase(GlobalTypes.USER_ROLE_ASHA)) {
                instance.add(Calendar.DATE, -1);
            }
            dp.getDatePicker().setMaxDate(instance.getTimeInMillis());
            dp.show();
        };
    }

    private DatePickerDialog.OnDateSetListener getDateSetListener(String vaccine, MaterialTextView txtDate, ImageView imageClear) {
        return (datePicker, year, month, day) -> {
            Calendar calendar = Calendar.getInstance();
            calendar.set(year, month, day, 0, 0, 0);
            String validation;
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                validation = SharedStructureData.immunisationService.vaccinationValidationForChildZambia(dob, calendar.getTime(), vaccine, allImmDateMap, queFormBean);
            } else {
                validation = SharedStructureData.immunisationService.vaccinationValidationForChild(dob, calendar.getTime(), vaccine, allImmDateMap);
            }
            if (validation != null) {
                txtDate.setText(UtilBean.getMyLabel(GlobalTypes.SELECT_DATE_TEXT));
                allImmDateMap.remove(vaccine);
                newImmDateMap.remove(vaccine);
                SewaUtil.generateToast(context, UtilBean.getMyLabel(validation));
            } else {
                allImmDateMap.put(vaccine, calendar.getTime());
                newImmDateMap.put(vaccine, calendar.getTime());
                txtDate.setText(new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(calendar.getTime()));
                imageClear.setVisibility(VISIBLE);

                imageClear.setOnClickListener(view -> {
                    txtDate.setText(UtilBean.getMyLabel(GlobalTypes.SELECT_DATE_TEXT));
                    allImmDateMap.remove(vaccine);
                    newImmDateMap.remove(vaccine);
                    imageClear.setVisibility(GONE);
                });
            }
            setAnswer(vaccine);
        };
    }

    private void setAnswer(String vaccine) {
        for (String imm : dueImmunisations) {
            Date date = newImmDateMap.get(imm);
            if (date == null) {
                continue;
            }
            String validation;
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                validation = SharedStructureData.immunisationService.vaccinationValidationForChildZambia(dob, date, imm, allImmDateMap, queFormBean);
            } else {
                validation = SharedStructureData.immunisationService.vaccinationValidationForChild(dob, date, imm, allImmDateMap);
            }

            if (validation != null) {
                String v = "Selected date for "
                        + FullFormConstants.getFullFormOfVaccines(imm)
                        + " has been removed because it was dependent on "
                        + FullFormConstants.getFullFormOfVaccines(vaccine);
                SewaUtil.generateToast(context, v);
                MaterialTextView textView = immDateTextViewMap.get(imm);
                if (textView != null) {
                    textView.setText(UtilBean.getMyLabel(GlobalTypes.SELECT_DATE_TEXT));
                }
                allImmDateMap.remove(imm);
                newImmDateMap.remove(imm);
            }
        }
        if (queFormBean != null) {
            SharedStructureData.vaccineGivenDateMap = allImmDateMap;
            if (newImmDateMap.isEmpty()) {
                queFormBean.setAnswer(null);
            } else {
                Map<String, String> ansMap = new HashMap<>();
                for (Map.Entry<String, Date> entry : newImmDateMap.entrySet()) {
                    ansMap.put(entry.getKey(), String.valueOf(entry.getValue().getTime()));
                }
                queFormBean.setAnswer(new Gson().toJson(ansMap));
            }
            Log.i(getClass().getSimpleName(), "Immunisation Component Answer : " + queFormBean.getAnswer());
        }
    }

    public Map<String, Date> getAnswer() {
        return newImmDateMap;
    }

    private List<String> vitaminAVaccines() {
        List<String> list = new ArrayList<>();
        list.add(RchConstants.VITAMIN_A);
        return list;
    }
}