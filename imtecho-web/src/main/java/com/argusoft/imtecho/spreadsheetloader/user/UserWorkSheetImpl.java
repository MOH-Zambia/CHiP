package com.argusoft.imtecho.spreadsheetloader.user;

import com.argusoft.imtecho.common.dao.RoleDao;
import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dao.UserLocationDao;
import com.argusoft.imtecho.common.dto.UserLocationDto;
import com.argusoft.imtecho.common.dto.UserMasterDto;
import com.argusoft.imtecho.common.mapper.UserLocationMappper;
import com.argusoft.imtecho.common.mapper.UserMapper;
import com.argusoft.imtecho.common.model.RoleMaster;
import com.argusoft.imtecho.common.model.UserLocation;
import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.exception.ImtechoResponseEntity;
import com.argusoft.imtecho.location.constants.LocationConstants;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.location.model.LocationMaster;
import com.argusoft.imtecho.spreadsheetloader.utility.PoiWorksheetReader;
import common.Logger;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jasypt.util.password.BasicPasswordEncryptor;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * <p>
 * user spreadSheet reading and writing service
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
public class UserWorkSheetImpl {

    public static final Logger logger = Logger.getLogger(UserWorkSheetImpl.class);

    private final String workSheetName;

    private Map<Integer, Integer> rowLocationMap = new LinkedHashMap<>();

    private Map<Integer, Map<Integer, UserMasterDto>> usersLocationMap = new LinkedHashMap<>();

    private Map<Integer, Map<UserConstants.ResultFields, String>> resultRowMap = new LinkedHashMap<>();

    private LocationMasterDao locationMasterDao;

    private RoleDao roleDao;

    private UserService userService;

    private UserDao userDao;

    private UserLocationDao userLocationDao;

    private UserLocationDto lastLocationDto = null;

    private Integer maxLocationLevel = null;

    private List<String> columns = null;

    protected PoiWorksheetReader wsReader = null;

    private BasicPasswordEncryptor basicPasswordEncryptor = new BasicPasswordEncryptor();

    public UserWorkSheetImpl(String workSheetName) {
        this.workSheetName = workSheetName;
    }

    /**
     * Load users form shred sheet
     *
     * @throws UploadUserException
     */
    public void loadUsers() throws UploadUserException {
        Integer roleId = Integer.valueOf(workSheetName.substring(
                workSheetName.indexOf("(") + 1,
                workSheetName.indexOf(")")));
        if (roleId != null) {
            this.getMaxLocationLevel();
            while (wsReader.nextRow()) {
                this.renderUsers();
            }
        } else {
            throw new UploadUserException(UserConstants.SHEET_NAME_NOT_VALID);
        }

    }

    /**
     * Render user form shred sheet
     *
     * @throws UploadUserException
     */
    private void renderUsers() throws UploadUserException {
        List<String> errorList = new ArrayList<>();

        UserMasterDto userMasterDto = null;
        if (getCellValue(maxLocationLevel - 1) != null) {
            lastLocationDto = this.getRowUserLocation();
        }

        userMasterDto = this.getRowUser(errorList);

        if (errorList.size() > 0) {
            setResultRowMapValue(wsReader.getCurrentRowIndex(), UserConstants.ResultFields.RESULT_MESSAGE, errorList.stream()
                    .map(error -> String.join(",", error))
                    .collect(Collectors.joining("\n")));
            return;
        }

        List<UserLocationDto> addUserLocations = new ArrayList<>();
        addUserLocations.add(lastLocationDto);
        userMasterDto.setAddedLocations(addUserLocations);

        Map<Integer, UserMasterDto> userListMap = null;

        if (usersLocationMap.get(lastLocationDto.getLocationId()) == null) {
            userListMap = new LinkedHashMap<>();
        } else {
            userListMap = usersLocationMap.get(lastLocationDto.getLocationId());
        }
        userListMap.put(wsReader.getCurrentRowIndex(), userMasterDto);
        usersLocationMap.put(lastLocationDto.getLocationId(), userListMap);
    }

    /**
     * Get location form row
     *
     * @return
     * @throws UploadUserException
     */
    private UserLocationDto getRowUserLocation() throws UploadUserException {
        String maxLevelLocationName = this.getCellValue(maxLocationLevel - 1);
        if ((maxLevelLocationName.indexOf("(") != -1 && maxLevelLocationName.indexOf(")") == -1) ||
                (maxLevelLocationName.indexOf("(") == -1 && maxLevelLocationName.indexOf(")") != -1) ||
                maxLevelLocationName.indexOf("(") == -1 && maxLevelLocationName.indexOf(")") == -1
        ) {
            throw new UploadUserException(UserConstants.SHEET_HEADER_COLUMN_ERROR);
        }
        Integer locationId = null;
        if (maxLevelLocationName != null) {
            locationId = Integer.valueOf(maxLevelLocationName.substring(
                    maxLevelLocationName.indexOf("(") + 1,
                    maxLevelLocationName.indexOf(")")));
            if (locationId != null) {
                this.rowLocationMap.put(locationId, wsReader.getCurrentRowIndex());
                UserLocationDto userLocationDto = new UserLocationDto();
                userLocationDto.setLocationId(locationId);
                return userLocationDto;
            } else {
                return null;
            }
        }
        return null;
    }

    /**
     * Get user form row
     *
     * @return
     * @throws UploadUserException
     */
    private UserMasterDto getRowUser(List<String> errorList) {
        UserConstants.UploadUserFields[] fields = UserConstants.UploadUserFields.values();
        UserMasterDto userMasterDto = new UserMasterDto();
        for (int i = 0; i < fields.length; i++) {
            try {
                switch (fields[i]) {
                    case FIRST_NAME:
                        String firstName = getCellValue(maxLocationLevel + i);
                        if (firstName != null) {
                            userMasterDto.setFirstName(firstName);
                        } else {
                            errorList.add(UserConstants.FIRST_NAME_NOT_FOUND);
                        }
                        break;
                    case MIDDLE_NAME:
                        userMasterDto.setMiddleName(getCellValue(maxLocationLevel + i));
                        break;
                    case LAST_NAME:
                        String lastName = getCellValue(maxLocationLevel + i);
                        if (lastName != null) {
                            userMasterDto.setLastName(lastName);
                        } else {
                            errorList.add(UserConstants.LAST_NAME_NOT_FOUND);
                        }
                        break;
                    case GENDER:
                        String gender = getCellValue(maxLocationLevel + i);
                        if (gender != null) {
                            if (gender.equalsIgnoreCase(UserConstants.Gender.MALE.name())) {
                                userMasterDto.setGender(UserConstants.Gender.MALE.getGender());
                            } else if (gender.equalsIgnoreCase(UserConstants.Gender.FEMALE.name())) {
                                userMasterDto.setGender(UserConstants.Gender.FEMALE.getGender());
                            }
                        } else {
                            errorList.add(UserConstants.GENDER_NOT_FOUND);
                        }
                        break;
                    case PHONE_NUMBER:
                        String mobileNumber = getCellValue(maxLocationLevel + i);
                        if (mobileNumber != null) {
                            if (mobileNumber.length() == 10) {
                                userMasterDto.setMobileNumber(mobileNumber);
                            } else {
                                errorList.add(UserConstants.MOBILE_NUMBER_NOT_VALID);
                            }
                        } else {
                            errorList.add(UserConstants.MOBILE_NUMBER_NOT_FOUND);
                        }
                        break;
                    case EMAIL_ID:
                        String email = getCellValue(maxLocationLevel + i);
                        if (email != null) {
                            email = email.trim();
                            if (email.matches(UserConstants.EMAIL_REGEX)) {
                                userMasterDto.setEmailId(email);
                            } else {
                                errorList.add(UserConstants.EMAIL_NOT_VALID);
                            }
                        } else {
                            errorList.add(UserConstants.EMAIL_NOT_FOUND);
                        }
                        break;
                }
            } catch (Exception e) {
                errorList.add(e.getMessage());
            }
        }
        return userMasterDto;
    }

    /**
     * Get max location level
     *
     * @throws UploadUserException
     */
    private void getMaxLocationLevel() throws UploadUserException {
        try {
            columns = wsReader.getColumnNames();
            for (int i = 0; i < columns.size(); i++) {
                if ((columns.get(i).indexOf("(") != -1 && columns.get(i).indexOf(")") == -1) ||
                        (columns.get(i).indexOf("(") == -1 && columns.get(i).indexOf(")") != -1)) {
                    break;
                }
                if (columns.get(i).indexOf("(") != -1 && columns.get(i).indexOf(")") != -1) {
                    continue;
                }
                this.maxLocationLevel = i;
                break;
            }
            if (maxLocationLevel == null) {
                throw new UploadUserException(UserConstants.SHEET_HEADER_COLUMN_ERROR);
            }
        } catch (Exception e) {
            throw new UploadUserException(UserConstants.SHEET_HEADER_COLUMN_ERROR);
        }

    }

    /**
     * Insert users in database
     *
     * @throws UploadUserException
     */
    public void insertUsers() throws UploadUserException {
        Integer roleId = Integer.valueOf(workSheetName.substring(
                workSheetName.indexOf("(") + 1,
                workSheetName.indexOf(")")));
        RoleMaster roleMaster = this.roleDao.retrieveById(roleId);

        if (roleMaster == null) {
            throw new UploadUserException(UserConstants.ROLE_NOT_EXIST);
        }

        for (Map.Entry<Integer, Map<Integer, UserMasterDto>> userMapEntry : usersLocationMap.entrySet()) {
            LocationMaster locationMaster = this.locationMasterDao.retrieveById(userMapEntry.getKey());

            Map<Integer, UserMasterDto> userRowMap = userMapEntry.getValue();
            for (Map.Entry<Integer, UserMasterDto> userRow : userRowMap.entrySet()) {
                if (resultRowMap.get(userRow.getKey()) == null ||
                        resultRowMap.get(userRow.getKey()).get(UserConstants.ResultFields.RESULT_MESSAGE) == null) {

                    UserMasterDto user = userRow.getValue();
                    UserLocationDto userLocationDto = user.getAddedLocations().get(0);
                    user.setRoleId(roleId);
                    userLocationDto.setType(locationMaster.getType());
                    userLocationDto.setName(locationMaster.getName());
                    userLocationDto.setLevel(LocationConstants.getLocationLevel(locationMaster.getType()));
                    user.getAddedLocations().set(0, userLocationDto);

                    List<UserMaster> usersMatchingPhone = userDao.retrieveByPhone(user.getMobileNumber(), roleId);

                    if (usersMatchingPhone.size() > 0) {
                        usersMatchingPhone = usersMatchingPhone.stream().filter((matchUser) -> matchUser.getFirstName().equals(user.getFirstName())
                                && matchUser.getLastName().equals(user.getLastName())).collect(Collectors.toList());
                        if (usersMatchingPhone.size() > 0) {
                            ImtechoResponseEntity response = userService.validateAOI(user.getId(), roleId, userLocationDao.retrieveLocationIdsByUserId(usersMatchingPhone.get(0).getId()),
                                    userLocationDto.getLocationId());
                            if (response.getErrorcode() != 2) {
                                UserLocation userLocation = userLocationDao.getUserLocationByUserIdLocationId(usersMatchingPhone.get(0).getId(),
                                        userLocationDto.getLocationId());
                                if (userLocation == null) {
                                    userLocationDto.setUserId(usersMatchingPhone.get(0).getId());
                                } else {
                                    userLocationDto.setId(userLocation.getId());
                                    userLocationDto.setUserId(userLocation.getUserId());
                                }
                                userLocationDto.setState(UserLocation.State.ACTIVE);
                                this.crateUserLocation(userLocationDto);
                            } else {
                                setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.RESULT_MESSAGE, UserConstants.USER_WITH_SAME_ROLE_EXIST);
                            }
                        } else {
                            setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.RESULT_MESSAGE, UserConstants.USER_ALREADY_EXIST);
                        }

                        continue;
                    }

                    String tempUserName = String.valueOf(user.getFirstName().toLowerCase().charAt(0));
                    if (user.getMiddleName() != null) {
                        tempUserName += String.valueOf(user.getMiddleName().toLowerCase().charAt(0));
                    }
                    tempUserName += user.getLastName().toLowerCase();
                    String username = userService.fetchAvailableUsername(tempUserName);
                    user.setUserName(username);
                    user.setPrefferedLanguage("GU");
                    user.setPassword(basicPasswordEncryptor.encryptPassword("12345678"));

                    try {
                        Integer userId = this.createUser(user);

                        userLocationDto.setUserId(userId);
                        userLocationDto.setState(UserLocation.State.ACTIVE);
                        this.crateUserLocation(userLocationDto);

                        setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.PASSWORD, "12345678");
                        setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.USER_NAME, username);
                        setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.RESULT_MESSAGE, UserConstants.USER_CREATE_SUCCESS);
                    } catch (Exception e) {
                        setResultRowMapValue(userRow.getKey(), UserConstants.ResultFields.RESULT_MESSAGE, e.getMessage());
                    }
                }
            }
        }
    }

    /**
     * Create result sheet from result data
     *
     * @param workbook
     */
    public void createResultSheet(XSSFWorkbook workbook) {
        XSSFSheet sheet = workbook.getSheet(workSheetName);
        this.addResultColumnInHeader(workbook, sheet);
        for (Map.Entry<Integer, Map<UserConstants.ResultFields, String>> resultRow : resultRowMap.entrySet()) {
            if (!resultRow.getValue().isEmpty()) {
                Row row = sheet.getRow(resultRow.getKey() - 1);
                Map<UserConstants.ResultFields, String> result = resultRow.getValue();
                if (result != null && !result.isEmpty()) {
                    int cellCount = maxLocationLevel + UserConstants.UploadUserFields.values().length;

                    UserConstants.ResultFields[] fields = UserConstants.ResultFields.values();
                    for (int i = cellCount;
                         i < cellCount + fields.length; i++) {
                        Cell value = row.createCell(i);
                        value.setCellValue(result.get(fields[i - cellCount]));
                    }
                }
            }
        }
    }

    /**
     * Add new header columns in result sheet
     *
     * @param workbook
     * @param sheet
     */
    private void addResultColumnInHeader(XSSFWorkbook workbook, XSSFSheet sheet) {
        Row headerRow = sheet.getRow(0);
        int cellCount = maxLocationLevel + UserConstants.UploadUserFields.values().length;

        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setColor(IndexedColors.RED.getIndex());
        style.setFont(font);

        UserConstants.ResultFields[] fields = UserConstants.ResultFields.values();
        for (int i = 0; i < fields.length; i++) {
            Cell label = headerRow.createCell(cellCount++);
            label.setCellValue(fields[i].name());
        }
    }

    /**
     * Get value form column od sheet
     *
     * @param columnIndex column index
     * @return value
     */
    private String getCellValue(Integer columnIndex) {
        String columnName = columns.get(columnIndex);
        columnName = columnName.replaceAll("[^\\w\\s]|[\\n$]", "");
        return wsReader.getValue(columnName);
    }

    /**
     * Create user
     *
     * @param userDto user data
     * @return user id
     */
    private Integer createUser(UserMasterDto userDto) {
        String roleName = roleDao.retrieveById(userDto.getRoleId()).getName();
        UserMaster user = UserMapper.convertUserDtoToMaster(userDto, roleName);
        return this.userDao.create(user);
    }

    /**
     * Create user location
     *
     * @param userLocationDto
     */
    private void crateUserLocation(UserLocationDto userLocationDto) {
        UserLocation userLocation = UserLocationMappper.convertUserLocationDtoToMaster(userLocationDto);
        userLocationDao.createOrUpdate(userLocation);
    }

    private void setResultRowMapValue(Integer key, UserConstants.ResultFields type, String value) {
        Map<UserConstants.ResultFields, String> resultMap = null;
        if (resultRowMap.get(key) == null || resultRowMap.get(key).isEmpty()) {
            resultMap = new LinkedHashMap<>();
        } else {
            resultMap = resultRowMap.get(key);
        }

        if (resultMap.get(type) == null) {
            resultMap.put(type, value);
        } else {
            resultMap.put(type, resultMap.get(type).concat(",").concat("\n").concat(value));
        }
        resultRowMap.put(key, resultMap);

    }

    public Map<Integer, Map<Integer, UserMasterDto>> getUsersLocationMap() {
        return usersLocationMap;
    }

    public void setLocationMasterDao(LocationMasterDao locationMasterDao) {
        this.locationMasterDao = locationMasterDao;
    }

    public void setRoleDao(RoleDao roleDao) {
        this.roleDao = roleDao;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public void setUserDao(UserDao userDao) {
        this.userDao = userDao;
    }

    public void setUserLocationDao(UserLocationDao userLocationDao) {
        this.userLocationDao = userLocationDao;
    }

    public Map<Integer, Map<UserConstants.ResultFields, String>> getResultRowMap() {
        return resultRowMap;
    }

    public void setWsReader(PoiWorksheetReader wsReader) {
        this.wsReader = wsReader;
    }

    public String getWorkSheetName() {
        return workSheetName;
    }

}
