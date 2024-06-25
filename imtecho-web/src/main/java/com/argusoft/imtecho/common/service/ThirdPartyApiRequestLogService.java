package com.argusoft.imtecho.common.service;

import com.argusoft.imtecho.common.dto.ThirdPartyApiRequestLogDto;

/**
 *
 * <p>
 * Defines service for ThirdPartyRequestLog
 * </p>
 *
 * @author ashish
 * @since 02/09/2020 04:40
 *
 */
public interface ThirdPartyApiRequestLogService {

    /**
     * Inserts DigiLocker (Third party) request logging for Pull Uri
     * @param dto An instance of ThirdPartyApiRequestLogDto
     * @return A Id of entered logging detail
     */
    Integer insertRequestLogForThirdPartyAPI(ThirdPartyApiRequestLogDto dto);

}
