package com.argusoft.sewa.android.app.OCR;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;
import static com.argusoft.sewa.android.app.constants.IdConstants.RADIO_BUTTON_ID_NO;
import static com.argusoft.sewa.android.app.constants.IdConstants.RADIO_BUTTON_ID_YES;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.text.InputType;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import androidx.activity.result.ActivityResult;
import androidx.activity.result.ActivityResultLauncher;
import androidx.activity.result.IntentSenderRequest;
import androidx.activity.result.contract.ActivityResultContracts;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.activity.LoginActivity_;
import com.argusoft.sewa.android.app.activity.MenuActivity;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.component.listeners.DateChangeListenerStatic;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.databean.ValidationTagBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.FamilyBean;
import com.argusoft.sewa.android.app.model.ListValueBean;
import com.argusoft.sewa.android.app.model.LoggerBean;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.model.StoreAnswerBean;
import com.argusoft.sewa.android.app.service.GPSTracker;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.argusoft.sewa.android.app.util.WSConstants;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.android.gms.tasks.Task;
import com.google.android.material.textfield.TextInputLayout;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions;
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning;
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import com.google.mlkit.vision.text.latin.TextRecognizerOptions;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.io.IOException;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

@EActivity
public class OCRActivity extends MenuActivity implements View.OnClickListener {
    @Bean
    TextRecognitionService textRecognitionService;
    @Bean
    SewaFhsServiceImpl sewaFhsService;
    @Bean
    SewaServiceImpl sewaService;
    @Bean
    OcrServiceImpl ocrService;
    public static final String SCAN_SHEET_SCREEN = "scanSheetScreen";
    public static final String EXTRACTED_DATA_SCREEN = "extractedDataScreen";
    private TextRecognizer textRecognizer;
    private LinearLayout globalPanel;
    private LinearLayout bodyLayoutContainer;
    private LinearLayout footerLayout;
    private Button nextButton;
    private String screen;
    private MemberBean selectedMember;
    private String ocrFormName;
    private final Map<String, Object> fieldNameAndInputType = new HashMap<>();
    private final Map<Integer, LinearLayout> mapOfPageNumberAndLayout = new HashMap<>();
    private final Map<Integer, JsonObject> mapOfPageNumberAndJsonObject = new HashMap<>();
    private ActivityResultLauncher<IntentSenderRequest> scannerLauncher;
    private List<MultipleOcrPage> fieldList = new ArrayList<>();
    private Integer currentPageIndex = 1;
    private LinearLayout displayLayout;
    private String memberUuid;
    private String uniqueHealthId;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

        uniqueHealthId = getIntent().getStringExtra(FieldNameConstants.UNIQUE_HEALTH_ID);
        memberUuid = getIntent().getStringExtra(FieldNameConstants.MEMBER_UUID);

        if (uniqueHealthId != null) {
            selectedMember = sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthId);
        } else {
            selectedMember = sewaFhsService.retrieveMemberBeanByUUID(memberUuid);
        }

        String formType = getIntent().getStringExtra(SewaConstants.ENTITY);
        if (FormConstants.CHIP_ACTIVE_MALARIA.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_ACTIVE_MALARIA;
        } else if (FormConstants.CHIP_PASSIVE_MALARIA.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_PASSIVE_MALARIA;
        } else if (FormConstants.CHIP_COVID_SCREENING.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_COVID_SCREENING;
        } else if (FormConstants.CHIP_TB.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_TB_SCREENING;
        } else if (FormConstants.LMP_FOLLOW_UP.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_LMPFU;
        } else if (FormConstants.TECHO_FHW_RIM.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_FAMILY_PLANNING;
        } else if (FormConstants.HIV_POSITIVE.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_HIV_POSITIVE;
        } else if (FormConstants.EMTCT.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_EMTCT;
        } else if (FormConstants.HIV_SCREENING.equalsIgnoreCase(formType)) {
            if (UtilBean.calculateAge(selectedMember.getDob()) < 15) {
                ocrFormName = FormConstants.OCR_CHILD_HIV_SCREENING;
            } else {
                ocrFormName = FormConstants.OCR_ADULT_HIV_SCREENING;
            }
        } else if (FormConstants.KNOWN_POSITIVE.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_KNOWN_POSITIVE;
        } else if (FormConstants.TECHO_FHW_ANC.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_ANC;
        }
        scannerLauncher = registerForActivityResult(new ActivityResultContracts.StartIntentSenderForResult(), this::handleActivityResult);
        initView();
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
        textRecognizer = TextRecognition.getClient(new TextRecognizerOptions.Builder().build());
        setContentView(globalPanel);
        setBodyDetail(currentPageIndex);
    }

    private void setBodyDetail(Integer pageNumber) {
        bodyLayoutContainer.removeAllViews();
        screen = SCAN_SHEET_SCREEN;
        List<String> options = new ArrayList<>();
        options.add(UtilBean.getMyLabel(LabelConstants.SCAN_SHEET) + " " + pageNumber);

        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            if (position == 0) {
                openCamera();
            }
        };

        ListView buttonList = MyStaticComponents.getButtonList(context, options, onItemClickListener);
        bodyLayoutContainer.addView(buttonList);
        footerLayout.setVisibility(View.GONE);
        nextButton.setVisibility(View.GONE);
        hideProcessDialog();
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
        setTitle(UtilBean.getTitleText(LabelConstants.OCR));
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == android.R.id.home) {
            handleBackNavigation();
        }
        return true;
    }

    private void handleNextButtonVisibility(Integer pageIndex) {
        if (pageIndex == fieldList.size()) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_SUBMIT));
        } else {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
        }
    }


    private void openCamera() {
        GmsDocumentScannerOptions.Builder options =
                new GmsDocumentScannerOptions.Builder()
                        .setResultFormats(
                                GmsDocumentScannerOptions.RESULT_FORMAT_JPEG,
                                GmsDocumentScannerOptions.RESULT_FORMAT_PDF);

        options.setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_BASE_WITH_FILTER);

        GmsDocumentScanning.getClient(options.build())
                .getStartScanIntent(this)
                .addOnSuccessListener(
                        intentSender ->
                                scannerLauncher.launch(new IntentSenderRequest.Builder(intentSender).build()))
                .addOnFailureListener(
                        e -> SewaUtil.generateToast(context, String.format("Error: %s", e.getMessage())));
    }


    private void handleActivityResult(ActivityResult activityResult) {
        int resultCode = activityResult.getResultCode();
        GmsDocumentScanningResult result =
                GmsDocumentScanningResult.fromActivityResultIntent(activityResult.getData());
        if (resultCode == Activity.RESULT_OK && result != null) {
            showProcessDialog();
            Bitmap imageBitmap = null;
            try {
                imageBitmap = BitmapUtils.getBitmapFromContentUri(getContentResolver(), Objects.requireNonNull(result.getPages()).get(0).getImageUri());
            } catch (IOException e) {
                Log.e("IOException", e.getMessage());
            }
            if (imageBitmap == null) {
                return;
            }

            // iterate field datatype and store in dto
            Task<Text> task = textRecognizer.process(InputImage.fromBitmap(imageBitmap, 0));
            task.addOnSuccessListener(new OnSuccessListener<Text>() {
                        @Override
                        public void onSuccess(Text text) {
                            populateFormData(OCRUtils.getTextArrayFromInput(text.getText()));
                            hideProcessDialog();
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            hideProcessDialog();
                        }
                    });
        } else if (resultCode == Activity.RESULT_CANCELED) {
            SewaUtil.generateToast(context, "Scanning was cancelled");
        } else {
            SewaUtil.generateToast(context, "Failed to scan. Please try again");
        }
    }

    private void populateFormData(String[] formData) {
        screen = EXTRACTED_DATA_SCREEN;

        displayLayout = getLinearLayout(context, 1, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        bodyLayoutContainer.removeAllViews();

        displayLayout.addView(MyStaticComponents.getListTitleView(this, "Re verify the data extracted from the OCR form"));
        String formConfiguration = ocrService.getConfigJsonForForm(ocrFormName);
        Type fieldListType = new TypeToken<List<MultipleOcrPage>>() {
        }.getType();
        fieldList = new Gson().fromJson(formConfiguration, fieldListType);


        //Predefined labels and their corresponding constants
        String[] labels = {"AVAILABLE", "MIGRATED", "POSITIVE", "NEGATIVE", "NOTHING", "NONE"};
        String[] constants = {
                LabelConstants.AVAILABLE,
                LabelConstants.MIGRATED,
                LabelConstants.POSITIVE,
                LabelConstants.NEGATIVE,
                LabelConstants.NOTHING,
                LabelConstants.NONE,
        };

        if (selectedMember != null) {
            displayLayout.addView(MyStaticComponents.generateQuestionView(null, null, context, "Member name"));
            displayLayout.addView(MyStaticComponents.generateAnswerView(context, UtilBean.getMemberFullName(selectedMember)));
        }


        try {
            String checkCorrectForm = getValidFormName();

            //FORM NAME[0] : [FORM_NAME][1]
            if (!formData[0].replaceAll("\\s", "").split(":")[1].trim().contains(checkCorrectForm)) {
                throw new IllegalStateException("You are scanning the wrong form");
            }

            if (FormConstants.OCR_COVID_SCREENING.equalsIgnoreCase(ocrFormName) ||
                    FormConstants.OCR_ANC.equalsIgnoreCase(ocrFormName) ||
                    FormConstants.OCR_KNOWN_POSITIVE.equalsIgnoreCase(ocrFormName)) {
                if (!formData[0].replaceAll("\\s", "").split(":")[1].trim().contains(String.valueOf(currentPageIndex))) {
                    throw new IllegalStateException("You are scanning wrong page");
                }
            }

            for (OcrQuestionBeanDto ocrQuestionBeanDto : fieldList.get(currentPageIndex - 1).getQuestionsConfigurations()) {
                String question = ocrQuestionBeanDto.getQuestion();
                String fieldName = ocrQuestionBeanDto.getFieldName();
                String fieldType = ocrQuestionBeanDto.getFieldType();
                int lineNumber = ocrQuestionBeanDto.getLineNumber();
                String splitByForExtractingAnswer = ocrQuestionBeanDto.getSplitByForExtractingAnswer();

                MaterialTextView questionKey = MyStaticComponents.generateQuestionView(null, null, context, question);
                displayLayout.addView(questionKey);

                String mainAnswer = formData[lineNumber].replaceAll("\\s", "").split(splitByForExtractingAnswer)[1].trim();

                switch (fieldType) {
                    case "DB":
                        List<ValidationTagBean> validationsForDob = new LinkedList<>();
                        validationsForDob.add(new ValidationTagBean(FormulaConstants.VALIDATION_IS_FUTURE_DATE,
                                "Date cannot be in future"));
                        DateChangeListenerStatic dateSelectorListener = new DateChangeListenerStatic(context, validationsForDob);
                        LinearLayout datePicker = new LinearLayout(context);
                        datePicker = MyStaticComponents.getCustomDatePickerForStatic(this, dateSelectorListener, 0);
                        Date selectedDate = null;
                        try {
                            selectedDate = OCRUtils.convertStringToDate(mainAnswer);
                            fieldNameAndInputType.put(fieldName, dateSelectorListener);
                            if (selectedDate != null) {
                                MaterialTextView txtDate = datePicker.findViewById(IdConstants.DATE_PICKER_TEXT_DATE_ID);
                                txtDate.setText(new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(selectedDate));
                            }
                            dateSelectorListener.setDateSet(selectedDate);
                        } catch (ParseException e) {
                            Log.e("Date parsing exception", e.getMessage());
                        }
                        displayLayout.addView(datePicker);
                        break;
                    case "TB":
                        TextInputLayout editText = MyStaticComponents.getEditText(context, question, -1, 100, InputType.TYPE_CLASS_TEXT);
                        fieldNameAndInputType.put(fieldName, editText);

                        for (int i = 0; i < labels.length; i++) {
                            String label = labels[i];
                            String constant = constants[i];

                            // Check similarity with the current label
                            if (OCRUtils.calculateSimilarity(mainAnswer, label) > 0.70) {
                                Objects.requireNonNull(editText.getEditText()).setText(constant);
                                // Break out of the loop if a match is found
                                break;
                            }
                        }

                        // If no match is found, set the OCR result as is
                        if (Objects.requireNonNull(editText.getEditText()).getText().toString().isEmpty()) {
                            editText.getEditText().setText(mainAnswer);
                        }

                        displayLayout.addView(editText);
                        break;
                    case "ITB":
                        TextInputLayout editTextNumber = MyStaticComponents.getEditText(context, question, -1, 100, InputType.TYPE_CLASS_NUMBER);
                        fieldNameAndInputType.put(fieldName, editTextNumber);

                        // If no match is found, set the OCR result as is
                        if (Objects.requireNonNull(editTextNumber.getEditText()).getText().toString().isEmpty()) {
                            editTextNumber.getEditText().setText(mainAnswer);
                        }

                        displayLayout.addView(editTextNumber);
                        break;
                    case "RB":
                        HashMap<Integer, String> stringMap = new HashMap<>();
                        stringMap.put(RADIO_BUTTON_ID_YES, LabelConstants.YES);
                        stringMap.put(RADIO_BUTTON_ID_NO, LabelConstants.NO);
                        RadioGroup yesNoRadioGroup = MyStaticComponents.getRadioGroup(this, stringMap, false);
                        fieldNameAndInputType.put(fieldName, yesNoRadioGroup);

                        if (mainAnswer.equalsIgnoreCase("YES")
                                || mainAnswer.equalsIgnoreCase("ES")
                                || mainAnswer.equalsIgnoreCase("Y")) {
                            ((RadioButton) yesNoRadioGroup.getChildAt(0)).setChecked(true);
                        } else if (mainAnswer.equalsIgnoreCase("NO")
                                || mainAnswer.equalsIgnoreCase("N0")
                                || mainAnswer.equalsIgnoreCase("No")
                                || mainAnswer.equalsIgnoreCase("N")) {
                            ((RadioButton) yesNoRadioGroup.getChildAt(1)).setChecked(true);
                        }
                        displayLayout.addView(yesNoRadioGroup);
                        break;
                }
            }
            handleNextButtonVisibility(currentPageIndex);
            bodyLayoutContainer.addView(displayLayout);
        } catch (Exception e) {
            SewaUtil.generateToast(context, e.getMessage());
            Log.e(Activity.class.getName(), e.getMessage());
            setBodyDetail(1);
        }
        footerLayout.setVisibility(View.VISIBLE);
        nextButton.setVisibility(View.VISIBLE);
    }

    @NonNull
    private String getValidFormName() {
        String checkCorrectForm;
        if (FormConstants.OCR_ACTIVE_MALARIA.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "ACT";
        } else if (FormConstants.OCR_PASSIVE_MALARIA.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "PAS";
        } else if (FormConstants.OCR_COVID_SCREENING.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "COV";
        } else if (FormConstants.OCR_TB_SCREENING.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "TUB";
        } else if (FormConstants.OCR_LMPFU.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "LMP";
        } else if (FormConstants.OCR_FAMILY_PLANNING.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "FAM";
        } else if (FormConstants.OCR_HIV_POSITIVE.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "HIVPOS";
        } else if (FormConstants.OCR_EMTCT.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "EMT";
        } else if (FormConstants.OCR_CHILD_HIV_SCREENING.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "CHILD";
        } else if (FormConstants.OCR_ADULT_HIV_SCREENING.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "ADULT";
        } else if (FormConstants.OCR_KNOWN_POSITIVE.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "KNOWN";
        } else if (FormConstants.OCR_ANC.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "ANC";
        } else {
            checkCorrectForm = "";
        }
        return checkCorrectForm;
    }

    @Override
    public void onBackPressed() {
        handleBackNavigation();
    }

    private void handleBackNavigation() {
        if (currentPageIndex > 1) {
            bodyLayoutContainer.removeAllViews();
            bodyLayoutContainer.addView(mapOfPageNumberAndLayout.get(currentPageIndex - 1));
            footerLayout.setVisibility(View.VISIBLE);
            nextButton.setVisibility(View.VISIBLE);
            currentPageIndex--;
            handleNextButtonVisibility(currentPageIndex);
        } else {
            finish();
        }
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            mapOfPageNumberAndLayout.put(currentPageIndex, displayLayout);
            mapOfPageNumberAndJsonObject.put(currentPageIndex, saveDataForFields());
            if (screen.equals(EXTRACTED_DATA_SCREEN) || screen.equalsIgnoreCase(SCAN_SHEET_SCREEN)) {
                if (currentPageIndex == fieldList.size()) {
                    saveData(ocrFormName);
                    finish();
                } else {
                    currentPageIndex++;
                    setBodyDetail(currentPageIndex);
                }
            }
        }
    }

    private void saveData(String formEntity) {
        try {
            ListValueBean listValueBean = null;
            //Merge JSON from multiple pages
            JsonObject jsonObjectForAnswers = mergeJsonObjects(mapOfPageNumberAndJsonObject);
            Log.i(getClass().getSimpleName(), "#### Generated OCR Data In : " + jsonObjectForAnswers);

            //update member for offline data
            MemberBean memberBean;
            String familyID = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
            FamilyBean familyBean = SharedStructureData.sewaFhsService.retrieveFamilyBeanByFamilyId(familyID);
            if (uniqueHealthId != null) {
                memberBean = sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthId);
            } else {
                memberBean = sewaFhsService.retrieveMemberBeanByUUID(memberUuid);
            }
            if (memberBean != null && jsonObjectForAnswers.get("rdtTestStatus") != null
                    && !jsonObjectForAnswers.get("rdtTestStatus").toString().isEmpty()) {
                memberBean.setRdtStatus(jsonObjectForAnswers.get("rdtTestStatus").toString());
            }
            if (memberBean != null && jsonObjectForAnswers.get("indexCase") != null) {
                Boolean indexCase = jsonObjectForAnswers.get("indexCase").getAsBoolean();
                memberBean.setIndexCase(indexCase);
            }
            sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);

            //set extra data in json object so that it can be stored in backend
            if (memberBean != null && memberBean.getActualId() != null) {
                jsonObjectForAnswers.add("memberId", new JsonPrimitive(memberBean.getActualId()));
            }
            if (memberBean != null && memberBean.getMemberUuid() != null) {
                jsonObjectForAnswers.add("memberUUID", new JsonPrimitive(memberBean.getMemberUuid()));
            }
            if (FormConstants.OCR_ACTIVE_MALARIA.equalsIgnoreCase(ocrFormName) ||
                    FormConstants.OCR_PASSIVE_MALARIA.equalsIgnoreCase(ocrFormName)) {
                jsonObjectForAnswers.add("malariaType", new JsonPrimitive(ocrFormName));
            }

            jsonObjectForAnswers.add("formFilledVia", new JsonPrimitive("OCR"));
            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                jsonObjectForAnswers.add("latitude", new JsonPrimitive(String.valueOf(GPSTracker.latitude)));
                jsonObjectForAnswers.add("longitude", new JsonPrimitive(String.valueOf(GPSTracker.longitude)));
            }
            jsonObjectForAnswers.add("familyId", new JsonPrimitive(familyBean.getActualId()));
            String healthInfraId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID);
            if (healthInfraId != null) {
                jsonObjectForAnswers.add("referralPlace", new JsonPrimitive(healthInfraId));
            }

            //Preparing Checksum
            StringBuilder checkSum = new StringBuilder(SewaTransformer.loginBean.getUsername());
            checkSum.append(Calendar.getInstance().getTimeInMillis());

            StoreAnswerBean storeAnswerBean = new StoreAnswerBean();
            storeAnswerBean.setAnswerEntity(formEntity);
            storeAnswerBean.setAnswer(String.valueOf(jsonObjectForAnswers));
            storeAnswerBean.setChecksum(checkSum.toString());
            storeAnswerBean.setDateOfMobile(Calendar.getInstance().getTimeInMillis());
            storeAnswerBean.setFormFilledUpTime(0L);
            storeAnswerBean.setMorbidityAnswer("-1");
            storeAnswerBean.setNotificationId(-1L);
            storeAnswerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO);
            storeAnswerBean.setRelatedInstance("-1");
            if (SewaTransformer.loginBean != null) {
                storeAnswerBean.setToken(SewaTransformer.loginBean.getUserToken());
                storeAnswerBean.setUserId(SewaTransformer.loginBean.getUserID());
            }
            sewaService.createStoreAnswerBean(storeAnswerBean);

            LoggerBean loggerBean = new LoggerBean();
            loggerBean.setBeneficiaryName(UtilBean.getMemberFullName(selectedMember) + " (" + selectedMember.getUniqueHealthId() + ")");
            loggerBean.setCheckSum(checkSum.toString());
            loggerBean.setDate(Calendar.getInstance().getTimeInMillis());
            loggerBean.setFormType(ocrFormName);
            loggerBean.setTaskName(UtilBean.getFullFormOfEntity().get(ocrFormName));
            loggerBean.setStatus(GlobalTypes.STATUS_PENDING);
            loggerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO.trim());
            loggerBean.setNoOfAttempt(0);
            sewaService.createLoggerBean(loggerBean);
        } catch (Exception e) {
            SewaUtil.generateToast(context, "Something went wrong. Please try again.");
            setBodyDetail(1);
        }
    }

    private JsonObject saveDataForFields() {
        String formConfiguration = ocrService.getConfigJsonForForm(ocrFormName);
        Type fieldListType = new TypeToken<List<MultipleOcrPage>>() {
        }.getType();
        List<MultipleOcrPage> fieldList = new Gson().fromJson(formConfiguration, fieldListType);

        JsonObject jsonObject = new JsonObject();
        for (OcrQuestionBeanDto ocrQuestionBeanDto : fieldList.get(currentPageIndex - 1).getQuestionsConfigurations()) {
            String fieldName = ocrQuestionBeanDto.getFieldName();
            String fieldType = ocrQuestionBeanDto.getFieldType();

            switch (fieldType) {
                case "DB":
                    DateChangeListenerStatic dateChangeListenerStatic = (DateChangeListenerStatic) fieldNameAndInputType.get(fieldName);
                    if (dateChangeListenerStatic != null) {
                        jsonObject.add(fieldName, new JsonPrimitive(dateChangeListenerStatic.getDateSet().getTime()));
                    }
                    break;
                case "TB":
                case "ITB":
                    TextInputLayout editText = (TextInputLayout) fieldNameAndInputType.get(fieldName);
                    if (editText != null) {
                        jsonObject.add(fieldName, new JsonPrimitive(Objects.requireNonNull(editText.getEditText()).getText().toString().trim()));
                    }
                    break;
                case "RB":
                    RadioGroup radioGroup = (RadioGroup) fieldNameAndInputType.get(fieldName);
                    if (radioGroup != null) {
                        jsonObject.add(fieldName, new JsonPrimitive(Objects.requireNonNull(getBooleanFromRadioGroup(radioGroup))));
                    }
                    break;
            }
        }
        return jsonObject;
    }

    public static JsonObject mergeJsonObjects(Map<Integer, JsonObject> mapOfPageNumberAndJsonObject) {
        JsonObject mergedJson = new JsonObject();

        for (Map.Entry<Integer, JsonObject> entry : mapOfPageNumberAndJsonObject.entrySet()) {
            JsonObject jsonObject = entry.getValue();
            for (String key : jsonObject.keySet()) {
                mergedJson.add(key, jsonObject.get(key));
            }
        }

        return mergedJson;
    }

    private static Boolean getBooleanFromRadioGroup(RadioGroup radioGroup) {
        if (radioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_YES) {
            return true;
        } else if (radioGroup.getCheckedRadioButtonId() == RADIO_BUTTON_ID_NO) {
            return false;
        }
        return null;
    }
}