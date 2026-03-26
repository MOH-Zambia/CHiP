package com.argusoft.imtecho.mobile.service;

import com.argusoft.imtecho.mobile.dto.InsightDto;
import org.springframework.web.multipart.MultipartFile;
import java.util.List;

public interface GeminiApiService {
    List<InsightDto> generatePatientInsights(Long memberActualId, String formType);

    List<InsightDto> aiMedicalInsights(Long memberActualId, String answerString);

    String generateContent(String prompt);

    String aiAudioTranscription(Long memberActualId, MultipartFile audioFile);
}
