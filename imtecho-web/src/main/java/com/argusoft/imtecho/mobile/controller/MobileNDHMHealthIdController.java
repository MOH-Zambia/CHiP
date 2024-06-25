package com.argusoft.imtecho.mobile.controller;

import com.argusoft.imtecho.common.model.UserMaster;
import com.argusoft.imtecho.exception.ImtechoMobileException;
import com.argusoft.imtecho.mobile.service.GenericSessionUtilService;
import com.argusoft.imtecho.mobile.service.MobileFhsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashSet;
import java.util.List;

/**
 * <p>
 * Add an understandable class description here
 * </p>
 *
 * @author rahul
 * @since 06/10/21 12:10 PM
 */
@RestController
@RequestMapping("/api/mobile/ndhm/healthid/")
public class MobileNDHMHealthIdController extends GenericSessionUtilService {

    private static final String SESSION_EXPIRED_MSG = "Your session is expired, Please login again";

    @Autowired
    @Lazy
    private MobileFhsService mobileFhsService;

    private void verifyUserToken(String userMobileToken) {
        if (userMobileToken != null) {
            UserMaster userMaster = mobileFhsService.isUserTokenValid(userMobileToken);
            if (userMaster == null) {
                throw new ImtechoMobileException(SESSION_EXPIRED_MSG, 1);
            }
        } else {
            throw new ImtechoMobileException(SESSION_EXPIRED_MSG, 1);
        }
    }


}