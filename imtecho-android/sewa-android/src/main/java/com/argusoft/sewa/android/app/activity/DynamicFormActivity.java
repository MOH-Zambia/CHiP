package com.argusoft.sewa.android.app.activity;

import static android.content.DialogInterface.BUTTON_NEGATIVE;
import static android.content.DialogInterface.BUTTON_POSITIVE;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyProcessDialog;
import com.argusoft.sewa.android.app.component.MyQRcodeDialog;
import com.argusoft.sewa.android.app.constants.ActivityConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.NotificationConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.impl.HealthInfraTypeLocationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.HealthInfrastructureServiceImpl;
import com.argusoft.sewa.android.app.core.impl.ImmunisationServiceImpl;
import com.argusoft.sewa.android.app.core.impl.LocationMasterServiceImpl;
import com.argusoft.sewa.android.app.core.impl.MoveToProductionServiceImpl;
import com.argusoft.sewa.android.app.core.impl.RchHighRiskServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceRestClientImpl;
import com.argusoft.sewa.android.app.core.impl.TechoServiceImpl;
import com.argusoft.sewa.android.app.core.impl.VersionServiceImpl;
import com.argusoft.sewa.android.app.datastructure.FormEngine;
import com.argusoft.sewa.android.app.datastructure.PageFormBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.exception.DataException;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.morbidities.constants.MorbiditiesConstant;
import com.argusoft.sewa.android.app.restclient.RestHttpException;
import com.argusoft.sewa.android.app.service.GPSTracker;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.AadharScanUtil;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.FormMetaDataUtil;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.PointInPolygon;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textfield.TextInputLayout;
import com.google.gson.Gson;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Objects;

/**
 * @author alpeshkyada
 */
@EActivity
public class DynamicFormActivity extends MenuActivity implements View.OnClickListener {

    public static FormEngine formEngine;

    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaFhsServiceImpl sewaFhsService;
    @Bean
    RchHighRiskServiceImpl rchHighRiskService;
    @Bean
    ImmunisationServiceImpl immunisationService;
    @Bean
    TechoServiceImpl techoService;
    @Bean
    FormMetaDataUtil formMetaDataUtil;
    @Bean
    MoveToProductionServiceImpl moveToProductionService;
    @Bean
    HealthInfrastructureServiceImpl healthInfrastructureService;
    @Bean
    LocationMasterServiceImpl locationMasterService;
    @Bean
    SewaServiceRestClientImpl serviceRestClient;
    @Bean
    VersionServiceImpl versionService;
    @Bean
    HealthInfraTypeLocationServiceImpl healthInfraTypeLocationService;

    private static final String TAG = "DynamicFormActivity";
    private SharedPreferences sharedPref;
    //  Required Fields
    private String formType;
    private boolean allowForm;
    private boolean isLabTestForm = false;
    private Integer labTestFormDetId;
    private String labTestVersion;
    private MyAlertDialog myDialog;
    private String answerString;
    private boolean isProperFinish = true;
    private String currentLatitude;
    private String currentLongitude;
    private boolean isGenerateQr = false;
    private boolean isBackFromBetween;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        showProcessDialog();
        getLgdWiseCoordinates();
        context = this;
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        try {
            formType = getIntent().getStringExtra(SewaConstants.ENTITY);
            allowForm = getIntent().getBooleanExtra(SewaConstants.ALLOW_SECOND_FORM_SAME_MEMBER_OFFLINE, Boolean.FALSE);
            isLabTestForm = getIntent().getBooleanExtra("isOPDLabTestForm", Boolean.FALSE);
            isGenerateQr = getIntent().getBooleanExtra("isGenerateQr", Boolean.FALSE);
            if (isLabTestForm) {
                labTestFormDetId = Integer.parseInt(getIntent().getStringExtra("labTestDetId"));
                labTestVersion = getIntent().getStringExtra("version");
            }
            initView();
        } catch (Exception e) {
            Log.e(getClass().getName(), null, e);
            sewaService.storeException(e, GlobalTypes.EXCEPTION_TYPE_DYNAMIC_FORM);
            showToaster(LabelConstants.ERROR_OCCURRED_SO_TRY_AGAIN_LATER);
            formType = "DynamicForm";
        }
    }

    @Background
    public void getLgdWiseCoordinates() {
        techoService.getLgdCodeWiseCoordinates();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (!SharedStructureData.isLogin) {
            Intent myIntent = new Intent(this, LoginActivity_.class);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(myIntent);
            finish();
        }
        retrieveSheet();
    }

    private void initView() {
        if (!GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
            checkIfAnyFormSyncIsPending();
        }
    }

    private void checkIfAnyFormSyncIsPending() {
        if (allowForm) {
            return;
        }

        if (!BuildConfig.FLAVOR.equalsIgnoreCase(GlobalTypes.FLAVOUR_DNHDD)) {
            if (SewaTransformer.loginBean.getUserRole().equals(GlobalTypes.USER_ROLE_ASHA)) {
                return;
            }
            if (formType != null && (FormConstants.NCD_SHEETS.contains(formType)
                    || FormConstants.IDSP_MEMBER.equals(formType)
                    || FormConstants.IDSP_MEMBER_2.equals(formType))) {
                return;
            }
        }

        String memberId = SharedStructureData.relatedPropertyHashTable.get("memberId");
        if (memberId != null) {
            boolean aBoolean = techoService.checkIfOfflineAnyFormFilledForMember(Long.valueOf(memberId));
            if (aBoolean) {
                showAlertAndFinish(LabelConstants.MSG_REFRESH_AND_TRY_AGAIN);
            }
        }
    }

    @Background
    public void retrieveSheet() {
        try {
            if (formEngine == null && formType != null) {
                SharedStructureData.formFillUpTime = new Date().getTime(); // set form start tym on first retrieval of question
                sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
                sharedPref.edit().putString(RelatedPropertyNameConstants.FORM_START_DATE, String.valueOf(new Date().getTime())).apply();
                SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.FORM_START_DATE, String.valueOf(new Date().getTime()));
                loadQuestionsAndQuestion();
                checkForGpsEnabledForms();
                runOnUiThread(() -> {
                    formEngine = FormEngine.generateForm(DynamicFormActivity.this, formType);
                    setContentView();
                });
            } else {
                setContentView();
            }
        } catch (Exception e) {
            hideProcessDialog();
            sewaService.storeException(e, GlobalTypes.EXCEPTION_TYPE_DYNAMIC_FORM);
            showToaster(LabelConstants.ERROR_OCCURRED_SO_TRY_AGAIN_LATER);
            Log.e(getClass().getName(), null, e);
            finish();
        }
    }

    @UiThread
    public void setContentView() {
        if (formEngine != null) {
            setContentView(formEngine.getPageView());
            String formName = DynamicUtils.getFullFormName(formType);
            System.out.println(">>>>>>>>>" + formName);

            if ((formType.equals(FormConstants.FHS_MEMBER_UPDATE) || formType.equals(FormConstants.FHS_MEMBER_UPDATE_NEW))
                    && (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY) == null)) {
                formName = UtilBean.getFullFormOfEntity().get(FormConstants.FHS_ADD_MEMBER);
            }
            if (isLabTestForm) {
                setTitle(UtilBean.getMyLabel(LabelConstants.OPD_LAB_TEST));
            } else {
                setTitle(formName);
            }
            if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY) != null) {
                setSubTitle(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.NAME_OF_BENEFICIARY));
            }
            if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.SUB_TITLE_DETAILS) != null) {
                setSubTitleDetails(SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.SUB_TITLE_DETAILS));
            }
            hideProcessDialog();
        }
    }

    private void loadQuestionsAndQuestion() {
        Log.d(TAG, "Form Title : " + formType + " is Loaded ...................");
        SharedStructureData.initIndexQuestionMap(this,
                sewaService,
                sewaFhsService,
                rchHighRiskService,
                immunisationService,
                healthInfrastructureService,
                locationMasterService,
                serviceRestClient,
                versionService,
                healthInfraTypeLocationService);

        sewaService.loadQuestionsBySheet(formType);
    }

    @UiThread
    public void checkForGpsEnabledForms() {
        if (isLabTestForm || SharedStructureData.gpsEnabledForms.contains(formType)) {
            // fetch current location either by gps or network if gps is disabled
            if (!SharedStructureData.gps.isLocationProviderEnabled()) {
                // Ask user to enable GPS/network in settings
                SharedStructureData.gps.showSettingsAlert(context);
            } else {
                SharedStructureData.gps.getLocation();
                currentLatitude = String.valueOf(GPSTracker.latitude);
                currentLongitude = String.valueOf(GPSTracker.longitude);
                SharedStructureData.relatedPropertyHashTable.put("currentLatitude", currentLatitude);
                SharedStructureData.relatedPropertyHashTable.put("currentLongitude", currentLongitude);

                if (!PointInPolygon.coordinateInsidePolygon()) {
                    UtilBean.showAlertAndExit(GlobalTypes.MSG_GEO_FENCING_VIOLATION, this);
                }
            }
        }
    }

    @Override
    public void onBackPressed() {
        if (formType != null && !formType.equalsIgnoreCase("DynamicForm")) {
            isBackFromBetween = true;
            if (formType.equalsIgnoreCase(FormConstants.STOCK_MANAGEMENT)) {
                myDialog = new MyAlertDialog(DynamicFormActivity.this, LabelConstants.CLOSE_THE_STOCK_REQUEST, this, DynamicUtils.BUTTON_YES_NO);
            } else {
                myDialog = new MyAlertDialog(DynamicFormActivity.this, LabelConstants.CLOSE_THE_REGISTRATION, this, DynamicUtils.BUTTON_YES_NO);
            }
            myDialog.show();
        } else {
            processDialog = new MyProcessDialog(DynamicFormActivity.this, GlobalTypes.MSG_PROCESSING);
            processDialog.show();
            changeActivity();
            processDialog.dismiss();
            finish();
        }
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if (id == BUTTON_POSITIVE) {
            if (SharedStructureData.ordtTimer != null) {
                SharedStructureData.ordtTimer.cancel();
            }
            isProperFinish = false;
            myDialog.dismiss();
            changeActivity();
            finish();
        } else if (id == BUTTON_NEGATIVE) {
            myDialog.dismiss();
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //We will get scan results here
        IntentResult resultForQRScanner = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        // Check first for location service
        if (requestCode == GlobalTypes.LOCATION_SERVICE_ACTIVITY) {
            if (!SharedStructureData.gps.isLocationProviderEnabled()) {
                runOnUiThread(() -> SharedStructureData.gps.showSettingsAlert(context));
            } else {
                SharedStructureData.gps.getLocation();
                currentLatitude = String.valueOf(GPSTracker.latitude);
                currentLongitude = String.valueOf(GPSTracker.longitude);
                SharedStructureData.relatedPropertyHashTable.put("currentLatitude", currentLatitude);
                SharedStructureData.relatedPropertyHashTable.put("currentLongitude", currentLongitude);

                if (!PointInPolygon.coordinateInsidePolygon()) {
                    UtilBean.showAlertAndExit(GlobalTypes.MSG_GEO_FENCING_VIOLATION, this);
                }
            }
            // Then check for Photo capture
        } else if (requestCode == GlobalTypes.PHOTO_CAPTURE_ACTIVITY) {
            try {
                if (resultCode == RESULT_OK) {
                    Bundle extras = data.getExtras();
                    if (extras != null) {
                        Bitmap photo = (Bitmap) extras.get("data");
                        QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
                        if (queFormBean != null) {

                            LinearLayout parentLayout = (LinearLayout) queFormBean.getQuestionTypeView();
                            ImageView takenImage = parentLayout.findViewById(GlobalTypes.PHOTO_CAPTURE_ACTIVITY);
                            takenImage.setVisibility(View.VISIBLE);
                            takenImage.setImageBitmap(photo);
                            String photoName = SewaTransformer.loginBean.getUsername() + "_" + SharedStructureData.currentQuestion + "_" + new Date().getTime() + GlobalTypes.IMAGE_CAPTURE_FORMAT;
                            queFormBean.setAnswer(photoName);
                            SewaUtil.generateToast(this, LabelConstants.PHOTO_CAPTURED);
                        }
                    }
                } else {
                    QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
                    if (queFormBean != null) {
                        LinearLayout parentLayout = (LinearLayout) queFormBean.getQuestionTypeView();
                        ImageView takenImage = parentLayout.findViewById(GlobalTypes.PHOTO_CAPTURE_ACTIVITY);
                        takenImage.setVisibility(View.GONE);
                        queFormBean.setAnswer(null);
                    }
                    SewaUtil.generateToast(this, LabelConstants.FAILED_TO_TAKE_PHOTO);
                }
            } catch (Exception e) {
                Log.e(TAG, null, e);
            }
            // Then Check for QR scanner
        } else if (resultForQRScanner != null) {
            if (resultForQRScanner.getContents() == null) {
                SewaUtil.generateToast(this, LabelConstants.FAILED_TO_SCAN_QR);
            } else {
                //show dialogue with resultForQRScanner
                String scanningData = resultForQRScanner.getContents();
                QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
                if (queFormBean != null) {
                    LinearLayout parentLayout = (LinearLayout) queFormBean.getQuestionTypeView();
                    Log.i(TAG, "QR Scanner Data : " + scanningData);

                    if (parentLayout.findViewById(GlobalTypes.QR_SCAN_ACTIVITY) != null) {
                        TextInputLayout answerView = parentLayout.findViewById(GlobalTypes.QR_SCAN_ACTIVITY);
                        try {
                            if (queFormBean.getDatamap().equalsIgnoreCase("NSSF")) {
                                answerView.getEditText().setText(scanningData);
                                queFormBean.setAnswer(scanningData);
                                Objects.requireNonNull(answerView.getEditText()).setText(scanningData);
                                queFormBean.setAnswer(scanningData);

                            } else {
                                Map<String, String> aadharDetailsMap = AadharScanUtil.getAadharScanDataMap(scanningData);
                                answerView.getEditText().setText(AadharScanUtil.getAadharTextToBeDisplayedAfterScan(aadharDetailsMap));
                                queFormBean.setAnswer(new Gson().toJson(aadharDetailsMap));
                            }
                            answerView.setVisibility(View.VISIBLE);
                        } catch (DataException e) {
                            Log.e(TAG, null, e);
                            answerView.setVisibility(View.GONE);
                            queFormBean.setAnswer(null);
                            // If Scanned data are not in xml format
                            SewaUtil.generateToast(this, LabelConstants.PLEASE_SCAN_AADHAAR);
                        }
                    } else if (parentLayout.findViewById(GlobalTypes.BARCODE_SCAN_ACTIVITY) != null) {
                        TextInputLayout answerView = parentLayout.findViewById(GlobalTypes.BARCODE_SCAN_ACTIVITY);
                        Objects.requireNonNull(answerView.getEditText()).setText(scanningData);
                        queFormBean.setAnswer(scanningData);
                        answerView.setVisibility(View.VISIBLE);
                    }
                } else {
                    Log.e(TAG, "No Question found from structure having id " + SharedStructureData.currentQuestion);
                }
            }
        } else if (requestCode == ActivityConstants.HEALTH_ID_MANAGEMENT_REQUEST_CODE) {
            QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
            if (queFormBean != null) {
                if (data != null && data.getStringExtra(RelatedPropertyNameConstants.HEALTH_ID_NUMBER) != null) {
                    queFormBean.setAnswer(data.getStringExtra(RelatedPropertyNameConstants.HEALTH_ID_NUMBER));
                }
            }
        } else if (requestCode == ActivityConstants.PPG_CAPTURE_ACTIVITY_REQUEST_CODE) {
            QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
            if (queFormBean != null) {
                if (resultCode == RESULT_OK) {
                    queFormBean.setAnswer(true);
                    LinearLayout parentLayout = (LinearLayout) queFormBean.getQuestionTypeView();
                    Button takePhotoButton = parentLayout.findViewById(ActivityConstants.PPG_CAPTURE_ACTIVITY_REQUEST_CODE);
                    if (takePhotoButton != null) {
                        takePhotoButton.setText(LabelConstants.DATA_CAPTURED_SUCCESS);
                        takePhotoButton.setBackgroundColor(ContextCompat.getColor(context, R.color.colorAccent));
                        takePhotoButton.setTextColor(ContextCompat.getColor(context, R.color.white));
                    }
                }else{
                    queFormBean.setAnswer(null);
                }
            }
        }
        // This is important, otherwise the resultForQRScanner will not be passed to the fragment
        super.onActivityResult(requestCode, resultCode, data);
    }

    @Override
    protected void onSaveInstanceState(@NonNull Bundle outState) {
        super.onSaveInstanceState(outState);
        // for reset the content view
        setContentView(new TextView(this));
    }

    @Background
    public void storeOpdLabTestForm(String answerStr) {
        runOnUiThread(() -> {
            processDialog = new MyProcessDialog(DynamicFormActivity.this, LabelConstants.SAVING_DATA);
            processDialog.show();
        });

        answerString = answerStr +
                "-1" +
                GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR +
                currentLongitude +
                GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR +
                "-2" +
                GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR +
                currentLatitude +
                GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR +
                "-8" +
                GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR +
                sharedPref.getString(RelatedPropertyNameConstants.FORM_START_DATE, null) +
                GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR +
                "-9" + GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR +
                new Date().getTime() +
                GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR;

        try {
            final String result = serviceRestClient.storeOpdLabFormDetails(answerString, labTestFormDetId, labTestVersion);
            if (result != null) {
                runOnUiThread(() -> SewaUtil.generateToast(DynamicFormActivity.this, LabelConstants.FORM_HAS_BEEN_SAVED_SUCCESSFULLY));
            }
            finishOpdLabTestForm(true);
        } catch (RestHttpException e) {
            hideProcessDialog();
            Log.e(TAG, null, e);

            runOnUiThread(() -> {
                View.OnClickListener listener = v -> {
                    if (v.getId() == BUTTON_POSITIVE) {
                        storeOpdLabTestForm(answerString);
                    } else {
                        finishOpdLabTestForm(false);
                    }
                };

                alertDialog = new MyAlertDialog(DynamicFormActivity.this, false,
                        LabelConstants.ERROR_OCCURRED_DURING_FORM_SUBMISSION,
                        listener,
                        DynamicUtils.BUTTON_RETRY_CANCEL);
                alertDialog.show();
            });
        }
    }

    private void finishOpdLabTestForm(boolean formSubmitted) {
        try {
            formEngine = null;
            PageFormBean.context = null;
            SharedStructureData.resetSharedStructureData();

            techoService.deleteQuestionAndAnswersByFormCode(formType);

            if (formSubmitted) {
                setResult(RESULT_OK);
            } else {
                setResult(RESULT_CANCELED);
            }
        } finally {
            super.finish();
        }
    }

    @UiThread
    public void onFormFillFinish(String answerString1, boolean isNavigate) {
        this.answerString = answerString1;
        this.isProperFinish = isNavigate;
        processDialog = new MyProcessDialog(this, LabelConstants.MSG_SAVING_DATA);
        processDialog.show();
        new Thread() {
            @Override
            public void run() {
                Calendar cal = Calendar.getInstance();
                Date endDate = new Date();
                Calendar durationInCal = Calendar.getInstance();
                durationInCal.setTimeInMillis(cal.getTimeInMillis() - SharedStructureData.formFillUpTime);
                SharedStructureData.formFillUpTime = endDate.getTime() - SharedStructureData.formFillUpTime;

                if (!FormConstants.NEW_DATA_BEAN_APPROACH_FORMS.contains(formType)) {
                    answerString = answerString
                            + "-8"
                            + GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR
                            + sharedPref.getString(RelatedPropertyNameConstants.FORM_START_DATE, null)
                            + GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR
                            + "-9"
                            + GlobalTypes.ANSWER_STRING_FIRST_SEPARATOR
                            + new Date().getTime()
                            + GlobalTypes.MULTI_VALUE_BEAN_SEPARATOR;
                }
                DynamicUtils.storeForm(formType, answerString);

                try {
                    if (SharedStructureData.fhwSheets.contains(formType)) {
                        changeActivity();
                    } else {
                        onFinishing();
                    }
                } catch (Exception e) {
                    Log.e(TAG, null, e);
                } finally {
                    hideProcessDialog();
                }
            }
        }.start();
    }

    public void onFinishing() {
        if (isGenerateQr && !isBackFromBetween) {
            runOnUiThread(() -> {
                MyQRcodeDialog myQRcodeDialog = new MyQRcodeDialog(this, "Family QR Code") {
                    @Override
                    public void onButtonClick() {
                        dismiss();
                        finish();
                    }
                };
                myQRcodeDialog.show();
            });
        } else {
            finish();
        }
    }

    @Override
    public void finish() {
        formEngine = null;
        PageFormBean.context = null;
        SharedStructureData.resetSharedStructureData();
        try {
            if (isProperFinish) {
                navigationFlowForActivity();
            }

            if (answerString != null) {
                setResult(RESULT_OK);
            } else {
                setResult(RESULT_CANCELED);
            }

            hideProcessDialog();
        } finally {
            super.finish();
        }
    }

    private void navigationFlowForActivity() {
        try {
            if (formType != null) {
                showMorbidity(formType);
            }
        } catch (Exception e) {
            SharedStructureData.sewaService.storeException(e, GlobalTypes.EXCEPTION_TYPE_DYNAMIC_FORM);
            Log.e(TAG, null, e);
        }
    }

    private void showMorbidity(String entity) {
        MorbiditiesConstant.morbidities = null;
        MorbiditiesConstant.nextEntity = null;

        String isPresent = SharedStructureData.relatedPropertyHashTable.get("isPresent");
        String status = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);

//        if (isPresent != null && isPresent.equalsIgnoreCase(GlobalTypes.TRUE)
//                && status != null && !status.equals(RchConstants.MEMBER_STATUS_DEATH)) {
//
//        }
    }

    private void changeActivity() {
        String nextEntity = SharedStructureData.relatedPropertyHashTable.get("nextEntity");
        if (formType != null
                && (formType.equals(NotificationConstants.FHW_NOTIFICATION_LMP_FOLLOW_UP)
                || formType.equals(FormConstants.FHW_PREGNANCY_CONFIRMATION))
                && nextEntity != null && !nextEntity.equals("NO") && isProperFinish) {

            SharedStructureData.relatedPropertyHashTable.clear();
            sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
            try {
                formMetaDataUtil.setMetaDataForRchFormByFormType(nextEntity, SharedStructureData.currentRchMemberBean.getActualId(),
                        SharedStructureData.currentRchMemberBean.getFamilyId(), null, sharedPref, SharedStructureData.currentRchMemberBean.getMemberUuid());
                if (nextEntity.equalsIgnoreCase(FormConstants.TECHO_FHW_ANC) || nextEntity.equalsIgnoreCase(FormConstants.CAM_ANC)) {
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.MEMBER_STATUS, RchConstants.MEMBER_STATUS_AVAILABLE);
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
            Intent myIntent = new Intent(this, DynamicFormActivity_.class);
            myIntent.putExtra(SewaConstants.ENTITY, nextEntity);
            myIntent.putExtra(SewaConstants.ALLOW_SECOND_FORM_SAME_MEMBER_OFFLINE, true);
            startActivity(myIntent);
            finish();
        } else if (formType != null && SharedStructureData.fhwSheets.contains(formType)) {
            if (formType.equalsIgnoreCase(FormConstants.LMP_FOLLOW_UP)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_ANC)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_PNC)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_WPD)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_RIM)
                    || formType.equalsIgnoreCase(FormConstants.CAM_ANC)
                    || formType.equalsIgnoreCase(FormConstants.CAM_WPD)
                    || formType.equalsIgnoreCase(FormConstants.CAM_RIM)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_FP_FOLLOW_UP)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_CI)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_CS)
                    || formType.equalsIgnoreCase(FormConstants.TECHO_FHW_VAE)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_ACTIVE_MALARIA)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_ACTIVE_MALARIA_FOLLOW_UP)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_PASSIVE_MALARIA)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_TB)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_TB_FOLLOW_UP)
                    || formType.equalsIgnoreCase(FormConstants.HIV_SCREENING)
                    || formType.equalsIgnoreCase(FormConstants.HIV_POSITIVE)
                    || formType.equalsIgnoreCase(FormConstants.HIV_SCREENING_FU)
                    || formType.equalsIgnoreCase(FormConstants.MALARIA_INDEX)
                    || formType.equalsIgnoreCase(FormConstants.CHIP_INDEX_INVESTIGATION)
                    || formType.equalsIgnoreCase(FormConstants.MALARIA_NON_INDEX)
                    || formType.equalsIgnoreCase(FormConstants.NCD_FHW_WEEKLY_CLINIC)
                    || formType.equalsIgnoreCase(FormConstants.NCD_FHW_WEEKLY_HOME)
                    || formType.equalsIgnoreCase(FormConstants.NCD_CVC_CLINIC)
                    || formType.equalsIgnoreCase(FormConstants.EMTCT)
                    || formType.equalsIgnoreCase(FormConstants.NCD_CVC_HOME)) {
                String memberStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                if (isProperFinish && memberStatus != null && memberStatus.equals("MIGRATED")) {
                    sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
                    SharedPreferences.Editor edit = sharedPref.edit();
                    Gson gson = new Gson();
                    String json = gson.toJson(SharedStructureData.currentRchMemberBean);
                    edit.putString("memberBean", json);
                    json = gson.toJson(SharedStructureData.currentRchFamilyDataBean);
                    edit.putString("familyDataBean", json);
                    edit.apply();
                    Intent myIntent = new Intent(this, MigrateOutActivity_.class);
                    startActivity(myIntent);
                }
            } else if (formType.equalsIgnoreCase(FormConstants.FHS_MEMBER_UPDATE) || formType.equalsIgnoreCase(FormConstants.FHS_MEMBER_UPDATE_NEW)) {
                String memberStatus = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                if (isProperFinish && memberStatus != null && memberStatus.equals("MIGRATED")) {
                    sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
                    SharedPreferences.Editor edit = sharedPref.edit();
                    Gson gson = new Gson();
                    String json = gson.toJson(new MemberBean(SharedStructureData.currentMemberDataBean));
                    edit.putString("memberBean", json);
                    json = gson.toJson(SharedStructureData.currentFamilyDataBean);
                    edit.putString("familyDataBean", json);
                    edit.apply();
                    Intent myIntent = new Intent(this, MigrateOutActivity_.class);
                    startActivity(myIntent);
                }
            }
            onFinishing();
        }
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            if (formEngine != null) {
                formEngine.backButtonClicked();
            }
        } else if (item.getItemId() == R.id.menu_home) {
            View.OnClickListener myListener = v -> {
                if (v.getId() == BUTTON_POSITIVE) {
                    alertDialog.dismiss();
                    isProperFinish = false;
                    navigateToHomeScreen(false);
                    finish();
                } else {
                    alertDialog.dismiss();
                }
            };

            alertDialog = new MyAlertDialog(this,
                    LabelConstants.WANT_TO_GO_BACK_TO_HOME_SCREEN,
                    myListener, DynamicUtils.BUTTON_YES_NO);
            alertDialog.show();
        } else {
            return super.onOptionsItemSelected(item);
        }
        return true;
    }

    public FormEngine getFormEngine() {
        return formEngine;
    }

    @UiThread
    public void showToaster(String msg) {
        SewaUtil.generateToast(context, msg);
    }
}
