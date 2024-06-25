package com.argusoft.sewa.android.app.component;

import static android.view.ViewGroup.LayoutParams.MATCH_PARENT;
import static android.view.ViewGroup.LayoutParams.WRAP_CONTENT;

import android.app.Dialog;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.widget.NestedScrollView;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.constants.LabelConstants;
import com.argusoft.sewa.android.app.constants.RelatedPropertyNameConstants;
import com.argusoft.sewa.android.app.databean.QrCodeDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.Log;
import com.argusoft.sewa.android.app.util.SewaConstants;
import com.argusoft.sewa.android.app.util.UtilBean;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textview.MaterialTextView;
import com.google.gson.Gson;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public abstract class MyQRcodeDialog extends Dialog {

    private Context context;
    private String title;
    private LinearLayout parentLayout;
    private LinearLayout mainParentLayout;
    private LinearLayout detailLayout;
    private String fileName;
    private Bitmap bitmapQr;

    public MyQRcodeDialog(Context context, String msg) {
        super(context);
        this.context = context;
        this.title = msg;
        init();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setCanceledOnTouchOutside(false);
        setCancelable(false);
        setContentView(mainParentLayout);
    }

    private void init() {
        NestedScrollView bodyScroller = MyStaticComponents.getScrollView(context, -1, new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT, 1));
        mainParentLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL,
                new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        parentLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL,
                new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        detailLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.VERTICAL,
                new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        mainParentLayout.setGravity(Gravity.CENTER);
        parentLayout.setGravity(Gravity.CENTER);
        detailLayout.setGravity(Gravity.CENTER);

        parentLayout.setPadding(15, 15, 15, 15);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);

        if (title != null) {
            LinearLayout linearLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.HORIZONTAL,
                    layoutParams);
            linearLayout.setPadding(30, 0, 30, 0);
            MaterialTextView materialTextView = MyStaticComponents.getMaterialTextView(context, title,
                    -1, R.style.CustomQuestionView, false);
            linearLayout.addView(materialTextView);
            parentLayout.addView(linearLayout);
        }

        ImageView imageQr = MyStaticComponents.getImageView(context, 1, null, null);
        String uuid = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.UUID);
        assert uuid != null;
        fileName = "QR_FAMILY_" + uuid.replace("/", "_") + ".png";
        String headOfFamilyName = LabelConstants.NOT_AVAILABLE;
        String familyFound = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_FOUND);
        String firstName, middleName, lastName;
        if (familyFound != null && familyFound.equals("1")) {
            if (SharedStructureData.loopBakCounter == 0) {
                String headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG);
                if (headAnswer != null && headAnswer.equals("2")) {
                    headOfFamilyName = LabelConstants.NOT_AVAILABLE;
                } else if (headAnswer != null && headAnswer.equals("1")) {
                    firstName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME);
                    middleName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MIDDLE_NAME);
                    lastName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME);
                    StringBuilder sb = new StringBuilder();
                    if (firstName != null) {
                        sb.append(firstName);
                    }
                    if (middleName != null) {
                        sb.append(" ");
                        sb.append(middleName);
                    }
                    if (lastName != null) {
                        sb.append(" ");
                        sb.append(lastName);
                    }
                    if (sb.length() > 0) {
                        headOfFamilyName = sb.toString();
                    }
                }
            } else {
                int headsDeclared = 0;
                String headAnswer;
                String statusAnswer;

                for (int i = 0; i < SharedStructureData.loopBakCounter + 1; i++) {
                    if (i == 0) {
                        headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG);
                        statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS);
                        firstName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME);
                        middleName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MIDDLE_NAME);
                        lastName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME);
                    } else {
                        headAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FAMILY_HEAD_FLAG + i);
                        statusAnswer = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MEMBER_STATUS + i);
                        firstName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.FIRST_NAME + i);
                        middleName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.MIDDLE_NAME + i);
                        lastName = SharedStructureData.relatedPropertyHashTable.get(RelatedPropertyNameConstants.LAST_NAME + i);
                    }
                    if (headAnswer != null && headAnswer.equals("1")) {
                        StringBuilder sb = new StringBuilder();
                        if (firstName != null) {
                            sb.append(firstName);
                        }
                        if (middleName != null) {
                            sb.append(middleName);
                        }
                        if (lastName != null) {
                            sb.append(lastName);
                        }
                        if (sb.length() > 0) {
                            headOfFamilyName = sb.toString();
                        }
                    }
                    if ((statusAnswer == null && headAnswer != null && headAnswer.equals("1"))
                            || (headAnswer != null && statusAnswer != null && headAnswer.equals("1") && statusAnswer.equals("1"))) {
                        headsDeclared++;
                    }

                }
                if (headsDeclared > 1) {
                    headOfFamilyName = "Multiple HOF found";
                }
            }
        }
        try {
            String currentLatitude = SharedStructureData.relatedPropertyHashTable.get("currentLatitude");
            String currentLongitude = SharedStructureData.relatedPropertyHashTable.get("currentLongitude");

            String qrData;
            QrCodeDataBean qrCodeDataBean = new QrCodeDataBean();
            Gson gson = new Gson();
            qrCodeDataBean.setHeadOfFamilyName(headOfFamilyName);
            if (currentLatitude != null) {
                qrCodeDataBean.setLatitude(currentLatitude);
            }
            if (currentLongitude != null) {
                qrCodeDataBean.setLongitude(currentLongitude);
            }
            if (currentLatitude != null && currentLongitude != null) {
                qrCodeDataBean.setPlusCode(UtilBean.convertLatLngToPlusCode(Double.parseDouble(currentLatitude), Double.parseDouble(currentLongitude), 10));
            }
            qrCodeDataBean.setUuid(uuid);
            qrData = gson.toJson(qrCodeDataBean);
            imageQr.setImageBitmap(encodeAsBitmap(qrData));
        } catch (WriterException e) {
            throw new RuntimeException(e);
        }


        detailLayout.addView(imageQr);
        detailLayout.addView(MyStaticComponents.getMaterialTextView(context, uuid,-1, R.style.CustomQuestionView, false));
        detailLayout.addView(MyStaticComponents.getOrTextView(context));
        String currentLatitude = SharedStructureData.relatedPropertyHashTable.get("currentLatitude");
        String currentLongitude = SharedStructureData.relatedPropertyHashTable.get("currentLongitude");
        if (currentLatitude != null && currentLongitude != null) {
            detailLayout.addView(MyStaticComponents.getMaterialTextView(context, UtilBean.convertLatLngToPlusCode(Double.parseDouble(currentLatitude), Double.parseDouble(currentLongitude), 10),-1, R.style.CustomQuestionView, false));
        }
        detailLayout.setPadding(30, 0, 30, 0);
        parentLayout.addView(detailLayout);
        MaterialTextView answerView = MyStaticComponents.generateAnswerView(context, " ");// don't keep it empty
        answerView.setId(GlobalTypes.QR_SCAN_ACTIVITY);
        answerView.setVisibility(View.GONE);
        parentLayout.addView(answerView);


        layoutParams.setMargins(20, 0, 20, 0);

        LinearLayout footerLayout = MyStaticComponents.getLinearLayout(context, -1, LinearLayout.HORIZONTAL,
                new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
        footerLayout.setGravity(Gravity.CENTER);
        footerLayout.setPadding(30, 0, 30, 0);
        footerLayout.setWeightSum(2);

        MaterialButton button1 = MyStaticComponents.getCustomButton(context, LabelConstants.DOWNLOAD, BUTTON_POSITIVE, layoutParams);
        button1.setCornerRadius(0);
        button1.setTypeface(Typeface.DEFAULT_BOLD);
        button1.setBackgroundColor(ContextCompat.getColor(context, R.color.buttonBackground));
        button1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                saveImageToGallery(UtilBean.getBitmapFromView(detailLayout));
            }
        });

//        MaterialButton button2 = MyStaticComponents.getCustomButton(context, LabelConstants.SHARE, BUTTON_POSITIVE, layoutParams);
//        button2.setCornerRadius(0);
//        button2.setTypeface(Typeface.DEFAULT_BOLD);
//        button2.setBackgroundColor(ContextCompat.getColor(context, R.color.buttonBackground));
//        button2.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                shareQrCode();
//            }
//        });

        parentLayout.addView(button1);
//        footerLayout.addView(button2);


        layoutParams = new LinearLayout.LayoutParams(MATCH_PARENT, WRAP_CONTENT);
        layoutParams.setMargins(20, 0, 20, 0);

        MaterialButton positiveButton = MyStaticComponents.getCustomButton(context, LabelConstants.OK, BUTTON_POSITIVE, layoutParams);
        positiveButton.setCornerRadius(0);
        positiveButton.setTypeface(Typeface.DEFAULT_BOLD);
        positiveButton.setBackgroundColor(ContextCompat.getColor(context, R.color.buttonBackground));
        positiveButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                onButtonClick();
            }
        });
        parentLayout.addView(positiveButton);
        bodyScroller.addView(parentLayout);
        mainParentLayout.addView(bodyScroller);
    }

    private void saveImageToGallery(Bitmap myBitmap) {
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.DISPLAY_NAME, fileName);
        values.put(MediaStore.Images.Media.TITLE, fileName);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/png");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES);
        }
        Uri imageUri;

        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                imageUri = context.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
                assert imageUri != null;
                OutputStream os = context.getContentResolver().openOutputStream(imageUri);
                myBitmap.compress(Bitmap.CompressFormat.JPEG, 100, os);
                assert os != null;
                os.close();
                Toast.makeText(context, "Image saved to gallery", Toast.LENGTH_SHORT).show();
            } else {
                File storageDir = Environment.getExternalStorageDirectory();
                File file = new File(storageDir, fileName);
                FileOutputStream outputStream = new FileOutputStream(file);
                myBitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStream);
                outputStream.flush();
                outputStream.close();
                values.put(MediaStore.Images.Media.DATA, file.getAbsolutePath());
                context.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
                Toast.makeText(context, "Image saved to gallery", Toast.LENGTH_SHORT).show();

            }
        } catch (IOException e) {
            Toast.makeText(context, "Error saving image to gallery", Toast.LENGTH_SHORT).show();
            e.printStackTrace();
        }
    }

    private void shareQrCode() {
        // Create a new file in the cache directory with a unique name
        File cacheFile = new File(SewaConstants.getDirectoryPath(context, SewaConstants.DIR_LMS_TEMP), fileName);
        try {
            FileOutputStream outputStream = new FileOutputStream(cacheFile);
            bitmapQr.compress(Bitmap.CompressFormat.JPEG, 90, outputStream);
            outputStream.flush();
            outputStream.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Get the content URI for the saved file
        Uri contentUri;
        if (Build.VERSION.SDK_INT >= 24) {
            contentUri = FileProvider.getUriForFile(context, context.getPackageName() + ".provider", cacheFile);
        } else {
            contentUri = Uri.fromFile(cacheFile);
        }
        if (contentUri != null) {
            Intent shareIntent = new Intent();
            shareIntent.setAction(Intent.ACTION_SEND);
            shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION); // temp permission for receiving app to read this file
            shareIntent.setDataAndType(contentUri, context.getContentResolver().getType(contentUri));
            shareIntent.putExtra(Intent.EXTRA_STREAM, contentUri);
            context.startActivity(Intent.createChooser(shareIntent, "Choose an app"));
        }
    }

    public abstract void onButtonClick();

    private Bitmap encodeAsBitmap(@NonNull String str) throws WriterException {
        Log.d("QR string : ", str);
        QRCodeWriter writer = new QRCodeWriter();
        BitMatrix bitMatrix = writer.encode(str, BarcodeFormat.QR_CODE, 800, 800);

        int w = bitMatrix.getWidth();
        int h = bitMatrix.getHeight();
        int[] pixels = new int[w * h];
        for (int y = 0; y < h; y++) {
            for (int x = 0; x < w; x++) {
                pixels[y * w + x] = bitMatrix.get(x, y) ? Color.BLACK : Color.WHITE;
            }
        }
        bitmapQr = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888);
        bitmapQr.setPixels(pixels, 0, w, 0, 0, w, h);
        return bitmapQr;
    }
}
