package com.argusoft.imtecho.mobile.service.impl;

import com.argusoft.imtecho.chip.dao.ChipMalariaDao;
import com.argusoft.imtecho.chip.model.ChipMalariaEntity;
import com.argusoft.imtecho.mobile.dto.InsightDto;
import com.argusoft.imtecho.mobile.service.GeminiApiService;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.hibernate.criterion.Restrictions;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;

import org.springframework.web.multipart.MultipartFile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Transactional
@Service
public class GeminiApiServiceImpl implements GeminiApiService {

    private static final Logger LOGGER = LoggerFactory.getLogger(GeminiApiServiceImpl.class);

    private static final String GEMINI_API_KEY = "AIzaSyB4NYcBiUbeNUFrYJJJon_b-ZCLd3UOfrU";
    private static final String GEMINI_API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + GEMINI_API_KEY;

    @Autowired
    private ChipMalariaDao chipMalariaDao;

    @Override
    public List<InsightDto> generatePatientInsights(Long memberActualId, String formType) {
        List<InsightDto> insights = new ArrayList<>();

        if (memberActualId == null) {
            return insights;
        }

        try {
            List<ChipMalariaEntity> malariaRecords = chipMalariaDao.findByCriteria(Restrictions.eq("memberId", memberActualId.intValue()));

            StringBuilder promptBuilder = new StringBuilder();
            promptBuilder.append("You are an AI clinical assistant for a community health worker processing a member's data. ");
            promptBuilder.append("Based on the following historical malaria records for this patient, generate up to 3 brief clinical insights. ");
            promptBuilder.append("Return ONLY a valid JSON array of objects. Each object must have the following string fields: 'title', 'description', 'severity' (must be 'high', 'medium', or 'low'), 'healthProgram' (e.g. 'Malaria', 'RCH', 'TB', 'HIV'). ");
            promptBuilder.append("Do not include markdown or backticks in your response. Just the JSON array.\n\n");
            
            if (malariaRecords == null || malariaRecords.isEmpty()) {
                promptBuilder.append("No previous malaria records found for this patient.");
            } else {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                for (ChipMalariaEntity record : malariaRecords) {
                    promptBuilder.append("Record Date: ").append(record.getServiceDate() != null ? sdf.format(record.getServiceDate()) : "Unknown").append(", ");
                    promptBuilder.append("RDT Test Status: ").append(record.getRdtTestStatus()).append(", ");
                    promptBuilder.append("Treatment History: ").append(record.getMalariaTreatmentHistory() != null ? record.getMalariaTreatmentHistory() : "Unknown").append(", ");
                    promptBuilder.append("Index Case: ").append(record.getIsIndexCase() != null ? record.getIsIndexCase() : "Unknown").append(".\n");
                }
            }

            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject contentObj = new JsonObject();
            JsonArray parts = new JsonArray();
            JsonObject partObj = new JsonObject();
            partObj.addProperty("text", promptBuilder.toString());
            parts.add(partObj);
            contentObj.add("parts", parts);
            contents.add(contentObj);
            requestBody.add("contents", contents);

            HttpEntity<String> request = new HttpEntity<>(requestBody.toString(), headers);

            if (!"GEMINI_API_KEY".equals(GEMINI_API_KEY)) {
                String responseBody = restTemplate.postForObject(GEMINI_API_URL, request, String.class);
                
                Gson gson = new Gson();
                JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);
                
                if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                    JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                    if (candidate.has("content")) {
                        JsonObject content = candidate.getAsJsonObject("content");
                        if (content.has("parts") && content.getAsJsonArray("parts").size() > 0) {
                            String aiText = content.getAsJsonArray("parts").get(0).getAsJsonObject().get("text").getAsString();
                            
                            aiText = aiText.replace("```json", "").replace("```", "").trim();
                            
                            JsonArray insightsArray = gson.fromJson(aiText, JsonArray.class);
                            for (JsonElement element : insightsArray) {
                                JsonObject obj = element.getAsJsonObject();
                                InsightDto dto = new InsightDto();
                                dto.setTitle(obj.has("title") ? obj.get("title").getAsString() : "Insight");
                                dto.setDescription(obj.has("description") ? obj.get("description").getAsString() : "No description");
                                dto.setSeverity(obj.has("severity") ? obj.get("severity").getAsString() : "low");
                                dto.setHealthProgram(obj.has("healthProgram") ? obj.get("healthProgram").getAsString() : "Malaria");
                                insights.add(dto);
                            }
                        }
                    }
                }
            } else {
                insights.add(new InsightDto("API Key Missing", "Please configure the Gemini API key in the backend.", "high", "System"));
                if (malariaRecords != null && !malariaRecords.isEmpty()) {
                     insights.add(new InsightDto("Historical Data Present", "Found " + malariaRecords.size() + " malaria record(s) for this patient.", "low", "Malaria"));
                }
            }
            
        } catch (Exception e) {
            LOGGER.error("Failed to fetch insights from Gemini", e);
            insights.add(new InsightDto("Error Generating Insights", "An error occurred while calling the AI service.", "medium", "System"));
        }

        return insights;
    }

    @Override
    public List<InsightDto> aiMedicalInsights(Long memberActualId, String answerString) {

        List<InsightDto> insights = new ArrayList<>();

        if (memberActualId == null) {
            return insights;
        }
        try {
            List<ChipMalariaEntity> malariaRecords = chipMalariaDao.findByCriteria(Restrictions.eq("memberId", memberActualId.intValue()));

            String prompt = buildMedicalPrompt(malariaRecords, answerString);
            String aiResponse = callGemini(prompt);
            insights = parseInsights(aiResponse);

        } catch (Exception e) {
            LOGGER.error("Error generating AI medical insights", e);
            insights.add(new InsightDto(
                    "Error Generating Insights",
                    "Unable to process AI insights at this time.",
                    "medium",
                    "System"
            ));
        }

        return insights;
    }

    @Override
    public String generateContent(String prompt) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject contentObj = new JsonObject();
            JsonArray parts = new JsonArray();
            JsonObject partObj = new JsonObject();
            partObj.addProperty("text", prompt);
            parts.add(partObj);
            contentObj.add("parts", parts);
            contents.add(contentObj);
            requestBody.add("contents", contents);

            HttpEntity<String> request = new HttpEntity<>(requestBody.toString(), headers);
            String responseBody = restTemplate.postForObject(GEMINI_API_URL, request, String.class);
            
            Gson gson = new Gson();
            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);
            
            if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                if (candidate.has("content")) {
                    JsonObject content = candidate.getAsJsonObject("content");
                    if (content.has("parts") && content.getAsJsonArray("parts").size() > 0) {
                        return content.getAsJsonArray("parts").get(0).getAsJsonObject().get("text").getAsString();
                    }
                }
            }
        } catch (Exception e) {
            LOGGER.error("Failed to fetch insights from Gemini", e);
        }
        return "Not available at the moment.";
    }

    private String buildMedicalPrompt(List<ChipMalariaEntity> malariaRecords, String answerString) {

        StringBuilder sb = new StringBuilder();

        sb.append("You are a clinical decision support tool helping a frontline community health worker in the field.\n");
        sb.append("The health worker has basic medical training but is not a doctor.\n\n");
        sb.append("Avoid medical jargon. Write like you are giving quick instructions to a community health worker.\n\n");

        sb.append("TASK:\n");
        sb.append("Based on the malaria screening form and patient history below, generate UP TO 3 insights.\n");
        sb.append("Each insight must be:\n");
        sb.append("- Simple enough for a non-doctor to understand\n");
        sb.append("- Actionable — tell the worker exactly what to do next\n");
        sb.append("- Specific to this patient's data, not generic advice\n\n");

        sb.append("OUTPUT FORMAT:\n");
        sb.append("Return ONLY a valid JSON array. No markdown, no explanation, no extra text.\n");
        sb.append("Each item must have exactly these fields:\n");
        sb.append("  \"title\": short heading (max 6 words)\n");
        sb.append("  \"description\": plain-language explanation and what to do (2-3 sentences max)\n");
        sb.append("  \"severity\": one of: \"high\" | \"medium\" | \"low\"\n");
        sb.append("    - high = refer to clinic/hospital now, possible danger\n");
        sb.append("    - medium = monitor closely, follow up needed\n");
        sb.append("    - low = routine care, no immediate action\n");
        sb.append("  \"healthProgram\": one of: \"Malaria\" | \"Nutrition\" | \"Maternal Health\" | \"General\"\n");
        sb.append("  \"actionLabel\": a 2-4 word action phrase like \"Refer Immediately\", \"Schedule Follow-Up\", \"Give ACT Treatment\", \"Record and Monitor\"\n\n");

        sb.append("MALARIA CONTEXT (use these rules when relevant):\n");
        sb.append("- If RDT is Positive: patient has malaria. Check if ACT treatment was given.\n");
        sb.append("- If RDT is Negative but symptoms persist: consider re-testing or referral.\n");
        sb.append("- Danger signs requiring IMMEDIATE referral: convulsions, unconsciousness, severe vomiting, unable to drink.\n");
        sb.append("- Index Case: if marked yes, household members may also be at risk.\n");
        sb.append("- Repeat malaria within 28 days may indicate treatment failure.\n\n");

        sb.append("TODAY'S FORM DATA (patient's current visit answers):\n");
        if (answerString != null && !answerString.trim().isEmpty()) {
            sb.append(formatAnswerString(answerString)).append("\n\n"); // <-- use formatter
        } else {
            sb.append("No form data provided for this visit.\n\n");
        }

        sb.append("PATIENT PAST MALARIA HISTORY:\n");
        if (malariaRecords == null || malariaRecords.isEmpty()) {
            sb.append("No previous malaria records found for this patient.\n\n");
        } else {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            for (ChipMalariaEntity record : malariaRecords) {
                sb.append("- Visit Date: ")
                        .append(record.getServiceDate() != null ? sdf.format(record.getServiceDate()) : "Unknown")
                        .append(" | RDT Result: ").append(nullSafe(record.getRdtTestStatus()))
                        .append(" | Treatment Given: ").append(nullSafe(record.getMalariaTreatmentHistory()))
                        .append(" | Was Index Case: ").append(nullSafe(record.getIsIndexCase()))
                        .append("\n");
            }
            sb.append("\n");
        }

        sb.append("IMPORTANT REMINDERS:\n");
        sb.append("- Do NOT repeat generic malaria advice (e.g. 'sleep under a net') unless directly relevant.\n");
        sb.append("- Focus on what THIS patient needs TODAY based on their specific data.\n");
        sb.append("- If data is missing or unclear, say so briefly and suggest what to check.\n");

        return sb.toString();
    }

    private String callGemini(String prompt) {

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        JsonObject requestBody = new JsonObject();
        JsonArray contents = new JsonArray();
        JsonObject contentObj = new JsonObject();
        JsonArray parts = new JsonArray();
        JsonObject partObj = new JsonObject();

        partObj.addProperty("text", prompt);
        parts.add(partObj);
        contentObj.add("parts", parts);
        contents.add(contentObj);
        requestBody.add("contents", contents);

        HttpEntity<String> request = new HttpEntity<>(requestBody.toString(), headers);

        String responseBody = restTemplate.postForObject(GEMINI_API_URL, request, String.class);

        Gson gson = new Gson();
        JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);

        if (jsonResponse.has("candidates")) {
            JsonObject candidate = jsonResponse.getAsJsonArray("candidates")
                    .get(0).getAsJsonObject();

            JsonObject content = candidate.getAsJsonObject("content");

            return content.getAsJsonArray("parts")
                    .get(0).getAsJsonObject()
                    .get("text").getAsString();
        }

        return "[]";
    }
    private List<InsightDto> parseInsights(String aiText) {
        List<InsightDto> insights = new ArrayList<>();
        try {
            Gson gson = new Gson();
            aiText = aiText.replace("```json", "")
                    .replace("```", "")
                    .trim();

            JsonArray array = gson.fromJson(aiText, JsonArray.class);

            for (JsonElement element : array) {
                JsonObject obj = element.getAsJsonObject();

                InsightDto dto = new InsightDto();
                dto.setTitle(getOrDefault(obj, "title", "Check Needed"));
                dto.setDescription(getOrDefault(obj, "description", "Please review this patient."));
                dto.setSeverity(getOrDefault(obj, "severity", "low"));
                dto.setHealthProgram(getOrDefault(obj, "healthProgram", "Malaria"));
                dto.setActionLabel(getOrDefault(obj, "actionLabel", "Review Patient")); // NEW

                insights.add(dto);
            }

        } catch (Exception e) {
            LOGGER.error("Failed to parse AI response: {}", aiText, e);
            InsightDto error = new InsightDto(
                    "Could Not Load Insights",
                    "There was a problem reading the AI response. Please try again.",
                    "medium",
                    "System"
            );
            error.setActionLabel("Retry");
            insights.add(error);
        }

        return insights;
    }
    private String nullSafe(Object value) {
        return value == null ? "Unknown" : value.toString();
    }

    private String getOrDefault(JsonObject obj, String key, String defaultVal) {
        return obj.has(key) && !obj.get(key).isJsonNull()
                ? obj.get(key).getAsString()
                : defaultVal;
    }

    // Add this map as a class-level constant
    private static final Map<String, String> SYMPTOM_CODE_MAP = new HashMap<String, String>() {{
        put("2700", "Fever");
        put("2701", "Chills and rigors (shaking/shivering)");
        put("2702", "Headache");
        put("2703", "Nausea or vomiting");
        put("2704", "Muscle pain (myalgia)");
        put("2705", "Fatigue and weakness");
        put("2706", "Sweating");
        put("2707", "Loss of appetite (anorexia)");
        put("2708", "Abdominal pain");
        put("2709", "Convulsions (seizures)");
        put("2710", "Jaundice (yellowing of skin/eyes)");
        put("2711", "Dark urine");
        // Add more codes as per your system
    }};

    private String formatAnswerString(String rawAnswer) {
        if (rawAnswer == null || rawAnswer.trim().isEmpty()) return "No form data available.";

        StringBuilder formatted = new StringBuilder();
        String[] lines = rawAnswer.split("\n");

        for (String line : lines) {
            line = line.trim();
            if (line.isEmpty()) continue;

            // Skip noisy or irrelevant fields
            if (line.startsWith("Member id:") ||
                    line.startsWith("Date of birth:") ||
                    line.startsWith("HIV status:") ||
                    line.startsWith("Immunization details:") ||
                    line.contains("N/A")) {
                // Only include if it has real data
                if (!line.contains("N/A")) {
                    formatted.append(line).append("\n");
                }
                continue;
            }

            // Decode symptom codes
            if (line.startsWith("Symptoms:")) {
                String[] parts = line.split(":", 2);
                if (parts.length > 1) {
                    String[] codes = parts[1].trim().split(",");
                    List<String> symptomNames = new ArrayList<>();
                    for (String code : codes) {
                        String name = SYMPTOM_CODE_MAP.getOrDefault(code.trim(), "Unknown symptom (code: " + code.trim() + ")");
                        symptomNames.add(name);
                    }
                    formatted.append("Symptoms present: ").append(String.join(", ", symptomNames)).append("\n");
                }
                continue;
            }

            // Decode T/F fields
            if (line.startsWith("Is treatment being given ?:")) {
                boolean treated = line.contains(": T");
                formatted.append("Is treatment currently being given: ").append(treated ? "Yes" : "No").append("\n");
                continue;
            }

            if (line.startsWith("Malaria treatment history ?:")) {
                boolean hasTreatmentHistory = line.contains(": T");
                formatted.append("Patient has prior malaria treatment history: ").append(hasTreatmentHistory ? "Yes" : "No").append("\n");
                continue;
            }

            // RDT — make it very explicit
            if (line.startsWith("RDT (Rapid Diagnostic Test) status:")) {
                String status = line.contains("POSITIVE") ? "POSITIVE (malaria parasites detected)" : "NEGATIVE (no malaria parasites detected)";
                formatted.append("RDT Result: ").append(status).append("\n");
                continue;
            }

            // Chronic diseases
            if (line.startsWith("Chronic diseases:")) {
                if (!line.contains("None")) {
                    formatted.append(line).append("\n");
                }
                continue;
            }

            // Keep remaining meaningful lines as-is
            formatted.append(line).append("\n");
        }

        return formatted.toString().trim();
    }

    @Override
    public String aiAudioTranscription(Long memberActualId, MultipartFile audioFile) {
        try {
            // Encode audio as Base64 for Gemini inline_data
            byte[] audioBytes = audioFile.getBytes();
            String base64Audio = Base64.getEncoder().encodeToString(audioBytes);
            String mimeType = audioFile.getContentType() != null ? audioFile.getContentType() : "audio/3gpp";

            // Fetch past malaria history for clinical context
            String clinicalContext = "";
            if (memberActualId != null) {
                try {
                    List<ChipMalariaEntity> records = chipMalariaDao.findByCriteria(
                            Restrictions.eq("memberId", memberActualId.intValue()));
                    if (records != null && !records.isEmpty()) {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        StringBuilder ctx = new StringBuilder("Patient's past malaria history:\n");
                        for (ChipMalariaEntity r : records) {
                            ctx.append("- Date: ").append(r.getServiceDate() != null ? sdf.format(r.getServiceDate()) : "Unknown")
                               .append(", RDT: ").append(nullSafe(r.getRdtTestStatus()))
                               .append(", Treatment: ").append(nullSafe(r.getMalariaTreatmentHistory()))
                               .append("\n");
                        }
                        clinicalContext = ctx.toString();
                    }
                } catch (Exception e) {
                    LOGGER.warn("Could not fetch patient history for audio transcription", e);
                }
            }

            // Build the prompt
            String textPrompt = "You are an AI assistant for a community health volunteer (CHV) working in a remote rural village.\n" +
                "The CHV has basic health training but is NOT a doctor. They speak in the local language during patient visits.\n\n" +
                "Your job is to:\n" +
                "1. TRANSCRIBE the audio recording of the patient conversation (translate to English if needed). Label it as TRANSCRIPT.\n" +
                "2. Provide simple, actionable CLINICAL DECISION SUPPORT based on what was said. Label it as CLINICAL ADVICE.\n\n" +
                "CLINICAL ADVICE must:\n" +
                "- Use plain, jargon-free language the CHV can act on immediately\n" +
                "- Flag any danger signs (e.g. convulsions, high fever, unconsciousness) that need immediate referral\n" +
                "- Mention relevant follow-up steps (give treatment, refer, monitor)\n" +
                "- Be specific to the patient's situation mentioned in the audio\n\n" +
                (clinicalContext.isEmpty() ? "" : clinicalContext + "\n") +
                "Format your response as:\n" +
                "TRANSCRIPT:\n[Full transcription here]\n\n" +
                "CLINICAL ADVICE:\n[Bullet-point advice here]\n";

            // Build Gemini multimodal request
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            JsonObject requestBody = new JsonObject();
            JsonArray contents = new JsonArray();
            JsonObject contentObj = new JsonObject();
            JsonArray parts = new JsonArray();

            // Audio part
            JsonObject audioPart = new JsonObject();
            JsonObject inlineData = new JsonObject();
            inlineData.addProperty("mime_type", mimeType);
            inlineData.addProperty("data", base64Audio);
            audioPart.add("inline_data", inlineData);
            parts.add(audioPart);

            // Text prompt part
            JsonObject textPart = new JsonObject();
            textPart.addProperty("text", textPrompt);
            parts.add(textPart);

            contentObj.add("parts", parts);
            contents.add(contentObj);
            requestBody.add("contents", contents);

            HttpEntity<String> request = new HttpEntity<>(requestBody.toString(), headers);

            // Use gemini-2.0-flash which supports inline audio
            String audioApiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + GEMINI_API_KEY;
            String responseBody = restTemplate.postForObject(audioApiUrl, request, String.class);

            Gson gson = new Gson();
            JsonObject jsonResponse = gson.fromJson(responseBody, JsonObject.class);

            if (jsonResponse.has("candidates") && jsonResponse.getAsJsonArray("candidates").size() > 0) {
                JsonObject candidate = jsonResponse.getAsJsonArray("candidates").get(0).getAsJsonObject();
                if (candidate.has("content")) {
                    JsonObject content = candidate.getAsJsonObject("content");
                    if (content.has("parts") && content.getAsJsonArray("parts").size() > 0) {
                        return content.getAsJsonArray("parts").get(0).getAsJsonObject().get("text").getAsString();
                    }
                }
            }

        } catch (Exception e) {
            LOGGER.error("Failed to process audio transcription via Gemini", e);
        }

        return "TRANSCRIPT:\nUnable to transcribe audio.\n\nCLINICAL ADVICE:\nAudio could not be processed. Please repeat the recording.";
    }
}
