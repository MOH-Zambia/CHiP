package com.argusoft.sewa.android.app.activity;

import static android.content.DialogInterface.BUTTON_POSITIVE;
import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioGroup;
import android.widget.Spinner;

import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyProcessDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.LocationConstants;
import com.argusoft.sewa.android.app.core.impl.LocationMasterServiceImpl;
import com.argusoft.sewa.android.app.core.impl.MigrationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FieldValueMobDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.MigrationOutDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.NotificationBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textfield.TextInputLayout;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by prateek on 13/3/19.
 */

@EActivity
public class MigrateOutActivity extends MenuActivity implements View.OnClickListener {

    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaFhsServiceImpl fhsService;
    @Bean
    MigrationServiceImpl migrationService;
    @Bean
    LocationMasterServiceImpl locationMasterService;
    private static final Integer RADIO_BUTTON_ID_YES = 1;
    private static final Integer RADIO_BUTTON_ID_NO = 2;
    private static final Integer RADIO_BUTTON_ID_NOT_KNOWN = 3;
    private static final String MEMBER_INFO_SCREEN = "memberInfoScreen";
    private static final String HIERARCHY_SCREEN = "hierarchyScreen";
    private static final String VILLAGE_SEARCH_SCREEN = "villageSearchScreen";
    private static final String HIERARCHY_SEARCH_SCREEN = "hierarchySearchScreen";
    private static final String CONFIRMATION_SCREEN = "confirmationScreen";
    private static final String OTHER_INFO_SCREEN = "otherInfoScreen";
    private static final String FINAL_SCREEN = "finalScreen";
    private SharedPreferences sharedPref;
    private LinearLayout bodyLayoutContainer;
    private MyAlertDialog myAlertDialog;
    private String screenName;
    private NotificationBean notificationBean = null;
    private MemberDataBean memberDataBean = null;
    private FamilyDataBean familyDataBean = null;
    private CheckBox outOfStateCheckBox;
    private MaterialTextView searchOptionTextView;
    private RadioGroup searchOptionRadioGroup;
    private TextInputLayout searchVillageEditText;
    private Button searchVillageButton;
    private List<LocationMasterBean> searchedVillageList = new ArrayList<>();
    private LocationMasterBean selectedLocation = null;
    private List<MemberBean> childrenUnder5Years;
    private List<CheckBox> childCheckBoxes;
    private TextInputLayout otherInfoEditText;
    private RadioGroup confirmationRadioGroup;
    private LinearLayout globalPanel;
    private int selectedVillageIndex = -1;
    private MaterialTextView listTitleView;
    private ListView listView;
    private MaterialTextView noVillageTextView;
    private Map<Integer, String> hierarchyMapWithLevelAndName;
    private final Map<Integer, List<LocationMasterBean>> levelLocationListMap = new HashMap<>();
    private final Map<Integer, LocationMasterBean> levelSelectedLocationMap = new HashMap<>();
    private final Map<Integer, MaterialTextView> levelSelectLocationQueMap = new HashMap<>();
    private final Map<Integer, Spinner> levelSpinnerMap = new HashMap<>();
    private Spinner stateSelectionSpinner;
    private LinkedList<String> stateList = new LinkedList<>();
    private String selectedState;
    private Map<Integer, String> stateValueAndIdMap = new HashMap<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        context = this;
        sharedPref = PreferenceManager.getDefaultSharedPreferences(context);
        String notificationBeanJson = sharedPref.getString(GlobalTypes.NOTIFICATION_BEAN, null);
        String memberBeanJson = sharedPref.getString("memberBean", null);
        String familyDataBeanJson = sharedPref.getString("familyDataBean", null);
        Gson gson = new Gson();

        if (notificationBeanJson != null) {
            notificationBean = gson.fromJson(notificationBeanJson, NotificationBean.class);
        }
        if (memberBeanJson != null) {
            memberDataBean = new MemberDataBean(gson.fromJson(memberBeanJson, MemberBean.class));
        }
        if (familyDataBeanJson != null) {
            familyDataBean = gson.fromJson(familyDataBeanJson, FamilyDataBean.class);
        }
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        initView();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (globalPanel != null) {
            setContentView(globalPanel);
        }
        if (!SharedStructureData.isLogin) {
            Intent myIntent = new Intent(context, LoginActivity_.class);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(myIntent);
            finish();
        }
        setTitle(UtilBean.getTitleText(LabelConstants.MIGRATION_TITLE));
        setSubTitle(UtilBean.getMemberFullName(memberDataBean));
    }

    private void initView() {
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(context, this);
        setContentView(globalPanel);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        setMemberInfoScreen();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            switch (screenName) {
                case MEMBER_INFO_SCREEN:
                    if (outOfStateCheckBox != null && outOfStateCheckBox.isChecked()) {
                        selectedLocation = null;
                        setConfirmationScreen(false);
                    } else {
                        if (searchOptionRadioGroup.getCheckedRadioButtonId() != -1) {
                            if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_YES) {
                                bodyLayoutContainer.removeAllViews();
                                screenName = HIERARCHY_SCREEN;
                                if (selectedLocation != null) {
                                    addSearchedVillageHierarchyScreen(selectedLocation);
                                } else {
                                    addSpinnersForLocationHierarchy(false);
                                }
                            }
                            if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NO) {
                                bodyLayoutContainer.removeAllViews();
                                setVillageSearchScreen();
                                if (searchVillageEditText.getEditText() != null
                                        && searchVillageEditText.getEditText().getText().toString().trim().length() > 0) {
                                    retrieveSearchedVillageListFromDB(searchVillageEditText.getEditText().getText().toString().trim());
                                }
                            }
                            if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
                                selectedLocation = null;
                                bodyLayoutContainer.removeAllViews();
                                setConfirmationScreen(false);
                            }
                        } else {
                            SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.PLEASE_SELECT_AN_OPTION));
                        }
                    }
                    break;

                case HIERARCHY_SCREEN:
                case HIERARCHY_SEARCH_SCREEN:
                    LocationMasterBean eighthLevelHierarchy;
                    if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                        eighthLevelHierarchy = levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.ZONE));
                    } else {
                        eighthLevelHierarchy = levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.VILLAGE));
                    }
                    if (eighthLevelHierarchy != null) {
                        if (eighthLevelHierarchy.getActualID().equals(Long.valueOf(familyDataBean.getLocationId()))) {
                            SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.MIGRATED_FROM_VILLAGE_SELECTED_AS_MIGRATION_IN_ALERT));
                        } else {
                            setOtherInfoScreen();
                        }
                    } else {
                        SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.VILLAGE_OR_ANGANVADI_SELECTION_REQUIRED_ALERT));
                    }
                    break;

                case VILLAGE_SEARCH_SCREEN:
                    if (searchedVillageList != null && !searchedVillageList.isEmpty()) {
                        if (selectedVillageIndex != -1) {
                            bodyLayoutContainer.removeAllViews();
                            selectedLocation = searchedVillageList.get(selectedVillageIndex);
                            screenName = HIERARCHY_SEARCH_SCREEN;
                            addSearchedVillageHierarchyScreen(selectedLocation);
                        } else {
                            SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.VILLAGE_OR_ANGANVADI_SELECTION_REQUIRED_ALERT_FOR_SEARCH));
                        }
                    } else {
                        SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.SEARCH_FOR_VILLAGE_OR_ANGANVADI_ALERT));
                    }
                    break;

                case CONFIRMATION_SCREEN:
                    if (confirmationRadioGroup.getCheckedRadioButtonId() != -1) {
                        if (confirmationRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_YES) {
                            setOtherInfoScreen();
                        }
                        if (confirmationRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NO) {
                            setMemberInfoScreen();
                        }
                    } else {
                        SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.PLEASE_SELECT_AN_OPTION));
                    }
                    break;

                case OTHER_INFO_SCREEN:
                    setFinalScreen();
                    break;

                case FINAL_SCREEN:
                    finishActivity();
                    break;

                default:
                    break;
            }
        }
    }

    private void setMemberInfoScreen() {
        bodyLayoutContainer.removeAllViews();
        screenName = MEMBER_INFO_SCREEN;

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.MEMBER_ID));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, memberDataBean.getUniqueHealthId()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.MEMBER_NAME));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, UtilBean.getMemberFullName(memberDataBean)));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.FAMILY_ID));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, memberDataBean.getFamilyId()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.CHECK_TO_BENEFICIARY_MIGRATED_OUT_OF_STATE));

        if (searchOptionTextView == null) {
            searchOptionTextView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.CHOOSE_OPTION_TO_SEARCH);
        }

        if (searchOptionRadioGroup == null) {
            searchOptionRadioGroup = new RadioGroup(context);
            searchOptionRadioGroup.addView(MyStaticComponents.getRadioButton(context, UtilBean.getMyLabel(LabelConstants.SELECT_LOCATION), RADIO_BUTTON_ID_YES));
            searchOptionRadioGroup.addView(MyStaticComponents.getRadioButton(context, UtilBean.getMyLabel(LabelConstants.TYPE_VILLAGE_NAME), RADIO_BUTTON_ID_NO));
            searchOptionRadioGroup.addView(MyStaticComponents.getRadioButton(context, UtilBean.getMyLabel(LabelConstants.LOCATION_NOT_KNOWN), RADIO_BUTTON_ID_NOT_KNOWN));
        }

        if (outOfStateCheckBox == null) {
            outOfStateCheckBox = MyStaticComponents.getCheckBox(context, UtilBean.getMyLabel(LabelConstants.OUT_OF_STATE), 255, false);
            outOfStateCheckBox.setOnCheckedChangeListener((buttonView, isChecked) -> {
                if (isChecked) {
                    bodyLayoutContainer.removeView(searchOptionTextView);
                    bodyLayoutContainer.removeView(searchOptionRadioGroup);
                } else {
                    bodyLayoutContainer.addView(searchOptionTextView);
                    bodyLayoutContainer.addView(searchOptionRadioGroup);
                }
            });
        }
        bodyLayoutContainer.addView(outOfStateCheckBox);

        if (!outOfStateCheckBox.isChecked()) {
            bodyLayoutContainer.addView(searchOptionTextView);
            bodyLayoutContainer.addView(searchOptionRadioGroup);
        }
    }

    private void setVillageSearchScreen() {
        bodyLayoutContainer.removeAllViews();
        screenName = VILLAGE_SEARCH_SCREEN;

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                UtilBean.getMyLabel(LabelConstants.VILLAGE_OR_ANGANVADI_TO_BE_ENTERED_ALERT)));

        if (searchVillageEditText == null) {
            searchVillageEditText = MyStaticComponents.getEditText(context, LabelConstants.VILLAGE_OR_ANGANVADI, 1001, 50, -1);
        }
        bodyLayoutContainer.addView(searchVillageEditText);

        if (searchVillageButton == null) {
            searchVillageButton = MyStaticComponents.getButton(context, UtilBean.getMyLabel(LabelConstants.SEARCH),
                    104, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
            searchVillageButton.setOnClickListener(v -> {
                InputMethodManager imm = (InputMethodManager) context.getSystemService(INPUT_METHOD_SERVICE);
                if (imm != null) {
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
                }
                bodyLayoutContainer.removeView(listView);
                bodyLayoutContainer.removeView(listTitleView);
                selectedVillageIndex = -1;
                if (searchVillageEditText.getEditText() != null && searchVillageEditText.getEditText().getText().toString().trim().length() > 0) {
                    showProcessDialog();
                    retrieveSearchedVillageListFromDB(searchVillageEditText.getEditText().getText().toString().trim());
                } else {
                    searchedVillageList.clear();
                    selectedLocation = null;
                    SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.VILLAGE_OR_ANGANVADI_TO_BE_ENTERED_TO_SEARCH_ALERT));
                }
            });
        }
        bodyLayoutContainer.addView(searchVillageButton);
    }

    @Background
    public void retrieveSearchedVillageListFromDB(CharSequence s) {
        searchedVillageList = migrationService.retrieveLocationMasterBeansBySearch(s, 6);
        addSearchedVillageList();
    }

    @UiThread
    public void addSearchedVillageList() {
        bodyLayoutContainer.removeView(noVillageTextView);
        bodyLayoutContainer.removeView(listTitleView);
        bodyLayoutContainer.removeView(listView);

        listTitleView = MyStaticComponents.getListTitleView(context, LabelConstants.SELECT_FROM_LIST);
        bodyLayoutContainer.addView(listTitleView);

        if (searchedVillageList != null && !searchedVillageList.isEmpty()) {
            String rbText;
            List<String> list = new ArrayList<>();
            for (LocationMasterBean locationMasterBean : searchedVillageList) {
                Map<Integer, String> hierarchyOfVillage = migrationService.retrieveHierarchyOfVillage(locationMasterBean);
                rbText = String.format("%s > %s > %s > %s > %s > %s",
                        hierarchyOfVillage.get(1),
                        hierarchyOfVillage.get(2),
                        hierarchyOfVillage.get(3),
                        hierarchyOfVillage.get(4),
                        hierarchyOfVillage.get(5),
                        hierarchyOfVillage.get(6));
                list.add(rbText);
            }

            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> selectedVillageIndex = position;
            listView = MyStaticComponents.getListView(context, list, onItemClickListener, -1);
            bodyLayoutContainer.addView(listView);
        } else {
            noVillageTextView = MyStaticComponents.generateInstructionView(context, LabelConstants.NO_VILLAGE_OR_ANGANVADI_FOUND_WITH_THE_GIVEN_NAME);
            bodyLayoutContainer.addView(noVillageTextView);
        }
        hideProcessDialog();
    }

    private void addSearchedVillageHierarchyScreen(LocationMasterBean locationMasterBean) {
        hierarchyMapWithLevelAndName = migrationService.retrieveHierarchyOfVillage(locationMasterBean);
        addSpinnersForLocationHierarchy(true);
    }

    private void setConfirmationScreen(boolean isBack) {
        screenName = CONFIRMATION_SCREEN;
        bodyLayoutContainer.removeAllViews();

        if (outOfStateCheckBox.isChecked()) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                    UtilBean.getMyLabel(LabelConstants.CONFORMATION_TO_MIGRATION_OUT_OF_STATE_FOR_MEMBER)));
        } else if (searchOptionRadioGroup != null && searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                    UtilBean.getMyLabel(LabelConstants.CONFORMATION_TO_UNKNOWN_MIGRATION_FOR_MEMBER)));
        }

        if (confirmationRadioGroup == null) {
            confirmationRadioGroup = new RadioGroup(context);
            confirmationRadioGroup.addView(MyStaticComponents.getRadioButton(context, UtilBean.getMyLabel(LabelConstants.YES), RADIO_BUTTON_ID_YES));
            confirmationRadioGroup.addView(MyStaticComponents.getRadioButton(context, UtilBean.getMyLabel(LabelConstants.NO), RADIO_BUTTON_ID_NO));
        }
        if (!isBack) {
            confirmationRadioGroup.clearCheck();
        }
        bodyLayoutContainer.addView(confirmationRadioGroup);
    }

    private void setStateSelectionSpinner(List<String> stateList) {
        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.SELECT_STATE));
        if (stateSelectionSpinner == null) {
            stateSelectionSpinner = new Spinner(context);
        }
        if (stateSelectionSpinner.getSelectedItem() == null) {
            stateSelectionSpinner.setAdapter(UtilBean.createAdapter(stateList));
        }
        bodyLayoutContainer.addView(stateSelectionSpinner);
        stateSelectionSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if (position != 0) {
                    for (Map.Entry<Integer, String> map : stateValueAndIdMap.entrySet()) {
                        if (map.getValue().equalsIgnoreCase(stateList.get(position))) {
                            selectedState = String.valueOf(map.getKey());
                        }
                    }
                } else {
                    selectedState = null;
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                //
            }
        });
    }

    private void setOtherInfoScreen() {
        screenName = OTHER_INFO_SCREEN;
        bodyLayoutContainer.removeAllViews();
        if (GlobalTypes.FLAVOUR_DNHDD.equalsIgnoreCase(BuildConfig.FLAVOR)
                && outOfStateCheckBox != null && outOfStateCheckBox.isChecked()) {
            List<FieldValueMobDataBean> labelDataBeans = SharedStructureData.sewaService.getFieldValueMobDataBeanByDataMap("indianStateList");
            if (!stateList.contains("-Select-"))
                stateList.add("-Select-");
            if (!stateValueAndIdMap.containsKey(0))
                stateValueAndIdMap.put(0, "-Select-");
            if (labelDataBeans != null && !labelDataBeans.isEmpty()) {
                for (FieldValueMobDataBean dataBean : labelDataBeans) {
                    if (stateList != null && !stateList.contains(dataBean.getValue())) {
                        stateList.add(dataBean.getValue());
                    }
                    if (stateValueAndIdMap != null && !stateValueAndIdMap.containsKey(dataBean.getIdOfValue())) {
                        stateValueAndIdMap.put(dataBean.getIdOfValue(), dataBean.getValue());
                    }
                }
            }
            setStateSelectionSpinner(stateList);
        }

        if (selectedLocation != null) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                    UtilBean.getMyLabel(LabelConstants.LOCATION_MIGRATED_TO)));

            Map<Integer, String> hierarchyOfVillage = migrationService.retrieveHierarchyOfVillage(selectedLocation);
            String villageHierarchy = String.format("%s > %s > %s > %s > %s > %s",
                    hierarchyOfVillage.get(1),
                    hierarchyOfVillage.get(2),
                    hierarchyOfVillage.get(3),
                    hierarchyOfVillage.get(4),
                    hierarchyOfVillage.get(5),
                    hierarchyOfVillage.get(6));

            bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, villageHierarchy));

            String fhwDetailString = selectedLocation.getFhwDetailString();
            if (fhwDetailString != null) {
                Type type = new TypeToken<List<Map<String, String>>>() {
                }.getType();
                List<Map<String, String>> fhwDetailMapList = new Gson().fromJson(fhwDetailString, type);
                Map<String, String> fhwDetailMap = fhwDetailMapList.get(0);

                if (fhwDetailMap.get("name") != null) {
                    if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                                UtilBean.getMyLabel(LabelConstants.CBV_NAME)));
                    } else {
                        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                                UtilBean.getMyLabel(LabelConstants.FHW_NAME)));
                    }


                    bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, fhwDetailMap.get("name")));
                }

                if (fhwDetailMap.get("mobileNumber") != null) {
                    bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                            UtilBean.getMyLabel(LabelConstants.FHW_MOBILE_NUMBER)));

                    bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, fhwDetailMap.get("mobileNumber")));
                }
            }
        }

        if (childrenUnder5Years == null) {
            childrenUnder5Years = migrationService.retrieveChildrenUnder5YearsByMotherId(Long.valueOf(memberDataBean.getId()));
        }

        if (!childrenUnder5Years.isEmpty()) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, UtilBean.getMyLabel(LabelConstants.WHICH_OF_THE_CHILDREN_MIGRATED_WITH_MOTHER) + "?"));
            childCheckBoxes = new ArrayList<>();
            int count = 0;
            for (MemberBean bean : childrenUnder5Years) {
                CheckBox checkBox = MyStaticComponents.getCheckBox(context, UtilBean.getMemberFullName(bean), count, false);
                bodyLayoutContainer.addView(checkBox);
                childCheckBoxes.add(checkBox);
                count++;
            }
        }

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.OTHER_INFORMATION));
        if (otherInfoEditText == null) {
            otherInfoEditText = MyStaticComponents.getEditText(context, LabelConstants.OTHER_INFORMATION, 1000, 500, -1);
        }
        bodyLayoutContainer.addView(otherInfoEditText);
    }

    private void setFinalScreen() {
        screenName = FINAL_SCREEN;
        bodyLayoutContainer.removeAllViews();

        bodyLayoutContainer.addView(MyStaticComponents.generateSubTitleView(context,
                UtilBean.getMyLabel(LabelConstants.FORM_ENTRY_COMPLETED)));
        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(context,
                UtilBean.getMyLabel(LabelConstants.FORM_ENTRY_COMPLETED_SUCCESSFULLY)));
    }

    private void finishActivity() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                myAlertDialog.dismiss();
                saveMigrationOut();
                sharedPref.edit().clear().apply();
                setResult(RESULT_OK);
                finish();
            } else {
                myAlertDialog.dismiss();
            }
        };

        myAlertDialog = new MyAlertDialog(context,
                LabelConstants.ON_MIGRATION_FORM_SUBMISSION_ALERT,
                myListener, DynamicUtils.BUTTON_YES_NO);
        myAlertDialog.show();
    }

    private void saveMigrationOut() {
        List<Long> childrenSelected = new ArrayList<>();
        if (childCheckBoxes != null && !childCheckBoxes.isEmpty()) {
            for (CheckBox box : childCheckBoxes) {
                if (box.isChecked()) {
                    childrenSelected.add(Long.valueOf(childrenUnder5Years.get(box.getId()).getActualId()));
                }
            }
        }

        MigrationOutDataBean migration = new MigrationOutDataBean();
        migration.setMemberId(Long.valueOf(memberDataBean.getId()));
        migration.setFromFamilyId(Long.valueOf(familyDataBean.getId()));
        migration.setFromLocationId(Long.valueOf(familyDataBean.getLocationId()));

        if (outOfStateCheckBox.isChecked()) {
            migration.setOutOfState(true);
            migration.setMigratedToStateName(selectedState);
        } else {
            migration.setOutOfState(false);

            if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
                migration.setLocationknown(false);
            } else {
                migration.setLocationknown(true);
                if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                    migration.setToLocationId(Objects.requireNonNull(levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.ZONE))).getActualID());
                } else {
                    migration.setToLocationId(Objects.requireNonNull(levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.VILLAGE))).getActualID());
                }
            }
        }

        migration.setChildrensUnder5(childrenSelected);
        if (otherInfoEditText.getEditText() != null
                && otherInfoEditText.getEditText().getText().toString().trim().length() > 0) {
            migration.setOtherInfo(otherInfoEditText.getEditText().getText().toString().trim());
        }
        migration.setReportedOn(new Date().getTime());
        migrationService.createMigrationOut(migration, memberDataBean, notificationBean);
        fhsService.markMemberAsMigrated(Long.valueOf(memberDataBean.getId()));
        fhsService.deleteNotificationByMemberIdAndNotificationType(Long.valueOf(memberDataBean.getId()), null);
    }

    @Override
    public void onBackPressed() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                myAlertDialog.dismiss();
                onMigrationCancelled();
                sharedPref.edit().clear().apply();
                finish();
            } else {
                myAlertDialog.dismiss();
            }
        };

        myAlertDialog = new MyAlertDialog(context,
                LabelConstants.ON_MIGRATION_CLOSE_ALERT,
                myListener, DynamicUtils.BUTTON_YES_NO);
        myAlertDialog.show();
    }

    private void onMigrationCancelled() {
        String loggerBeanId = sharedPref.getString("loggerBeanId", null);
        String answerRecordStoredId = sharedPref.getString("answerRecordStoredId", null);

        if (notificationBean != null) {
            sewaService.createNotificationBean(notificationBean);
        }

        if (loggerBeanId != null) {
            sewaService.deleteLoggerBeanByLoggerBeanId(Long.valueOf(loggerBeanId));
        }

        if (answerRecordStoredId != null) {
            sewaService.deleteStoreAnswerBeanByStoreAnswerBeanId(Long.valueOf(answerRecordStoredId));
        }
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////                                       Methods to show Hierarchy                                       //////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private void addSpinnersForLocationHierarchy(boolean preselected) {
        levelLocationListMap.clear();
        levelSpinnerMap.clear();
        levelSelectLocationQueMap.clear();

        List<LocationMasterBean> locationMasterBeans = locationMasterService.retrieveLocationMasterBeansByParent(LabelConstants.ZAMBIA_LOCATION_ID);

        if (locationMasterBeans.isEmpty()) {
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "No locations found");
            bodyLayoutContainer.addView(selectTextView);
            return;
        }

        String locationType = locationMasterBeans.get(0).getType();
        Integer level = locationMasterService.getLocationLevelByType(locationMasterBeans.get(0).getType());

        String[] arrayOfOptions = new String[locationMasterBeans.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);

        int defaultIndex = 0;
        int i = 1;
        for (LocationMasterBean locationBean : locationMasterBeans) {
            arrayOfOptions[i] = locationBean.getName();
            if (preselected && locationBean.getName().equals(hierarchyMapWithLevelAndName.get(level))) {
                defaultIndex = i;
            }
            i++;
        }

        levelLocationListMap.put(level, locationMasterBeans);

        Spinner spinner = MyStaticComponents.getSpinner(context, arrayOfOptions, defaultIndex, level);
        spinner.setOnItemSelectedListener(getHierarchySpinnerListener(locationType, preselected));

        String name = locationMasterService.getLocationTypeNameByType(locationType);
        MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
        bodyLayoutContainer.addView(selectTextView);
        bodyLayoutContainer.addView(spinner);

        if (defaultIndex != 0) {
            onItemSelectedForSpinner(locationType, level, defaultIndex, true);
        }

        levelSpinnerMap.put(level, spinner);
        levelSelectLocationQueMap.put(level, selectTextView);
    }

    private AdapterView.OnItemSelectedListener getHierarchySpinnerListener(String locationType, final boolean preselected) {
        return new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                onItemSelectedForSpinner(locationType, parent.getId(), position, preselected);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                //Do nothing
            }
        };
    }

    private void onItemSelectedForSpinner(String locationType, Integer currentLevel, int position, boolean preselected) {
        System.out.println(">>>>>>>> Position  : " + position);
        System.out.println(">>>>>>>> Boolean.TRUE.equals(checkLocationLevel(locationType))  : " + Boolean.TRUE.equals(checkLocationLevel(locationType)));
        if (position == 0) {
            removeHierarchySpinners(currentLevel);
            LocationMasterBean selectedLoc = levelSelectedLocationMap.get(currentLevel);
            if (selectedLoc != null) {
                selectedLocation = locationMasterService.getLocationMasterBeanByActualId(selectedLoc.getParent());
                if (selectedLocation != null) {
                    currentLevel = selectedLocation.getLevel();
                }
            }
            levelSelectedLocationMap.remove(currentLevel);
        } else if (Boolean.TRUE.equals(checkLocationLevel(locationType))) {
            removeHierarchySpinners(currentLevel);
            selectedLocation = Objects.requireNonNull(levelLocationListMap.get(currentLevel)).get(position - 1);
            levelSelectedLocationMap.put(selectedLocation.getLevel(), selectedLocation);
            addHierarchySpinners(selectedLocation, preselected);
        } else {
            removeHierarchySpinners(currentLevel);
            selectedLocation = Objects.requireNonNull(levelLocationListMap.get(currentLevel)).get(position - 1);
            levelSelectedLocationMap.put(selectedLocation.getLevel(), selectedLocation);
        }
    }

    private void addHierarchySpinners(LocationMasterBean parent, boolean preselected) {
        List<LocationMasterBean> locationBeans = locationMasterService.retrieveLocationMasterBeansByParent(parent.getActualID().intValue());
        if (!locationBeans.isEmpty()) {
            removeHierarchySpinners(parent.getLevel());

            Integer newLevel = locationBeans.get(0).getLevel();
            levelLocationListMap.put(newLevel, locationBeans);

            String[] arrayOfOptions = new String[locationBeans.size() + 1];
            arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
            int i = 1;
            int defaultIndex = 0;
            for (LocationMasterBean location : locationBeans) {
                arrayOfOptions[i] = location.getName();
                if (preselected && location.getName().equals(hierarchyMapWithLevelAndName.get(newLevel))) {
                    defaultIndex = i;
                }
                i++;
            }

            String locationType = locationBeans.get(0).getType();
            Spinner spinner = MyStaticComponents.getSpinner(context, arrayOfOptions, defaultIndex, newLevel);
            AdapterView.OnItemSelectedListener spinnerListener = getHierarchySpinnerListener(locationType, preselected);
            spinner.setOnItemSelectedListener(spinnerListener);

            String name = locationMasterService.getLocationTypeNameByType(locationType);
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
            bodyLayoutContainer.addView(selectTextView);
            bodyLayoutContainer.addView(spinner);

            if (defaultIndex != 0) {
                onItemSelectedForSpinner(locationType, newLevel, defaultIndex, true);
            }

            levelSpinnerMap.put(newLevel, spinner);
            levelSelectLocationQueMap.put(newLevel, selectTextView);
        } else {
            removeHierarchySpinners(parent.getLevel());
        }
    }

    private void removeHierarchySpinners(Integer level) {
        for (Map.Entry<Integer, List<LocationMasterBean>> entry : levelLocationListMap.entrySet()) {
            if (entry.getKey() > level) {
                bodyLayoutContainer.removeView(levelSelectLocationQueMap.get(entry.getKey()));
                bodyLayoutContainer.removeView(levelSpinnerMap.get(entry.getKey()));
                levelSelectedLocationMap.remove(entry.getKey());
            }
        }
    }

    private Boolean checkLocationLevel(String currentLevel) {
        return !(LocationConstants.LocationType.VILLAGE.equalsIgnoreCase(currentLevel)
                || LocationConstants.LocationType.ANM_AREA.equalsIgnoreCase(currentLevel)
                || LocationConstants.LocationType.ANGANWADI_AREA.equalsIgnoreCase(currentLevel));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (screenName == null || screenName.isEmpty()) {
            navigateToHomeScreen(false);
            return true;
        }

        if (item.getItemId() == android.R.id.home) {
            selectedVillageIndex = -1;
            switch (screenName) {
                case HIERARCHY_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    setMemberInfoScreen();
                    break;

                case HIERARCHY_SEARCH_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    processDialog = new MyProcessDialog(context, GlobalTypes.MSG_PROCESSING);
                    processDialog.show();
                    setVillageSearchScreen();
                    if (searchVillageEditText.getEditText() != null
                            && searchVillageEditText.getEditText().getText().toString().trim().length() > 0) {
                        retrieveSearchedVillageListFromDB(searchVillageEditText.getEditText().getText().toString().trim());
                    }
                    break;

                case VILLAGE_SEARCH_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    setMemberInfoScreen();
                    if (searchedVillageList != null && !searchedVillageList.isEmpty()) {
                        searchedVillageList.clear();
                    }
                    break;

                case CONFIRMATION_SCREEN:
                    setMemberInfoScreen();
                    break;

                case OTHER_INFO_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    if (outOfStateCheckBox != null && outOfStateCheckBox.isChecked()) {
                        setConfirmationScreen(true);
                    } else {
                        if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NO && selectedLocation != null) {
                            screenName = HIERARCHY_SEARCH_SCREEN;
                            addSearchedVillageHierarchyScreen(selectedLocation);
                            break;
                        }
                        if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_YES) {
                            screenName = HIERARCHY_SCREEN;
                            if (selectedLocation != null) {
                                addSearchedVillageHierarchyScreen(selectedLocation);
                            } else {
                                addSpinnersForLocationHierarchy(false);
                            }
                            break;
                        }
                        if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
                            setConfirmationScreen(true);
                            break;
                        }
                    }
                    break;

                case FINAL_SCREEN:
                    setOtherInfoScreen();
                    break;

                default:
                    onBackPressed();
            }
        }
        return true;
    }
}
