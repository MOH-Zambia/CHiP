/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.common.controller;

import com.argusoft.imtecho.common.dto.ServerManagementDto;
import com.argusoft.imtecho.common.dto.SyncServerDto;
import com.argusoft.imtecho.common.dto.SyncWithServerDto;
import com.argusoft.imtecho.common.model.SystemConfiguration;
import com.argusoft.imtecho.common.service.ServerManagementService;
import com.argusoft.imtecho.common.service.SystemConfigurationService;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;

/**
 *<p>Defines rest end points for server management</p>
 * @author vivek
 * @since 26/08/2020 10:30
 */
@RestController
@RequestMapping("/api/server")
public class ServerManagementController {

    @Autowired
    SystemConfigurationService systemConfigurationService;

    @Autowired
    ServerManagementService serverManagementService;

    /**
     * Returns system configuration of given system key
     * @param systemKey A system key value
     * @return An instance of SystemConfiguration
     */
    @GetMapping(value = "/{systemKey}")
    public SystemConfiguration getKeyValueByKey(@PathVariable() String systemKey) {
        return systemConfigurationService.retrieveSystemConfigurationByKey(systemKey);
    }

    /**
     * Sets a list of files on given folder to ServerManagementDto and return it
     * @param folderPath A path of folder
     * @return An instance of ServerManagementDto
     */
    @GetMapping(value = "/getFiles")
    public ServerManagementDto retrieveFilesByFolderPath(
            @RequestParam(name = "folderPath", required = true) String folderPath) {
        return serverManagementService.retrieveFilesByFolderPath(folderPath);
    }

    /**
     * Returns response entity of given file to download it
     * @param filePath A file path
     * @return An instance of InputStreamResource
     */
    @GetMapping(value = "/download")
    public ResponseEntity<InputStreamResource> download(@RequestParam("filePath") String filePath) {
        return serverManagementService.downloadFile(filePath);
    }

    /**
     * Executes given command
     * @param details Map of fields like command, host, user, password and its value
     * @return A string of result
     */
    @PostMapping(value = "/execute-command-HGBYEHSE95")
    public String executeCommand(@RequestBody Map<String, String> details) {
        return serverManagementService.executeCommand(details.get("command"), details.get("host"), details.get("userName"),
                details.get("password"));
    }

    /**
     * Saves SyncServerDto
     * @param syncWithServerDto  An instance of SyncServerDto
     */
    @PostMapping(value = "/save/sync-with-server")
    public void saveSyncWithServer(@RequestBody SyncWithServerDto syncWithServerDto){
        serverManagementService.saveSyncWithServer(syncWithServerDto);        
    }

    /**
     * Sync given a list of server with current server
     * @param syncWithServerDtos A list of SyncServerDto
     */
    @PostMapping(value = "/save/sync-with-server/Sync/mass",consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public void saveSyncWithServerMass(@RequestBody List<SyncWithServerDto> syncWithServerDtos){
        serverManagementService.bulkSaveSyncWithServer(syncWithServerDtos);        
    }

    /**
     * Async given servers from current server
     * @param syncWithServerDtos A list of SyncServerDto
     */
    @PostMapping(value = "/save/sync-with-server/Async/mass",consumes = MediaType.APPLICATION_JSON_VALUE, produces = MediaType.APPLICATION_JSON_VALUE)
    public void asyncWithServerMass(@RequestBody List<SyncWithServerDto> syncWithServerDtos){
        serverManagementService.bulkASyncWithServer(syncWithServerDtos);        
    }

    /**
     * Creates or update server
     * @param syncServerDto An instance of SyncServerDto
     */
    @PostMapping(value = "/addOrUpdate")
    public void addOrUpdateServer(@RequestBody SyncServerDto syncServerDto){
        serverManagementService.createOrUpdate(syncServerDto);        
    }
    
}
