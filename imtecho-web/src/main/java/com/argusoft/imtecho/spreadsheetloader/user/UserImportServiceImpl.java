package com.argusoft.imtecho.spreadsheetloader.user;

import com.argusoft.imtecho.common.dao.RoleDao;
import com.argusoft.imtecho.common.dao.UserDao;
import com.argusoft.imtecho.common.dao.UserLocationDao;
import com.argusoft.imtecho.common.dto.UserMasterDto;
import com.argusoft.imtecho.common.service.UserService;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.spreadsheetloader.location.LocationConstants;
import common.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * <p>
 * Implementation of UserImportService
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
@Service
@Transactional
public class UserImportServiceImpl implements UserImportService {

    public static final Logger logger = Logger.getLogger(UserImportServiceImpl.class);

    @Autowired
    private LocationMasterDao locationMasterDao;

    @Autowired
    private RoleDao roleDao;

    @Autowired
    private UserDao userDao;

    @Autowired
    private UserService userService;

    @Autowired
    private UserLocationDao userLocationDao;

    private UserSpreadsheetImpl userSpreadsheetImpl;

    /**
     * Generate file path using input path and file name
     *
     * @param path     Path name
     * @param fileName File name
     * @return file path with name
     */
    public String generateFileName(String path, String fileName) {

        if (path != null && !path.equalsIgnoreCase("")) {
            return path + File.separator + fileName;
        } else {
            StringBuilder filePathBuilder = new StringBuilder();

            filePathBuilder.append(System.getProperty("user.home"));
            filePathBuilder.append(File.separator);
            filePathBuilder.append(LocationConstants.SPREAD_SHEET);
            filePathBuilder.append(File.separator);
            filePathBuilder.append(LocationConstants.NEW_FILE);
            filePathBuilder.append(File.separator);
            filePathBuilder.append(fileName);

            return filePathBuilder.toString();
        }
    }

    /**
     * Transfer user.
     *
     * @param inputPath Input file path.
     * @param fileName  File name.
     * @return Returns result.
     */
    @Override
    public Map<String, String> transfer(String inputPath, String fileName) {
        Map<String, String> resultMap = new LinkedHashMap<>();

        Map<String, Map<Integer, Map<Integer, UserMasterDto>>> wsUserMap = new LinkedHashMap<>();

        String filePath = generateFileName(inputPath, fileName);

        try {
            UserSpreadsheetImpl spreadsheetImpl = new UserSpreadsheetImpl(filePath);
            this.setUserSpredsheetImpl(spreadsheetImpl);
            spreadsheetImpl.init();
            wsUserMap = spreadsheetImpl.getWsUserMap();

            UserWorkSheetImpl workSheetImpl;

            if (!wsUserMap.isEmpty()) {
                for (Map.Entry<String, Map<Integer, Map<Integer, UserMasterDto>>> userMapEntry : wsUserMap.entrySet()) {

                    Map<Integer, Map<Integer, UserMasterDto>> userMap = userMapEntry.getValue();

                    workSheetImpl = spreadsheetImpl.getWorkSheetInstance(userMapEntry.getKey());

                    if (userMap != null && !userMap.isEmpty()) {
                        workSheetImpl.setUserService(userService);
                        workSheetImpl.setLocationMasterDao(locationMasterDao);
                        workSheetImpl.setRoleDao(roleDao);
                        workSheetImpl.setUserDao(userDao);
                        workSheetImpl.setUserLocationDao(userLocationDao);
                        workSheetImpl.insertUsers();
                    }
                }
                String resultFileName = userSpreadsheetImpl.createResultWorkbook();
                resultMap.put(UserConstants.RESULT_FILE, resultFileName);
            } else {
                resultMap.put(UserConstants.RESULT, UserConstants.NO_USER_FOUND);
            }
        } catch (Exception e) {
            resultMap.put(UserConstants.RESULT, e.toString());
        }
        return resultMap;
    }


    public void setUserSpredsheetImpl(UserSpreadsheetImpl userSpreadsheetImpl) {
        this.userSpreadsheetImpl = userSpreadsheetImpl;
    }

}
