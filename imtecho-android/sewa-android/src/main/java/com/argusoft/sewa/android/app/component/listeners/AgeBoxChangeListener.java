package com.argusoft.sewa.android.app.component.listeners;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.argusoft.sewa.android.app.BuildConfig;
import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

/**
 * @author alpeshkyada
 */
public class AgeBoxChangeListener implements View.OnFocusChangeListener {

    private int year;
    private int month;
    private int day;
    private int week;
    private final Context context;
    private final QueFormBean queFormBean;
    private TextView textDate;

    public AgeBoxChangeListener(Context context, QueFormBean queFormBean) {
        this.context = context;
        this.queFormBean = queFormBean;
        year = -1;
        month = -1;
        day = -1;
        week = -1;
    }

    public void setTextDate(TextView textDate) {
        this.textDate = textDate;
    }

    @Override
    public void onFocusChange(View view, boolean bln) {
        EditText editText = (EditText) view;
        if (!bln) {
            int textId = editText.getId();
            if (textId == IdConstants.AGE_BOX_YEAR_EDIT_TEXT_ID) {  //that is year
                try {
                    year = Integer.parseInt(editText.getText().toString());
                    editText.setHint(LabelConstants.ENTER + " " + GlobalTypes.YEARS);
                } catch (Exception e) {
                    editText.setHint(LabelConstants.ENTER_VALID + " " + GlobalTypes.YEARS);
                    editText.setText("");
                    SewaUtil.generateToast(view.getContext(), "Enter valid years");
                    year = -1;
                    if (GlobalTypes.FLAVOUR_CHIP.equalsIgnoreCase(BuildConfig.FLAVOR)) {
                        year = 0;
                    }
                } finally {
                    setAnswer();
                }
            } else if (textId == IdConstants.AGE_BOX_MONTH_EDIT_TEXT_ID) { //that is month
                try {
                    month = Integer.parseInt(editText.getText().toString());
                    editText.setHint(LabelConstants.ENTER + " " + GlobalTypes.MONTHS);
                    setAnswer();
                } catch (Exception e) {
                    editText.setHint(LabelConstants.ENTER_VALID + " " + GlobalTypes.MONTHS);
                    editText.setText("0");
                    SewaUtil.generateToast(view.getContext(), "Enter valid months");
                    month = 0;
                } finally {
                    setAnswer();
                }
            } else if (textId == IdConstants.AGE_BOX_WEEK_EDIT_TEXT_ID) {
                try {
                    week = Integer.parseInt(editText.getText().toString());
                    editText.setHint(LabelConstants.ENTER + " " + GlobalTypes.WEEK);
                    setAnswer();
                } catch (Exception e) {
                    editText.setHint(LabelConstants.ENTER_VALID + " " + GlobalTypes.WEEK);
                    editText.setText("");
                    day = -1;
                } finally {
                    setAnswer();
                }
            } else if (textId == IdConstants.AGE_BOX_DAY_EDIT_TEXT_ID) {
                try {
                    day = Integer.parseInt(editText.getText().toString());
                    editText.setHint(LabelConstants.ENTER + " " + GlobalTypes.DAY);
                    setAnswer();
                } catch (Exception e) {
                    editText.setHint(LabelConstants.ENTER_VALID + " " + GlobalTypes.DAY);
                    editText.setText("");
                    day = -1;
                } finally {
                    setAnswer();
                }
            }
        }
    }

    private void setAnswer() {
//        String ageFormat = null;
//        if (year != -1 && month != -1 && day != -1) {
//            ageFormat = year + GlobalTypes.DATE_STRING_SEPARATOR + month + GlobalTypes.DATE_STRING_SEPARATOR + day;
        Calendar instance = Calendar.getInstance();
        if (year != -1 || month != -1 || week != -1 || day != -1) {
            if (year != -1) {
                instance = Calendar.getInstance();
                instance.add(Calendar.YEAR, (-1) * year);
            }

            if (month != -1) {
                if (month < 0 || month > 11) {
                    queFormBean.setAnswer(null);
                    SewaUtil.generateToast(context, "Months should be between 0 to 11");
                    return;
                }
                instance.add(Calendar.MONTH, (-1) * month);
            }

            if (week != -1) {
                instance.add(Calendar.WEEK_OF_YEAR, (-1) * week);
            }

            if (day != -1) {
                if (day < 0 || day > 6) {
                    queFormBean.setAnswer(null);
                    SewaUtil.generateToast(context, "Days should be between 0 to 6");
                    return;
                }
                instance.add(Calendar.DAY_OF_WEEK, (-1) * day);
            }

        } else {
            queFormBean.setAnswer(null);
            if (textDate != null) {
                textDate.setText(UtilBean.getMyLabel(LabelConstants.YEAR_AND_MONTH_NOT_YET_ENTERED));
            }
        }

        instance.set(Calendar.HOUR_OF_DAY, 0);
        instance.set(Calendar.MINUTE, 0);
        instance.set(Calendar.SECOND, 0);
        instance.set(Calendar.MILLISECOND, 0);

        queFormBean.setAnswer(instance.getTime().getTime());
        Log.i(getClass().getSimpleName(), "The Age in year/month/day wise : " + instance.getTime());

        if (textDate != null) {
            String calculatedDate = new SimpleDateFormat(GlobalTypes.DATE_DD_MM_YYYY_FORMAT, Locale.getDefault()).format(instance.getTime());
            textDate.setText(calculatedDate);
        }

    }
}
