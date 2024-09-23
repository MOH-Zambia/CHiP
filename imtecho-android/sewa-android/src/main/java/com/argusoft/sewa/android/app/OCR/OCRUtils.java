package com.argusoft.sewa.android.app.OCR;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
import static android.widget.LinearLayout.VERTICAL;
import static com.argusoft.sewa.android.app.component.MyStaticComponents.getLinearLayout;
import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.context;

import android.widget.LinearLayout;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Locale;
import java.util.Map;

public class OCRUtils {

    public static Date convertStringToDate(String dateString) throws ParseException {
        // Remove spaces from the input string
        dateString = dateString.replaceAll("\\s", "");
        dateString = dateString.replaceAll("O", "0");
        dateString = dateString.replaceAll("o", "0");
        dateString = dateString.replaceAll("i", "1");
        dateString = dateString.replaceAll("I", "1");
        dateString = dateString.replaceAll("l", "1");

        // Define date formats for parsing
        SimpleDateFormat[] dateFormats = {
                new SimpleDateFormat("dd-MM-yyyy", Locale.getDefault()),
                new SimpleDateFormat("dd/MM/yyyy", Locale.getDefault())
        };

        for (SimpleDateFormat format : dateFormats) {
            try {
                // Parse the date using the current format
                return format.parse(dateString);
            } catch (ParseException e) {
                // Ignore parsing errors and try the next format
            }
        }

        // If none of the formats match, return null;
        return null;
    }

    public static double calculateSimilarity(String s1, String s2) {
        // Convert strings to lowercase for case-insensitive comparison
        s1 = s1.toLowerCase();
        s2 = s2.toLowerCase();

        // Compute Levenshtein distance
        int[][] dp = new int[s1.length() + 1][s2.length() + 1];
        for (int i = 0; i <= s1.length(); i++) {
            for (int j = 0; j <= s2.length(); j++) {
                if (i == 0) {
                    dp[i][j] = j;
                } else if (j == 0) {
                    dp[i][j] = i;
                } else {
                    dp[i][j] = min(
                            dp[i - 1][j - 1] + (s1.charAt(i - 1) == s2.charAt(j - 1) ? 0 : 1),
                            dp[i - 1][j] + 1,
                            dp[i][j - 1] + 1
                    );
                }
            }
        }

        // Compute similarity score (normalized Levenshtein distance)
        int maxLen = Math.max(s1.length(), s2.length());
        return 1.0 - (double) dp[s1.length()][s2.length()] / maxLen;
    }


    public static Map<String, String> convertStringToMap(String input) {
        Map<String, String> map = new LinkedHashMap<>();

        // Split the input string by lines
        String[] lines = input.split("\n");

        // Iterate through each line
        for (String line : lines) {
            // Split each line by '='
            String[] parts = line.split("=");
            if (parts.length == 2) {
                // Trim any leading/trailing whitespace from the key and value
                String key = parts[0].trim();
                String value = parts[1].trim();
                // Put the key-value pair into the map
                map.put(key, value);
            }
        }

        return map;
    }

    public static String[] getTextArrayFromInput(String input) {
        return input.split("\n");
    }

    private static int min(int a, int b, int c) {
        return Math.min(Math.min(a, b), c);
    }


    /*public static String[] getActiveMalariaFormConfiguration() {
        return new String[]{
                //question~fieldName~fieldType~lineNumber~splitByForExtractingAnswer
                "Service date~serviceDate~DB~1~=",
                "Member status~memberStatus~TB~2~=",
                "Symptoms~otherMalariaSymtoms~TB~3~=",
                "RDT status~rdtTestStatus~TB~4~=",
                "Index case~isIndexCase~RB~5~=",
                "Having travel history~havingTravelHistory~RB~6~=",
                "Malaria treatment history~malariaTreatmentHistory~RB~7~=",
                "Treatment given~isTreatmentBeingGiven~RB~8~=",
                "LMP date~lmpDate~DB~9~=",
                "Referral required~referralDone~RB~10~=",
                "Referral reason~referralReason~TB~11~=",
                "IEC given~isIecGiven~RB~12~="
        };
    }*/

    public static LinearLayout getButtonAndOcrFormDataLayout() {
        LinearLayout mainLayout = getLinearLayout(context, -1, VERTICAL,
                new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT));


        return mainLayout;
    }
}
