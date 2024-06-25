package com.argusoft.sewa.android.app.component.listeners;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.MyProcessDialog;
import com.argusoft.sewa.android.app.component.MyStaticComponents;
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
import com.google.android.material.textfield.TextInputLayout;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.text.Collator;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Timer;
import java.util.TimerTask;

public class HealthInfrastructureComponent extends LinearLayout implements AdapterView.OnItemSelectedListener {

    private static final long DELAY = 1000L;
    private final Context context;
    private final QueFormBean queFormBean;
    private final LinearLayout healthInfraComponent;
    private final LinearLayout typeSelectionLayout;
    private final Spinner typeSpinner;
    private final Map<Long, String> infraTypeMap;

    private MyProcessDialog processDialog;
    private Long selectedInfraTypeId;
    private RadioGroup searchTypeRadioGroup;
    private TextView searchTypeTextView;
    private TextView infraSelectionTextView;
    private Spinner infraSelectionSpinner;
    private MaterialTextView noInfraTextView;
    private TextView searchInfraTextView;
    private TextInputLayout searchInfraEditText;
    private Timer timer = new Timer();
    private TextView hierarchyTextView;
    private LinearLayout hierarchyLayout;

    private List<Integer> locationLevels = new ArrayList<>();
    private final Map<Integer, List<LocationMasterBean>> levelLocationListMap = new HashMap<>();
    private final Map<Integer, LocationMasterBean> levelSelectedLocationMap = new HashMap<>();
    private final Map<Integer, MaterialTextView> levelSelectLocationQueMap = new HashMap<>();
    private final Map<Integer, Spinner> levelSpinnerMap = new HashMap<>();
    private List<HealthInfrastructureBean> infrastructureBeans = new ArrayList<>();
    private final Map<Integer, String> attributeMap = new HashMap<>();
    private final List<String> selectedAttributes = new ArrayList<>();

    private LocationMasterBean selectedLocation = null;
    private final Collator collator = Collator.getInstance(new Locale("hi", "IN"));

    private final Handler uiHandler;
    private final Handler backgroundHandler;

    public HealthInfrastructureComponent(Context context, QueFormBean queFormBean) {
        super(context);
        this.context = context;
        this.queFormBean = queFormBean;

        uiHandler = new Handler(Looper.getMainLooper());
        HandlerThread handlerThread = new HandlerThread("HandlerThread");
        handlerThread.start();
        backgroundHandler = new Handler(handlerThread.getLooper());

        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT);
        healthInfraComponent = getLinearLayout(context, IdConstants.HEALTH_INFRA_MAIN_LAYOUT_ID, VERTICAL, layoutParams);

        Map<String, String> dataMap = new HashMap<>();
        String attribute = null;
        if (queFormBean.getDatamap() != null && !queFormBean.getDatamap().trim().isEmpty()) {
            try {
                dataMap = new Gson().fromJson(queFormBean.getDatamap(), new TypeToken<Map<String, String>>() {
                }.getType());
                if (dataMap.containsKey("attribute")) {
                    attribute = dataMap.get("attribute");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (dataMap.containsKey("type")) {
            infraTypeMap = SharedStructureData.healthInfrastructureService.retrieveDistinctSpecificHealthInfraType(Arrays.asList(dataMap.get("type").split(",")));
        } else {
            infraTypeMap = SharedStructureData.healthInfrastructureService.retrieveDistinctHealthInfraType();
        }

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
        attributeButton.setOnClickListener(getAttributeButtonClickListener(attribute));

        if (attribute == null) {
            attributeButton.setVisibility(GONE);
        }

        healthInfraComponent.addView(typeSelectionLayout);
        this.addView(healthInfraComponent);
    }

    private static String getAttributeLabelFromName(String attribute) {
        switch (attribute) {
            case "isFru":
                return "FRU";
            case "isCmtc":
                return "CMTC";
            case "isNrc":
                return "NRC";
            case "isSncu":
                return "SNCU";
            case "isChiranjeevi":
                return "Chiranjivi";
            case "isBalsaka":
                return "Balsaka";
            case "isPmjy":
                return "PMJAY";
            case "isBloodBank":
                return "Blood Bank";
            case "isGynaec":
                return "Gynaecology";
            case "isPediatrician":
                return "Pediatrician";
            case "isCpConfirmationCenter":
                return "Cerebral Palsy Confirmation Center";
            case "forNcd":
                return "NCD";
            case "isBalsakha1":
                return "Balsakha 1";
            case "isBalsakha3":
                return "Balsakha 3";
            case "isUsgFacility":
                return "Usg Facility";
            case "isReferralFacility":
                return "Referral Facility";
            case "isMaYojna":
                return "Ma Yojna";
            case "isNpcb":
                return "NPCB";
            default:
                return attribute;
        }
    }

    private View.OnClickListener getAttributeButtonClickListener(String attribute) {
        if (attribute == null) {
            return null;
        }
        String[] attributes = attribute.split(",");
        if (attributes.length == 0) {
            return null;
        }

        return view -> {
            attributeMap.clear();
            List<String> previouslySelectedItems = new ArrayList<>(selectedAttributes);

            final String[] listItems = new String[attributes.length];
            for (int i = 0; i < attributes.length; i++) {
                listItems[i] = UtilBean.getMyLabel(getAttributeLabelFromName(attributes[i]));
                attributeMap.put(i, attributes[i]);
            }

            AlertDialog.Builder alertDialog = new AlertDialog.Builder(context);
            alertDialog.setTitle("Select attributes");
            alertDialog.setMultiChoiceItems(
                    listItems, getCheckedItemsFromAttributeList(attributes),
                    (dialogInterface, i, b) -> {
                        if (b) {
                            selectedAttributes.add(attributeMap.get(i));
                        } else {
                            selectedAttributes.remove(attributeMap.get(i));
                        }
                    });
            alertDialog.setPositiveButton(
                    UtilBean.getMyLabel(LabelConstants.OK),
                    (dialogInterface, i) -> {

                    });
            alertDialog.setNegativeButton(
                    UtilBean.getMyLabel(LabelConstants.CANCEL),
                    (dialogInterface, i) -> {
                        selectedAttributes.clear();
                        selectedAttributes.addAll(previouslySelectedItems);
                    });
            alertDialog.show();
        };
    }

    private boolean[] getCheckedItemsFromAttributeList(String[] attributes) {
        if (selectedAttributes.isEmpty()) {
            return null;
        }
        boolean[] checkedItems = new boolean[attributes.length];
        for (int i = 0; i < attributes.length; i++) {
            checkedItems[i] = selectedAttributes.contains(attributes[i]);
        }
        return checkedItems;
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
                setSearchTypeView();
            }
        }
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
        //Do Nothing
    }

    private void resetAllViews() {
        searchTypeTextView = null;
        searchTypeRadioGroup = null;
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

    private void setSearchTypeView() {
        queFormBean.setAnswer(null);
        healthInfraComponent.removeView(infraSelectionTextView);
        healthInfraComponent.removeView(infraSelectionSpinner);
        healthInfraComponent.removeView(noInfraTextView);
        healthInfraComponent.removeView(searchTypeTextView);
        healthInfraComponent.removeView(searchTypeRadioGroup);

        if (searchTypeTextView == null) {
            searchTypeTextView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.CHOOSE_OPTION_TO_SEARCH);
        }

        if (searchTypeRadioGroup == null) {
            searchTypeRadioGroup = new RadioGroup(context);
            searchTypeRadioGroup.setPadding(0, 0, 0, 50);
            RadioButton searchByName = MyStaticComponents.getRadioButton(context, LabelConstants.SEARCH_BY_NAME,
                    IdConstants.HEALTH_INFRA_SEARCH_BY_NAME_RADIO_BUTTON_ID);
            searchTypeRadioGroup.addView(searchByName);
            RadioButton searchByHierarchy = MyStaticComponents.getRadioButton(context, LabelConstants.SEARCH_BY_HIERARCHY,
                    IdConstants.HEALTH_INFRA_SEARCH_BY_HIERARCHY_RADIO_BUTTON_ID);
            searchTypeRadioGroup.addView(searchByHierarchy);

            searchTypeRadioGroup.setOnCheckedChangeListener((group, checkedId) -> {
                queFormBean.setAnswer(null);
                healthInfraComponent.removeView(infraSelectionTextView);
                healthInfraComponent.removeView(infraSelectionSpinner);
                healthInfraComponent.removeView(noInfraTextView);
                if (checkedId == IdConstants.HEALTH_INFRA_SEARCH_BY_NAME_RADIO_BUTTON_ID) {
                    addSearchLayoutForInfrastructure();
                    if (searchInfraEditText.getEditText() != null) {
                        retrieveInfrastructuresBySearchFromDB(searchInfraEditText.getEditText().getText().toString());
                    }
                } else if (checkedId == IdConstants.HEALTH_INFRA_SEARCH_BY_HIERARCHY_RADIO_BUTTON_ID) {
                    addHierarchyLayoutForInfrastructure();
                    retrieveInfrastructureByLocationFromDB();
                }
            });
        }

        healthInfraComponent.addView(searchTypeTextView);
        healthInfraComponent.addView(searchTypeRadioGroup);
    }

    private void addSearchLayoutForInfrastructure() {
        healthInfraComponent.removeView(hierarchyTextView);
        healthInfraComponent.removeView(hierarchyLayout);
        healthInfraComponent.removeView(searchInfraTextView);
        healthInfraComponent.removeView(searchInfraEditText);

        if (searchInfraTextView == null) {
            searchInfraTextView = MyStaticComponents.generateQuestionView(null, null, context, LabelConstants.SEARCH_HEALTH_INFRASTRUCTURE);
        }

        if (searchInfraEditText == null) {
            searchInfraEditText = MyStaticComponents.getEditText(context,
                    UtilBean.getMyLabel(LabelConstants.SEARCH_HEALTH_INFRASTRUCTURE),
                    IdConstants.HEALTH_INFRA_SEARCH_BY_NAME_EDIT_TEXT_ID,
                    100, -1);
            if (searchInfraEditText.getEditText() != null) {
                searchInfraEditText.getEditText().addTextChangedListener(new TextWatcher() {
                    @Override
                    public void beforeTextChanged(CharSequence s, int start, int count, int after) {
                        //Do Nothing
                    }

                    @Override
                    public void onTextChanged(final CharSequence s, int start, int before, int count) {
                        timer.cancel();
                        timer = new Timer();
                        timer.schedule(
                                new TimerTask() {
                                    @Override
                                    public void run() {
                                        if (s != null && s.length() > 2) {
                                            uiHandler.post(() -> {
                                                healthInfraComponent.removeView(infraSelectionTextView);
                                                healthInfraComponent.removeView(infraSelectionSpinner);
                                                healthInfraComponent.removeView(noInfraTextView);
                                                retrieveInfrastructuresBySearchFromDB(s.toString());
                                                searchInfraEditText.setFocusable(true);
                                            });
                                        } else if (s != null && s.length() == 0) {
                                            uiHandler.post(() -> {
                                                healthInfraComponent.removeView(infraSelectionTextView);
                                                healthInfraComponent.removeView(infraSelectionSpinner);
                                                healthInfraComponent.removeView(noInfraTextView);
                                                infrastructureBeans.clear();
                                            });
                                        }
                                    }
                                },
                                DELAY
                        );
                    }

                    @Override
                    public void afterTextChanged(Editable s) {
                        //Do Nothing
                    }
                });
            }
        }

        healthInfraComponent.addView(searchInfraTextView);
        healthInfraComponent.addView(searchInfraEditText);
    }

    private void addHierarchyLayoutForInfrastructure() {
        healthInfraComponent.removeView(hierarchyTextView);
        healthInfraComponent.removeView(hierarchyLayout);
        healthInfraComponent.removeView(searchInfraTextView);
        healthInfraComponent.removeView(searchInfraEditText);

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
        MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name.toLowerCase());
        hierarchyLayout.addView(selectTextView);
        hierarchyLayout.addView(spinner);
        levelSpinnerMap.put(level, spinner);
        levelSelectLocationQueMap.put(level, selectTextView);
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
            MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, context, "Select " + name.toLowerCase());
            hierarchyLayout.addView(selectTextView);
            hierarchyLayout.addView(spinner);
            levelSpinnerMap.put(newLevel, spinner);
            levelSelectLocationQueMap.put(newLevel, selectTextView);
        } else {
            removeSpinners(parent.getLevel());
        }
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

    private String getAttributeStringFromList() {
        StringBuilder sb = new StringBuilder();
        int count = 0;
        for (String str : selectedAttributes) {
            if (count != 0) {
                sb.append(",");
            }
            sb.append(str);
            count++;
        }
        return sb.length() > 0 ? sb.toString() : null;
    }

    private void retrieveInfrastructuresBySearchFromDB(final String search) {
        queFormBean.setAnswer(null);
        if (search != null && search.length() > 2) {
            showProcessDialog();
            backgroundHandler.post(() -> {
                infrastructureBeans = SharedStructureData.healthInfrastructureService.retrieveHealthInfraBySearch(search, selectedInfraTypeId, getAttributeStringFromList());
                uiHandler.post(this::addInfrastructureSelectionLayout);
            });
        }
    }

    private void retrieveInfrastructureByLocationFromDB() {
        queFormBean.setAnswer(null);
        if (selectedLocation != null && locationLevels.contains(selectedLocation.getLevel())) {
            showProcessDialog();
            backgroundHandler.post(() -> {
                infrastructureBeans = SharedStructureData.healthInfrastructureService.retrieveHealthInfraByLocationId(selectedLocation.getActualID(), selectedInfraTypeId, getAttributeStringFromList());
                uiHandler.post(this::addInfrastructureSelectionLayout);
            });
        } else {
            healthInfraComponent.removeView(infraSelectionTextView);
            healthInfraComponent.removeView(infraSelectionSpinner);
            healthInfraComponent.removeView(noInfraTextView);
        }
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

    private void showProcessDialog() {
        processDialog = new MyProcessDialog(context, GlobalTypes.MSG_PROCESSING);
        processDialog.show();
    }

    private void dismissProcessDialog() {
        if (processDialog != null && processDialog.isShowing()) {
            processDialog.dismiss();
        }
    }
}
