package com.argusoft.imtecho.spreadsheetloader.user;

/**
 * <p>
 * Define constants for upload users.
 * </p>
 *
 * @author nihar
 * @since 10/07/21 10:19 AM
 */
public class UserConstants {

    //Success messages
    public static final String USER_CREATE_SUCCESS = "User created successfully";

    //Error messages
    public static final String PROBLEM_WHILE_LOAD_SPREADSHEET = "Some problem occured while process file";
    public static final String FIRST_NAME_NOT_FOUND = "First name is required";
    public static final String LAST_NAME_NOT_FOUND = "Last name is required";
    public static final String GENDER_NOT_FOUND = "Gender is required";
    public static final String MOBILE_NUMBER_NOT_FOUND = "Mobile No is required";
    public static final String MOBILE_NUMBER_NOT_VALID = "Phone Number should be of 10 digits.";
    public static final String EMAIL_NOT_FOUND = "Email is required";
    public static final String EMAIL_NOT_VALID = "Email is not valid.";
    public static final String SHEET_NAME_NOT_VALID = "Sheet name is not valid please download new sample.";
    public static final String USER_ALREADY_EXIST = "User already exist with same mobile number.";
    public static final String USER_WITH_SAME_ROLE_EXIST = "User with same role exist.";
    public static final String ROLE_NOT_EXIST = "User role dose not exist.";
    public static final String SHEET_HEADER_COLUMN_ERROR = "Sheet header column not valid please download new sample";

    //Result info message
    public static final String NO_USER_FOUND = "No user Fond in any sheet.";


    //Result map key prefix
    public static final String RESULT = "result";
    public static final String DEFAULT_RESULT_FILE_NAME = "result.xlsx";
    public static final String RESULT_FILE = "result_File";

    //Regex
    public static final String EMAIL_REGEX = "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$";

    //Timestamp append after processed file name
    public static final String DEFAULT_TIMESTAMP = "ddMMyyyy_hhmmss";

    public enum Gender {
        MALE("M"),
        FEMALE("F");

        private String gender;

        Gender(String gender) {
            this.gender = gender;
        }

        public String getGender() {
            return this.gender;
        }
    }

    public enum UploadUserFields {
        FIRST_NAME,
        MIDDLE_NAME,
        LAST_NAME,
        GENDER,
        PHONE_NUMBER,
        EMAIL_ID
    }

    public enum ResultFields {
        USER_NAME,
        PASSWORD,
        RESULT_MESSAGE
    }
}
