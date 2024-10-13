package com.argusoft.sewa.android.app.component;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.pdf.PdfRenderer;
import android.os.ParcelFileDescriptor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.cardview.widget.CardView;
import androidx.core.content.ContextCompat;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.databean.WorkLogScreenDataBean;
import com.argusoft.sewa.android.app.datastructure.SharedStructureData;
import com.argusoft.sewa.android.app.model.UploadFileDataBean;
import com.argusoft.sewa.android.app.util.DynamicUtils;
import com.argusoft.sewa.android.app.util.GlobalTypes;
import com.argusoft.sewa.android.app.util.UtilBean;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author alpeshkyada
 */
public abstract class MyWorkLogAdapter extends BaseAdapter {

    private final Context context;
    private final List<WorkLogScreenDataBean> myLogs;
    private final Map<Integer, View> adapterView;

    public MyWorkLogAdapter(Context context, List<WorkLogScreenDataBean> myLogs) {
        this.context = context;
        this.adapterView = new HashMap<>();
        this.myLogs = myLogs;
    }

    @Override
    public int getCount() {
        if (myLogs != null) {
            return myLogs.size();
        }
        return 0;
    }

    @Override
    public Object getItem(int position) {
        if (myLogs != null) {
            return myLogs.get(position);
        }
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View view = adapterView.get(position);
        if (view == null && myLogs != null && !myLogs.isEmpty()) {
            final WorkLogScreenDataBean log = myLogs.get(position);

            LinearLayout layout = (LinearLayout) LayoutInflater.from(context).inflate(R.layout.worklog_list_view, null);

            LinearLayout llChild = layout.findViewById(R.id.llChild);

            ImageView status = layout.findViewById(R.id.work_log_status_image);
            if (log.getUploadFileDataBean() != null && !log.getUploadFileDataBean().isEmpty()) {
                for (UploadFileDataBean uploadFileDataBean : log.getUploadFileDataBean()) {
                    llChild.addView(addChildView(uploadFileDataBean));
                }
            }

            if (log.getImage() != -1) {
                status.setImageResource(log.getImage());
                status.setVisibility(View.VISIBLE);
            } else {
                status.setVisibility(View.GONE);
            }

            TextView date = layout.findViewById(R.id.work_log_date);
            if (log.getDate() != null) {
                date.setText(log.getDate());
                date.setVisibility(View.VISIBLE);
            } else {
                date.setVisibility(View.GONE);
            }

            TextView name = layout.findViewById(R.id.work_log_name);
            if (log.getName() != null) {
                name.setText(UtilBean.getMyLabel(log.getName()));
                name.setVisibility(View.VISIBLE);
            } else {
                name.setVisibility(View.GONE);
            }

            TextView task = layout.findViewById(R.id.work_log_task);
            if (log.getTask() != null) {
                task.setText(UtilBean.getMyLabel(log.getTask()));
                task.setVisibility(View.VISIBLE);
            } else {
                task.setVisibility(View.GONE);
            }

            final View.OnClickListener listener = v -> {
                if (SharedStructureData.workLogAlert != null) {
                    SharedStructureData.workLogAlert.dismiss();
                }
            };

            ImageView info = layout.findViewById(R.id.work_log_info);
            if (log.getMessage() != null) {
                info.setVisibility(View.VISIBLE);
                layout.setOnClickListener(v -> {
                    SharedStructureData.workLogAlert = new MyAlertDialog(context,
                            log.getMessage(), listener, DynamicUtils.BUTTON_OK);
                    SharedStructureData.workLogAlert.show();
                });
            } else {
                info.setVisibility(View.GONE);
            }

            adapterView.put(position, layout);
            return layout;
        }
        return view;
    }

    private CardView addChildView(UploadFileDataBean uploadFileDataBean) {
        CardView layout = (CardView) LayoutInflater.from(context).inflate(R.layout.worklog_list_child_view, null);
        ImageView status = layout.findViewById(R.id.work_log_file_status_image);
        ImageView btnRetry = layout.findViewById(R.id.work_log_file_retry);
        TextView btnStatus = layout.findViewById(R.id.work_log_status);

        if (uploadFileDataBean.getFileType() != null && uploadFileDataBean.getFileType().contains("image")) {
            status.setImageResource(R.drawable.ic_image);
        } else if (uploadFileDataBean.getFileType() != null && uploadFileDataBean.getFileType().contains("pdf")) {
            status.setImageResource(R.drawable.ic_pdf);
        } else {
            status.setImageResource(R.drawable.ic_pdf);
        }
        status.setImageTintList(ContextCompat.getColorStateList(context, R.color.colorPrimary));

        if (uploadFileDataBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_PENDING) ||
                uploadFileDataBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_ERROR)) {
            try {
                File imgFile = new File(uploadFileDataBean.getFilePath());
                if (imgFile.exists()) {
                    if (uploadFileDataBean.getFileType() != null && uploadFileDataBean.getFileType().contains("image")) {
                        Bitmap myBitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
                        status.setImageBitmap(myBitmap);
                        status.setImageTintList(null);
                    } else if (uploadFileDataBean.getFileType() != null && uploadFileDataBean.getFileType().contains("pdf")) {
                        ParcelFileDescriptor fileDescriptor = ParcelFileDescriptor.open(imgFile, ParcelFileDescriptor.MODE_READ_ONLY);
                        PdfRenderer pdfRenderer = new PdfRenderer(fileDescriptor);
                        PdfRenderer.Page pdfPage = pdfRenderer.openPage(0);
                        Bitmap bitmap = Bitmap.createBitmap(pdfPage.getWidth(), pdfPage.getHeight(), Bitmap.Config.ARGB_8888);
                        pdfPage.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
                        pdfPage.close();
                        pdfRenderer.close();
                        fileDescriptor.close();

                        status.setImageBitmap(bitmap);
                        status.setImageTintList(null);

                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (uploadFileDataBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_SUCCESS)) {
            btnStatus.setText("Synced");
            btnStatus.setBackgroundColor(ContextCompat.getColor(context, R.color.colorAccent));
            btnStatus.setOnClickListener(null);
        } else if ((uploadFileDataBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_PENDING) ||
                uploadFileDataBean.getStatus().equalsIgnoreCase(GlobalTypes.STATUS_ERROR)) &&
                uploadFileDataBean.getParentStatus().equalsIgnoreCase(GlobalTypes.STATUS_SUCCESS)) {
            btnStatus.setText("Retry");
            btnStatus.setOnClickListener(v -> {
                retryUploading(uploadFileDataBean);
                notifyDataSetChanged();
            });
            btnStatus.setBackgroundColor(ContextCompat.getColor(context, R.color.colorPrimary));
        } else {
            btnStatus.setText("Pending");
            btnStatus.setOnClickListener(null);
            btnStatus.setBackgroundColor(ContextCompat.getColor(context, R.color.colorPrimary));
        }

        TextView date = layout.findViewById(R.id.work_log_file_date);
        if (uploadFileDataBean.getFileName() != null) {
            if (uploadFileDataBean.getFileType() != null) {
                if (uploadFileDataBean.getFileType().equalsIgnoreCase("image/png")) {
                    date.setText(uploadFileDataBean.getFileName().concat(".png"));
                } else if (uploadFileDataBean.getFileType().equalsIgnoreCase("image/jpeg")) {
                    date.setText(uploadFileDataBean.getFileName().concat(".jpeg"));
                } else if (uploadFileDataBean.getFileType().equalsIgnoreCase("image/jpg")) {
                    date.setText(uploadFileDataBean.getFileName().concat(".jpg"));
                } else if (uploadFileDataBean.getFileType().equalsIgnoreCase("application/pdf")) {
                    date.setText(uploadFileDataBean.getFileName().concat(".pdf"));
                } else {
                    date.setText(uploadFileDataBean.getFileName());
                }
            } else {
                date.setText(uploadFileDataBean.getFileName());
            }
            date.setVisibility(View.VISIBLE);
        } else {
            date.setVisibility(View.GONE);
        }

        return layout;
    }

    public abstract void retryUploading(UploadFileDataBean bean);
}
