package com.argusoft.imtecho.familyqrcode.service.impl;

import com.argusoft.imtecho.common.service.QRCodeGeneratorService;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.familyqrcode.dto.FamilyQRCodeDto;
import com.argusoft.imtecho.familyqrcode.service.FamilyQRCodeService;
import com.argusoft.imtecho.fhs.dao.FamilyDao;
import com.github.jhonnymertz.wkhtmltopdf.wrapper.Pdf;
import com.github.jhonnymertz.wkhtmltopdf.wrapper.params.Param;
import com.google.common.io.ByteSource;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.Objects;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * @author kripansh
 * @since 07/04/23 12:27 pm
 */
@Service
@Transactional
public class FamilyQRCodeServiceImpl implements FamilyQRCodeService {
    @Autowired
    FamilyDao familyDao;

    @Autowired
    QRCodeGeneratorService qrCodeGeneratorService;


    @Override
    public List<FamilyQRCodeDto> getFamilies(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset) {
        return familyDao.getFamiliesForQRCode(locationId, fromDate, toDate, limit, offset);
    }

    @Override
    public ResponseEntity<InputStreamResource> generateQrCode(String familyId, Integer width, Integer height) {
        JsonObject json = new JsonObject();
        json.addProperty("familyId", familyId);
        var gson = new Gson();
        byte[] result = qrCodeGeneratorService.generateQRCode(gson.toJson(json), width, height, null);
        try {
            var resource = new InputStreamResource(ByteSource.wrap(result).openStream());
            var headers = new HttpHeaders();
            headers.add(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=" + "qr-code");
            return ResponseEntity.ok()
                    .headers(headers)
                    .contentLength(result.length)
                    .contentType(MediaType.parseMediaType("application/octet-stream"))
                    .body(resource);
        } catch (Exception e) {
            Logger.getLogger(FamilyQRCodeServiceImpl.class.getName()).log(Level.INFO, e.getMessage(), e);
        }
        return ResponseEntity.status(404).build();
    }

    @Override
    public ByteArrayOutputStream generatePdfForAllFamilies(Integer locationId, String fromDate, String toDate) throws IOException, InterruptedException {
        List<FamilyQRCodeDto> familyList = getFamilies(locationId, fromDate, toDate, null, null);
        return generatePdf(familyList);
    }

    @Override
    public ByteArrayOutputStream generatePdfForFamily(String familyId) throws IOException, InterruptedException {
        List<FamilyQRCodeDto> familyList = new ArrayList<>();
        FamilyQRCodeDto familyQRCodeDto = familyDao.getFamilyDetailsForQRCode(familyId);
        familyList.add(familyQRCodeDto);
        return generatePdf(familyList);
    }

    public ByteArrayOutputStream generatePdf(List<FamilyQRCodeDto> familyList) throws IOException, InterruptedException {
        for (FamilyQRCodeDto family : familyList) {
            ResponseEntity<InputStreamResource> img = generateQrCode(family.getFamilyId(), 300, 300);
            InputStreamResource inputStreamResource = img.getBody();
            byte[] imageByteArray = IOUtils.toByteArray(inputStreamResource.getInputStream());
            StringBuilder dataUri = new StringBuilder();
            dataUri.append("data:image/png;base64, ");
            dataUri.append(Base64.getEncoder().encodeToString(imageByteArray));
            family.setQrCode(dataUri.toString());
        }
        StringBuilder sb = new StringBuilder("<!DOCTYPE html>\n" +
                "<html>\n" +
                "\n" +
                "<head>\n" +
                "    <meta charset=\"UTF-8\">\n" +
                "    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no\">\n" +
                "    <!-- Bootstrap CSS -->\n" +
                "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css\"\n" +
                "        integrity=\"sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm\" crossorigin=\"anonymous\">\n" +
                "\n" +
                "    <style>\n" +
                "        .block {\n" +
                "            width: 3in;\n" +
                "            height: 4in;\n" +
                "            max-width: 3in;\n" +
                "            max-height: 4in;\n" +
                "            border: 2px solid black\n" +
                "        }\n" +
                "\n" +
                "        .border {\n" +
                "            border: 2px solid black !important;\n" +
                "            margin: 28px 0px;\n" +
                "            padding: 24px;\n" +
                "        }\n" +
                "        .table {\n" +
                "            margin-bottom: 0;\n" +
                "        }\n" +
                "\n" +
                "        .para {\n" +
                "            text-align: center;\n" +
                "            white-space: nowrap;\n" +
                "            overflow: hidden;\n" +
                "            width: 300px;\n" +
                "            text-overflow: ellipsis;\n" +
                "            margin: auto;\n" +
                "        }\n" +
                "\n" +
                "        .label {\n" +
                "            font-weight: bold;\n" +
                "            font-size: 25px\n" +
                "        }\n" +
                "\n" +
                "        .value {\n" +
                "            font-size: 25px;\n" +
                "        }\n" +
                "\n" +
                "        .table td,\n" +
                "        .table th {\n" +
                "            border: 2px solid #000000\n" +
                "        }\n" +
                "    </style>\n" +
                "</head>\n" +
                "\n" +
                "<body>\n" +
                "    <div class=\"container-fluid\">\n" +
                "        <div class=\"row\">\n" +
                "            <div class=\"col-12\">\n" +
                "               <div class=\"border\">\n" +
                "                <table class=\"table\">\n" +
                "                    <tr>");
        int index = 0;
        int borderIndex = 0;
        for (FamilyQRCodeDto family : familyList) {
            if (borderIndex == 2 && index == 6) {
                borderIndex = 0;
                index = 0;
                sb.append("</tr>\n")
                        .append("</table>\n")
                        .append("</div>\n")
                        .append("          <div class=\"border\">\n")
                        .append("           <table class=\"table\">\n")
                        .append("                <tr>\n");
            } else if (index == 6) {
                index = 0;
                borderIndex++;
                sb.append("</tr>")
                        .append("<tr>");
            }
            index++;
            sb.append(generatePdfData(family));
        }

        // To fill empty cells in a page
        int familyListBuffer = familyList.size() % 18;
        if (familyListBuffer != 0) {
            int buffer = 18 - familyListBuffer;
            int cells = buffer % 6;
            for (int i = 0; i < cells; i++) {
                sb.append("<td class=\"block\" style=\"border:none\">\n")
                        .append("</td>");
            }
            int rows = buffer / 6;
            for (int i = 0; i < rows; i++) {
                sb.append("</tr>")
                        .append("<tr>");
                for (int j = 0; j < 6; j++) {
                    sb.append("<td class=\"block\" style=\"border:none\">\n")
                            .append("</td>");
                }
            }
        }

        sb.append("</tr></table></div></div></div></div>\n" + "</body> \n" + "</html>");

        String pdfHtml = sb.toString();
        Pdf pdf = new Pdf();
        pdf.addPageFromString(pdfHtml);

        pdf.addParam(new Param("--page-width", "18in"),
                new Param("--page-height", "12in"),
                new Param("--enable-local-file-access"));
        String filePath = "FamilyQRCode.pdf";
        Path outFile = Files.createTempFile(filePath, ".pdf");
        File file = pdf.saveAsDirect(outFile.toString());
        FileInputStream fis = null;
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        byte[] buf = new byte[1024];
        try {
            fis = new FileInputStream(file);
            for (int readNum; (readNum = fis.read(buf)) != -1; ) {
                outputStream.write(buf, 0, readNum); // no doubt here is 0
            }
        } catch (IOException ex) {
            Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            if (Objects.nonNull(fis)) {
                fis.close();
            }
        }
        return outputStream;
    }

    private StringBuilder generatePdfData(FamilyQRCodeDto family) {
        if (family.getFamilyHead().equals("")) {
            family.setFamilyHead("N.A.");
        }
        String imageDirectoryPath = ConstantUtil.REPOSITORY_PATH + ConstantUtil.IMPLEMENTATION_TYPE + File.separator + "images" + File.separator;
        String dgmImagePath = imageDirectoryPath + "dgm.jpeg";
        StringBuilder sb = new StringBuilder();
        sb.append("<td class=\"block\">\n" +
                "<h6 style=\"text-align:center\">UT Administration of DNHDD</h6>" +
                "                            <div class=\"form-group\" style=\"text-align:center\">\n" +
                "                                <img class=\"image\" style=\"width:78px;height:70px\" src=\"" + dgmImagePath + "\" alt=\"Logo\">\n" +
                "                            </div>\n" +
                "                            <div class=\"form-group\" style=\"text-align:center\">\n" +
                "                                <img class=\"image\" width=\"100px\"\n" +
                "                                    src=\"" + family.getQrCode() + "\"\n" +
                "                                    alt=\"QR Code\">\n" +
                "                            </div>\n" +
                "                            <div class=\"data\">\n" +
                "                                <p class=\"para\">\n" +
                "                                    <span class=\"value\">" + family.getHouseNumber() + "</span>\n" +
                "                                </p>\n" +
                "                                <p class=\"para\">\n" +
                "                                    <span class=\"value\">" + family.getFamilyHead() + "</span>\n" +
                "                                </p>\n" +
                "                                <p class=\"para\">\n" +
                "                                    <span class=\"value\">" + family.getFamilyId() + "</span>\n" +
                "                                </p>\n" +
                "                                <p class=\"para\">\n" +
                "                                    <span class=\"value\">" + family.getQrLocation() + "</span>\n" +
                "                                </p>\n" +
                "                                <p class=\"para\">\n" +
                "                                    <span class=\"label\" style=\"font-size:15px\">ASHA: </span>\n" +
                "                                    <span class=\"value\" style=\"font-size:15px\">" + family.getAshaName() + "</span>\n" +
                "                                </p>\n" +
                "                            </div>\n" +
                "                        </td>");
        return sb;
    }


    @Override
    public List<FamilyQRCodeDto> getFamiliesSewa(Integer locationId, String fromDate, String toDate, Integer limit, Integer offset) {
        return familyDao.getFamiliesForQRCodeSewa(locationId, fromDate, toDate, limit, offset);
    }

    @Override
    public ByteArrayOutputStream generatePdfForAllFamiliesSewa(Integer locationId, String fromDate, String toDate) throws IOException, InterruptedException {
        List<FamilyQRCodeDto> familyList = getFamiliesSewa(locationId, fromDate, toDate, null, null);
        return generatePdfSewa(familyList);
    }

    @Override
    public ByteArrayOutputStream generatePdfForFamilySewa(String familyId) throws IOException, InterruptedException {
        List<FamilyQRCodeDto> familyList = new ArrayList<>();
        FamilyQRCodeDto familyQRCodeDto = familyDao.getFamilyDetailsForQRCodeSewa(familyId);
        familyList.add(familyQRCodeDto);
        return generatePdfSewa(familyList);
    }

    public ByteArrayOutputStream generatePdfSewa(List<FamilyQRCodeDto> familyList) throws IOException, InterruptedException {
        for (FamilyQRCodeDto family : familyList) {
            ResponseEntity<InputStreamResource> img = generateQrCode(family.getFamilyId(), 200, 200);
            InputStreamResource inputStreamResource = img.getBody();
            byte[] imageByteArray = IOUtils.toByteArray(inputStreamResource.getInputStream());
            StringBuilder dataUri = new StringBuilder();
            dataUri.append("data:image/png;base64, ");
            dataUri.append(Base64.getEncoder().encodeToString(imageByteArray));
            family.setQrCode(dataUri.toString());
        }
        StringBuilder sb = new StringBuilder("<!DOCTYPE html>" +
                "<html>\n" +
                "<head>\n" +
                "<meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no\">" +
                "\n" +
                "    <!-- Bootstrap CSS -->\n" +
                "    <link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css\"\n" +
                "        integrity=\"sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm\" crossorigin=\"anonymous\">\n" +
                "\n" +
                "    <style>\n" +
                "        .block {\n" +
                "            width: 2.0in;\n" +
                "            height: 2.0in;\n" +
                "            max-width: 2.0in;\n" +
                "            max-height: 2.0in;\n" +
                "            border: 2px solid black\n" +
                "        }\n" +
                "\n" +
                "        .border {\n" +
                "            border: 0px solid black !important;\n" +
                "            margin: 6px 0px;\n" +
                "        }\n" +
                "        .table {\n" +
                "            margin-bottom: 0;\n" +
                "        }\n" +
                "\n" +
                "        .para {\n" +
                "            text-align: center;\n" +
                "            white-space: nowrap;\n" +
                "            overflow: hidden;\n" +
                "            width: 300px;\n" +
                "            text-overflow: ellipsis;\n" +
                "            margin: auto;\n" +
                "        }\n" +
                "\n" +
                "        .label {\n" +
                "            font-weight: bold;\n" +
                "            font-size: 18px\n" +
                "        }\n" +
                "\n" +
                "        .value {\n" +
                "            font-size: 18px;\n" +
                "        }\n" +
                "\n" +
                "        .table td,\n" +
                "        .table th {\n" +
                "            border: 2px solid #000000\n" +
                "        }\n" +
                "    </style>\n" +
                "</head>" +
                "<body> \n" +
                "   <div class=\"container-fluid\">\n" +
                "       <div class=\"row\">\n" +
                "           <div class=\"col-12\">" +
                "               <div class=\"border\">\n" +
                "               <table class=\"table\">" +
                "                   <tr>");
        int index = 0;
        int borderIndex = 0;
        for (FamilyQRCodeDto family : familyList) {
            if (borderIndex == 3 && index == 2) {
                borderIndex = 0;
                index = 0;
                sb.append("</tr>\n")
                        .append("</table>\n")
                        .append("</div>\n")
                        .append("          <div class=\"border\">\n")
                        .append("           <table class=\"table\">\n")
                        .append("                <tr>\n");
            } else if (index == 2) {
                index = 0;
                borderIndex++;
                sb.append("</tr>\n")
                        .append("<tr>");
            }
            index++;
            sb.append(generatePdfDataSewa(family));
        }

        // To fill empty cells in a page
        int familyListBuffer = familyList.size() % 8;
        if (familyListBuffer != 0) {
            int buffer = 8 - familyListBuffer;
            int cells = buffer % 2;
            for (int i = 0; i < cells; i++) {
                sb.append("<td class=\"block\" style=\"border:none\">\n")
                        .append("</td>\n");
            }
            int rows = buffer / 2;
            for (int i = 0; i < rows; i++) {
                sb.append("</tr>\n")
                        .append("<tr>");
                for (int j = 0; j < 2; j++) {
                    sb.append("<td class=\"block\" style=\"border:none\">\n")
                            .append("</td>\n");
                }
            }
        }

        sb.append("</tr></table></div></div></div></div>\n" + "</body> \n" + "</html>");

        String pdfHtml = sb.toString();
        Pdf pdf = new Pdf();
        pdf.addPageFromString(pdfHtml);
        pdf.addParam(new Param("--enable-local-file-access"));
        String filePath = "FamilyQRCode.pdf";
        Path outFile = Files.createTempFile(filePath, ".pdf");
        File file = pdf.saveAsDirect(outFile.toString());
        FileInputStream fis = null;
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        byte[] buf = new byte[1024];
        try {
            fis = new FileInputStream(file);
            for (int readNum; (readNum = fis.read(buf)) != -1; ) {
                outputStream.write(buf, 0, readNum); // no doubt here is 0
            }
        } catch (IOException ex) {
            Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, ex.getMessage(), ex);
        } finally {
            if (Objects.nonNull(fis)) {
                fis.close();
            }
        }
        return outputStream;
    }

    private StringBuilder generatePdfDataSewa(FamilyQRCodeDto family) {
//        String imageDirectoryPath = ConstantUtil.REPOSITORY_PATH + ConstantUtil.IMPLEMENTATION_TYPE + File.separator + "images" + File.separator;
//        String dgmImagePath = imageDirectoryPath + "dgm.jpeg";
        StringBuilder sb = new StringBuilder();
        sb.append("<td class=\"block\">\n" +
                "            <div class=\"form-group\" style=\"text-align:center\">\n" +
                "                <img class=\"image\" width=\"178px\" src=\"" + family.getQrCode() + "\" alt=\"QR Code\">\n" +
                "            </div>\n" +
                "            <div>\n" +
                "                <p class=\"para\">\n" +
                "                    <span class=\"value\">" + family.getHouseNumber() + "</span>\n" +
                "                </p>\n" +
                "                <p class=\"para\">\n" +
                "                    <span class=\"value\">" + family.getFamilyHead() + "</span>\n" +
                "                </p>\n" +
                "                <p class=\"para\">\n" +
                "                    <span class=\"label\">SC/Village: </span>\n" +
                "                    <span class=\"value\">" + family.getQrLocation() + "</span>\n" +
                "                </p>\n" +
                "                <p class=\"para\">\n" +
                "                    <span class=\"label\" style=\"font-size:12px\">ASHA: </span>\n" +
                "                    <span class=\"value\" style=\"font-size:12px\">" + family.getAshaName() + "</span>\n" +
                "                </p>\n" +
                "            </div>\n" +
                "        </td>");
        return sb;
    }
}
