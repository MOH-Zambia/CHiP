package com.argusoft.sewa.android.app.component.listeners;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Typeface;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.Gravity;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TableLayout;
import android.widget.TableRow;

import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.databean.OptionDataBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textfield.TextInputLayout;
import com.google.android.material.textview.MaterialTextView;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

public class StockRequestComponent extends LinearLayout {
    private final Context context;
    private final QueFormBean queFormBean;
    private final Map<String, TextInputLayout> stockMap;
    private final Map<String, String> answerMap;
    private TableLayout tableLayout;

    public StockRequestComponent(Context context, QueFormBean queFormBean) {
        super(context);
        this.context = context;
        this.queFormBean = queFormBean;
        stockMap = new HashMap<>();
        answerMap = new HashMap<>();
        init();
    }

    @SuppressLint("ClickableViewAccessibility")
    private void init() {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        tableLayout = new TableLayout(context);

        TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(0, MATCH_PARENT, 3);
        layoutParams.setMargins(0, 10, 0, 10);

        LinearLayout.LayoutParams textViewParams = new LinearLayout.LayoutParams(0, MATCH_PARENT, 5);
        textViewParams.setMargins(10, 0, 10, 0);

       /* LinearLayout.LayoutParams textViewParams1 = new LinearLayout.LayoutParams(0, MATCH_PARENT, 2);
        textViewParams.setMargins(10, 0, 10, 0);*/

        LinearLayout.LayoutParams inputTextParams = new LinearLayout.LayoutParams(0, MATCH_PARENT, 3.5f);
        inputTextParams.setMargins(10, 0, 10, 0);
        inputTextParams.gravity = Gravity.CENTER_VERTICAL;

        LinearLayout.LayoutParams layoutParamsClose = new LinearLayout.LayoutParams(0, MATCH_PARENT, 0.5f);
        layoutParamsClose.setMargins(10, 10, 10, 10);
        layoutParamsClose.gravity = Gravity.CENTER_VERTICAL;

        AutoCompleteTextView autoCompleteTextView = new AutoCompleteTextView(context);
        List<OptionDataBean> options = UtilBean.getOptionsOrDataMap(queFormBean, false);
        List<String> searchableOptions = new ArrayList<>();

        for (OptionDataBean option : options) {
            searchableOptions.add(option.getValue());
        }

        AdapterView.OnItemClickListener adaptorClickListener = (adapterView, view, i, l) -> {
            String selectedItem = adapterView.getItemAtPosition(i).toString();
            OptionDataBean option = null;
            for (OptionDataBean o : options) {
                if (o.getValue().equals(selectedItem)) {
                    option = o;
                    break;
                }
            }

            if (option != null && !stockMap.containsKey(option.getKey())) {
                LinearLayout nameAndQuantity = getLinearLayout(context, -1, HORIZONTAL,
                        new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));
                nameAndQuantity.setWeightSum(10f);

                TableRow row = new TableRow(context);
                MaterialTextView textView = new MaterialTextView(context);
                textView.setPadding(0, 20, 0, 20);
                textView.setText(UtilBean.getMyLabel(selectedItem));
                textView.setGravity(Gravity.CENTER_VERTICAL);
                textView.setTypeface(Typeface.DEFAULT_BOLD);
                textView.setLayoutParams(textViewParams);
                nameAndQuantity.addView(textView);

                TextInputLayout qtyInputText = MyStaticComponents.getChardhamEditText(context, LabelConstants.ENTER_QUANTITY, 10011, 3, InputType.TYPE_CLASS_NUMBER);
                qtyInputText.setLayoutParams(inputTextParams);
                qtyInputText.setPadding(0, 10, 0, 10);
                stockMap.put(option.getKey(), qtyInputText);
                Objects.requireNonNull(qtyInputText.getEditText()).addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

                    }

                    private Timer timer = new Timer();

                    @Override
                    public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                        timer.cancel();
                        timer = new Timer();
                        timer.schedule(
                                new TimerTask() {
                                    @Override
                                    public void run() {
                                        setAnswers();
                                    }
                                },
                                500L
                        );
                    }

                    @Override
                    public void afterTextChanged(Editable editable) {

                    }
                });

                MaterialTextView availableText = new MaterialTextView(context);
                availableText.setPadding(0, 20, 0, 20);
                try {
                    Integer medicineId = Integer.valueOf(option.getKey());
                    availableText.setText("Avl. " + SharedStructureData.stockManagementService.getStockAmountById(medicineId).toString());
                } catch (SQLException e) {
                    throw new RuntimeException(e);
                }
                availableText.setTypeface(Typeface.DEFAULT_BOLD);
               // availableText.setLayoutParams(textViewParams1);
                availableText.setGravity(Gravity.CENTER_VERTICAL);
               // nameAndQuantity.addView(availableText);

                qtyInputText.setGravity(Gravity.CENTER_VERTICAL);
                nameAndQuantity.addView(qtyInputText);

                ImageView imageClear = MyStaticComponents.getImageView(context, 2, R.drawable.cross, null);
                imageClear.setLayoutParams(layoutParamsClose);
                nameAndQuantity.addView(imageClear);

                OptionDataBean finalOption = option;
                imageClear.setOnClickListener(view1 -> {
                    stockMap.remove(finalOption.getKey());
                    tableLayout.removeView(row);
                    setAnswers();
                });

                row.addView(nameAndQuantity, layoutParams);
                tableLayout.addView(row, 0);
                setAnswers();
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

        mainLayout.addView(autoCompleteTextView);
        mainLayout.addView(tableLayout);
        addView(mainLayout);
    }

    private void setAnswers() {
        if (checkValidations()) {
            queFormBean.setAnswer(answerMap);
        } else {
            queFormBean.setAnswer(null);
        }
    }

    private boolean checkValidations() {
        answerMap.clear();

        // Check if any medicines are selected
        if (stockMap.isEmpty()) {
            queFormBean.setMandatorymessage("Please select medicines to request for stock");
            return false;
        }

        // Loop through each entry in stockMap
        for (Map.Entry<String, TextInputLayout> entry : stockMap.entrySet()) {
            String quantityString = Objects.requireNonNull(entry.getValue().getEditText())
                    .getText().toString().trim();

            // Check if the quantity is empty or zero
            if (quantityString.isEmpty()) {
                queFormBean.setMandatorymessage("Please enter quantity for " +
                        SharedStructureData.sewaFhsService.getValueOfListValuesById(entry.getKey()));
                return false;
            } else if (quantityString.equals("0")) {
                queFormBean.setMandatorymessage("Quantity cannot be 0 for " +
                        SharedStructureData.sewaFhsService.getValueOfListValuesById(entry.getKey()));
                return false;
            } else {
                // Add valid quantity to the answerMap
                answerMap.put(entry.getKey(), quantityString);
            }
        }

        return true; // All validations passed
    }

}
