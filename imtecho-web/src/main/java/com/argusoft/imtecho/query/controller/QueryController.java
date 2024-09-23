/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.query.controller;

import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.query.dto.QueryDto;
import com.argusoft.imtecho.query.dto.QueryMasterDto;
import com.argusoft.imtecho.query.dto.QueryWithSQLDto;
import com.argusoft.imtecho.query.service.QueryMasterService;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.*;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

/**
 * <p>Defines rest end points for query</p>
 * @author vaishali
 * @since 02/09/2020 10:30
 */
@RestController
@RequestMapping("/api/resource")
public class QueryController {

    @Autowired
    QueryMasterService queryMasterService;

    /**
     * Returns all configured query based on given status
     * @param isActive A status value
     * @return A list of QueryMasterDto
     */
    @GetMapping(value = "")
    public List<QueryMasterDto> retrieveAllConfigure(@RequestParam(value = "is_active", required = false) Boolean isActive) {
        return queryMasterService.retrieveAll(isActive);
    }

    /**
     * Returns query of given UUID
     * @param id An UUID
     * @return An instance of QueryMasterDto
     */
    @GetMapping(value = "/{id}")
    public QueryMasterDto retrieveById(@PathVariable Integer id) {
        return queryMasterService.retrieveById(id);
    }

    /**
     * Creates or update query
     * @param queryMasterDto An instance of QueryMasterDto
     */
    @PostMapping(value = "")
    public void createOrUpdate(@RequestBody QueryMasterDto queryMasterDto) {
        queryMasterService.createOrUpdate(queryMasterDto,false);
    }

    /**
     * Updates a status of query
     * @param queryMasterDto An instance of QueryMasterDto
     */
    @PutMapping(value = "")
    public void toggleActive(@RequestBody QueryMasterDto queryMasterDto) {
        if (queryMasterDto.getUuid() == null) {
            queryMasterDto.setUuid(UUID.randomUUID());
        }
        queryMasterService.toggleActive(queryMasterDto);
    }

    /**
     * Execute a query from given query dto
     * @param queryDto An instance of QueryDto
     * @return An instance of QueryDto
     */
    @PostMapping(value = "/getdata")
    public QueryDto executeQuery(@RequestBody QueryDto queryDto) {
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        List<QueryDto> executeQueryByCode = queryMasterService.executeQuery(queryDtos, true);
        if (!executeQueryByCode.isEmpty()) {
            return executeQueryByCode.get(0);
        } else {
            throw new ImtechoSystemException("Get multiple response " + queryDto, 0);
        }
    }

    @PostMapping(value = "/getdatawithtimeout")
    public QueryDto executeQueryWithTimeout(@RequestBody QueryDto queryDto) {
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        ExecutorService es = Executors.newSingleThreadExecutor();
        CompletableFuture<List<QueryDto>> cf = CompletableFuture.supplyAsync(()->{
            try {
                return queryMasterService.executeQuery(queryDtos, true);
            } catch (Exception e) {
                throw new ImtechoSystemException("Error executing query", 0);
            }
        }, es);
        try {
            List<QueryDto> retrievedDto = cf.get(5, TimeUnit.SECONDS);
            if (!retrievedDto.isEmpty()) {
                return retrievedDto.get(0);
            } else {
                throw new ImtechoSystemException("Gets multiple responses: " + queryDto, 0);
            }
        } catch (TimeoutException e) {
            throw new ImtechoSystemException("One or more tables seem to be locked, remove locks or try again later", 0);
        } catch (Exception e) {
            throw new ImtechoSystemException(e.toString(), 0);
        }
        finally {
            es.shutdown();
        }
    }

    /**
     * Execute a query from given query dto
     * @param code A query code
     * @param queryDto An instance of QueryDto
     * @return An instance of QueryDto
     */
    @PostMapping(value = "/getdata/{code}")
    public QueryDto execute(@PathVariable(value = "code")String code
            ,  @RequestBody QueryDto queryDto) {
        List<QueryDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        List<QueryDto> executeQueryByCode = queryMasterService.execute(queryDtos, true);
        if (!executeQueryByCode.isEmpty()) {
            return executeQueryByCode.get(0);
        } else {
            throw new ImtechoSystemException("Get multiple response " + queryDto, 0);
        }
    }

    /**
     * Executes query from given a list of query dto
     * @param queryDtos A list of QueryDto
     * @return A list of QueryDto
     */
    @PostMapping(value = "/getdatas")
    public List<QueryDto> executeQuery(@RequestBody List<QueryDto> queryDtos) {
        for (QueryDto query : queryDtos) {
            if (query.getSequence() == null) {
                throw new ImtechoSystemException("Please add Sequence!", 0);
            }
        }
        try {
            return queryMasterService.executeQuery(queryDtos, true);
        } catch (Exception e) {
            throw new ImtechoSystemException("Exception in getdata " + queryDtos, e);
        }
    }

    /**
     * Executes query from given a list of query dto
     * @param queryDtos A list of QueryDto
     * @return A list of QueryDto
     */
    @PostMapping(value = "/getalldata")
    public List<QueryDto> executeAll(@RequestBody List<QueryDto> queryDtos) {
        for (QueryDto query : queryDtos) {
            if (query.getSequence() == null) {
                throw new ImtechoSystemException("Please add Sequence!", 0);
            }
        }
        try {
            return queryMasterService.execute(queryDtos, true);
        } catch (Exception e) {
            throw new ImtechoSystemException("Exception in getdata " + queryDtos, e);
        }
    }

    /**
     * Executes given query
     * @param query An query string
     */
    @PostMapping(value = "/runquery")
    public void runQuery(@RequestBody String query) {
        queryMasterService.runUpdateQuery(query);
    }


    /**
     * Execute a query from given query dto
     * @param code A query code
     * @param queryDto An instance of QueryWithSQLDto
     * @return An instance of QueryWithSQLDto
     */
    @PostMapping(value = "/getdataforformconfigurator/{code}")
    public QueryWithSQLDto executeForFormConfigurator(@PathVariable(value = "code")String code, @RequestBody QueryWithSQLDto queryDto) {
        List<QueryWithSQLDto> queryDtos = new LinkedList<>();
        queryDtos.add(queryDto);
        List<QueryWithSQLDto> executeQueryByCode = queryMasterService.executeForFormConfigurator(queryDtos, true);
        if (!executeQueryByCode.isEmpty()) {
            return executeQueryByCode.get(0);
        } else {
            throw new ImtechoSystemException("Get multiple response " + queryDto, 0);
        }
    }

    /**
     * Executes query from given a list of query dto
     * @param queryDtos A list of QueryWithSQLDto
     * @return A list of QueryWithSQLDto
     */
    @PostMapping(value = "/getalldataforformconfigurator")
    public List<QueryWithSQLDto> executeAllForFormConfigurator(@RequestBody List<QueryWithSQLDto> queryDtos) {
        for (QueryWithSQLDto query : queryDtos) {
            if (query.getSequence() == null) {
                throw new ImtechoSystemException("Please add Sequence!", 0);
            }
        }
        try {
            return queryMasterService.executeForFormConfigurator(queryDtos, true);
        } catch (Exception e) {
            throw new ImtechoSystemException("Exception in getdata " + queryDtos, e);
        }
    }

}
