package com.argusoft.sewa.android.app.activity;

import android.content.Intent;
import android.os.Bundle;
import android.view.Gravity;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.Spinner;

import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyProcessDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.databean.RchVillageProfileDataBean;
import com.argusoft.sewa.android.app.databean.WorkerDetailDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.LocationBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by prateek on 23/6/18.
 */

@EActivity
public class RchVillageProfileActivity extends MenuActivity implements View.OnClickListener {

    @Bean
    SewaFhsServiceImpl fhsService;
    private List<LocationBean> locationBeans = new ArrayList<>();
    private LinearLayout bodyLayoutContainer;
    private RchVillageProfileDataBean villageProfile;
    private Button nextButton;
    private LocationBean selectedLocation;
    private boolean isVillageSelectionScreen = Boolean.FALSE;
    private boolean isVillageProfileScreen = Boolean.FALSE;
    private boolean isContactDetailsScreen = Boolean.FALSE;
    private boolean isWorkerDetailsScreen = Boolean.FALSE;
    private Spinner spinner;
    private LinearLayout globalPanel;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initView();
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
        setTitle(UtilBean.getTitleText(LabelConstants.VILLAGE_PROFILE_TITLE));
    }

    private void initView() {
        processDialog = new MyProcessDialog(this, GlobalTypes.MSG_PROCESSING);
        processDialog.show();
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(this, this);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        setBodyDetail();

    }

    @Background
    public void setBodyDetail() {
        locationBeans = fhsService.getDistinctLocationsAssignedToUser();
        if (locationBeans.size() == 1) {
            selectedLocation = locationBeans.get(0);
            isVillageSelectionScreen = Boolean.FALSE;
            isVillageProfileScreen = Boolean.TRUE;
            getRchVillageProfileDataBeanNetworkCall();
        } else if (locationBeans.isEmpty()) {
            isVillageProfileScreen = Boolean.TRUE;
            getRchVillageProfileDataBeanNetworkCall();
        } else {
            isVillageSelectionScreen = Boolean.TRUE;
            addVillageSelectionSpinner();
        }

    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            if (isVillageSelectionScreen) {
                String selectedVillage = spinner.getSelectedItem().toString();
                for (LocationBean locationBean : locationBeans) {
                    if (selectedVillage.equals(locationBean.getName())) {
                        selectedLocation = locationBean;
                        break;
                    }
                }
                bodyLayoutContainer.removeAllViews();
                getRchVillageProfileDataBeanNetworkCall();
                isVillageSelectionScreen = Boolean.FALSE;
                isVillageProfileScreen = Boolean.TRUE;
            } else if (isVillageProfileScreen) {
                bodyLayoutContainer.removeAllViews();
                createContactDetailsScreen();
                isContactDetailsScreen = Boolean.TRUE;
                isVillageProfileScreen = Boolean.FALSE;
            } else if (isContactDetailsScreen) {
                bodyLayoutContainer.removeAllViews();
                createWorkerDetailsScreen();
                isContactDetailsScreen = Boolean.FALSE;
                isWorkerDetailsScreen = Boolean.TRUE;
                nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_OKAY));
            } else {
                navigateToHomeScreen(false);
            }
        }
    }

    private void addVillageSelectionSpinner() {
        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, UtilBean.getMyLabel(LabelConstants.SELECT_VILLAGE)));
        String[] arrayOfOptions = new String[locationBeans.size()];
        int i = 0;
        for (LocationBean locationBean : locationBeans) {
            arrayOfOptions[i] = locationBean.getName();
            i++;
        }
        spinner = MyStaticComponents.getSpinner(this, arrayOfOptions, 0, 2);
        bodyLayoutContainer.addView(spinner);
    }

    @Background
    public void getRchVillageProfileDataBeanNetworkCall() {
        villageProfile = fhsService.getRchVillageProfileDataBean(selectedLocation.getActualID().toString());
        createVillageProfileScreen();
    }

    @UiThread
    public void createVillageProfileScreen() {
        MaterialTextView villageNameView = MyStaticComponents.generateTitleView(this, selectedLocation.getName());
        villageNameView.setGravity(Gravity.CENTER);
        bodyLayoutContainer.addView(villageNameView);

        LinearLayout layout;
        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.BASIC_DETAILS));

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.TOTAL_POPULATION + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getTotalPopulation().toString()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.TOTAL_ELIGIBLE_COUPLE + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getTotalEligibleCouple().toString()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.PREGNANT_WOMEN_COUNT + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getPregnantWomenCount().toString()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.INFANT_CHILD_COUNT + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getInfantChildCount().toString()));
        bodyLayoutContainer.addView(layout);
    }

    private void createContactDetailsScreen() {
        MaterialTextView villageNameView = MyStaticComponents.generateTitleView(this, selectedLocation.getName());
        villageNameView.setGravity(Gravity.CENTER);
        bodyLayoutContainer.addView(villageNameView);

        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.EMERGENCY_CONTACT_DETAILS));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.NEAR_BY_HOSPITAL_ADDRESS_AND_PHONE + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getNearbyHospitalDetail()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.FRU_NAME_AND_PHONE + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFruDetail()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.AMBULANCE_NUMBER + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getAmbulanceNumber()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.TRANSPORTATION_NUMBER + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getTransportationNumber()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.NATIONAL_CALL_CENTER_NUMBER + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getNationalCallCentreNumber()));

        bodyLayoutContainer.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.HELPLINE_NUMBER + " : "));
        bodyLayoutContainer.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getHelplineNumber()));
    }

    private void createWorkerDetailsScreen() {
        MaterialTextView villageNameView = MyStaticComponents.generateTitleView(this, selectedLocation.getName());
        villageNameView.setGravity(Gravity.CENTER);
        bodyLayoutContainer.addView(villageNameView);

        LinearLayout layout;

        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.ASHA_DETAIL));
        int counter = 1;
        for (WorkerDetailDataBean asha : this.villageProfile.getAshaDetail()) {

            layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
            layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.ASHA + counter + " " + LabelConstants.NAME + " : "));
            layout.addView(MyStaticComponents.generateAnswerView(this, asha.getName()));
            bodyLayoutContainer.addView(layout);

            layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
            layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.ASHA + counter + " " + LabelConstants.MOBILE_NUMBER + " : "));
            layout.addView(MyStaticComponents.generateAnswerView(this, asha.getMobileNumber()));
            bodyLayoutContainer.addView(layout);

            layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
            layout.addView(MyStaticComponents.generateQuestionView(null, null, this, LabelConstants.ASHA + counter + " " + LabelConstants.AADHAR_NUMBER + " : "));
            layout.addView(MyStaticComponents.generateAnswerView(this, asha.getAadharNumber()));
            bodyLayoutContainer.addView(layout);
            counter++;
        }

        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.ANM_DETAIL));

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.NAME + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getAnmDetail().getName()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.MOBILE_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getAnmDetail().getMobileNumber()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.AADHAR_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getAnmDetail().getAadharNumber()));
        bodyLayoutContainer.addView(layout);

        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.FHW_DETAIL));

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.NAME + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getName()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.MOBILE_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getMobileNumber()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.AADHAR_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getAadharNumber()));
        bodyLayoutContainer.addView(layout);

        bodyLayoutContainer.addView(MyStaticComponents.generateInstructionView(this, LabelConstants.MPHW_DETAIL));

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.NAME + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getName()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.MOBILE_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getMobileNumber()));
        bodyLayoutContainer.addView(layout);

        layout = MyStaticComponents.getLinearLayout(this, 1, LinearLayout.HORIZONTAL, null);
        layout.addView(MyStaticComponents.generateQuestionView(null, null, this,  LabelConstants.AADHAR_NUMBER + " : "));
        layout.addView(MyStaticComponents.generateAnswerView(this, this.villageProfile.getFhwDetail().getAadharNumber()));
        bodyLayoutContainer.addView(layout);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == android.R.id.home) {
            if (isWorkerDetailsScreen) {
                bodyLayoutContainer.removeAllViews();
                createContactDetailsScreen();
                nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
                isWorkerDetailsScreen = Boolean.FALSE;
                isContactDetailsScreen = Boolean.TRUE;
            } else if (isContactDetailsScreen) {
                bodyLayoutContainer.removeAllViews();
                createVillageProfileScreen();
                isContactDetailsScreen = Boolean.FALSE;
                isVillageProfileScreen = Boolean.TRUE;
            } else if (isVillageProfileScreen) {
                bodyLayoutContainer.removeAllViews();
                if (locationBeans.isEmpty()) {
                    isVillageProfileScreen = Boolean.FALSE;
                    navigateToHomeScreen(false);
                } else {
                    isVillageSelectionScreen = Boolean.TRUE;
                    isVillageProfileScreen = Boolean.FALSE;
                    addVillageSelectionSpinner();
                }
            } else {
                isVillageSelectionScreen = Boolean.FALSE;
                navigateToHomeScreen(false);
            }
        }
        return true;
    }
}
