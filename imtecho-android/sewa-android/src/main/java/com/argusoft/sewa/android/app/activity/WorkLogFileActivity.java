package com.argusoft.sewa.android.app.activity;

import android.content.Intent;
import android.view.MenuItem;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.component.MyWorkLogAdapter;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.databean.WorkLogScreenDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.UploadFileDataBean;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.UtilBean;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;

import java.util.ArrayList;
import java.util.List;

/**
 * @author kelvin
 */
@EActivity
public class WorkLogFileActivity extends MenuActivity {

    @Bean
    SewaServiceImpl sewaService;

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

        setTitle(LabelConstants.WORK_LOG_FILE_TITLE);
        retrieveWorkLog();
    }

    private void retrieveWorkLog() {
        showProcessDialog();
        List<UploadFileDataBean> loggerBeans = sewaService.getFileWorkLog();
        List<WorkLogScreenDataBean> lst = new ArrayList<>();
        WorkLogScreenDataBean log;
        if (loggerBeans != null && !loggerBeans.isEmpty()) {
            for (UploadFileDataBean loggerBean : loggerBeans) {
                if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_SUCCESS)) {
                    log = new WorkLogScreenDataBean(loggerBean.getFileName(), R.drawable.success, loggerBean.getFileType(), loggerBean.getFormType(), null);
                    lst.add(log);
                } else if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_PENDING)) {
                    log = new WorkLogScreenDataBean(loggerBean.getFileName(), R.drawable.pending, loggerBean.getFileType(), loggerBean.getFormType(), null);
                    lst.add(log);
                } else if (loggerBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_ERROR)) {
                    log = new WorkLogScreenDataBean(loggerBean.getFileName(), R.drawable.error, loggerBean.getFileType(), loggerBean.getFormType(), null);
                    lst.add(log);
                }
            }
        } else {
            log = new WorkLogScreenDataBean(UtilBean.getMyLabel(LabelConstants.THERE_IS_NO_WORKLOG_TO_DISPLAY), -1, null, null, null);
            lst.add(log);
        }
        MyWorkLogAdapter adapter = new MyWorkLogAdapter(this, lst) {
            @Override
            public void retryUploading(UploadFileDataBean bean) {
            }
        };
        setContentView(MyStaticComponents.getListView(this, adapter, null));
        hideProcessDialog();
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);
        if (item.getItemId() == android.R.id.home) {
            navigateToHomeScreen(false);
        }
        return true;
    }
}
