package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static android.widget.LinearLayout.HORIZONTAL;
import static android.widget.LinearLayout.VERTICAL;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;
import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.context;
import static com.argusoft.sewa.android.app.util.UtilBean.createAdapter;
import static com.argusoft.sewa.android.app.util.UtilBean.setBmiTextColorAndText;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.graphics.Typeface;
import android.preference.PreferenceManager;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.text.format.DateFormat;
import android.text.method.DigitsKeyListener;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.recyclerview.widget.RecyclerView;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.activity.CustomPhotoCaptureActivity;
import com.argusoft.sewa.android.app.activity.DynamicFormActivity;
import com.argusoft.sewa.android.app.component.listeners.AudioPlayerListener;
import com.argusoft.sewa.android.app.component.listeners.AudioTextBoxListener;
import com.argusoft.sewa.android.app.component.listeners.BloodPresserChangedListener;
import com.argusoft.sewa.android.app.component.listeners.CheckBoxChangeListener;
import com.argusoft.sewa.android.app.component.listeners.CheckBoxWithTextBoxListener;
import com.argusoft.sewa.android.app.component.listeners.ComboChangeListener;
import com.argusoft.sewa.android.app.component.listeners.DateChangeListener;
import com.argusoft.sewa.android.app.component.listeners.HealthInfrastructureComponent;
import com.argusoft.sewa.android.app.component.listeners.HeightBoxChangeListener;
import com.argusoft.sewa.android.app.component.listeners.OtpVerificationListener;
import com.argusoft.sewa.android.app.component.listeners.RadioButtonCheckedListener;
import com.argusoft.sewa.android.app.component.listeners.RadioButtonDateListener;
import com.argusoft.sewa.android.app.component.listeners.SimulationsAudioPlayerListener;
import com.argusoft.sewa.android.app.component.listeners.TemperatureBoxListener;
import com.argusoft.sewa.android.app.component.listeners.TextFocusChangeListener;
import com.argusoft.sewa.android.app.component.listeners.TimeChangeListener;
import com.argusoft.sewa.android.app.component.listeners.WeightBoxChangeListener;
import com.argusoft.sewa.android.app.constants.ActivityConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.FullFormConstants;
import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.FormulaTagBean;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.databean.OptionTagBean;
import com.argusoft.sewa.android.app.databean.ValidationTagBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.MemberBean;
import com.argusoft.sewa.android.app.qrscanner.QRScannerActivity;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.argusoft.sewa.android.app.util.WeightScoreUtil;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.chip.Chip;
import com.google.android.material.chip.ChipGroup;
import com.google.android.material.textfield.TextInputLayout;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.google.zxing.integration.android.IntentIntegrator;

import java.lang.reflect.Type;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.TreeSet;
import java.util.UUID;

import lecho.lib.hellocharts.model.Axis;
import lecho.lib.hellocharts.model.Line;
import lecho.lib.hellocharts.model.LineChartData;
import lecho.lib.hellocharts.model.PointValue;
import lecho.lib.hellocharts.view.LineChartView;

public class MyDynamicComponents {

    private static boolean moreDetailsDisplayed = false;

    private static TableRow.LayoutParams layoutParamsForRow = new TableRow.LayoutParams(MATCH_PARENT);
    private static TableRow.LayoutParams layoutParams2 = new TableRow.LayoutParams(0, WRAP_CONTENT, 2);
    private static TableRow.LayoutParams layoutParams1 = new TableRow.LayoutParams(0, MATCH_PARENT, 1);

    private static MyProcessDialog processDialog;

    private MyDynamicComponents() {
    }

    public static RadioGroup getRadioGroup(Context context, QueFormBean queFormBean, int id, boolean isHorizontal) {

        RadioGroup radioGroup = new RadioGroup(context);
        radioGroup.setPadding(0, 0, 0, 20);
        RadioButton radioButton;
        if (isHorizontal) {
            radioGroup.setOrientation(HORIZONTAL);
        }

        //add default value
        List<OptionDataBean> optionDataBean = UtilBean.getOptionsOrDataMap(queFormBean, false);
        if (queFormBean.getRelatedpropertyname() == null || queFormBean.getRelatedpropertyname().trim().length() == 0) {
            queFormBean.setRelatedpropertyname(optionDataBean.get(0).getRelatedProperty());
        }

        int defaultIndex = -1;
        if (queFormBean.getIshidden().equalsIgnoreCase(GlobalTypes.FALSE)) {
            String relatedPropertyName = null;
            if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0 && !queFormBean.getRelatedpropertyname().trim().equalsIgnoreCase("null")) {
                relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            }
            List<FormulaTagBean> formulas = queFormBean.getFormulas();
            if (formulas != null && !formulas.isEmpty()) {
                String formulaValue = formulas.get(0).getFormulavalue();
                String[] split = UtilBean.split(formulaValue, GlobalTypes.KEY_VALUE_SEPARATOR);
                if (Arrays.toString(split).toLowerCase().contains(FormulaConstants.FORMULA_SET_DEFAULT_PROPERTY)) {
                    if (relatedPropertyName == null || relatedPropertyName.trim().length() == 0 || relatedPropertyName.equalsIgnoreCase("null")) {
                        relatedPropertyName = split[1];
                    }
                    String relatedPropertyValue;
                    if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                        relatedPropertyName += queFormBean.getLoopCounter();
                    }
                    relatedPropertyValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);

                    OptionDataBean defaultValue = new OptionDataBean();
                    if (relatedPropertyValue != null && relatedPropertyValue.length() > 0 && !relatedPropertyValue.equalsIgnoreCase("null")) {
                        defaultValue.setKey(relatedPropertyValue);
                        defaultIndex = optionDataBean.indexOf(defaultValue);
                    }
                }
            }

            radioGroup.setOnCheckedChangeListener(new RadioButtonCheckedListener(queFormBean, optionDataBean));

            int counter = 0;
            if (id > 0) {
                radioGroup.setId(id);
            }
            if (!optionDataBean.isEmpty()) {
                for (OptionDataBean value : optionDataBean) {
                    radioButton = MyStaticComponents.getRadioButton(context, value.getValue(), counter++);
                    radioButton.setPadding(0, 0, 50, 0);
                    radioGroup.addView(radioButton);
                }
                if (defaultIndex != -1) {
                    ((RadioButton) radioGroup.getChildAt(defaultIndex)).setChecked(true);
                }
            }
            return radioGroup;
        }
        return radioGroup;
    }

    public static View getCheckBoxWithTextBox(Context context, QueFormBean queFormBean) {

        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        CheckBoxWithTextBoxListener myListener = new CheckBoxWithTextBoxListener(queFormBean);

        String notAvailableText = queFormBean.getDatamap();
        if (notAvailableText == null) {
            notAvailableText = GlobalTypes.NOT_AVAILABLE;
        }
        CheckBox myCheBox = MyStaticComponents.getCheckBox(context, notAvailableText, IdConstants.CHECKBOX_WITH_TEXT_BOX_CHECKBOX_ID, false);
        myCheBox.setOnCheckedChangeListener(myListener);
        myCheBox.setTextColor(ContextCompat.getColorStateList(context, R.color.checkbox_selector));
        mainLayout.addView(myCheBox);

        LinearLayout inputLayout = getLinearLayout(context,
                IdConstants.CHECKBOX_WITH_TEXT_BOX_INPUT_LAYOUT_ID, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        int inputType = -1;
        List<ValidationTagBean> validations = queFormBean.getValidations();
        if (validations != null && !validations.isEmpty()) {
            for (ValidationTagBean validation : validations) {
                if (validation.getMethod().equalsIgnoreCase(FormulaConstants.NUMERIC)
                        || validation.getMethod().equalsIgnoreCase(FormulaConstants.GREATER_THAN_0)
                        || validation.getMethod().equalsIgnoreCase(FormulaConstants.ONLY_NUMBERS)) {
                    inputType = InputType.TYPE_CLASS_NUMBER;
                    break;
                }
            }
        }

        TextInputLayout editText = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), -1, queFormBean.getLength(), inputType);
        if (editText.getEditText() != null) {
            editText.getEditText().setOnFocusChangeListener(myListener);
        }
        String defaultValue;
        if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (defaultValue != null) {
                queFormBean.setAnswer(defaultValue);
                editText.getEditText().setText(defaultValue);
            }
        }

        if (SharedStructureData.formType != null && SharedStructureData.formType.equals(FormConstants.FAMILY_HEALTH_SURVEY)
                && Boolean.TRUE.equals(SharedStructureData.isAadharNumberScanned) && queFormBean.getId() == 14) {
            //14 has to be the id of the question for aadhar number
            myCheBox.setClickable(false);
            editText.setClickable(false);
            editText.setFocusable(false);
        }
        inputLayout.addView(editText);
        mainLayout.addView(inputLayout);
        return mainLayout;
    }

    public static View getCheckBoxWithTextWatcherBox(Context context, QueFormBean queFormBean) {

        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        CheckBoxWithTextBoxListener myListener = new CheckBoxWithTextBoxListener(queFormBean);

        String notAvailableText = queFormBean.getDatamap();
        if (notAvailableText == null) {
            notAvailableText = GlobalTypes.NOT_AVAILABLE;
        }
        CheckBox myCheBox = MyStaticComponents.getCheckBox(context, notAvailableText, IdConstants.CHECKBOX_WITH_TEXT_BOX_CHECKBOX_ID, false);
        myCheBox.setOnCheckedChangeListener(myListener);
        myCheBox.setTextColor(ContextCompat.getColorStateList(context, R.color.checkbox_selector));
        mainLayout.addView(myCheBox);

        LinearLayout inputLayout = getLinearLayout(context,
                IdConstants.CHECKBOX_WITH_TEXT_BOX_INPUT_LAYOUT_ID, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        int inputType = -1;
        List<ValidationTagBean> validations = queFormBean.getValidations();
        if (validations != null && !validations.isEmpty()) {
            for (ValidationTagBean validation : validations) {
                if (validation.getMethod().equalsIgnoreCase(FormulaConstants.GREATER_THAN_0)
                        || validation.getMethod().equalsIgnoreCase(FormulaConstants.ONLY_NUMBERS) || validation.getMethod().equalsIgnoreCase(FormulaConstants.NUMERIC)) {
                    inputType = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
                    break;
                } else if (validation.getMethod().equalsIgnoreCase(FormulaConstants.NUMERIC) || validation.getMethod().equalsIgnoreCase(FormulaConstants.GREATER_THAN_0)) {
                    inputType = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
                    break;
                }
            }
        }

        TextInputLayout editText = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), -1, queFormBean.getLength(), inputType);
        if (editText.getEditText() != null) {
            editText.getEditText().setOnFocusChangeListener(myListener);
        }
        String defaultValue;
        if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (defaultValue != null) {
                queFormBean.setAnswer(defaultValue);
                editText.getEditText().setText(defaultValue);
            }
        }

        MaterialTextView validationView = new MaterialTextView(context);
        validationView.setTextColor(Color.RED);
        validationView.setVisibility(View.GONE);

        if (editText.getEditText() != null) {
            editText.getEditText().addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

                }

                @Override
                public void onTextChanged(CharSequence s, int i, int i1, int i2) {
                    if (s != null) {
                        checkValidationsForTWB(s.toString(), validationView, queFormBean, DynamicUtils.checkValidation(s.toString(), queFormBean.getLoopCounter(), queFormBean.getValidations()) != null);
                    } else {
                        checkValidationsForTWB(null, validationView, queFormBean, DynamicUtils.checkValidation(null, queFormBean.getLoopCounter(), queFormBean.getValidations()) != null);
                    }
                }

                @Override
                public void afterTextChanged(Editable editable) {

                }
            });
        }

        if (SharedStructureData.formType != null && SharedStructureData.formType.equals(FormConstants.FAMILY_HEALTH_SURVEY)
                && Boolean.TRUE.equals(SharedStructureData.isAadharNumberScanned) && queFormBean.getId() == 14) {
            //14 has to be the id of the question for aadhar number
            myCheBox.setClickable(false);
            editText.setClickable(false);
            editText.setFocusable(false);
        }
        inputLayout.addView(editText);
        inputLayout.addView(validationView);
        mainLayout.addView(inputLayout);
        return mainLayout;
    }

    public static LinearLayout getCheckBoxInGroup(Context context, QueFormBean queFormBean, int id, CheckBoxChangeListener listener) {

        LinearLayout checkBoxGroup = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (listener != null) {
            listener.setLayout(checkBoxGroup);
        }

        String defaultValue = null;
        List<String> defaultValues = null;

        if (queFormBean != null && queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (defaultValue != null) {
                defaultValues = UtilBean.getListFromStringBySeparator(defaultValue, GlobalTypes.COMMA);
            }
        }

        List<OptionDataBean> options = UtilBean.getOptionsOrDataMap(queFormBean, false);

        if (!options.isEmpty() && !options.get(0).getKey().equalsIgnoreCase(GlobalTypes.NO_OPTION_AVAILABLE)) {
            int counter = 0;
            List<CheckBox> defaultSelectedCheckBoxes = new ArrayList<>();
//            CheckBox selectAllCheckBox = null;

            for (OptionDataBean name : options) {
                CheckBox checkBox;
//                if (name.getKey().equalsIgnoreCase("selectall")) {
//                    checkBox = MyStaticComponents.getCheckBox(context, name.getValue(), counter++, false);
//                    selectAllCheckBox = checkBox; // Store the "Select All" checkbox reference
//                }
                if (defaultValues != null && !defaultValues.isEmpty() && defaultValues.contains(name.getKey())) {
                    checkBox = MyStaticComponents.getCheckBox(context, name.getValue(), counter++, false);
                    defaultSelectedCheckBoxes.add(checkBox);
                } else {
                    checkBox = MyStaticComponents.getCheckBox(context, name.getValue(), counter++, false);
                }
                checkBox.setTextColor(ContextCompat.getColorStateList(context, R.color.checkbox_selector));
                checkBox.setPadding(0, 20, 0, 20);
                checkBox.setOnCheckedChangeListener(listener);
                checkBoxGroup.addView(checkBox);
                checkBoxGroup.addView(MyStaticComponents.getSeparator(context));
            }
//            if (selectAllCheckBox != null) {
//                CheckBox finalSelectAllCheckBox = selectAllCheckBox;
//                selectAllCheckBox.setOnCheckedChangeListener((buttonView, isChecked) -> {
//                    for (int i = 0; i < checkBoxGroup.getChildCount(); i++) {
//                        View child = checkBoxGroup.getChildAt(i);
//                        if (child instanceof CheckBox && child != finalSelectAllCheckBox) {
//                            CheckBox checkBox = (CheckBox) child;
//                            checkBox.setChecked(isChecked);
//                        }
//                    }
//                });
//            }
            for (CheckBox checkBox : defaultSelectedCheckBoxes) {
                checkBox.setChecked(true);
            }
            if (queFormBean != null) {
                queFormBean.setAnswer(defaultValue);
            }
        } else {
            if (defaultValues != null && !defaultValues.isEmpty()) {
                int counter = 0;
                for (String name : defaultValues) {
                    CheckBox checkBox = MyStaticComponents.getCheckBox(context, name, counter++, false);
                    checkBox.setOnCheckedChangeListener(listener);
                    checkBoxGroup.addView(checkBox);
                }
            } else {
                checkBoxGroup.addView(MyStaticComponents.generateAnswerView(context, GlobalTypes.NO_OPTION_AVAILABLE));
            }
        }
        if (id != -1) {
            checkBoxGroup.setId(id);
        }

        return checkBoxGroup;
    }

    public static LinearLayout getChardhamCheckBoxInGroup(Context context, QueFormBean queFormBean, int id, CheckBoxChangeListener listener) {
        LinearLayout checkBoxGroup = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (listener != null) {
            listener.setLayout(checkBoxGroup);
        }

        String defaultValue = null;
        List<String> defaultValues = null;
        List<CheckBox> allCheckBoxes;

        if (queFormBean != null && queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (defaultValue != null) {
                defaultValues = UtilBean.getListFromStringBySeparator(defaultValue, GlobalTypes.COMMA);
            }
        }

        List<OptionDataBean> options = UtilBean.getOptionsOrDataMap(queFormBean, false);
        List<String> searchableOptions = new ArrayList<>();

        for (OptionDataBean option : options) {
            searchableOptions.add(option.getValue());
        }
        allCheckBoxes = new ArrayList<>();
        List<CheckBox> finalAllCheckBoxes = allCheckBoxes;
        AutoCompleteTextView searchList = MyStaticComponents.getAutoCompleteTextView(
                context,
                LabelConstants.SEARCH_TREATMENT,
                searchableOptions,
                (adapterView, view, i, l) -> {
                    String selectedItem = adapterView.getItemAtPosition(i).toString();
                    if (!finalAllCheckBoxes.isEmpty()) {
                        for (CheckBox checkBox : finalAllCheckBoxes) {
                            if (checkBox.getText().equals(selectedItem)) {
                                checkBox.setChecked(true);
                            }
                        }
                    }
                });
        checkBoxGroup.addView(searchList);
        if (!options.isEmpty() && !options.get(0).getKey().equalsIgnoreCase(GlobalTypes.NO_OPTION_AVAILABLE)) {
            int counter = 0;
            List<CheckBox> defaultSelectedCheckBoxes = new ArrayList<>();
            for (OptionDataBean name : options) {
                CheckBox checkBox;
                if (defaultValues != null && !defaultValues.isEmpty() && defaultValues.contains(name.getKey())) {
                    checkBox = MyStaticComponents.getCheckBox(context, name.getValue(), counter++, false);
                    defaultSelectedCheckBoxes.add(checkBox);
                } else {
                    checkBox = MyStaticComponents.getCheckBox(context, name.getValue(), counter++, false);
                    allCheckBoxes.add(checkBox);
                }
                checkBox.setTextColor(ContextCompat.getColorStateList(context, R.color.checkbox_selector));
                checkBox.setPadding(0, 20, 0, 20);
                checkBox.setOnCheckedChangeListener(listener);
                checkBoxGroup.addView(checkBox);
                checkBoxGroup.addView(MyStaticComponents.getSeparator(context));
            }
            for (CheckBox checkBox : defaultSelectedCheckBoxes) {
                checkBox.setChecked(true);
            }

            if (queFormBean != null) {
                queFormBean.setAnswer(defaultValue);
            }
        } else {
            if (defaultValues != null && !defaultValues.isEmpty()) {
                int counter = 0;
                for (String name : defaultValues) {
                    CheckBox checkBox = MyStaticComponents.getCheckBox(context, name, counter++, false);
                    checkBox.setOnCheckedChangeListener(listener);
                    checkBoxGroup.addView(checkBox);
                }
            } else {
                checkBoxGroup.addView(MyStaticComponents.generateAnswerView(context, GlobalTypes.NO_OPTION_AVAILABLE));
            }
        }

        if (id != -1) {
            checkBoxGroup.setId(id);
        }
        return checkBoxGroup;
    }

    @SuppressLint("ClickableViewAccessibility")
    public static LinearLayout getChardhamChipGroup(Context context, QueFormBean queFormBean, int id) {
        LinearLayout chipGroupMainLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        AutoCompleteTextView autoCompleteTextView = new AutoCompleteTextView(context);
        List<OptionDataBean> options = UtilBean.getOptionsOrDataMap(queFormBean, false);
        List<String> searchableOptions = new ArrayList<>();
        List<String> answer = new ArrayList<>();

        for (OptionDataBean option : options) {
            searchableOptions.add(option.getValue());
        }

        List<String> selectedChips = new ArrayList<>();
        ChipGroup chipGroup = new ChipGroup(context);

        AdapterView.OnItemClickListener adaptorClickListener = (adapterView, view, i, l) -> {

            String selectedItem = adapterView.getItemAtPosition(i).toString();
            OptionDataBean option = options.get(i);

            if (!selectedChips.contains(selectedItem)) {
                Chip chip = new Chip(context);
                chip.setText(selectedItem);
                chip.setCloseIconVisible(true);
                chip.setOnCloseIconClickListener(view1 -> {
                    selectedChips.remove(chip.getText().toString());
                    answer.remove(option.getKey());
                    chipGroup.removeView(chip);

                    if (!answer.isEmpty()) {
                        queFormBean.setAnswer(UtilBean.stringListJoin(answer, GlobalTypes.COMMA));
                    } else {
                        queFormBean.setAnswer(null);
                    }

                });
                selectedChips.add(chip.getText().toString());
                answer.add(option.getKey());
                chipGroup.addView(chip);

                if (!answer.isEmpty()) {
                    queFormBean.setAnswer(UtilBean.stringListJoin(answer, GlobalTypes.COMMA));
                } else {
                    queFormBean.setAnswer(null);
                }

            } else {
                SewaUtil.generateToast(context, "You have already selected " + selectedItem);
            }
            autoCompleteTextView.setText("");
        };

        ArrayAdapter<String> adapter = new ArrayAdapter<>(context, R.layout.select_dialog_item, searchableOptions);
        autoCompleteTextView.setThreshold(1);
        autoCompleteTextView.setPadding(24, 24, 24, 24);
        autoCompleteTextView.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.ic_arrow_drop_down_black, 0);
        autoCompleteTextView.setCompoundDrawablePadding(20);
        autoCompleteTextView.setBackground(ContextCompat.getDrawable(context, R.drawable.chardham_edit_text_background));
        autoCompleteTextView.setHintTextColor(ContextCompat.getColor(context, R.color.gray));
        autoCompleteTextView.setMaxLines(1);
        autoCompleteTextView.setHint(LabelConstants.SELECT_TREATMENT_CHIP);
        autoCompleteTextView.setAdapter(adapter);
        autoCompleteTextView.setOnItemClickListener(adaptorClickListener);
        autoCompleteTextView.setOnTouchListener((view, motionEvent) -> {
            autoCompleteTextView.showDropDown();
            return false;
        });

        chipGroupMainLayout.addView(autoCompleteTextView);
        chipGroupMainLayout.addView(chipGroup);

        if (id != -1) {
            chipGroupMainLayout.setId(id);
        }
        return chipGroupMainLayout;
    }


    public static LinearLayout getFormSubmissionComponent(final Context context, final QueFormBean queFormBean) {

        LinearLayout linearLayout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.form_submission_component, null);

        MaterialButton submitButton = linearLayout.findViewById(R.id.submitButton);
        MaterialButton reviewButton = linearLayout.findViewById(R.id.reviewButton);

        final OptionTagBean submitOption = queFormBean.getOptions().get(0);

        View.OnClickListener submitListener = v -> {
            queFormBean.setNext(submitOption.getNext());
            queFormBean.setAnswer(submitOption.getKey());
            ((DynamicFormActivity) context).getFormEngine().navigateToNextPage();
        };
        submitButton.setOnClickListener(submitListener);

        final OptionTagBean reviewOption = queFormBean.getOptions().get(1);
        View.OnClickListener reviewListener = v -> {
            queFormBean.setNext(reviewOption.getNext());
            queFormBean.setAnswer(reviewOption.getKey());
            ((DynamicFormActivity) context).getFormEngine().navigateToNextPage();
        };

        reviewButton.setOnClickListener(reviewListener);
        return linearLayout;
    }

    public static LinearLayout getCustomTimePicker(QueFormBean queFormBean, Context context) {
        LinearLayout myLayout = getLinearLayout(context, -1, HORIZONTAL, null);
        myLayout.setGravity(Gravity.CENTER_VERTICAL);
        String textDate = GlobalTypes.SELECT_TIME_TEXT;

        MaterialTextView txtDate = MyStaticComponents.generateAnswerView(context, textDate);
        txtDate.setId(IdConstants.DATE_PICKER_TEXT_DATE_ID);
        txtDate.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 200));

        myLayout.addView(txtDate);

        ImageView imageCalendar = MyStaticComponents.getImageView(context, 2, R.drawable.ic_timepicker, null);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1);
        imageCalendar.setLayoutParams(layoutParams);
        myLayout.addView(imageCalendar);

        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            myLayout.setBackground(context.getDrawable(R.drawable.training_custom_datepicker));
        } else {
            myLayout.setBackground(context.getDrawable(R.drawable.custom_datepicker));
        }
        myLayout.setOnClickListener(new TimeChangeListener(queFormBean, context));
        myLayout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
//        RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) myLayout.getLayoutParams();
//        lp.setMargins(0, 0, 0, 50);
        return myLayout;
    }

    public static LinearLayout getCustomDatePicker(QueFormBean queFormBean, Context context) {
        LinearLayout myLayout = getLinearLayout(context, -1, HORIZONTAL, null);
        String textDate = GlobalTypes.SELECT_DATE_TEXT;
        if (queFormBean.getRelatedpropertyname() != null) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            String stringLongDate = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (stringLongDate != null) {
                long longDate = Long.parseLong(stringLongDate);
                textDate = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(new Date(longDate));
                queFormBean.setAnswer(longDate);
            }
        }

        MaterialTextView txtDate = MyStaticComponents.generateAnswerView(context, textDate);
        txtDate.setId(IdConstants.DATE_PICKER_TEXT_DATE_ID);
        txtDate.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 200));

        myLayout.addView(txtDate);

        ImageView imageCalendar = MyStaticComponents.getImageView(context, 2, R.drawable.ic_calender, null);
        imageCalendar.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));
        myLayout.addView(imageCalendar);

        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            myLayout.setBackground(context.getDrawable(R.drawable.training_custom_datepicker));
        } else {
            myLayout.setBackground(context.getDrawable(R.drawable.custom_datepicker));
        }

        boolean isFutureDate = false;
        boolean isPastDate = false;
        if (queFormBean.getValidations() != null && !queFormBean.getValidations().isEmpty()) {
            for (ValidationTagBean validation : queFormBean.getValidations()) {
                if (validation.getMethod().equalsIgnoreCase("isFutureDate")) {
                    isFutureDate = true;
                    break;
                }

                if (validation.getMethod().equalsIgnoreCase("isPastDate")) {
                    isPastDate = true;
                    break;
                }
            }
        }
        myLayout.setOnClickListener(new DateChangeListener(queFormBean, context, isFutureDate, isPastDate));
        if (SharedStructureData.formType != null && SharedStructureData.formType.equals(FormConstants.CFHC)
                && Boolean.TRUE.equals(SharedStructureData.isDobScannedFromAadhar)) {
            myLayout.setClickable(false);
        }

        myLayout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) myLayout.getLayoutParams();
//        lp.setMargins(0, 0, 0, 50);
        return myLayout;
    }

    public static LinearLayout getCustomDatePickerForServiceDate(QueFormBean queFormBean, Context context) {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        LinearLayout myLayout = getLinearLayout(context, -1, HORIZONTAL, null);
        String textDate = GlobalTypes.SELECT_DATE_TEXT;
        if (queFormBean.getRelatedpropertyname() != null) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            String stringLongDate = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (stringLongDate != null) {
                long longDate = Long.parseLong(stringLongDate);
                textDate = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(new Date(longDate));
                queFormBean.setAnswer(longDate);
            }
        }

        MaterialTextView txtDate = MyStaticComponents.generateAnswerView(context, textDate);
        txtDate.setId(IdConstants.DATE_PICKER_TEXT_DATE_ID);
        txtDate.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 200));

        myLayout.addView(txtDate);

        ImageView imageCalendar = MyStaticComponents.getImageView(context, 2, R.drawable.ic_calender, null);
        imageCalendar.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));
        myLayout.addView(imageCalendar);

        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            myLayout.setBackground(context.getDrawable(R.drawable.training_custom_datepicker));
        } else {
            myLayout.setBackground(context.getDrawable(R.drawable.custom_datepicker));
        }

        boolean isFutureDate = false;
        boolean isPastDate = false;
        if (queFormBean.getValidations() != null && !queFormBean.getValidations().isEmpty()) {
            for (ValidationTagBean validation : queFormBean.getValidations()) {
                if (validation.getMethod().equalsIgnoreCase("isFutureDate")) {
                    isFutureDate = true;
                    break;
                }

                if (validation.getMethod().equalsIgnoreCase("isPastDate")) {
                    isPastDate = true;
                    break;
                }
            }
        }
        myLayout.setOnClickListener(new DateChangeListener(queFormBean, context, isFutureDate, isPastDate));
        if (SharedStructureData.formType != null && SharedStructureData.formType.equals(FormConstants.CFHC)
                && Boolean.TRUE.equals(SharedStructureData.isDobScannedFromAadhar)) {
            myLayout.setClickable(false);
        }

        myLayout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) myLayout.getLayoutParams();
//        lp.setMargins(0, 0, 0, 50);
        mainLayout.addView(myLayout);
        String lastServiceDate = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_SERVICE_DATE);

        if (lastServiceDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
            mainLayout.addView(MyStaticComponents.generateAnswerView(context, "Service date should be on or after " + sdf.format(new Date(Long.parseLong(lastServiceDate)))));
        }

        return mainLayout;
    }

    public static LinearLayout getCustomDatePickerForServiceDateFP(QueFormBean queFormBean, Context context) {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        LinearLayout myLayout = getLinearLayout(context, -1, HORIZONTAL, null);
        String textDate = GlobalTypes.SELECT_DATE_TEXT;
        if (queFormBean.getRelatedpropertyname() != null) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            String stringLongDate = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (stringLongDate != null) {
                long longDate = Long.parseLong(stringLongDate);
                textDate = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(new Date(longDate));
                queFormBean.setAnswer(longDate);
            }
        }

        MaterialTextView txtDate = MyStaticComponents.generateAnswerView(context, textDate);
        txtDate.setId(IdConstants.DATE_PICKER_TEXT_DATE_ID);
        txtDate.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 200));

        myLayout.addView(txtDate);

        ImageView imageCalendar = MyStaticComponents.getImageView(context, 2, R.drawable.ic_calender, null);
        imageCalendar.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));
        myLayout.addView(imageCalendar);

        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            myLayout.setBackground(context.getDrawable(R.drawable.training_custom_datepicker));
        } else {
            myLayout.setBackground(context.getDrawable(R.drawable.custom_datepicker));
        }

        boolean isFutureDate = false;
        boolean isPastDate = false;
        if (queFormBean.getValidations() != null && !queFormBean.getValidations().isEmpty()) {
            for (ValidationTagBean validation : queFormBean.getValidations()) {
                if (validation.getMethod().equalsIgnoreCase("isFutureDate")) {
                    isFutureDate = true;
                    break;
                }

                if (validation.getMethod().equalsIgnoreCase("isPastDate")) {
                    isPastDate = true;
                    break;
                }
            }
        }
        myLayout.setOnClickListener(new DateChangeListener(queFormBean, context, isFutureDate, isPastDate));
        if (SharedStructureData.formType != null && SharedStructureData.formType.equals(FormConstants.CFHC)
                && Boolean.TRUE.equals(SharedStructureData.isDobScannedFromAadhar)) {
            myLayout.setClickable(false);
        }

        myLayout.setLayoutParams(new RelativeLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        RelativeLayout.LayoutParams lp = (RelativeLayout.LayoutParams) myLayout.getLayoutParams();
//        lp.setMargins(0, 0, 0, 50);
        mainLayout.addView(myLayout);
        String lastServiceDate = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FP_SERVICE_DATE);

        if (lastServiceDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
            mainLayout.addView(MyStaticComponents.generateAnswerView(context, "Service date should be on or after " + sdf.format(new Date(Long.parseLong(lastServiceDate)))));
        }

        return mainLayout;
    }


    public static View getPPGImageView(QueFormBean queFormBean, Context context) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout ppgImageLayout = getLinearLayout(context, -1, VERTICAL, layoutParams);
        Button takePhotoButton = new Button(context);
        takePhotoButton.setId(ActivityConstants.PPG_CAPTURE_ACTIVITY_REQUEST_CODE);
        takePhotoButton.setText("Capture Data");
        SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.PATIENT_UUID, UUID.randomUUID().toString());
        View.OnClickListener onClickListener = new View.OnClickListener() {
            private Activity activity;
            private int currentQuestionId;

            public View.OnClickListener setActivity(Activity activity, int id) {
                this.activity = activity;
                this.currentQuestionId = id;
                return this;
            }

            @Override
            public void onClick(View view) {
                try {
                    SharedStructureData.currentQuestion = currentQuestionId;
                    // launch  activity.
//                    Intent intent = new Intent(activity, QuestionnaireActivity.class);
//                    activity.startActivityForResult(intent, ActivityConstants.PPG_CAPTURE_ACTIVITY_REQUEST_CODE);

                } catch (Exception e) {
                    Log.e(getClass().getName(), null, e);
                }
            }
        }.setActivity((Activity) context, DynamicUtils.getLoopId(queFormBean));
        takePhotoButton.setOnClickListener(onClickListener);
        ppgImageLayout.addView(takePhotoButton);
        return ppgImageLayout;
    }


    public static View getQRScannerView(Context context, QueFormBean queFormBean, int id) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);

        LinearLayout qrScannerView = getLinearLayout(context, -1, VERTICAL, layoutParams);
        if (id != -1) {
            qrScannerView.setId(id);
        }

        ImageView actionButton = MyStaticComponents.getImageView(context, 1, R.drawable.qr_scan, null);

        qrScannerView.addView(actionButton);

        TextInputLayout answerView = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), -1, queFormBean.getLength(), -1);
        answerView.setId(GlobalTypes.QR_SCAN_ACTIVITY);
        answerView.setTag(queFormBean);
        if (answerView.getEditText() != null) {
            answerView.getEditText().setInputType(InputType.TYPE_CLASS_TEXT);
            answerView.getEditText().setKeyListener(DigitsKeyListener.getInstance("0123456789-"));
            answerView.getEditText().setOnFocusChangeListener(new TextFocusChangeListener(context, queFormBean));
            if (queFormBean.getRelatedpropertyname() != null && SharedStructureData.relatedPropertyHashTable.containsKey(queFormBean.getRelatedpropertyname())) {
                answerView.getEditText().setText(SharedStructureData.relatedPropertyHashTable.get(queFormBean.getRelatedpropertyname()));
                queFormBean.setAnswer(SharedStructureData.relatedPropertyHashTable.get(queFormBean.getRelatedpropertyname()));
            }
        }

        if (SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_QR_ENABLED) != null && SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.IS_QR_ENABLED).equalsIgnoreCase("1")) {
            answerView.setVisibility(View.VISIBLE);
            answerView.setEnabled(true);
        } else {
            answerView.setVisibility(View.GONE);
            answerView.setEnabled(false);
        }
        qrScannerView.addView(answerView, layoutParams);

        View.OnClickListener onClickListener = new View.OnClickListener() {
            private Activity activity;
            private int currentQuestionId;

            public View.OnClickListener setActivity(Activity activity, int id) {
                this.activity = activity;
                this.currentQuestionId = id;
                return this;
            }

            @Override
            public void onClick(View view) {
                try {
                    SharedStructureData.currentQuestion = currentQuestionId;
                    // launch barcode activity.
                    //initiate scan with our custom scan activity
                    IntentIntegrator intentIntegrator = new IntentIntegrator(activity);
                    intentIntegrator.setCaptureActivity(QRScannerActivity.class);
                    intentIntegrator.initiateScan();

                } catch (Exception e) {
                    Log.e(getClass().getName(), null, e);
                }
            }
        }.setActivity((Activity) context, DynamicUtils.getLoopId(queFormBean));

        actionButton.setOnClickListener(onClickListener);
        return qrScannerView;
    }

    public static View getBarcodeScannerView(Context context, QueFormBean queFormBean, int id) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);

        LinearLayout qrScannerView = getLinearLayout(context, -1, VERTICAL, layoutParams);
        if (id != -1) {
            qrScannerView.setId(id);
        }

        ImageView actionButton = MyStaticComponents.getImageView(context, 1, R.drawable.qr_scan, null);

        qrScannerView.addView(actionButton);

        TextInputLayout answerView = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), -1, queFormBean.getLength(), -1);
        if (answerView.getEditText() != null) {
            answerView.getEditText().setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            answerView.getEditText().setOnFocusChangeListener(new TextFocusChangeListener(context, queFormBean));
        }
        answerView.setId(GlobalTypes.BARCODE_SCAN_ACTIVITY);
        answerView.setVisibility(View.VISIBLE);
        qrScannerView.addView(answerView, layoutParams);

        View.OnClickListener onClickListener = new View.OnClickListener() {
            private Activity activity;
            private int currentQuestionId;

            public View.OnClickListener setActivity(Activity activity, int id) {
                this.activity = activity;
                this.currentQuestionId = id;
                return this;
            }

            @Override
            public void onClick(View view) {
                try {
                    SharedStructureData.currentQuestion = currentQuestionId;
                    // launch barcode activity.
                    //initiate scan with our custom scan activity
                    IntentIntegrator intentIntegrator = new IntentIntegrator(activity);
                    intentIntegrator.setDesiredBarcodeFormats(intentIntegrator.ALL_CODE_TYPES);
                    intentIntegrator.setCaptureActivity(QRScannerActivity.class);
                    intentIntegrator.setPrompt("Scan a barcode");
                    intentIntegrator.setCameraId(0);  // Use a specific camera of the device
                    intentIntegrator.setBeepEnabled(true);
                    intentIntegrator.setBarcodeImageEnabled(true);
                    intentIntegrator.initiateScan();

                } catch (Exception e) {
                    Log.e(getClass().getName(), null, e);
                }
            }
        }.setActivity((Activity) context, DynamicUtils.getLoopId(queFormBean));

        actionButton.setOnClickListener(onClickListener);
        return qrScannerView;
    }

    public static Spinner getSpinner(Context context, QueFormBean queFormBean, int id) {
        //add default value
        Spinner spinner = new Spinner(context, Spinner.MODE_DIALOG);
        String typeOfQue = queFormBean.getType();
        boolean isCombo = typeOfQue != null && typeOfQue.equalsIgnoreCase(GlobalTypes.COMBO_BOX_DYNAMIC_SELECT);
        List<OptionDataBean> optionDataBeans = UtilBean.getOptionsOrDataMap(queFormBean, isCombo);

        int defaultIndex = 0;
        String relatedPropertyName = null;
        if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0 && !queFormBean.getRelatedpropertyname().trim().equalsIgnoreCase("null")) {
            relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
        }
        List<FormulaTagBean> formulas = queFormBean.getFormulas();
        if (formulas != null && !formulas.isEmpty()) {
            String formulaValue = formulas.get(0).getFormulavalue();
            String[] split = UtilBean.split(formulaValue, GlobalTypes.KEY_VALUE_SEPARATOR);

            if (Arrays.toString(split).toLowerCase().contains(FormulaConstants.FORMULA_SET_DEFAULT_PROPERTY)) {
                if (relatedPropertyName == null || relatedPropertyName.trim().length() == 0 || relatedPropertyName.equalsIgnoreCase("null")) {
                    relatedPropertyName = split[1];
                }
                if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                    relatedPropertyName += queFormBean.getLoopCounter();
                }
                OptionDataBean defaultValue = new OptionDataBean();
                defaultValue.setKey(SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName));

                if (defaultValue.getKey() != null && defaultValue.getKey().trim().length() > 0) {
                    defaultIndex = optionDataBeans.indexOf(defaultValue);
                }
            }
        }
        spinner.setOnItemSelectedListener(new ComboChangeListener(queFormBean));

        if (!optionDataBeans.isEmpty()) {
            MyArrayAdapter myAdapter = new MyArrayAdapter(context, R.layout.spinner_item_top, UtilBean.getListOfOptions(optionDataBeans));
            myAdapter.setDropDownViewResource(R.layout.spinner_item_dropdown);
            spinner.setAdapter(myAdapter);
            spinner.setSelection(defaultIndex);
        }
        if (id != -1) {
            spinner.setId(id);
        }

        if (BuildConfig.FLAVOR.equalsIgnoreCase(GlobalTypes.FLAVOUR_UTTARAKHAND)) {
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
            layoutParams.setMargins(0, 0, 0, 40);
            spinner.setLayoutParams(layoutParams);
        }

        return spinner;
    }

    public static LinearLayout getHealthInfrastructureComponent(Context context, final QueFormBean queFormBean) {
        return new HealthInfrastructureComponent(context, queFormBean);
    }

    public static LinearLayout getOralScreeningComponent(final Context context, final QueFormBean queFormBean) {
        final Set<String> selectedCheckBoxTags = new LinkedHashSet<>();
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout oralScreeningComponent = getLinearLayout(context, 10001, VERTICAL, layoutParams);
        oralScreeningComponent.setGravity(Gravity.CENTER);
        LayoutInflater vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View v = vi.inflate(R.layout.oral_examlayout, oralScreeningComponent);

        CompoundButton.OnCheckedChangeListener onCheckedChangeListener = (buttonView, isChecked) -> {
            String tag = buttonView.getTag().toString();
            if (isChecked) {
                selectedCheckBoxTags.add(tag);
            } else {
                selectedCheckBoxTags.remove(tag);
            }
            queFormBean.setAnswer(UtilBean.stringListJoin(selectedCheckBoxTags, ","));
        };

        for (int i = 1; i < 17; i++) {
            CheckBox c = v.findViewById(context.getResources().getIdentifier("oral_chkBox" + i, "id", context.getPackageName()));
            c.setOnCheckedChangeListener(onCheckedChangeListener);
        }

        return oralScreeningComponent;
    }

    public static LinearLayout getBreastScreeningComponent(final Context context, final QueFormBean queFormBean) {
        final Set<String> selectedCheckBoxTags = new LinkedHashSet<>();
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout breastScreeningComponent = getLinearLayout(context, 10001, VERTICAL, layoutParams);
        breastScreeningComponent.setGravity(Gravity.CENTER);
        LayoutInflater vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View v = vi.inflate(R.layout.breast_exam_layout, breastScreeningComponent);

        CompoundButton.OnCheckedChangeListener onCheckedChangeListener = (buttonView, isChecked) -> {
            String tag = buttonView.getTag().toString();
            if (isChecked) {
                selectedCheckBoxTags.add(tag);
            } else {
                selectedCheckBoxTags.remove(tag);
            }
            queFormBean.setAnswer(UtilBean.stringListJoin(selectedCheckBoxTags, ","));
        };

        for (int i = 1; i < 27; i++) {
            CheckBox c = v.findViewById(context.getResources().getIdentifier("breast_chkBox" + i, "id", context.getPackageName()));
            c.setOnCheckedChangeListener(onCheckedChangeListener);
        }

        disableCheckboxesForBreastScreening(v, queFormBean, context);

        return breastScreeningComponent;
    }

    private static void disableCheckboxesForBreastScreening(View v, QueFormBean queFormBean, Context context) {
        if (queFormBean.getDatamap() != null && !queFormBean.getDatamap().isEmpty()) {
            List<String> list = Arrays.asList(queFormBean.getDatamap().split("-"));
            for (int i = 1; i < 27; i++) {
                CheckBox c = v.findViewById(context.getResources().getIdentifier("breast_chkBox" + i, "id", context.getPackageName()));
                if (!list.contains(String.valueOf(i))) {
                    c.setEnabled(false);
                }
            }
        }
    }

    public static LinearLayout getCervicalScreeningComponent(final Context context, final QueFormBean queFormBean) {
        final Set<String> selectedCheckBoxTags = new LinkedHashSet<>();
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout cervicalScreeningComponent = getLinearLayout(context, 10001, VERTICAL, layoutParams);
        cervicalScreeningComponent.setGravity(Gravity.CENTER);
        LayoutInflater vi = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View v = vi.inflate(R.layout.cervical_exam_layout, cervicalScreeningComponent);

        CompoundButton.OnCheckedChangeListener onCheckedChangeListener = (buttonView, isChecked) -> {
            String tag = buttonView.getTag().toString();
            if (isChecked) {
                selectedCheckBoxTags.add(tag);
            } else {
                selectedCheckBoxTags.remove(tag);
            }
            queFormBean.setAnswer(UtilBean.stringListJoin(selectedCheckBoxTags, ","));
        };

        for (int i = 1; i < 13; i++) {
            CheckBox c = v.findViewById(context.getResources().getIdentifier("cervical_chkBox" + i, "id", context.getPackageName()));
            c.setOnCheckedChangeListener(onCheckedChangeListener);
        }

        return cervicalScreeningComponent;
    }

    public static LinearLayout getBMIComponent(Context context, final QueFormBean queFormBean) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout bmiComponent = getLinearLayout(context, 10000, VERTICAL, layoutParams);
        List<Integer> heightRange = new ArrayList<>();
        List<Float> weightRange = new ArrayList<>();

        String height = null;
        String weight = null;
        String bmi = null;

        if (queFormBean.getFormulas() != null && !queFormBean.getFormulas().isEmpty()) {
            for (FormulaTagBean formulaTagBean : queFormBean.getFormulas()) {
                if (formulaTagBean.getFormulavalue().contains("-")) {
                    //formulaName-heightPropertyName-weightPropertyName
                    String[] split = formulaTagBean.getFormulavalue().split("-");
                    if (split[0].equalsIgnoreCase(FormulaConstants.FORMULA_SET_BMI_HEIGHT_WEIGHT) && split.length >= 3) {
                        height = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                        weight = SharedStructureData.relatedPropertyHashTable.get(split[2]);
                        if (height != null && weight != null) {
                            if (height.contains(".")) {
                                height = height.split("\\.")[0];
                            }
                            bmi = UtilBean.calculateBmi(Integer.parseInt(height), Float.parseFloat(weight));
                            queFormBean.setAnswer(height + "/" + weight + "/" + bmi);
                        }
                        if (split.length == 7) {
                            heightRange.add(Integer.valueOf(split[3]));
                            heightRange.add(Integer.valueOf(split[4]));
                            weightRange.add(Float.valueOf(split[5]));
                            weightRange.add(Float.valueOf(split[6]));
                        }
                    }
                }
            }
        }

        MaterialTextView heightQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.HEIGHT_IN_CMS);
        final TextInputLayout heightAnswerText = MyStaticComponents.getEditText(context, LabelConstants.HEIGHT, 10001, 3, -1);
        heightAnswerText.setPadding(0, 0, 0, 50);
        if (heightAnswerText.getEditText() != null) {
            heightAnswerText.getEditText().setInputType(InputType.TYPE_CLASS_NUMBER);
            if (height != null) {
                heightAnswerText.getEditText().setText(height);
            }
        }

        MaterialTextView weightQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.WEIGHT_IN_KGS);
        final TextInputLayout weightAnswerText = MyStaticComponents.getEditText(context, LabelConstants.WEIGHT, 10002, 6, -1);
        weightAnswerText.setPadding(0, 0, 0, 50);
        if (weightAnswerText.getEditText() != null) {
            weightAnswerText.getEditText().setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            if (weight != null) {
                weightAnswerText.getEditText().setText(weight);
            }
        }

        MaterialTextView bmiQuestionView = MyStaticComponents.generateQuestionView(null, "weight (kg) / [height (m)]2", context, LabelConstants.BMI);
        final MaterialTextView bmiAnswerView = MyStaticComponents.generateAnswerView(context, LabelConstants.NOT_AVAILABLE);
        bmiAnswerView.setPadding(0, 0, 0, 50);
        if (bmi != null) {
            setBmiTextColorAndText(bmiAnswerView, bmi);
        }
        heightAnswerText.getEditText().addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                //add something
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                checkValidationForBMI(s.toString(), weightAnswerText.getEditText().getText().toString(), bmiAnswerView, queFormBean, getClass().getName(), heightRange, weightRange);
            }

            @Override
            public void afterTextChanged(Editable s) {
                //add something
            }
        });

        if (weightAnswerText.getEditText() != null) {
            weightAnswerText.getEditText().addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                    //add something
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    checkValidationForBMI(heightAnswerText.getEditText().getText().toString(), s.toString(), bmiAnswerView, queFormBean, getClass().getName(), heightRange, weightRange);
                }

                @Override
                public void afterTextChanged(Editable s) {
                    //add something
                }
            });
        }

        bmiComponent.addView(heightQuestionView);
        bmiComponent.addView(heightAnswerText);
        bmiComponent.addView(weightQuestionView);
        bmiComponent.addView(weightAnswerText);
        bmiComponent.addView(bmiQuestionView);
//        bmiComponent.addView(infoColorCodes);
        bmiComponent.addView(bmiAnswerView);
        return bmiComponent;
    }

    public static LinearLayout getBMIComponentAdolescent(Context context, final QueFormBean queFormBean) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout bmiComponent = getLinearLayout(context, 10000, VERTICAL, layoutParams);

        String height = null;
        String weight = null;
        String bmi = null;

        if (queFormBean.getFormulas() != null && !queFormBean.getFormulas().isEmpty()) {
            for (FormulaTagBean formulaTagBean : queFormBean.getFormulas()) {
                if (formulaTagBean.getFormulavalue().contains("-")) {
                    //formulaName-heightPropertyName-weightPropertyName
                    String[] split = formulaTagBean.getFormulavalue().split("-");
                    if (split[0].equalsIgnoreCase(FormulaConstants.FORMULA_SET_BMI_HEIGHT_WEIGHT) && split.length == 3) {
                        height = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                        weight = SharedStructureData.relatedPropertyHashTable.get(split[2]);
                        if (height != null && weight != null) {
                            if (height.contains(".")) {
                                height = height.split("\\.")[0];
                            }
                            bmi = UtilBean.calculateBmi(Integer.parseInt(height), Float.parseFloat(weight));
                            queFormBean.setAnswer(height + "/" + weight + "/" + bmi);
                        }
                    }
                }
            }
        }

        MaterialTextView heightQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.HEIGHT_IN_CMS);
        final TextInputLayout heightAnswerText = MyStaticComponents.getEditText(context, LabelConstants.HEIGHT, 10001, 3, -1);
        heightAnswerText.requestFocus();
        heightAnswerText.setPadding(0, -20, 0, 50);
        if (heightAnswerText.getEditText() != null) {
            heightAnswerText.getEditText().setInputType(InputType.TYPE_CLASS_NUMBER);
            /*if (height != null) {
                heightAnswerText.getEditText().setText(height);
            }*/
        }

        MaterialTextView weightQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.WEIGHT_IN_KGS);
        final TextInputLayout weightAnswerText = MyStaticComponents.getEditText(context, LabelConstants.WEIGHT, 10002, 4, -1);
        weightAnswerText.setPadding(0, -20, 0, 50);
        if (weightAnswerText.getEditText() != null) {
            weightAnswerText.getEditText().setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
            /*if (weight != null) {
                weightAnswerText.getEditText().setText(weight);
            }*/
        }

        MaterialTextView bmiQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.BMI);
        final MaterialTextView bmiAnswerView = MyStaticComponents.generateAnswerView(context, LabelConstants.NOT_AVAILABLE);
        bmiAnswerView.setPadding(0, 0, 0, 50);
        /*if (bmi != null) {
            bmiAnswerView.setText(bmi);
        }*/
        heightAnswerText.getEditText().addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                //add something
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                checkValidationForBMIAdolescent(s.toString(), weightAnswerText.getEditText().getText().toString(), bmiAnswerView, queFormBean, getClass().getName());
            }

            @Override
            public void afterTextChanged(Editable s) {
                //add something
            }
        });

        if (weightAnswerText.getEditText() != null) {
            weightAnswerText.getEditText().addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                    //add something
                }

                @Override
                public void onTextChanged(CharSequence s, int start, int before, int count) {
                    checkValidationForBMIAdolescent(heightAnswerText.getEditText().getText().toString(), s.toString(), bmiAnswerView, queFormBean, getClass().getName());
                }

                @Override
                public void afterTextChanged(Editable s) {
                    //add something
                }
            });
        }

        bmiComponent.addView(heightQuestionView);
        bmiComponent.addView(heightAnswerText);
        bmiComponent.addView(weightQuestionView);
        bmiComponent.addView(weightAnswerText);
        bmiComponent.addView(bmiQuestionView);
        bmiComponent.addView(bmiAnswerView);
        return bmiComponent;
    }

    public static void checkValidationForBMIAdolescent(String h, String w, MaterialTextView bmiAnswerView, QueFormBean queFormBean, String className) {
        if (h.isEmpty()) {
            bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
            if (queFormBean != null) {
                queFormBean.setMandatorymessage(LabelConstants.ENTER_HEIGHT);
                queFormBean.setAnswer(null);
            }
        } else if (Integer.parseInt(h) < 100 || Integer.parseInt(h) > 175) {
            bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
            queFormBean.setMandatorymessage(LabelConstants.HEIGHT_BETWEEN_100_TO_175);
            queFormBean.setAnswer(null);
        } else if (w.isEmpty()) {
            bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
            if (queFormBean != null) {
                queFormBean.setMandatorymessage(LabelConstants.ENTER_WEIGHT);
                queFormBean.setAnswer(null);
            }
        } else if (Float.parseFloat(w) < 5 || Float.parseFloat(w) > 70) {
            bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
            queFormBean.setMandatorymessage(LabelConstants.WEIGHT_BETWEEN_5_TO_70);
            queFormBean.setAnswer(null);
        } else {
            try {
                int height = Integer.parseInt(h);
                float weight = Float.parseFloat(w);
                String bmi = UtilBean.calculateBmi(height, weight);
                if (bmi != null) {
                    String condition = "";
                    if (bmi.length() > 0 && Float.parseFloat(bmi) <= 18.5) {
                        condition = UtilBean.getMyLabel(RchConstants.HIGH_RISK_UNDERWEIGHT);
                    } else if (bmi.length() > 0 && Float.parseFloat(bmi) > 18.5 && Float.parseFloat(bmi) <= 25) {
                        condition = UtilBean.getMyLabel(RchConstants.NORMAL);
                    } else if (bmi.length() > 0 && Float.parseFloat(bmi) > 25 && Float.parseFloat(bmi) <= 29.9) {
                        condition = UtilBean.getMyLabel(RchConstants.HIGH_RISK_OVERWEIGHT);
                    } else if (bmi.length() > 0 && Float.parseFloat(bmi) >= 30) {
                        condition = UtilBean.getMyLabel(RchConstants.HIGH_RISK_OBESE);
                    }
                    bmiAnswerView.setText(String.format("%s - %s", bmi, condition));
                    queFormBean.setAnswer(String.format("%s/%s/%s", h, w, bmi));
                } else {
                    bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
                    queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_WEIGHT);
                    queFormBean.setAnswer(null);
                }
            } catch (Exception e) {
                bmiAnswerView.setText(LabelConstants.NOT_AVAILABLE);
                queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_HEIGHT);
                queFormBean.setAnswer(null);
                android.util.Log.e(className, null, e);
            }
        }
    }

    public static LinearLayout getHBComponent(Context context, final QueFormBean queFormBean) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout haemoglobinComponent = getLinearLayout(context, 10000, VERTICAL, layoutParams);

        String haemoglobin = null;

        if (queFormBean.getFormulas() != null && !queFormBean.getFormulas().isEmpty()) {
            for (FormulaTagBean formulaTagBean : queFormBean.getFormulas()) {
                if (formulaTagBean.getFormulavalue().contains("-")) {
                    //formulaName-haemoglobin
                    String[] split = formulaTagBean.getFormulavalue().split("-");
                    if (split[0].equalsIgnoreCase(FormulaConstants.FORMULA_SET_HAEMOGLOBIN) && split.length == 2) {
                        haemoglobin = SharedStructureData.relatedPropertyHashTable.get(split[1]);
                        if (haemoglobin != null) {
                            if (haemoglobin.contains(".")) {
                                haemoglobin = haemoglobin.split("\\.")[0];
                            }
                            queFormBean.setAnswer(haemoglobin);
                        }
                    }
                }
            }
        }

        MaterialTextView heightQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.HAEMOGLOBIN);
        final TextInputLayout heightAnswerText = MyStaticComponents.getEditText(context, LabelConstants.HAEMOGLOBIN, 10001, 4, -1);
        heightAnswerText.setPadding(0, -20, 0, 50);
        if (heightAnswerText.getEditText() != null) {
            heightAnswerText.getEditText().setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL);
            /*if (haemoglobin != null) {
                heightAnswerText.getEditText().setText(haemoglobin);
            }*/
        }

        MaterialTextView hbQuestionView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.CONDITION_HB);
        final MaterialTextView hbAnswerView = MyStaticComponents.generateAnswerView(context, LabelConstants.NOT_AVAILABLE);
        hbAnswerView.setPadding(0, 0, 0, 50);
        /*if (haemoglobin != null) {
            hbAnswerView.setText(checkValidationForHB(context, haemoglobin, hbAnswerView, queFormBean, MyDynamicComponents.class.getName()));
        }*/

        heightAnswerText.getEditText().addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                //add something
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                checkValidationForHB(context, s.toString(), hbAnswerView, queFormBean, getClass().getName());
            }

            @Override
            public void afterTextChanged(Editable s) {
                //add something
            }
        });

        haemoglobinComponent.addView(heightQuestionView);
        haemoglobinComponent.addView(heightAnswerText);
        haemoglobinComponent.addView(hbQuestionView);
        haemoglobinComponent.addView(hbAnswerView);
        return haemoglobinComponent;
    }

    public static LinearLayout getTWBComponent(Context context, final QueFormBean queFormBean) {
        int inputType = -1;
        List<ValidationTagBean> validations = queFormBean.getValidations();
        if (validations != null && !validations.isEmpty()) {
            for (ValidationTagBean validation : validations) {
                if (validation.getMethod().equalsIgnoreCase(FormulaConstants.NUMERIC) || validation.getMethod().equalsIgnoreCase(FormulaConstants.GREATER_THAN_0)) {
                    inputType = InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL;
                    break;
                } else if (validation.getMethod().equalsIgnoreCase(FormulaConstants.PERSON_NAME)) {
                    inputType = InputType.TYPE_TEXT_VARIATION_PERSON_NAME;
                    break;
                } else if (validation.getMethod().equalsIgnoreCase(FormulaConstants.ONLY_NUMBERS)) {
                    inputType = InputType.TYPE_CLASS_NUMBER;
                    break;
                } else if (validation.getMethod().equalsIgnoreCase(FormulaConstants.ALPHA_NUMERIC_WITH_CAPS)) {
                    inputType = InputType.TYPE_CLASS_TEXT;
                    break;
                }
            }
        }
        TextInputLayout editText = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), -1, queFormBean.getLength(), inputType);
        if (editText.getEditText() != null) {
            editText.getEditText().setOnFocusChangeListener(new TextFocusChangeListener(context, queFormBean));
        }
        String defaultValue;
        if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);
            if (defaultValue != null) {
                queFormBean.setAnswer(defaultValue);
                editText.getEditText().setText(defaultValue);
            }
        }

        MaterialTextView validationView = new MaterialTextView(context);
        validationView.setTextColor(Color.RED);
        validationView.setVisibility(View.GONE);
        LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (editText.getEditText() != null) {
            editText.getEditText().addTextChangedListener(new TextWatcher() {
                @Override
                public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

                }

                @Override
                public void onTextChanged(CharSequence s, int i, int i1, int i2) {
                    if (s != null) {
                        checkValidationsForTWB(s.toString(), validationView, queFormBean, DynamicUtils.checkValidation(s.toString(), queFormBean.getLoopCounter(), queFormBean.getValidations()) != null);
                    } else {
                        checkValidationsForTWB(null, validationView, queFormBean, DynamicUtils.checkValidation(null, queFormBean.getLoopCounter(), queFormBean.getValidations()) != null);
                    }
                }

                @Override
                public void afterTextChanged(Editable editable) {

                }
            });
        }
        linearLayout.addView(editText);
        linearLayout.addView(validationView);
        return linearLayout;
    }

    private static void checkValidationsForTWB(String ans, MaterialTextView validationView, QueFormBean queFormBean, boolean isVisible) {
        validationView.setVisibility(isVisible ? View.VISIBLE : View.GONE);
        validationView.setText(DynamicUtils.checkValidation(ans, queFormBean.getLoopCounter(), queFormBean.getValidations()));
    }

    public static void checkValidationForHB(Context context, String h, MaterialTextView hbAnswerView, QueFormBean queFormBean, String className) {
        String condition = "";
        if (h.isEmpty()) {
            hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
            hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.black));
            if (queFormBean != null) {
                queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_HB);
                queFormBean.setAnswer(null);
            }
        } else {
            try {
                float haemoglobin = Float.parseFloat(h);
                hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.textColor));
                condition = LabelConstants.NOT_AVAILABLE;

                if (haemoglobin < 3) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.ENTER_VALID_VALUE_HB));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.textColor));
                    condition = LabelConstants.NOT_AVAILABLE;
                    queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_VALUE_HB);
                    queFormBean.setAnswer(null);

                } else if (haemoglobin >= 3 && haemoglobin <= 7) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.HB_SEVERE));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.pregnantWomenTextColor));
                    condition = LabelConstants.HB_SEVERE;
                    queFormBean.setAnswer(haemoglobin);

                } else if (haemoglobin >= 7 && haemoglobin <= 9) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.HB_MODERATE));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.yellow));
                    condition = LabelConstants.HB_MODERATE;
                    queFormBean.setAnswer(haemoglobin);

                } else if (haemoglobin >= 9 && haemoglobin <= 11) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.HB_MILD));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.spinnerBorderSelected));
                    condition = LabelConstants.HB_MILD;
                    queFormBean.setAnswer(haemoglobin);

                } else if (haemoglobin >= 11 && haemoglobin <= 17) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NORMAL));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.rb_correct_text));
                    condition = LabelConstants.NORMAL;
                    queFormBean.setAnswer(haemoglobin);

                } else if (haemoglobin >= 17) {
                    hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.ENTER_VALID_VALUE_HB));
                    hbAnswerView.setTextColor(ContextCompat.getColorStateList(context, R.color.textColor));
                    condition = LabelConstants.NOT_AVAILABLE;
                    queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_VALUE_HB);
                    queFormBean.setAnswer(null);
                }
            } catch (Exception e) {
                hbAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                android.util.Log.e(className, null, e);
            }
        }
    }


    public static void checkValidationForBMI(String h, String w, MaterialTextView bmiAnswerView, QueFormBean queFormBean, String className, List<Integer> heightRange, List<Float> weightRange) {
        if (h.isEmpty()) {
            bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
            if (queFormBean != null) {
                queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_HEIGHT);
                queFormBean.setAnswer(null);
            }
        } else if (w.isEmpty()) {
            bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
            if (queFormBean != null) {
                queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_WEIGHT);
                queFormBean.setAnswer(null);
            }
        } else {
            try {
                int height = Integer.parseInt(h);
                float weight = Float.parseFloat(w);

                if (heightRange.size() == 2 && weightRange.size() == 2) {
                    if (height < heightRange.get(0) || height > heightRange.get(1)) {
                        bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                        queFormBean.setMandatorymessage("Please enter height between " + heightRange.get(0) + " and " + heightRange.get(1) + " cms.");
                        queFormBean.setAnswer(null);
                    } else if (weight < weightRange.get(0) || weight > weightRange.get(1)) {
                        bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                        queFormBean.setMandatorymessage("Please enter weight between " + weightRange.get(0) + " and " + weightRange.get(1) + " kgs.");
                        queFormBean.setAnswer(null);
                    } else {
                        String bmi = UtilBean.calculateBmi(height, weight);
                        if (bmi != null) {
                            setBmiTextColorAndText(bmiAnswerView, bmi);
                            queFormBean.setAnswer(String.format("%s/%s/%s", h, w, bmi));
                        } else {
                            bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                            queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_WEIGHT);
                            queFormBean.setAnswer(null);
                        }
                    }
                } else {
                    if (height < 60 || height > 250) {
                        bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                        queFormBean.setMandatorymessage(LabelConstants.HEIGHT_BETWEEN_60_TO_250);
                        queFormBean.setAnswer(null);
                    } else if (weight < 10 || weight > 150) {
                        bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                        queFormBean.setMandatorymessage(LabelConstants.WEIGHT_BETWEEN_10_TO_150);
                        queFormBean.setAnswer(null);
                    } else {
                        String bmi = UtilBean.calculateBmi(height, weight);
                        if (bmi != null) {
                            setBmiTextColorAndText(bmiAnswerView, bmi);
                            queFormBean.setAnswer(String.format("%s/%s/%s", h, w, bmi));
                        } else {
                            bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                            bmiAnswerView.setTextColor(ContextCompat.getColor(context, R.color.pregnantWomenTextColor));
                            queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_WEIGHT);
                            queFormBean.setAnswer(null);
                        }
                    }
                }
            } catch (Exception e) {
                bmiAnswerView.setText(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                queFormBean.setMandatorymessage(LabelConstants.ENTER_VALID_HEIGHT);
                queFormBean.setAnswer(null);
                Log.e(className, null, e);
            }
        }
    }

    public static LinearLayout getMotherChildRelationshipView(final Context context, final QueFormBean queFormBean) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout motherChildView = getLinearLayout(context, 10000, VERTICAL, layoutParams);

        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        Set<String> membersUnderTwenty = sharedPreferences.getStringSet(RelatedPropertyNameConstants.LOOP_COUNTER_FOR_ALIVE_MEMBERS, null);
        Set<String> femaleMarriedMembers = sharedPreferences.getStringSet(RelatedPropertyNameConstants.LOOP_COUNTER_FOR_FEMALE_MARRIED_MEMBERS, null);

        queFormBean.setAnswer(null);

        if (membersUnderTwenty != null && !membersUnderTwenty.isEmpty()
                && femaleMarriedMembers != null && !femaleMarriedMembers.isEmpty()) {

            String counter;
            String motherCounter;
            final Map<Integer, List<OptionTagBean>> motherOptionListMap = new HashMap<>();
            for (String loopCounter : membersUnderTwenty) {
                counter = loopCounter;
                if (counter.equals("0")) {
                    counter = "";
                }

                String dob = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.DOB + counter);

                if (dob != null) {
                    Calendar calendar = Calendar.getInstance();
                    calendar.setTimeInMillis(Long.parseLong(dob));
                    calendar.add(Calendar.YEAR, -12);
                    calendar.set(Calendar.HOUR_OF_DAY, 0);
                    calendar.set(Calendar.MINUTE, 0);
                    calendar.set(Calendar.SECOND, 0);
                    calendar.set(Calendar.MILLISECOND, 0);
                    long dateBefore12years = calendar.getTime().getTime();

                    List<String> stringOptions = new ArrayList<>();
                    List<OptionTagBean> motherOptions = new ArrayList<>();
                    stringOptions.add(UtilBean.getMyLabel(GlobalTypes.SELECT));
                    OptionTagBean select = new OptionTagBean();
                    select.setKey("-2");
                    select.setValue(UtilBean.getMyLabel(GlobalTypes.SELECT));
                    motherOptions.add(select);

                    for (String motherLoopCounter : femaleMarriedMembers) {
                        if (loopCounter.equals(motherLoopCounter)) {
                            continue;
                        }

                        motherCounter = motherLoopCounter;
                        if (motherLoopCounter.equals("0")) {
                            motherCounter = "";
                        }

                        dob = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.DOB + motherCounter);
                        if (dob != null) {
                            calendar.setTimeInMillis(Long.parseLong(dob));
                            calendar.set(Calendar.HOUR_OF_DAY, 0);
                            calendar.set(Calendar.MINUTE, 0);
                            calendar.set(Calendar.SECOND, 0);
                            calendar.set(Calendar.MILLISECOND, 0);
                            if (calendar.getTimeInMillis() <= dateBefore12years) {
                                String motherName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME + motherCounter)
                                        + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME + motherCounter);

                                OptionTagBean option = new OptionTagBean();
                                option.setKey(motherLoopCounter);
                                option.setValue(motherName);
                                motherOptions.add(option);
                                stringOptions.add(UtilBean.getMyLabel(motherName));
                            }
                        }
                    }

                    if (motherOptions.size() == 1) {
                        continue;
                    }

                    stringOptions.add(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                    OptionTagBean option1 = new OptionTagBean();
                    option1.setKey("-1");
                    option1.setValue(UtilBean.getMyLabel(LabelConstants.NOT_AVAILABLE));
                    motherOptions.add(option1);
                    queFormBean.setOptions(motherOptions);
                    motherOptionListMap.put(Integer.valueOf(loopCounter), motherOptions);

                    String childName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME + counter)
                            + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME + counter);
                    motherChildView.addView(MyStaticComponents.generateInstructionView(context, childName));

                    final Spinner motherSpinner = getSpinner(context, queFormBean, Integer.parseInt(loopCounter));
                    motherSpinner.setAdapter(createAdapter(stringOptions));
                    motherChildView.addView(motherSpinner);
                    motherSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                        @Override
                        public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

                            List<OptionTagBean> options = motherOptionListMap.get(motherSpinner.getId());
                            OptionTagBean selectedOption = Objects.requireNonNull(options).get(position);
                            String selectedOptionKey = selectedOption.getKey();

                            String answer = (String) queFormBean.getAnswer();
                            Map<String, String> answerMap = new HashMap<>();
                            Type type = new TypeToken<HashMap<String, String>>() {
                            }.getType();
                            Gson gson = new Gson();
                            if (!selectedOptionKey.equals("-2")) {
                                if (answer != null) {
                                    answerMap = gson.fromJson(answer, type);
                                }
                                answerMap.put(String.valueOf(motherSpinner.getId()), selectedOptionKey);
                            } else {
                                if (answer != null) {
                                    answerMap = gson.fromJson(answer, type);
                                    answerMap.remove(String.valueOf(motherSpinner.getId()));
                                }
                            }

                            if (!answerMap.isEmpty()) {
                                queFormBean.setAnswer(gson.toJson(answerMap));
                            } else {
                                queFormBean.setAnswer(null);
                            }

                            if (String.valueOf(motherSpinner.getId()).equals(selectedOptionKey)) {
                                SewaUtil.generateToast(context, UtilBean.getMyLabel(LabelConstants.SELECT_DIFFERENT_MOTHER_FOR_CHILD));
                            }
                        }

                        @Override
                        public void onNothingSelected(AdapterView<?> parent) {
                            //add something
                        }
                    });
                }
            }


            if (motherOptionListMap.isEmpty()) {
                motherChildView.addView(MyStaticComponents.generateInstructionView(context, LabelConstants.NO_CHILD_PRESENT));
            }
            SharedStructureData.relatedPropertyHashTable.put("numberOfMemberForMotherSelection", motherOptionListMap.size() + "");
        } else {
            motherChildView.addView(MyStaticComponents.generateInstructionView(context, LabelConstants.NO_CHILD_PRESENT));
        }
        return motherChildView;
    }

    public static LinearLayout getHusbandWifeRelationshipView(final Context context, final QueFormBean queFormBean) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout marriedMemberView = getLinearLayout(context, 10000, VERTICAL, layoutParams);

        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        Set<String> maleMarriedMembers = sharedPreferences.getStringSet(RelatedPropertyNameConstants.LOOP_COUNTER_FOR_MALE_MARRIED_MEMBERS, null);
        Set<String> femaleMarriedMembers = sharedPreferences.getStringSet(RelatedPropertyNameConstants.LOOP_COUNTER_FOR_WIFE_MEMBERS, null);
        if (femaleMarriedMembers != null && !femaleMarriedMembers.isEmpty()) {
            Map<String, String> husbands = new HashMap<>();
            if (maleMarriedMembers != null && !maleMarriedMembers.isEmpty()) {
                for (String loopCounter : maleMarriedMembers) {
                    String husbandName;
                    if (loopCounter.equals("0")) {
                        husbandName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME)
                                + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME);
                    } else {
                        husbandName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME + loopCounter)
                                + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME + loopCounter);
                    }
                    husbands.put(loopCounter, husbandName);
                }
            }

            List<String> stringOptions = new ArrayList<>();
            List<OptionTagBean> husbandOptions = new ArrayList<>();
            stringOptions.add(UtilBean.getMyLabel(GlobalTypes.SELECT));
            OptionTagBean select = new OptionTagBean();
            select.setKey("-2");
            select.setValue(UtilBean.getMyLabel(GlobalTypes.SELECT));
            husbandOptions.add(select);
            if (!husbands.isEmpty()) {
                for (Map.Entry<String, String> entry : husbands.entrySet()) {
                    OptionTagBean option = new OptionTagBean();
                    option.setKey("" + entry.getKey());
                    option.setValue("" + entry.getValue());
                    husbandOptions.add(option);
                    stringOptions.add(UtilBean.getMyLabel("" + entry.getValue()));
                }
            }
            stringOptions.add(UtilBean.getMyLabel(GlobalTypes.NOT_AVAILABLE));
            OptionTagBean option1 = new OptionTagBean();
            option1.setKey("-1");
            option1.setValue(UtilBean.getMyLabel(GlobalTypes.NOT_AVAILABLE));
            husbandOptions.add(option1);
            queFormBean.setOptions(husbandOptions);

            for (String loopCounter : femaleMarriedMembers) {
                String wifeName;
                if (loopCounter.equals("0")) {
                    wifeName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME)
                            + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME);
                } else {
                    wifeName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME + loopCounter)
                            + " " + SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME + loopCounter);
                }
                marriedMemberView.addView(MyStaticComponents.generateInstructionView(context, wifeName));

                final Spinner husbandSpinner = getSpinner(context, queFormBean, Integer.parseInt(loopCounter));
                husbandSpinner.setAdapter(createAdapter(stringOptions));
                marriedMemberView.addView(husbandSpinner);
                husbandSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
                    @Override
                    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {

                        List<OptionTagBean> options = queFormBean.getOptions();
                        OptionTagBean selectedOption = options.get(position);
                        String selectedOptionKey = selectedOption.getKey();

                        String answer = (String) queFormBean.getAnswer();
                        Map<String, String> answerMap;

                        if (answer != null && !answer.isEmpty()) {
                            answerMap = new Gson().fromJson(answer, new TypeToken<HashMap<String, String>>() {
                            }.getType());
                        } else {
                            answerMap = new HashMap<>();
                        }

                        if (!selectedOptionKey.equals("-2")) {
                            answerMap.put(String.valueOf(husbandSpinner.getId()), selectedOptionKey);
                        } else {
                            answerMap.remove(String.valueOf(husbandSpinner.getId()));
                        }

                        if (!answerMap.isEmpty()) {
                            queFormBean.setAnswer(new Gson().toJson(answerMap));
                        } else {
                            queFormBean.setAnswer(null);
                        }
                    }

                    @Override
                    public void onNothingSelected(AdapterView<?> parent) {
                        //Do Nothing
                    }
                });
            }

            if (queFormBean.getAnswer() != null) {
                String answer = (String) queFormBean.getAnswer();
                Map<String, String> answerMap;
                Type type = new TypeToken<HashMap<String, String>>() {
                }.getType();
                Gson gson = new Gson();
                answerMap = gson.fromJson(answer, type);
                if (answerMap != null && !answerMap.isEmpty()) {
                    for (Map.Entry<String, String> entry : answerMap.entrySet()) {
                        String key = entry.getKey();
                        String value = entry.getValue();
                        Spinner spinner = marriedMemberView.findViewById(Integer.parseInt(key));
                        List<OptionTagBean> options = queFormBean.getOptions();
                        OptionTagBean optionTagBean = new OptionTagBean();
                        optionTagBean.setKey(value);
                        int index = options.indexOf(optionTagBean);
                        spinner.setSelection(index);
                    }
                }
            }

        } else {
            marriedMemberView.addView(MyStaticComponents.generateInstructionView(context, LabelConstants.NO_FEMALE_MARRIED_MEMBERS_PRESENT));
        }
        return marriedMemberView;
    }

    public static LinearLayout getImmunisationGivenComponent(Context context, QueFormBean queFormBean) {
        TableLayout tableLayout = new TableLayout(context);
        tableLayout.setPadding(10, 10, 10, 10);
        tableLayout.setLayoutParams(new TableLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        TableRow.LayoutParams layoutParamsForRow = new TableRow.LayoutParams(MATCH_PARENT);
        TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(0, WRAP_CONTENT, 1);
        TableRow.LayoutParams layoutParams2 = new TableRow.LayoutParams(WRAP_CONTENT, WRAP_CONTENT);

        int i = 0;
        TableRow row = new TableRow(context);
        row.setPadding(10, 15, 10, 15);
        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            row.setBackgroundResource(R.drawable.table_row_selector);
        } else {
            row.setBackgroundResource(R.drawable.spinner_item_border);
        }
        row.setLayoutParams(layoutParamsForRow);

        MaterialTextView immunisations = new MaterialTextView(context);
        immunisations.setGravity(Gravity.CENTER_VERTICAL);
        immunisations.setPadding(20, 10, 20, 10);
        immunisations.setText(UtilBean.getMyLabel("Immunisation"));
        immunisations.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(immunisations, layoutParams);

        MaterialTextView dueDate = new MaterialTextView(context);
        dueDate.setGravity(Gravity.CENTER_VERTICAL);
        dueDate.setPadding(20, 10, 20, 10);
        dueDate.setText(UtilBean.getMyLabel("Date"));
        dueDate.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(dueDate, layoutParams2);

        tableLayout.addView(row, i);
        i++;

        Map<String, String> immunisationsMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
        String memberId = SharedStructureData.relatedPropertyHashTable.get(queFormBean.getRelatedpropertyname());


        if (memberId != null) {

            MemberBean memberBean;
            memberBean = SharedStructureData.sewaFhsService.retrieveMemberBeanByActualId(Long.parseLong(memberId));

            if (memberBean != null) {
                Set<String> dueImmunisationsForChild;
                if (GlobalTypes.FLAVOUR_DNHDD.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                    dueImmunisationsForChild = SharedStructureData.immunisationService.getDueImmunisationsForChildDnhdd(memberBean.getDob(), memberBean.getImmunisationGiven(), new Date(), null, false);
                } else {
                    dueImmunisationsForChild = SharedStructureData.immunisationService.getDueImmunisationsForChild(memberBean.getDob(), memberBean.getImmunisationGiven(), new Date(), null, false);
                }
                if (memberBean.getImmunisationGiven() != null) {
                    String[] immunisationAndDate = memberBean.getImmunisationGiven().split(",");
                    int counterVitaminA = 1;
                    String givenVitaminAVaccineName;
                    for (String date : immunisationAndDate) {
                        String[] split = date.split("#");
                        if (split[0].equals(RchConstants.VITAMIN_A)) {
                            givenVitaminAVaccineName = split[0].concat("_").concat(String.valueOf(counterVitaminA));
                            if (!immunisationsMap.containsKey(givenVitaminAVaccineName))
                                immunisationsMap.put(split[0].concat("_").concat(String.valueOf(counterVitaminA)), split[1]);
                            counterVitaminA++;
                        } else
                            immunisationsMap.put(split[0], split[1]);
                    }
                }

                if (dueImmunisationsForChild != null && !dueImmunisationsForChild.isEmpty()) {
                    for (String str : dueImmunisationsForChild) {
                        Map<Boolean, String> immunisationMissedMap;
                        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValidZambia(memberBean.getDob(), str, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
                        } else {
                            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValid(memberBean.getDob(), str, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
                        }
                        for (Map.Entry<Boolean, String> entry : immunisationMissedMap.entrySet()) {
                            Boolean isMissed = entry.getKey();
                            String dateRange = entry.getValue();
                            try {
                                if (dateRange != null) {
                                    String[] date = dateRange.split("-");
                                    if (!sdf.parse(date[0]).after(new Date())) {
                                        if (isMissed.equals(true) && sdf.parse(date[0]).before(new Date())) {
                                            immunisationsMap.put(str, LabelConstants.MISSED + "," + dateRange);
                                        } else {
                                            immunisationsMap.put(str, LabelConstants.DUE_NOW + "," + dateRange);
                                        }
                                    }
                                }
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }

                    }
                }
            }
        }

        if (!immunisationsMap.isEmpty()) {
            List<String> vaccineList = new ArrayList<>(immunisationsMap.keySet());
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                Collections.sort(vaccineList, UtilBean.Z_VACCINATION_COMPARATOR);
            } else {
                Collections.sort(vaccineList, UtilBean.VACCINATION_COMPARATOR);
            }

            for (String vaccine : vaccineList) {
                row = new TableRow(context);
                if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
                    row.setBackgroundResource(R.drawable.table_row_selector);
                } else {
                    row.setBackgroundResource(R.drawable.spinner_item_border);
                }
                row.setLayoutParams(layoutParamsForRow);

                immunisations = new MaterialTextView(context);
                immunisations.setPadding(10, 10, 10, 10);
                immunisations.setGravity(Gravity.CENTER_VERTICAL);
                immunisations.setText(UtilBean.getMyLabel(FullFormConstants.getFullFormOfVaccines(vaccine)));

                dueDate = new MaterialTextView(context);
                dueDate.setPadding(10, 10, 2, 10);
                dueDate.setTextSize(12);
                dueDate.setGravity(Gravity.CENTER_VERTICAL);
                if (immunisationsMap.get(vaccine).contains(",")) {
                    dueDate.setText(UtilBean.getMyLabel(immunisationsMap.get(vaccine).split(",")[1]));
                    if (LabelConstants.DUE_NOW.equalsIgnoreCase(immunisationsMap.get(vaccine).split(",")[0])) {
                        dueDate.setTextColor(Color.GREEN);
                    } else if (LabelConstants.MISSED.equalsIgnoreCase(immunisationsMap.get(vaccine).split(",")[0])) {
                        dueDate.setTextColor(Color.RED);
                    }
                } else {
                    dueDate.setText(UtilBean.getMyLabel(immunisationsMap.get(vaccine)));
                }

                if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
                    immunisations.setBackgroundResource(R.drawable.table_row_selector);
                    dueDate.setBackgroundResource(R.drawable.table_row_selector);
                } else {
                    immunisations.setBackgroundResource(R.drawable.spinner_item_border);
                    dueDate.setBackgroundResource(R.drawable.spinner_item_border);
                }

                row.addView(immunisations, layoutParams);
                row.addView(dueDate, layoutParams2);
                tableLayout.addView(row, i);
                i++;
            }
        }
        MaterialTextView textView = new MaterialTextView(context);
        textView.setText(LabelConstants.VACCINE_NOTE);
        textView.setTextSize(10);
        textView.setPadding(10, 10, 10, 10);
        textView.setGravity(Gravity.CENTER_VERTICAL);

        LinearLayout linearLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        linearLayout.setPadding(10, 10, 10, 10);
        linearLayout.addView(tableLayout);
        linearLayout.addView(textView);

        return linearLayout;
    }

    public static LinearLayout getImmunisationGivenComponentZambia(Context context, QueFormBean queFormBean) {
        TableLayout tableLayout = new TableLayout(context);
        tableLayout.setPadding(10, 10, 10, 10);
        tableLayout.setLayoutParams(new TableLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        TableRow.LayoutParams layoutParamsForRow = new TableRow.LayoutParams(MATCH_PARENT);
        TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(0, WRAP_CONTENT, 1);
        Date lbw = UtilBean.clearTimeFromDate(new Date());
        Date ubw = UtilBean.clearTimeFromDate(new Date());
        Date tmpDate;
        Calendar dob = Calendar.getInstance();
        Calendar temp = Calendar.getInstance();

        int i = 0;
        TableRow row = new TableRow(context);
        row.setPadding(10, 15, 10, 15);
        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            row.setBackgroundResource(R.drawable.table_row_selector);
        } else {
            row.setBackgroundResource(R.drawable.spinner_item_border);
        }
        row.setLayoutParams(layoutParamsForRow);

        MaterialTextView immunisations = new MaterialTextView(context);
        immunisations.setGravity(Gravity.CENTER_VERTICAL);
        immunisations.setPadding(20, 10, 20, 10);
        immunisations.setText(UtilBean.getMyLabel("Vaccine"));
        immunisations.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(immunisations, layoutParams);
        Map<String, Date> vaccineGivenDateMap = SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter());


        MaterialTextView dueDate = new MaterialTextView(context);
        dueDate.setGravity(Gravity.CENTER_VERTICAL);
        dueDate.setPadding(20, 10, 20, 10);
        dueDate.setText(UtilBean.getMyLabel("Date Range"));
        dueDate.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(dueDate, layoutParams);
        //StringBuilder sb = new StringBuilder();

        tableLayout.addView(row, i);
        i++;
        MaterialTextView givenDate = new MaterialTextView(context);
        givenDate.setGravity(Gravity.CENTER_VERTICAL);
        givenDate.setPadding(20, 10, 20, 10);
        givenDate.setText(UtilBean.getMyLabel("Given Date"));
        givenDate.setTypeface(Typeface.DEFAULT_BOLD);
        row.addView(givenDate, layoutParams);
        Map<String, String> immunisationsMap = new HashMap<>();
        Map<String, String> immunisationsAndDateMap = new HashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
        String memberId = SharedStructureData.relatedPropertyHashTable.get(queFormBean.getRelatedpropertyname());
        String memberUuid = null;
        if (memberId == null) {
            memberUuid = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_UUID);
        }

        if (memberId != null || memberUuid != null) {
            MemberBean memberBean = null;
            if (memberId != null) {
                memberBean = SharedStructureData.sewaFhsService.retrieveMemberBeanByActualId(Long.parseLong(memberId));
            }
            if (memberUuid != null) {
                memberBean = SharedStructureData.sewaFhsService.retrieveMemberBeanByUUID(memberUuid);
            }
            if (memberBean != null) {
                Date dateOfBirth = memberBean.getDob();
                dateOfBirth = UtilBean.clearTimeFromDate(dateOfBirth);
                dob.setTime(dateOfBirth);
                temp.setTime(dateOfBirth);
                Set<String> dueImmunisationsForChild = SharedStructureData.immunisationService.getDueImmunisationsForChildZambia(memberBean.getDob(), memberBean.getImmunisationGiven(), new Date(), null, false);
                if (memberBean.getImmunisationGiven() != null) {
                    String[] immunisationAndDate = memberBean.getImmunisationGiven().split(",");
                    for (String date : immunisationAndDate) {
                        String[] split = date.split("#");
                        immunisationsAndDateMap.put(split[0], split[1]);

                        switch (split[0]) {
                            case RchConstants.HEPATITIS_B_0:
                            case RchConstants.VITAMIN_K:
                                lbw = dob.getTime();
                                dob.add(Calendar.DATE, 1);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_BCG:
                                lbw = dob.getTime();
                                dob.add(Calendar.YEAR, 1);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_50000:
                                lbw = dob.getTime();
                                dob.add(Calendar.MONTH, 5);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_100000:
                                dob.add(Calendar.MONTH, 6);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 11);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_1:
                                dob.add(Calendar.MONTH, 12);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 18);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_2:
                                dob.add(Calendar.MONTH, 18);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 24);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_3:
                                dob.add(Calendar.MONTH, 24);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 30);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_4:
                                dob.add(Calendar.MONTH, 30);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 36);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_5:
                                dob.add(Calendar.MONTH, 36);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 42);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_6:
                                dob.add(Calendar.MONTH, 42);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 48);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_7:
                                dob.add(Calendar.MONTH, 48);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 54);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_VITTAMIN_A_200000_8:
                                dob.add(Calendar.MONTH, 54);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                dob.add(Calendar.MONTH, 59);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;
                            case RchConstants.Z_OPV_0:
                                lbw = dob.getTime();
                                dob.add(Calendar.DATE, 13);
                                ubw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_OPV_1:
                            case RchConstants.Z_ROTA_VACCINE_1:
                            case RchConstants.Z_PCV_1:
                            case RchConstants.Z_DPT_HEB_HIB_1:
                                dob.add(Calendar.DATE, 42);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_OPV_2:
                                dob.add(Calendar.DATE, 70);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_OPV_3:
                                dob.add(Calendar.DATE, 98);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.OPV_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 56);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_OPV_2);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_ROTA_VACCINE_2:
                                dob.add(Calendar.DATE, 70);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_ROTA_VACCINE_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_PCV_2:
                                dob.add(Calendar.DATE, 70);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_PCV_3:
                                dob.add(Calendar.DATE, 98);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 56);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_PCV_2);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_DPT_HEB_HIB_2:
                                dob.add(Calendar.DATE, 70);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_DPT_HEB_HIB_3:
                                dob.add(Calendar.DATE, 98);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 56);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                tmpDate = vaccineGivenDateMap.get(RchConstants.Z_DPT_HEB_HIB_2);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_MEASLES_RUBELLA_1:
                                dob.add(Calendar.MONTH, 9);
                                lbw = dob.getTime();
                                dob.setTime(dateOfBirth);
                                break;

                            case RchConstants.Z_MEASLES_RUBELLA_2:
                                dob.add(Calendar.MONTH, 18);
                                lbw = dob.getTime();
                                tmpDate = vaccineGivenDateMap.get(RchConstants.MEASLES_RUBELLA_1);
                                if (tmpDate != null) {
                                    temp.setTime(tmpDate);
                                    temp.add(Calendar.DATE, 28);
                                    if (temp.getTimeInMillis() > dob.getTimeInMillis()) {
                                        lbw = temp.getTime();
                                    }
                                }
                                dob.setTime(dateOfBirth);
                                break;
                            default:
                        }

                        if (split[0].equalsIgnoreCase(RchConstants.Z_BCG) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_OPV_0) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_50000) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_100000) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_1) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_2) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_3) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_4) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_5) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_6) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_7) ||
                                split[0].equalsIgnoreCase(RchConstants.Z_VITTAMIN_A_200000_8)
                        ) {
                            immunisationsMap.put(split[0], sdf.format(lbw) + " - " + sdf.format(ubw));
                        } else {
                            immunisationsMap.put(split[0], "After " + sdf.format(lbw));
                        }
                    }
                }

                if (dueImmunisationsForChild != null && !dueImmunisationsForChild.isEmpty()) {
                    for (String str : dueImmunisationsForChild) {
                        Map<Boolean, String> immunisationMissedMap;
                        if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValidZambia(memberBean.getDob(), str, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
                        } else {
                            immunisationMissedMap = SharedStructureData.immunisationService.isImmunisationMissedOrNotValid(memberBean.getDob(), str, new Date(), SharedStructureData.getVaccineGivenDateMap(queFormBean.getLoopCounter()), true);
                        }

                        for (Map.Entry<Boolean, String> entry : immunisationMissedMap.entrySet()) {
                            Boolean isMissed = entry.getKey();
                            String dateRange = entry.getValue();
                            try {
                                if (dateRange != null && !dateRange.contains("After")) {
                                    String[] date = dateRange.split("-");
                                    if (!Objects.requireNonNull(sdf.parse(date[0])).after(new Date())) {
                                        if (isMissed.equals(true) && Objects.requireNonNull(sdf.parse(date[0])).before(new Date())) {
                                            immunisationsMap.put(str, LabelConstants.MISSED + "," + dateRange);
                                        } else {
                                            immunisationsMap.put(str, LabelConstants.DUE_NOW + "," + dateRange);
                                        }
                                    }
                                } else {
                                    if (dateRange != null) {
                                        String[] date = dateRange.split(" ");
                                        if (!Objects.requireNonNull(Objects.requireNonNull(Objects.requireNonNull(sdf.parse(date[1])))).after(new Date())) {
                                            if (isMissed.equals(true) && Objects.requireNonNull(sdf.parse(date[1])).before(new Date())) {
                                                immunisationsMap.put(str, LabelConstants.MISSED + "," + dateRange);
                                            } else {
                                                immunisationsMap.put(str, LabelConstants.DUE_NOW + "," + dateRange);
                                            }
                                        }
                                    }
                                }
                            } catch (ParseException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                }
            }
        }

        if (!immunisationsMap.isEmpty()) {
            List<String> vaccineList = new ArrayList<>(immunisationsMap.keySet());
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                Collections.sort(vaccineList, UtilBean.Z_VACCINATION_COMPARATOR);
            } else {
                Collections.sort(vaccineList, UtilBean.VACCINATION_COMPARATOR);
            }

            for (String vaccine : vaccineList) {
                row = new TableRow(context);
                if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
                    row.setBackgroundResource(R.drawable.table_row_selector);
                } else {
                    row.setBackgroundResource(R.drawable.spinner_item_border);
                }
                row.setLayoutParams(layoutParamsForRow);

                immunisations = new MaterialTextView(context);
                immunisations.setPadding(10, 10, 10, 10);
                immunisations.setGravity(Gravity.CENTER_VERTICAL);
                immunisations.setText(UtilBean.getMyLabel(FullFormConstants.getFullFormOfVaccines(vaccine)));

                dueDate = new MaterialTextView(context);
                dueDate.setPadding(10, 10, 2, 10);
                dueDate.setTextSize(12);
                dueDate.setGravity(Gravity.CENTER_VERTICAL);

                givenDate = new MaterialTextView(context);
                givenDate.setPadding(10, 10, 2, 10);
                givenDate.setTextSize(12);
                givenDate.setGravity(Gravity.CENTER_VERTICAL);

                Date date1;
                Date today = new Date();

                if (Objects.requireNonNull(immunisationsMap.get(vaccine)).contains(",")) {
                    dueDate.setText(UtilBean.getMyLabel(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[1]));
                    if (UtilBean.getMyLabel(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[1]).contains("-")
                            || UtilBean.getMyLabel(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[1]).contains("After")) {
                        givenDate.setText(UtilBean.getMyLabel("N/A"));
                    }
                    if (Objects.requireNonNull(Objects.requireNonNull(immunisationsMap.get(vaccine))).split(",")[1].contains("-")) {
                        String[] date = Objects.requireNonNull(Objects.requireNonNull(immunisationsMap.get(vaccine))).split(",")[1].split("-");
                        try {
                            date1 = sdf.parse(date[0]);
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        if (today.before(date1))
                            dueDate.setTextColor(Color.BLACK);
                        else if (LabelConstants.DUE_NOW.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
                            dueDate.setTextColor(Color.BLUE);
                        } else if (LabelConstants.MISSED.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
                            dueDate.setTextColor(Color.RED);
                        }
                    } else if (Objects.requireNonNull(Objects.requireNonNull(immunisationsMap.get(vaccine))).split(",")[1].contains("After")) {
                        String[] date = Objects.requireNonNull(Objects.requireNonNull(immunisationsMap.get(vaccine))).split(",")[1].split(" ");
                        try {
                            date1 = sdf.parse(date[1]);
                        } catch (ParseException e) {
                            throw new RuntimeException(e);
                        }
                        if (today.before(date1))
                            dueDate.setTextColor(Color.BLACK);
                        else if (LabelConstants.DUE_NOW.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
                            dueDate.setTextColor(Color.BLUE);
                        } else if (LabelConstants.MISSED.equalsIgnoreCase(Objects.requireNonNull(immunisationsMap.get(vaccine)).split(",")[0])) {
                            dueDate.setTextColor(Color.RED);
                        }
                    }
                } else {
                    dueDate.setText(UtilBean.getMyLabel(immunisationsMap.get(vaccine)));
                    givenDate.setTextColor(ContextCompat.getColor(context, R.color.hofTextColor));
                    givenDate.setText(UtilBean.getMyLabel(immunisationsAndDateMap.get(vaccine)));
                }


                if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
                    immunisations.setBackgroundResource(R.drawable.table_row_selector);
                } else {
                    //immunisations.setBackgroundResource(R.drawable.spinner_item_border);
                }

                row.addView(immunisations, layoutParams);
                row.addView(dueDate, layoutParams);
                row.addView(givenDate, layoutParams);
                tableLayout.addView(row, i);
                i++;
            }
        }

        MaterialTextView textView = new MaterialTextView(context);
        textView.setText(LabelConstants.VACCINE_NOTE);
        textView.setTextSize(10);
        textView.setPadding(10, 10, 10, 10);
        textView.setGravity(Gravity.CENTER_VERTICAL);

        LinearLayout linearLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        linearLayout.setPadding(10, 10, 10, 10);
        linearLayout.addView(tableLayout);
        linearLayout.addView(textView);

        return linearLayout;
    }

    public static LinearLayout getWeightBox(Context context, QueFormBean queFormBean, int id, boolean isCombo, boolean isShowDate, String checkBoxLabel) {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }

        WeightBoxChangeListener myListener = new WeightBoxChangeListener(context, queFormBean, isShowDate);

        CheckBox myCheBox = MyStaticComponents.getCheckBox(context,
                (checkBoxLabel != null ? checkBoxLabel : LabelConstants.WEIGHING_SCALE_NOT_AVAILABLE),
                IdConstants.WEIGHT_BOX_CHECKBOX_ID,
                false);
        myCheBox.setOnCheckedChangeListener(myListener);

        if (!BuildConfig.FLAVOR.equalsIgnoreCase(GlobalTypes.FLAVOUR_DNHDD)) {
            mainLayout.addView(myCheBox);
        }

        LinearLayout inputLayout;

        inputLayout = getLinearLayout(context,
                IdConstants.WEIGHT_BOX_INPUT_LAYOUT_ID,
                HORIZONTAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 2));

        // kilogram   Kgs' and 'Grams'
        LinearLayout linearLayout = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 1));
        if (isCombo) {
            Spinner myKilo = MyStaticComponents.getSpinner(context, GlobalTypes.KILO_LIST.toArray(new String[0]), 0, IdConstants.WEIGHT_BOX_SPINNER_KILO_ID);
            myKilo.setOnItemSelectedListener(myListener);
            linearLayout.addView(myKilo, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 10));
        } else {
            TextInputLayout textKilogram = MyStaticComponents.getEditText(context,
                    UtilBean.getMyLabel(LabelConstants.IN_KG),
                    IdConstants.WEIGHT_BOX_SPINNER_KILO_ID,
                    3,
                    InputType.TYPE_CLASS_NUMBER);
            textKilogram.setOnFocusChangeListener(myListener);
            linearLayout.addView(textKilogram, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 10));
        }
        // Label for kilo
        MaterialTextView textView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_MASS_IN_KG, -1, R.style.CustomAnswerView, false);
//        linearLayout.addView(textView, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 2));
        linearLayout.setPadding(0, 0, 20, 0);
        inputLayout.addView(linearLayout);

        // Gram selection
        linearLayout = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 1));
        Spinner myGram = MyStaticComponents.getSpinner(context, GlobalTypes.GRAM_LIST.toArray(new String[0]), 0, IdConstants.WEIGHT_BOX_SPINNER_GRAM_ID);
        myGram.setOnItemSelectedListener(myListener);
        linearLayout.addView(myGram, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 10));
        // Label for Gram
        textView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_MASS_IN_GRAM, -1, R.style.CustomAnswerView, false);
//        linearLayout.addView(textView, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 2));
        linearLayout.setPadding(20, 0, 0, 50);
        inputLayout.addView(linearLayout);

        //date component if it is required
        if (isShowDate) {
            inputLayout.addView(MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.DATE_OF_WEIGHT + ":"));
            inputLayout.addView(MyStaticComponents.getCustomDatePickerForStatic(context, myListener, -1));
        }

        mainLayout.addView(inputLayout);

        return mainLayout;
    }

    public static LinearLayout getHeightBox(Context context, QueFormBean queFormBean, int id) {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }

        LinearLayout inputLayout;
        HeightBoxChangeListener myListener = new HeightBoxChangeListener(context, queFormBean, false);

        inputLayout = getLinearLayout(context,
                IdConstants.HIGHT_BOX_INPUT_LAYOUT_ID,
                HORIZONTAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 2));

        LinearLayout linearLayout = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 1));

        //spinner for feet
        Spinner feets = MyStaticComponents.getSpinner(context, GlobalTypes.FEET_LIST.toArray(new String[0]), 0, IdConstants.HEIGHT_BOX_SPINNER_FEET_ID);
        feets.setOnItemSelectedListener(myListener);
        linearLayout.addView(feets, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 10));
        linearLayout.setPadding(0, 0, 20, 0);
        inputLayout.addView(linearLayout);

        // spinner for inches
        linearLayout = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 1));
        Spinner inches = MyStaticComponents.getSpinner(context, GlobalTypes.INCH_LIST.toArray(new String[0]), 0, IdConstants.HEIGHT_BOX_SPINNER_INCH_ID);
        inches.setOnItemSelectedListener(myListener);
        linearLayout.addView(inches, new LinearLayout.LayoutParams(0, WRAP_CONTENT, 10));
        linearLayout.setPadding(20, 0, 0, 50);
        inputLayout.addView(linearLayout);

        mainLayout.addView(inputLayout);

        return mainLayout;
    }

    public static LinearLayout getTemperatureBox(Context context, QueFormBean queFormBean, int id) {

        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }

        TemperatureBoxListener myListener = new TemperatureBoxListener(queFormBean);

        CheckBox myCheBox = MyStaticComponents.getCheckBox(context, LabelConstants.THERMOMETER_NOT_AVAILABLE, IdConstants.TEMPERATURE_BOX_CHECKBOX_ID, false);
        myCheBox.setOnCheckedChangeListener(myListener);

        mainLayout.addView(myCheBox);

        LinearLayout inputLayout = getLinearLayout(context, IdConstants.TEMPERATURE_BOX_INPUT_LAYOUT_ID, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.TEMPERATURE_IN_FAHRENHEIT, -1, R.style.CustomAnswerView, false));
        Spinner myDegree = MyStaticComponents.getSpinner(context, GlobalTypes.TEMPERATURE_DEGREE_VALUES.toArray(new String[0]), 0, IdConstants.TEMPERATURE_BOX_SPINNER_DEGREE_ID);
        myDegree.setOnItemSelectedListener(myListener);
        inputLayout.addView(myDegree);

        inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.REMAIN_FLOATING_VALUE, -1, R.style.CustomAnswerView, false));
        Spinner myFloat = MyStaticComponents.getSpinner(context, GlobalTypes.TEMPERATURE_FLOATING_VALUES.toArray(new String[0]), 0, IdConstants.TEMPERATURE_BOX_SPINNER_FLOATING_ID);
        myFloat.setOnItemSelectedListener(myListener);
        inputLayout.addView(myFloat);

        mainLayout.addView(inputLayout);

        return mainLayout;
    }

    public static LinearLayout getBloodPressureBox(Context context, QueFormBean queFormBean, int id) {
        QueFormBean nextQuestion = SharedStructureData.mapIndexQuestion.get(Integer.parseInt(queFormBean.getNext()));
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }
        BloodPresserChangedListener myListener = new BloodPresserChangedListener(context, queFormBean);
        String[] dataMap = queFormBean.getDatamap().split("-");
        String notAvailableText = "";

        // if dataMap value is 'T' then hide the not available checkbox
        if (!dataMap[0].equals("T")) {
            notAvailableText = GlobalTypes.NOT_AVAILABLE;
            CheckBox myCheBox = MyStaticComponents.getCheckBox(context, notAvailableText, IdConstants.BLOOD_PRESSURE_BOX_CHECKBOX_ID, false);
            myCheBox.setOnCheckedChangeListener(myListener);

            mainLayout.addView(myCheBox);
        }

        LinearLayout inputLayout = getLinearLayout(context, IdConstants.BLOOD_PRESSURE_BOX_INPUT_LAYOUT_ID, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        // kilogram   Kgs' and 'Grams'
        LinearLayout rowOne = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        TextInputLayout sysEditText = MyStaticComponents.getEditText(context,
                UtilBean.getMyLabel(LabelConstants.SYSTOLIC_BP),
                IdConstants.BLOOD_PRESSURE_BOX_SYSTOLIC_ID,
                3, InputType.TYPE_CLASS_NUMBER);
        sysEditText.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 9));
        if (sysEditText.getEditText() != null) {
            if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                sysEditText.getEditText().setHint("60 to 260");
            }
            sysEditText.getEditText().setOnFocusChangeListener(myListener);
        }
        sysEditText.setPadding(0, -0, 0, 50);
        rowOne.addView(sysEditText);

        MaterialTextView sysTextView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_PRESSURE, -1, R.style.CustomAnswerView, false);
        if (sysTextView != null) {
            sysTextView.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));
            rowOne.addView(sysTextView);
        }

        inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.SYSTOLIC_BP, -1, R.style.CustomAnswerView, false));
        inputLayout.addView(rowOne);

        rowOne = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        TextInputLayout diaEditText = MyStaticComponents.getEditText(context,
                UtilBean.getMyLabel(LabelConstants.DIASTOLIC_BP),
                IdConstants.BLOOD_PRESSURE_BOX_DIASTOLIC_ID,
                3, InputType.TYPE_CLASS_NUMBER);
        sysEditText.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 9));
        sysEditText.setPadding(0, 0, 0, 50);
        if (sysEditText.getEditText() != null) {
            sysEditText.getEditText().setOnFocusChangeListener(myListener);
            diaEditText.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 9));
            diaEditText.setPadding(0, 0, 0, 50);
            if (diaEditText.getEditText() != null) {
                diaEditText.getEditText().setOnFocusChangeListener(myListener);
            }

            rowOne.addView(diaEditText);

            sysTextView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_PRESSURE, -1, R.style.CustomAnswerView, false);
            if (sysTextView != null) {
                sysTextView.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));

                rowOne.addView(sysTextView);
            }
            inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.DIASTOLIC_BP, -1, R.style.CustomAnswerView, false));
            inputLayout.addView(rowOne);

//            MaterialTextView recordTimeView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.RECORD_TIME);
//            MaterialTextView timeAnswerView = MyStaticComponents.generateAnswerView(context, LabelConstants.NOT_AVAILABLE);
//            timeAnswerView.setPadding(0, 0, 0, 50);
//            if (dataMap[1] != null && !dataMap[1].isEmpty()
//                    && dataMap[1].equalsIgnoreCase("showTime")) {
//                setCurrentReadingTime(nextQuestion);
//            }

            if (sysEditText != null) {
                sysEditText.getEditText().addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {
                        if (dataMap.length >= 2 && dataMap[1] != null && !dataMap[1].isEmpty()
                                && dataMap[1].equalsIgnoreCase("showTime")) {
                            setCurrentReadingTime(nextQuestion);
                        }
                    }

                    @Override
                    public void afterTextChanged(Editable s) {

                    }
                });
            }

            if (diaEditText != null) {
                diaEditText.getEditText().addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

                    }

                    @Override
                    public void onTextChanged(CharSequence s, int start, int before, int count) {
                        if (dataMap.length >= 2 && dataMap[1] != null && !dataMap[1].isEmpty()
                                && dataMap[1].equalsIgnoreCase("showTime")) {
                            setCurrentReadingTime(nextQuestion);
                        }
                    }

                    @Override
                    public void afterTextChanged(Editable s) {

                    }
                });
            }

            mainLayout.addView(inputLayout);
//            mainLayout.addView(recordTimeView);
//            mainLayout.addView(timeAnswerView);

        }
        return mainLayout;
    }

    public static LinearLayout getBloodPressureBoxZambia(Context context, QueFormBean queFormBean, int id) {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        if (id != -1) {
            mainLayout.setId(id);
        }
        BloodPresserChangedListener myListener = new BloodPresserChangedListener(context, queFormBean);
        String notAvailableText = queFormBean.getDatamap();

        // if dataMap value is 'T' then hide the not available checkbox
        if (!notAvailableText.equals("T")) {
            if (notAvailableText == null) {
                notAvailableText = GlobalTypes.NOT_AVAILABLE;
            }
            CheckBox myCheBox = MyStaticComponents.getCheckBox(context, notAvailableText, IdConstants.BLOOD_PRESSURE_BOX_CHECKBOX_ID, false);
            myCheBox.setOnCheckedChangeListener(myListener);

            mainLayout.addView(myCheBox);
        }

        LinearLayout inputLayout = getLinearLayout(context, IdConstants.BLOOD_PRESSURE_BOX_INPUT_LAYOUT_ID, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        // kilogram   Kgs' and 'Grams'
        LinearLayout rowOne = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        TextInputLayout sysEditText = MyStaticComponents.getEditText(context,
                UtilBean.getMyLabel(LabelConstants.SYSTOLIC_BP),
                IdConstants.BLOOD_PRESSURE_BOX_SYSTOLIC_ID,
                3, InputType.TYPE_CLASS_NUMBER);
        sysEditText.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 9));
        if (sysEditText.getEditText() != null) {
            sysEditText.getEditText().setHint("60 to 260");
            sysEditText.getEditText().setOnFocusChangeListener(myListener);
        }
        sysEditText.setPadding(0, -0, 0, 50);
        rowOne.addView(sysEditText);
        MaterialTextView sysTextView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_PRESSURE, -1, R.style.CustomAnswerView, false);
        if (sysTextView != null) {
            sysTextView.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));
            rowOne.addView(sysTextView);
        }
        inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.SYSTOLIC_BP, -1, R.style.CustomAnswerView, false));
        inputLayout.addView(rowOne);
        rowOne = getLinearLayout(context, -1, HORIZONTAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        sysEditText = MyStaticComponents.getEditText(context,
                UtilBean.getMyLabel(LabelConstants.DIASTOLIC_BP),
                IdConstants.BLOOD_PRESSURE_BOX_DIASTOLIC_ID,
                3, InputType.TYPE_CLASS_NUMBER);
        sysEditText.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 9));
        sysEditText.setPadding(0, 0, 0, 50);
        if (sysEditText.getEditText() != null) {
            sysEditText.getEditText().setHint("40 to 160");
            sysEditText.getEditText().setOnFocusChangeListener(myListener);
        }

        rowOne.addView(sysEditText);

        sysTextView = MyStaticComponents.getMaterialTextView(context, LabelConstants.UNIT_OF_PRESSURE, -1, R.style.CustomAnswerView, false);
        if (sysTextView != null) {
            sysTextView.setLayoutParams(new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1));

            rowOne.addView(sysTextView);
        }
        inputLayout.addView(MyStaticComponents.getMaterialTextView(context, LabelConstants.DIASTOLIC_BP, -1, R.style.CustomAnswerView, false));
        inputLayout.addView(rowOne);
        mainLayout.addView(inputLayout);
        return mainLayout;
    }

    private static void setCurrentReadingTime(QueFormBean queFormBean) {
        String timeFormat = "MMM dd, yyyy hh:mm aaa";
        String currentTime = (String) DateFormat.format(timeFormat, Calendar.getInstance().getTime());

        if (queFormBean != null) {
            TextView nextQuestionView = (TextView) queFormBean.getQuestionTypeView();
            if (nextQuestionView != null) {
                if (currentTime != null && !currentTime.isEmpty()) {
                    nextQuestionView.setText(currentTime);
                    if (queFormBean.getRelatedpropertyname() != null && !queFormBean.getRelatedpropertyname().isEmpty()) {
                        SharedStructureData.relatedPropertyHashTable.put(queFormBean.getRelatedpropertyname(), currentTime);
                    }
                } else {
                    nextQuestionView.setText(LabelConstants.NOT_AVAILABLE);
                }
            }
            queFormBean.setAnswer(currentTime);
        }
    }

    public static LinearLayout getChildGrowthChart(Boolean isBoy, Context context) {
        Map<Integer, String> defaultData = Boolean.TRUE.equals(isBoy) ? WeightScoreUtil.WEIGHT_MAP_FOR_BOYS : WeightScoreUtil.WEIGHT_MAP_FOR_GIRLS;

        LinearLayout linearLayout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.child_growth_chart, null);
        LineChartView lineChartView = linearLayout.findViewById(R.id.lineChart);

        List<PointValue> yAxisValues0 = new ArrayList<>();
        List<PointValue> yAxisValues1 = new ArrayList<>();
        List<PointValue> yAxisValues2 = new ArrayList<>();
        List<PointValue> yAxisValues3 = new ArrayList<>();
        List<PointValue> yAxisValues4 = new ArrayList<>();

        Line line0 = new Line(yAxisValues0).setColor(Color.BLUE).setHasPoints(false);
        Line line1 = new Line(yAxisValues1).setColor(Color.RED).setHasPoints(false);
        Line line2 = new Line(yAxisValues2).setColor(ContextCompat.getColor(context, R.color.hofTextColor)).setHasPoints(false);
        Line line3 = new Line(yAxisValues3).setColor(Color.RED).setHasPoints(false);
        Line line4 = new Line(yAxisValues4).setColor(Color.BLACK).setHasPoints(false);

        for (Integer i : new TreeSet<>(defaultData.keySet())) {
            String data = defaultData.get(i);
            String[] cols = new String[0];
            if (data != null) {
                cols = data.split("~");
            }
            yAxisValues1.add(new PointValue(i, Float.parseFloat(cols[0])));
            yAxisValues2.add(new PointValue(i, Float.parseFloat(cols[1])));
            yAxisValues3.add(new PointValue(i, Float.parseFloat(cols[2])));
            yAxisValues4.add(new PointValue(i, Float.parseFloat(cols[3])));
        }

        yAxisValues0.add(new PointValue(0, 0f));
        List<Line> lines = new ArrayList<>();
        lines.add(line0);
        lines.add(line1);
        lines.add(line2);
        lines.add(line3);
        lines.add(line4);

        LineChartData data = new LineChartData();
        data.setLines(lines);

        Axis axis = new Axis();
        axis.setName(LabelConstants.CHILD_GROWTH_CHART_X_LABEL);
        axis.setTextSize(16);
        axis.setTextColor(R.color.colorPrimary);
        data.setAxisXBottom(axis);

        Axis yAxis = new Axis();
        yAxis.setName(LabelConstants.CHILD_GROWTH_CHART_Y_LABEL);
        yAxis.setTextColor(R.color.colorPrimary);
        yAxis.setTextSize(16);
        data.setAxisYLeft(yAxis);

        lineChartView.setLineChartData(data);
        lineChartView.animate();

        return linearLayout;
    }

    public static LinearLayout getOTPBasedVerificationComponent(final Context context, final QueFormBean queFormBean) {
        final LinearLayout verificationComponent = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.otp_verification_layout, null);
        verificationComponent.setOnClickListener(new OtpVerificationListener(context, verificationComponent, queFormBean));
        return verificationComponent;
    }

    public static LinearLayout getAudioPlayer(Context context, QueFormBean queFormBean, String dataMap, int id) {

        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }

        ImageView imageView = MyStaticComponents.getImageView(context, 1, R.drawable.play_audio, null);
        mainLayout.addView(imageView);

        imageView.setOnClickListener(new AudioPlayerListener(context, queFormBean, dataMap));

        return mainLayout;
    }

    public static LinearLayout getAudioPlayerForSimulations(Context context, int id, String path) {

        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        if (id != -1) {
            mainLayout.setId(id);
        }

        ImageView imageView = MyStaticComponents.getImageView(context, 1, R.drawable.play_audio, null);
        mainLayout.addView(imageView);

        imageView.setOnClickListener(new SimulationsAudioPlayerListener(context, path));

        return mainLayout;
    }

    public static LinearLayout getAudioTextBox(Context context, QueFormBean queFormBean, int id) {

        AudioTextBoxListener myListener = new AudioTextBoxListener(queFormBean, context);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);

        LinearLayout audioTextBox = getLinearLayout(context, -1, LinearLayout.HORIZONTAL, layoutParams);
        if (id != 0) {
            audioTextBox.setId(id);
        }
        layoutParams = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 2f);
        int length = queFormBean.getLength();
        TextInputLayout editText = MyStaticComponents.getEditText(context, queFormBean.getQuestion(), IdConstants.AUDIO_TEXT_BOX_ID, length, 1);
        editText.setOnFocusChangeListener(myListener);
        editText.setLayoutParams(layoutParams);

        audioTextBox.addView(editText); // add textBox to Layout
        String defaultValue;
        if (queFormBean.getRelatedpropertyname() != null && queFormBean.getRelatedpropertyname().trim().length() > 0) {
            String relatedPropertyName = queFormBean.getRelatedpropertyname().trim();
            if (queFormBean.getLoopCounter() > 0 && !queFormBean.isIgnoreLoop()) {
                relatedPropertyName += queFormBean.getLoopCounter();
            }
            defaultValue = SharedStructureData.relatedPropertyHashTable.get(relatedPropertyName);

            if (defaultValue != null) {
                queFormBean.setAnswer(defaultValue + GlobalTypes.KEY_VALUE_SEPARATOR);
                if (editText.getEditText() != null) {
                    editText.getEditText().setText(defaultValue);
                }
            }
        }
        ImageView imageView = MyStaticComponents.getImageView(context, 22, R.drawable.record_audio, null);
        imageView.setOnClickListener(myListener);
        layoutParams = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 0.1f);
        imageView.setLayoutParams(layoutParams);
        audioTextBox.addView(imageView); // add record button to Layout

        return audioTextBox;
    }

    public static LinearLayout getPhotoPicker(QueFormBean queFormBean, Context context, int id) {
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        LinearLayout myPhotoPicker = getLinearLayout(context, -1, VERTICAL, layoutParams);
        if (id != -1) {
            myPhotoPicker.setId(id);
        }

        View.OnClickListener listener = (new View.OnClickListener() {
            private Activity activity;
            private int currentQuestionId;

            public View.OnClickListener setActivity(Activity activity, int id) {
                this.activity = activity;
                this.currentQuestionId = id;
                return this;
            }

            @Override
            public void onClick(View view) {
                if (view.getId() == R.id.closeImageView) {
                    queFormBean.setAnswer((String) view.getTag());
                } else {
                    try {
                        SharedStructureData.currentQuestion = currentQuestionId;
                        Intent intent = new Intent(activity, CustomPhotoCaptureActivity.class);
                        intent.setFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
                        activity.startActivity(intent);
                    } catch (Exception e) {
                        android.util.Log.e(getClass().getSimpleName(), null, e);
                    }
                }
            }
        }).setActivity((Activity) context, DynamicUtils.getLoopId(queFormBean));
        if (queFormBean.getLength() <= 1) {
            ImageView actionButton = MyStaticComponents.getImageView(context, 1, R.drawable.camera, null);
            myPhotoPicker.addView(actionButton);
            actionButton.setOnClickListener(listener);
            ImageView takenPicture = MyStaticComponents.getImageView(context, GlobalTypes.PHOTO_CAPTURE_ACTIVITY,
                    R.drawable.no_image_available,
                    new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
            takenPicture.setVisibility(View.GONE);
            takenPicture.setScaleType(ImageView.ScaleType.FIT_XY);
            myPhotoPicker.addView(takenPicture, layoutParams);
        } else {
            List<String> pathList = new ArrayList<>();
            pathList.add(null);
            View rootLayout = LayoutInflater.from(context).inflate(R.layout.layout_recycler_view_grid_layout, null);
            RecyclerView recyclerView = rootLayout.findViewById(R.id.recyclerView);
            ImageGridLayoutAdapter imageGridLayoutAdapter = new ImageGridLayoutAdapter(pathList, context, queFormBean.getLength(), listener);
            recyclerView.setAdapter(imageGridLayoutAdapter);
            myPhotoPicker.addView(rootLayout);
        }

        return myPhotoPicker;
    }

    public static View getRadioButtonDate(Context context, QueFormBean queFormBean, String radioSelectionText, String dateSelectionText) {
        List<OptionDataBean> optionsOrDataMap = UtilBean.getOptionsOrDataMap(queFormBean, false);
        if (!optionsOrDataMap.isEmpty()) {
            RadioButtonDateListener myListener = new RadioButtonDateListener(context, queFormBean);

            List<String> listOfOptions = UtilBean.getListOfOptions(optionsOrDataMap);
            LinearLayout mainLayout = MyStaticComponents.getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

            if (radioSelectionText != null && radioSelectionText.trim().length() > 0 && !radioSelectionText.trim().equalsIgnoreCase("null")) {
                mainLayout.addView(MyStaticComponents.generateQuestionView(null, null, context, UtilBean.getMyLabel(radioSelectionText)));
            }
            mainLayout.addView(MyStaticComponents.getRadioGroup(context, myListener, listOfOptions, -1, -1, VERTICAL));
            //generate Dependency date view
            LinearLayout customDatePicker = MyStaticComponents.getLinearLayout(context, RadioButtonDateListener.DATE_VIEW_ID, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
            if (dateSelectionText != null && dateSelectionText.trim().length() > 0 && !dateSelectionText.trim().equalsIgnoreCase("null")) {
                customDatePicker.addView(MyStaticComponents.generateQuestionView(null, null, context, UtilBean.getMyLabel(dateSelectionText)));
            }
            LinearLayout myDatePicker = MyStaticComponents.getCustomDatePickerForStatic(context, myListener, DynamicUtils.ID_OF_CUSTOM_DATE_PICKER);
            customDatePicker.addView(myDatePicker);
            // by default it is invisible
            customDatePicker.setVisibility(View.GONE);
            mainLayout.addView(customDatePicker);
            return mainLayout;
        } else {
            return MyStaticComponents.generateAnswerView(context, UtilBean.getMyLabel(LabelConstants.NO_OPTIONS_FOUND));
        }
    }

    public static LinearLayout getMemberDetailsComponent(final Context context, QueFormBean queFormBean) {
        LinearLayout mainLayout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.member_details_component, null);
        final LinearLayout memberDetailsLayout = mainLayout.findViewById(R.id.memberDetFirst);
        final MaterialButton moreButton = mainLayout.findViewById(R.id.moreButton);

        final List<OptionDataBean> allOptions = UtilBean.getOptionsOrDataMap(queFormBean, false);
        final List<OptionDataBean> optionsForFirst = new LinkedList<>();

        int count = 1;
        for (OptionDataBean optionDataBean : allOptions) {
            if (count < 8) {
                optionsForFirst.add(optionDataBean);
            }
            count++;
        }

        setData(context, memberDetailsLayout, optionsForFirst);

        moreButton.setOnClickListener(v -> {
            if (!moreDetailsDisplayed) {
                setData(context, memberDetailsLayout, allOptions);
                moreButton.setText(UtilBean.getMyLabel(LabelConstants.LESS));
            } else {
                setData(context, memberDetailsLayout, optionsForFirst);
                moreButton.setText(UtilBean.getMyLabel(LabelConstants.MORE));
            }
            moreDetailsDisplayed = !moreDetailsDisplayed;
        });
        return mainLayout;
    }

    private static void setData(Context context, LinearLayout mainLayout, List<OptionDataBean> optionDataBeans) {
        mainLayout.removeAllViews();


        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(WRAP_CONTENT, WRAP_CONTENT, 1);
        LinearLayout.LayoutParams layoutParams1 = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        LinearLayout layout = getLinearLayout(context, -1, HORIZONTAL, layoutParams1);

        int length = 0;
        int count = 1;
        int horizontalCount = 1;

        for (OptionDataBean optionDataBean : optionDataBeans) {
            LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, count, VERTICAL, layoutParams);
            linearLayout.addView(MyStaticComponents.getListTitleView(context, optionDataBean.getKey()));
            linearLayout.setPadding(0, 0, 20, 0);
            String value = UtilBean.getNotAvailableIfNull(SharedStructureData.relatedPropertyHashTable.get(optionDataBean.getValue()));
            MaterialTextView materialTextView = MyStaticComponents.generateAnswerView(context, value);
            materialTextView.setPadding(20, 0, 0, 0);
            linearLayout.addView(materialTextView);

            layout.addView(linearLayout);

            if (optionDataBean.getKey().length() > value.length()) {
                length = length + optionDataBean.getKey().length();
            } else {
                length = length + value.length();
            }


            if (count == optionDataBeans.size() || length > 20) {
                layout.setWeightSum(horizontalCount);
                mainLayout.addView(layout);
                length = 0;
                layout = getLinearLayout(context, -1, HORIZONTAL, layoutParams1);
                horizontalCount = 1;
            } else {
                horizontalCount++;
            }

            count++;
        }
    }

    public static void showProcessDialog(Activity context) {
        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
        processDialog = new MyProcessDialog(context, UtilBean.getMyLabel(LabelConstants.PROCESSING));
        processDialog.show();
    }

    public static void hideProcessDialog(Activity context) {
        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
    }

    public static TableRow getTableRow(int i, String labelText, String valueText, Context context) {
        TableRow row = new TableRow(context);
        row.setPadding(10, 15, 10, 15);
        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            row.setBackgroundResource(R.drawable.table_row_selector);
        } else {
            row.setBackgroundResource(R.drawable.spinner_item_border);
        }
        row.setLayoutParams(layoutParamsForRow);
        MaterialTextView label = new MaterialTextView(context);
        MaterialTextView value = new MaterialTextView(context);
        label.setGravity(Gravity.START);
        value.setGravity(Gravity.CENTER);
        if (i == 0) {
            label.setText(UtilBean.getMyLabel("Parameters"));
            value.setText(UtilBean.getMyLabel(LabelConstants.VALUE));
            label.setTypeface(Typeface.DEFAULT_BOLD);
            value.setTypeface(Typeface.DEFAULT_BOLD);
            row.addView(label, layoutParams2);
            row.addView(value, layoutParams1);
        } else {
            label.setText(UtilBean.getMyLabel(labelText));
            value.setText(UtilBean.getMyLabel(valueText));
            row.addView(label, layoutParams2);
            row.addView(value, layoutParams1);
        }
        return row;
    }

    public static LinearLayout getTableLayout(Context context, QueFormBean queFormBean) {
        LinearLayout mainLayout = MyStaticComponents.getLinearLayout(context, -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));

        Map<String, String> dataMap = new HashMap<>();

        if (queFormBean.getDatamap() != null && !queFormBean.getDatamap().trim().isEmpty()) {
            try {
                dataMap = new Gson().fromJson(queFormBean.getDatamap(), new TypeToken<Map<String, String>>() {
                }.getType());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

//        map.put("Red Tablets", "IFA Tablet(60mg elemental Iron + 500mcg Folic Acid)");
//        map.put("Blue Tablets", "IFA Tablet(60mg elemental Iron + 500mcg Folic Acid)");
//        map.put("Pink Tablets", "IFA Tablet(45mg elemental Iron + 400mcg Folic Acid)");
//        map.put("Syrup", "1ml IFA Syrup(20mg elemental Iron + 100mcg Folic Acid)");

        TableRow.LayoutParams layoutParamsForCell1 = new TableRow.LayoutParams(0, WRAP_CONTENT, 2);
        TableRow.LayoutParams layoutParamsForCell2 = new TableRow.LayoutParams(0, WRAP_CONTENT, 5);

        TableLayout tableLayout = new TableLayout(context);
        tableLayout.setPadding(10, 10, 10, 10);
        tableLayout.setLayoutParams(new TableLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        int i = 0;
//        TableLayout tableLayout = getTableLayout();
        for (Map.Entry<String, String> entry : dataMap.entrySet()) {
            TableRow row = getTableRow(context);
            MaterialTextView tableCell1 = getTableCell(context, UtilBean.getMyLabel(entry.getKey()));
            MaterialTextView tableCell2 = getTableCell(context, UtilBean.getMyLabel(entry.getValue()));
//            if (i == 0) {
            tableCell1.setTypeface(Typeface.DEFAULT_BOLD);
            tableCell2.setTypeface(Typeface.DEFAULT_BOLD);
//            }
            row.addView(tableCell1, layoutParamsForCell1);
            row.addView(tableCell2, layoutParamsForCell2);
            tableLayout.addView(row, i);
            i++;
        }
        mainLayout.addView(tableLayout);

        return mainLayout;
    }

    private static MaterialTextView getTableCell(Context context, String cellValue) {
        MaterialTextView textView = new MaterialTextView(context);
        textView.setGravity(Gravity.CENTER);
        textView.setText(UtilBean.getMyLabel(cellValue));
        return textView;
    }

    private static TableRow getTableRow(Context context) {
        TableRow row = new TableRow(context);
        row.setLayoutParams(new TableRow.LayoutParams(MATCH_PARENT));
        row.setPadding(10, 15, 10, 15);
        if (SewaUtil.CURRENT_THEME == R.style.techo_training_app) {
            row.setBackgroundResource(R.drawable.table_row_selector);
        } else {
            row.setBackgroundResource(R.drawable.spinner_item_border);
        }
        return row;
    }
}
