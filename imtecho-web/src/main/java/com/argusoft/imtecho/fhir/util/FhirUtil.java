package com.argusoft.imtecho.fhir.util;

import ca.uhn.fhir.context.FhirContext;
import ca.uhn.fhir.parser.IParser;
import org.hl7.fhir.r4.model.Resource;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for common FHIR operations.
 */
public class FhirUtil {

    private FhirUtil() {
    }

    private static final ResourceBundle applicationPropertiesBundle = ResourceBundle.getBundle("application");

    /**
     * Converts a FHIR Resource object to its JSON string representation.
     *
     * @param resource The FHIR Resource to be converted
     * @return JSON string representation of the FHIR Resource, or null if the resource is null
     */
    public static String getJsonStringResponse(Resource resource) {
        if (resource == null) {
            return null;
        }
        FhirContext context = FhirContext.forR4();
        IParser parser = context.newJsonParser();
        return parser.encodeResourceToString(resource);
    }

    /**
     * Retrieves the URI of the local host, including protocol (HTTP/HTTPS) based on application properties.
     *
     * @return URI string of the local host
     */
    public static String getUri() {
        InetAddress localhost = null;
        String ip = "No IP";
        try {
            localhost = InetAddress.getLocalHost();
        } catch (UnknownHostException ex) {
            Logger.getLogger(FhirUtil.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (localhost != null && localhost.getHostAddress() != null) {
            ip = localhost.getHostAddress();
        }

        String prefix;
        if (Boolean.parseBoolean(applicationPropertiesBundle.getString("server-ssl-enabled"))){
            prefix = "https://";
        } else {
            prefix = "http://";
        }
        return prefix+ip;
    }

}
