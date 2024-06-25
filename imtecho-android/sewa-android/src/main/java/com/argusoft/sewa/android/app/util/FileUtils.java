package com.argusoft.sewa.android.app.util;

import android.annotation.SuppressLint;
import android.content.ContentUris;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.webkit.MimeTypeMap;

import com.argusoft.sewa.android.app.datastructure.SharedStructureData;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class FileUtils {

    private static final FileUtils ourInstance = new FileUtils();
    private static Uri contentUri = null;
    private static final String IMAGE = "image";
    private static final String AUDIO = "audio";
    private static final String VIDEO = "video";
    private static final String PDF = "PDF";



    public static FileUtils getInstance() {
        return ourInstance;
    }

    @SuppressLint("NewApi")
    public String getPath(Context context, Uri uri) {
        try {

            // check here to KITKAT or new version
            final boolean isKitKat = Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT;
            String selection = null;
            String[] selectionArgs = null;
            // DocumentProvider
            if (isKitKat) {
                // ExternalStorageProvider

                if (isExternalStorageDocument(uri)) {
                    final String docId = DocumentsContract.getDocumentId(uri);
                    final String[] split = docId.split(":");
                    final String type = split[0];

                    String fullPath = getPathFromExtSD(split);
                    if (fullPath != "") {
                        return fullPath;
                    } else {
                        return null;
                    }
                }


                // DownloadsProvider

                if (isDownloadsDocument(uri)) {

                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        final String id;
                        Cursor cursor = null;
                        try {
                            cursor = context.getContentResolver().query(uri, new String[]{MediaStore.MediaColumns.DISPLAY_NAME}, null, null, null);
                            if (cursor != null && cursor.moveToFirst()) {
                                String fileName = cursor.getString(0);
                                String path = Environment.getExternalStorageDirectory().toString() + "/Download/" + fileName;
                                if (!TextUtils.isEmpty(path)) {
                                    return path;
                                }
                            }
                        } finally {
                            if (cursor != null)
                                cursor.close();
                        }
                        id = DocumentsContract.getDocumentId(uri);
                        if (!TextUtils.isEmpty(id)) {
                            if (id.startsWith("raw:")) {
                                return id.replaceFirst("raw:", "");
                            }
                            String[] contentUriPrefixesToTry = new String[]{
                                    "content://downloads/public_downloads",
                                    "content://downloads/my_downloads"
                            };
                            for (String contentUriPrefix : contentUriPrefixesToTry) {
                                try {
                                    final Uri contentUri = ContentUris.withAppendedId(Uri.parse(contentUriPrefix), Long.valueOf(id));


                                    return getDataColumn(context, contentUri, null, null);
                                } catch (NumberFormatException e) {
                                    //In Android 8 and Android P the id is not a number
                                    return uri.getPath().replaceFirst("^/document/raw:", "").replaceFirst("^raw:", "");
                                }
                            }


                        }
                    } else {
                        final String id = DocumentsContract.getDocumentId(uri);

                        if (id.startsWith("raw:")) {
                            return id.replaceFirst("raw:", "");
                        }
                        try {
                            contentUri = ContentUris.withAppendedId(
                                    Uri.parse("content://downloads/public_downloads"), Long.valueOf(id));
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                        if (contentUri != null) {

                            return getDataColumn(context, contentUri, null, null);
                        }
                    }
                }


                // MediaProvider
                if (isMediaDocument(uri)) {
                    final String docId = DocumentsContract.getDocumentId(uri);
                    final String[] split = docId.split(":");
                    final String type = split[0];

                    Uri contentUri = null;

                    if ("image".equals(type)) {
                        contentUri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                    } else if ("video".equals(type)) {
                        contentUri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                    } else if ("audio".equals(type)) {
                        contentUri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                    }

                    selection = "_id=?";
                    selectionArgs = new String[]{split[1]};


                    return getDataColumn(context, contentUri, selection,
                            selectionArgs);
                }

                if (isGoogleDriveUri(uri)) {
                    return getDriveFilePath(context, uri);
                }

                if (isWhatsAppFile(uri)) {
                    return getFilePathForWhatsApp(context, uri);
                }


                if ("content".equalsIgnoreCase(uri.getScheme())) {

                    if (isGooglePhotosUri(uri)) {
                        return uri.getLastPathSegment();
                    }
                    if (isGoogleDriveUri(uri)) {
                        return getDriveFilePath(context, uri);
                    }
               /* if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {

                    // return getFilePathFromURI(context,uri);
                    return copyFileToInternalStorage(context, uri, "userfiles");
                    // return getRealPathFromURI(context,uri);
                } else {*/
                    return getDataColumn(context, uri, null, null);
//                }

                }
                if ("file".equalsIgnoreCase(uri.getScheme())) {
                    return uri.getPath();
                }
            } else {

                if (isWhatsAppFile(uri)) {
                    return getFilePathForWhatsApp(context, uri);
                }

                if ("content".equalsIgnoreCase(uri.getScheme())) {
                    String[] projection = {
                            MediaStore.Images.Media.DATA
                    };
                    Cursor cursor = null;
                    try {
                        cursor = context.getContentResolver()
                                .query(uri, projection, selection, selectionArgs, null);
                        int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
                        if (cursor.moveToFirst()) {
                            return cursor.getString(column_index);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

        } catch (Exception e) {
            Log.e("Error: ", "" + e.getMessage());
            return copyFileToInternalStorage(context, uri, Environment.DIRECTORY_DOWNLOADS);
        }
        return null;
    }

    private boolean fileExists(String filePath) {
        File file = new File(filePath);

        return file.exists();
    }

    private String getPathFromExtSD(String[] pathData) {
        final String type = pathData[0];
        final String relativePath = "/" + pathData[1];
        String fullPath = "";

        // on my Sony devices (4.4.4 & 5.1.1), `type` is a dynamic string
        // something like "71F8-2C0A", some kind of unique id per storage
        // don't know any API that can get the root path of that storage based on its id.
        //
        // so no "primary" type, but let the check here for other devices
        if ("primary".equalsIgnoreCase(type)) {
            fullPath = Environment.getExternalStorageDirectory() + relativePath;
            if (fileExists(fullPath)) {
                return fullPath;
            }
        }

        // Environment.isExternalStorageRemovable() is `true` for external and internal storage
        // so we cannot relay on it.
        //
        // instead, for each possible path, check if file exists
        // we'll start with secondary storage as this could be our (physically) removable sd card
        fullPath = System.getenv("SECONDARY_STORAGE") + relativePath;
        if (fileExists(fullPath)) {
            return fullPath;
        }

        fullPath = System.getenv("EXTERNAL_STORAGE") + relativePath;
        if (fileExists(fullPath)) {
            return fullPath;
        }

        return fullPath;
    }

    private String getDriveFilePath(Context context, Uri uri) {
        Uri returnUri = uri;
        Cursor returnCursor = context.getContentResolver().query(returnUri, null, null, null, null);
        /*
         * Get the column indexes of the data in the Cursor,
         *     * move to the first row in the Cursor, get the data,
         *     * and display it.
         * */
        int nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
        int sizeIndex = returnCursor.getColumnIndex(OpenableColumns.SIZE);
        returnCursor.moveToFirst();
        String name = (returnCursor.getString(nameIndex));
        String size = (Long.toString(returnCursor.getLong(sizeIndex)));
        File file = new File(context.getCacheDir(), name);
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            FileOutputStream outputStream = new FileOutputStream(file);
            int read = 0;
            int maxBufferSize = 1 * 1024 * 1024;
            int bytesAvailable = inputStream.available();

            //int bufferSize = 1024;
            int bufferSize = Math.min(bytesAvailable, maxBufferSize);

            final byte[] buffers = new byte[bufferSize];
            while ((read = inputStream.read(buffers)) != -1) {
                outputStream.write(buffers, 0, read);
            }
            Log.e("File Size", "Size " + file.length());
            inputStream.close();
            outputStream.close();
            Log.e("File Path", "Path " + file.getPath());
            Log.e("File Size", "Size " + file.length());
        } catch (Exception e) {
            Log.e("Exception", e.getMessage());
        }
        return file.getPath();
    }

    /***
     * Used for Android Q+
     * @param uri
     * @param newDirName if you want to create a directory, you can set this variable
     * @return
     */
    private String copyFileToInternalStorage(Context context, Uri uri, String newDirName) {
        Uri returnUri = uri;

        Cursor returnCursor = context.getContentResolver().query(returnUri, new String[]{
                OpenableColumns.DISPLAY_NAME, OpenableColumns.SIZE
        }, null, null, null);


        /*
         * Get the column indexes of the data in the Cursor,
         *     * move to the first row in the Cursor, get the data,
         *     * and display it.
         * */
        int nameIndex = returnCursor.getColumnIndex(OpenableColumns.DISPLAY_NAME);
        int sizeIndex = returnCursor.getColumnIndex(OpenableColumns.SIZE);
        returnCursor.moveToFirst();
        String name = (returnCursor.getString(nameIndex));
        String size = (Long.toString(returnCursor.getLong(sizeIndex)));

        File output;
        if (!newDirName.equals("")) {
            File dir = new File(context.getFilesDir() + "/" + newDirName);
            if (!dir.exists()) {
                dir.mkdir();
            }
            output = new File(context.getFilesDir() + "/" + newDirName + "/" + name);
        } else {
            output = new File(context.getFilesDir() + "/" + name);
        }
        try {
            InputStream inputStream = context.getContentResolver().openInputStream(uri);
            FileOutputStream outputStream = new FileOutputStream(output);
            int read = 0;
            int bufferSize = 1024;
            final byte[] buffers = new byte[bufferSize];
            while ((read = inputStream.read(buffers)) != -1) {
                outputStream.write(buffers, 0, read);
            }

            inputStream.close();
            outputStream.close();

        } catch (Exception e) {

            Log.e("Exception", e.getMessage());
        }

        return output.getPath();
    }

    private String getFilePathForWhatsApp(Context context, Uri uri) {
        return copyFileToInternalStorage(context, uri, Environment.DIRECTORY_DOWNLOADS);
    }

    private String getDataColumn(Context context, Uri uri, String selection, String[] selectionArgs) {
        Cursor cursor = null;
        final String column = "_data";
        final String[] projection = {column};

        try {
            cursor = context.getContentResolver().query(uri, projection,
                    selection, selectionArgs, null);

            if (cursor != null && cursor.moveToFirst()) {
                final int index = cursor.getColumnIndexOrThrow(column);
                return cursor.getString(index);
            }
        } finally {
            if (cursor != null)
                cursor.close();
        }

        return null;
    }

    private boolean isExternalStorageDocument(Uri uri) {
        return "com.android.externalstorage.documents".equals(uri.getAuthority());
    }

    private boolean isDownloadsDocument(Uri uri) {
        return "com.android.providers.downloads.documents".equals(uri.getAuthority());
    }

    private boolean isMediaDocument(Uri uri) {
        return "com.android.providers.media.documents".equals(uri.getAuthority());
    }

    private boolean isGooglePhotosUri(Uri uri) {
        return "com.google.android.apps.photos.content".equals(uri.getAuthority());
    }

    public boolean isWhatsAppFile(Uri uri) {
        return "com.whatsapp.provider.media".equals(uri.getAuthority());
    }

    private boolean isGoogleDriveUri(Uri uri) {
        return "com.google.android.apps.docs.storage".equals(uri.getAuthority()) || "com.google.android.apps.docs.storage.legacy".equals(uri.getAuthority());
    }

    public String getMimeType(String url) {
        String type = null;
        String extension = MimeTypeMap.getFileExtensionFromUrl(url);
        if (extension != null) {
            type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
        }
        return type;
    }

    public String convertBitmapToFile(Bitmap bitmap, String path) {
        File file = new File(path);
        try {
            file.createNewFile();
            ByteArrayOutputStream bos = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100 /*ignored for PNG*/, bos);
            byte[] bitmapData = bos.toByteArray();
            FileOutputStream fos = new FileOutputStream(file);
            fos.write(bitmapData);
            fos.flush();
            fos.close();
            return file.getAbsolutePath();
        } catch (IOException e) {
            e.printStackTrace();
            SharedStructureData.sewaService.storeException(e, GlobalTypes.EXCEPTION_TYPE_CAMERA);
            return null;
        }
    }

    public void removeFile(String filePath) {
        File file = new File(filePath);
        file.deleteOnExit();
    }

    public String convertBase64(String filePath) {
        Bitmap bitmap = BitmapFactory.decodeFile(filePath);
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteArrayOutputStream);
        byte[] byteArrayImage = byteArrayOutputStream.toByteArray();
        return Base64.encodeToString(byteArrayImage, Base64.NO_WRAP);
    }

    public String convertAnyFileToBase64(Context context, String filePath, String fileType) {
        if (filePath != null && fileType != null) {
            switch (fileType) {
                case IMAGE:
                case VIDEO:
                    File imageFile = new File(filePath);
                    FileInputStream imageFileInputStream = null;
                    byte[] imageBytes;
                    try {
                        imageFileInputStream = new FileInputStream(imageFile);
                        imageBytes = new byte[(int) imageFile.length()];
                        imageFileInputStream.read(imageBytes);
                        return Base64.encodeToString(imageBytes, Base64.NO_WRAP);
                    } catch (IOException e) {
                        e.printStackTrace();
                        return null;
                    }
                case AUDIO:
                    try {
                        FileInputStream fileInputStream = null;
                        fileInputStream = new FileInputStream(filePath);
                        ByteArrayOutputStream byteArrayAudioOutputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                            byteArrayAudioOutputStream.write(buffer, 0, bytesRead);
                        }
                        byte[] byteArray = byteArrayAudioOutputStream.toByteArray();
                        return Base64.encodeToString(byteArray, Base64.NO_WRAP);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                case PDF:
                    try {
                        FileInputStream fileInputStream = new FileInputStream(filePath);
                        ByteArrayOutputStream byteArrayPdfOutputStream = new ByteArrayOutputStream();
                        byte[] buffer = new byte[1024];
                        int bytesRead;
                        while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                            byteArrayPdfOutputStream.write(buffer, 0, bytesRead);
                        }
                        byte[] byteArray = byteArrayPdfOutputStream.toByteArray();
                        return Base64.encodeToString(byteArray, Base64.NO_WRAP);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    break;
                default:
            }
        }
        return null;
    }

    public static String getFileTypeFromPath(String filePath) {
        if (filePath != null) {
            String[] extension = filePath.split("\\.");
            switch (extension[extension.length-1]) {
                case "jpg":
                case "png":
                    return "image";
                case "mp3":
                case "amr":
                    return "audio";
                case "mp4":
                case "3gp":
                    return "video";
                case "pdf":
                    return "pdf";
                default:
                    return extension[extension.length-1];
            }
        }
        return null;
    }

    public static String getFileNameFromPath(String filePath) {
        if (filePath != null) {
            String[] name = filePath.split("/");
            return name[name.length-1];
        }
        return null;
    }
}
