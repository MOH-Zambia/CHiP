package com.argusoft.sewa.android.app.llm;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class DownloadService {

    private static final String TAG = "llm_DownloadService";
    private static final String MODELS_DIR = "models";

    public interface DownloadListener {
        void onProgress(int progress);
        void onSuccess(String localPath);
        void onError(Exception e);
    }

    private final Context context;
    private final OkHttpClient okHttpClient;
    private final ExecutorService executorService;
    private Call currentCall;

    public DownloadService(Context context) {
        this.context = context.getApplicationContext();
        this.okHttpClient = new OkHttpClient();
        this.executorService = Executors.newSingleThreadExecutor();
    }

    public String getModelLocalPath() {
        File dir = new File(context.getFilesDir(), MODELS_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return new File(dir, ModelConstants.FILENAME).getAbsolutePath();
    }

    public boolean isModelDownloaded() {
        File file = new File(getModelLocalPath());
        return file.exists() && file.length() > 100_000_000L;
    }

    public void downloadModel(final DownloadListener listener) {
        executorService.submit(new Runnable() {
            @Override
            public void run() {
                try {
                    String localPath = getModelLocalPath();
                    File file = new File(localPath);

                    // Remove any partial download
                    if (file.exists() && file.length() < 100_000_000L) {
                        file.delete();
                    } else if (file.exists() && file.length() >= 100_000_000L) {
                        // Already downloaded
                        listener.onProgress(100);
                        listener.onSuccess(localPath);
                        return;
                    }

                    Request request = new Request.Builder()
                            .url(ModelConstants.DOWNLOAD_URL)
                            .build();

                    currentCall = okHttpClient.newCall(request);
                    Response response = currentCall.execute();

                    if (!response.isSuccessful() || response.body() == null) {
                        throw new Exception("Download failed: HTTP " + response.code());
                    }

                    long totalBytes = response.body().contentLength();
                    if (totalBytes <= 0) {
                        totalBytes = ModelConstants.SIZE_BYTES; // fallback estimate
                    }

                    InputStream inputStream = response.body().byteStream();
                    OutputStream outputStream = new FileOutputStream(file);

                    byte[] buffer = new byte[8192];
                    long downloadedBytes = 0;
                    int read;
                    int lastProgress = 0;

                    while ((read = inputStream.read(buffer)) != -1) {
                        outputStream.write(buffer, 0, read);
                        downloadedBytes += read;

                        int progress = (int) ((downloadedBytes * 100) / totalBytes);
                        if (progress > lastProgress) {
                            lastProgress = progress;
                            listener.onProgress(progress);
                        }
                    }

                    outputStream.flush();
                    outputStream.close();
                    inputStream.close();

                    listener.onSuccess(localPath);

                } catch (Exception e) {
                    if (currentCall != null && currentCall.isCanceled()) {
                        Log.w(TAG, "Download was canceled.");
                    } else {
                        Log.e(TAG, "Download failed", e);
                        listener.onError(e);
                    }
                } finally {
                    currentCall = null;
                }
            }
        });
    }

    public void cancelDownload() {
        if (currentCall != null && !currentCall.isCanceled()) {
            currentCall.cancel();
        }
    }

    public void deleteModel() {
        File file = new File(getModelLocalPath());
        if (file.exists()) {
            file.delete();
        }
    }
}
