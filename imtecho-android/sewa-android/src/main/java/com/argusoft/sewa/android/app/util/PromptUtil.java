package com.argusoft.sewa.android.app.util;

public class PromptUtil {

    public static String getPrompt(String form, String answerString){
        switch (form) {
            case "ACTIVE_MALARIA":
                return getPromptForActiveMalaria(answerString);
            default:
                return "";
        }
    }

    private static String getPromptForActiveMalaria(String answerString) {
        StringBuilder sb = new StringBuilder();
        sb.append("Based on the following patient data, provide clinical decision support. \n");
        return "";
    }

}
