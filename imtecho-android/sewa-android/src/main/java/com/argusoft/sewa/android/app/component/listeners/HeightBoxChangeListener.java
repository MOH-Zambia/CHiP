package com.argusoft.sewa.android.app.component.listeners;

import android.content.Context;
import android.view.View;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.datepicker.MaterialDatePicker;
import com.google.android.material.datepicker.MaterialPickerOnPositiveButtonClickListener;

import java.text.SimpleDateFormat;
import java.util.Locale;

/**
 * @author alpeshkyada
 */
public class HeightBoxChangeListener implements View.OnFocusChangeListener,
        CompoundButton.OnCheckedChangeListener,
        AdapterView.OnItemSelectedListener,
        View.OnClickListener,
        MaterialPickerOnPositiveButtonClickListener<Long> {

    private final Context context;
    private final QueFormBean queFormBean;
    private final boolean isShowDate;
    private final String dateMandatoryMessage;
    private int feet;
    private int inches;
    private Long date;
    private boolean isChecked;
    private View mainLayout;
    private TextView txtDate;
    private String heightMandatoryMessage;
    private EditText txtFeet;
    private Spinner comboInches;
    private Spinner comboFeet;

    public HeightBoxChangeListener(Context context, QueFormBean queFormBean, boolean isShowDate) {
        this.context = context;
        this.queFormBean = queFormBean;
        this.isShowDate = isShowDate;
        this.dateMandatoryMessage = LabelConstants.WHEN_WAS_WEIGHT_TAKEN;
        feet = inches = -1;
        date = 0L;
        isChecked = false;
    }

    @Override  // if checked changed
    public void onCheckedChanged(CompoundButton cb, boolean bln) {
        isChecked = bln;
        if (mainLayout == null) {
            mainLayout = (((View) queFormBean.getQuestionTypeView()).findViewById(IdConstants.HIGHT_BOX_INPUT_LAYOUT_ID));
        }
        if (isChecked) {
            mainLayout.setVisibility(View.GONE);
            resetComponent();
        } else {
            mainLayout.setVisibility(View.VISIBLE);
        }
        setAnswer();
    }

    @Override  // if kilogram entered
    public void onFocusChange(View view, boolean bln) {
        if (!bln) {
            txtFeet = (EditText) view;
            try {
                feet = Integer.parseInt(txtFeet.getText().toString());
            } catch (Exception e) {
                feet = -1;
            } finally {
                setAnswer();
            }
        }
    }

    @Override  // if gram is selected 
    public void onItemSelected(AdapterView<?> av, View view, int i, long l) {
        try {
            if (av.getId() == IdConstants.HEIGHT_BOX_SPINNER_INCH_ID) {
                inches = i - 1;
                comboInches = (Spinner) av;
            } else if (av.getId() == IdConstants.HEIGHT_BOX_SPINNER_FEET_ID) {
                feet = i - 1;
                comboFeet = (Spinner) av;
            }
        } catch (Exception e) {
            inches = i - 1;
            Log.e(getClass().getSimpleName(), null, e);
        }
        setAnswer();
    }

    @Override
    public void onNothingSelected(AdapterView<?> av) {
        // Do nothing
    }

    @Override  // if click on date selection
    public void onClick(View view) {
        txtDate = view.findViewById(IdConstants.DATE_PICKER_TEXT_DATE_ID);

        MaterialDatePicker.Builder<Long> builder = MaterialDatePicker.Builder.datePicker();
        if (date != null && date != 0L) {
            builder.setSelection(date);
        }
        MaterialDatePicker<Long> datePicker = builder.build();
        datePicker.addOnPositiveButtonClickListener(this);
        datePicker.show(((AppCompatActivity) context).getSupportFragmentManager(), LabelConstants.MY_DATE_PICKER);
    }

    @Override
    public void onPositiveButtonClick(Long selection) {
        if (txtDate != null) {
            txtDate.setText(new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(selection));
        }
        this.date = selection;
        setAnswer();
    }

    private void setAnswer() {
        String answer = null;
        if (isChecked) {
            answer = GlobalTypes.NO_WEIGHT;
        } else {
            if (isShowDate) {
                if (date > 0) {
                    if (feet != -1) {
                        if (inches != -1) {
                            //Converting to cms
                            Double incms = (feet * 30.48) + (inches * 2.54);
                            answer = incms.intValue() + GlobalTypes.DATE_STRING_SEPARATOR + date;
                        } else {
                            //Converting to cms
                            Double incms = (feet * 30.48);
                            answer = incms.intValue() + GlobalTypes.DATE_STRING_SEPARATOR + date;
                        }
                    } else if (inches != -1) {
                        Double incms = (inches * 2.54);
                        answer = incms.intValue() + GlobalTypes.DATE_STRING_SEPARATOR + date;
                    } else if (heightMandatoryMessage != null) {
                        queFormBean.setMandatorymessage(heightMandatoryMessage);
                    }
                } else {
                    heightMandatoryMessage = queFormBean.getMandatorymessage();
                    queFormBean.setMandatorymessage(dateMandatoryMessage);
                }
            } else {
                if (feet != -1) {
                    if (inches != -1) {
                        Double incms = (feet * 30.48) + (inches * 2.54);
                        answer = String.valueOf(incms.intValue());
                    } else {
                        Double incms = (feet * 30.48);
                        answer = String.valueOf(incms.intValue());
                    }
                } else if (inches != -1) {
                    Double incms = (inches * 2.54);
                    answer = String.valueOf(incms.intValue());
                }
            }
        }
        queFormBean.setAnswer(answer);
        Log.i(getClass().getSimpleName(), queFormBean.getQuestion() + "=" + queFormBean.getAnswer());
        DynamicUtils.applyFormula(queFormBean, true);
    }

    private void resetComponent() {
        if (txtFeet != null) {
            txtFeet.setText("");
            feet = -1;
        } else if (comboFeet != null) {
            try {
                comboFeet.setSelection(0);
                feet = -1;
            } catch (Exception e) {
                Log.e(getClass().getSimpleName(), null, e);
                feet = -1;
            }
        }
        if (comboInches != null) {
            try {
                comboInches.setSelection(0);
                inches = -1;
            } catch (Exception e) {
                Log.e(getClass().getSimpleName(), null, e);
                inches = -1;
            }
        }
        if (txtDate != null) {
            txtDate.setText(UtilBean.getMyLabel(LabelConstants.SELECT_DATE));
            date = 0L;
        }
    }
}
