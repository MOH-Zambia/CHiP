package com.argusoft.imtecho.fcm.dao;

import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.fcm.model.FirebaseTokenEntity;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
@Transactional
public interface FirebaseTokenDao extends GenericDao<FirebaseTokenEntity, Integer> {

    boolean isAddedFirebaseToken(int userId, String firebaseToken);
    List<FirebaseTokenEntity> retrieveByUserId(int userId);
}