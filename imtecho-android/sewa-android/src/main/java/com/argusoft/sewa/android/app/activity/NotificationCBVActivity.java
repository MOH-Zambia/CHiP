package com.argusoft.sewa.android.app.activity;

import static android.content.DialogInterface.BUTTON_POSITIVE;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import androidx.appcompat.widget.Toolbar;
import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.component.PagingListView;
import com.argusoft.sewa.android.app.component.SearchComponent;
import com.argusoft.sewa.android.app.constants.ActivityConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.NotificationConstants;
import com.argusoft.sewa.android.app.core.impl.ImmunisationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.NotificationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.databean.FamilyDataBean;
import com.argusoft.sewa.android.app.databean.FamilyMigrationDetailsDataBean;
import com.argusoft.sewa.android.app.databean.ListItemDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.databean.MigrationDetailsDataBean;
import com.argusoft.sewa.android.app.databean.NotificationMobDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.exception.DataException;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.FormMetaDataUtil;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.stream.Collectors;

@EActivity
public class NotificationCBVActivity extends MenuActivity implements View.OnClickListener, PagingListView.PagingListener, SearchComponent.SearchClick, SearchComponent.ClearClick {
    private static final String NOTIFICATION_TYPE_SELECTION_SCREEN = "notificationTypeSelectionScreen";
    private static final String NOTIFICATION_SELECTION_SCREEN = "notificationSelectionScreen";
    private static final String MIGRATION_REVERT_NOTIFICATION_SCREEN = "migrationRevertNotificationScreen";
    private static final String READ_ONLY_NOTIFICATION_SCREEN = "readOnlyNotificationScreen";
    private static final String HOUSE_HOLD_NEARBY_MALARIA_SCREENING = "nearbyHouseholdForMalaria";
    private static final Integer REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY = 200;
    private static final Integer REQUEST_CODE_FOR_OTHER_NOTIFICATION_ACTIVITY = 201;
    private static final long LIMIT = 30;
    private static final long DELAY = 500;
    private static final String TAG = "NotificationActivity";

    @Bean
    public ImmunisationServiceImpl immunisationService;
    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaFhsServiceImpl fhsService;
    @Bean
    NotificationServiceImpl notificationService;
    @Bean
    FormMetaDataUtil formMetaDataUtil;
    private long offset = 0;
    private boolean isFromLogin;
    private View.OnClickListener onClickListener = this;
    private List<NotificationMobDataBean> notificationBeanList = new LinkedList<>();
    private NotificationMobDataBean selectedNotification;
    private LinearLayout bodyLayoutContainer;
    private int selectedIndexForNearbyHouseHold = -1;
    private List<MemberDataBean> uniqueMembers;
    private Button nextButton;
    private String screenName;
    private Map<Integer, String> notificationCodeWithRadioButtonIdMap = new HashMap<>();
    private String selectedNotificationCode = null;
    private PagingListView notificationListView;
    private ListView nearbyHouseholdButton;
    private Timer timer = new Timer();
    private List<Integer> selectedVillageIds = new ArrayList<>();
    private List<Integer> selectedAreaIds = new ArrayList<>();
    private Map<String, Integer> notificationsCountMap;
    private LinearLayout globalPanel;
    private LinearLayout footerView;
    private MaterialTextView titleView;
    private CharSequence search;
    private String locationIdForAllFam;
    private List<MemberDataBean> nearbyMembersOverAll;
    private LinkedHashMap<String, String> qrScanFilter = new LinkedHashMap<>();
    private boolean isNearbyHouseholdSearch;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        isFromLogin = getIntent().getBooleanExtra("isFromLogin", false);
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
            Intent intent = new Intent(this, LoginActivity_.class);
            intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            finish();
        }
        setTitle(UtilBean.getTitleText(LabelConstants.NOTIFICATION_TITLE));
    }

    private void initView() {
        showProcessDialog();
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(this, this);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        footerView = globalPanel.findViewById(DynamicUtils.ID_FOOTER);
        nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        setBodyDetail();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            switch (screenName) {
                case NOTIFICATION_SELECTION_SCREEN:
                    Intent intent;
                    if (notificationBeanList == null || notificationBeanList.isEmpty()) {
                        addNotificationTypeScreen();
                        nextButton.setText(GlobalTypes.EVENT_NEXT);
                        selectedNotificationCode = null;
                        return;
                    }
                    if (selectedNotification == null) {
                        SewaUtil.generateToast(this, LabelConstants.TASK_SELECTION_ALERT);
                        return;
                    }
                    switch (selectedNotification.getTask()) {
                        case NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN:
                            showProcessDialog();
                            intent = new Intent(this, MigrationInConfirmationActivity_.class);
                            intent.putExtra(GlobalTypes.NOTIFICATION_BEAN, new Gson().toJson(selectedNotification, NotificationMobDataBean.class));
                            startActivityForResult(intent, REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY);
                            hideProcessDialog();
                            break;
                        case NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT:
                            showProcessDialog();
                            intent = new Intent(this, MigrationOutConfirmationActivity_.class);
                            intent.putExtra(GlobalTypes.NOTIFICATION_BEAN, new Gson().toJson(selectedNotification, NotificationMobDataBean.class));
                            startActivityForResult(intent, REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY);
                            hideProcessDialog();
                            break;
                        case NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN:
                            showProcessDialog();
                            intent = new Intent(this, FamilyMigrationInConfirmationActivity_.class);
                            intent.putExtra(GlobalTypes.NOTIFICATION_BEAN, new Gson().toJson(selectedNotification, NotificationMobDataBean.class));
                            startActivityForResult(intent, REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY);
                            hideProcessDialog();
                            break;
                        case NotificationConstants.FHW_NOTIFICATION_READ_ONLY:
                            showReadOnlyNotification();
                            break;
                        case NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY:
                            if (Boolean.TRUE.equals(notificationService.checkIfThereArePendingNotificationsForMember(selectedNotification.getMemberId() != null ? selectedNotification.getMemberId() : null, NotificationConstants.FHW_NOTIFICATION_ANC))) {
                                View.OnClickListener myListener = v1 -> {
                                    if (v1.getId() == BUTTON_POSITIVE) {
                                        alertDialog.dismiss();
                                        startDynamicFormActivity();
                                    } else {
                                        alertDialog.dismiss();
                                    }
                                };

                                alertDialog = new MyAlertDialog(this,
                                        LabelConstants.ZAMBIA_PROCEED_FROM_WPD_WHILE_ANC_ALERTS_PENDING_ALERT,
                                        myListener, DynamicUtils.BUTTON_YES_NO);
                                alertDialog.show();
                            } else {
                                startDynamicFormActivity();
                            }
                            break;
                        default:
                            startDynamicFormActivity();
                            break;
                    }
                    break;
                case MIGRATION_REVERT_NOTIFICATION_SCREEN:
                case READ_ONLY_NOTIFICATION_SCREEN:
                    bodyLayoutContainer.removeAllViews();
                    showProcessDialog();
                    addLastUpdateLabel();
                    addSearchTextBox();
                    retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
                    break;
                case HOUSE_HOLD_NEARBY_MALARIA_SCREENING:
                    if (selectedIndexForNearbyHouseHold != -1) {
                        MemberDataBean memberDataBean = nearbyMembersOverAll.get(selectedIndexForNearbyHouseHold);
                        if (memberDataBean != null) {
                            SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
                            formMetaDataUtil.setMetaDataActiveMalariaFromNearbyHousehold(memberDataBean.getId(), memberDataBean.getFamilyId(), sharedPref, true);
                            Intent intentMalaria = new Intent(NotificationCBVActivity.this, DynamicFormActivity_.class);
                            intentMalaria.putExtra(SewaConstants.ENTITY, FormConstants.CHIP_ACTIVE_MALARIA);
                            startActivityForResult(intentMalaria, REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY);
                        }
                    } else {
                        SewaUtil.generateToast(context, "Please select a member");
                    }
                    break;
                default:
            }
        }
    }

    @Background
    public void setBodyDetail() {
        startLocationSelectionActivity();
    }

    private void startLocationSelectionActivity() {
        Intent myIntent = new Intent(context, LocationSelectionActivity_.class);
        myIntent.putExtra(FieldNameConstants.TITLE, LabelConstants.NOTIFICATION_TITLE);
        startActivityForResult(myIntent, ActivityConstants.LOCATION_SELECTION_ACTIVITY_REQUEST_CODE);
    }

    @Background
    public void retrieveCountsForEachNotificationType() {
        selectedNotificationCode = null;
        notificationsCountMap = notificationService.retrieveCountForNotificationType(selectedVillageIds, selectedAreaIds);
        addNotificationTypeScreen();
    }

    private String setNotificationCountFromMap(Integer count) {
        return count != null ? count.toString() : null;
    }

    @UiThread
    public void addNotificationTypeScreen() {
        screenName = NOTIFICATION_TYPE_SELECTION_SCREEN;
        footerView.setVisibility(View.GONE);
        bodyLayoutContainer.removeAllViews();

        int count = 0;
        notificationCodeWithRadioButtonIdMap = new HashMap<>();

        List<ListItemDataBean> listItems = new ArrayList<>();


        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_ANC);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_ANC)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_ANC))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_WORK_PLAN_FOR_DELIVERY))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN);
        listItems.add(new ListItemDataBean(-1,
               UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN))));
        count++;

//        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT);
//        listItems.add(new ListItemDataBean(-1,
//                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT)),
//                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT))));
//        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_PNC);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_PNC)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_PNC))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_CHILD_SERVICES))));
        count++;

//        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.FHW_NOTIFICATION_DISCHARGE);
//        listItems.add(new ListItemDataBean(-1,
//                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.FHW_NOTIFICATION_DISCHARGE)),
//                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.FHW_NOTIFICATION_DISCHARGE))));
//        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.NOTIFICATION_TB_FOLLOW_UP);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.NOTIFICATION_TB_FOLLOW_UP)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.NOTIFICATION_TB_FOLLOW_UP))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.NOTIFICATION_ACTIVE_MALARIA);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT))));
        count++;

        notificationCodeWithRadioButtonIdMap.put(count, NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT);
        listItems.add(new ListItemDataBean(-1,
                UtilBean.getMyLabel(UtilBean.getFullFormOfEntity().get(NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT)),
                setNotificationCountFromMap(notificationsCountMap.get(NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT))));
        count++;

        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            selectedNotificationCode = notificationCodeWithRadioButtonIdMap.get(position);
            offset = 0;
            Intent intent;
            if (selectedNotificationCode == null) {
                SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.SELECT_NOTIFICATION_TYPE));
                return;
            }
            if (selectedNotificationCode.equals(NotificationConstants.FHW_WORK_PLAN_ASHA_REPORTED_EVENT)) {
                intent = new Intent(context, ReportedEventConfirmationNotificationActivity_.class);
                intent.putExtra(GlobalTypes.SELECTED_ASHA_AREAS, new Gson().toJson(selectedAreaIds));
                intent.putExtra(GlobalTypes.SELECTED_VILLAGE_IDS, new Gson().toJson(selectedVillageIds));
                startActivityForResult(intent, REQUEST_CODE_FOR_OTHER_NOTIFICATION_ACTIVITY);
            } else {
                bodyLayoutContainer.removeAllViews();
                showProcessDialog();
                addLastUpdateLabel();
                if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT) ||
                        selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT)) {
                    addColorCodeInfo();
                }
                addSearchTextBox();
                retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
                footerView.setVisibility(View.VISIBLE);
            }
        };

        PagingListView notificationTypeListView = MyStaticComponents.getPaginatedListViewWithItem(context, listItems, R.layout.listview_row_notification, onItemClickListener, null);
        bodyLayoutContainer.addView(notificationTypeListView);
        hideProcessDialog();
    }

    @UiThread
    public void addColorCodeInfo() {
        TextView infoColorCodes = new MaterialTextView(context);
        infoColorCodes.setText(UtilBean.getMyLabel("Click here to see color codes"));
        infoColorCodes.setTextColor(ContextCompat.getColor(context, R.color.black));
        infoColorCodes.setCompoundDrawablesWithIntrinsicBounds(ContextCompat.getDrawable(context, R.drawable.ic_info_black), null, null, null);
        infoColorCodes.setCompoundDrawablePadding(10);
        infoColorCodes.setTextSize(12);
        infoColorCodes.setGravity(Gravity.CENTER_VERTICAL);
        bodyLayoutContainer.addView(infoColorCodes);

        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        final AlertDialog alertDialogCustom = builder.create();
        View alertView = LayoutInflater.from(this).inflate(R.layout.ncd_notification_color_code, null);
        alertDialogCustom.setView(alertView);
        alertDialogCustom.setCancelable(true);

        infoColorCodes.setOnClickListener(v -> {
            alertView.findViewById(R.id.buttonAlert).setOnClickListener(v2 -> {
                alertDialogCustom.dismiss();
            });
            alertDialogCustom.show();
        });
    }

    @UiThread
    public void addLastUpdateLabel() {
        bodyLayoutContainer.addView(lastUpdateLabelView(sewaService, bodyLayoutContainer));
    }

    @UiThread
    public void addSearchTextBox() {
        if (selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN)
                || selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT)
                || selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN)
                || selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_READ_ONLY)) {
            return;
        }

        search = null;

        SearchComponent searchBox = new SearchComponent(context, null, LabelConstants.MEMBER_ID_OR_NAME_TO_SEARCH, null, this, this, null, null);
        //searchBox.addTextWatcherInEditText(getSearchClickOffline());
        bodyLayoutContainer.addView(searchBox);

    }

    @UiThread
    public void addSearchTextBoxForNearbyHouseHold() {
        search = null;
        SearchComponent searchBox = new SearchComponent(context, null, LabelConstants.MEMBER_ID_OR_NAME_TO_SEARCH, null, this, this, null, null, true);
        bodyLayoutContainer.addView(searchBox);

    }

    private TextWatcher getSearchClickOffline() {
        return new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                //not implemented
            }

            @Override
            public void onTextChanged(final CharSequence s, int start, int before, int count) {
                timer.cancel();
                timer = new Timer();
                timer.schedule(
                        new TimerTask() {
                            @Override
                            public void run() {
                                if (s != null && s.length() > 2) {
                                    runOnUiThread(() -> retrieveInitialNotificationsFromDB(selectedNotificationCode, s, LIMIT, offset, null));
                                } else if (s == null || s.length() == 0) {
                                    runOnUiThread(() -> {
                                        showProcessDialog();
                                        retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
                                    });
                                }
                            }
                        },
                        DELAY
                );
            }

            @Override
            public void afterTextChanged(Editable s) {
                //not implemented
            }
        };
    }

    @Background
    public void retrieveInitialNotificationsFromDB(String notificationCode, CharSequence searchString, long limit, long offset, String qrData) {
        selectedNotification = null;
        search = searchString;
        qrScanFilter = SewaUtil.setQrScanFilterData(qrData);
        isNearbyHouseholdSearch = false;
        try {
            if (notificationCode.equalsIgnoreCase(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN) ||
                    selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN) ||
                    selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT)) {
                Integer villageId = notificationService.getVillageIdFromAshaArea(selectedAreaIds.get(0));
                if (villageId != null) {
                    selectedVillageIds.add(villageId);
                }
                notificationBeanList = notificationService.retrieveNotificationsForUser(selectedVillageIds, null, notificationCode, searchString, limit, 0, qrScanFilter);
            } else {
                notificationBeanList = notificationService.retrieveNotificationsForUser(selectedVillageIds, selectedAreaIds, notificationCode, searchString, limit, 0, qrScanFilter);
            }
            this.offset = this.offset + LIMIT;
        } catch (SQLException e) {
            Log.e(getClass().getName(), null, e);
        }
        addNotificationSelectionScreen(searchString != null);
    }

    @UiThread
    public void addNotificationSelectionScreen(boolean isSearch) {
        screenName = NOTIFICATION_SELECTION_SCREEN;
        bodyLayoutContainer.removeView(notificationListView);
        if (selectedNotificationCode != null && (selectedNotificationCode.equals(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA))) {
            bodyLayoutContainer.removeView(nearbyHouseholdButton);
        }
        bodyLayoutContainer.removeView(titleView);
        if (notificationBeanList == null || notificationBeanList.isEmpty()) {
            titleView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_NOTIFICATION_ALERT_WITH_GRATITUDE_FOR_WORK);
            bodyLayoutContainer.addView(titleView);
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> addNotificationTypeScreen());

            if (!isSearch) {
                hideProcessDialog();
            }
            return;
        }

        if (selectedNotificationCode != null && (selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN))) {
            titleView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_FAMILY);
        } else {
            titleView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_BENEFICIARY);
        }

        List<String> options = new ArrayList<>();
        options.add(UtilBean.getMyLabel(LabelConstants.NEARBY_HOUSEHOLDS));
        AdapterView.OnItemClickListener onButtonClick = (parent, view, position, id) -> {
            if (position == 0) {
                bodyLayoutContainer.removeAllViews();
                addSearchTextBoxForNearbyHouseHold();
                retrieveMembersWithin150M(notificationBeanList);
            }
        };
        nearbyHouseholdButton = MyStaticComponents.getButtonList(context, options, onButtonClick);
        if (selectedNotificationCode != null && (selectedNotificationCode.equals(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA))) {
            bodyLayoutContainer.addView(nearbyHouseholdButton);
        }

        bodyLayoutContainer.addView(titleView);

        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            if (notificationBeanList.size() > position)
                selectedNotification = notificationBeanList.get(position);
        };

        List<ListItemDataBean> stringList = getListViewItemsForNotificationList(notificationBeanList);
        if (selectedNotificationCode != null && (selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN) ||
                selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN) ||
                selectedNotificationCode.equals(NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT))) {
            notificationListView = MyStaticComponents.getPaginatedListViewWithItem(context, stringList, R.layout.listview_row_with_info, onItemClickListener, this);
        } else {
            notificationListView = MyStaticComponents.getPaginatedListViewWithItem(context, stringList, R.layout.listview_row_with_date, onItemClickListener, this);
        }

        bodyLayoutContainer.addView(notificationListView);
        nextButton.setText(GlobalTypes.EVENT_NEXT);
        nextButton.setOnClickListener(this);

        if (!isSearch) {
            hideProcessDialog();
        }
    }

    @Background
    public void retrieveMembersWithin150M(List<NotificationMobDataBean> notificationBeanList) {
        List<String> familyIds = new ArrayList<>();
        List<MemberDataBean> membersOfNearbyHouseHold = new ArrayList<>();
        uniqueMembers = new ArrayList<>();

        for (NotificationMobDataBean notificationMobDataBean : notificationBeanList) {
            MemberBean memberBean = fhsService.retrieveMemberBeanByActualId(notificationMobDataBean.getMemberId());
            if (Boolean.TRUE.equals(memberBean.getIndexCase())) {
                FamilyDataBean familyDataBean = fhsService.retrieveFamilyDataBeanByFamilyId(notificationMobDataBean.getFamilyId());
                if (!familyIds.contains(familyDataBean.getId())) {
                    familyIds.add(familyDataBean.getId());
                    List<MemberDataBean> nearbyMembers = new ArrayList<>(fhsService.retrieveMembersWithin150mOfActiveMalariaCases(
                            locationIdForAllFam,
                            familyDataBean.getLatitude(),
                            familyDataBean.getLongitude()));
                    membersOfNearbyHouseHold.addAll(nearbyMembers);
                }
            }
        }

        Set<MemberDataBean> uniqueMembersSet = new HashSet<>(membersOfNearbyHouseHold);
        List<MemberDataBean> uniqueMembersList = new ArrayList<>(uniqueMembersSet);
        for (MemberDataBean member : uniqueMembersList) {
            if (member.getIndexCase() == null || Boolean.FALSE.equals(member.getIndexCase())) {
                uniqueMembers.add(member);
            }
        }
        setScreenForHouseholdsWithin150M(uniqueMembers);
    }

    private void searchMembers(String searchTerm) {
        if (searchTerm.isEmpty()) {
            setScreenForHouseholdsWithin150M(uniqueMembers);
        } else {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
                List<MemberDataBean> searchResults = uniqueMembers.stream()
                        .filter(member -> member.getSearchString().toLowerCase().contains(searchTerm.toLowerCase()))
                        .collect(Collectors.toList());
                setScreenForHouseholdsWithin150M(searchResults);
            }
        }
    }

    @UiThread
    public void setScreenForHouseholdsWithin150M(List<MemberDataBean> memberDataBeans) {
        selectedIndexForNearbyHouseHold = -1;
        isNearbyHouseholdSearch = true;
        nearbyMembersOverAll = new ArrayList<>(memberDataBeans);
        bodyLayoutContainer.removeView(notificationListView);
        bodyLayoutContainer.removeView(titleView);
        screenName = HOUSE_HOLD_NEARBY_MALARIA_SCREENING;

        if (nearbyMembersOverAll == null || nearbyMembersOverAll.isEmpty()) {
            titleView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(titleView);
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> retrieveMembersWithin150M(notificationBeanList));
            return;
        }

        titleView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_MEMBER);
        List<ListItemDataBean> stringList = getListViewItemsForHouseHold(nearbyMembersOverAll);
        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            if (nearbyMembersOverAll.size() > position)
                selectedIndexForNearbyHouseHold = position;
        };
        notificationListView = MyStaticComponents.getPaginatedListViewWithItem(context, stringList, R.layout.listview_row_with_two_item, onItemClickListener, this);
        bodyLayoutContainer.addView(titleView);
        bodyLayoutContainer.addView(notificationListView);
        nextButton.setText(GlobalTypes.EVENT_NEXT);
        nextButton.setOnClickListener(this);
        hideKeyboard();
    }

    @Override
    public void onLoadMoreItems() {
        onLoadMoreBackground();
    }

    @Background
    public void onLoadMoreBackground() {
        try {
            List<NotificationMobDataBean> notificationMobDataBeans = notificationService.retrieveNotificationsForUser(
                    selectedVillageIds, selectedAreaIds, selectedNotificationCode, search, LIMIT, offset, qrScanFilter);
            this.offset = this.offset + LIMIT;
            onLoadMoreUi(notificationMobDataBeans);
        } catch (SQLException e) {
            Log.e(getClass().getName(), null, e);
        }
    }

    @UiThread
    public void onLoadMoreUi(List<NotificationMobDataBean> notificationMobDataBeans) {
        if (notificationMobDataBeans != null && !notificationMobDataBeans.isEmpty()) {
            notificationBeanList.addAll(notificationMobDataBeans);
            List<ListItemDataBean> stringList = getListViewItemsForNotificationList(notificationMobDataBeans);
            notificationListView.onFinishLoadingWithItem(true, stringList);
        } else {
            notificationListView.onFinishLoadingWithItem(false, null);
        }
    }

    private List<ListItemDataBean> getListViewItemsForNotificationList(List<NotificationMobDataBean> notificationBeans) {
        List<ListItemDataBean> items = new ArrayList<>();
        StringBuilder text;
        for (NotificationMobDataBean notificationMobDataBean : notificationBeans) {
            notificationMobDataBean.setOverdueFlag(
                    notificationMobDataBean.getExpectedDueDate() != null && new Date(notificationMobDataBean.getExpectedDueDate()).before(new Date())
            );
            Gson gson = new Gson();
            String date = null;
            String visit = null;
            StringBuilder vaccines = new StringBuilder();
            text = new StringBuilder();

            MemberBean memberBean;
            switch (notificationMobDataBean.getTask()) {
                case NotificationConstants.FHW_NOTIFICATION_FAMILY_MIGRATION_IN:
                    FamilyMigrationDetailsDataBean familyMigrationDetailsDataBean = gson.fromJson(notificationMobDataBean.getOtherDetails(), FamilyMigrationDetailsDataBean.class);
                    for (String string : familyMigrationDetailsDataBean.getMemberDetails()) {
                        text.append(string).append(LabelConstants.NEW_LINE);
                    }
                    items.add(new ListItemDataBean(LabelConstants.FAMILY_ID, familyMigrationDetailsDataBean.getFamilyIdString(), text.toString()));
                    break;
                case NotificationConstants.FHW_NOTIFICATION_MIGRATION_IN:
                case NotificationConstants.FHW_NOTIFICATION_MIGRATION_OUT:
                    MigrationDetailsDataBean memberDetails = gson.fromJson(notificationMobDataBean.getOtherDetails(), MigrationDetailsDataBean.class);
                    text = new StringBuilder(memberDetails.getFirstName() + " " + memberDetails.getMiddleName() + " " + memberDetails.getLastName());
                    items.add(new ListItemDataBean(memberDetails.getHealthId(), text.toString(), null));
                    break;
                case NotificationConstants.FHW_NOTIFICATION_READ_ONLY:
                    if (notificationMobDataBean.getHeader() != null) {
                        text = new StringBuilder(UtilBean.getMyLabel(notificationMobDataBean.getHeader()));
                    } else {
                        text = new StringBuilder(UtilBean.getMyLabel(LabelConstants.INFORMATION));
                    }
                    items.add(new ListItemDataBean(null, text.toString(), null, null, false));
                    break;
                case FormConstants.TECHO_FHW_CS:
                    memberBean = fhsService.retrieveMemberBeanByActualId(notificationMobDataBean.getMemberId());
                    if (notificationMobDataBean.getExpectedDueDate() != null) {
                        date = UtilBean.convertDateToString(notificationMobDataBean.getExpectedDueDate(), false, false, true);
                    }
                    if (notificationMobDataBean.getCustomField() != null && !notificationMobDataBean.getCustomField().equals("0")) {
                        visit = UtilBean.getMyLabel(LabelConstants.VISIT) + " " + notificationMobDataBean.getCustomField();
                    }
                    Set<String> dueImmunisationsForChild = immunisationService.getDueImmunisationsForChildZambia(memberBean.getDob(), memberBean.getImmunisationGiven(), new Date(), null, true);
                    if (dueImmunisationsForChild != null && !dueImmunisationsForChild.isEmpty()) {
                        for (String anImmunisation : dueImmunisationsForChild) {
                            vaccines.append(UtilBean.getMyLabel(anImmunisation.trim())).append(", ");
                        }
                    } else {
                        vaccines = new StringBuilder(UtilBean.getMyLabel(LabelConstants.NO_DUE_VACCINES));
                    }
                    items.add(new ListItemDataBean(date, memberBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberBean), visit, LabelConstants.DUE_VACCINES, vaccines.substring(0, vaccines.length() - 2), notificationMobDataBean.getOverdueFlag()));
                    break;
                case NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT:
                case NotificationConstants.NOTIFICATION_NCD_HOME_VISIT:
                case FormConstants.NCD_CVC_CLINIC:
                case FormConstants.NCD_CVC_HOME:
                    Boolean referredBackFlag = null;
                    String scheduledByMoReview = null;
                    boolean displayEarly = false;
                    memberBean = fhsService.retrieveMemberBeanByActualId(notificationMobDataBean.getMemberId());
                    if (notificationMobDataBean.getOtherDetails() != null && notificationMobDataBean.getOtherDetails().equalsIgnoreCase("MO_REVIEW")) {
                        scheduledByMoReview = "INCOMPLETE_STATE";
                    } else if (notificationMobDataBean.getOtherDetails() != null && notificationMobDataBean.getOtherDetails().equalsIgnoreCase("FOLLOWUP")) {
                        referredBackFlag = true;
                    }
                    if (new Date(notificationMobDataBean.getScheduledDate()).after(new Date())) {
                        displayEarly = true;
                    }
                    if (notificationMobDataBean.getExpectedDueDate() != null) {
                        date = UtilBean.convertDateToString(notificationMobDataBean.getExpectedDueDate(), false, false, true);
                    }
                    if (notificationMobDataBean.getCustomField() != null && !notificationMobDataBean.getCustomField().equals("0")) {
                        visit = UtilBean.getMyLabel(LabelConstants.VISIT) + " " + notificationMobDataBean.getCustomField();
                    }
                    items.add(new ListItemDataBean(date, memberBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberBean), visit, notificationMobDataBean.getOverdueFlag(), referredBackFlag, displayEarly, scheduledByMoReview));
                    break;
                default:
                    memberBean = fhsService.retrieveMemberBeanByActualId(notificationMobDataBean.getMemberId());
                    if (notificationMobDataBean.getExpectedDueDate() != null) {
                        date = UtilBean.convertDateToString(notificationMobDataBean.getExpectedDueDate(), false, false, true);
                    }
                    if (notificationMobDataBean.getCustomField() != null && !notificationMobDataBean.getCustomField().equals("0")) {
                        visit = UtilBean.getMyLabel(LabelConstants.VISIT) + " " + notificationMobDataBean.getCustomField();
                    }

                    items.add(new ListItemDataBean(date, memberBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberBean), visit, notificationMobDataBean.getOverdueFlag()));
                    break;
            }
        }
        return items;
    }

    private List<ListItemDataBean> getListViewItemsForHouseHold(List<MemberDataBean> memberDataBeans) {
        List<ListItemDataBean> list = new ArrayList<>();
        for (MemberDataBean memberDataBean : memberDataBeans) {
            list.add(new ListItemDataBean(memberDataBean.getFamilyId(), memberDataBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberDataBean), null, null));
        }
        return list;
    }


    @Override
    public void onBackPressed() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                navigateToHomeScreen(false);
                finish();
            } else {
                alertDialog.dismiss();
            }
        };

        alertDialog = new MyAlertDialog(this,
                LabelConstants.ON_NOTIFICATION_ACTIVITY_CLOSE_ALERT,
                myListener, DynamicUtils.BUTTON_YES_NO);
        alertDialog.show();
    }

    private void startDynamicFormActivity() {
        showProcessDialog();
        String nextEntity;
        if (selectedNotificationCode.equalsIgnoreCase(FormConstants.FHW_MONTHLY_SAM_SCREENING)) {
            nextEntity = "SAM_SCREENING";
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_NCD_CLINIC_VISIT)) {
            nextEntity = FormConstants.NCD_FHW_WEEKLY_CLINIC;
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_NCD_HOME_VISIT)) {
            nextEntity = FormConstants.NCD_FHW_WEEKLY_HOME;
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_TB_FOLLOW_UP)) {
            nextEntity = FormConstants.CHIP_TB_FOLLOW_UP;
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_ACTIVE_MALARIA)) {
            nextEntity = FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP;
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_FP_FOLLOW_UP_VISIT)) {
            nextEntity = FormConstants.CHIP_FP_FOLLOW_UP;
        } else if (selectedNotificationCode.equalsIgnoreCase(NotificationConstants.NOTIFICATION_HIV_NEGATIVE_FOLLOWUP_VISIT)) {
            nextEntity = FormConstants.HIV_SCREENING_FU;
        } else {
            nextEntity = selectedNotification.getTask();
        }

        if (nextEntity != null) {
            SharedPreferences sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
            try {
                if (selectedNotification != null) {
                    MemberBean memberBean = fhsService.retrieveMemberBeanByActualId(selectedNotification.getMemberId());
                    if (memberBean != null) {
                        formMetaDataUtil.setMetaDataForRchFormByFormType(nextEntity, memberBean.getActualId(), memberBean.getFamilyId(), selectedNotification, sharedPref, memberBean.getMemberUuid());
                    }
                }
            } catch (DataException e) {
                View.OnClickListener listener = v -> {
                    alertDialog.dismiss();
                    navigateToHomeScreen(false);
                };
                alertDialog = new MyAlertDialog(this, false,
                        UtilBean.getMyLabel(LabelConstants.ERROR_TO_REFRESH_ALERT), listener, DynamicUtils.BUTTON_OK);
                alertDialog.show();
                return;
            }
            Intent intent = new Intent(NotificationCBVActivity.this, DynamicFormActivity_.class);
            intent.putExtra(SewaConstants.ENTITY, nextEntity);
            startActivityForResult(intent, REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY);
        }
        hideProcessDialog();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //We will get scan results here
        IntentResult resultForQRScanner = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE_FOR_NOTIFICATION_ACTIVITY) {
            showProcessDialog();
            offset = 0;
            onActivityResultBackgroundTask();
        } else if (requestCode == REQUEST_CODE_FOR_OTHER_NOTIFICATION_ACTIVITY) {
            addNotificationTypeScreen();
        } else if (requestCode == ActivityConstants.LOCATION_SELECTION_ACTIVITY_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                locationIdForAllFam = data.getStringExtra(FieldNameConstants.LOCATION_ID);
                Integer locationId = Integer.parseInt(Objects.requireNonNull(data.getStringExtra(FieldNameConstants.LOCATION_ID)));
                selectedAreaIds.clear();
                selectedAreaIds.add(locationId);
                showProcessDialog();
                retrieveCountsForEachNotificationType();
            } else {
                navigateToHomeScreen(false);
            }
        } else if (resultForQRScanner != null) {
            if (resultForQRScanner.getContents() == null) {
                SewaUtil.generateToast(this, LabelConstants.FAILED_TO_SCAN_QR);
            } else {
                //show dialogue with resultForQRScanner
                String scanningData = resultForQRScanner.getContents();
                Log.i(TAG, "QR Scanner Data : " + scanningData);
                retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, scanningData);
            }
        } else {
            navigateToHomeScreen(false);
        }
    }

    private void onActivityResultBackgroundTask() {
        try {
            selectedNotification = null;
            this.offset = 0;
            notificationBeanList = notificationService.retrieveNotificationsForUser(selectedVillageIds, selectedAreaIds, selectedNotificationCode, null, LIMIT, 0, qrScanFilter);
            this.offset = this.offset + LIMIT;
            if (notificationBeanList != null && !notificationBeanList.isEmpty()) {
                bodyLayoutContainer.removeAllViews();
                addLastUpdateLabel();
                addSearchTextBox();
                addNotificationSelectionScreen(false);
            } else {
                notificationsCountMap = notificationService.retrieveCountForNotificationType(selectedVillageIds, selectedAreaIds);
                addNotificationTypeScreen();
            }
        } catch (SQLException e) {
            navigateToHomeScreen(false);
            Log.e(getClass().getName(), null, e);
        }
    }

    @UiThread
    public void showReadOnlyNotification() {
        screenName = READ_ONLY_NOTIFICATION_SCREEN;
        bodyLayoutContainer.removeAllViews();
        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, selectedNotification.getOtherDetails()));
        nextButton.setText(UtilBean.getMyLabel(LabelConstants.MARK_AS_READ));
        offset = 0;

        final View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                showProcessDialog();
                bodyLayoutContainer.removeAllViews();
                addLastUpdateLabel();
                addSearchTextBox();
                nextButton.setText(GlobalTypes.EVENT_NEXT);
                nextButton.setOnClickListener(onClickListener);
                markNotificationAsReadAndRetrieveData();
            } else {
                alertDialog.dismiss();
            }
        };

        nextButton.setOnClickListener(v -> {
            alertDialog = new MyAlertDialog(NotificationCBVActivity.this,
                    LabelConstants.CONFORMATION_TO_MARK_NOTIFICATION_AS_READ,
                    myListener, DynamicUtils.BUTTON_YES_NO);
            alertDialog.show();
        });

    }

    @Background
    public void markNotificationAsReadAndRetrieveData() {
        fhsService.markNotificationAsRead(selectedNotification);
        notificationsCountMap = notificationService.retrieveCountForNotificationType(selectedVillageIds, selectedAreaIds);
        retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (screenName == null || screenName.isEmpty()) {
            navigateToHomeScreen(false);
            return true;
        }

        if (item.getItemId() == android.R.id.home) {
            switch (screenName) {
                case NOTIFICATION_TYPE_SELECTION_SCREEN:
                    startLocationSelectionActivity();
                    break;
                case NOTIFICATION_SELECTION_SCREEN:
                    offset = 0;
                    showProcessDialog();
                    retrieveCountsForEachNotificationType();
                    nextButton.setText(GlobalTypes.EVENT_NEXT);
                    break;
                case MIGRATION_REVERT_NOTIFICATION_SCREEN:
                case READ_ONLY_NOTIFICATION_SCREEN:
                case HOUSE_HOLD_NEARBY_MALARIA_SCREENING:
                    bodyLayoutContainer.removeAllViews();
                    showProcessDialog();
                    addLastUpdateLabel();
                    addSearchTextBox();
                    retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
                    nextButton.setText(GlobalTypes.EVENT_NEXT);
                    nextButton.setOnClickListener(this);
                    break;
                default:
            }
            footerView.setVisibility(View.VISIBLE);
            return true;
        }
        return false;
    }

    private void hideKeyboard() {
        InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
        View view = getCurrentFocus();
        if (view == null) {
            view = new View(this);
        }
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

    @Override
    public void onSearchClick(String searchType, String searchText, Date date) {
        if (isNearbyHouseholdSearch) {
            searchMembers(searchText.replace("'", "\''"));
        } else {
            runOnUiThread(() -> retrieveInitialNotificationsFromDB(selectedNotificationCode, searchText.replace("'", "\''"), LIMIT, offset, null));
        }

        hideKeyboard();
    }

    @Override
    public void onClearClick() {
        if (isNearbyHouseholdSearch) {
            retrieveMembersWithin150M(notificationBeanList);
        } else {
            retrieveInitialNotificationsFromDB(selectedNotificationCode, null, LIMIT, offset, null);
        }
        hideKeyboard();
    }
}
