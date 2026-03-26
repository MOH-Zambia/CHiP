package com.argusoft.sewa.android.app.llm;


import android.util.Log;

import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.mp.ai_gguf.GGUFNativeLib;
import com.mp.ai_gguf.models.StreamCallback;
import com.mp.ai_gguf.models.DecodingMetrics;

import org.androidannotations.annotations.EBean;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.concurrent.atomic.AtomicBoolean;

public class LlmService {

    private static final String TAG = "llm_LlmService";
    private static volatile LlmService instance;
    private AssetModelExtractor extractor;

    public static LlmService getInstance() {
        if (instance == null) {
            synchronized (LlmService.class) {
                if (instance == null) {
                    instance = new LlmService();
                }
            }
        }
        return instance;
    }

    private LlmService() {
        worker = Executors.newSingleThreadExecutor(r -> {
            Thread t = new Thread(r, "llm-worker");
            t.setPriority(Thread.MIN_PRIORITY);
            return t;
        });
    }

    public enum State { IDLE, LOADING, READY, ERROR }
    private final GGUFNativeLib gguf = new GGUFNativeLib();
    private volatile State state = State.IDLE;
    private final ExecutorService worker;
    private Future<?> activeFuture;
    private final AtomicBoolean abortFlag = new AtomicBoolean(false);

    public interface ModelStateListener {
        void onModelReady();
        void onModelUnloaded();
        void onModelError(String message);
    }

    public interface GenerationListener {
        void onToken(String token, String fullText);
        void onComplete(String fullText);
        void onError(Exception e);
    }


    public void loadModel(String modelPath, ModelStateListener listener) {
        if(modelPath == null){
            if (extractor == null) {
                extractor = new AssetModelExtractor(SharedStructureData.context);
            }
            modelPath = extractor.getModelLocalPath();
        }
        if (state == State.LOADING) {
            Log.w(TAG, "loadModel() called while already loading – ignored");
            return;
        }
        if (state == State.READY) {
            Log.i(TAG, "Model already loaded");
            if (listener != null)
                listener.onModelReady();
            return;
        }

        state = State.LOADING;
        String finalModelPath = modelPath;
        activeFuture = worker.submit(() -> {
            try {
                File f = new File(finalModelPath);
                if (!f.exists()) throw new Exception("Model file not found: " + finalModelPath);

                Log.i(TAG, "Loading: " + f.getName());

                boolean ok = gguf.nativeLoadModel(
                        finalModelPath,
                        ModelConstants.INFERENCE_N_THREADS,   // threads  (0 = auto)
                        ModelConstants.INFERENCE_N_CTX,        // ctxSize
                        ModelConstants.INFERENCE_TEMPERATURE,  // temp
                        ModelConstants.INFERENCE_TOP_K,        // topK
                        ModelConstants.INFERENCE_TOP_P,        // topP
                        0.05f,   // minP  (sensible default)
                        0,       // mirostat  (disabled)
                        5.0f,    // mirostatTau
                        0.1f,    // mirostatEta
                        -1       // seed  (-1 = random)
                );

                if (!ok) throw new Exception("nativeLoadModel returned false");

                if (ModelConstants.SYSTEM_PROMPT != null && !ModelConstants.SYSTEM_PROMPT.isEmpty()) {
                    gguf.nativeSetSystemPrompt(ModelConstants.SYSTEM_PROMPT);
                }

                state = State.READY;
                Log.i(TAG, "Model ready");
                if (listener != null)
                    listener.onModelReady();

            } catch (Throwable t) {
                state = State.ERROR;
                String msg = "Failed to load model: " + t.getMessage();
                Log.e(TAG, msg, t);
                if (listener != null) listener.onModelError(msg);
            }
        });
    }

    public void unloadModel(ModelStateListener listener) {
        abortFlag.set(true);
        gguf.nativeStopGeneration();

        worker.submit(() -> {
            try {
                gguf.nativeRelease();
                state = State.IDLE;
                Log.i(TAG, "Model unloaded");
                if (listener != null) listener.onModelUnloaded();
            } catch (Throwable t) {
                Log.e(TAG, "Unload error: " + t.getMessage(), t);
                if (listener != null) listener.onModelError("Unload failed: " + t.getMessage());
            }
        });
    }

    public void unloadModel() { unloadModel(null); }

    public boolean isModelLoaded() {
        return state == State.READY;
    }
    public State getState() {
        return state;
    }


    public void abortGeneration() {
        abortFlag.set(true);
        gguf.nativeStopGeneration();
        if (activeFuture != null) activeFuture.cancel(true);
    }

    public void generateResponse(
            final List<Message> conversationHistory,
            final String userMessage,
            final GenerationListener listener
    ) {
        if (!isModelLoaded()) {
            listener.onError(new IllegalStateException("Model not loaded. Call loadModel() first."));
            return;
        }

        abortFlag.set(false);

        activeFuture = worker.submit(() -> {
            try {
                int maxTokens = Math.min(1800, ModelConstants.INFERENCE_N_CTX - ModelConstants.INFERENCE_N_PREDICT - 50);
                List<Message> safeHistory = truncateHistory(conversationHistory, userMessage, maxTokens);
                String prompt = buildPrompt(safeHistory, userMessage);

                final StringBuilder fullText = new StringBuilder();

                gguf.nativeGenerateStream(prompt, ModelConstants.INFERENCE_N_PREDICT,
                        new StreamCallback() {
                            @Override
                            public void onToken(String token) {
                                if (abortFlag.get())
                                    return;
                                String clean = token
                                        .replace("<|im_end|>", "")
                                        .replace("<|im_start|>", "");
                                if (clean.isEmpty())
                                    return;
                                fullText.append(clean);
                                listener.onToken(clean, fullText.toString());
                            }

                            @Override
                            public void onToolCall(String name, String argsJson) {
                                // Not used in chat mode – ignore
                            }

                            @Override
                            public void onDone() {
                                if (!abortFlag.get()) {
                                    listener.onComplete(fullText.toString().trim());
                                }
                            }

                            @Override
                            public void onError(String message) {
                                if (!abortFlag.get()) {
                                    listener.onError(new Exception("Native error: " + message));
                                }
                            }

                            @Override
                            public void onMetrics(DecodingMetrics metrics) {
                                Log.i(TAG, "Tokens: " + metrics.getGeneratedTokens());
                            }
                        });

            } catch (Throwable err) {
                if (!abortFlag.get()) {
                    Log.e(TAG, "Generation error", err);
                    try { gguf.nativeRelease(); } catch (Exception ignored) {}
                    state = State.IDLE;
                    listener.onError(new Exception(
                            "Generation failed. Model context was reset. " +
                            "Please load the model again.", err));
                }
            }
        });
    }

    List<Message> truncateHistory(List<Message> history, String userMessage, int maxTokens) {
        int userEst = (int) Math.ceil(userMessage.length() / 4.0);
        int systemEst = (int) Math.ceil(ModelConstants.SYSTEM_PROMPT.length() / 4.0);
        int budget = maxTokens - userEst - systemEst - 50;

        List<Message> result = new ArrayList<>();
        for (int i = history.size() - 1; i >= 0; i--) {
            int est = (int) Math.ceil(history.get(i).getContent().length() / 4.0);
            if (budget - est < 0) break;
            budget -= est;
            result.add(0, history.get(i));
        }
        return result;
    }

    String buildPrompt(List<Message> history, String userMessage) {
        StringBuilder sb = new StringBuilder();
        sb.append("<|im_start|>system\n")
          .append(ModelConstants.SYSTEM_PROMPT)
          .append("<|im_end|>\n");

        for (Message msg : history) {
            sb.append("<|im_start|>").append(msg.getRole()).append("\n")
              .append(msg.getContent()).append("<|im_end|>\n");
        }

        sb.append("<|im_start|>user\n")
          .append(userMessage)
          .append("<|im_end|>\n<|im_start|>assistant\n");

        Log.i(TAG, "Prompt token estimate: ~" + (int) Math.ceil(sb.length() / 4.0));
        return sb.toString();
    }
}
