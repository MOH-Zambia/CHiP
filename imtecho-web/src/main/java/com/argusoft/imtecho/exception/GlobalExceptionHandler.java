package com.argusoft.imtecho.exception;

import com.argusoft.imtecho.caughtexception.model.CaughtExceptionEntity;
import com.argusoft.imtecho.caughtexception.service.CaughtExceptionService;
import com.argusoft.imtecho.common.util.EmailUtil;
import com.argusoft.imtecho.config.security.ImtechoSecurityUser;
import org.apache.catalina.connector.ClientAbortException;
import org.apache.commons.lang.exception.ExceptionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * <p>
 * Define methods for global exception.
 * </p>
 *
 * @author charmi
 * @since 26/08/20 10:19 AM
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    @Autowired
    private EmailUtil emailUtil;

    @Autowired
    private ImtechoSecurityUser securityUser;

    @Autowired
    private CaughtExceptionService caughtExceptionService;

    /**
     * Method of Java's throwable class which prints the throwable along with other details
     * like the line number and class name where the exception occurred.
     *
     * @param e Instance of HttpMessageNotReadableException.
     */
    @ExceptionHandler
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public void handle(HttpMessageNotReadableException e) {
        Logger.getLogger(GlobalExceptionHandler.class.getName()).log(Level.INFO, e.getMessage(), e);
    }

    /**
     * Handle exception.
     *
     * @param e Instance of ImtechoUserException.
     * @return Returns entity of imptecho response.
     */
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler
    public ResponseEntity<ImtechoResponseEntity> handleException(ImtechoUserException e) {
        if (e != null) {
            ImtechoResponseEntity rE = (e).getResponse();
            return new ResponseEntity<>(rE, HttpStatus.BAD_REQUEST);
        }
        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    @ResponseStatus(HttpStatus.FORBIDDEN)
    @ExceptionHandler
    public ResponseEntity<Map<String, String>> handleException(ImtechoForbiddenException e) {
        if (e != null) {
            Map<String, String> resp = new HashMap<>();
            resp.put("reason",e.getMessage());
            return new ResponseEntity<>(resp, HttpStatus.FORBIDDEN);
        }
        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }

    /**
     * Handle internal server error.
     *
     * @param request Instance of HttpServletRequest.
     * @param e       Instance of Exception.
     * @return Returns entity of imptecho response.
     */
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    @ExceptionHandler
    public ResponseEntity<ImtechoResponseEntity> handleException(HttpServletRequest request, Exception e) {
        if (e instanceof ImtechoSystemException) {
            ImtechoResponseEntity imtechoResponseEntity = ((ImtechoSystemException) e).getResponse();
            String message = ((ImtechoSystemException) e).getResponse().message;
            saveException(request, e, message);
//            emailUtil.sendExceptionEmail(e, null, request, message);
            return new ResponseEntity<>(imtechoResponseEntity, HttpStatus.BAD_REQUEST);
        } else if (!(e instanceof ImtechoUserException) && !(e instanceof ClientAbortException)) {
            saveException(request, e, null);
//            emailUtil.sendExceptionEmail(e, null, request, "");
            Logger.getLogger(GlobalExceptionHandler.class.getName()).log(Level.INFO, e.getMessage(), e);
        }
        return new ResponseEntity<>(new ImtechoResponseEntity(e.getMessage()), HttpStatus.INTERNAL_SERVER_ERROR);
    }

    private void saveException(HttpServletRequest request, Exception e, String message) {
        CaughtExceptionEntity exception = new CaughtExceptionEntity();
        if (request.getRequestURL() != null) {
            exception.setRequestUrl(request.getRequestURL().toString());
        }

        try {
            if (securityUser != null && securityUser.getUserName() != null) {
                exception.setUsername(securityUser.getUserName());
            }
        } catch (Exception ex) {
            Logger.getLogger(getClass().getSimpleName()).log(Level.SEVERE, ">>>>>>>>>>>>>" + ex.getMessage());
        }

        if (message != null) {
            exception.setExceptionMsg(((ImtechoSystemException) e).getResponse().message);
        } else {
            exception.setExceptionMsg(e.getMessage());
        }
        exception.setExceptionStackTrace(ExceptionUtils.getStackTrace(e));
        exception.setExceptionType("Web");
        caughtExceptionService.saveCaughtException(exception);
    }

}
