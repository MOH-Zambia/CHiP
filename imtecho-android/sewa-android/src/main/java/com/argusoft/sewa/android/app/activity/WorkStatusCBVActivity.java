package com.argusoft.sewa.android.app.activity;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.content.Intent;
import android.graphics.Typeface;
import android.os.Bundle;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TableLayout;
import android.widget.TableRow;

import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.databean.WorkLogScreenDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.FhwServiceDetailBean;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.model.LoggerBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

@EActivity
public class WorkStatusCBVActivity extends MenuActivity implements View.OnClickListener {
    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaFhsServiceImpl fhsService;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<LocationBean, Integer> locationBeanDao;

    private List<LocationBean> locationBeans = new ArrayList<>();
    private final Map<String, Long> mapOfStatistics = new LinkedHashMap<>();
    private final Map<String, Long> mapOfExpectedValues = new LinkedHashMap<>();
    private LinearLayout bodyLayoutContainer;
    private Button nextButton;
    private Spinner spinner;
    private boolean isVillageSelectionScreen = Boolean.FALSE;
    private Integer locationId;
    private LinearLayout globalPanel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
    }

    private void initView() {
        showProcessDialog();
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(this, this);
        setContentView(globalPanel);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        setBodyDetail();
    }

    private void setBodyDetail() {
        locationBeans = fhsService.getDistinctLocationsAssignedToUser();
        if (locationBeans.size() == 1) {
            locationId = locationBeans.get(0).getActualID();
            isVillageSelectionScreen = Boolean.FALSE;
            addTable(Long.valueOf(locationId));
        } else if (locationBeans.isEmpty()) {
            addDataNotSyncedMsg(bodyLayoutContainer, nextButton);
        } else {
            isVillageSelectionScreen = Boolean.TRUE;
            addVillageSelectionSpinner();
        }
    }

    private void addVillageSelectionSpinner() {
        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, UtilBean.getMyLabel(LabelConstants.SELECT_VILLAGE)));
        String[] arrayOfOptions = new String[locationBeans.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(LabelConstants.ALL);
        int i = 1;
        for (LocationBean locationBean : locationBeans) {
            arrayOfOptions[i] = locationBean.getName();
            i++;
        }
        spinner = MyStaticComponents.getSpinner(this, arrayOfOptions, 0, 2);
        bodyLayoutContainer.addView(spinner);
        hideProcessDialog();
    }

    private void addVillageHeading(LocationBean locationBean) {
        String labelValue;
        if (locationBean != null) {
            labelValue = UtilBean.getMyLabel(LabelConstants.VILLAGE) + ":" + UtilBean.getMyLabel(locationBean.getName());
        } else {
            labelValue = UtilBean.getMyLabel(LabelConstants.ALL + " " + LabelConstants.VILLAGE);
        }

        MaterialTextView villageHeading = MyStaticComponents.generateSubTitleView(this, labelValue);
        bodyLayoutContainer.addView(villageHeading);
    }

    private void addStatisticTypeHeading() {
        String labelValue = "";
        labelValue = LabelConstants.WORK_LOG_FOR_ZAMBIA;
        if (!labelValue.trim().isEmpty()) {
            MaterialTextView villageHeading = MyStaticComponents.generateQuestionView(null, null, this, UtilBean.getMyLabel(labelValue));
            bodyLayoutContainer.addView(villageHeading);
        }
    }


    private String getProportionForTrueValidationsStatistics(String key) {
        StringBuilder stringBuilder = new StringBuilder(" ");
        Long statValue = mapOfStatistics.get(key);
        if (statValue == null) {
            statValue = 0L;
        }
        Long totalValue;
        stringBuilder.append("(");
        switch (key) {
            case LabelConstants.NUMBER_AND_PROPORTION_OF_TRUE_VALIDATION_BY_GVK_EMRI_CALL_CENTER:
                totalValue = mapOfStatistics.get(LabelConstants.TOTAL_NUMBER_OF_FAMILIES_IN_TECHO_AS_OF_TODAY);
                if (totalValue == null || totalValue == 0) {
                    return "";
                }
                stringBuilder.append(String.format(Locale.getDefault(), "%.2f",
                        (float) statValue / totalValue * 100));
                break;
            case LabelConstants.NUMBER_AND_PROPORTION_OF_FAMILY_MEMBERS_FOR_WHOM_YOU_ENTERED_AADHAR_NUMBER:
            case LabelConstants.NUMBER_AND_PROPORTION_OF_FAMILY_MEMBERS_FOR_WHOM_YOU_ENTERED_PHONE_NUMBER:
                totalValue = mapOfStatistics.get(LabelConstants.TOTAL_NUMBER_OF_FAMILY_MEMBERS_IN_TECHO_AS_OF_TODAY);
                if (totalValue == null || totalValue == 0) {
                    return "";
                }
                stringBuilder.append(String.format(Locale.getDefault(), "%.2f",
                        (float) statValue / totalValue * 100));
                break;
            default:
        }
        stringBuilder.append("%)");
        return stringBuilder.toString();
    }


    private void addTable(Long locationId) {
        LocationBean locationBean = new LocationBean();
        List<FhwServiceDetailBean> fhwServiceDetailBeans;
        if (locationId != null) {
            try {
                locationBean = locationBeanDao.queryBuilder().where().eq("actualID", Integer.valueOf(locationId.toString())).query().get(0);
                addVillageHeading(locationBean);
                addStatisticTypeHeading();
            } catch (SQLException e) {
                Log.e(getClass().getName(), null, e);
            }
            fhwServiceDetailBeans = fhsService.retrieveFhwServiceDetailBeansByVillageId(locationBean.getActualID());

        } else {
            addVillageHeading(null);
            addStatisticTypeHeading();
            fhwServiceDetailBeans = fhsService.retrieveFhwServiceDetailBeansByVillageId(null);
        }

        populateMapOfStatistics(fhwServiceDetailBeans);

        //Setting Up UI Table
        TableLayout tableLayout = new TableLayout(this);
        tableLayout.setPadding(10, 10, 10, 10);
        tableLayout.setLayoutParams(new TableLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        TableRow.LayoutParams layoutParamsForRow = new TableRow.LayoutParams(MATCH_PARENT);
        TableRow.LayoutParams layoutParams2 = new TableRow.LayoutParams(0, WRAP_CONTENT, 2);
        TableRow.LayoutParams layoutParams1 = new TableRow.LayoutParams(0, MATCH_PARENT, 1);

        int i = 0;
        int countForStatistics = 0;

        TableRow row = new TableRow(this);
        row.setPadding(10, 15, 10, 15);
        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            row.setBackgroundResource(R.drawable.table_row_selector);
        } else {
            row.setBackgroundResource(R.drawable.spinner_item_border);
        }
        row.setLayoutParams(layoutParamsForRow);
        MaterialTextView performanceItem = new MaterialTextView(this);
        MaterialTextView performanceValue = new MaterialTextView(this);
        performanceItem.setGravity(Gravity.CENTER);
        performanceValue.setGravity(Gravity.CENTER);
        performanceItem.setText(UtilBean.getMyLabel(LabelConstants.PERFORMANCE_ITEM));
        performanceValue.setText(UtilBean.getMyLabel(LabelConstants.VALUE));
        performanceItem.setTypeface(Typeface.DEFAULT_BOLD);
        performanceValue.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(performanceItem, layoutParams2);
        row.addView(performanceValue, layoutParams1);
        tableLayout.addView(row, i);
        i++;

        for (Map.Entry<String, Long> aStatistic : mapOfStatistics.entrySet()) {
            countForStatistics++;


            row = new TableRow(this);
            row.setPadding(10, 15, 10, 15);
            if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
                row.setBackgroundResource(R.drawable.table_row_selector);
            } else {
                row.setBackgroundResource(R.drawable.spinner_item_border);
            }
            row.setLayoutParams(layoutParamsForRow);
            performanceItem = new MaterialTextView(this);
            performanceValue = new MaterialTextView(this);
            performanceItem.setGravity(Gravity.CENTER);
            performanceValue.setGravity(Gravity.CENTER);
            if (i == 0) {
                performanceItem.setText(UtilBean.getMyLabel(LabelConstants.PERFORMANCE_ITEM));
                performanceValue.setText(UtilBean.getMyLabel(LabelConstants.VALUE));
                performanceItem.setTypeface(Typeface.DEFAULT_BOLD);
                performanceValue.setTypeface(Typeface.DEFAULT_BOLD);
            } else {
                performanceItem.setText(UtilBean.getMyLabel(aStatistic.getKey()));
                performanceValue.setText(String.format("%s%s", aStatistic.getValue().toString(),
                        getProportionForTrueValidationsStatistics(aStatistic.getKey())));
            }
            row.addView(performanceItem, layoutParams2);
            row.addView(performanceValue, layoutParams1);
            tableLayout.addView(row, i);
            i++;
        }
        bodyLayoutContainer.addView(tableLayout);

        hideProcessDialog();

    }

    private void addValueInMap(Map<String, Long> map, String key, Long newValue) {
        Long oldValue = map.get(key);
        if (oldValue != null) {
            map.put(key, oldValue + newValue);
        } else {
            map.put(key, newValue);
        }
    }


    private void populateMapOfStatistics(List<FhwServiceDetailBean> fhwServiceDetailBeans) {

        mapOfStatistics.put(LabelConstants.NUMBER_OF_FAMILIES_ADDED_BY_YOU_TILL_NOW, 0L);


        for (FhwServiceDetailBean fhwServiceDetailBean : fhwServiceDetailBeans) {
            addValueInMap(mapOfStatistics, LabelConstants.NUMBER_OF_FAMILIES_ADDED_BY_YOU_TILL_NOW, fhwServiceDetailBean.getNewFamiliesAddedTillNow());
        }
    }


    @Override
    protected void onResume() {
        super.onResume();
        if (globalPanel != null) {
            setContentView(globalPanel);
        }
        if (!SharedStructureData.isLogin) {
            Intent myIntent = new Intent(this, LoginActivity_.class);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(myIntent);
            finish();
        }
        setTitle(UtilBean.getTitleText(LabelConstants.WORK_STATUS_TITLE));
    }

    @UiThread
    public void retrieveWorkLog() {
        List<LoggerBean> loggerBeans = sewaService.getWorkLog();
        List<WorkLogScreenDataBean> lst = new ArrayList<>();
        WorkLogScreenDataBean log;
        if (loggerBeans != null && !loggerBeans.isEmpty()) {
            SimpleDateFormat sdf = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT + " hh:mm:ss", Locale.getDefault());
            Calendar calendar = Calendar.getInstance();
            calendar.add(Calendar.DATE, -1);

            for (LoggerBean loggerBean : loggerBeans) {
                if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_SUCCESS)) {
                    log = new WorkLogScreenDataBean(sdf.format(new Date(loggerBean.getDate())), R.drawable.success,
                            loggerBean.getBeneficiaryName(), loggerBean.getTaskName(), loggerBean.getMessage());
                    lst.add(log);
                } else if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_PENDING)) {
                    log = new WorkLogScreenDataBean(sdf.format(new Date(loggerBean.getDate())), R.drawable.pending,
                            loggerBean.getBeneficiaryName(), loggerBean.getTaskName(), loggerBean.getMessage());
                    lst.add(log);
                } else if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_ERROR)
                        && loggerBean.getModifiedOn() != null && loggerBean.getModifiedOn().after(calendar.getTime())) {
                    log = new WorkLogScreenDataBean(sdf.format(new Date(loggerBean.getDate())), R.drawable.error,
                            loggerBean.getBeneficiaryName(), loggerBean.getTaskName(), loggerBean.getMessage());
                    lst.add(log);
                } else if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_HANDLED_ERROR)
                        && loggerBean.getModifiedOn() != null && loggerBean.getModifiedOn().after(calendar.getTime())) {
                    log = new WorkLogScreenDataBean(sdf.format(new Date(loggerBean.getDate())), R.drawable.warning,
                            loggerBean.getBeneficiaryName(), loggerBean.getTaskName(), loggerBean.getMessage());
                    lst.add(log);
                }
            }
        } else {
            log = new WorkLogScreenDataBean(null, -1, LabelConstants.THERE_IS_NO_WORKLOG_TO_DISPLAY, null, null);
            lst.add(log);
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == android.R.id.home) {
            if (isVillageSelectionScreen) {
                navigateToHomeScreen(false);
            }
        }
        return true;
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            if (isVillageSelectionScreen) {
                String selectedVillage = spinner.getSelectedItem().toString();
                if (spinner.getSelectedItemPosition() == 0) {
                    locationId = null;
                } else {
                    for (LocationBean locationBean : locationBeans) {
                        if (selectedVillage.equals(locationBean.getName())) {
                            locationId = locationBean.getActualID();
                            break;
                        }
                    }
                }
                bodyLayoutContainer.removeAllViews();
                if (locationId != null)
                    addTable(Long.valueOf(locationId));
                else
                    addTable(null);
                isVillageSelectionScreen = Boolean.FALSE;
            }
        }

    }
}
