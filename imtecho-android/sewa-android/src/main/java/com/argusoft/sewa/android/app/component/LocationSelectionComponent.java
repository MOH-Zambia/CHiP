package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.content.Context;
import android.view.View;
import android.widget.AdapterView;
import android.widget.LinearLayout;
import android.widget.Spinner;

import com.argusoft.sewa.android.app.core.LocationMasterService;
import com.argusoft.sewa.android.app.model.LocationMasterBean;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.textview.MaterialTextView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Defines methods for LocationSelectionComponent
 *
 * @author prateek
 * @since 29/05/23 2:39 pm
 */
public class LocationSelectionComponent extends LinearLayout implements AdapterView.OnItemSelectedListener {

    private final LocationMasterService locationService;
    private List<LocationMasterBean> locationBeans;
    private final Map<Integer, List<LocationMasterBean>> locationMap = new HashMap<>();
    private final Map<Integer, Spinner> spinnerMap = new HashMap<>();
    private final Map<Integer, MaterialTextView> selectTextViewMap = new HashMap<>();
    private LocationMasterBean selectedLocation;
    private final List<String> maxLevel;
    private final LinearLayout bodyLayoutContainer;


    public LocationSelectionComponent(Context context, LocationMasterService locationService, List<String> maxLevel) {
        super(context);
        this.locationService = locationService;
        this.maxLevel = maxLevel;
        this.bodyLayoutContainer = getLocationSelectionView();
        addView(bodyLayoutContainer);
    }

    public LocationSelectionComponent(Context context, LocationMasterService locationService, List<String> maxLevel, boolean fromStart) {
        super(context);
        this.locationService = locationService;
        this.maxLevel = maxLevel;
        if (fromStart) {
            this.bodyLayoutContainer = getLocationSelectionViewFromStart();
        } else {
            this.bodyLayoutContainer = getLocationSelectionView();
        }
        addView(bodyLayoutContainer);
    }

    private LinearLayout getLocationSelectionView() {
        LinearLayout mainLayout = MyStaticComponents.getLinearLayout(getContext(), -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        locationBeans = locationService.retrieveLocationMastersAssignedToUser();
        if (locationBeans.isEmpty()) {
            mainLayout.addView(MyStaticComponents.generateInstructionView(getContext(), "No location found. Please refresh and try again"));
            locationService.clearLocationMasterTable();
        } else {
            addLocationSpinner(mainLayout);
        }
        return mainLayout;
    }

    private LinearLayout getLocationSelectionViewFromStart() {
        LinearLayout mainLayout = MyStaticComponents.getLinearLayout(getContext(), -1, VERTICAL, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));

        locationBeans = locationService.getLocationWithNoParent();
        if (locationBeans.isEmpty()) {
            mainLayout.addView(MyStaticComponents.generateInstructionView(getContext(), "No location found. Please refresh and try again"));
            locationService.clearLocationMasterTable();
        } else {
            addLocationSpinner(mainLayout);
        }
        return mainLayout;
    }

    public void addLocationSpinner(LinearLayout bodyLayoutContainer) {
        String locationType = null;
        String[] arrayOfOptions = new String[locationBeans.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
        int i = 1;
        for (LocationMasterBean locationBean : locationBeans) {
            locationType = locationBean.getType();
            arrayOfOptions[i] = locationBean.getName();
            i++;
        }

        Integer level = locationService.getLocationLevelByType(locationBeans.get(0).getType());
        locationMap.put(level, locationBeans);

        Spinner spinner = MyStaticComponents.getSpinner(getContext(), arrayOfOptions, 0, level);
        spinner.setOnItemSelectedListener(this);

        String name = locationService.getLocationTypeNameByType(locationType);
        MaterialTextView selectTextView = MyStaticComponents.generateQuestionView(null, null, getContext(), "Select " + name);
        bodyLayoutContainer.addView(selectTextView);
        bodyLayoutContainer.addView(spinner);
        spinnerMap.put(level, spinner);
        selectTextViewMap.put(level, selectTextView);
    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        int level = parent.getId();

        if (position == 0) {
            selectedLocation = null;
            removeSpinners(level);
            return;
        }

        List<LocationMasterBean> locationMasterBeans = locationMap.get(level);
        if (locationMasterBeans == null || locationMasterBeans.isEmpty()) {
            return;
        }

        LocationMasterBean locationBean = locationMasterBeans.get(position - 1);

        List<LocationMasterBean> locationMasterBeanList = null;
        if (maxLevel == null || maxLevel.isEmpty() || !maxLevel.contains(locationBean.getType())) {
            locationMasterBeanList = locationService.retrieveLocationMasterBeansByLevelAndParent(null, locationBean.getActualID());
        }

        if (locationMasterBeanList == null || locationMasterBeanList.isEmpty()) {
            selectedLocation = locationBean;
            return;
        }

        selectedLocation = null;
        locationMap.put(level + 1, locationMasterBeanList);
        removeSpinners(level);

        String locationType = null;
        String[] arrayOfOptions = new String[locationMasterBeanList.size() + 1];
        arrayOfOptions[0] = UtilBean.getMyLabel(GlobalTypes.SELECT);
        int i = 1;
        for (LocationMasterBean location : locationMasterBeanList) {
            locationType = location.getType();
            arrayOfOptions[i] = location.getName();
            i++;
        }
        Spinner spinner = MyStaticComponents.getSpinner(getContext(), arrayOfOptions, 0, level + 1);
        spinner.setOnItemSelectedListener(this);

        String name = locationService.getLocationTypeNameByType(locationType);
        MaterialTextView selectTextView = MyStaticComponents.generateSubTitleView(getContext(), "Select " + name);
        bodyLayoutContainer.addView(selectTextView);
        bodyLayoutContainer.addView(spinner);
        spinnerMap.put(level + 1, spinner);
        selectTextViewMap.put(level + 1, selectTextView);
    }

    @Override
    public void onNothingSelected(AdapterView<?> parent) {
        //
    }

    private void removeSpinners(Integer level) {
        for (Map.Entry<Integer, List<LocationMasterBean>> entry : locationMap.entrySet()) {
            if (entry.getKey() > level) {
                bodyLayoutContainer.removeView(selectTextViewMap.get(entry.getKey()));
                bodyLayoutContainer.removeView(spinnerMap.get(entry.getKey()));
            }
        }
    }

    public LocationMasterBean getSelectedLocation() {
        return selectedLocation;
    }
}
