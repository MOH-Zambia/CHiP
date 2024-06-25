
package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.mobile.dto.MobileRequestParamDto;

/**
 * <p>
 *     Define methods for user attendance
 * </p>
 * @author rahul
 * @since 27/08/2020 4:30
 */
public interface UserAttendanceMasterService {
     /**
      * Marks attendance of current day from given mobile request
      * @param mobileRequestParamDto An instance of MobileRequestParamDto
      * @return An id of created row
      */
     Integer markAttendanceForTheDay(MobileRequestParamDto mobileRequestParamDto);

     /**
      * Updates attendance of given mobile request
      * @param mobileRequestParamDto An instance of MobileRequestParamDto
      */
     void storeAttendanceForTheDay(MobileRequestParamDto mobileRequestParamDto);
}
