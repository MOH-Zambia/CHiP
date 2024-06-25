package com.argusoft.sewa.android.app.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.WindowManager;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import org.androidannotations.annotations.EActivity;

@EActivity
public class BaseActivity extends AppCompatActivity {
    private final Handler inactivityHandler = new Handler();
    private final Runnable inactivityRunnable = this::performAfterInactivity;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        //getWindow().setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE);
        super.onCreate(savedInstanceState);
        startInactivityCheck();
    }

    private void performAfterInactivity() {
        Intent intent = new Intent(this, LoginActivity_.class);
        startActivity(intent);
        finish();
    }

    private void startInactivityCheck() {
        inactivityHandler.postDelayed(inactivityRunnable, 15 * 60 * 1000);
    }

    public void resetInactivityTimer() {
        inactivityHandler.removeCallbacks(inactivityRunnable);
        startInactivityCheck();
    }

    @Override
    public void onUserInteraction() {
        super.onUserInteraction();
        resetInactivityTimer();
    }

    @Override
    protected void onStop() {
        super.onStop();
        inactivityHandler.removeCallbacks(inactivityRunnable);
    }
}