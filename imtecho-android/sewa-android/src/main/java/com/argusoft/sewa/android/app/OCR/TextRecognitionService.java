package com.argusoft.sewa.android.app.OCR;

import static org.androidannotations.annotations.EBean.Scope.Singleton;

import android.graphics.Bitmap;

import com.argusoft.sewa.android.app.util.Log;
import com.google.mlkit.vision.common.InputImage;
import com.google.mlkit.vision.text.Text;
import com.google.mlkit.vision.text.TextRecognition;
import com.google.mlkit.vision.text.TextRecognizer;
import com.google.mlkit.vision.text.latin.TextRecognizerOptions;

import org.androidannotations.annotations.EBean;

@EBean(scope = Singleton)
public class TextRecognitionService {

    private TextRecognizer textRecognizer;

    public interface TextRecognitionCallback {
        void onTextRecognized(String text);
        void onError(Exception e);
    }

    public void processImage(Bitmap bitmap, TextRecognitionCallback callback) {
        textRecognizer = TextRecognition.getClient(TextRecognizerOptions.DEFAULT_OPTIONS);
        InputImage image = InputImage.fromBitmap(bitmap, 0);
        textRecognizer.process(image)
                .addOnSuccessListener(text -> {
                    // Extracting text from each block, line, or element as needed
                    StringBuilder extractedText = new StringBuilder();
                    for (Text.TextBlock block : text.getTextBlocks()) {
                        extractedText.append(block.getText()).append("\n");
                    }
                    callback.onTextRecognized(extractedText.toString());
                })
                .addOnFailureListener(
                        e -> Log.e("ERRRRPRRR", e.getMessage()));
    }
    public void close() {
        textRecognizer.close();
    }
}