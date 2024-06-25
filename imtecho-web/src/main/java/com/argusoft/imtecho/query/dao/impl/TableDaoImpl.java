/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.query.dao.impl;

import com.argusoft.imtecho.common.component.AliasToEntityLinkedMapResultTransformer;
import com.argusoft.imtecho.common.util.ConstantUtil;
import com.argusoft.imtecho.common.util.QueryAndResponseAnalysisService;
import com.argusoft.imtecho.exception.ImtechoSystemException;
import com.argusoft.imtecho.query.dao.TableDao;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Collection;
import java.util.Date;
import java.util.UUID;

import lombok.extern.slf4j.Slf4j;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

/**
 * Implements methods of TableDao
 *
 * @author vaishali
 * @since 02/09/2020 10:30
 */
@Slf4j
@Repository
@Transactional
public class TableDaoImpl implements TableDao {
    @Autowired
    SessionFactory sessionFactory;

    @Autowired
    QueryAndResponseAnalysisService queryAndResponseAnalysisService;

    /**
     * {@inheritDoc}
     */
    @Override
    public List<Map<String, Object>> executeQueryForCombo(String queryString, String reportName) {
        List<Map<String, Object>> optionsList = new ArrayList<>();
        NativeQuery<Object> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
        List<Object> results = query.list();
        if(!results.isEmpty() && results.size() > ConstantUtil.MAXIMUM_AMOUNT_OF_ROWS_FETCH_FROM_DB){
            log.info("Query  ======> {}\nReport Name  ======> {}\nNumber Of Rows ======> {}", queryString, reportName, results.size());
            queryAndResponseAnalysisService.insertQueryAnalysisDetails(queryString, reportName, results.size());
        }
        for (Object result : results) {
            if (result != null && result.getClass().isArray()) {
                Object[] resultArray = (Object[]) result;
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("key", resultArray[0]);
                if (resultArray.length > 1) {
                    resultMap.put("value", resultArray[1]);
                    if (resultArray.length > 2) {
                        resultMap.put("selected", resultArray[2]);

                    }
                }

                optionsList.add(resultMap);
            } else {
                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("key", result);
                resultMap.put("value", result);
                optionsList.add(resultMap);
            }
        }
        return optionsList;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LinkedHashMap<String, Object>> executeQuery(String queryString) {
        List<LinkedHashMap<String, Object>> linkedHashMaps;
        NativeQuery<LinkedHashMap<String, Object>> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
        query.setResultTransformer(AliasToEntityLinkedMapResultTransformer.INSTANCE);
        linkedHashMaps = query.list();
        if(!linkedHashMaps.isEmpty() && linkedHashMaps.size() > ConstantUtil.MAXIMUM_AMOUNT_OF_ROWS_FETCH_FROM_DB){
            log.info("Query  ======> {}\nNumber Of Rows ======> {}", queryString, linkedHashMaps.size());
            queryAndResponseAnalysisService.insertQueryAnalysisDetails(queryString, null, linkedHashMaps.size());
        }
        return linkedHashMaps;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public List<LinkedHashMap<String, Object>> execute(String queryString, LinkedHashMap<String, Object> parameterValue) {
        List<LinkedHashMap<String, Object>> linkedHashMaps;
        try {
            NativeQuery<LinkedHashMap<String, Object>> query = sessionFactory.getCurrentSession().createSQLQuery(queryString);
            if (Objects.nonNull(parameterValue)) {
                for (Map.Entry<String, Object> entry : parameterValue.entrySet()) {
                    Object obj = entry.getValue();
                    String key = entry.getKey();
                    if (obj instanceof Collection<?>) {
                        query.setParameterList(key, (Collection<?>) obj);
                    } else if (obj instanceof Object[]) {
                        query.setParameterList(key, (Object[]) obj);
                    } else if (obj instanceof Date) {
                        query.setParameter(key, obj);
                    } else if (obj instanceof UUID) {
                        query.setParameter(key, obj.toString());
                    } else if (Objects.nonNull(obj) && Objects.nonNull(getDate(obj.toString()))) {
                        query.setParameter(key, getDate(obj.toString()));
                    } else {
                        query.setParameter(key, obj);
                    }

                }
            }
            query.setResultTransformer(AliasToEntityLinkedMapResultTransformer.INSTANCE);
            linkedHashMaps = query.list();
            if(!linkedHashMaps.isEmpty() && linkedHashMaps.size() > ConstantUtil.MAXIMUM_AMOUNT_OF_ROWS_FETCH_FROM_DB){
                String parameters = Objects.nonNull(parameterValue) ? parameterValue.toString() : null;
                log.info("Query  ======> {}\nParameters ======> {}\nNumber Of Rows ======> {}", queryString, parameters, linkedHashMaps.size());
                queryAndResponseAnalysisService.insertQueryAnalysisDetails(queryString, parameters, linkedHashMaps.size());
            }
        } catch (Exception e) {
            log.info("Error queryString " + e.getMessage() + " : {} ", queryString);
            throw new ImtechoSystemException("Error from execute method, queryString : " + queryString, e);
        }
        return linkedHashMaps;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void executeUpdate(String queryString) {
        NativeQuery<Integer> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
        query.setTimeout(14400);
        try {
            query.executeUpdate();
        } catch (Exception e) {
            log.info("Error queryString : {} ", queryString);
            throw new ImtechoSystemException("Error from executeUpdate, queryString : " + queryString, e);
        }
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public void executeUpdateQuery(String queryString, LinkedHashMap<String, Object> parameterValue) {
        try {
            NativeQuery<Integer> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
            if (Objects.nonNull(parameterValue)) {
                for (Map.Entry<String, Object> entry : parameterValue.entrySet()) {
                    Object obj = entry.getValue();
                    String key = entry.getKey();
                    if (obj instanceof Collection<?>) {
                        query.setParameterList(key, (Collection<?>) obj);
                    } else if (obj instanceof Object[]) {
                        query.setParameterList(key, (Object[]) obj);
                    } else if (obj instanceof Date) {
                        query.setParameter(key, obj);
                    } else if (obj instanceof UUID) {
                        query.setParameter(key, obj.toString());
                    } else if (Objects.nonNull(obj) && Objects.nonNull(getDate(obj.toString()))) {
                        query.setParameter(key, getDate(obj.toString()));
                    } else {
                        query.setParameter(key, obj);
                    }
                }
            }
            query.setTimeout(14400);
            query.executeUpdate();
        } catch (Exception e) {
            log.info("Error queryString : {}", queryString);
            throw new ImtechoSystemException("Error from executeUpdateQuery, queryString : " + queryString, e);
        }

    }

    private Date getDate(String inDate) {
        if (inDate.split("-").length == 3) {
            SimpleDateFormat dateFormat;
            if (inDate.split("-")[0].length() == 4) {
                if (inDate.contains(":"))
                    dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                else
                    dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            } else {
                if (inDate.contains(":"))
                    dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
                else
                    dateFormat = new SimpleDateFormat("dd-MM-yyyy");
            }
            dateFormat.setLenient(false);
            try {
                return dateFormat.parse(inDate.trim());
            } catch (ParseException e) {
                log.error(e.toString());
                return null;
            }
        } else {
            return null;
        }
    }

    @Override
    public void executeUpdateQueryWithoutCast(String queryString, LinkedHashMap<String, Object> parameterValue) {
        try {
            NativeQuery<Integer> query = sessionFactory.getCurrentSession().createNativeQuery(queryString);
            if (Objects.nonNull(parameterValue)) {
                for (Map.Entry<String, Object> entry : parameterValue.entrySet()) {
                    Object obj = entry.getValue();
                    String key = entry.getKey();
                    query.setParameter(key, obj);
                }
            }
            query.setTimeout(14400);
            query.executeUpdate();
        } catch (Exception e) {
            log.info("Error queryString : {}", queryString);
            throw new ImtechoSystemException("Error from executeUpdateQuery, queryString : " + queryString, e);
        }
    }
}
