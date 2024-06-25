//package com.argusoft.imtecho.upload.user.controller;
//
//import com.argusoft.imtecho.upload.location.service.UploadLocationService;
//import com.argusoft.imtecho.upload.user.service.UploadUserService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.HttpHeaders;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.util.FileCopyUtils;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import javax.servlet.http.HttpServletResponse;
//import java.io.*;
//import java.net.URLConnection;
//import java.nio.charset.StandardCharsets;
//import java.util.Map;
//
///**
// * <p>
// * Define APIs for upload user.
// * </p>
// *
// * @author nihar
// * @since 06/07/21 10:19 AM
// */
//@RestController
//@RequestMapping("/api/upload/user")
//public class UploadUserController {
//
//    @Autowired
//    private UploadUserService uploadUserService;
//
//    /**
//     * Download sample for upload user
//     *
//     * @param locationId location Id
//     * @param roleId     role id
//     * @return return excel file byte[]
//     * @throws IOException
//     */
//    @GetMapping(value = "/downloadsample/{locationId}", produces = {"application/vnd.ms-excel"})
//    public ResponseEntity<byte[]> downloadSample(@PathVariable Integer locationId, @RequestParam Integer roleId) throws IOException {
//        ByteArrayOutputStream excelOPStream = uploadUserService.downloadSample(locationId, roleId);
//
//        HttpHeaders headers = new HttpHeaders();
//        headers.setContentType(MediaType.parseMediaType("application/vnd.ms-excel"));
//        byte[] data = excelOPStream.toByteArray();
//        headers.setContentDispositionFormData("attachment", "test.xlsx");
//        headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
//        return new ResponseEntity<>(data, headers, HttpStatus.OK);
//    }
//
//    /**
//     * Download result file.
//     *
//     * @param fileName File name.
//     * @param response Instance of HttpServletResponse.
//     * @throws IOException If an I/O error occurs when reading or writing.
//     */
//    @GetMapping(value = "/download/{fileName:.+}")
//    public void downloadXls(@PathVariable("fileName") String fileName, HttpServletResponse response) throws IOException {
//        String filePath = System.getProperty("user.home") + File.separator + "SpreadSheet" + File.separator + "result" + File.separator;
//        File file = new File(filePath + fileName);
//
//        if (!file.exists()) {
//            String errorMessage = "Sorry. The file you are looking for does not exist";
//            OutputStream outputStream = response.getOutputStream();
//            outputStream.write(errorMessage.getBytes(StandardCharsets.UTF_8));
//            outputStream.close();
//            return;
//        }
//
//        String mimeType = URLConnection.guessContentTypeFromName(file.getName());
//        if (mimeType == null) {
//            mimeType = "application/octet-stream";
//        }
//
//        response.setContentType(mimeType);
//
//        response.setHeader("Content-Disposition", String.format("inline; filename=\"%s\"", file.getName()));
//
//        response.setContentLength((int) file.length());
//
//        try (InputStream inputStream = new BufferedInputStream(new FileInputStream(file))) {
//            FileCopyUtils.copy(inputStream, response.getOutputStream());
//        }
//
//    }
//
//    /**
//     * Upload user file.
//     *
//     * @param file user file.
//     * @return Returns name of file.
//     */
//    @PostMapping(value = "", consumes = javax.ws.rs.core.MediaType.MULTIPART_FORM_DATA, produces = javax.ws.rs.core.MediaType.APPLICATION_JSON)
//    public String uploadXls(@RequestParam("file") MultipartFile[] file) {
//        return uploadUserService.uploadXls(file);
//    }
//
//    /**
//     * Process user file.
//     *
//     * @param fileName File name.
//     * @return Returns result.
//     */
//    @PostMapping(value = "/process/{fileName:.+}")
//    public Map<String, String> processXls(@PathVariable("fileName") String fileName) {
//        System.out.println(fileName);
//        return uploadUserService.processXls(fileName);
//    }
//}
