
package com.argusoft.imtecho.common.dao.impl;

import com.argusoft.imtecho.common.model.UserAttendanceInfo;
import com.argusoft.imtecho.database.common.impl.GenericDaoImpl;
import org.springframework.stereotype.Repository;
import com.argusoft.imtecho.common.dao.UserAttendanceMasterDao;

/**
 * <p>
 *     Implements methods of UserAttendanceMasterDao
 * </p>
 *
 * @author rahul
 * @since 31/08/2020 4:30
 */
@Repository
public class UserAttendanceMasterDaoImpl extends GenericDaoImpl<UserAttendanceInfo, Integer> implements UserAttendanceMasterDao{
    
}
