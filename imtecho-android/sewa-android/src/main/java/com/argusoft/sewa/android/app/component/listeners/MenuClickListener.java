package com.argusoft.sewa.android.app.component.listeners;

import android.content.Context;
import android.content.Intent;
import android.view.View;

import com.argusoft.sewa.android.app.activity.AnnouncementActivity_;
import com.argusoft.sewa.android.app.activity.HighRiskPregnancyActivity_;
import com.argusoft.sewa.android.app.activity.HouseHoldLineListActivity_;
import com.argusoft.sewa.android.app.activity.LmsProgressReportActivity_;
import com.argusoft.sewa.android.app.activity.MyPeopleCBVActivity_;
import com.argusoft.sewa.android.app.activity.NotificationCBVActivity_;
import com.argusoft.sewa.android.app.activity.StockManagementActivity_;
import com.argusoft.sewa.android.app.activity.WorkLogActivity_;
import com.argusoft.sewa.android.app.activity.WorkRegisterActivity_;
import com.argusoft.sewa.android.app.activity.WorkStatusCBVActivity_;
import com.argusoft.sewa.android.app.constants.MenuConstants;
import com.argusoft.sewa.android.app.lms.LmsCourseListActivity_;

public class MenuClickListener implements View.OnClickListener {

    private final Context context;
    private final String selectedMenu;

    public MenuClickListener(Context context, String selectedMenu) {
        this.context = context;
        this.selectedMenu = selectedMenu;
    }

    @Override
    public void onClick(View v) {
        Intent intent;
        switch (selectedMenu) {
            case MenuConstants.HOUSE_HOLD_LINE_LIST:
                intent = new Intent(context, HouseHoldLineListActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.CBV_NOTIFICATION:
                intent = new Intent(context, NotificationCBVActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.FHW_HIGH_RISK_WOMEN_AND_CHILD:
                intent = new Intent(context, HighRiskPregnancyActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.FHW_WORK_REGISTER:
                intent = new Intent(context, WorkRegisterActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.FHW_WORK_STATUS:
                intent = new Intent(context, WorkStatusCBVActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.ANNOUNCEMENTS:
                intent = new Intent(context, AnnouncementActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.WORK_LOG:
                intent = new Intent(context, WorkLogActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.CBV_MY_PEOPLE:
                intent = new Intent(context, MyPeopleCBVActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.LEARNING_MANAGEMENT_SYSTEM:
                intent = new Intent(context, LmsCourseListActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.LMS_PROGRESS_REPORT:
                intent = new Intent(context, LmsProgressReportActivity_.class);
                context.startActivity(intent);
                break;
            case MenuConstants.STOCK_MANAGEMENT:
                intent = new Intent(context, StockManagementActivity_.class);
                context.startActivity(intent);
                break;
            default:
        }
    }
}
