package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.content.Context;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.LinearLayout;

import com.argusoft.sewa.android.app.constants.LabelConstants;

import java.util.HashMap;
import java.util.Map;

/**
 * Defines methods for MultiSelectComponent
 *
 * @author prateek
 * @since 16/02/23 10:31 PM
 */
public class MultiSelectComponent extends LinearLayout {

    private final Context context;
    private final Map<String, String> options;
    private final String title;
    private final Map<String, CheckBox> checkBoxes = new HashMap<>();

    private boolean isNonCheck = false;

    public MultiSelectComponent(Context context, Map<String, String> options, String title) {
        super(context);
        this.context = context;
        this.options = options;
        this.title = title;
        initView();
    }

    private void initView() {
        LinearLayout mainLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL, new LayoutParams(MATCH_PARENT, WRAP_CONTENT));
        addView(mainLayout);

        if (title != null) {
            mainLayout.addView(MyStaticComponents.generateQuestionView(
                    null, null, context, title));
        }

        int counter = 0;
        for (Map.Entry<String, String> entry : options.entrySet()) {
            CheckBox checkBox = MyStaticComponents.getCheckBox(context, entry.getValue(), counter++, false);
            if(!entry.getValue().equalsIgnoreCase(LabelConstants.NONE) && !entry.getValue().equalsIgnoreCase(LabelConstants.OTHER)){
                checkBox.setOnCheckedChangeListener((buttonView, isChecked) -> {
                    if(isChecked) {
                        for (Map.Entry<String, CheckBox> entry1 : checkBoxes.entrySet()) {
                            if (entry1.getKey().equalsIgnoreCase(LabelConstants.NONE) && entry1.getValue().isChecked()) {
                                clearCheckboxes(LabelConstants.NONE, true);
                                break;
                            }
                        }
                    }
                });
            }
            checkBoxes.put(entry.getKey(), checkBox);
            mainLayout.addView(checkBox);
        }
    }

    public void clearCheckboxes(String option, boolean isClearSingle){
        for (Map.Entry<String, CheckBox> entry : checkBoxes.entrySet()) {
            if(isClearSingle && entry.getKey().equalsIgnoreCase(option)){
                entry.getValue().setChecked(false);
                break;
            }else if(!isClearSingle) {
                if (!entry.getKey().equalsIgnoreCase(option)) {
                    entry.getValue().setChecked(false);
                }
            }
        }
    }

    public String getAnswerString() {
        StringBuilder sb = new StringBuilder();
        int i = 0;
        for (Map.Entry<String, CheckBox> entry : checkBoxes.entrySet()) {
            if (entry.getValue().isChecked()) {
                if (i != 0) {
                    sb.append(",");
                }
                sb.append(entry.getKey());
                i++;
            }
        }
        return sb.toString().length() > 0 ? sb.toString() : null;
    }

    public void setCheckedChangeForOption(String option, CompoundButton.OnCheckedChangeListener listener) {
        for (Map.Entry<String, CheckBox> entry : checkBoxes.entrySet()) {
            if (entry.getKey().equalsIgnoreCase(option)) {
                entry.getValue().setOnCheckedChangeListener(listener);
                return;
            }
        }
    }
}
