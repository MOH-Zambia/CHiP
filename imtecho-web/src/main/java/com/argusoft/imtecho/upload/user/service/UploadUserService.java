//package com.argusoft.imtecho.upload.user.service;
//
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.ByteArrayOutputStream;
//import java.util.Map;
//
///**
// * <p>
// * Service for upload user.
// * </p>
// *
// * @author nihar
// * @since 10/07/21 10:19 AM
// */
//public interface UploadUserService {
//
//    /**
//     * Download sample file for upload user
//     *
//     * @param locationId location id
//     * @param roleId     role id
//     * @return ByteArrayOutputStream of excel file
//     */
//    public ByteArrayOutputStream downloadSample(Integer locationId, Integer roleId);
//
//    /**
//     * Upload user file.
//     *
//     * @param file user file.
//     * @return Returns name of file.
//     */
//    String uploadXls(MultipartFile[] file);
//
//    /**
//     * Process user file.
//     *
//     * @param fileName File name.
//     * @return Returns result.
//     */
//    Map<String, String> processXls(String fileName);
//
//}
