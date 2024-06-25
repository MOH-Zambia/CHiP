package com.argusoft.imtecho.familyqrcode.controller;

import com.argusoft.imtecho.familyqrcode.dto.FamilyQRCodeDto;
import com.argusoft.imtecho.familyqrcode.service.FamilyQRCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;

/**
 * @author kripansh
 * @since 07/04/23 12:25 pm
 */
@RestController
@RequestMapping("/api/familyqrcode")
public class FamilyQRCodeController {
    @Autowired
    FamilyQRCodeService familyQRCodeService;

    @GetMapping(path = "/family")
    public List<FamilyQRCodeDto> getFamilies(@RequestParam(name="locationId") Integer locationId,
                                             @RequestParam(name="toDate") String toDate,
                                             @RequestParam(name="fromDate") String fromDate,
                                             @RequestParam(name="limit") Integer limit,
                                             @RequestParam(name="offset") Integer offset) {
        return familyQRCodeService.getFamilies(locationId, fromDate, toDate, limit, offset);
    }

    @GetMapping(path = "/generateqrcode")
    public ResponseEntity<InputStreamResource> generateQRCode(@RequestParam String familyId) {
        return familyQRCodeService.generateQrCode(familyId, 250, 250);
    }

    @GetMapping(path = "/generatepdf")
    public ResponseEntity<byte[]> generatePdf(@RequestParam(name="familyId", required = false) String familyId,
                                              @RequestParam(name="locationId", required = false) Integer locationId,
                                              @RequestParam(name="toDate", required = false) String toDate,
                                              @RequestParam(name="fromDate", required = false) String fromDate) throws IOException, InterruptedException  {
        ByteArrayOutputStream pdfOPStream = new ByteArrayOutputStream();
        if(familyId == null){
            pdfOPStream = familyQRCodeService.generatePdfForAllFamilies(locationId, fromDate, toDate);
        } else if (locationId == null) {
            pdfOPStream = familyQRCodeService.generatePdfForFamily(familyId);
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/pdf"));
        byte[] data = pdfOPStream.toByteArray();
        headers.setContentDispositionFormData("attachment", "test.pdf");
        headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
        return new ResponseEntity<>(data, headers, HttpStatus.OK);
    }

    @GetMapping(path = "/familysewa")
    public List<FamilyQRCodeDto> getFamiliesSewa(@RequestParam(name="locationId") Integer locationId,
                                             @RequestParam(name="toDate") String toDate,
                                             @RequestParam(name="fromDate") String fromDate,
                                             @RequestParam(name="limit") Integer limit,
                                             @RequestParam(name="offset") Integer offset) {
        return familyQRCodeService.getFamiliesSewa(locationId, fromDate, toDate, limit, offset);
    }

    @GetMapping(path = "/generatepdfsewa")
    public ResponseEntity<byte[]> generatePdfSewa(@RequestParam(name="familyId", required = false) String familyId,
                                              @RequestParam(name="locationId", required = false) Integer locationId,
                                              @RequestParam(name="toDate", required = false) String toDate,
                                              @RequestParam(name="fromDate", required = false) String fromDate) throws IOException, InterruptedException  {
        ByteArrayOutputStream pdfOPStream = new ByteArrayOutputStream();
        if(familyId == null){
            pdfOPStream = familyQRCodeService.generatePdfForAllFamiliesSewa(locationId, fromDate, toDate);
        } else if (locationId == null) {
            pdfOPStream = familyQRCodeService.generatePdfForFamilySewa(familyId);
        }
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.parseMediaType("application/pdf"));
        byte[] data = pdfOPStream.toByteArray();
        headers.setContentDispositionFormData("attachment", "test.pdf");
        headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");
        return new ResponseEntity<>(data, headers, HttpStatus.OK);
    }
}
