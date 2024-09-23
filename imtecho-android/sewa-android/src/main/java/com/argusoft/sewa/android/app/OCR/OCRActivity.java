package com.argusoft.sewa.android.app.OCR;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;
import static com.argusoft.sewa.android.app.constants.FhsConstants.CFHC_FAMILY_STATE_NEW;
import static com.argusoft.sewa.android.app.constants.IdConstants.RADIO_BUTTON_ID_NO;
import static com.argusoft.sewa.android.app.constants.IdConstants.RADIO_BUTTON_ID_YES;
import static com.argusoft.sewa.android.app.mappers.HouseHoldLineListMobileMapper.generateTempUniqueHealthId;

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
import com.argusoft.sewa.android.app.databean.MemberDataBean;
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
import com.argusoft.sewa.android.app.util.CommonUtil;
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
import com.google.gson.JsonArray;
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
import org.androidannotations.annotations.UiThread;
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
import java.util.UUID;

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

    @OrmLiteDao(helper = DBConnection.class)
    Dao<FamilyBean, Integer> familyBeanDao;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<MemberBean, Integer> memberBeanDao;
    public static final String SCAN_SHEET_SCREEN = "scanSheetScreen";
    public static final String EXTRACTED_DATA_SCREEN = "extractedDataScreen";
    public static final String NEW_MEMBERS_SCREEN = "NEW_MEMBERS_SCREEN";
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
    private String familyId;
    private String locationId;
    private Integer memberCount = 0;
    private Boolean isMemberAdded = false;
    private Boolean isFromHousehold = false;
    String formType = null;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);

        uniqueHealthId = getIntent().getStringExtra(FieldNameConstants.UNIQUE_HEALTH_ID);
        memberUuid = getIntent().getStringExtra(FieldNameConstants.MEMBER_UUID);
        familyId = getIntent().getStringExtra(FieldNameConstants.FAMILY_ID);
        locationId = getIntent().getStringExtra(FieldNameConstants.LOCATION_ID);

        if (uniqueHealthId != null) {
            selectedMember = sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthId);
        } else if (memberUuid != null) {
            selectedMember = sewaFhsService.retrieveMemberBeanByUUID(memberUuid);
        }

        formType = getIntent().getStringExtra(SewaConstants.ENTITY);
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
        } else if (FormConstants.FHS_MEMBER_UPDATE_NEW.equalsIgnoreCase(formType)) {
            if (uniqueHealthId == null && memberUuid == null) {
                ocrFormName = FormConstants.OCR_ADD_MEMBER;
            } else {
                ocrFormName = FormConstants.OCR_UPDATE_MEMBER;
            }
        } else if (FormConstants.HOUSE_HOLD_LINE_LIST_NEW.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_HOUSEHOLD_LINE_LIST;
            isFromHousehold = true;
        } else if (FormConstants.TECHO_FHW_WPD.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_WPD;
        } else if (FormConstants.TECHO_FHW_PNC.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_PNC;
        } else if (FormConstants.TECHO_FHW_CS.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_CS;
        } else if (FormConstants.CHIP_GBV_SCREENING.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_GBV;
        } else if (FormConstants.MALARIA_NON_INDEX.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_MALARIA_NON_INDEX;
        } else if (FormConstants.MALARIA_INDEX.equalsIgnoreCase(formType)) {
            ocrFormName = FormConstants.OCR_MALARIA_INDEX;
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
        if (ocrFormName.equalsIgnoreCase(FormConstants.OCR_HOUSEHOLD_LINE_LIST)) {
            options.add(UtilBean.getMyLabel(LabelConstants.SCAN_FAMILY));
        } else {
            options.add(UtilBean.getMyLabel(LabelConstants.SCAN_SHEET) + " " + pageNumber);
        }

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
        setTitle(UtilBean.getTitleText(UtilBean.getFullFormOfEntity().get(formType)));
        displayLayout = getLinearLayout(context, 1, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        bodyLayoutContainer.removeAllViews();

        displayLayout.addView(MyStaticComponents.getListTitleView(this, "Re verify the data extracted from the OCR form"));
        String formConfiguration = ocrService.getConfigJsonForForm(ocrFormName);
        Type fieldListType = new TypeToken<List<MultipleOcrPage>>() {
        }.getType();
        fieldList = new Gson().fromJson(formConfiguration, fieldListType);


        //Predefined labels and their corresponding constants
        String[] labels = {"AVAILABLE", "MIGRATED", "POSITIVE", "NEGATIVE", "NOTHING", "NONE", "HINDU", "MUSLIM", "CHRISTIAN", "BUDDHIST"};
        String[] constants = {
                LabelConstants.AVAILABLE,
                LabelConstants.MIGRATED,
                LabelConstants.POSITIVE,
                LabelConstants.NEGATIVE,
                LabelConstants.NOTHING,
                LabelConstants.NONE,
                LabelConstants.HINDU,
                LabelConstants.MUSLIM,
                LabelConstants.CHRISTIAN,
                LabelConstants.BUDDHIST,
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
                String mainAnswer = null;
                if (formData[lineNumber].replace("\\s", "").split(splitByForExtractingAnswer).length > 1) {
                    mainAnswer = formData[lineNumber].replaceAll("\\s", "").split(splitByForExtractingAnswer)[1].trim();
                }

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
                            if (mainAnswer != null) {
                                selectedDate = OCRUtils.convertStringToDate(mainAnswer);
                                fieldNameAndInputType.put(fieldName, dateSelectorListener);
                                if (selectedDate != null) {
                                    MaterialTextView txtDate = datePicker.findViewById(IdConstants.DATE_PICKER_TEXT_DATE_ID);
                                    txtDate.setText(new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault()).format(selectedDate));
                                }
                                dateSelectorListener.setDateSet(selectedDate);
                            } else {
                                dateSelectorListener.setDateSet(null);
                            }
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
                            if (mainAnswer != null && OCRUtils.calculateSimilarity(mainAnswer, label) > 0.70) {
                                Objects.requireNonNull(editText.getEditText()).setText(constant);
                                // Break out of the loop if a match is found
                                break;
                            }
                        }

                        // If no match is found, set the OCR result as is
                        if (Objects.requireNonNull(editText.getEditText()).getText().toString().isEmpty() && mainAnswer != null) {
                            editText.getEditText().setText(mainAnswer);
                        }

                        displayLayout.addView(editText);
                        break;
                    case "ITB":
                        TextInputLayout editTextNumber = MyStaticComponents.getEditText(context, question, -1, 100, InputType.TYPE_CLASS_NUMBER);
                        fieldNameAndInputType.put(fieldName, editTextNumber);

                        // If no match is found, set the OCR result as is
                        if (Objects.requireNonNull(editTextNumber.getEditText()).getText().toString().isEmpty() && mainAnswer != null) {
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

                        if (mainAnswer != null && (mainAnswer.equalsIgnoreCase("YES")
                                || mainAnswer.equalsIgnoreCase("ES")
                                || mainAnswer.equalsIgnoreCase("Y"))) {
                            ((RadioButton) yesNoRadioGroup.getChildAt(0)).setChecked(true);
                        } else if (mainAnswer != null && (mainAnswer.equalsIgnoreCase("NO")
                                || mainAnswer.equalsIgnoreCase("N0")
                                || mainAnswer.equalsIgnoreCase("No")
                                || mainAnswer.equalsIgnoreCase("N"))) {
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
        if (ocrFormName.equalsIgnoreCase(FormConstants.OCR_HOUSEHOLD_LINE_LIST)) {
            nextButton.setText(UtilBean.getMyLabel(GlobalTypes.EVENT_NEXT));
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
        } else if (FormConstants.OCR_ADD_MEMBER.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "ADD";
        } else if (FormConstants.OCR_UPDATE_MEMBER.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "UPDATE";
        } else if (FormConstants.OCR_WPD.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "POV";
        } else if (FormConstants.OCR_HOUSEHOLD_LINE_LIST.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "FAMILY";
        } else if (FormConstants.OCR_PNC.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "PNC";
        } else if (FormConstants.OCR_CS.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "CHILD";
        } else if (FormConstants.OCR_GBV.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "GBV";
        } else if (FormConstants.OCR_MALARIA_NON_INDEX.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "NON";
        } else if (FormConstants.OCR_MALARIA_INDEX.equalsIgnoreCase(ocrFormName)) {
            checkCorrectForm = "IND";
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

    @UiThread
    public void setPageForNewMember() {
        screen = NEW_MEMBERS_SCREEN;
        bodyLayoutContainer.removeAllViews();
        MaterialTextView questionKey = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.NEW_MEMBERS);
        bodyLayoutContainer.addView(questionKey);
        HashMap<Integer, String> stringMap = new HashMap<>();
        stringMap.put(RADIO_BUTTON_ID_YES, LabelConstants.YES);
        stringMap.put(RADIO_BUTTON_ID_NO, LabelConstants.NO);
        RadioGroup yesNoRadioGroup = MyStaticComponents.getRadioGroup(this, stringMap, false);
        bodyLayoutContainer.addView(yesNoRadioGroup);
        yesNoRadioGroup.setOnCheckedChangeListener((group, checkedId) -> {
            if (checkedId == RADIO_BUTTON_ID_YES) {
                isMemberAdded = true;
            } else if (checkedId == RADIO_BUTTON_ID_NO) {
                isMemberAdded = false;
            }
        });
        footerLayout.setVisibility(View.VISIBLE);
        nextButton.setVisibility(View.VISIBLE);
    }

    @Override
    public void onClick(View view) {
        if (view.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            if (isFromHousehold) {
                mapOfPageNumberAndLayout.put(memberCount, displayLayout);
                mapOfPageNumberAndJsonObject.put(memberCount, saveDataForFields());
            } else {
                mapOfPageNumberAndLayout.put(currentPageIndex, displayLayout);
                mapOfPageNumberAndJsonObject.put(currentPageIndex, saveDataForFields());
            }
            if (screen.equals(EXTRACTED_DATA_SCREEN) || screen.equalsIgnoreCase(SCAN_SHEET_SCREEN)) {
                if (memberCount > 0) {
                    setPageForNewMember();
                } else if (currentPageIndex == fieldList.size() && (!ocrFormName.equalsIgnoreCase(FormConstants.OCR_HOUSEHOLD_LINE_LIST))) {
                    saveData(ocrFormName);
                    finish();
                } else if (ocrFormName.equalsIgnoreCase(FormConstants.OCR_HOUSEHOLD_LINE_LIST)) {
                    if (memberCount == 0) {
                        memberCount++;
                        ocrFormName = FormConstants.OCR_ADD_MEMBER;
                        setBodyDetail(memberCount);
                    } else {
                        setPageForNewMember();
                    }
                } else {
                    currentPageIndex++;
                    setBodyDetail(currentPageIndex);
                }
            }
            if (screen.equalsIgnoreCase(NEW_MEMBERS_SCREEN)) {
                if (isMemberAdded) {
                    memberCount++;
                    setBodyDetail(memberCount);
                } else {
                    saveData(ocrFormName);
                    finish();
                }
            }
        }
    }

    private void saveData(String formEntity) {

        ListValueBean listValueBean = null;
        try {
            //Merge JSON from multiple pages
            JsonObject jsonObjectForAnswers = mergeJsonObjects(mapOfPageNumberAndJsonObject);

            if (isFromHousehold) {
                saveDataForHouseHoldLineListForm(mapOfPageNumberAndJsonObject, jsonObjectForAnswers);
                return;
            }

            Log.i(getClass().getSimpleName(), "#### Generated OCR Data In : " + jsonObjectForAnswers);

            //update member for offline data
            MemberBean memberBean = null;
            String familyID = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_ID);
            FamilyBean familyBean;
            if (familyID != null) {
                familyBean = SharedStructureData.sewaFhsService.retrieveFamilyBeanByFamilyId(familyID);
            } else {
                familyBean = SharedStructureData.sewaFhsService.retrieveFamilyBeanByFamilyId(familyId);
            }
            if (uniqueHealthId != null) {
                memberBean = sewaFhsService.retrieveMemberBeanByHealthId(uniqueHealthId);
            } else if (memberUuid != null) {
                memberBean = sewaFhsService.retrieveMemberBeanByUUID(memberUuid);
            }
            if (ocrFormName.equalsIgnoreCase(FormConstants.OCR_ADD_MEMBER) || ocrFormName.equalsIgnoreCase(FormConstants.OCR_UPDATE_MEMBER)) {
                if (memberBean == null) {
                    memberBean = new MemberBean();
                    memberBean.setMemberUuid(UUID.randomUUID().toString());
                }
                memberBean.setFirstName(jsonObjectForAnswers.has("firstName") ? jsonObjectForAnswers.get("firstName").getAsString() : memberBean.getFirstName());
                memberBean.setLastName(jsonObjectForAnswers.has("lastName") ? jsonObjectForAnswers.get("lastName").getAsString() : memberBean.getLastName());
                memberBean.setMiddleName(jsonObjectForAnswers.has("middleName") ? jsonObjectForAnswers.get("middleName").getAsString() : memberBean.getMiddleName());
                memberBean.setDob(jsonObjectForAnswers.has("dob") ? new Date(jsonObjectForAnswers.get("dob").getAsLong()) : memberBean.getDob());
                String relationWithHof = jsonObjectForAnswers.has("relationWithHof") ? jsonObjectForAnswers.get("relationWithHof").getAsString() : null;
                if (relationWithHof != null) {
                    if (OCRUtils.calculateSimilarity(relationWithHof, "self") > 0.70) {
                        memberBean.setFamilyHeadFlag(true);
                    } else {
                        memberBean.setRelationWithHof(relationWithHof);
                    }
                }
                String gender = jsonObjectForAnswers.get("gender").getAsString().toLowerCase();
                if (gender != null) {

                    switch (gender) {
                        case "f":
                        case "female":
                            memberBean.setGender(GlobalTypes.FEMALE);
                            break;
                        case "m":
                        case "male":
                            memberBean.setGender(GlobalTypes.MALE);
                    }
                }
                memberBean.setMobileNumber(jsonObjectForAnswers.has("mobileNumber") ? jsonObjectForAnswers.get("mobileNumber").getAsString() : memberBean.getMobileNumber());
                if (memberBean.getGender().equalsIgnoreCase("F")) {
                    memberBean.setIsPregnantFlag(jsonObjectForAnswers.has("isPregnant") ? CommonUtil.returnTrueFalseFromInitials(jsonObjectForAnswers.get("isPregnant").getAsString()) : memberBean.getPregnantFlag());
                }
                String maritalStatus = jsonObjectForAnswers.has("maritalStatus") ? jsonObjectForAnswers.get("maritalStatus").getAsString() : null;
                if (maritalStatus != null) {
                    maritalStatus.toLowerCase();
                    switch (maritalStatus) {
                        case "married":
                            memberBean.setMaritalStatus("629");
                            break;
                        case "unmarried":
                            memberBean.setMaritalStatus("630");
                            break;
                        case "widow":
                            memberBean.setMaritalStatus("641");
                            break;
                        case "widower":
                            memberBean.setMaritalStatus("643");
                            break;
                        case "abandoned":
                            memberBean.setMaritalStatus("642");
                            break;
                    }
                }
                memberBean.setUpdatedBy(String.valueOf(SewaTransformer.loginBean.getUserID()));
                memberBean.setUpdatedOn(new Date());
                memberBean.setCreatedOn(new Date());
                memberBean.setCreatedBy(String.valueOf(SewaTransformer.loginBean.getUserID()));
                sewaService.createMemberBean(null, memberBean, familyBean);
            } else if (ocrFormName.equalsIgnoreCase(FormConstants.OCR_WPD)) {
                memberBean.setIsPregnantFlag(false);
                memberBean.setLastDeliveryDate(new Date(Long.parseLong(jsonObjectForAnswers.get("serviceDate").getAsString())));
                String pregnancyOutcome = jsonObjectForAnswers.get("pregnancyOutcome").getAsString();
                memberBean.setLastDeliveryOutcome(getLastDeliveryOutcome(pregnancyOutcome));
                jsonObjectForAnswers.add("pregnancyOutcome", new JsonPrimitive(pregnancyOutcome));
                if (memberBean.getLastDeliveryOutcome().equalsIgnoreCase("LBIRTH") || memberBean.getLastDeliveryOutcome().equalsIgnoreCase("SBIRTH")) {
                    if (memberBean.getCurrentPara() != null) {
                        memberBean.setCurrentPara((short) (memberBean.getCurrentPara() + 1));
                    } else {
                        memberBean.setCurrentPara((short) 1);
                    }
                    MemberBean childBean = new MemberBean();
                    childBean.setMemberUuid(UUID.randomUUID().toString());
                    childBean.setFirstName("B/O of " + memberBean.getFirstName());
                    childBean.setLastName(memberBean.getLastName());
                    childBean.setMiddleName(memberBean.getMiddleName());
                    childBean.setDob(memberBean.getLastDeliveryDate());
                    childBean.setGender(jsonObjectForAnswers.get("gender").getAsString());
                    childBean.setWeight(Float.parseFloat(jsonObjectForAnswers.get("babyWeight").getAsString()));
                    jsonObjectForAnswers.add("childUUID", new JsonPrimitive(childBean.getMemberUuid()));
                    sewaService.createMemberBean(null, childBean, familyBean);
                }
            } else if (FormConstants.OCR_GBV.equalsIgnoreCase(ocrFormName)) {
                if (jsonObjectForAnswers.has("areYouPregnant")) {
                    if (memberBean.getGender().equalsIgnoreCase("F") && CommonUtil.returnTrueFalseFromInitials(jsonObjectForAnswers.get("areYouPregnant").getAsString())) {
                        memberBean.setIsPregnantFlag(CommonUtil.returnTrueFalseFromInitials(jsonObjectForAnswers.get("areYouPregnant").getAsString()));
                    } else {
                        SewaUtil.generateToast(context, "Male patient can't be marked");
                        setBodyDetail(1);
                    }

                }
            }
            if (memberBean.getMemberUuid() == null) {
                memberBean.setMemberUuid(UUID.randomUUID().toString());
            }
            if (memberBean != null && jsonObjectForAnswers.get("rdtTestStatus") != null
                    && !jsonObjectForAnswers.get("rdtTestStatus").toString().isEmpty()) {
                memberBean.setRdtStatus(jsonObjectForAnswers.get("rdtTestStatus").toString());
            }
            if (memberBean != null && jsonObjectForAnswers.get("indexCase") != null) {
                Boolean indexCase = jsonObjectForAnswers.get("indexCase").getAsBoolean();
                memberBean.setIndexCase(indexCase);
            }

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
            if (familyBean.getActualId() != null) {
                jsonObjectForAnswers.add("familyId", new JsonPrimitive(familyBean.getActualId()));
            }
            jsonObjectForAnswers.add("locationId", familyBean.getAreaId() != null ? new JsonPrimitive(familyBean.getAreaId()) : new JsonPrimitive(familyBean.getLocationId()));
            String healthInfraId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID);
            if (healthInfraId != null) {
                jsonObjectForAnswers.add("referralPlace", new JsonPrimitive(healthInfraId));
            }
            if (memberBean != null && (memberBean.getUniqueHealthId() != null || memberBean.getMemberUuid() != null)) {
                sewaService.updateMemberByUniqueHealthId(null, memberBean, familyBean);
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
            if (selectedMember == null && ocrFormName.equalsIgnoreCase(FormConstants.OCR_ADD_MEMBER)) {
                loggerBean.setBeneficiaryName(UtilBean.getMyLabel("New member added"));
            } else {
                loggerBean.setBeneficiaryName(UtilBean.getMemberFullName(selectedMember) + " (" + selectedMember.getUniqueHealthId() + ")");
            }
            loggerBean.setCheckSum(checkSum.toString());
            loggerBean.setDate(Calendar.getInstance().getTimeInMillis());
            loggerBean.setFormType(ocrFormName);
            loggerBean.setTaskName(UtilBean.getFullFormOfEntity().get(ocrFormName));
            loggerBean.setStatus(GlobalTypes.STATUS_PENDING);
            loggerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO.trim());
            loggerBean.setNoOfAttempt(0);
            sewaService.createLoggerBean(loggerBean);
        } catch (NumberFormatException e) {
            SewaUtil.generateToast(context, e.getMessage());
            Log.e(Activity.class.getName(), e.getMessage());
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
                    if (dateChangeListenerStatic != null && dateChangeListenerStatic.getDateSet() != null) {
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
                        if (getBooleanFromRadioGroup(radioGroup) != null) {
                            jsonObject.add(fieldName, new JsonPrimitive(Objects.requireNonNull(getBooleanFromRadioGroup(radioGroup))));
                        }
                    }
                    break;
            }
        }
        return jsonObject;
    }

    public String getLastDeliveryOutcome(String pregnancyOutcome) {
        pregnancyOutcome = pregnancyOutcome.toLowerCase();
        switch (pregnancyOutcome) {
            case "live":
            case "live birth":
            case "lbirth":
            case "lb":
            case "livebirth":
                return "LBIRTH";
            case "still":
            case "sbirth":
            case "still birth":
            case "sb":
            case "stillbirth":
                return "SBIRTH";
            case "mtp":
            case "medical termination":
            case "m t p":
                return "MTP";
            case "abortion":
            case "aborted":
                return "ABORTION";
            case "spontaneous":
            case "spontaneous abortion":
            case "spontaneous aborted":
                return "SPONT_ABORTION";
            default:
                return "";
        }
    }

    public void saveDataForHouseHoldLineListForm
            (Map<Integer, JsonObject> mapOfPageNumberAndJsonObject, JsonObject jsonObject) {
        FamilyBean familyBean = new FamilyBean();
        familyBean.setHouseNumber(jsonObject.get("houseNumber").getAsString());
        familyBean.setAddress1(jsonObject.get("address").getAsString());
        familyBean.setTypeOfToilet(jsonObject.get("typeOfToilet").getAsString());
        familyBean.setDrinkingWaterSource(jsonObject.get("drinkingWaterSource").getAsString());
        familyBean.setUuid(UUID.randomUUID().toString());
        familyBean.setCreatedBy(String.valueOf(-1));
        familyBean.setCreatedOn(new Date());
        familyBean.setUpdatedBy(String.valueOf(-1));
        familyBean.setUpdatedOn(new Date());
        familyBean.setState(CFHC_FAMILY_STATE_NEW);
        familyBean.setFamilyId("TMP" + new Date().getTime() / 1000);
        familyBean.setLocationId(locationId);
        familyBean.setAreaId(locationId);
        jsonObject.add("familyUuid", new JsonPrimitive(familyBean.getUuid()));
        jsonObject.add("locationId", new JsonPrimitive(familyBean.getAreaId()));
        try {
            familyBeanDao.create(familyBean);
            List<MemberDataBean> arrays = new ArrayList<>();
            for (Map.Entry<Integer, JsonObject> entry : mapOfPageNumberAndJsonObject.entrySet()) {
                if (entry.getKey() == 0) {
                    continue;
                }
                MemberBean memberBean = new MemberBean();
                memberBean.setFirstName(entry.getValue().has("firstName") ? entry.getValue().get("firstName").getAsString() : memberBean.getFirstName());
                memberBean.setLastName(entry.getValue().has("lastName") ? entry.getValue().get("lastName").getAsString() : memberBean.getLastName());
                memberBean.setMiddleName(entry.getValue().has("middleName") ? entry.getValue().get("middleName").getAsString() : memberBean.getMiddleName());
                memberBean.setDob(entry.getValue().has("dob") ? new Date(entry.getValue().get("dob").getAsLong()) : memberBean.getDob());
                String relationWithHof = entry.getValue().has("relationWithHof") ? entry.getValue().get("relationWithHof").getAsString() : null;
                if (relationWithHof != null) {
                    if (OCRUtils.calculateSimilarity(relationWithHof, "self") > 0.70) {
                        memberBean.setFamilyHeadFlag(true);
                    } else {
                        memberBean.setRelationWithHof(relationWithHof);
                    }
                }

                memberBean.setGender(entry.getValue().has("gender") ? entry.getValue().get("gender").getAsString() : memberBean.getGender());
                memberBean.setMobileNumber(entry.getValue().has("mobileNumber") ? entry.getValue().get("mobileNumber").getAsString() : memberBean.getMobileNumber());
                memberBean.setIsPregnantFlag(entry.getValue().has("isPregnant") ? CommonUtil.returnTrueFalseFromInitials(entry.getValue().get("isPregnant").getAsString()) : memberBean.getPregnantFlag());

                String maritalStatus = entry.getValue().has("maritalStatus") ? entry.getValue().get("maritalStatus").getAsString() : null;
                if (maritalStatus != null) {
                    maritalStatus.toLowerCase();
                    switch (maritalStatus) {
                        case "married":
                            memberBean.setMaritalStatus("629");
                            break;
                        case "unmarried":
                            memberBean.setMaritalStatus("630");
                            break;
                        case "widow":
                            memberBean.setMaritalStatus("641");
                            break;
                        case "widower":
                            memberBean.setMaritalStatus("643");
                            break;
                        case "abandoned":
                            memberBean.setMaritalStatus("642");
                            break;
                    }
                }
                if (memberBean.getMemberUuid() == null && memberBean.getUniqueHealthId() == null) {
                    memberBean.setMemberUuid(UUID.randomUUID().toString());
                }
                memberBean.setUpdatedOn(new Date());
                memberBean.setUpdatedBy(String.valueOf(-1));
                memberBean.setCreatedOn(new Date());
                memberBean.setCreatedBy(String.valueOf(-1));
                memberBean.setUniqueHealthId(generateTempUniqueHealthId(memberBean.getMemberUuid()));
                arrays.add(new MemberDataBean(memberBean));
                memberBean.setFamilyId(familyBean.getFamilyId());
                sewaService.createMemberBean(null, memberBean, familyBean);
            }


            JsonArray jsonArray = new Gson().toJsonTree(arrays).getAsJsonArray();
            jsonObject.add("members", jsonArray);
            jsonObject.add("formFilledVia", new JsonPrimitive("OCR"));
            jsonObject.add("locationId", new JsonPrimitive(locationId));
            jsonObject.add("mobileStartDate", new JsonPrimitive(new Date().toString()));
            jsonObject.add("mobileEndDate", new JsonPrimitive(new Date().toString()));
            if (SharedStructureData.gps != null) {
                SharedStructureData.gps.getLocation();
                jsonObject.add("latitude", new JsonPrimitive(String.valueOf(GPSTracker.latitude)));
                jsonObject.add("longitude", new JsonPrimitive(String.valueOf(GPSTracker.longitude)));
            }
            if (familyBean.getActualId() != null) {
                jsonObject.add("familyId", new JsonPrimitive(familyBean.getActualId()));
            }

            String healthInfraId = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID);
            if (healthInfraId != null) {
                jsonObject.add("referralPlace", new JsonPrimitive(healthInfraId));
            }

            //Preparing Checksum
            StringBuilder checkSum = new StringBuilder(SewaTransformer.loginBean.getUsername());
            checkSum.append(Calendar.getInstance().getTimeInMillis());

            StoreAnswerBean storeAnswerBean = new StoreAnswerBean();
            storeAnswerBean.setAnswerEntity(FormConstants.OCR_HOUSEHOLD_LINE_LIST);
            storeAnswerBean.setAnswer(String.valueOf(jsonObject));
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
            loggerBean.setBeneficiaryName(UtilBean.getMyLabel("New family added"));
            loggerBean.setCheckSum(checkSum.toString());
            loggerBean.setDate(Calendar.getInstance().getTimeInMillis());
            loggerBean.setFormType(ocrFormName);
            loggerBean.setTaskName(UtilBean.getFullFormOfEntity().get(ocrFormName));
            loggerBean.setStatus(GlobalTypes.STATUS_PENDING);
            loggerBean.setRecordUrl(WSConstants.CONTEXT_URL_TECHO.trim());
            loggerBean.setNoOfAttempt(0);
            sewaService.createLoggerBean(loggerBean);
        } catch (Exception e) {
            Log.i(getClass().getSimpleName(), e.getMessage());
        }

    }


    public static JsonObject mergeJsonObjects
            (Map<Integer, JsonObject> mapOfPageNumberAndJsonObject) {
        JsonObject mergedJson = new JsonObject();

        for (Map.Entry<Integer, JsonObject> entry : mapOfPageNumberAndJsonObject.entrySet()) {
            JsonObject jsonObject = entry.getValue();
            for (String key : jsonObject.keySet()) {
                mergedJson.add(key, jsonObject.get(key));
            }
        }

        return mergedJson;
    }

    public static void setDataForHouseHold(FamilyBean familyBean, JsonObject jsonObject) {
        familyBean.setHouseNumber(jsonObject.get("houseNumber").getAsString());
        familyBean.setAddress1(jsonObject.get("address").getAsString());
        familyBean.setTypeOfToilet(jsonObject.get("typeOfToilet").getAsString());
        familyBean.setDrinkingWaterSource(jsonObject.get("drinkingWaterSource").getAsString());
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