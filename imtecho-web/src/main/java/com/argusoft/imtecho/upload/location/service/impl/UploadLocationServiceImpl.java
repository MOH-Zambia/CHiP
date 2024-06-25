/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.upload.location.service.impl;

import com.argusoft.imtecho.location.dao.LocationLevelHierarchyDao;
import com.argusoft.imtecho.location.dao.LocationMasterDao;
import com.argusoft.imtecho.spreadsheetloader.location.LocationTransferrer;
import com.argusoft.imtecho.upload.location.service.UploadLocationService;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * <p>
 *     Define services for upload location.
 * </p>
 * @author harsh
 * @since 26/08/20 11:00 AM
 *
 */
@Service
@Transactional
public class UploadLocationServiceImpl implements UploadLocationService {

    @Autowired
    private LocationMasterDao locationDao;

    @Autowired
    private LocationLevelHierarchyDao locationLevelDao;

    @Autowired
    private LocationTransferrer locationTransferrer;

    /**
     * {@inheritDoc}
     */
    @Override
    public String uploadXls(MultipartFile[] file) {
        String fileName = file[0].getOriginalFilename();
        String filePath = System.getProperty("user.home") + "/SpreadSheet/Newfile";
        try(FileOutputStream outputStream = new FileOutputStream(new File(filePath + File.pathSeparator + fileName))) {
            
            outputStream.write(file[0].getBytes());

        } catch (IOException e) {
            Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, e.getMessage(), e);
        }

        return fileName;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public Map<String, String> processXls(String fileName) {
        String filePath = System.getProperty("user.home") + "/SpreadSheet/Newfile";

        Map<String, String> result = new LinkedHashMap<>();
        try {
            return locationTransferrer.transfer(filePath, fileName);
        } catch (Exception ex) {
            Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, ex.getMessage(), ex);
        }
        return result;
    }

}
