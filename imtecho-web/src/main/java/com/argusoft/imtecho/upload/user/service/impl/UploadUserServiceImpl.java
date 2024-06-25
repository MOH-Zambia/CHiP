//package com.argusoft.imtecho.upload.user.service.impl;
//
//import com.argusoft.imtecho.common.dto.RoleMasterDto;
//import com.argusoft.imtecho.common.service.RoleHierarchyManagementService;
//import com.argusoft.imtecho.common.service.RoleService;
//import com.argusoft.imtecho.location.dao.LocationTypeMasterDao;
//import com.argusoft.imtecho.location.dto.LocationMasterDto;
//import com.argusoft.imtecho.location.model.LocationTypeMaster;
//import com.argusoft.imtecho.location.service.LocationService;
//import com.argusoft.imtecho.query.dto.QueryDto;
//import com.argusoft.imtecho.query.service.QueryMasterService;
//import com.argusoft.imtecho.reportconfig.service.impl.ReportServiceImpl;
//import com.argusoft.imtecho.spreadsheetloader.location.LocationConstants;
//import com.argusoft.imtecho.spreadsheetloader.location.LocationTransferrer;
//import com.argusoft.imtecho.spreadsheetloader.user.UserConstants;
//import com.argusoft.imtecho.spreadsheetloader.user.UserTransferrer;
//import com.argusoft.imtecho.upload.user.service.UploadUserService;
//import org.apache.poi.ss.usermodel.*;
//import org.apache.poi.xssf.streaming.SXSSFWorkbook;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.ByteArrayOutputStream;
//import java.io.File;
//import java.io.FileOutputStream;
//import java.io.IOException;
//import java.util.*;
//import java.util.logging.Level;
//
///**
// * <p>
// * Service impl for UploadUserService.
// * </p>
// *
// * @author nihar
// * @since 10/07/21 10:19 AM
// */
//@Service
//@Transactional
//public class UploadUserServiceImpl implements UploadUserService {
//
//    private static final Logger log = LoggerFactory.getLogger(UploadUserServiceImpl.class);
//
//    @Autowired
//    private LocationService locationService;
//
//    @Autowired
//    private LocationTypeMasterDao locationTypeMasterDao;
//
//    @Autowired
//    private QueryMasterService queryMasterService;
//
//    @Autowired
//    private UserTransferrer userTransferrer;
//
//    @Autowired
//    private RoleHierarchyManagementService roleHierarchyService;
//
//    @Autowired
//    private RoleService roleService;
//
//    /**
//     * {@inheritDoc}
//     */
//    @Override
//    public ByteArrayOutputStream downloadSample(Integer locationId, Integer roleId) {
//        SXSSFWorkbook workbook = new SXSSFWorkbook();
//        RoleMasterDto roleMasterDto = roleService.retrieveById(roleId);
//        Sheet sheet = workbook.createSheet(roleMasterDto.getName() + "(" + roleMasterDto.getId() + ")");
//
//        CellStyle style = workbook.createCellStyle();
//        Font font = workbook.createFont();
//        font.setColor(IndexedColors.RED.getIndex());
//        style.setFont(font);
//
//        Integer rownum = 0;
//        Integer cellnum = 0;
//
//        LocationMasterDto locationMasterDto = locationService.retrieveById(locationId);
//        Integer maxLevel = locationMasterDto.getLevel();
//        Integer parentId = locationMasterDto.getParent();
//        cellnum = maxLevel - 1;
//
//        Row titleRow = sheet.createRow(rownum++);
//        Row locationRow = sheet.createRow(rownum++);
//        titleRow.setRowStyle(style);
//
//        Cell label = titleRow.createCell(cellnum);
//        Cell value = locationRow.createCell(cellnum);
//
//        LocationTypeMaster locationTypeMaster =
//                this.locationTypeMasterDao.retrieveLocationType(locationMasterDto.getType());
//        label.setCellValue(locationTypeMaster.getName() + "(" + locationMasterDto.getType() + ")");
//        value.setCellValue(locationMasterDto.getEnglishName() + "(" + locationMasterDto.getId() + ")");
//        value.setCellStyle(style);
//
//        for (int i = maxLevel - 1; i > 0; i--) {
//            cellnum--;
//            locationMasterDto = locationService.retrieveById(parentId);
//            locationTypeMaster =
//                    this.locationTypeMasterDao.retrieveLocationType(locationMasterDto.getType());
//            label = titleRow.createCell(cellnum);
//            value = locationRow.createCell(cellnum);
//            label.setCellValue(locationTypeMaster.getName() + "(" + locationMasterDto.getType() + ")");
//            value.setCellValue(locationMasterDto.getEnglishName());
//            value.setCellStyle(style);
//            parentId = locationMasterDto.getParent();
//        }
//
//        UserConstants.UploadUserFields[] fields = UserConstants.UploadUserFields.values();
//        cellnum = maxLevel;
//
//        for (int i = 0; i < fields.length; i++) {
//            label = titleRow.createCell(cellnum);
//            label.setCellValue(fields[i].name());
//            cellnum++;
//        }
//
//        ByteArrayOutputStream excelByteArrayOPStream = new ByteArrayOutputStream();
//
//        try {
//            workbook.write(excelByteArrayOPStream);
//        } catch (Exception e) {
//            log.error(e.getMessage(), e);
//        }
//        return excelByteArrayOPStream;
//    }
//
//
//    /**
//     * {@inheritDoc}
//     */
//    @Override
//    public String uploadXls(MultipartFile[] file) {
//        String fileName = file[0].getOriginalFilename();
//        String filePath = System.getProperty("user.home") + "/SpreadSheet/Newfile";
//        System.out.println(filePath + File.separator + fileName);
//        try (FileOutputStream outputStream = new FileOutputStream(new File(filePath + File.separator + fileName))) {
//
//            outputStream.write(file[0].getBytes());
//
//        } catch (IOException e) {
//            java.util.logging.Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, e.getMessage(), e);
//        }
//
//        return fileName;
//    }
//
//    /**
//     * {@inheritDoc}
//     */
//    @Override
//    public Map<String, String> processXls(String fileName) {
//        String filePath = System.getProperty("user.home") + "/SpreadSheet/Newfile";
//        Map<String, String> result = new LinkedHashMap<>();
//        try {
//            return this.userTransferrer.transfer(filePath, fileName);
//        } catch (Exception ex) {
//            java.util.logging.Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, ex.getMessage(), ex);
//        }
//        return result;
//    }
//}
