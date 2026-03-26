package com.argusoft.sewa.android.app.activity;

import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.llm.AssetModelExtractor;
import com.argusoft.sewa.android.app.llm.LlmService;
import com.argusoft.sewa.android.app.llm.Message;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class LlmChatActivity extends AppCompatActivity {

    private EditText etMessage;
    private Button btnSend;
    private ProgressBar progressBar;
    private final List<Message> history = new ArrayList<>();
    private LlmService llmService;
    private AssetModelExtractor extractor;
    private final ExecutorService ioThread = Executors.newSingleThreadExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_llm_chat);

        Toolbar toolbar = findViewById(R.id.llm_toolbar);
        setSupportActionBar(toolbar);
        if (getSupportActionBar() != null) {
            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
            toolbar.setNavigationOnClickListener(v -> finish());
        }

        etMessage = findViewById(R.id.etMessage);
        btnSend = findViewById(R.id.btnSend);
        progressBar = findViewById(R.id.llmProgress);
        llmService = LlmService.getInstance();
        extractor  = new AssetModelExtractor(this);
        btnSend.setOnClickListener(v -> onSendClicked());
        initModel();
    }

    private void initModel() {
        if (llmService.isModelLoaded()) {
            setUiReady(true);
            return;
        }

        if (extractor.isModelExtracted()) {
            loadModel(extractor.getModelLocalPath());
            return;
        }
        extractThenLoad();
    }

    private void extractThenLoad() {
        setUiReady(false);
        progressBar.setVisibility(View.VISIBLE);
        progressBar.setProgress(0);
        showToast("Copying model from assets…");

        ioThread.submit(() -> extractor.extract(new AssetModelExtractor.ExtractListener() {
            @Override
            public void onProgress(int percent) {
                runOnUiThread(() -> progressBar.setProgress(percent));
            }

            @Override
            public void onSuccess(String localPath) {
                runOnUiThread(() -> {
                    progressBar.setVisibility(View.GONE);
                    showToast("Model ready to load");
                    loadModel(localPath);
                });
            }

            @Override
            public void onError(Exception e) {
                runOnUiThread(() -> {
                    progressBar.setVisibility(View.GONE);
                    showToast("Failed to extract model: " + e.getMessage());
                });
            }
        }));
    }

    private void loadModel(String path) {
        setUiReady(false);
        showToast("Loading model…");

        llmService.loadModel(path, new LlmService.ModelStateListener() {
            @Override public void onModelReady() {
                runOnUiThread(() -> {
                    showToast("Model ready ✓");
                    setUiReady(true);
                });
            }
            @Override public void onModelUnloaded() { /* no-op */ }
            @Override public void onModelError(String message) {
                runOnUiThread(() -> showToast("Load error: " + message));
            }
        });
    }

    private void onSendClicked() {
        String msg = etMessage.getText().toString().trim();
        if (msg.isEmpty()) return;

        history.add(new Message(Message.ROLE_USER, msg));
        etMessage.setText("");
        setUiReady(false);

        llmService.generateResponse(history, msg, new LlmService.GenerationListener() {
            @Override public void onToken(String token, String fullText) {
            }

            @Override public void onComplete(String fullText) {
                history.add(new Message(Message.ROLE_ASSISTANT, fullText));
                runOnUiThread(() -> {
                    setUiReady(true);
                    showToast("AI: " + (fullText.length() > 100
                            ? fullText.substring(0, 100) + "…"
                            : fullText));
                });
            }

            @Override public void onError(Exception e) {
                runOnUiThread(() -> {
                    setUiReady(true);
                    showToast("Error: " + e.getMessage());
                });
            }
        });
    }


    @Override
    protected void onDestroy() {
        ioThread.shutdownNow();
        super.onDestroy();
        // LlmService is a singleton – model stays loaded until explicitly unloaded
    }

    private void setUiReady(boolean ready) {
        btnSend.setEnabled(ready);
        etMessage.setEnabled(ready);
    }

    private void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_SHORT).show();
    }
}
