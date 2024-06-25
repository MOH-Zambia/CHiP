/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.upload.location.dto;

/**
 *
 * <p>
 *     Used for folder.
 * </p>
 * @author vivek
 * @since 26/08/20 11:00 AM
 *
 */
public class FolderDto {
    private String folderName;
    private String path;

    public String getFolderName() {
        return folderName;
    }

    public void setFolderName(String folderName) {
        this.folderName = folderName;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
    
}
