/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.upload.location.controller;

import com.argusoft.imtecho.upload.location.service.UploadLocationService;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLConnection;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.core.MediaType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 *
 * <p>
 * Define APIs for upload location.
 * </p>
 *
 * @author harsh
 * @since 26/08/20 10:19 AM
 */
@RestController
@RequestMapping("/api/upload/location")
public class UploadLocationController {

    @Autowired
    UploadLocationService uploadLocationService;

    /**
     * Upload location file.
     * @param file Location file.
     * @return Returns name of file.
     */
    @PostMapping(value = "", consumes = MediaType.MULTIPART_FORM_DATA, produces = MediaType.APPLICATION_JSON)
    public String uploadXls(@RequestParam("file") MultipartFile[] file) {
        return uploadLocationService.uploadXls(file);
    }

    /**
     * Download file.
     * @param fileName File name.
     * @param response Instance of HttpServletResponse.
     * @throws IOException If an I/O error occurs when reading or writing.
     */
    @GetMapping(value = "/download/{fileName:.+}")
    public void downloadXls(@PathVariable("fileName") String fileName, HttpServletResponse response) throws IOException {
        String filePath = System.getProperty("user.home") + File.separator + "SpreadSheet" + File.separator + "Error" + File.separator;
        File file = new File(filePath + fileName);

        if (!file.exists()) {
            String errorMessage = "Sorry. The file you are looking for does not exist";
            OutputStream outputStream = response.getOutputStream();
            outputStream.write(errorMessage.getBytes(StandardCharsets.UTF_8));
            outputStream.close();
            return;
        }

        String mimeType = URLConnection.guessContentTypeFromName(file.getName());
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }

        response.setContentType(mimeType);

        response.setHeader("Content-Disposition", String.format("inline; filename=\"%s\"",file.getName()));

        response.setContentLength((int) file.length());

        try(InputStream inputStream = new BufferedInputStream(new FileInputStream(file))){
                    FileCopyUtils.copy(inputStream, response.getOutputStream());
        }
        
    }

    /**
     * Process location file.
     * @param fileName File name.
     * @return Returns result.
     */
    @PostMapping(value = "/process/{fileName:.+}")
    public Map<String, String> processXls(@PathVariable("fileName") String fileName) {
        return uploadLocationService.processXls(fileName);
    }
}
