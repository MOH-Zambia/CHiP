
package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.common.dto.ServerManagementDto;
import com.argusoft.imtecho.common.dto.SyncServerDto;
import com.argusoft.imtecho.common.dto.SyncWithServerDto;
import java.util.List;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.ResponseEntity;

/**
 * <p>
 *     Define methods for server management
 * </p>
 * @author vivek
 * @since 27/08/2020 4:30
 */
public interface ServerManagementService {

     /**
      * Sets a list of files on given folder to ServerManagementDto and return it
      * @param folderPath A path of folder
      * @return An instance of ServerManagementDto
      */
     ServerManagementDto retrieveFilesByFolderPath(String folderPath);

     /**
      * Returns response entity of given file to download it
      * @param filePath A file path
      * @return An instance of InputStreamResource
      */
     ResponseEntity<InputStreamResource> downloadFile(String filePath);

     /**
      * Executes given command
      * @param command A command to execute
      * @param host A value of host
      * @param userName A user name
      * @param password A user's password
      * @return A string of result
      */
     String executeCommand(String command, String host, String userName, String password);

     /**
      * Fetch and insert configuration
      */
     void fetchAndInsertConfiguration();

     /**
      * Saves SyncServerDto
      * @param syncWithServerDto  An instance of SyncServerDto
      */
     void saveSyncWithServer(SyncWithServerDto syncWithServerDto);

     /**
      * Sync given a list of server with current server
      * @param syncWithServerDtos A list of SyncServerDto
      */
     void bulkSaveSyncWithServer(List<SyncWithServerDto> syncWithServerDtos);


     /**
      * Async given servers from current server
      * @param syncWithServerDtos A list of SyncServerDto
      */
     void bulkASyncWithServer(List<SyncWithServerDto> syncWithServerDtos);

     /**
      * Creates or update server
      * @param syncServerDto An instance of SyncServerDto
      */
     void createOrUpdate(SyncServerDto syncServerDto);
}
