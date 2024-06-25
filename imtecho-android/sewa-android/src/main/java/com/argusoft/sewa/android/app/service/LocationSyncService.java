package com.argusoft.sewa.android.app.service;

import static com.argusoft.sewa.android.app.datastructure.SharedStructureData.gps;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;

import androidx.annotation.Nullable;

import com.argusoft.sewa.android.app.core.impl.SewaServiceRestClientImpl;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EService;


@EService
public class LocationSyncService extends Service {

    private Handler handler;
    private Runnable runnable;

    @Bean
    SewaServiceRestClientImpl sewaServiceRestClient;

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        handler = new Handler();
        runnable = () -> {
            if (gps != null) {
                gps.getLocation();
                String currentLat = String.valueOf(GPSTracker.latitude);
                String currentLng = String.valueOf(GPSTracker.longitude);
                //callLocationSyncApi(currentLat, currentLng);
            }
            handler.postDelayed(runnable, 30000);// 30 sec
        };
        handler.postDelayed(runnable, 30000); // 30 sec
        return START_STICKY;
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
