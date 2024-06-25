package com.argusoft.imtecho.spreadsheetloader.location;

import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.location.model.LocationMaster;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiWorksheetReader;

import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import common.Logger;

/**
 * <p>
 *     Defines methods for location work sheet.
 * </p>
 * @author avani
 * @since 07/09/2020 10:30
 */
public abstract class LocationWorkSheetImpl {

    public static final Logger logger = Logger.getLogger(LocationWorkSheetImpl.class);

    protected PoiWorksheetReader wsReader = null;

    // Map Container to store Location object
    protected Map<String, LocationMaster> locationMap = new LinkedHashMap<>();

    // Map Container to store row and column number of location object
    protected Map<String, List<Integer>> rowIndexMap = new LinkedHashMap<>();

    // Map Container to store row and column number when error occured
    protected Map<String, Map<Integer, List<String>>> rowColumnMap = null;

    protected Map<LocationResultEnum, AtomicInteger> results = new LinkedHashMap<>();

    public String errorMessageCount = null;

    private LocationMasterDao locationDao = null;

    private LocationLevelHierarchyDao locationLevelDao = null;

    private Set<Integer> skipLocation = new HashSet<>();
    
    /**
     * Create work sheet instance using work sheet name.
     * @param workSheetName Work sheet name.
     * @return LocationWorkSheetImpl Returns instance of LocationWorkSheetImpl.
     */
    public static LocationWorkSheetImpl getWorkSheetInstance(String workSheetName) {

        String lowerWsName = workSheetName.toLowerCase();
        if (lowerWsName.endsWith(LocationConstants.RURAL)) {
            return new RuralWorksheetImpl(workSheetName);
        } else if (lowerWsName.endsWith(LocationConstants.URBAN)) {
            return new UrbanWorksheetImpl(workSheetName);
        } else if (lowerWsName.endsWith(LocationConstants.NAGARPALIKA)) {
            return new NagarpalikaWorksheetImpl(workSheetName);
        }

        return null;

    }
    
    /**
     * Check if location key is exists in location map or not
     * @param locationKey Location key.
     * @return Returns instance of TreeSet.
     */
    public SortedSet<String> isKeyExistInLocationMap(String locationKey) {

        TreeSet<String> treeSet = new TreeSet<>((o1, o2) -> {

            int oc1 = Integer.parseInt(o1.split("_")[2]);
            int oc2 = Integer.parseInt(o2.split("_")[2]);

            return oc1 - oc2;
        });

        Set<String> mapKeys = locationMap.keySet();

        for (String mapKey : mapKeys) {
            if (mapKey.startsWith(locationKey)) {
                treeSet.add(mapKey);
            }
        }

        return treeSet;
    }

    /**
     * Check whole location level hierarchy before add in map
     *
     * @param existsLocation Exists location details.
     * @param parentLocation Parent location details.
     * @param index Index of location.
     * @return boolean Returns true/false based on level hierarchy.
     */
    public boolean checkForLevelHierarchy(LocationMaster existsLocation, LocationMaster[] parentLocation, int index) {
        LocationMaster parent = parentLocation[index];

        if (existsLocation != null && existsLocation.getParentMasterForImport() != null && parent != null && parent.getParentMasterForImport() != null) {

            if (!existsLocation.getParentMasterForImport().getName().equalsIgnoreCase(parent.getName())) {

                return true;

            } else {
                return checkForLevelHierarchy(existsLocation.getParentMasterForImport(), parentLocation, index - 1);

            }
        }

        return false;
    }

    /**
     * Print location hierarchy when any error occurred in parse location
     *
     * @param locationKey Location key.
     * @param index Index of location.
     * @param parentLocation Parent location details.
     * @return Returns hierarchy string.
     */
    public String printLocationHierarchy(String locationKey, int index, LocationMaster[] parentLocation) {

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < index; i++) {

            if (parentLocation[i] != null) {
                sb.append(parentLocation[i].getName());
            } else {
            }
            sb.append(">");

        }
        sb.append(locationKey.split("_")[0]);

        return sb.toString();
    }

    /**
     * Increment result counter values
     *
     * @param results Map of location enum result.
     * @param result Location result.
     */
    public void increment(Map<LocationResultEnum, AtomicInteger> results, LocationResultEnum result) {
        AtomicInteger count = results.get(result);
        if (count == null) {
            count = new AtomicInteger();
            results.put(result, count);
        }
        count.incrementAndGet();
    }
    
    /**
     * Set error style for cell
     * @param outCell Output cell.
     * @param inCell  Input cell.
     */
    public void setErrorCellStyle(XSSFCell outCell, XSSFCell inCell) {

        XSSFCellStyle newCellStyle = outCell.getSheet().getWorkbook().createCellStyle();

        if (inCell != null) {
            newCellStyle.cloneStyleFrom(inCell.getCellStyle());
        }

        newCellStyle.setFillForegroundColor(IndexedColors.RED.getIndex());
        newCellStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

        outCell.setCellStyle(newCellStyle);

    }
    
    /**
     * Check cell type and set its value
     *
     * @param outCell Output cell.
     * @param cell Cell.
     */
    public void setCellValue(XSSFCell outCell, XSSFCell cell) {

        switch (cell.getCellType()) {
            case HSSFCell.CELL_TYPE_FORMULA:
                outCell.setCellFormula(cell.getCellFormula());
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                outCell.setCellValue(cell.getNumericCellValue());
                break;
            case HSSFCell.CELL_TYPE_STRING:
                outCell.setCellValue(cell.getStringCellValue());
                break;
            case HSSFCell.CELL_TYPE_BLANK:
                outCell.setCellType(HSSFCell.CELL_TYPE_BLANK);
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                outCell.setCellValue(cell.getBooleanCellValue());
                break;
            case HSSFCell.CELL_TYPE_ERROR:
                outCell.setCellErrorValue(cell
                        .getErrorCellValue());
                break;
            default:
                outCell.setCellValue(cell.getStringCellValue());
                break;
        }

    }

    /**
     * Create list for location level hierarchy id.
     *
     * @param location Location details.
     * @param locationIds List of location ids.
     */
    public void getLocationLevelHierarchy(LocationMaster location, List<Integer> locationIds) {

        if (location.getParentMasterForImport() != null) {

            locationIds.add(location.getParentMasterForImport().getId());
            getLocationLevelHierarchy(location.getParentMasterForImport(), locationIds);
        } else {
            List<LocationMaster> state = this.locationDao.getLocationsByLocationType(LocationConstants.LocationType.STATE.getType(), true);
            
             if (state != null && !state.isEmpty()) {
                for (LocationMaster stateLocation : state) {

                    String stateName = stateLocation.getName();
                    if (LocationConstants.GUJARAT_STATE_ENGLISH.equalsIgnoreCase(stateName) || LocationConstants.GUJARAT_STATE_GUJARATI.equals(stateName)) {
                        locationIds.add(state.get(0).getId());
                    }

                }

            }

        }

    }

    /**
     * Create object for location level hierarchy
     *
     * @param location Location details.
     * @param locationIds List of location ids.
     * @return Returns locationLevelHierarchy.
     * @throws Exception Define exception.
     */
    public LocationLevelHierarchy createLocationLevelHierarchy(LocationMaster location, List<Integer> locationIds) throws Exception {

        LocationLevelHierarchy levelHierarchy = new LocationLevelHierarchy();

        try {
            levelHierarchy.setLocationId(location.getId());
            levelHierarchy.setIsActive(true);
            levelHierarchy.setLocationType(location.getType());

            if (locationIds != null) {
                for (int i = locationIds.size() - 1, level = 1; i >= 0; i--, level++) {

                    String propertyName = LocationConstants.LEVEL_PROPERTY + level;
                    String setterName = LocationConstants.SETTER_METHOD_PREFIX + propertyName.substring(0, 1).toUpperCase() + propertyName.substring(1);

                    levelHierarchy
                            .getClass().getMethod(setterName, Integer.class
                            ).invoke(levelHierarchy, locationIds.get(i));
                }
            }
        } catch (NoSuchMethodException | SecurityException | IllegalAccessException | IllegalArgumentException | InvocationTargetException ex) {
            logger.error("Problem occured while create location level hierarchy");
            throw ex;

        }

        return levelHierarchy;

    }

    /**
     * Print location hierarchy when any error occurred in parse location
     * @param location Location details.
     * @param sb Instance of StringBuilder.
     * @return Returns string location hierarchy.
     */
    public String printLocationHierarchy(LocationMaster location, StringBuilder sb) {
       if (location.getParentMasterForImport() != null) {
            sb.append(location.getParentMasterForImport().getName());
            sb.append(">");
            printLocationHierarchy(location.getParentMasterForImport(), sb);
        }
        return sb.toString();

    }

    /**
     * Add not null element.
     * @param id Location id.
     * @param levelHierarchyList Location level hierarchy list.
     */
    public void addNotNullElement(Integer id, List<Integer> levelHierarchyList) {
        if (id != null) {
            levelHierarchyList.add(id);
        }
    }

    /**
     * Find parent location key from location map
     * @param locationKey Location key.
     * @param locationMap Map of location.
     * @return Returns string location key
     */
    public String findParentLocationKeyInMap(String locationKey, Map<String, LocationMaster> locationMap) {

        TreeSet<String> treeSet = new TreeSet<>((o1, o2) -> {

            int oc1 = Integer.parseInt(o1.split("_")[2]);
            int oc2 = Integer.parseInt(o2.split("_")[2]);

            return oc1 - oc2;
        });

        Set<String> mapKeys = locationMap.keySet();

        for (String mapKey : mapKeys) {
            if (mapKey.startsWith(locationKey)) {
                treeSet.add(mapKey);
            }
        }

        return treeSet.last();
    }

    /**
     * Load locations.
     */
    public abstract void loadLocations();

    /**
     * Identify parent.
     * @param errorlocationType Error in location type.
     * @param locationType Location type.
     * @return Returns true/false based on identify parent.
     */
    public abstract boolean identifyParent(String errorlocationType, String locationType);

    /**
     * Retrieves filtered work book.
     * @param sheet XSSF sheet.
     * @param outWorkbook XSS out work book.
     * @param value Value.
     * @return Returns XSSFWorkbook.
     */
    public abstract XSSFWorkbook getFilteredWorkBook(XSSFSheet sheet, XSSFWorkbook outWorkbook, Map<String, Map<Integer, List<String>>> value);

    /**
     * Insert location.
     * @param errorRowMap Map in error row.
     */
    public abstract void insertLocations(Map<String, Map<String, Map<Integer, List<String>>>> errorRowMap);

    /**
     * Retrieves work sheet hierarchy.
     * @return Returns work sheet hierarchy.
     */
    public abstract String getWorkSheetHierarchy();

    public void setWsReader(PoiWorksheetReader wsReader) {
        this.wsReader = wsReader;
    }

    public void setErrorMessageCount(String errorMessageCount) {
        this.errorMessageCount = errorMessageCount;
    }

    public Map<String, LocationMaster> getLocationMap() {
        return locationMap;
    }

    public Map<String, List<Integer>> getRowIndexMap() {
        return rowIndexMap;
    }

    public Map<String, Map<Integer, List<String>>> getErrorDetailMap() {
        return rowColumnMap;
    }

    public Map<LocationResultEnum, AtomicInteger> getResults() {
        return results;
    }

    public void setLocationDao(LocationMasterDao locationDao) {
        this.locationDao = locationDao;
    }

    public LocationMasterDao getLocationDao() {
        return locationDao;
    }

    public LocationLevelHierarchyDao getLocationLevelDao() {
        return locationLevelDao;
    }

    public void setLocationLevelDao(LocationLevelHierarchyDao locationLevelDao) {
        this.locationLevelDao = locationLevelDao;
    }

    public Set<Integer> getSkipLocation() {
        return skipLocation;
    }

}
