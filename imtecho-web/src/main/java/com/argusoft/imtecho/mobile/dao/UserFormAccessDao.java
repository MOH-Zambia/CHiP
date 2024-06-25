/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.imtecho.mobile.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.mobile.dto.UserFormAccessBean;
import com.argusoft.imtecho.mobile.model.UserFormAccess;
import java.util.List;

/**
 *
 * @author avani
 */
public interface UserFormAccessDao extends GenericDao<UserFormAccess, Integer>{
    
    List<UserFormAccessBean> getUserFormAccessDetail(int userId);

    boolean checkIfUserFormAccessAlreadyExists(Integer userId, String formCode);
    
    void updateUserFormAccess();
    
}
