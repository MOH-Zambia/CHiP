package com.medlocal.core.llm.service;

interface IGgufGenerationCallback {
    void onToken(String token);
    void onToolCall(String name, String args);
    void onMetrics(int totalTokens, int promptTokens, int generatedTokens, float tokensPerSecond, long timeToFirstToken, long totalTimeMs);
    void onDone();
    void onError(String message);
}
