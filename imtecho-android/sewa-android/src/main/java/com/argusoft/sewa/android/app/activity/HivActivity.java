package com.argusoft.sewa.android.app.activity;


import static android.content.DialogInterface.BUTTON_POSITIVE;

import android.app.Activity;
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
import android.widget.LinearLayout;
import android.widget.ListView;

import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.OCR.OCRActivity_;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.component.PagingListView;
import com.argusoft.sewa.android.app.component.SearchComponent;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.databean.ListItemDataBean;
import com.argusoft.sewa.android.app.databean.MemberDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.exception.DataException;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.FormMetaDataUtil;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Objects;

@EActivity
public class HivActivity extends MenuActivity implements View.OnClickListener, PagingListView.PagingListener, SearchComponent.SearchClick, SearchComponent.ClearClick {
    @Bean
    SewaFhsServiceImpl fhsService;
    @Bean
    FormMetaDataUtil formMetaDataUtil;
    private static final String TAG = "HivActivity";
    private LinearLayout globalPanel;
    private LinearLayout bodyLayoutContainer;
    private LinearLayout footerLayout;
    private Button nextButton;
    private String screen;
    private MyAlertDialog myAlertDialog;
    private String selectedService;
    private MemberDataBean memberSelected = null;
    private int selectedPeopleIndex = -1;
    List<Integer> selectedAshaAreas = new ArrayList<>();
    String searchString;
    private long LIMIT;
    private long offset;
    int selectedVillage;
    private SearchComponent searchBox;
    private SharedPreferences sharedPref;
    private MaterialTextView pagingHeaderView;
    private PagingListView pagingListView;
    private MaterialTextView noMemberAvailableView;
    List<MemberDataBean> memberList = new ArrayList<>();
    LinkedHashMap<String, String> qrScanFilter;
    private int selectedMemberToUpdateIndex = -1;

    public static final String SERVICE_SELECTION_SCREEN = "SERVICE_SELECTION_SCREEN";
    public static final String HIV_SCREENING_SCREEN = "HIV_SCREENING_SCREEN";
    public static final String HIV_POSITIVE_PREGNANT_WOMAN = "HIV_POSITIVE_PREGNANT_WOMAN";

    public static final String HIV_SCREENING = "HIV_SCREENING";
    public static final String KNOWN_POSITIVE = "KNOWN_POSITIVE";
    public static final String POSITIVE_PREGNANT_WOMAN = "POSITIVE_PREGNANT_WOMAN";
    public static final String EMTCT = "EMTCT";
    public static final String SCREENING_MEMBER_SELECTION_SCREEN = "SCREENING_MEMBER_SELECTION_SCREEN";
    public static final String KNOWN_POSITIVE_SELECTION_SCREEN = "KNOWN_POSITIVE_SELECTION_SCREEN";
    public static final String POSITIVE_PREGNANT_WOMEN_SCREEN = "POSITIVE_PREGNANT_WOMEN_SCREEN";
    public static final String EMTCT_SCREEN = "EMTCT_SCREEN";
    Bundle extras;
    private Intent myIntent;


    @Override

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        getDataFromBundle();
        initView();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (Objects.equals(selectedService, SERVICE_SELECTION_SCREEN)) {
            footerLayout.setVisibility(View.GONE);
        }
        if (globalPanel != null) {
            setContentView(globalPanel);
        }
        if (!SharedStructureData.isLogin) {
            myIntent = new Intent(this, LoginActivity_.class);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(myIntent);
            finish();
        }
        setTitle(UtilBean.getTitleText(LabelConstants.HIV));
    }

    private void initView() {
        showProcessDialog();
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(this, this);
        setContentView(globalPanel);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        footerLayout = globalPanel.findViewById(DynamicUtils.ID_FOOTER);
        nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        setContentView(globalPanel);
        setBodyDetail();
    }

    public void getDataFromBundle() {
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            selectedAshaAreas = new Gson().fromJson(this.getIntent().getStringExtra("selectedAshaAreas"),
                    new TypeToken<List<String>>() {
                    }.getType());
            searchString = extras.getString("search");
            LIMIT = extras.getLong("limit");
            offset = extras.getLong("offset");
            selectedVillage = extras.getInt("selectedVillage");
        }
    }

    @Background
    public void setBodyDetail() {
        setServiceSelectionScreen();
    }

    @UiThread
    public void setServiceSelectionScreen() {
        qrScanFilter = new LinkedHashMap<>();
        bodyLayoutContainer.removeAllViews();
        screen = SERVICE_SELECTION_SCREEN;

        List<ListItemDataBean> items = new ArrayList<>();
        items.add(new ListItemDataBean(UtilBean.getMyLabel(LabelConstants.HIV_SCREENING)));
        items.add(new ListItemDataBean(UtilBean.getMyLabel(LabelConstants.KNOWN_POSITIVE)));
        items.add(new ListItemDataBean(UtilBean.getMyLabel(LabelConstants.POSITIVE_PREGNANT_WOMEN)));
        items.add(new ListItemDataBean(UtilBean.getMyLabel(LabelConstants.EMTCT)));

        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            switch (position) {
                case 0:
                    bodyLayoutContainer.removeAllViews();
                    addSearchTextBox();
                    retrieveHivScreeningScreen(null);
                    selectedService = HIV_SCREENING;
                    break;
                case 1:
                    bodyLayoutContainer.removeAllViews();
                    addSearchTextBox();
                    retrieveKnownPositiveScreen(null);
                    selectedService = KNOWN_POSITIVE;
                    break;
                case 2:
                    bodyLayoutContainer.removeAllViews();
                    addSearchTextBox();
                    retrievePositivePregnantWomenScreen(null);
                    selectedService = POSITIVE_PREGNANT_WOMAN;
                    break;
                case 3:
                    bodyLayoutContainer.removeAllViews();
                    addSearchTextBox();
                    retrieveMembersForEMTCTScreen(null);
                    selectedService = EMTCT;
                    break;
            }
        };
        ListView listView = MyStaticComponents.getPaginatedListViewWithItem(this, items, R.layout.listview_row_type, onItemClickListener, null);
        bodyLayoutContainer.addView(listView);
        nextButton.setText(GlobalTypes.EVENT_NEXT);
        nextButton.setOnClickListener(this);
        footerLayout.setVisibility(View.GONE);
        hideProcessDialog();
        hideKeyboard();
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            setSubTitle(null);
            switch (selectedService) {
                case HIV_SCREENING:
                    if (selectedPeopleIndex != -1) {
                        showProcessDialog();
                        memberSelected = memberList.get(selectedPeopleIndex);
                        setSubTitle(UtilBean.getMemberFullName(memberSelected));
                        showAlertAndNavigate(FormConstants.HIV_SCREENING);
                    } else {
                        SewaUtil.generateToast(context, "Please select a member");
                    }
                    break;
                case KNOWN_POSITIVE:
                    if (selectedPeopleIndex != -1) {
                        showProcessDialog();
                        memberSelected = memberList.get(selectedPeopleIndex);
                        setSubTitle(UtilBean.getMemberFullName(memberSelected));
                        showAlertAndNavigate(FormConstants.KNOWN_POSITIVE);
                    } else {
                        SewaUtil.generateToast(context, "Please select a member");
                    }
                    break;
                case POSITIVE_PREGNANT_WOMAN:
                    if (selectedPeopleIndex != -1) {
                        showProcessDialog();
                        memberSelected = memberList.get(selectedPeopleIndex);
                        setSubTitle(UtilBean.getMemberFullName(memberSelected));
                        showAlertAndNavigate(FormConstants.HIV_POSITIVE);
                    } else {
                        SewaUtil.generateToast(context, "Please select a member");
                    }
                    break;
                case EMTCT:
                    if (selectedPeopleIndex != -1) {
                        showProcessDialog();
                        memberSelected = memberList.get(selectedPeopleIndex);
                        setSubTitle(UtilBean.getMemberFullName(memberSelected));
                        showAlertAndNavigate(FormConstants.EMTCT);
                    } else {
                        SewaUtil.generateToast(context, "Please select a member");
                    }
                    break;
            }
        }
    }

    private void showAlertAndNavigate(String formConstant) {
        View.OnClickListener myListener = view -> {
            if (view.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                startDynamicFormActivity(formConstant, memberSelected);
            } else {
                alertDialog.dismiss();
                startOCRActivity(formConstant, memberSelected);
            }
        };
        alertDialog = new MyAlertDialog(this,
                UtilBean.getMyLabel("Select form filling type"),
                myListener, DynamicUtils.BUTTON_YES_NO, "Manual", "OCR", null);
        alertDialog.show();
    }

    private void startOCRActivity(final String formType, MemberDataBean memberDataBean) {
        sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
        try {
            formMetaDataUtil.setMetaDataForRchFormByFormType(formType, memberDataBean.getId(), memberDataBean.getFamilyId(), null, sharedPref, memberDataBean.getMemberUuid());
        } catch (DataException e) {
            showProcessDialog();
            View.OnClickListener listener = clickView -> {
                alertDialog.dismiss();
                navigateToHomeScreen(false);
            };
            alertDialog = new MyAlertDialog(this, false,
                    UtilBean.getMyLabel(LabelConstants.ERROR_TO_REFRESH_ALERT), listener, DynamicUtils.BUTTON_OK);
            alertDialog.show();
            return;
        }
        myIntent = new Intent(this, OCRActivity_.class);
        myIntent.putExtra(SewaConstants.ENTITY, formType);
        myIntent.putExtra(FieldNameConstants.UNIQUE_HEALTH_ID, memberSelected.getUniqueHealthId());
        myIntent.putExtra(FieldNameConstants.MEMBER_UUID, memberSelected.getMemberUuid());
        startActivityForResult(myIntent,1);
        hideProcessDialog();
    }


    private void startDynamicFormActivity(final String formType, MemberDataBean memberDataBean) {
        showProcessDialog();
        sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
        formMetaDataUtil.setMetaDataForRchFormByFormType(formType, memberDataBean.getId(), memberDataBean.getFamilyId(), null, sharedPref, memberDataBean.getMemberUuid());

        myIntent = new Intent(this, DynamicFormActivity_.class);
        myIntent.putExtra(SewaConstants.ENTITY, formType);
        startActivityForResult(myIntent, 2);
        hideProcessDialog();
    }

    @Background
    public void retrieveHivScreeningScreen(CharSequence s) {
        screen = HIV_SCREENING_SCREEN;
        offset = 0;
        memberList = fhsService.retrieveMembersForHIVScreening(selectedAshaAreas, selectedVillage, s, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        setMemberSelectionScreen(selectedService, s != null);
    }

    @Background
    public void retrieveKnownPositiveScreen(CharSequence s) {
        screen = KNOWN_POSITIVE;
        offset = 0;
        memberList = fhsService.retrieveMembersForKnownScreening(selectedAshaAreas, selectedVillage, s, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        setMemberSelectionScreen(selectedService, s != null);
    }

    @Background
    public void retrievePositivePregnantWomenScreen(CharSequence s) {
        screen = HIV_POSITIVE_PREGNANT_WOMAN;
        offset = 0;
        memberList = fhsService.retrieveHIVPositiveMembers(selectedAshaAreas, selectedVillage, s, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        setMemberSelectionScreen(selectedService, s != null);
    }

    @Background
    public void retrieveMembersForEMTCTScreen(CharSequence s) {
        screen = EMTCT;
        offset = 0;
        memberList = fhsService.retrieveEMTCTMembers(selectedAshaAreas, selectedVillage, s, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        setMemberSelectionScreen(selectedService, s != null);
    }

    @UiThread
    public void setMemberSelectionScreen(String selectedService, boolean isSearch) {
        switch (selectedService) {
            case HIV_SCREENING:
                setMembersForHiv(isSearch);
                break;
            case KNOWN_POSITIVE:
                setMembersForKnownPositive(isSearch);
                break;
            case POSITIVE_PREGNANT_WOMAN:
                setMembersForPositivePregnantWomen(isSearch);
                break;
            case EMTCT:
                setMembersEMTCT(isSearch);
                break;
        }
        showProcessDialog();
    }

    @Override
    public void onBackPressed() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                myAlertDialog.dismiss();
                navigateToHomeScreen(false);
                finish();
            } else {
                myAlertDialog.dismiss();
            }
        };

        myAlertDialog = new MyAlertDialog(this,
                LabelConstants.ON_MY_PEOPLE_ACTIVITY_CLOSE_ALERT,
                myListener, DynamicUtils.BUTTON_YES_NO);
        myAlertDialog.show();
    }

    @UiThread
    public void setMembersForKnownPositive(boolean isSearch) {
        selectedPeopleIndex = -1;
        screen = KNOWN_POSITIVE_SELECTION_SCREEN;
        bodyLayoutContainer.removeView(noMemberAvailableView);
        bodyLayoutContainer.removeView(pagingHeaderView);
        bodyLayoutContainer.removeView(pagingListView);
        footerLayout.setVisibility(View.VISIBLE);

        if (memberList != null && !memberList.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_MEMBER);
            bodyLayoutContainer.addView(pagingHeaderView);
            List<ListItemDataBean> membersList = getMembersList(memberList);
            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
                if (memberList.size() > position) {
                    selectedPeopleIndex = position;
                }
            };
            if (isSearch) {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, null);
            } else {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, this);
            }
            bodyLayoutContainer.addView(pagingListView);
        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }

        hideProcessDialog();

        if (memberList == null || memberList.isEmpty()) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> navigateToHomeScreen(false));
        } else {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
            nextButton.setOnClickListener(this);
        }
    }

    @UiThread
    public void setMembersForHiv(boolean isSearch) {
        selectedPeopleIndex = -1;
        screen = SCREENING_MEMBER_SELECTION_SCREEN;
        bodyLayoutContainer.removeView(noMemberAvailableView);
        bodyLayoutContainer.removeView(pagingHeaderView);
        bodyLayoutContainer.removeView(pagingListView);
        footerLayout.setVisibility(View.VISIBLE);

        if (memberList != null && !memberList.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_MEMBER);
            bodyLayoutContainer.addView(pagingHeaderView);
            List<ListItemDataBean> membersList = getMembersList(memberList);
            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
                if (memberList.size() > position) {
                    selectedPeopleIndex = position;
                }
            };
            if (isSearch) {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, null);
            } else {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, this);
            }
            bodyLayoutContainer.addView(pagingListView);
        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }

        hideProcessDialog();

        if (memberList == null || memberList.isEmpty()) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> navigateToHomeScreen(false));
        } else {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
            nextButton.setOnClickListener(this);
        }
    }

    @UiThread
    public void setMembersForPositivePregnantWomen(boolean isSearch) {
        screen = POSITIVE_PREGNANT_WOMEN_SCREEN;
        selectedPeopleIndex = -1;
        bodyLayoutContainer.removeView(noMemberAvailableView);
        bodyLayoutContainer.removeView(pagingHeaderView);
        bodyLayoutContainer.removeView(pagingListView);
        footerLayout.setVisibility(View.VISIBLE);

        if (memberList != null && !memberList.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_MEMBER);
            bodyLayoutContainer.addView(pagingHeaderView);
            List<ListItemDataBean> membersList = getMembersList(memberList);
            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
                if (memberList.size() > position) {
                    selectedPeopleIndex = position;
                }
            };
            if (isSearch) {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, null);
            } else {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, this);
            }
            bodyLayoutContainer.addView(pagingListView);
        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }

        hideProcessDialog();

        if (memberList == null || memberList.isEmpty()) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> navigateToHomeScreen(false));
        } else {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
            nextButton.setOnClickListener(this);
        }
    }

    @UiThread
    public void setMembersEMTCT(boolean isSearch) {
        screen = EMTCT_SCREEN;
        selectedPeopleIndex = -1;
        bodyLayoutContainer.removeView(noMemberAvailableView);
        bodyLayoutContainer.removeView(pagingHeaderView);
        bodyLayoutContainer.removeView(pagingListView);
        footerLayout.setVisibility(View.VISIBLE);

        if (memberList != null && !memberList.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.SELECT_MEMBER);
            bodyLayoutContainer.addView(pagingHeaderView);
            List<ListItemDataBean> membersList = getMembersList(memberList);
            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
                if (memberList.size() > position) {
                    selectedPeopleIndex = position;
                }
            };
            if (isSearch) {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, null);
            } else {
                pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, membersList, R.layout.listview_row_with_three_item_chip, onItemClickListener, this);
            }
            bodyLayoutContainer.addView(pagingListView);
        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }

        hideProcessDialog();

        if (memberList == null || memberList.isEmpty()) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            nextButton.setOnClickListener(v -> navigateToHomeScreen(false));
        } else {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
            nextButton.setOnClickListener(this);
        }
    }

    @UiThread
    public void addSearchTextBox() {
        searchBox = new SearchComponent(context, null, LabelConstants.MEMBER_ID_OR_NAME_TO_SEARCH, null, this, this, null, null);
        //searchBox.addTextWatcherInEditText(getSearchClickOffline());
        bodyLayoutContainer.addView(searchBox);
    }

    private List<ListItemDataBean> getMembersList(List<MemberDataBean> memberDataBeanList) {
        List<ListItemDataBean> list = new ArrayList<>();
        switch (selectedService) {
            case HIV_SCREENING:
            case KNOWN_POSITIVE:
            case POSITIVE_PREGNANT_WOMAN:
            case EMTCT:
                for (MemberDataBean memberDataBean : memberDataBeanList) {
                    String age = "N/A";
                    int week;
                    int year;
                    String gender = memberDataBean.getGender().equalsIgnoreCase("M") ? LabelConstants.MALE : LabelConstants.FEMALE;
                    if (memberDataBean.getDob() != null) {
                        week = UtilBean.getNumberOfWeeks(new Date(memberDataBean.getDob()), new Date());
                        year = UtilBean.calculateAgeYearMonthDay(memberDataBean.getDob())[0];
                        if (week < 52) {
                            String weekText = week == 1 ? "Week" : "Weeks";
                            age = String.format("Age - %s %s", week, weekText);
                        } else {
                            String yearText = year == 1 ? "Year" : "Years";
                            age = String.format("Age - %s %s", year, yearText);
                        }
                    }
                    list.add(new ListItemDataBean(memberDataBean.getFamilyId(), memberDataBean.getUniqueHealthId(), UtilBean.getMemberFullName(memberDataBean), age, gender));
                }
                break;

        }
        return list;
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
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == android.R.id.home) {
            setSubTitle(null);
            switch (screen) {
                case SERVICE_SELECTION_SCREEN:
                    finish();
                    break;
                case POSITIVE_PREGNANT_WOMEN_SCREEN:
                case KNOWN_POSITIVE_SELECTION_SCREEN:
                case SCREENING_MEMBER_SELECTION_SCREEN:
                case EMTCT_SCREEN:
                    setServiceSelectionScreen();
                    break;
            }
        }
        return true;
    }

    @Override
    public void onLoadMoreItems() {
        switch (selectedService) {
            case HIV_SCREENING:
                loadMoreMemberToScreenForHivScreening();
                break;
            case KNOWN_POSITIVE:
                loadMoreMemberToScreenForKnownPositive();
                break;
            case POSITIVE_PREGNANT_WOMAN:
                loadMoreMemberToScreenForPregWoman();
                break;
            case EMTCT:
                loadMoreMemberEMTCT();
                break;
        }
    }

    @UiThread
    public void onLoadMoreUiMember(List<MemberDataBean> memberDataBeanList) {
        if (memberDataBeanList != null && !memberDataBeanList.isEmpty()) {
            List<ListItemDataBean> membersList = getMembersList(memberDataBeanList);
            memberList.addAll(memberDataBeanList);
            pagingListView.onFinishLoadingWithItem(true, membersList);
        } else {
            pagingListView.onFinishLoadingWithItem(false, null);
        }
    }

    @Background
    public void loadMoreMemberToScreenForHivScreening() {
        List<MemberDataBean> memberDataBeanList = fhsService.retrieveMembersForHIVScreening(selectedAshaAreas, selectedVillage, searchString, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        onLoadMoreUiMember(memberDataBeanList);
    }

    @Background
    public void loadMoreMemberToScreenForKnownPositive() {
        List<MemberDataBean> memberDataBeanList = fhsService.retrieveMembersForKnownScreening(selectedAshaAreas, selectedVillage, searchString, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        onLoadMoreUiMember(memberDataBeanList);
    }

    @Background
    public void loadMoreMemberToScreenForPregWoman() {
        List<MemberDataBean> memberDataBeanList = fhsService.retrieveHIVPositiveMembers(selectedAshaAreas, selectedVillage, searchString, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        onLoadMoreUiMember(memberDataBeanList);
    }

    @Background
    public void loadMoreMemberEMTCT() {
        List<MemberDataBean> memberDataBeanList = fhsService.retrieveEMTCTMembers(selectedAshaAreas, selectedVillage, searchString, LIMIT, offset, qrScanFilter);
        offset = offset + LIMIT;
        onLoadMoreUiMember(memberDataBeanList);
    }

    @Override
    public void onSearchClick(String searchType, String searchText, Date date) {
        runOnUiThread(() -> {
            switch (selectedService) {
                case HIV_SCREENING:
                    retrieveHivScreeningScreen(searchText.replace("'", "\''"));
                    break;
                case KNOWN_POSITIVE:
                    retrieveKnownPositiveScreen(searchText.replace("'", "\''"));
                    break;
                case POSITIVE_PREGNANT_WOMAN:
                    retrievePositivePregnantWomenScreen(searchText.replace("'", "\''"));
                    break;
                case EMTCT:
                    retrieveMembersForEMTCTScreen(searchText.replace("'", "\''"));
                    break;
            }
        });
        hideKeyboard();
    }

    @Override
    public void onClearClick() {
        runOnUiThread(() -> {
            switch (selectedService) {
                case HIV_SCREENING:
                    retrieveHivScreeningScreen(null);
                    break;
                case KNOWN_POSITIVE:
                    retrieveKnownPositiveScreen(null);
                    break;
                case POSITIVE_PREGNANT_WOMAN:
                    retrievePositivePregnantWomenScreen(null);
                    break;
                case EMTCT:
                    retrieveMembersForEMTCTScreen(null);
                    break;
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        setMemberSelectionScreen(selectedService, false);
    }
}
