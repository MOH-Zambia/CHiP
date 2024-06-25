/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.argusoft.sewa.android.app.activity;

import android.Manifest;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.os.Bundle;
import android.view.Surface;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageCapture;
import androidx.camera.core.ImageCaptureException;
import androidx.camera.core.Preview;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.lifecycle.LifecycleOwner;
import androidx.recyclerview.widget.RecyclerView;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.component.ImageGridLayoutAdapter;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.util.FileUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.google.common.util.concurrent.ListenableFuture;

import java.io.File;
import java.util.Date;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * @author kunjan                                                                private static final int REQUEST_CAMERA_PERMISSION = 200;
 * private TextureView textureView;
 */
public class CustomPhotoCaptureActivity extends AppCompatActivity {
    private static final int REQUEST_CODE_PERMISSIONS = 10;
    private static final String[] REQUIRED_PERMISSIONS = new String[]{Manifest.permission.CAMERA};

    private PreviewView viewFinder;
    private ImageCapture imageCapture;
    private ExecutorService cameraExecutor;

    private RelativeLayout progressLayout;
    private Button captureButton;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.photo_capture);

        viewFinder = findViewById(R.id.textureView);

        if (allPermissionsGranted()) {
            startCamera();
        } else {
            ActivityCompat.requestPermissions(this, REQUIRED_PERMISSIONS, REQUEST_CODE_PERMISSIONS);
        }
        progressLayout = findViewById(R.id.progressLayout);
        captureButton = findViewById(R.id.button_capture);

        getOutputDirectory();
        cameraExecutor = Executors.newSingleThreadExecutor();

        captureButton.setOnClickListener(view -> takePhoto());
    }

    private boolean allPermissionsGranted() {
        for (String permission : REQUIRED_PERMISSIONS) {
            if (ContextCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED) {
                return false;
            }
        }
        return true;
    }

    private void startCamera() {
        ListenableFuture<ProcessCameraProvider> cameraProviderFuture = ProcessCameraProvider.getInstance(this);

        cameraProviderFuture.addListener(() -> {
            try {
                ProcessCameraProvider cameraProvider = cameraProviderFuture.get();

                Preview preview = new Preview.Builder().build();
                preview.setSurfaceProvider(viewFinder.getSurfaceProvider());

                imageCapture = new ImageCapture.Builder()
                        .setTargetRotation(Surface.ROTATION_0)
                        .build();

                CameraSelector cameraSelector = CameraSelector.DEFAULT_BACK_CAMERA;

                cameraProvider.unbindAll();
                cameraProvider.bindToLifecycle((LifecycleOwner) this, cameraSelector, preview, imageCapture);

            } catch (ExecutionException | InterruptedException e) {
                // Handle exceptions
            }
        }, ContextCompat.getMainExecutor(this));
    }

    private void takePhoto() {
        if (imageCapture == null) return;
        progressLayout.setVisibility(View.VISIBLE);
        captureButton.setVisibility(View.GONE);
        String photoName =
                SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_ACTUAL_ID) + "_" + new Date().getTime() + GlobalTypes.IMAGE_CAPTURE_FORMAT;
        System.out.println("******************************     " + photoName);
        File photoFile = new File(SewaConstants.getDirectoryPath(this, SewaConstants.DIR_IMAGE), photoName);

        ImageCapture.OutputFileOptions outputOptions = new ImageCapture.OutputFileOptions.Builder(photoFile).build();

        imageCapture.takePicture(outputOptions, cameraExecutor, new ImageCapture.OnImageSavedCallback() {
            @Override
            public void onImageSaved(@NonNull ImageCapture.OutputFileResults outputFileResults) {
                runOnUiThread(() -> {
                    QueFormBean queFormBean = SharedStructureData.mapIndexQuestion.get(SharedStructureData.currentQuestion);
                    if (queFormBean != null) {
                        String uniqueId = UUID.randomUUID().toString();
                        if (photoFile.exists()) {
                            if (queFormBean.getLength() < 1) {
                                Bitmap bitmap = BitmapFactory.decodeFile(photoFile.getAbsolutePath());
                                try {
                                    bitmap = rotateBitmapWithAspectRatio(bitmap, 90);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                LinearLayout parentLayout = (LinearLayout) queFormBean.getQuestionTypeView();
                                ImageView takenImage = parentLayout.findViewById(GlobalTypes.PHOTO_CAPTURE_ACTIVITY);
                                takenImage.setVisibility(View.VISIBLE);
                                takenImage.setImageBitmap(bitmap);
                                queFormBean.setAnswer(uniqueId);
                                SharedStructureData.imageFilesToUpload.put(uniqueId,photoName);
                            } else {
                                Bitmap bitmap = BitmapFactory.decodeFile(photoFile.getAbsolutePath());
                                try {
                                    bitmap = rotateBitmapWithAspectRatio(bitmap, 90);
                                    FileUtils.getInstance().convertBitmapToFile(bitmap, photoFile.getAbsolutePath());
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                                View parentLayout = (View) queFormBean.getQuestionTypeView();
                                RecyclerView recyclerView = parentLayout.findViewById(R.id.recyclerView);
                                ImageGridLayoutAdapter imageGridLayoutAdapter = ((ImageGridLayoutAdapter) Objects.requireNonNull(recyclerView.getAdapter()));
                                imageGridLayoutAdapter.addImage(uniqueId,photoName);
                                SharedStructureData.imageFilesToUpload.put(uniqueId, photoName);
                                queFormBean.setAnswer(imageGridLayoutAdapter.getUniqueIdList());
                            }
                            SewaUtil.generateToast(CustomPhotoCaptureActivity.this, LabelConstants.PHOTO_CAPTURED);
                        } else {
                            SewaUtil.generateToast(CustomPhotoCaptureActivity.this, LabelConstants.PHOTO_CAPTURED_FAILED);
                        }
                    }
                    progressLayout.setVisibility(View.GONE);
                    captureButton.setVisibility(View.VISIBLE);
                    finish();
                });
            }

            @Override
            public void onError(@NonNull ImageCaptureException exception) {
                exception.printStackTrace();
            }
        });
    }


    public Bitmap rotateBitmapWithAspectRatio(Bitmap source, float degrees) {
        // Calculate the new dimensions for the rotated bitmap
        int sourceWidth = source.getWidth();
        int sourceHeight = source.getHeight();
        Matrix matrix = new Matrix();
        matrix.postRotate(degrees);

        // Create a new bitmap with the rotated image
        Bitmap rotatedBitmap = Bitmap.createBitmap(source, 0, 0, sourceWidth, sourceHeight, matrix, true);

        return rotatedBitmap;
    }

    @Override
    public void onBackPressed() {
        if (findViewById(R.id.button_capture).getVisibility() == View.VISIBLE) {
            super.onBackPressed();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == REQUEST_CODE_PERMISSIONS) {
            if (allPermissionsGranted()) {
                startCamera();
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        cameraExecutor.shutdown();
    }

    private File getOutputDirectory() {
        File appDir = new File(SewaConstants.getDirectoryPath(this, SewaConstants.DIR_IMAGE));
        if (!appDir.exists() && !appDir.mkdir()) {
            appDir = getFilesDir();
        }
        return appDir;
    }
}

