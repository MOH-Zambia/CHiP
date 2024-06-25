package com.argusoft.imtecho.familyqrcode.service;

import com.argusoft.imtecho.familyqrcode.dto.FamilyQRCodeDto;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * @author kripansh
 * @since 07/04/23 12:27 pm
 */
public interface FamilyQRCodeService {
    List<FamilyQRCodeDto> getFamilies(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset);

    ResponseEntity<InputStreamResource> generateQrCode(String familyId, Integer width, Integer height);

    ByteArrayOutputStream generatePdfForAllFamilies(Integer locationId, String fromDate, String toDate) throws IOException, InterruptedException ;

    ByteArrayOutputStream generatePdfForFamily(String familyId) throws IOException, InterruptedException ;

    List<FamilyQRCodeDto> getFamiliesSewa(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset);

    ByteArrayOutputStream generatePdfForAllFamiliesSewa(Integer locationId, String fromDate, String toDate) throws IOException, InterruptedException ;

    ByteArrayOutputStream generatePdfForFamilySewa(String familyId) throws IOException, InterruptedException ;
}
