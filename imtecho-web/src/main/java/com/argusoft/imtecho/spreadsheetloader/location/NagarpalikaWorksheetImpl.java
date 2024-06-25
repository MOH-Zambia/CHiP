package com.argusoft.imtecho.spreadsheetloader.location;

import com.argusoft.imtecho.location.model.LocationLevelHierarchy;
import com.argusoft.imtecho.location.model.LocationMaster;

import common.Logger;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.dao.DataIntegrityViolationException;

/**
 * <p>
 *     Defines methods for nagar palika work sheet.
 * </p>
 * @author avani
 * @since 07/09/2020 10:30
 */
public class NagarpalikaWorksheetImpl extends LocationWorkSheetImpl {

    public static final Logger logger = Logger.getLogger(NagarpalikaWorksheetImpl.class);

    private String workSheetName;

    private LocationMaster[] parentLocation;

    private LocationConstants.NagarpalikaHeader[] columnNames = null;

    public NagarpalikaWorksheetImpl(String workSheetName) {
        this.workSheetName = workSheetName;
        results.put(LocationResultEnum.ERRORS_ENCOUNTERED, new AtomicInteger());
        results.put(LocationResultEnum.LOCATION_ADDED, new AtomicInteger());
        results.put(LocationResultEnum.SKIP_LOCATION, new AtomicInteger());
    }

    /**
     * Read corporation worksheet and parse location
     */
    @Override
    public void loadLocations() {

        String errorKey = null;
        int rows = wsReader.getEstimatedRows();

        logger.info("Work sheet '" + workSheetName + "' having estimated rows:" + rows);

        //Store index wise location object for identify parent
        parentLocation = new LocationMaster[LocationConstants.NagarpalikaHeader.values().length];
        rowColumnMap = new LinkedHashMap<>();

        //Loop through all row in worksheet
        while (wsReader.nextRow()) {

            // Create Location data
            errorKey = this.renderToLocation(errorKey, rowColumnMap);
            //Skip all row once Trash row is found
            if (LocationConstants.TRASH.equalsIgnoreCase(errorKey)) {
                break;
            }
        }

    }

    /**
     * Fetch value from each row and create location object
     *
     * @param errorKey Error key.
     * @return Returns errorKey
     */
    private String renderToLocation(String errorKey, Map<String, Map<Integer, List<String>>> rowColumnMap) {

        String locationKey = null;
        String locationType;
        String locationCode = null;

        columnNames = LocationConstants.NagarpalikaHeader.values();

        for (int i = 0; i < columnNames.length; i++) {
            try {
                String column = columnNames[i].name();
                String value = wsReader.getValue(column);

                if (value != null) {
                    value = value.trim();

                    if (!value.equalsIgnoreCase("")) {

                        //Ignore trash row
                        if (value.toLowerCase().contains(LocationConstants.TRASH.toLowerCase())) {
                            return LocationConstants.TRASH;
                        }

                        String enumConstant = column.replace(" ", "_");
                        locationType = (LocationConstants.LocationType.valueOf(enumConstant)).getType();
                        locationKey = value + "_" + locationType;

                        if (errorKey != null && !errorKey.equalsIgnoreCase("")) {

                            String locationTypestr = errorKey.split("_")[1];

                            if (!identifyParent(locationTypestr, (LocationConstants.LocationType.valueOf(enumConstant)).getType())) {
                                getSkipLocation().add(wsReader.getCurrentRowIndex());
                                if (!LocationConstants.NagarpalikaHeader.EMAMTA_CODE.name().equalsIgnoreCase(column)) {
                                    this.increment(results, LocationResultEnum.SKIP_LOCATION);
                                }

                                if (!LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationTypestr) &&
                                        !rowColumnMap.containsKey(String.valueOf(wsReader.getCurrentRowIndex()))) {
                                        rowColumnMap.put(String.valueOf(wsReader.getCurrentRowIndex()), null);
                                }

                                continue;
                            } else {
                                errorKey = null;
                            }
                        }

                        try {

                            if (value.contains("(")) {

                            String subString;
                            StringBuilder sb = new StringBuilder(value);

                            if (value.contains(")")) {
                                subString = value.substring(value.indexOf("(") + 1, value.indexOf(")"));
                            } else {
                                subString = value.substring(value.indexOf("(") + 1, sb.length());
                            }
                            if (subString.matches(LocationConstants.DIGIT_REGEX)) {
                                locationCode = subString;
                            }
                                sb.delete(value.indexOf("("), sb.length());
                                value = sb.toString().trim();

                            }

                        if (value.contains("{")) {

                            String subString;
                            StringBuilder sb = new StringBuilder(value);

                            if (value.contains("}")) {
                                subString = value.substring(value.indexOf("{") + 1, value.indexOf("}"));
                            } else {
                                subString = value.substring(value.indexOf("{") + 1, sb.length());
                            }
                            if (subString.matches(LocationConstants.DIGIT_REGEX)) {
                                locationCode = subString;
                            }
                            sb.delete(value.indexOf("{"), sb.length());
                            value = sb.toString().trim();

                        }

                        if (value.contains("[")) {

                            String subString;
                            StringBuilder sb = new StringBuilder(value);

                            if (value.contains("[")) {
                                subString = value.substring(value.indexOf("[") + 1, value.indexOf("]"));
                            } else {
                                subString = value.substring(value.indexOf("[") + 1, sb.length());
                            }
                            if (subString.matches(LocationConstants.DIGIT_REGEX)) {
                                locationCode = subString;
                            }
                            sb.delete(value.indexOf("["), sb.length());
                            value = sb.toString().trim();

                        }

                        } catch (StringIndexOutOfBoundsException e) {
                            throw new LocationException(LocationConstants.INVALID_DATA_FOUND_PARENTHESIS_INCORRECT);
                        }

                        if (value.contains("+") && !LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(locationType)
                                && !LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType)) {
                            String[] values = value.split("\\+");
                            for (String val : values) {
                                if (val != null && !val.equalsIgnoreCase("")) {
                                    errorKey = processLocation(i, column, val, errorKey, enumConstant, locationCode);
                                }
                            }
                        } else {
                            if (!value.equalsIgnoreCase("")) {
                                errorKey = processLocation(i, column, value, errorKey, enumConstant, locationCode);
                            }
                        }
                    }
                }

            } catch (Exception e) {
                logger.error(LocationConstants.LOCATION_PARSE_ERROR + " in worksheet " + wsReader.getWorkSheetName(), e);
                String errorHierarchy = printLocationHierarchy(locationKey, i, parentLocation);

                logger.error("Row Index: " + wsReader.getCurrentRowIndex() + " , Hierarchy:  " + errorHierarchy, e);

                errorKey = prepareErrorMap(locationKey, i, errorKey, e.toString(), errorHierarchy);

            }

        }

        return errorKey;
    }

    /**
     * Render each location and add in location map.
     *
     * @param i Index.
     * @param column Column name.
     * @param value Column value.
     * @param errorKey Error key.
     * @param enumConstant Enum constant.
     * @param locationCode Location code.
     * @return Returns string error key.
     */
    public String processLocation(int i, String column, String value, String errorKey, String enumConstant, String locationCode) {
        int occurence = 0;
        String locationKey = null;

        try {

            value = value.trim();

            //Key which is stored in location map , e.x Value_LocationType
            //If some value repeated in each row it will create only one location object
            locationKey = value + "_" + (LocationConstants.LocationType.valueOf(enumConstant)).getType();

            SortedSet<String> treeSet = isKeyExistInLocationMap(locationKey);

            if (treeSet.isEmpty()) {

                //No need to create location for EMAMTA_CODE , it is stored in its parent location
                if (LocationConstants.NagarpalikaHeader.EMAMTA_CODE.name().equalsIgnoreCase(column)) {

                    setLocationCodeToLocation(value, i - 1);

                } else if (LocationConstants.UrbanHeader.ANGANWADI_AREA_SOCIETY_AREA.name().equalsIgnoreCase(column)) {

                    if (!checkEmamtaCodeExistsOrNot(i)) {
                        throw new LocationException(LocationConstants.EMAMTA_CODE_NOT_EXIST_ERROR_URBAN);
                    } else {
                        locationKey = value + "_" + (LocationConstants.LocationType.valueOf(enumConstant)).getType() + "_" + occurence;

                        setLocationObjectValues(locationKey, value, i, wsReader.getCurrentRowIndex(), LocationConstants.LocationType.valueOf(enumConstant).getType(), locationCode);
                    }

                } else {
                    locationKey = value + "_" + (LocationConstants.LocationType.valueOf(enumConstant)).getType() + "_" + occurence;

                    setLocationObjectValues(locationKey, value, i, wsReader.getCurrentRowIndex(), LocationConstants.LocationType.valueOf(enumConstant).getType(), locationCode);

                }

            } else {

                for (String mapKey : treeSet) {

                    LocationMaster existsLocation = locationMap.get(mapKey);
                    LocationMaster parent = null;
                    if (i != 0) {
                        parent = parentLocation[i - 1];
                    }

                    if (existsLocation.getParentMasterForImport() != null && parent != null) {

                        //Add in map if parents are different
                        if (checkForLevelHierarchy(existsLocation, parentLocation, i - 1)) {

                            String lastKey = treeSet.last();

                            occurence = Integer.parseInt(lastKey.split("_")[2]);
                            locationKey = value + "_" + (LocationConstants.LocationType.valueOf(enumConstant)).getType() + "_" + (occurence + 1);

                            if (LocationConstants.NagarpalikaHeader.EMAMTA_CODE.name().equalsIgnoreCase(column)) {

                                setLocationCodeToLocation(value, i - 1);

                            } else if (LocationConstants.UrbanHeader.ANGANWADI_AREA_SOCIETY_AREA.name().equalsIgnoreCase(column)) {

                                if (!checkEmamtaCodeExistsOrNot(i)) {
                                    throw new LocationException(LocationConstants.EMAMTA_CODE_NOT_EXIST_ERROR_URBAN);
                                } else {
                                    setLocationObjectValues(locationKey, value, i, wsReader.getCurrentRowIndex(), LocationConstants.LocationType.valueOf(enumConstant).getType(), locationCode);
                                    break;
                                }

                            } else {
                                setLocationObjectValues(locationKey, value, i, wsReader.getCurrentRowIndex(), LocationConstants.LocationType.valueOf(enumConstant).getType(), locationCode);
                                break;
                            }
                        }else{
                            parentLocation[i] = existsLocation;
                        }

                    }
                }

            }

        } catch (Exception e) {

            String errorHierarchy = printLocationHierarchy(locationKey, i, parentLocation);
            logger.error(LocationConstants.LOCATION_PARSE_ERROR + " in worksheet " + wsReader.getWorkSheetName());
            logger.error("Row Index: " + wsReader.getCurrentRowIndex() + " , Hierarchy:  " + errorHierarchy, e);

            errorKey = prepareErrorMap(locationKey, i, errorKey, e.toString(), errorHierarchy);

        }
        return errorKey;

    }

    /**
     * Set location code to previous location object.
     *
     * @param locationCode Location code.
     * @param index Index.
     * @throws LocationException Define location exception.
     */
    public void setLocationCodeToLocation(String locationCode, int index) throws LocationException {

        try {
            String prevColumn = columnNames[index].name();
            String prevValue = wsReader.getValue(prevColumn);

            TreeSet<String> set = new TreeSet<>();
            if (LocationConstants.NagarpalikaHeader.ANGANWADI_AREA_SOCIETY_AREA.name().equalsIgnoreCase(prevColumn)) {

                if (prevValue != null && !prevValue.equalsIgnoreCase("")) {

                    String prevEnumConstant = prevColumn.replace(" ", "_");

                    if (prevValue.contains("(")) {

                        StringBuilder sb = new StringBuilder(prevValue);
                        sb.delete(prevValue.indexOf("("), sb.length());
                        prevValue = sb.toString().trim();

                    }

                    if (prevValue.contains("{")) {

                        StringBuilder sb = new StringBuilder(prevValue);
                        sb.delete(prevValue.indexOf("{"), sb.length());
                        prevValue = sb.toString().trim();

                    }

                    if (prevValue.contains("[")) {

                        StringBuilder sb = new StringBuilder(prevValue);
                        sb.delete(prevValue.indexOf("["), sb.length());
                        prevValue = sb.toString().trim();

                    }
                    String prevLocationKey = prevValue + "_" + (LocationConstants.LocationType.valueOf(prevEnumConstant)).getType();

                    Set<String> mapKeys = locationMap.keySet();

                    for (String mapKey : mapKeys) {
                        if (mapKey.startsWith(prevLocationKey)) {
                            set.add(mapKey);
                        }
                    }

                    LocationMaster prevLocation = locationMap.get(set.last());
                    if (prevLocation != null) {
                        prevLocation.setLocationCode(Long.valueOf(locationCode));
                    } else {
                        setLocationCodeToLocation(locationCode, index - 1);
                    }
                } else {
                    setLocationCodeToLocation(locationCode, index - 1);
                }
            } else {
                setLocationCodeToLocation(locationCode, index - 1);
            }
        } catch (ArrayIndexOutOfBoundsException e) {
            throw new LocationException(LocationConstants.EMAMTA_CODE_ERROR_URBAN);
        }

    }

    /**
     * Create location object and set all value
     *
     * @param locationKey Location key.
     * @param value Location value.
     * @param i Index.
     * @param rowNum Row number.
     * @param locationType Location type.
     * @return LocationMaster Location master.
     * @throws LocationException Define location exception.
     */
    private LocationMaster setLocationObjectValues(String locationKey, String value, int i, int rowNum, String locationType, String locationCode) throws LocationException {
        LocationMaster location = new LocationMaster();
        location.setName(value);

        parentLocation[i] = location;

        //Set location type 
        location.setType(locationType);

        if (i != 0) {
            //Set parent of location object as its previous cell location object
            if (parentLocation[i - 1] != null) {
                location.setParentMaster(parentLocation[i - 1]);
            } else {
                throw new LocationException(LocationConstants.PARENT_NOT_FOUND_FOR_LOCATION);
            }

        } else {
            location.setParentMaster(null);
        }

        location.setIsActive(true);
        location.setState(LocationMaster.State.ACTIVE);
        location.setIsArchive(false);
        location.setCreatedBy(LocationConstants.ADMIN);
        location.setCreatedOn(new Date());

        if (locationCode != null && !locationCode.isEmpty()) {
            location.setLocationCode(Long.valueOf(locationCode));
        }

        locationMap.put(locationKey, location);

        List<Integer> rowcolumn = new ArrayList<>();
        rowcolumn.add(rowNum);
        rowcolumn.add(i);

        rowIndexMap.put(locationKey, rowcolumn);

        return location;

    }

    /**
     * Prepare error map with add row and column detail when exception occurred
     *
     * @param locationKey Location key.
     * @param i Index.
     * @param errorKey Error key.
     * @param exception Define exception.
     * @param errorHierarchy Error in location hierarchy.
     * @return Returns string.
     */
    private String prepareErrorMap(String locationKey, int i, String errorKey, String exception, String errorHierarchy) {

        if (locationKey != null && !locationKey.equalsIgnoreCase("")) {
            errorKey = locationKey;
        }

        this.increment(results, LocationResultEnum.ERRORS_ENCOUNTERED);
        Map<Integer, List<String>> columnValuesMap = new HashMap<>();

        String type="";
        if(Objects.nonNull(locationKey)) {
            type = locationKey.split("_")[1];
        }
        if (LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(type)) {
            List<String> hierarchyList = new LinkedList<>(Arrays.asList(errorHierarchy.split(">")));
            hierarchyList.remove(hierarchyList.size() - 1);

            List<String> errorList = new ArrayList<>();

            if (exception != null && !exception.equalsIgnoreCase("") &&
                    Integer.parseInt(errorMessageCount) < exception.length()) {
                    exception = exception.substring(0, Integer.parseInt(errorMessageCount));
            }

            errorList.add(exception);

            columnValuesMap.put(i, hierarchyList);

            String key = parentLocation[i - 1].getName() + "_" + parentLocation[i - 1].getType();

            rowColumnMap.put(String.valueOf(rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0)), columnValuesMap);

            Map<Integer, List<String>> columnErrorMap = new HashMap<>();
            columnErrorMap.put(i, errorList);

            rowColumnMap.put(wsReader.getCurrentRowIndex() + "_"
                    + i + "_" + errorKey.split("_")[0], columnErrorMap);
        } else if (LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(type)) {
            List<String> hierarchyList = new LinkedList<>(Arrays.asList(errorHierarchy.split(">")));

            String anmArea = hierarchyList.get(hierarchyList.size() - 2);

            hierarchyList.remove(hierarchyList.size() - 2);
            hierarchyList.remove(hierarchyList.size() - 1);

            List<String> anmAreaList = new ArrayList<>();
            anmAreaList.add("");
            anmAreaList.add("");
            anmAreaList.add("");
            anmAreaList.add(anmArea);
            Map<Integer, List<String>> columnValuesMap1 = new HashMap<>();

            List<String> errorList = new ArrayList<>();

            if (exception != null && !exception.equalsIgnoreCase("") &&
                    Integer.parseInt(errorMessageCount) < exception.length()) {
                    exception = exception.substring(0, Integer.parseInt(errorMessageCount));
            }

            errorList.add(exception);

            columnValuesMap.put(i, hierarchyList);
            columnValuesMap1.put(i, anmAreaList);

            String key = parentLocation[i - 1].getName() + "_" + parentLocation[i - 1].getType();

            int parentKeyIndex = rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0);

            String otherkey = parentLocation[i - 1].getParentMasterForImport().getName() + "_" + parentLocation[i - 1].getParentMasterForImport().getType();
            int otherParentKey = rowIndexMap.get(findParentLocationKeyInMap(otherkey, locationMap)).get(0);
            rowColumnMap.put(String.valueOf(otherParentKey), columnValuesMap);
            rowColumnMap.put(String.valueOf(parentKeyIndex), columnValuesMap1);

            Map<Integer, List<String>> columnErrorMap = new HashMap<>();
            columnErrorMap.put(i, errorList);
            rowColumnMap.put(wsReader.getCurrentRowIndex() + "_"
                    + i + "_" + errorKey.split("_")[0], columnErrorMap);

        } else if (LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(type)) {
            List<String> hierarchyList = new LinkedList<>(Arrays.asList(errorHierarchy.split(">")));

            String anmArea = hierarchyList.get(hierarchyList.size() - 3);

            String anganwadi = hierarchyList.get(hierarchyList.size() - 2);
            hierarchyList.remove(hierarchyList.size() - 3);
            hierarchyList.remove(hierarchyList.size() - 2);
            hierarchyList.remove(hierarchyList.size() - 1);

            List<String> anmAreaList = new ArrayList<>();
            anmAreaList.add("");
            anmAreaList.add("");
            anmAreaList.add("");
            anmAreaList.add(anmArea);
            Map<Integer, List<String>> columnValuesMap1 = new HashMap<>();

            columnValuesMap.put(i, hierarchyList);
            columnValuesMap1.put(i, anmAreaList);

            String key = parentLocation[i - 1].getParentMasterForImport().getName() + "_" + parentLocation[i - 1].getParentMasterForImport().getType();

            int parentKeyIndex = rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0);

            String otherkey = parentLocation[i - 1].getParentMasterForImport().getParentMasterForImport().getName() + "_" + parentLocation[i - 1].getParentMasterForImport().getParentMasterForImport().getType();
            int otherParentKey = rowIndexMap.get(findParentLocationKeyInMap(otherkey, locationMap)).get(0);

            rowColumnMap.put(String.valueOf(otherParentKey), columnValuesMap);
            rowColumnMap.put(String.valueOf(parentKeyIndex), columnValuesMap1);

            List<String> list = new ArrayList<>();
            list.add("");
            list.add("");
            list.add("");
            list.add("");
            list.add(anganwadi);
            list.add(errorKey.split("_")[0]);

            if (exception != null && !exception.equalsIgnoreCase("") &&
                    Integer.parseInt(errorMessageCount) < exception.length()) {
                    exception = exception.substring(0, Integer.parseInt(errorMessageCount));
            }
            List<String> error = new ArrayList<>();
            error.add(exception);
            Map<Integer, List<String>> columnValuesMap2 = new HashMap<>();
            columnValuesMap2.put(LocationConstants.ERROR_MESSAGE_INT, error);
            columnValuesMap2.put(i, list);

            rowColumnMap.put(String.valueOf(wsReader.getCurrentRowIndex()), columnValuesMap2);

        } else {
            List<String> list = Arrays.asList(errorHierarchy.split(">"));

            List<String> error = new ArrayList<>();

            if (exception != null && !exception.equalsIgnoreCase("") &&
                    Integer.parseInt(errorMessageCount) < exception.length()) {
                    exception = exception.substring(0, Integer.parseInt(errorMessageCount));
            }

            error.add(exception);

            columnValuesMap.put(LocationConstants.ERROR_MESSAGE_INT, error);
            columnValuesMap.put(i, list);

            rowColumnMap.put(String.valueOf(wsReader.getCurrentRowIndex()), columnValuesMap);
        }
        return errorKey;
    }

    /**
     * Identify parent location for skip row
     *
     * @param errorlocationType Error location type.
     * @param locationType Location type.
     * @return Returns boolean.
     */
    @Override
    public boolean identifyParent(String errorlocationType, String locationType) {

        if (LocationConstants.LocationType.ZONE.getType().equalsIgnoreCase(errorlocationType)) {

            if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ZONE.getType().equalsIgnoreCase(locationType)) {
                return true;
            } else if (LocationConstants.LocationType.UPHC.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.EMAMTA_CODE.getType().equalsIgnoreCase(locationType)) {
                return false;
            }

        } else if (LocationConstants.LocationType.UPHC.getType().equalsIgnoreCase(errorlocationType)) {

            if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ZONE.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.UPHC.getType().equalsIgnoreCase(locationType)) {
                return true;
            } else if (LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.EMAMTA_CODE.getType().equalsIgnoreCase(locationType)) {
                return false;
            }

        } else if (LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(errorlocationType)) {

            if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ZONE.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.UPHC.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(locationType)) {
                return true;
            } else if (LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.EMAMTA_CODE.getType().equalsIgnoreCase(locationType)) {
                return false;
            }

        } else if (LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(errorlocationType)) {
            if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ZONE.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.UPHC.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType)) {
                return true;
            } else if (LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(locationType)
                    || LocationConstants.LocationType.EMAMTA_CODE.getType().equalsIgnoreCase(locationType)) {
                return false;
            }

        } else if (LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(errorlocationType)) {
            return true;

        } else return LocationConstants.LocationType.EMAMTA_CODE.getType().equalsIgnoreCase(errorlocationType);
        return false;
    }

    /**
     * Retrieves filtered work book.
     * @param sheet XSSF sheet.
     * @param outWorkBook Out work book.
     * @param errorDetail Error details.
     * @return Returns XSSFWorkbook.
     */
    @Override
    public XSSFWorkbook getFilteredWorkBook(XSSFSheet sheet, XSSFWorkbook outWorkBook, Map<String, Map<Integer, List<String>>> errorDetail) {
        logger.info("Error found in worksheet: " + sheet.getSheetName());
        // create New work sheet 
        XSSFSheet outSheet = outWorkBook.createSheet(sheet.getSheetName());

        //create header row
        XSSFRow headerRow = outSheet.createRow(0);

        XSSFCellStyle newCellStyle = null;
        for (int col = 0; col < columnNames.length; col++) {

            XSSFCell headerCell = headerRow.createCell(col);
            headerCell.setCellValue(columnNames[col].name());

            newCellStyle = headerCell.getSheet().getWorkbook().createCellStyle();
            newCellStyle.cloneStyleFrom(sheet.getRow(0).getCell(col).getCellStyle());
            headerCell.setCellStyle(newCellStyle);
        }

        XSSFCell rowIdCell = headerRow.createCell(columnNames.length);
        rowIdCell.setCellStyle(newCellStyle);
        rowIdCell.setCellValue(LocationConstants.REFERENCE_ROW_ID);

        XSSFCell errorMsgCell = headerRow.createCell(columnNames.length + 1);
        errorMsgCell.setCellStyle(newCellStyle);
        errorMsgCell.setCellValue(LocationConstants.ERROR_MESSAGE);

        int i = 1;
        int rowIndexError = 0;
        for (Map.Entry<String, Map<Integer, List<String>>> rowColumnDetail : errorDetail.entrySet()) {

            // create new row
            int rowNum;
            if (rowColumnDetail.getKey().contains("_")) {
                rowNum = Integer.parseInt(rowColumnDetail.getKey().split("_")[0]);
            } else {
                rowNum = Integer.parseInt(rowColumnDetail.getKey());
            }

            XSSFRow outRow = outSheet.createRow(i);

            i++;

            // get columns with given column numbers
            Map<Integer, List<String>> columnDetail = rowColumnDetail.getValue();

            if (!rowColumnDetail.getKey().contains("_")) {
                //Normal row and area parent row
                if (columnDetail != null && !columnDetail.isEmpty()) {

                    XSSFRow row = sheet.getRow(rowNum - 1);

                    String errorMessage = null;
                    if (columnDetail.containsKey(LocationConstants.ERROR_MESSAGE_INT)) {
                        errorMessage = columnDetail.get(LocationConstants.ERROR_MESSAGE_INT).get(0);
                        columnDetail.remove(LocationConstants.ERROR_MESSAGE_INT);
                    }

                    for (Map.Entry<Integer, List<String>> columnValues : columnDetail.entrySet()) {

                        int col = 0;
                        while (col < columnValues.getValue().size()) {

                            // create new column
                            XSSFCell outCell = outRow.createCell(col);
                            XSSFCell cell = row.getCell(col);
                            outCell.setCellValue(columnValues.getValue().get(col));
                            if (cell != null && col == columnValues.getKey()) {
                                    setErrorCellStyle(outCell, cell);
                            }
                            col++;
                        }

                        // Set another column value after errored column
                        row = sheet.getRow(rowNum - 1);
                        while (col < columnNames.length) {

                            XSSFCell outCell = outRow.createCell(col);
                            XSSFCell cell = row.getCell(col);

                            if (outCell != null && cell != null) {

                                setCellValue(outCell, cell);

                                if (cell.getCellType() != HSSFCell.CELL_TYPE_BLANK &&
                                        cell.getColumnIndex() != columnNames.length - 1) {
                                        setErrorCellStyle(outCell, cell);
                                }
                            }

                            col++;

                        }

                        if (errorMessage != null) {
                            //create error message column
                            outRow.createCell(columnNames.length + 1).setCellValue(errorMessage);
                        }

                        //create refrence row id column
                        outRow.createCell(columnNames.length).setCellValue(rowNum);

                    }

                } else {
                    //Skip row 

                    if (rowIndexError == 0 || rowIndexError != (rowNum)) {
                        XSSFRow row = sheet.getRow(rowNum - 1);
                        if (row != null) {
                            for (int colNum = 0; colNum < columnNames.length; colNum++) {

                                // create new column
                                XSSFCell outCell = outRow.createCell(colNum);
                                XSSFCell cell = row.getCell(colNum);

                                if (outCell != null && cell != null) {

                                    if (cell.getCellType() != HSSFCell.CELL_TYPE_BLANK &&
                                            cell.getColumnIndex() != columnNames.length - 1) {
                                            setErrorCellStyle(outCell, cell);
                                    }

                                    setCellValue(outCell, cell);

                                }

                            }
                            //create refrence row id column
                            outRow.createCell(columnNames.length).setCellValue(rowNum);
                        }
                    }
                }

            } else {
                //Area column
                rowIndexError = Integer.parseInt(rowColumnDetail.getKey().split("_")[0]);
                int cellNo = Integer.parseInt(rowColumnDetail.getKey().split("_")[1]);
                String cellVal = rowColumnDetail.getKey().split("_")[2];
                XSSFCell outCell = outRow.createCell(cellNo);
                outCell.setCellValue(cellVal);
                setErrorCellStyle(outCell, null);
                int col = cellNo + 1;
                // Set another column value after errored column
                XSSFRow row = sheet.getRow(rowIndexError - 1);

                while (col < columnNames.length) {

                    outCell = outRow.createCell(col);
                    XSSFCell cell = row.getCell(col);
                    if (outCell != null && cell != null) {

                        setCellValue(outCell, cell);

                        if (cell.getCellType() != HSSFCell.CELL_TYPE_BLANK &&
                                cell.getColumnIndex() != columnNames.length - 1) {
                                setErrorCellStyle(outCell, cell);
                        }
                    }

                    col++;

                }

                //set error message
                outRow.createCell(columnNames.length + 1).setCellValue(rowColumnDetail.getValue().get(cellNo).get(0));

                //create refrence row id column
                outRow.createCell(columnNames.length).setCellValue(rowNum);
            }

        }

        return outWorkBook;
    }

    /**
     * Render location map and insert location in database
     *
     * @param errorRowMap Map in error row.
     */
    @Override
    public void insertLocations(Map<String, Map<String, Map<Integer, List<String>>>> errorRowMap) {
        logger.info("Insert locations in database..");
        LocationMaster location = null;
        String errorKey = null;
        Map<String, LocationMaster> dblocationMap = new HashMap<>();
        LocationMaster corporation = null;
        boolean isdistrictInserted = false;

        for (Map.Entry<String, LocationMaster> locationObj : locationMap.entrySet()) {

            try {
                location = locationObj.getValue();
                if (location.getParentMasterForImport() != null) {
                    String parentDBLocationKey = location.getParentMasterForImport().getName() + "_" + location.getParentMasterForImport().getType();
                    if (dblocationMap.containsKey(parentDBLocationKey)) {
                        location.setParentMaster(dblocationMap.get(parentDBLocationKey));
                    }
                }

                if (errorKey != null && !errorKey.equalsIgnoreCase("")) {

                    String locationType = errorKey.split("_")[1];

                    if (!this.identifyParent(locationType, locationObj.getKey().split("_")[1])) {
                        this.increment(results, LocationResultEnum.SKIP_LOCATION);
                        getSkipLocation().add(rowIndexMap.get(locationObj.getKey()).get(0));

                        if (!LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(locationType) &&
                                !rowColumnMap.containsKey(String.valueOf(rowIndexMap.get(locationObj.getKey()).get(0)))) {
                                rowColumnMap.put(rowIndexMap.get(locationObj.getKey()).get(0).toString(), null);
                                errorRowMap.put(workSheetName, rowColumnMap);
                        }
                        continue;
                    } else {
                        errorKey = null;
                    }

                }

                LocationMaster dbLocation = this.checkOrFindDuplication(location);

                if (dbLocation == null) {

                    if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(location.getType())) {

                        corporation = location;
                        isdistrictInserted = true;

                    }

                    //insert location in DB
                    this.getLocationDao().create(location);

                    List<Integer> locationIds = new ArrayList<>();
                    locationIds.add(location.getId());
                    getLocationLevelHierarchy(location, locationIds);
                    LocationLevelHierarchy locationHierarchy = this.createLocationLevelHierarchy(location, locationIds);

                    //insert location level hierarchy
                    Integer hierarchyId = getLocationLevelDao().create(locationHierarchy);

                    location.setLocationHierarchy(getLocationLevelDao().retrieveById(hierarchyId));
                    //update location hierarchy id
                    this.getLocationDao().update(location);
                    this.increment(results, LocationResultEnum.LOCATION_ADDED);
                } else {
                    String dbLocationKey = location.getName() + "_" + location.getType();
                    dblocationMap.put(dbLocationKey, dbLocation);

                    if (LocationConstants.LocationType.CORPORATION.getType().equalsIgnoreCase(location.getType())) {

                        corporation = dbLocation;
                        isdistrictInserted = false;

                    }

                    this.increment(results, LocationResultEnum.DUPLICATE_LOCATION);
                }

            } catch (DataIntegrityViolationException e) {
                logger.error("Duplicate data found while process file");
                throw e;

            } catch (Exception ex) {
                errorKey = locationObj.getKey();
                StringBuilder sb = new StringBuilder();
                sb.append(location.getName());
                sb.append(">");

                String[] s = printLocationHierarchy(location, sb).split(">");

                StringBuilder s1 = new StringBuilder();
                for (int i = s.length - 1; i >= 0; i--) {
                    s1.append(s[i]);

                    if (i != 0) {
                        s1.append(">");
                    }

                }
                logger.error(LocationConstants.LOCATION_ADD_ERROR + s1.toString() + " at row: " + rowIndexMap.get(locationObj.getKey()).get(0) + " , in worksheet " + workSheetName, ex);

                this.increment(results, LocationResultEnum.ERRORS_ENCOUNTERED);

                Map<Integer, List<String>> columnValuesMap = new HashMap<>();

                if (errorRowMap.get(workSheetName) != null) {

                    rowColumnMap = errorRowMap.get(workSheetName);
                }

                //check for area column
                if (LocationConstants.LocationType.ANM_AREA.getType().equalsIgnoreCase(location.getType())) {
                    List<String> hierarchyList = new LinkedList<>(Arrays.asList(s1.toString().split(">")));
                    hierarchyList.remove(hierarchyList.size() - 1);

                    List<String> errorList = new ArrayList<>();

                    String exception = ex.toString();

                    if (exception != null && !exception.equalsIgnoreCase("") &&
                            Integer.parseInt(errorMessageCount) < exception.length()) {
                            exception = exception.substring(0, Integer.parseInt(errorMessageCount));
                    }

                    errorList.add(exception);

                    columnValuesMap.put(rowIndexMap.get(locationObj.getKey()).get(1), hierarchyList);

                    String key = locationObj.getValue().getParentMasterForImport().getName() + "_" + locationObj.getValue().getParentMasterForImport().getType();

                    rowColumnMap.put(String.valueOf(rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0)), columnValuesMap);

                    Map<Integer, List<String>> columnErrorMap = new HashMap<>();
                    columnErrorMap.put(rowIndexMap.get(locationObj.getKey()).get(1), errorList);
                    rowColumnMap.put(rowIndexMap.get(locationObj.getKey()).get(0) + "_"
                            + rowIndexMap.get(locationObj.getKey()).get(1)
                            + "_" + location.getName(), columnErrorMap);
                } else if (LocationConstants.LocationType.ANGANWADI_AREA_SOCIETY_AREA.getType().equalsIgnoreCase(location.getType())) {
                    List<String> hierarchyList = new LinkedList<>(Arrays.asList(s1.toString().split(">")));

                    String anmArea = hierarchyList.get(hierarchyList.size() - 2);

                    hierarchyList.remove(hierarchyList.size() - 2);
                    hierarchyList.remove(hierarchyList.size() - 1);

                    List<String> anmAreaList = new ArrayList<>();
                    anmAreaList.add("");
                    anmAreaList.add("");
                    anmAreaList.add("");
                    anmAreaList.add(anmArea);
                    Map<Integer, List<String>> columnValuesMap1 = new HashMap<>();

                    List<String> errorList = new ArrayList<>();

                    String exception = ex.toString();

                    if (exception != null && !exception.equalsIgnoreCase("") &&
                            Integer.parseInt(errorMessageCount) < exception.length()) {
                            exception = exception.substring(0, Integer.parseInt(errorMessageCount));
                    }

                    errorList.add(exception);

                    columnValuesMap.put(rowIndexMap.get(locationObj.getKey()).get(1), hierarchyList);
                    columnValuesMap1.put(rowIndexMap.get(locationObj.getKey()).get(1), anmAreaList);

                    String key = locationObj.getValue().getParentMasterForImport().getName() + "_" + locationObj.getValue().getParentMasterForImport().getType();

                    int parentKeyIndex = rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0);

                    String otherkey = locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getName() + "_" + locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getType();
                    int otherParentKey = rowIndexMap.get(findParentLocationKeyInMap(otherkey, locationMap)).get(0);
                    rowColumnMap.put(String.valueOf(otherParentKey), columnValuesMap);
                    rowColumnMap.put(String.valueOf(parentKeyIndex), columnValuesMap1);

                    Map<Integer, List<String>> columnErrorMap = new HashMap<>();
                    columnErrorMap.put(rowIndexMap.get(locationObj.getKey()).get(1), errorList);
                    rowColumnMap.put(rowIndexMap.get(locationObj.getKey()).get(0) + "_"
                            + rowIndexMap.get(locationObj.getKey()).get(1)
                            + "_" + location.getName(), columnErrorMap);

                } else if (LocationConstants.LocationType.ASHA_AREA.getType().equalsIgnoreCase(location.getType())) {
                    List<String> hierarchyList = new LinkedList<>(Arrays.asList(s1.toString().split(">")));

                    String anmArea = hierarchyList.get(hierarchyList.size() - 3);

                    String anganwadi = hierarchyList.get(hierarchyList.size() - 2);
                    hierarchyList.remove(hierarchyList.size() - 3);
                    hierarchyList.remove(hierarchyList.size() - 2);
                    hierarchyList.remove(hierarchyList.size() - 1);

                    List<String> anmAreaList = new ArrayList<>();
                    anmAreaList.add("");
                    anmAreaList.add("");
                    anmAreaList.add("");
                    anmAreaList.add(anmArea);
                    Map<Integer, List<String>> columnValuesMap1 = new HashMap<>();

                    columnValuesMap.put(rowIndexMap.get(locationObj.getKey()).get(1), hierarchyList);
                    columnValuesMap1.put(rowIndexMap.get(locationObj.getKey()).get(1), anmAreaList);

                    String key = locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getName() + "_" + locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getType();

                    int parentKeyIndex = rowIndexMap.get(findParentLocationKeyInMap(key, locationMap)).get(0);

                    String otherkey = locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getParentMasterForImport().getName() + "_" + locationObj.getValue().getParentMasterForImport().getParentMasterForImport().getParentMasterForImport().getType();
                    int otherParentKey = rowIndexMap.get(findParentLocationKeyInMap(otherkey, locationMap)).get(0);

                    rowColumnMap.put(String.valueOf(otherParentKey), columnValuesMap);
                    rowColumnMap.put(String.valueOf(parentKeyIndex), columnValuesMap1);

                    List<String> list = new ArrayList<>();
                    list.add("");
                    list.add("");
                    list.add("");
                    list.add("");
                    list.add(anganwadi);
                    list.add(location.getName());

                    String exception = ex.toString();

                    if (exception != null && !exception.equalsIgnoreCase("") &&
                            Integer.parseInt(errorMessageCount) < exception.length()) {
                            exception = exception.substring(0, Integer.parseInt(errorMessageCount));
                    }
                    List<String> error = new ArrayList<>();
                    error.add(exception);
                    Map<Integer, List<String>> columnValuesMap2 = new HashMap<>();
                    columnValuesMap2.put(LocationConstants.ERROR_MESSAGE_INT, error);
                    columnValuesMap2.put(rowIndexMap.get(locationObj.getKey()).get(1), list);
                    rowColumnMap.put(String.valueOf(rowIndexMap.get(locationObj.getKey()).get(0)), columnValuesMap2);

                } else {
                    List<String> list = Arrays.asList(s1.toString().split(">"));

                    List<String> error = new ArrayList<>();

                    String exception = ex.toString();

                    if (exception != null && !exception.equalsIgnoreCase("") &&
                            Integer.parseInt(errorMessageCount) < exception.length()) {
                            exception = exception.substring(0, Integer.parseInt(errorMessageCount));
                    }
                    error.add(exception);

                    columnValuesMap.put(LocationConstants.ERROR_MESSAGE_INT, error);
                    columnValuesMap.put(rowIndexMap.get(locationObj.getKey()).get(1), list);

                    rowColumnMap.put(String.valueOf(rowIndexMap.get(locationObj.getKey()).get(0)), columnValuesMap);
                }

                errorRowMap.put(workSheetName, rowColumnMap);

            }

        }

        if (isdistrictInserted) {
            setStateInCorporation(corporation);
        }
    }

    /**
     * Check if location already exists in database or not.
     * @param location1 Location details.
     * @return Returns locationMaster.
     */
    public LocationMaster checkOrFindDuplication(LocationMaster location1) {

        List<LocationMaster> locationList = this.getLocationDao().getLocationsByNameAndParent(location1.getName(), location1.getType(), location1.getParentMasterForImport());

        List<Integer> locationIds = new ArrayList<>();
        List<Integer> dblevelHierarchyList;

        if (locationList == null) {
            return null;
        } else {

            getLocationLevelHierarchy(location1, locationIds);

            locationList.sort(Comparator.comparingInt(LocationMaster::getId));

            for (LocationMaster dbLocation : locationList) {

                dblevelHierarchyList = new ArrayList<>();

                LocationLevelHierarchy levelHierarchy = dbLocation.getLocationHierarchy();

                if (levelHierarchy != null) {

                    addNotNullElement(levelHierarchy.getLevel7(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel6(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel5(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel4(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel3(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel2(), dblevelHierarchyList);
                    addNotNullElement(levelHierarchy.getLevel1(), dblevelHierarchyList);
                }

                if (dblevelHierarchyList.containsAll(locationIds)) {
                    return dbLocation;

                }
            }

        }

        return null;
    }

    /**
     * Set state as parent in Corporation
     *
     * @param corporation Corporation
     */
    private void setStateInCorporation(LocationMaster corporation) {

        if (corporation != null) {
            List<LocationMaster> state = this.getLocationDao().getLocationsByLocationType(LocationConstants.LocationType.STATE.getType(), true);

            if (state != null && !state.isEmpty()) {
                for (LocationMaster stateLocation : state) {

                    String stateName = stateLocation.getName();
                    if (LocationConstants.GUJARAT_STATE_ENGLISH.equalsIgnoreCase(stateName) || LocationConstants.GUJARAT_STATE_GUJARATI.equals(stateName)) {
                        corporation.setParentMaster(stateLocation);
                    }

                }
            }

            getLocationDao().update(corporation);
        }

    }

    /**
     * Return work sheet hierarchy
     *
     * @return String
     */
    @Override
    public String getWorkSheetHierarchy() {
        return LocationConstants.NAGARPALIKA_HIERARCHY;
    }
    
    /**
     * Check if emamta code is exists or not 
     * @param i Index.
     * @return Returns true/false.
     */
    private boolean checkEmamtaCodeExistsOrNot(int i) {

        i = i + 2;
        String column = columnNames[i].name();
        String value = wsReader.getValue(column);

        if (value != null) {
            value = value.trim();

            return !value.equalsIgnoreCase("");
        } else {
            return false;
        }

    }

}
