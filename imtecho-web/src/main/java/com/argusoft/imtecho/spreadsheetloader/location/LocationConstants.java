package com.argusoft.imtecho.spreadsheetloader.location;

/**
 *
 * <p>
 * Define constants for locations.
 * </p>
 *
 * @author avani
 * @since 26/08/20 10:19 AM
 */
public class LocationConstants {

    public static final String LEVEL_PROPERTY = "level";
    public static final String SETTER_METHOD_PREFIX = "set";

    //Use to identify hierarchy
    public static final String RURAL_HIERARCHY = "H1";
    public static final String URBAN_HIERARCHY = "H3";
    public static final String NAGARPALIKA_HIERARCHY = "H2";

    //Use in created by
    public static final String ADMIN = "ADMIN";

    //Timestamp append after processed and error file name
    public static final String DEFAULT_TIMESTAMP = "ddMMyyyy_hhmmss";

    public static final String ERROR = "error";

    //Regex
    public static final String TIMESTAMP_REGEX = "_\\d{8}_\\d{6}";
    public static final String DIGIT_REGEX = "\\d+";

    //Result map key prefix
    public static final String RESULT = "result";
    public static final String ERROR_FILE_NAME = "error_file_name";

    //identify worksheet name 
    public static final String RURAL = "rural";
    public static final String URBAN = "urban";
    public static final String NAGARPALIKA = "nagarpalika";

    //Reference row column name for error spread sheet
    public static final String REFERENCE_ROW_ID = "Refrencence Row Number";
    public static final String ERROR_MESSAGE = "Error Message";
    public static final int ERROR_MESSAGE_INT = -1;

    //Ignore TRASH row
    public static final String TRASH = "TRASH";

    //Exception message length key 
    public static final String ALLOWED_CHARACTERS_IN_ERROR_LOG = "ALLOWED_CHARACTERS_IN_ERROR_LOG";
    public static final String EXCEPTION_MESSAGE_LENGTH = "150";
    
    //Identify state
    public static final String GUJARAT_STATE_ENGLISH= "Gujarat";
    public static final String GUJARAT_STATE_GUJARATI = "ગુજરાત";
    

    //Success messages 
    public static final String LOADING_SUCCESS_SPREADSHEET = "Spreadsheet loaded successfully";

    //Error messages
    public static final String LOCATION_ADD_ERROR = "Error while adding location data ";
    public static final String LOCATION_PARSE_ERROR = "Error while parse location data ";
    public static final String FAIL_LOAD_WORKSHEET = "Failed to load worksheet ";
    public static final String FAIL_LOAD_SPREADSHEET = "Failed to load spreadsheet ";
    public static final String FAIL_GENERATE_ERROR_SHEET = "Error while generate error spread sheet ";
    public static final String PROBLEM_WHILE_LOAD_SPREADSHEET = "Some problem occured while process file";
    public static final String PARENT_NOT_FOUND_FOR_LOCATION = "Parent not found for this location";
    public static final String DUPLICATE_LOCATION_FOUND = "Duplicate locations found while process file";

    //Folder name for read and write spread sheets
    public static final String SPREAD_SHEET = "SpreadSheet";
    public static final String NEW_FILE = "Newfile";
    public static final String PROCESSED_FILE = "Processed";
    public static final String ERROR_FILE = "Error";

    public static final String EMAMTA_CODE_ERROR_RURAL = "Village does not exists for this emamta code";
    public static final String EMAMTA_CODE_ERROR_URBAN = "Anganwadi Area / Society Area does not exists for this emamta code";
public static final String EMAMTA_CODE_NOT_EXIST_ERROR_RURAL = "Emamta code not exists for this village";
    public static final String EMAMTA_CODE_NOT_EXIST_ERROR_URBAN = "Emamta code not exists for this anganwadi Area / Society Area";
    
    public static final String INVALID_DATA_FOUND_PARENTHESIS_INCORRECT = "Invalid data found , check parenthesis";
    public static final String INVALID_DATA_FOUND = "Invalid data found";

    //Location type constant for store in DB
    public enum LocationType {

        STATE("S"),
        DISTRICT("D"),
        BLOCK("B"),
        TALUKA("B"),
        PHC("P"),
        SUB_CENTER("SC"),
        VILLAGE("V"),
        AREA("A"),
        EMAMTA_CODE("E"),
        UPHC("U"),
        ANM_AREA("ANM"),
        ANGANWADI_AREA_SOCIETY_AREA("ANG"),
        ASHA_AREA("AA"),
        CORPORATION("C"),
        ZONE("Z"),;

        private String type;

        LocationType(String type) {
            this.type = type;
        }

        public String getType() {
            return this.type;
        }

    }

    public enum RuralHeader {

        DISTRICT,
        BLOCK,
        PHC,
        SUB_CENTER,
        VILLAGE,
        AREA,
        EMAMTA_CODE
    }

    public enum UrbanHeader {

        DISTRICT,
        BLOCK,
        UPHC,
        ANM_AREA,
        ANGANWADI_AREA_SOCIETY_AREA,
        ASHA_AREA,
        EMAMTA_CODE
    }

    public enum NagarpalikaHeader {

        CORPORATION,
        ZONE,
        UPHC,
        ANM_AREA,
        ANGANWADI_AREA_SOCIETY_AREA,
        ASHA_AREA,
        EMAMTA_CODE
    }

}
