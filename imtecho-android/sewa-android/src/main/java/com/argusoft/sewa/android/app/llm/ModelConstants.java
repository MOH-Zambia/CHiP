package com.argusoft.sewa.android.app.llm;

public class ModelConstants {
    public static final String DOWNLOAD_URL = "https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf";
    public static final String FILENAME = "qwen2.5-coder-1.5b-instruct-q4_k_m.gguf";
    public static final long SIZE_BYTES = 986_000_000L;
    public static final int CONTEXT_LENGTH = 4096;
    public static final int INFERENCE_N_PREDICT = 4000;
    public static final float INFERENCE_TEMPERATURE = 0.1f;
    public static final float INFERENCE_TOP_P = 0.9f;
    public static final int INFERENCE_TOP_K = 40;
    public static final int INFERENCE_N_THREADS = 4;
    public static final int INFERENCE_N_CTX = 4096;

    public static final String SYSTEM_PROMPT = 
        "You are a helpful, Generate Response only in bullet points. concise AI assistant running fully offline on an Android device. " +
        "Answer clearly and accurately. If you are unsure, say so." +
        "If you do not know something, say so honestly. Do not make up facts.";

    public static final long MIN_RAM_BYTES = 1_000_000_000L;
}
