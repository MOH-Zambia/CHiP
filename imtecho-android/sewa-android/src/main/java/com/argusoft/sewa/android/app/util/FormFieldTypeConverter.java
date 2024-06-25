package com.argusoft.sewa.android.app.util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class FormFieldTypeConverter {

    public static final String FIELD_TYPE_LONG = "LONG";
    public static final String FIELD_TYPE_INTEGER = "INTEGER";
    public static final String FIELD_TYPE_FLOAT = "FLOAT";
    public static final String FIELD_TYPE_BOOLEAN = "BOOLEAN";
    public static final String FIELD_TYPE_ARRAY = "ARRAY";


    public static void putDataInAnswerObject(JSONObject answerObj, String fieldName, String ans, String fieldType) {
        try {
            if (fieldType.equalsIgnoreCase(FIELD_TYPE_ARRAY)) {
                answerObj.put(fieldName, FormFieldTypeConverter.convertStringToArray(ans));
            } else {
                answerObj.put(fieldName, FormFieldTypeConverter.convertStringToObject(ans, fieldType));
            }
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }

    public static JSONArray convertStringToArray(String ans) {
        String[] str = ans.split(",");
        JSONArray jsonArray = new JSONArray();
        for (String s : str) {
            jsonArray.put(s);
        }
        return jsonArray;

    }

    public static Object convertStringToObject(String answerStr, String fieldType) {
        switch (fieldType) {
            case FormFieldTypeConverter.FIELD_TYPE_INTEGER:
                return Integer.parseInt(answerStr);
            case FormFieldTypeConverter.FIELD_TYPE_LONG:
                return Long.parseLong(answerStr);
            case FormFieldTypeConverter.FIELD_TYPE_FLOAT:
                return Float.parseFloat(answerStr);
            case FormFieldTypeConverter.FIELD_TYPE_BOOLEAN:
                return CommonUtil.returnTrueFalseFromInitials(answerStr);
            default:
                return answerStr;
        }
    }
}

