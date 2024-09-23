package com.argusoft.sewa.android.app.component.listeners;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;

import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;

public class TextChangeListener implements TextWatcher {

    private EditText editText;
    private QueFormBean queFormBean;
    private boolean isFormatting;

    public TextChangeListener(EditText editText, QueFormBean queFormBean) {
        this.editText = editText;
        this.queFormBean = queFormBean;
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
        // No need to do anything here
    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {
        if (isFormatting) {
            return;
        }

        isFormatting = true;
        editText.removeTextChangedListener(this);

        String idProof = SharedStructureData.relatedPropertyHashTable.get("idProof");

        // Save the current cursor position
        int cursorPosition = editText.getSelectionStart();

        if (s == null || s.length() == 0) {
            editText.setInputType(EditorInfo.TYPE_CLASS_TEXT | EditorInfo.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        } else if (queFormBean.getDatamap().equals("passport") && !idProof.contains("INTL")) {
            if (s.length() > 8) {
                // Trim the text to a maximum length of 8
                s = s.subSequence(0, 8);
                editText.setText(s);
                editText.setSelection(s.length());
            } else if (s.length() > 2) {
                // Handle input switching after 2 characters
                if (s.length() == 3) { // The moment 3rd character is entered
                    editText.setInputType(EditorInfo.TYPE_CLASS_NUMBER);
                }
            } else if (s.length() <= 2) {
                // Reset to alphabetic input if length is 2 or less
                editText.setInputType(EditorInfo.TYPE_CLASS_TEXT | EditorInfo.TYPE_TEXT_FLAG_CAP_CHARACTERS);
            }
        } else if (!queFormBean.getDatamap().equals("passport") && s.length() > 4) {
            StringBuilder sb = new StringBuilder(s.toString().replace("-", ""));
            int j = 4;
            int m = sb.length();
            for (int i = 0; i < m / 4; i++) {
                sb.insert(j, "-");
                j += 5;
            }
            editText.setText(sb.toString());
        }

        // Restore the cursor position after setting the text
        editText.setSelection(Math.min(cursorPosition, editText.getText().length()));

        editText.addTextChangedListener(this);
        isFormatting = false;
    }


    @Override
    public void afterTextChanged(Editable s) {
        if (isFormatting) {
            return;
        }

        isFormatting = true;
        String idProof = SharedStructureData.relatedPropertyHashTable.get("idProof");

        if (s.length() > 2 && queFormBean.getDatamap().equals("passport") && !idProof.contains("INTL")) {
            String firstTwo = s.subSequence(0, 2).toString().toUpperCase();
            String remaining = s.subSequence(2, s.length()).toString();

            // Filter remaining characters to only allow digits
            StringBuilder filteredRemaining = new StringBuilder();
            for (int i = 0; i < remaining.length(); i++) {
                char c = remaining.charAt(i);
                if (Character.isDigit(c)) {
                    filteredRemaining.append(c);
                }
            }

            String sb = firstTwo + filteredRemaining.toString();
            if (!sb.equals(s.toString())) {
                editText.removeTextChangedListener(this);
                editText.setText(sb);
                editText.setSelection(sb.length());
                editText.addTextChangedListener(this);
            }
        }

        // Reset input type if the text length is 2 or less
        if (s.length() <= 2 && queFormBean.getDatamap().equals("passport") && !idProof.contains("INTL")) {
            editText.setInputType(EditorInfo.TYPE_CLASS_TEXT | EditorInfo.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        }

        isFormatting = false;
    }
}
