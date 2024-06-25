package com.argusoft.imtecho.common.dao;

import com.argusoft.imtecho.common.model.UserHealthInfrastructure;
import com.argusoft.imtecho.database.common.GenericDao;
import com.argusoft.imtecho.location.model.HealthInfrastructureDetails;

import java.util.Date;
import java.util.List;

/**
 * <p>Defines database method for user health infrastructure</p>
 *
 * @author vaishali
 * @since 31/08/2020 10:30
 */

public interface UserHealthInfrastructureDao extends GenericDao<UserHealthInfrastructure, Integer> {
    /**
     * Returns a list of user health infra structure based on given user id and health infrastructure id
     *
     * @param userId                 A user id
     * @param healthInfrastructureId A health infrastructure id
     * @return A list of UserHealthInfrastructure
     */
    List<UserHealthInfrastructure> retrieveByHealthInfrastructureIdAndUserId(Integer userId, Integer healthInfrastructureId);

    /**
     * Returns a list of user health infra structure based on given user id
     *
     * @param userId A user id
     * @return A list of UserHealthInfrastructure
     */
    List<UserHealthInfrastructure> retrieveByUserId(Integer userId);

    List<UserHealthInfrastructure> retrieveByHealthInfrastructureId(Integer healthInfrastructureId);

    /**
     * Returns a count of user health infrastructure
     *
     * @param userId A user id
     * @return A count of user health infrastructure
     */
    int retrieveCountByUserId(Integer userId);

    /**
     * Returns a list of health infrastructure details
     *
     * @param toBeRemoved    A health infrastructure id
     * @param healthInfraIds A list of health infrastructure id
     * @return A list of HealthInfrastructureDetails
     */
    List<HealthInfrastructureDetails> healthInfraExistsUnderLocation(Integer toBeRemoved, List<Integer> healthInfraIds);

    /**
     * Returns a list of user health infra structure based on given user id
     *
     * @param userId     A user id
     * @param modifiedOn last modified date
     * @return A list of UserHealthInfrastructure
     */
    List<UserHealthInfrastructure> retrieveByUserId(Integer userId, Date modifiedOn);
}
