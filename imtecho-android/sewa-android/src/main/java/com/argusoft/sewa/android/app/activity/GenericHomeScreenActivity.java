package com.argusoft.sewa.android.app.activity;

import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.gps;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;
import android.view.View;

import androidx.appcompat.widget.Toolbar;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.comparator.MenuConstantComparator;
import com.argusoft.sewa.android.app.component.HomeMenuAdapter;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyProcessDialog;
import com.argusoft.sewa.android.app.component.OnMenuItemViewVClickListener;
import com.argusoft.sewa.android.app.component.listeners.MenuClickListener;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.MenuConstants;
import com.argusoft.sewa.android.app.core.impl.LmsEventServiceImpl;
import com.argusoft.sewa.android.app.core.impl.MenuServiceImpl;
import com.argusoft.sewa.android.app.core.impl.MoveToProductionServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.FormAccessibilityBean;
import com.argusoft.sewa.android.app.model.MenuBean;
import com.argusoft.sewa.android.app.restclient.impl.ApiManager;
import com.argusoft.sewa.android.app.service.LocationSyncService_;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.argusoft.sewa.android.app.util.WSConstants;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

@EActivity
public class GenericHomeScreenActivity extends HomeScreenMenuActivity implements OnMenuItemViewVClickListener {

    @Bean
    MenuServiceImpl menuService;
    @Bean
    MoveToProductionServiceImpl moveToProdService;
    @Bean
    SewaServiceImpl sewaService;
    @Bean
    LmsEventServiceImpl lmsEventService;
    @Bean
    ApiManager apiManager;
    HomeMenuAdapter homeMenuAdapter;

    private List<MenuBean> orderList = new ArrayList<>();
    private Handler uIHandler;
    private Handler backgroundHandler;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SharedStructureData.relatedPropertyHashTable.clear();
        context = this;
        uIHandler = new Handler(Looper.getMainLooper());
        HandlerThread handlerThread = new HandlerThread("HandlerThread");
        handlerThread.start();
        backgroundHandler = new Handler(handlerThread.getLooper());
        init();
    }

    private void init() {
        setContentView(R.layout.activity_home_screen);
        Toolbar toolbar = findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        setActionBarDesign();
        setNavigationView();
        orderList = menuService.retrieveMenus();

        Collections.sort(orderList, new MenuConstantComparator());
        LinkedList<Integer> icons = new LinkedList<>();
        LinkedList<String> names = new LinkedList<>();
        LinkedList<String> constant = new LinkedList<>();
        List<MenuBean> menuToRemove = new ArrayList<>();
        for (MenuBean m : orderList) {
            Integer menuIcons = MenuConstants.getMenuIcons(m.getConstant());
            if (menuIcons == null) {
                menuToRemove.add(m);
                continue;
            }
            icons.add(menuIcons);
            names.add(m.getDisplayName());
            constant.add(m.getConstant());
        }
        orderList.removeAll(menuToRemove);

        if (orderList.isEmpty()) {
            showAlert(LabelConstants.NO_FEATURE_FOUND, GlobalTypes.MSG_NO_MENU, v -> alertDialog.dismiss(), DynamicUtils.BUTTON_OK);
        }

        //set up recycler view
        RecyclerView recyclerView = findViewById(R.id.rv_home_screen_icons);
        homeMenuAdapter = new HomeMenuAdapter(context, integerListToIntArray(icons), names.toArray(new String[0]), constant.toArray(new String[0]), true,
                /*techoService.isNewNotification()*/false, lmsService.isAnyUpdatedDataAvailable(), this::onItemClickListener);
        GridLayoutManager gridLayoutManager;
        if (getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            gridLayoutManager = new GridLayoutManager(context, 6);
        } else {
            gridLayoutManager = new GridLayoutManager(context, 3);
        }
        recyclerView.setLayoutManager(gridLayoutManager);
        recyclerView.setAdapter(homeMenuAdapter);
        //setCardView(context, names.toArray(new String[0]), integerListToIntArray(icons), this);

        if (SewaTransformer.loginBean.getUserRole() != null && SewaTransformer.loginBean.getUserRole().equalsIgnoreCase(GlobalTypes.USER_ROLE_SDRF) ||
                SewaTransformer.loginBean.getUserRole().equalsIgnoreCase(GlobalTypes.USER_ROLE_FMR) ||
                SewaTransformer.loginBean.getUserRole().equalsIgnoreCase(GlobalTypes.USER_ROLE_MULE)) {
            if (!SharedStructureData.gps.isLocationProviderEnabled()) {
                gps.showSettingsAlert(context);
            } else {
                Intent startLocationService = new Intent(this, LocationSyncService_.class);
                startService(startLocationService);
            }
        }
    }

    private int[] integerListToIntArray(LinkedList<Integer> icons) {
        int[] iconsArray = new int[icons.size()];
        int i = 0;
        for (Integer icon : icons) {
            iconsArray[i] = icon;
            i++;
        }
        return iconsArray;
    }

    @Override
    public void onBackPressed() {
        View.OnClickListener onClickListener = this::logoutAlertDialogClick;
        alertDialog = new MyAlertDialog(this,
                UtilBean.getMyLabel(GlobalTypes.MSG_CANCEL_APPLICATION),
                onClickListener, DynamicUtils.BUTTON_HIDE_LOGOUT);
        alertDialog.show();
    }

    private boolean checkMenuAccessibleToUser(View view, String menuConstant) {
        String formCode = MenuConstants.getFormCodeFromMenuConstant(menuConstant);
        if (formCode == null) {
            return true;
        }

        FormAccessibilityBean formAccessibilityBean = moveToProductionService.retrieveFormAccessibilityBeanByFormType(formCode);
        if (Boolean.TRUE.equals(SewaTransformer.loginBean.isTrainingUser())) {
            return checkIfFormIsAccessibleInTraining(formAccessibilityBean, view, menuConstant);
        } else {
            return checkIfFormIsAccessibleInProduction(formAccessibilityBean, view, menuConstant);
        }
    }

    private boolean checkIfFormIsAccessibleInProduction(FormAccessibilityBean formAccessibilityBean, View view, String menuConstant) {
        if (formAccessibilityBean == null) {
            showAlertDialogForFormNotAccessible(view, menuConstant);
            return false;
        }

        if (Boolean.TRUE.equals(formAccessibilityBean.getTrainingReq())
                && (formAccessibilityBean.getState() == null || !formAccessibilityBean.getState().equals("MOVE_TO_PRODUCTION"))) {
            showAlertDialogForFormNotAccessible(view, menuConstant);
            return false;
        }
        return true;
    }

    private boolean checkIfFormIsAccessibleInTraining(FormAccessibilityBean formAccessibilityBean, View view, String menuConstant) {
        if (formAccessibilityBean != null && Boolean.TRUE.equals(formAccessibilityBean.getTrainingReq()) && formAccessibilityBean.getState() != null && formAccessibilityBean.getState().equals(GlobalTypes.MOVE_TO_PRODUCTION_RESPONSE_PENDING)) {
            Intent intent = new Intent(this, MoveToProductionActivity_.class);
            startActivity(intent);
            return false;
        } else if (formAccessibilityBean != null && Boolean.TRUE.equals(formAccessibilityBean.getTrainingReq()) && formAccessibilityBean.getState() != null && formAccessibilityBean.getState().equals(GlobalTypes.MOVE_TO_PRODUCTION)) {
            showAlertDialogForFormNotAccessible(view, menuConstant);
            return false;
        }
        return true;
    }

    @UiThread
    public void showAlertDialogForFormNotAccessible(View view, String menuConstant) {
        processDialog.dismiss();

        String alertLabel = LabelConstants.TRAINING_REQUIRED_AND_PRACTICE;
        String posButton = UtilBean.getMyLabel(LabelConstants.GO_TO_TRAINING_MODE);
        String negButton = UtilBean.getMyLabel(LabelConstants.CANCEL);
        if (Boolean.TRUE.equals(SewaTransformer.loginBean.isTrainingUser())) {
            alertLabel = UtilBean.getMyLabel(LabelConstants.PRACTICE_COMPLETED);
            posButton = UtilBean.getMyLabel(LabelConstants.EXIT_TRAINING_MODE);
            negButton = UtilBean.getMyLabel(LabelConstants.CANCEL);
        }
        alertDialog = new MyAlertDialog(context,
                UtilBean.getMyLabel(alertLabel),
                v -> {
                    alertDialog.dismiss();
                    if (v.getId() == DialogInterface.BUTTON_POSITIVE) {
                        if (Boolean.TRUE.equals(SewaTransformer.loginBean.isTrainingUser())) {
                            loginIntoProduction();
                        } else {
                            loginIntoTraining();
                        }
                    }
                }, DynamicUtils.BUTTON_YES_NO,
                posButton,
                negButton,
                true);
        alertDialog.show();
    }

    @UiThread
    public void showTrainingCompletedForm() {
        List<FormAccessibilityBean> formAccessibilityBeans = moveToProdService.isAnyFormTrainingCompleted();
        if (formAccessibilityBeans != null && !formAccessibilityBeans.isEmpty()) {
            Intent intent = new Intent(this, MoveToProductionActivity_.class);
            startActivity(intent);
        }
    }

    @Override
    public void onItemClickListener(int position, View view) {
        processDialog = new MyProcessDialog(this, GlobalTypes.PLEASE_WAIT);
        processDialog.show();
        new Thread() {
            @Override
            public void run() {
                MenuBean menuConstant = orderList.get(position);
                if (checkMenuAccessibleToUser(view, menuConstant.getConstant())) {
                    MenuClickListener menuListener = new MenuClickListener(context, menuConstant.getConstant());
                    menuListener.onClick(view);
                }
                processDialog.dismiss();
            }
        }.start();
    }

    private void loginIntoProduction() {
        if (!sewaService.isOnline()) {
            SewaUtil.generateToast(context, LabelConstants.NO_INTERNET_CONNECTION_AVAILABLE);
            return;
        }

        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
        processDialog = new MyProcessDialog(context, LabelConstants.PLEASE_WAIT_WHILE_LOADING_PRODUCTION);
        processDialog.show();

        backgroundHandler.post(() -> {
            //First Submit all the records
            try {
                sewaService.updateAnswerBeanTokensAndUserIdsOnce();
                sewaService.uploadDataToServer();
                sewaService.uploadAllMediaToServer();
                lmsEventService.uploadLmsEventToServer();
                sewaService.uploadUncaughtExceptionDetailToServer();
            } catch (Exception e) {
                Log.e(getClass().getSimpleName(), e.getMessage());
                sewaService.storeException(e, "DATA_SYNC");
            }

            // Switch to Production Server
            WSConstants.setLiveContextUrl();
            apiManager.createApiService();
            String username = SewaTransformer.loginBean.getUsername();
            if (username.endsWith("_t")) {
                username = username.substring(0, username.length() - 2);
            }

            String validateUser = sewaService.validateUser(username, SewaTransformer.loginBean.getPasswordPlain(), 1, false);

            uIHandler.post(() -> SewaUtil.generateToast(context, validateUser));

            if (validateUser.equalsIgnoreCase(SewaConstants.LOGIN_SUCCESS_WEB) || validateUser.contains(GlobalTypes.MOBILE_DATE_NOT_SAME_SERVER)) {
                //Start logging into Training Environment
                SewaUtil.CURRENT_THEME = R.style.techo_app;
                sewaService.doAfterSuccessfulLogin(true);
            } else {
                WSConstants.setTrainingContextUrl();
                apiManager.createApiService();
            }

            uIHandler.post(() -> {
                if (processDialog != null && processDialog.isShowing()) {
                    processDialog.dismiss();
                }

                //Reload the menu activity
                Intent intent = new Intent(context, GenericHomeScreenActivity_.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                ((Activity) context).finish();
            });
        });
    }

    private void loginIntoTraining() {
        if (!sewaService.isOnline()) {
            SewaUtil.generateToast(context, LabelConstants.NO_INTERNET_CONNECTION_AVAILABLE);
            return;
        }

        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
        processDialog = new MyProcessDialog(context, LabelConstants.PLEASE_WAIT_WHILE_LOADING_PRACTICE);
        processDialog.show();

        backgroundHandler.post(() -> {
            try {
                //First Submit all the records
                sewaService.updateAnswerBeanTokensAndUserIdsOnce();
                sewaService.uploadDataToServer();
                sewaService.uploadAllMediaToServer();
                lmsEventService.uploadLmsEventToServer();
                sewaService.uploadUncaughtExceptionDetailToServer();
            } catch (Exception e) {
                Log.e(getClass().getSimpleName(), e.getMessage());
                sewaService.storeException(e, "DATA_SYNC");
            }

            // Switch to Training Server
            WSConstants.setTrainingContextUrl();
            apiManager.createApiService();
            String validateUser = sewaService.validateUser(
                    SewaTransformer.loginBean.getUsername() + "_t",
                    SewaTransformer.loginBean.getPasswordPlain(), 2, false);

            uIHandler.post(() -> SewaUtil.generateToast(context, validateUser));

            if (validateUser.equalsIgnoreCase(SewaConstants.LOGIN_SUCCESS_WEB) || validateUser.contains(GlobalTypes.MOBILE_DATE_NOT_SAME_SERVER)) {
                //Start logging into Training Environment
                SewaUtil.CURRENT_THEME = R.style.techo_training_app;
                sewaService.doAfterSuccessfulLogin(true);
            } else {
                WSConstants.setLiveContextUrl();
                apiManager.createApiService();
            }

            uIHandler.post(() -> {
                if (processDialog != null && processDialog.isShowing()) {
                    processDialog.dismiss();
                }

                if (Boolean.TRUE.equals(SewaTransformer.loginBean.isTrainingUser())) {
                    List<FormAccessibilityBean> formAccessibilityBeans = moveToProductionService.isAnyFormTrainingCompleted();
                    if (formAccessibilityBeans != null && !formAccessibilityBeans.isEmpty()) {
                        Intent intent = new Intent(this, MoveToProductionActivity_.class);
                        context.startActivity(intent);
                        ((Activity) context).finish();
                        return;
                    }
                }

                //Reload the menu activity
                Intent intent = new Intent(context, GenericHomeScreenActivity_.class);
                intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
                ((Activity) context).finish();
            });
        });
    }
}
