package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.constants.FormulaConstants;
import com.argusoft.sewa.android.app.constants.IdConstants;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RchConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.ValidationTagBean;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.HealthInfrastructureBean;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;

public class TypeHealthInfrastructureComponent extends LinearLayout implements AdapterView.OnItemSelectedListener {

    private final Context context;
    private final QueFormBean queFormBean;
    private final LinearLayout healthInfraComponent;
    private final LinearLayout typeSelectionLayout;
    private final Spinner typeSpinner;
    private TextView infraSelectionTextView;
    private Spinner infraSelectionSpinner;
    private MaterialTextView noInfraTextView;
    private LocationMasterBean selectedLocation = null;
    private TextView hierarchyTextView;
    private LinearLayout hierarchyLayout;
    private final Collator collator = Collator.getInstance(new Locale("hi", "IN"));
    private final Map<Integer, List<LocationMasterBean>> levelLocationListMap = new HashMap<>();
    private final Map<Integer, LocationMasterBean> levelSelectedLocationMap = new HashMap<>();
    private final Map<Integer, MaterialTextView> levelSelectLocationQueMap = new HashMap<>();
    private final Map<Integer, Spinner> levelSpinnerMap = new HashMap<>();
    private List<HealthInfrastructureBean> infrastructureBeans = new ArrayList<>();
    private final Handler uiHandler;
    private final Handler backgroundHandler;
    private final Map<Long, String> infraTypeMap;
    private Long selectedInfraTypeId;
    private List<Integer> locationLevels = new ArrayList<>();
    private MyProcessDialog processDialog;

    public TypeHealthInfrastructureComponent(Context context, QueFormBean queFormBean) {
        super(context);
        this.context = context;
        this.queFormBean = queFormBean;

        uiHandler = new Handler(Looper.getMainLooper());
        HandlerThread handlerThread = new HandlerThread("HandlerThread");
        handlerThread.start();
        backgroundHandler = new Handler(handlerThread.getLooper());

        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        healthInfraComponent = getLinearLayout(context, IdConstants.HEALTH_INFRA_MAIN_LAYOUT_ID, VERTICAL, layoutParams);


        infraTypeMap = SharedStructureData.healthInfrastructureService.retrieveDistinctHealthInfraType();


        String[] arrayOfOptions = new String[infraTypeMap.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
        int count = 1;
        for (Map.Entry<Long, String> entry : infraTypeMap.entrySet()) {
            arrayOfOptions[count] = entry.getValue();
            count++;
        }

        typeSelectionLayout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.health_infra_type_selection_layout, null);

        typeSpinner = MyStaticComponents.getSpinner(context, arrayOfOptions, 0,
                IdConstants.HEALTH_INFRA_TYPE_SELECTION_SPINNER_ID);

        LinearLayout infraTypeLayout = typeSelectionLayout.findViewById(R.id.infraTypeLayout);
        infraTypeLayout.addView(typeSpinner);

        ImageButton attributeButton = typeSelectionLayout.findViewById(R.id.infraAttributeButton);

        typeSpinner.setOnItemSelectedListener(this);
//        attributeButton.setOnClickListener(getAttributeButtonClickListener(attribute));
        attributeButton.setVisibility(GONE);


        healthInfraComponent.addView(typeSelectionLayout);
        this.addView(healthInfraComponent);
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        queFormBean.setAnswer(null);

        healthInfraComponent.removeAllViews();
        healthInfraComponent.addView(MyStaticComponents.generateQuestionView(
                null, null, context, LabelConstants.SELECT_HEALTH_INFRASTRUCTURE_TYPE));
        healthInfraComponent.addView(typeSelectionLayout);

        if (!typeSpinner.getSelectedItem().equals(UtilBean.getMyLabel(GlobalTypes.SELECT))
                && !typeSpinner.getSelectedItem().equals(GlobalTypes.SELECT)) {
            for (Map.Entry<Long, String> entry : infraTypeMap.entrySet()) {
                if (entry.getValue().equals(typeSpinner.getSelectedItem())) {
                    selectedInfraTypeId = entry.getKey();
                    locationLevels = SharedStructureData.healthInfraTypeLocationService.retrieveLocationLevelsById(entry.getKey());
                    Log.i(getClass().getSimpleName(), "Selected Health Infrastructure Type : " + entry.getKey() + " : : " + entry.getValue());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HEALTH_INFRASTRUCTURE_TYPE, entry.getValue());
                    SharedStructureData.relatedPropertyHashTable.put(RelatedPropertyNameConstants.HEALTH_INFRASTRUCTURE_TYPE_ID, entry.getKey().toString());
                    break;
                }
            }
            String validationMessage = null;
            if (queFormBean.getValidations() != null) {
                for (ValidationTagBean validation : queFormBean.getValidations()) {
                    if (validation.getMethod().contains("-")) {
                        String[] split = validation.getMethod().split("-");
                        if (split[0].equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_SERVICE_DATE_FOR_HEALTH_INFRA)) {
                            ArrayList<ValidationTagBean> validationTagBeans = new ArrayList<>();
                            validationTagBeans.add(validation);
                            validationMessage = DynamicUtils.checkValidation(selectedInfraTypeId.toString(), 0, validationTagBeans);
                        }
                    } else if (validation.getMethod().equalsIgnoreCase(FormulaConstants.VALIDATION_CHECK_SERVICE_DATE_FOR_HEALTH_INFRA)) {
                        ArrayList<ValidationTagBean> validationTagBeans = new ArrayList<>();
                        validationTagBeans.add(validation);
                        validationMessage = DynamicUtils.checkValidation(selectedInfraTypeId.toString(), 0, validationTagBeans);
                    }
                }
            }
            if (validationMessage != null) {
                SewaUtil.generateToast(SharedStructureData.context, validationMessage);
            } else {
                resetAllViews();
//                addHierarchyLayoutForInfrastructure();
                retrieveInfrastructureByLocationFromDB();
//                setSearchTypeView();
            }
        }
    }

    private void resetAllViews() {
        hierarchyTextView = null;
        hierarchyLayout = null;
        infraSelectionTextView = null;
        infraSelectionSpinner = null;
        noInfraTextView = null;
        selectedLocation = null;
        levelLocationListMap.clear();
        levelSelectedLocationMap.clear();
        levelSpinnerMap.clear();
        levelSelectLocationQueMap.clear();
        infrastructureBeans.clear();
    }

    private void addHierarchyLayoutForInfrastructure() {
        healthInfraComponent.removeView(hierarchyTextView);
        healthInfraComponent.removeView(hierarchyLayout);
//        healthInfraComponent.removeView(searchInfraTextView);
//        healthInfraComponent.removeView(searchInfraEditText);

        if (hierarchyTextView == null) {
            hierarchyTextView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.SELECT_HIERARCHY_FOR_HEALTH_INFRASTRUCTURE);
        }

        if (hierarchyLayout == null) {
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
            hierarchyLayout = MyStaticComponents.getLinearLayout(context,
                    IdConstants.HEALTH_INFRA_SEARCH_BY_HIERARCHY_LAYOUT_ID,
                    LinearLayout.VERTICAL, layoutParams);
            addSpinnersForLocationHierarchy();
        }

        healthInfraComponent.addView(hierarchyTextView);
        healthInfraComponent.addView(hierarchyLayout);
    }

    private void addSpinnersForLocationHierarchy() {
        levelLocationListMap.clear();
        levelSpinnerMap.clear();
        levelSelectLocationQueMap.clear();
        infrastructureBeans.clear();

        List<LocationMasterBean> locationMasterBeans = SharedStructureData.locationMasterService.getLocationWithNoParent();

        if (locationMasterBeans == null || locationMasterBeans.isEmpty()) {
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "No locations found");
            hierarchyLayout.addView(selectTextView);
            return;
        } else {
            Collections.sort(locationMasterBeans, (o1, o2) -> (UtilBean.getMyLabel(o1.getName()).toLowerCase().compareTo(UtilBean.getMyLabel(o2.getName()).toLowerCase())));
            Collections.sort(locationMasterBeans, (o1, o2) -> collator.compare(UtilBean.getMyLabel(o1.getName()), UtilBean.getMyLabel(o2.getName())));
        }

        String locationType = locationMasterBeans.get(0).getType();
        Integer level = locationMasterBeans.get(0).getLevel();

        String[] arrayOfOptions = new String[locationMasterBeans.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);

        int i = 1;
        for (LocationMasterBean locationBean : locationMasterBeans) {
            arrayOfOptions[i] = locationBean.getName();
            i++;
        }

        levelLocationListMap.put(level, locationMasterBeans);

        Spinner spinner = MyStaticComponents.getSpinner(context, arrayOfOptions, 0, level);
        spinner.setOnItemSelectedListener(getOnItemSelectedListenerForHierarchy());

        String name = SharedStructureData.locationMasterService.getLocationTypeNameByType(locationType);
        MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
        hierarchyLayout.addView(selectTextView);
        hierarchyLayout.addView(spinner);
        levelSpinnerMap.put(level, spinner);
        levelSelectLocationQueMap.put(level, selectTextView);
    }

    private void retrieveInfrastructureByLocationFromDB() {
        queFormBean.setAnswer(null);
//        if (selectedLocation != null && locationLevels.contains(selectedLocation.getLevel())) {
        showProcessDialog();
//            backgroundHandler.post(() -> {
        infrastructureBeans = SharedStructureData.healthInfrastructureService.retrieveHealthInfraByLocationId(null, selectedInfraTypeId, null);
//                uiHandler.post(this::addInfrastructureSelectionLayout);
        addInfrastructureSelectionLayout();
//            });
//        } else {
//            healthInfraComponent.removeView(infraSelectionTextView);
//            healthInfraComponent.removeView(infraSelectionSpinner);
//            healthInfraComponent.removeView(noInfraTextView);
//        }
    }

    private void addInfrastructureSelectionLayout() {
        healthInfraComponent.removeView(infraSelectionTextView);
        healthInfraComponent.removeView(infraSelectionSpinner);
        healthInfraComponent.removeView(noInfraTextView);

        if (selectedInfraTypeId.equals(RchConstants.INFRA_PRIVATE_HOSPITAL)) {
            HealthInfrastructureBean infrastructureBean = new HealthInfrastructureBean();
            infrastructureBean.setActualId(-1L);
            infrastructureBean.setTypeId(RchConstants.INFRA_PRIVATE_HOSPITAL);
            infrastructureBean.setName(UtilBean.getMyLabel(LabelConstants.OTHER));
            infrastructureBeans.add(infrastructureBean);
        }

        if (selectedInfraTypeId.equals(RchConstants.INFRA_TRUST_HOSPITAL)) {
            HealthInfrastructureBean infrastructureBean = new HealthInfrastructureBean();
            infrastructureBean.setActualId(-1L);
            infrastructureBean.setTypeId(RchConstants.INFRA_TRUST_HOSPITAL);
            infrastructureBean.setName(UtilBean.getMyLabel(LabelConstants.OTHER));
            infrastructureBeans.add(infrastructureBean);
        }

        if (infrastructureBeans.isEmpty()) {
            noInfraTextView = MyStaticComponents.generateInstructionView(context, LabelConstants.NO_HEALTH_INFRASTRUCTURE_AVAILABLE_ON_SELECTED_LOCATION);
            healthInfraComponent.addView(noInfraTextView);
            dismissProcessDialog();
            return;
        }

        if (infraSelectionTextView == null) {
            infraSelectionTextView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.SELECT_HEALTH_INFRASTRUCTURE);
        }

        Collections.sort(infrastructureBeans, (o1, o2) -> (UtilBean.getMyLabel(o1.getName()).toLowerCase().compareTo(UtilBean.getMyLabel(o2.getName()).toLowerCase())));
        Collections.sort(infrastructureBeans, (o1, o2) -> collator.compare(UtilBean.getMyLabel(o1.getName()), UtilBean.getMyLabel(o2.getName())));
        String[] arrayOfOptions = new String[infrastructureBeans.size() + 1];
        int defaultIndex = 0;
        if (!infrastructureBeans.isEmpty()) {
            int i = 1;
            arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
            for (HealthInfrastructureBean infrastructureBean : infrastructureBeans) {
                arrayOfOptions[i] = infrastructureBean.getName();
                i++;
            }
        } else {
            arrayOfOptions[0] = UtilBean.getMyLabel(LabelConstants.NO_HEALTH_INFRASTRUCTURE_AVAILABLE);
        }

        infraSelectionSpinner = MyStaticComponents.getSpinner(context, arrayOfOptions, defaultIndex, 1);
        infraSelectionSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if (position != 0) {
                    HealthInfrastructureBean selectedInfra = infrastructureBeans.get(position - 1);
                    Log.i(getClass().getSimpleName(), "Selected Health Infrastructure : " + selectedInfra);
                    queFormBean.setAnswer(selectedInfra.getActualId());
                    SharedStructureData.selectedHealthInfra = selectedInfra;
                } else {
                    queFormBean.setAnswer(null);
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {
                //Do Nothing
            }
        });

        healthInfraComponent.addView(infraSelectionTextView);
        healthInfraComponent.addView(infraSelectionSpinner);

        dismissProcessDialog();
    }

    private AdapterView.OnItemSelectedListener getOnItemSelectedListenerForHierarchy() {
        return new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                Integer currentLevel = parent.getId();
                if (position == 0) {
                    removeSpinners(currentLevel);
                    LocationMasterBean selectedLoc = levelSelectedLocationMap.get(currentLevel);
                    if (selectedLoc != null) {
                        selectedLocation = SharedStructureData.locationMasterService.getLocationMasterBeanByActualId(selectedLoc.getParent());
                        if (selectedLocation != null) {
                            currentLevel = selectedLocation.getLevel();
                        }
                    }
                    levelSelectedLocationMap.remove(currentLevel);
                } else if (Boolean.TRUE.equals(checkLocationLevel(currentLevel))) {
                    removeSpinners(currentLevel);
                    selectedLocation = Objects.requireNonNull(levelLocationListMap.get(currentLevel)).get(position - 1);
                    levelSelectedLocationMap.put(selectedLocation.getLevel(), selectedLocation);
                    addSpinners(selectedLocation);
                } else {
                    removeSpinners(currentLevel);
                    selectedLocation = Objects.requireNonNull(levelLocationListMap.get(currentLevel)).get(position - 1);
                    levelSelectedLocationMap.put(selectedLocation.getLevel(), selectedLocation);
                }

                retrieveInfrastructureByLocationFromDB();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        };
    }

    private void removeSpinners(Integer level) {
        for (Map.Entry<Integer, List<LocationMasterBean>> entry : levelLocationListMap.entrySet()) {
            if (entry.getKey() > level) {
                hierarchyLayout.removeView(levelSelectLocationQueMap.get(entry.getKey()));
                hierarchyLayout.removeView(levelSpinnerMap.get(entry.getKey()));
                levelSelectedLocationMap.remove(entry.getKey());
            }
        }
    }

    private void addSpinners(LocationMasterBean parent) {
        List<LocationMasterBean> locationBeans = SharedStructureData.locationMasterService.retrieveLocationMasterBeansByParent(parent.getActualID().intValue());
        if (!locationBeans.isEmpty()) {

            Collections.sort(locationBeans, (o1, o2) -> (UtilBean.getMyLabel(o1.getName()).toLowerCase().compareTo(UtilBean.getMyLabel(o2.getName()).toLowerCase())));
            Collections.sort(locationBeans, (o1, o2) -> collator.compare(UtilBean.getMyLabel(o1.getName()), UtilBean.getMyLabel(o2.getName())));
            removeSpinners(parent.getLevel());

            Integer newLevel = locationBeans.get(0).getLevel();
            levelLocationListMap.put(newLevel, locationBeans);

            String[] arrayOfOptions = new String[locationBeans.size() + 1];
            arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
            int i = 1;
            for (LocationMasterBean location : locationBeans) {
                arrayOfOptions[i] = location.getName();
                i++;
            }

            Spinner spinner = MyStaticComponents.getSpinner(context, arrayOfOptions, 0, newLevel);
            spinner.setOnItemSelectedListener(getOnItemSelectedListenerForHierarchy());

            String name = SharedStructureData.locationMasterService.getLocationTypeNameByType(locationBeans.get(0).getType());
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name);
            hierarchyLayout.addView(selectTextView);
            hierarchyLayout.addView(spinner);
            levelSpinnerMap.put(newLevel, spinner);
            levelSelectLocationQueMap.put(newLevel, selectTextView);
        } else {
            removeSpinners(parent.getLevel());
        }
    }

    private Boolean checkLocationLevel(Integer currentLevel) {
        if (currentLevel == null) {
            return false;
        }

        Integer maxLevel = null;
        for (Integer level : locationLevels) {
            if (maxLevel == null || maxLevel < level) {
                maxLevel = level;
            }
        }

        return !currentLevel.equals(maxLevel);
    }

    private void showProcessDialog() {
        processDialog = new MyProcessDialog(context, GlobalTypes.MSG_PROCESSING);
        processDialog.show();
    }

    private void dismissProcessDialog() {
        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
        //Do Nothing
    }
}
