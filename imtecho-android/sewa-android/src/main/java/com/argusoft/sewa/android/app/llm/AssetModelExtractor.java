package com.argusoft.sewa.android.app.llm;

import android.content.Context;
import android.content.res.AssetManager;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * Copies the bundled .gguf model from the APK assets folder to the app's
 * private internal storage so that llama.cpp can open it as a normal file.
 *
 * The copy is skipped if the destination file already exists and has the
 * correct size (checked against ModelConstants.SIZE_BYTES).
 */
public class AssetModelExtractor {

    private static final String TAG = "AssetModelExtractor";
    private static final String MODELS_DIR = "models";

    public interface ExtractListener {
        void onProgress(int percent);
        void onSuccess(String localPath);
        void onError(Exception e);
    }

    private final Context context;

    public AssetModelExtractor(Context context) {
        this.context = context.getApplicationContext();
    }

    /** Absolute path where the model will live after extraction. */
    public String getModelLocalPath() {
        File dir = new File(context.getFilesDir(), MODELS_DIR);
        return new File(dir, ModelConstants.FILENAME).getAbsolutePath();
    }

    public boolean isModelExtracted() {
        File f = new File(getModelLocalPath());
        return f.exists() && f.length() > (long) (ModelConstants.SIZE_BYTES * 0.8);
    }

    public void extract(ExtractListener listener) {
        try {
            File dir = new File(context.getFilesDir(), MODELS_DIR);
            if (!dir.exists()) dir.mkdirs();

            File dest = new File(dir, ModelConstants.FILENAME);

            if (dest.exists() && dest.length() > (long) (ModelConstants.SIZE_BYTES * 0.8)) {
                Log.i(TAG, "Model already extracted, skipping copy.");
                listener.onProgress(100);
                listener.onSuccess(dest.getAbsolutePath());
                return;
            }

            if (dest.exists()) {
                dest.delete();
            }

            Log.i(TAG, "Copying " + ModelConstants.FILENAME + " from assets → " + dest);

            AssetManager am = context.getAssets();
            try (InputStream in = am.open(ModelConstants.FILENAME);
                 OutputStream out = new FileOutputStream(dest)) {

                byte[] buf = new byte[64 * 1024]; // 64 KB chunks
                long total = ModelConstants.SIZE_BYTES;
                long copied = 0;
                int lastPercent = -1;
                int n;

                while ((n = in.read(buf)) != -1) {
                    out.write(buf, 0, n);
                    copied += n;
                    int percent = total > 0 ? (int) (copied * 100 / total) : 0;
                    if (percent != lastPercent) {
                        lastPercent = percent;
                        listener.onProgress(percent);
                    }
                }
                out.flush();
            }

            Log.i(TAG, "Extraction complete: " + dest.length() + " bytes");
            listener.onSuccess(dest.getAbsolutePath());

        } catch (IOException e) {
            Log.e(TAG, "Extraction failed", e);
            listener.onError(e);
        }
    }
}
