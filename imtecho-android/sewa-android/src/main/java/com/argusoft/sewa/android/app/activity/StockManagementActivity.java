package com.argusoft.sewa.android.app.activity;

import static android.content.DialogInterface.BUTTON_POSITIVE;
import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static android.widget.LinearLayout.HORIZONTAL;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.WindowManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TableLayout;
import android.widget.TableRow;

import androidx.appcompat.widget.Toolbar;
import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyAlertDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
import com.argusoft.sewa.android.app.component.PagingListView;
import com.argusoft.sewa.android.app.constants.ActivityConstants;
import com.argusoft.sewa.android.app.constants.FieldNameConstants;
import com.argusoft.sewa.android.app.constants.FormConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.core.impl.HealthInfrastructureServiceImpl;
import com.argusoft.sewa.android.app.core.impl.LocationMasterServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaFhsServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.core.impl.SewaServiceRestClientImpl;
import com.argusoft.sewa.android.app.databean.ListItemDataBean;
import com.argusoft.sewa.android.app.databean.StockManagementDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.db.DBConnection;
import com.argusoft.sewa.android.app.model.HealthInfrastructureBean;
import com.argusoft.sewa.android.app.model.StockInventoryBean;
import com.argusoft.sewa.android.app.model.VersionBean;
import com.argusoft.sewa.android.app.restclient.RestHttpException;
import com.argusoft.sewa.android.app.transformer.SewaTransformer;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.FormMetaDataUtil;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;
import com.google.zxing.integration.android.IntentIntegrator;
import com.google.zxing.integration.android.IntentResult;
import com.j256.ormlite.dao.Dao;

import org.androidannotations.annotations.Background;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;
import org.androidannotations.ormlite.annotations.OrmLiteDao;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Timer;

@EActivity
public class StockManagementActivity extends MenuActivity implements View.OnClickListener {

    @Bean
    SewaServiceImpl sewaService;
    @Bean
    SewaFhsServiceImpl fhsService;
    @Bean
    LocationMasterServiceImpl locationService;
    @OrmLiteDao(helper = DBConnection.class)
    Dao<VersionBean, Integer> versionBeanDao;

    @OrmLiteDao(helper = DBConnection.class)
    Dao<StockInventoryBean, Integer> stockInventoryBeanDao;
    @Bean
    FormMetaDataUtil formMetaDataUtil;
    @Bean
    SewaServiceRestClientImpl sewaServiceRestClient;
    @Bean
    HealthInfrastructureServiceImpl healthInfrastructureService;
    private static final String STOCK_REQUEST_SCREEN = "stockRequestScreen";
    private static final String REQUEST_SCREEN = "requestsScreen";
    private static final String MY_STOCK_SCREEN = "myStockScreen";
    private static final long DELAY = 500;
    private static final int LIMIT = 30;
    private int offset = 0;
    private LinearLayout globalPanel;
    private LinearLayout bodyLayoutContainer;
    private Button nextButton;
    private Timer timer = new Timer();
    private Intent myIntent;
    private String screen;
    private TableLayout tableLayout;
    private PagingListView pagingListView;
    private MaterialTextView pagingHeaderView;
    private MaterialTextView noMemberAvailableView;
    private int selectedItemIndex = -1;
    private String locationId;
    private LinearLayout footerLayout;
    List<StockManagementDataBean> stockManagementDataBeans;
    private LinkedHashMap<String, String> qrScanFilter = new LinkedHashMap<>();
    private final SimpleDateFormat sdfForDisplay = new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault());
    private List<StockInventoryBean> stockInventoryBean;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        context = this;
        getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        initView();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (globalPanel != null) {
            setContentView(globalPanel);
        }
        if (!SharedStructureData.isLogin) {
            myIntent = new Intent(this, LoginActivity_.class);
            myIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
                    | Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(myIntent);
            finish();
        }
        setTitle(UtilBean.getTitleText(UtilBean.getFullFormOfEntity().get(FormConstants.STOCK_MANAGEMENT)));
    }

    private void initView() {
        showProcessDialog();
        globalPanel = DynamicUtils.generateDynamicScreenTemplate(this, this);
        Toolbar toolbar = globalPanel.findViewById(R.id.my_toolbar);
        setSupportActionBar(toolbar);
        bodyLayoutContainer = globalPanel.findViewById(DynamicUtils.ID_BODY_LAYOUT);
        nextButton = globalPanel.findViewById(DynamicUtils.ID_NEXT_BUTTON);
        footerLayout = globalPanel.findViewById(DynamicUtils.ID_FOOTER);
        setBodyDetail();
    }

    @Background
    public void setBodyDetail() {
        startLocationSelectionActivity();
    }

    private void startLocationSelectionActivity() {
        myIntent = new Intent(context, LocationSelectionActivity_.class);
        myIntent.putExtra(FieldNameConstants.TITLE, UtilBean.getFullFormOfEntity().get(FormConstants.STOCK_MANAGEMENT));
        startActivityForResult(myIntent, ActivityConstants.LOCATION_SELECTION_ACTIVITY_REQUEST_CODE);
    }

    @Override
    public void onClick(View v) {
        if (v.getId() == DynamicUtils.ID_NEXT_BUTTON) {
            if (screen.equals(STOCK_REQUEST_SCREEN)) {

            } else {
                navigateToHomeScreen(false);
            }
        }
    }

    @UiThread
    public void addStockRequestScreen() {
        bodyLayoutContainer.removeAllViews();
        screen = STOCK_REQUEST_SCREEN;
        bodyLayoutContainer.addView(lastUpdateLabelView(sewaService, bodyLayoutContainer));
        List<String> options = new ArrayList<>();
        options.add(UtilBean.getMyLabel(LabelConstants.REQUEST_FOR_STOCK));
        options.add(UtilBean.getMyLabel(LabelConstants.APPROVED_REQUESTS));
        options.add(UtilBean.getMyLabel(LabelConstants.PENDING_REQUESTS));
        options.add(UtilBean.getMyLabel(LabelConstants.MY_STOCK));

        AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
            if (position == 0) {
                startStockRequestForm();
            } else if (position == 1) {
                callApprovedRequestsApi(true);
            } else if (position == 2) {
                callApprovedRequestsApi(false);
            } else if (position == 3) {
                showAvailableStockDetails();
            }
        };

        ListView buttonList = MyStaticComponents.getButtonList(context, options, onItemClickListener);
        buttonList.setPadding(0, 0, 0, 30);
        bodyLayoutContainer.addView(buttonList);
        footerLayout.setVisibility(View.GONE);
        hideProcessDialog();
    }

    @Background
    public void showAvailableStockDetails() {
        try {
            stockInventoryBean = stockInventoryBeanDao.queryBuilder().query();
            showMyStockScreen(stockInventoryBean);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    @Background
    public void callApprovedRequestsApi(boolean isApproved) {
        try {
            if (SharedStructureData.sewaService.isOnline()) {
                stockManagementDataBeans = sewaServiceRestClient.getStockManagementDataBeans(SewaTransformer.loginBean.getUserID(), isApproved);
                showRequestsScreen(stockManagementDataBeans);
            } else {
                showAlert(LabelConstants.NETWORK, LabelConstants.INTERNET_CONNECTION_REQUIRED_FOR_FETCHING_DATA, null, DynamicUtils.BUTTON_OK);
            }
        } catch (RestHttpException e) {
            e.printStackTrace();
            runOnUiThread(() -> {
                SewaUtil.generateToast(context, LabelConstants.SOME_ERROR_OCCURRED_PLEASE_TRY_AGAIN);
                hideProcessDialog();
            });
        }
    }

    @UiThread
    public void showRequestsScreen(List<StockManagementDataBean> stockManagementDataBeans) {
        bodyLayoutContainer.removeAllViews();
        screen = REQUEST_SCREEN;
        if (stockManagementDataBeans != null && !stockManagementDataBeans.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.REQUESTS);
            bodyLayoutContainer.addView(pagingHeaderView);

            List<ListItemDataBean> requestList = getRequestList(stockManagementDataBeans);
            AdapterView.OnItemClickListener onItemClickListener = (parent, view, position, id) -> {
                selectedItemIndex = position;
                ListItemDataBean itemDataBean = requestList.get(selectedItemIndex);
                showAlertForConsent(itemDataBean);
            };

            pagingListView = MyStaticComponents.getPaginatedListViewWithItem(context, requestList, R.layout.listview_stock_chip, onItemClickListener, null);
            bodyLayoutContainer.addView(pagingListView);
        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }
        hideProcessDialog();

    }

    @UiThread
    public void showMyStockScreen(List<StockInventoryBean> stockInventoryBeans) {
        bodyLayoutContainer.removeAllViews();
        screen = MY_STOCK_SCREEN;
        if (stockInventoryBeans != null && !stockInventoryBeans.isEmpty()) {
            pagingHeaderView = MyStaticComponents.getListTitleView(this, LabelConstants.MY_STOCK);
            pagingHeaderView.setGravity(Gravity.CENTER);
            bodyLayoutContainer.addView(pagingHeaderView);

            TableRow.LayoutParams layoutParams = new TableRow.LayoutParams(0, MATCH_PARENT, 1);

            LinearLayout.LayoutParams nameParams = new LinearLayout.LayoutParams(0, WRAP_CONTENT, 4f);
            LinearLayout.LayoutParams qtyParams = new LinearLayout.LayoutParams(0, WRAP_CONTENT, 1f);

            tableLayout = new TableLayout(context);

            LinearLayout nameAndQuantityLabel = getLinearLayout(context, -1, HORIZONTAL,
                    new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

            nameAndQuantityLabel.setWeightSum(5f);

            TableRow rowForLabel = new TableRow(context);

            MaterialTextView textViewForLabel = new MaterialTextView(context);
            textViewForLabel.setPadding(20, 30, 20, 30);
            textViewForLabel.setText(UtilBean.getTitleText(LabelConstants.MEDICINE_NAME));
            textViewForLabel.setLayoutParams(nameParams);
            textViewForLabel.setTypeface(null, Typeface.BOLD);
            textViewForLabel.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
            textViewForLabel.setBackground(ContextCompat.getDrawable(context, R.drawable.border_for_stock));

            MaterialTextView qtyTextViewForLabel = new MaterialTextView(context);
            qtyTextViewForLabel.setPadding(20, 30, 20, 30);
            qtyTextViewForLabel.setText(UtilBean.getTitleText(LabelConstants.DELIVERED_QUANTITY));
            qtyTextViewForLabel.setLayoutParams(qtyParams);
            qtyTextViewForLabel.setTypeface(null, Typeface.BOLD);
            qtyTextViewForLabel.setTextColor(ContextCompat.getColor(context, R.color.colorPrimary));
            qtyTextViewForLabel.setBackground(ContextCompat.getDrawable(context, R.drawable.border_for_stock));


            nameAndQuantityLabel.addView(textViewForLabel);
            nameAndQuantityLabel.addView(qtyTextViewForLabel);

            rowForLabel.addView(nameAndQuantityLabel, layoutParams);
            tableLayout.addView(rowForLabel);
            bodyLayoutContainer.addView(tableLayout);


            for (StockInventoryBean stockInventoryBean : stockInventoryBeans) {
                tableLayout = new TableLayout(context);
                LinearLayout nameAndQuantity = getLinearLayout(context, -1, HORIZONTAL,
                        new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

                nameAndQuantity.setWeightSum(5f);

                TableRow row = new TableRow(context);

                MaterialTextView textView = new MaterialTextView(context);
                textView.setText(UtilBean.getMyLabel(fhsService.getValueOfListValuesById(String.valueOf(stockInventoryBean.getMedicineId()))));
                textView.setPadding(20, 30, 20, 30);
                textView.setLayoutParams(nameParams);
                textView.setTextColor(ContextCompat.getColor(context, R.color.black));
                textView.setBackground(ContextCompat.getDrawable(context, R.drawable.border_for_stock));

                MaterialTextView qtyTextView = new MaterialTextView(context);
                qtyTextView.setText(stockInventoryBean.getDeliveredQuantity() - stockInventoryBean.getUsed() > 0 ? String.valueOf(stockInventoryBean.getDeliveredQuantity() - stockInventoryBean.getUsed()) : "0");
                qtyTextView.setPadding(20, 30, 20, 30);
                qtyTextView.setLayoutParams(qtyParams);
                qtyTextView.setTextColor(ContextCompat.getColor(context, R.color.black));
                qtyTextView.setBackground(ContextCompat.getDrawable(context, R.drawable.border_for_stock));

                nameAndQuantity.addView(textView);
                nameAndQuantity.addView(qtyTextView);

                row.addView(nameAndQuantity, layoutParams);
                tableLayout.addView(row);
                bodyLayoutContainer.addView(tableLayout);
            }

        } else {
            bodyLayoutContainer.removeView(pagingHeaderView);
            noMemberAvailableView = MyStaticComponents.generateInstructionView(this, LabelConstants.NO_RECORDS_FOUND);
            bodyLayoutContainer.addView(noMemberAvailableView);
        }
        hideProcessDialog();
    }


    private List<ListItemDataBean> getRequestList(List<StockManagementDataBean> stockManagementDataBeans) {
        List<ListItemDataBean> list = new ArrayList<>();

        for (StockManagementDataBean stockManagementDataBean : stockManagementDataBeans) {
            list.add(new ListItemDataBean(stockManagementDataBean.getMedicineId(),
                    UtilBean.getMyLabel(fhsService.getValueOfListValuesById(stockManagementDataBean.getMedicineId().toString())),
                    String.valueOf(stockManagementDataBean.getMedicineQuantity()),
                    stockManagementDataBean.getApprovedQuantity() != null
                            ? String.valueOf(stockManagementDataBean.getApprovedQuantity())
                            : "N/A",
                    String.valueOf(stockManagementDataBean.getApprovedBy()),
                    stockManagementDataBean.getApprovedOn() != null
                            ? sdfForDisplay.format(stockManagementDataBean.getApprovedOn())
                            : "N/A",
                    stockManagementDataBean.getStatus() != null
                            ? stockManagementDataBean.getStatus()
                            : "N/A",
                    String.valueOf(stockManagementDataBean.getId())));
        }
        return list;
    }


    private void showAlertForConsent(ListItemDataBean item) {
        View.OnClickListener listener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                showProcessDialog();
                callStockDeliveredStatusApi(Integer.valueOf(item.getRequestId()), item.getMedicineId());
            } else {
                alertDialog.dismiss();
            }
        };


        alertDialog = new MyAlertDialog(this,
                "Click on Yes if you have received this medicine.",
                listener, DynamicUtils.BUTTON_YES_NO);
        alertDialog.show();
    }

    @Background
    public void callStockDeliveredStatusApi(Integer reqId, Integer medicineId) {
        try {
            if (SharedStructureData.sewaService.isOnline()) {
                sewaServiceRestClient.markStockStatusAsDelivered(reqId, medicineId, SewaTransformer.loginBean.getUserID());
//                callApprovedRequestsApi(false);
                hideProcessDialog();
                doUpdate(false);

            } else {
                showAlert(LabelConstants.NETWORK, LabelConstants.INTERNET_CONNECTION_REQUIRED_FOR_FETCHING_DATA, null, DynamicUtils.BUTTON_OK);
            }
        } catch (RestHttpException e) {
            e.printStackTrace();
            runOnUiThread(() -> {
                SewaUtil.generateToast(context, LabelConstants.SOME_ERROR_OCCURRED_PLEASE_TRY_AGAIN);
                hideProcessDialog();
            });
        }

    }

    private void startStockRequestForm() {
//        showProcessDialog();
        myIntent = new Intent(this, DynamicFormActivity_.class);
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context);
        sharedPreferences.edit().clear().apply();

        SharedStructureData.relatedPropertyHashTable.clear();
        SharedStructureData.membersUnderTwenty.clear();
        SharedStructureData.selectedHealthInfra = null;
        SharedStructureData.highRiskConditions.clear();

        HealthInfrastructureBean healthInfraBean = healthInfrastructureService.retrieveHealthInfrastructureAssignedToUser(SewaTransformer.loginBean.getUserID());
        if (healthInfraBean != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "1");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, String.valueOf(healthInfraBean.getActualId()));
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_NAME, String.valueOf(healthInfraBean.getName()));
        } else {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.IS_DEFAULT_HEALTH_INFRA_ASSIGNED, "2");
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.USER_ASSIGNED_HEALTH_INFRA_ID, null);
        }

        if (SewaTransformer.loginBean.getFirstName() != null) {
            SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.BENEFICIARY_NAME_FOR_LOG, "Request from " + SewaTransformer.loginBean.getFirstName());
        }

        String nextEntity = FormConstants.STOCK_MANAGEMENT;
        myIntent.putExtra(SewaConstants.ENTITY, nextEntity);
        startActivityForResult(myIntent, ActivityConstants.STOCK_MANAGEMENT_ACTIVITY_RESULT);
//        showProcessDialog();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        IntentResult resultForQRScanner = IntentIntegrator.parseActivityResult(requestCode, resultCode, data);
        super.onActivityResult(requestCode, resultCode, data);
        footerLayout.setVisibility(View.VISIBLE);

        if (requestCode == ActivityConstants.STOCK_MANAGEMENT_ACTIVITY_RESULT) {
            addStockRequestScreen();
            if (resultCode == RESULT_OK) {
                if (SharedStructureData.sewaService.isOnline()) {
                    doUpdate(false);
                }
            }
            hideProcessDialog();
        } else if (requestCode == ActivityConstants.LOCATION_SELECTION_ACTIVITY_REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                locationId = data.getStringExtra(FieldNameConstants.LOCATION_ID);
                showProcessDialog();
                addStockRequestScreen();
            } else {
                finish();
            }
        } else if (resultForQRScanner != null) {
            if (resultForQRScanner.getContents() == null) {
                SewaUtil.generateToast(this, LabelConstants.FAILED_TO_SCAN_QR);
            } else {
                qrScanFilter = SewaUtil.setQrScanFilterData(resultForQRScanner.getContents());
            }
        }
    }


    @Override
    public void onBackPressed() {
        View.OnClickListener myListener = v -> {
            if (v.getId() == BUTTON_POSITIVE) {
                alertDialog.dismiss();
                navigateToHomeScreen(false);
                finish();
            } else {
                alertDialog.dismiss();
            }
        };

        alertDialog = new MyAlertDialog(this,
                LabelConstants.CLOSE_FAMILY_FOLDER,
                myListener, DynamicUtils.BUTTON_YES_NO);
        alertDialog.show();
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        super.onOptionsItemSelected(item);

        if (screen == null || screen.isEmpty()) {
            navigateToHomeScreen(false);
            return true;
        }

        if (item.getItemId() == android.R.id.home) {
            footerLayout.setVisibility(View.VISIBLE);
            switch (screen) {
                case STOCK_REQUEST_SCREEN:
                    startLocationSelectionActivity();
                    break;
                case REQUEST_SCREEN:
                case MY_STOCK_SCREEN:
                    addStockRequestScreen();
                    break;

                default:
                    finish();
                    break;
            }
        }
        return true;
    }

    @Override
    public boolean onPrepareOptionsMenu(Menu menu) {
        menu.findItem(R.id.menu_refresh).setVisible(true);
        menu.findItem(R.id.menu_announcement).setVisible(false);
        menu.findItem(R.id.menu_about).setVisible(false);
        return true;
    }
}
