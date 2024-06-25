/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.upload.location.service;

import java.util.Map;
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
public interface UploadLocationService {

    /**
     * Upload location file.
     * @param file Location file.
     * @return Returns name of file.
     */
    String uploadXls(MultipartFile[] file);

    /**
     * Process location file.
     * @param fileName File name.
     * @return Returns result.
     */
    Map<String, String> processXls(String fileName);
    
}
