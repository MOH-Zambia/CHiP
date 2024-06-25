/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.common.dto;

import com.argusoft.imtecho.common.model.FileDetails;
import com.fasterxml.jackson.annotation.JsonInclude;
import java.util.List;

/**
 * <p>Defines fields related to server management</p>
 * @author vivek
 * @since 26/08/2020 5:30
 */
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ServerManagementDto {

    private List<FileDetails> fileList;

    public List<FileDetails> getFileList() {
        return fileList;
    }

    public void setFileList(List<FileDetails> fileList) {
        this.fileList = fileList;
    }

}
