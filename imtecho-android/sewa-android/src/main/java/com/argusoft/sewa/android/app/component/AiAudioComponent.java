package com.argusoft.sewa.android.app.component;

import android.content.Context;
import android.graphics.Color;
import android.view.Gravity;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.Toast;

import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.util.HiddenQuestionFormulaUtil;
import com.google.android.material.textview.MaterialTextView;

public class AiAudioComponent extends LinearLayout {

    private ProgressBar loader;
    private LinearLayout container;
    private Button recordButton;
    private MaterialTextView transcriptView;
    private boolean isRecording = false;
    private QueFormBean queFormBean;

    public AiAudioComponent(Context context, QueFormBean queFormBean) {
        super(context);
        this.queFormBean = queFormBean;
        setOrientation(VERTICAL);
        setLayoutParams(new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        ));
        setPadding(16, 16, 16, 16);

        initViews(context);
    }

    private void initViews(Context context) {
        // Record Button
        recordButton = new Button(context);
        recordButton.setText("Start Recording");
        LayoutParams btnParams = new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        );
        btnParams.setMargins(0, 0, 0, 20);
        recordButton.setLayoutParams(btnParams);
        recordButton.setOnClickListener(v -> toggleRecording());
        addView(recordButton);

        // Loader
        loader = new ProgressBar(context);
        LayoutParams loaderParams = new LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
        );
        loaderParams.gravity = Gravity.CENTER;
        loader.setLayoutParams(loaderParams);
        loader.setVisibility(GONE);
        addView(loader);

        // Container for transcript
        container = new LinearLayout(context);
        container.setOrientation(VERTICAL);
        container.setVisibility(GONE);
        LayoutParams containerParams = new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        );
        container.setLayoutParams(containerParams);

        transcriptView = new MaterialTextView(context);
        transcriptView.setTextSize(14f);
        transcriptView.setTextColor(Color.BLACK);
        container.addView(transcriptView);

        addView(container);
    }

    private android.media.MediaRecorder recorder;
    private String audioFilePath;

    private void toggleRecording() {
        isRecording = !isRecording;
        if (isRecording) {
            startRecording();
        } else {
            stopRecording();
        }
    }

    private void startRecording() {
        recordButton.setText("Stop Recording & Send");
        audioFilePath = getContext().getExternalCacheDir().getAbsolutePath() + "/ai_audio_record_" + System.currentTimeMillis() + ".3gp";
        recorder = new android.media.MediaRecorder();
        recorder.setAudioSource(android.media.MediaRecorder.AudioSource.MIC);
        recorder.setOutputFormat(android.media.MediaRecorder.OutputFormat.THREE_GPP);
        recorder.setOutputFile(audioFilePath);
        recorder.setAudioEncoder(android.media.MediaRecorder.AudioEncoder.AMR_NB);

        try {
            recorder.prepare();
            recorder.start();
            android.widget.Toast.makeText(getContext(), "Recording started...", android.widget.Toast.LENGTH_SHORT).show();
        } catch (java.io.IOException | IllegalStateException e) {
            android.widget.Toast.makeText(getContext(), "Recording failed to start", android.widget.Toast.LENGTH_SHORT).show();
            isRecording = false;
            recordButton.setText("Start Recording");
        }
    }

    private void stopRecording() {
        recordButton.setText("Start Recording");
        if (recorder != null) {
            try {
                recorder.stop();
            } catch (RuntimeException e) {
                // Ignore if called immediately after start
            }
            recorder.release();
            recorder = null;
            android.widget.Toast.makeText(getContext(), "Recording stopped. Transcribing...", android.widget.Toast.LENGTH_SHORT).show();
            
            queFormBean.setAnswer(audioFilePath);
            HiddenQuestionFormulaUtil.generateAiAudioTranscriptionAsync(queFormBean);
        }
    }

    public void showLoader() {
        if (loader != null) loader.setVisibility(VISIBLE);
        if (container != null) container.setVisibility(GONE);
    }

    public void showError(String msg) {
        if (loader != null) loader.setVisibility(GONE);
        if (container != null) {
            container.setVisibility(VISIBLE);
            transcriptView.setText(msg != null ? msg : "Something went wrong");
            transcriptView.setTextColor(Color.RED);
        }
    }

    public void setTranscript(String transcript) {
        if (loader != null) loader.setVisibility(GONE);
        if (container != null) {
            container.setVisibility(VISIBLE);
            transcriptView.setText(transcript);
            transcriptView.setTextColor(Color.BLACK);
        }
    }
}
