package com.argusoft.sewa.android.app.qrscanner;

import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.util.SewaUtil;
import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcode;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetector;
import com.google.firebase.ml.vision.barcode.FirebaseVisionBarcodeDetectorOptions;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.common.FirebaseVisionImageMetadata;
import com.otaliastudios.cameraview.CameraView;
import com.otaliastudios.cameraview.controls.Flash;
import com.otaliastudios.cameraview.frame.Frame;
import com.otaliastudios.cameraview.frame.FrameProcessor;

import java.util.List;

/**
 * @author Utkarsh
 */
public class BarcodeScanningActivity extends AppCompatActivity {

    private CameraView cameraView;
    private Button switchFlash;
    private FirebaseVisionBarcodeDetector firebaseVisionBarcodeDetector;
    private boolean isDetected = false;
    private boolean isFlashLightOn = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.barcode_scanning_layout);
        setUpCamera();
    }

    private void setUpCamera() {
        cameraView = findViewById(R.id.cameraView);
        switchFlash = findViewById(R.id.switch_flashlight);
        cameraView.setLifecycleOwner(this);
        cameraView.addFrameProcessor(new FrameProcessor() {
            @Override
            public void process(@NonNull Frame frame) {
                processImage(getVisionImageFromFrame(frame));
            }
        });


        if (!hasFlash()) {
            switchFlash.setVisibility(View.GONE);
        } else {
            switchFlash.setOnClickListener(view -> switchFlashlight());
        }

        FirebaseVisionBarcodeDetectorOptions firebaseVisionBarcodeDetectorOptions = new FirebaseVisionBarcodeDetectorOptions.Builder()
                .setBarcodeFormats(FirebaseVisionBarcode.FORMAT_QR_CODE)
                .build();
        firebaseVisionBarcodeDetector = FirebaseVision.getInstance().getVisionBarcodeDetector(firebaseVisionBarcodeDetectorOptions);
    }

    private void processImage(FirebaseVisionImage visionImageFromFrame) {
        if (!isDetected) {
            firebaseVisionBarcodeDetector.detectInImage(visionImageFromFrame)
                    .addOnSuccessListener(new OnSuccessListener<List<FirebaseVisionBarcode>>() {
                        @Override
                        public void onSuccess(List<FirebaseVisionBarcode> firebaseVisionBarcodes) {
                            processResult(firebaseVisionBarcodes);
                        }
                    })
                    .addOnFailureListener(new OnFailureListener() {
                        @Override
                        public void onFailure(@NonNull Exception e) {
                            SewaUtil.generateToast(BarcodeScanningActivity.this, e.getMessage());
                        }
                    });
        }
    }

    private void processResult(List<FirebaseVisionBarcode> firebaseVisionBarcodes) {
        if (!firebaseVisionBarcodes.isEmpty()) {
            isDetected = true;
            for (FirebaseVisionBarcode item : firebaseVisionBarcodes) {
                int valueType = item.getValueType();
                Intent intent = new Intent();
                switch (valueType) {
                    case FirebaseVisionBarcode.TYPE_TEXT:
                        intent.putExtra(LabelConstants.SCANNER_DATA, item.getDisplayValue());
                        break;
                    case FirebaseVisionBarcode.TYPE_URL:
                        if (item.getDisplayValue() != null) {
                            intent.putExtra(LabelConstants.SCANNER_DATA, item.getDisplayValue().replace("http://", ""));
                        }
                        break;
                }
                setResult(RESULT_OK, intent);
                finish();
            }
        }
    }

    private boolean hasFlash() {
        return getApplicationContext().getPackageManager()
                .hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH);
    }

    private void switchFlashlight() {
        if (!isFlashLightOn) {
            cameraView.setFlash(Flash.TORCH);
            switchFlash.setText(R.string.turn_off_flashlight);
            isFlashLightOn = true;
        } else {
            cameraView.setFlash(Flash.OFF);
            switchFlash.setText(R.string.turn_on_flashlight);
            isFlashLightOn = false;
        }
    }

    private FirebaseVisionImage getVisionImageFromFrame(Frame frame) {
        byte[] data = frame.getData();
        FirebaseVisionImageMetadata firebaseVisionImageMetadata = new FirebaseVisionImageMetadata.Builder()
                .setFormat(FirebaseVisionImageMetadata.IMAGE_FORMAT_NV21)
                .setHeight(frame.getSize().getHeight())
                .setWidth(frame.getSize().getWidth())
                .build();
        return FirebaseVisionImage.fromByteArray(data, firebaseVisionImageMetadata);
    }

    @Override
    public void onBackPressed() {
        finish();
    }
}