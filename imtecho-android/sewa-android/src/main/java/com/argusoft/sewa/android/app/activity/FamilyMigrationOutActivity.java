package com.argusoft.sewa.android.app.activity;

import static android.content.DialogInterface.BUTTON_POSITIVE;
import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.content.Intent;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.ActivityConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.LocationConstants;
import com.argusoft.sewa.android.app.core.impl.LocationMasterServiceImpl;
import com.argusoft.sewa.android.app.core.impl.MigrationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FamilyMigrationOutDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.button.MaterialButton;
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
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Created by prateek on 8/9/19
 */
@EActivity
public class FamilyMigrationOutActivity extends MenuActivity implements View.OnClickListener {

    @Bean
    SewaFhsServiceImpl fhsService;
    @Bean
    MigrationServiceImpl migrationService;
    @Bean
    LocationMasterServiceImpl locationMasterService;

    private static final String FAMILY_INFO_SCREEN = "familyInfoScreen";
    private static final String SEARCH_OPTION_SCREEN = "searchOptionScreen";
    private static final String HIERARCHY_SCREEN = "hierarchyScreen";
    private static final String VILLAGE_SEARCH_SCREEN = "villageSearchScreen";
    private static final String HIERARCHY_SEARCH_SCREEN = "hierarchySearchScreen";
    private static final String CONFIRMATION_SCREEN = "confirmationScreen";
    private static final String OTHER_INFO_SCREEN = "otherInfoScreen";
    private static final String FINAL_SCREEN = "finalScreen";
    private static final Integer RADIO_BUTTON_ID_YES = 1;
    private static final Integer RADIO_BUTTON_ID_NO = 2;
    private static final Integer RADIO_BUTTON_ID_NOT_KNOWN = 3;

    private LinearLayout bodyLayoutContainer;
    private String screenName;
    private CheckBox outOfStateCheckBox;
    private TextView searchOptionTextView;
    private RadioGroup searchOptionRadioGroup;
    private RadioGroup splitRadioGroup;
    private TextInputLayout searchVillageEditText;
    private Button searchVillageButton;
    private List<LocationMasterBean> searchedVillageList = new ArrayList<>();
    private LocationMasterBean selectedLocation = null;
    private TextInputLayout otherInfoEditText;
    private RadioGroup confirmationRadioGroup;
    private NotificationMobDataBean selectedNotification;
    private FamilyDataBean familyDataBean;
    private List<Long> memberIds = new ArrayList<>();
    private LinearLayout globalPanel;
    private ListView listView;
    private int selectedVillageIndex = -1;
    private MaterialTextView listTitleView;
    private MaterialTextView noVillageTextView;

    private Map<Integer, String> hierarchyMapWithLevelAndName;
    private final Map<Integer, List<LocationMasterBean>> levelLocationListMap = new HashMap<>();
    private final Map<Integer, LocationMasterBean> levelSelectedLocationMap = new HashMap<>();
    private final Map<Integer, MaterialTextView> levelSelectLocationQueMap = new HashMap<>();
    private final Map<Integer, Spinner> levelSpinnerMap = new HashMap<>();
    private String newHeadId = null;
    private boolean existingHeadSelected;
    private Map<String, String> relWithHofMap;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        context = this;
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            String family = extras.getString("familyToMigrate", null);
            familyDataBean = new Gson().fromJson(family, FamilyDataBean.class);
            String notificationString = extras.getString(GlobalTypes.NOTIFICATION, null);
            if (notificationString != null) {
                selectedNotification = new Gson().fromJson(notificationString, NotificationMobDataBean.class);
            }
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
        setTitle(UtilBean.getTitleText(LabelConstants.FAMILY_MIGRATION_OUT_TITLE));
        setSubTitle(familyDataBean.getFamilyId());
    }

    private void initView() {
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(context, this);
        setContentView(globalPanel);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        MaterialButton nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
        setFamilyInfoScreen();
    }

    @Override
    public void onBackPressed() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                setResult(RESULT_CANCELED);
                finish();
            } else {
                alertDialog.dismiss();
            }
        };

        alertDialog = new MyAlertDialog(context, false,
                LabelConstants.ON_MIGRATION_CLOSE_ALERT,
                myListener,
                DynamicUtils.BUTTON_YES_NO);
        alertDialog.show();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == ActivityConstants.FAMILY_SPLIT_ACTIVITY_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                newHeadId = data.getStringExtra("newHead");
                existingHeadSelected = data.getBooleanExtra("existingHeadSelected", false);
                relWithHofMap = (Map<String, String>) data.getSerializableExtra("relationWithHofMap");
                boolean isCurrentLocation = data.getBooleanExtra("isCurrentLocation", false);
                if (isCurrentLocation) {
                    setResult(RESULT_OK);
                    finish();
                } else {
                    String memberIdsString = data.getStringExtra("memberIds");
                    if (memberIdsString != null) {
                        memberIds = new Gson().fromJson(memberIdsString, new TypeToken<List<Long>>() {
                        }.getType());
                        setSearchOptionScreen(true);
                    } else {
                        memberIds = new ArrayList<>();
                    }
                }
            } else if (resultCode == RESULT_CANCELED) {
                setFamilyInfoScreen();
            }
        }
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            switch (screenName) {
                case FAMILY_INFO_SCREEN:
                    if (splitRadioGroup.getCheckedRadioButtonId() == -1) {
                        SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.PLEASE_SELECT_AN_OPTION));
                    } else if (splitRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_YES) {
                        setSearchOptionScreen(false);
                    } else if (splitRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NO) {
                        Intent intent = new Intent(context, FamilySplitActivity_.class);
                        intent.putExtra("familyToSplit", new Gson().toJson(familyDataBean));
                        if (selectedNotification != null) {
                            intent.putExtra(GlobalTypes.NOTIFICATION, new Gson().toJson(selectedNotification));
                        }
                        startActivityForResult(intent, ActivityConstants.FAMILY_SPLIT_ACTIVITY_REQUEST_CODE);
                    }
                    break;

                case SEARCH_OPTION_SCREEN:
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
                                EditText searchVillage = searchVillageEditText.getEditText();
                                if (searchVillage != null && searchVillage.getText().toString().trim().length() > 0) {
                                    retrieveSearchedVillageListFromDB(searchVillage.getText().toString().trim());
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
                            selectedLocation = searchedVillageList.get(selectedVillageIndex);
                            if (familyDataBean.getLocationId().equals(selectedLocation.getActualID().toString())) {
                                SewaUtil.generateToast(context, LabelConstants.MIGRATED_FROM_VILLAGE_SELECTED_AS_MIGRATION_IN_ALERT);
                                return;
                            }
                            bodyLayoutContainer.removeAllViews();
                            showProcessDialog();
                            screenName = HIERARCHY_SEARCH_SCREEN;
                            addSearchedVillageHierarchyScreen(selectedLocation);
                            hideProcessDialog();
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
                            setSearchOptionScreen(false);
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

    private void setFamilyInfoScreen() {
        screenName = FAMILY_INFO_SCREEN;
        bodyLayoutContainer.removeAllViews();
        bodyLayoutContainer.addView(MyStaticComponents.generateTitleView(this, LabelConstants.FAMILY_DETAILS));
        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.FAMILY_ID));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, familyDataBean.getFamilyId()));
        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.MEMBERS_INFO));
        bodyLayoutContainer.addView(UtilBean.getMembersListForDisplay(this, familyDataBean));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                LabelConstants.DO_YOU_WANT_TO_MIGRATE_OR_SPLIT_THIS_FAMILY));
        if (splitRadioGroup == null) {
            splitRadioGroup = new RadioGroup(context);
            splitRadioGroup.addView(
                    MyStaticComponents.getRadioButton(context,
                            UtilBean.getMyLabel(LabelConstants.MIGRATE_THE_FAMILY),
                            RADIO_BUTTON_ID_YES));
            splitRadioGroup.addView(
                    MyStaticComponents.getRadioButton(context,
                            UtilBean.getMyLabel(LabelConstants.SPLIT_THE_FAMILY),
                            RADIO_BUTTON_ID_NO));
        }
        bodyLayoutContainer.addView(splitRadioGroup);
    }


    private void setSearchOptionScreen(boolean isSplitFamily) {
        screenName = SEARCH_OPTION_SCREEN;
        bodyLayoutContainer.removeAllViews();

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                LabelConstants.CHECK_IF_THE_FAMILY_HAS_BEEN_MIGRATED_TO_OUT_OF_STATE));

        if (searchOptionTextView == null) {
            searchOptionTextView = MyStaticComponents.generateQuestionView(null, null, context,
                    LabelConstants.CHOOSE_OPTION_TO_SEARCH);
        }

        if (searchOptionRadioGroup == null) {

            HashMap<Integer, String> stringMap = new HashMap<>();
            stringMap.put(RADIO_BUTTON_ID_YES, LabelConstants.SELECT_LOCATION);
            stringMap.put(RADIO_BUTTON_ID_NO, LabelConstants.TYPE_VILLAGE_NAME);

            if (!isSplitFamily) {
                stringMap.put(RADIO_BUTTON_ID_NOT_KNOWN, LabelConstants.LOCATION_NOT_KNOWN);
            }
            searchOptionRadioGroup = MyStaticComponents.getRadioGroup(this, stringMap, false);
        }

        if (outOfStateCheckBox == null) {
            outOfStateCheckBox = MyStaticComponents.getCheckBox(context, LabelConstants.OUT_OF_STATE, 255, false);
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
                LabelConstants.VILLAGE_OR_ANGANVADI_TO_BE_ENTERED_ALERT));

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
                EditText searchVillage = searchVillageEditText.getEditText();
                if (searchVillage != null && searchVillage.getText().toString().trim().length() > 0) {
                    showProcessDialog();
                    retrieveSearchedVillageListFromDB(searchVillageEditText.getEditText().getText().toString().trim());
                } else {
                    searchedVillageList.clear();
                    selectedLocation = null;
                    SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.VILLAGE_OR_ANGANVADI_SELECTION_REQUIRED_ALERT_FOR_SEARCH));
                }
            });
        }
        bodyLayoutContainer.addView(searchVillageButton);
    }

    @Background
    public void retrieveSearchedVillageListFromDB(CharSequence s) {
        searchedVillageList = locationMasterService.retrieveLocationMasterBeansBySearchAndType(s, LocationConstants.getLocationTypesForVillageLevel());
        addSearchedVillageList();
    }

    @UiThread
    public void addSearchedVillageList() {
        bodyLayoutContainer.removeView(listView);
        bodyLayoutContainer.removeView(listTitleView);
        bodyLayoutContainer.removeView(noVillageTextView);

        listTitleView = MyStaticComponents.getListTitleView(context, LabelConstants.SELECT_FROM_LIST);
        bodyLayoutContainer.addView(listTitleView);

        if (searchedVillageList != null && !searchedVillageList.isEmpty()) {
            String rbText;
            List<String> list = new ArrayList<>();
            for (LocationMasterBean locationMasterBean : searchedVillageList) {
                rbText = locationMasterService.retrieveLocationHierarchyByLocationId(locationMasterBean.getActualID());
                list.add(rbText);
            }
            AdapterView.OnItemClickListener onItemClickListener = new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    selectedVillageIndex = position;
                }
            };
            listView = MyStaticComponents.getListView(context, list, onItemClickListener, -1);
            bodyLayoutContainer.addView(listView);
        } else {
            noVillageTextView = MyStaticComponents.generateInstructionView(context, LabelConstants.NO_VILLAGE_OR_ANGANVADI_FOUND_WITH_THE_GIVEN_NAME);
            bodyLayoutContainer.addView(noVillageTextView);
        }
        hideProcessDialog();
    }

    private void addSearchedVillageHierarchyScreen(LocationMasterBean locationMasterBean) {
        hierarchyMapWithLevelAndName = locationMasterService.retrieveHierarchyMapWithLocation(locationMasterBean);
        addSpinnersForLocationHierarchy(true);
    }

    private void setConfirmationScreen(boolean isBack) {
        screenName = CONFIRMATION_SCREEN;
        bodyLayoutContainer.removeAllViews();

        if (outOfStateCheckBox.isChecked()) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                    LabelConstants.SURE_THIS_FAMILY_HAS_MIGRATED_OUT_OF_STATE));
        } else if (searchOptionRadioGroup != null && searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context,
                    LabelConstants.SURE_YOU_DON_T_KNOW_WHERE_THIS_FAMILY_HAS_BEEN_MIGRATED));
        }

        if (confirmationRadioGroup == null) {
            HashMap<Integer, String> stringMap = new HashMap<>();
            stringMap.put(RADIO_BUTTON_ID_YES, LabelConstants.YES);
            stringMap.put(RADIO_BUTTON_ID_NO, LabelConstants.NO);
            confirmationRadioGroup = MyStaticComponents.getRadioGroup(this, stringMap, true);
        }
        if (!isBack) {
            confirmationRadioGroup.clearCheck();
        }
        bodyLayoutContainer.addView(confirmationRadioGroup);
    }

    private void setOtherInfoScreen() {
        screenName = OTHER_INFO_SCREEN;
        bodyLayoutContainer.removeAllViews();

        if (selectedLocation != null) {
            bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.LOCATION_MIGRATED_TO));

            String villageHierarchy = locationMasterService.retrieveLocationHierarchyByLocationId(selectedLocation.getActualID());
            bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, villageHierarchy));

            String fhwDetailString = selectedLocation.getFhwDetailString();
            if (fhwDetailString != null) {
                Type type = new TypeToken<List<Map<String, String>>>() {
                }.getType();
                List<Map<String, String>> fhwDetailMapList = new Gson().fromJson(fhwDetailString, type);
                Map<String, String> fhwDetailMap = fhwDetailMapList.get(0);

                bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.FHW_NAME));

                bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, fhwDetailMap.get("name")));

                bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.FHW_MOBILE_NUMBER));

                String mobNumber = fhwDetailMap.get("mobileNumber");
                if (mobNumber != null && !mobNumber.trim().isEmpty()) {
                    bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, fhwDetailMap.get("mobileNumber")));
                } else {
                    bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(context, LabelConstants.NOT_AVAILABLE));
                }
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
                alertDialog.dismiss();
                saveFamilyMigrationOut();
                setResult(RESULT_OK);
                finish();
            } else {
                alertDialog.dismiss();
            }
        };

        alertDialog = new MyAlertDialog(context,
                LabelConstants.ON_MIGRATION_FORM_SUBMISSION_ALERT,
                myListener, DynamicUtils.BUTTON_YES_NO);
        alertDialog.show();
    }

    private void saveFamilyMigrationOut() {
        FamilyMigrationOutDataBean migration = new FamilyMigrationOutDataBean();
        migration.setFamilyId(Long.valueOf(familyDataBean.getId()));
        migration.setFromLocationId(Long.valueOf(familyDataBean.getLocationId()));

        if (memberIds != null && !memberIds.isEmpty()) {
            migration.setSplit(true);
            migration.setMemberIds(memberIds);
        }

        if (newHeadId != null) {
            migration.setNewHead(Long.parseLong(newHeadId));
        }

        migration.setExistingHeadSelected(existingHeadSelected);

        if (relWithHofMap != null && !relWithHofMap.isEmpty()) {
            migration.setRelationWithHofMap(relWithHofMap);
        }

        if (outOfStateCheckBox.isChecked()) {
            migration.setOutOfState(true);
        } else {
            migration.setOutOfState(false);

            if (searchOptionRadioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NOT_KNOWN) {
                migration.setLocationKnown(false);
            } else {
                migration.setLocationKnown(true);
                if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                    migration.setToLocationId(Objects.requireNonNull(levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.ZONE))).getActualID());
                } else {
                    migration.setToLocationId(Objects.requireNonNull(levelSelectedLocationMap.get(locationMasterService.getLocationLevelByType(LocationConstants.LocationType.VILLAGE))).getActualID());
                }
            }
        }

        EditText otherInfo = otherInfoEditText.getEditText();
        if (otherInfo != null && otherInfo.getText().toString().trim().length() > 0) {
            migration.setOtherInfo(otherInfo.getText().toString().trim());
        }
        migration.setReportedOn(new Date().getTime());
        migrationService.createFamilyMigrationOut(migration, familyDataBean, selectedNotification);
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
                case FAMILY_INFO_SCREEN:
                    setResult(RESULT_CANCELED);
                    finish();
                    break;

                case SEARCH_OPTION_SCREEN:
                    if (memberIds != null && !memberIds.isEmpty()) {
                        Intent intent = new Intent(context, FamilySplitActivity_.class);
                        intent.putExtra("familyToSplit", new Gson().toJson(familyDataBean));
                        intent.putExtra("memberIds", new Gson().toJson(memberIds));
                        if (selectedNotification != null) {
                            intent.putExtra(GlobalTypes.NOTIFICATION, new Gson().toJson(selectedNotification));
                        }
                        startActivityForResult(intent, ActivityConstants.FAMILY_SPLIT_ACTIVITY_REQUEST_CODE);
                    } else {
                        setFamilyInfoScreen();
                    }
                    break;

                case HIERARCHY_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    setSearchOptionScreen(false);
                    break;

                case HIERARCHY_SEARCH_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    showProcessDialog();
                    setVillageSearchScreen();
                    EditText searchVillage = searchVillageEditText.getEditText();
                    if (searchVillage != null && searchVillage.getText().toString().trim().length() > 0) {
                        retrieveSearchedVillageListFromDB(searchVillage.getText().toString().trim());
                    }
                    break;

                case VILLAGE_SEARCH_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    setSearchOptionScreen(false);
                    if (searchedVillageList != null && !searchedVillageList.isEmpty()) {
                        searchedVillageList.clear();
                    }
                    break;

                case CONFIRMATION_SCREEN:
                    setSearchOptionScreen(false);
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

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////                                       Methods to show Hierarchy                                       //////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    private void addSpinnersForLocationHierarchy(boolean preselected) {
        levelLocationListMap.clear();
        levelSpinnerMap.clear();
        levelSelectLocationQueMap.clear();

        List<LocationMasterBean> locationMasterBeans = SharedStructureData.locationMasterService.getLocationWithNoParent();

        if (locationMasterBeans == null || locationMasterBeans.isEmpty()) {
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
        spinner.setOnItemSelectedListener(getHierarchySpinnerListener(preselected));

        String name = SharedStructureData.locationMasterService.getLocationTypeNameByType(locationType);
        MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
        bodyLayoutContainer.addView(selectTextView);
        bodyLayoutContainer.addView(spinner);

        if (defaultIndex != 0) {
            onItemSelectedForSpinner(level, defaultIndex, true);
        }

        levelSpinnerMap.put(level, spinner);
        levelSelectLocationQueMap.put(level, selectTextView);
    }

    private AdapterView.OnItemSelectedListener getHierarchySpinnerListener(final boolean preselected) {
        return new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                onItemSelectedForSpinner(parent.getId(), position, preselected);
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        };
    }

    private void onItemSelectedForSpinner(Integer currentLevel, int position, boolean preselected) {
        if (position == 0) {
            removeHierarchySpinners(currentLevel);
            LocationMasterBean selectedLoc = levelSelectedLocationMap.get(currentLevel);
            if (selectedLoc != null) {
                selectedLocation = SharedStructureData.locationMasterService.getLocationMasterBeanByActualId(selectedLoc.getParent());
                if (selectedLocation != null) {
                    currentLevel = selectedLocation.getLevel();
                }
            }
            levelSelectedLocationMap.remove(currentLevel);
        } else if (Boolean.TRUE.equals(checkLocationLevel(currentLevel))) {
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
        List<LocationMasterBean> locationBeans = SharedStructureData.locationMasterService.retrieveLocationMasterBeansByParent(parent.getActualID().intValue());
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

            Spinner spinner = MyStaticComponents.getSpinner(context, arrayOfOptions, defaultIndex, newLevel);
            AdapterView.OnItemSelectedListener spinnerListener = getHierarchySpinnerListener(preselected);
            spinner.setOnItemSelectedListener(spinnerListener);

            String name = SharedStructureData.locationMasterService.getLocationTypeNameByType(locationBeans.get(0).getType());
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
            bodyLayoutContainer.addView(selectTextView);
            bodyLayoutContainer.addView(spinner);

            if (defaultIndex != 0) {
                onItemSelectedForSpinner(newLevel, defaultIndex, true);
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

    private Boolean checkLocationLevel(Integer currentLevel) {
        if (currentLevel == null) {
            return false;
        }
        return currentLevel <= 7;
    }
}
