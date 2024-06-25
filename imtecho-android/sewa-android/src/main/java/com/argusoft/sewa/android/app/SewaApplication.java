/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app;

import android.app.Application;
import android.content.SharedPreferences;
import android.os.PowerManager;
import android.preference.PreferenceManager;

import com.argusoft.sewa.android.app.core.impl.SewaServiceImpl;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.WSConstants;
import com.j256.ormlite.android.apptools.OpenHelperManager;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EApplication;

import java.lang.Thread.UncaughtExceptionHandler;

/**
 * @author kelvin
 */
@EApplication
public class SewaApplication extends Application {

    private UncaughtExceptionHandler defaultUEH;
    PowerManager.WakeLock screenOnWakeLock;
    private static String generatedToken;
    private static SharedPreferences sharedPref;
    @Bean
    SewaServiceImpl sewaService;

    public SewaApplication() {
        Log.d("APPS_INSTALLED", "Configurations Called");
        defaultUEH = Thread.getDefaultUncaughtExceptionHandler();
        UncaughtExceptionHandler uncaughtExceptionHandler = (thread, ex) -> {
            SharedStructureData.sewaService.storeException(ex, GlobalTypes.EXCEPTION_TYPE_UNHANDLED);
            OpenHelperManager.releaseHelper();
            defaultUEH.uncaughtException(thread, ex);
        };
        Thread.setDefaultUncaughtExceptionHandler(uncaughtExceptionHandler);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        sharedPref = PreferenceManager.getDefaultSharedPreferences(this);
        Log.d("APPS_INSTALLED", "onCreate of Main");
        WSConstants.setLiveContextUrl();
        PowerManager powerManager = (PowerManager) getSystemService(POWER_SERVICE);
        screenOnWakeLock =  powerManager.newWakeLock(PowerManager.SCREEN_BRIGHT_WAKE_LOCK,"SewaApp:ScreenlockTag");
        screenOnWakeLock.acquire(10*60*1000L /*10 minutes*/);
    }

    public static String getEcgToken(){
        return generatedToken;
    }

    public static void setEcgToken(String token){
        generatedToken = token;
        sharedPref.edit().putString("ECG_TOKEN",token).apply();
    }

    @Override
    public void onTerminate() {
        super.onTerminate();
        OpenHelperManager.releaseHelper();
    }
}
