package com.argusoft.sewa.android.app.component;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.argusoft.sewa.android.app.R;
import com.argusoft.sewa.android.app.util.FileUtils;
import com.argusoft.sewa.android.app.util.SewaConstants;

import java.util.ArrayList;
import java.util.List;

public class ImageGridLayoutAdapter extends RecyclerView.Adapter<ImageGridLayoutAdapter.ViewHolder> {
    private final List<String> imagePath;
    private final List<String> uniqueIdList;

    private final View.OnClickListener onClickListener;
    private int imageLength = 0;
    private Context context;

    public ImageGridLayoutAdapter(List<String> imagePath, Context context, int imageLength, View.OnClickListener onClickListener) {
        this.imagePath = imagePath;
        this.uniqueIdList = new ArrayList<>();
        this.onClickListener = onClickListener;
        this.imageLength = imageLength;
        this.context = context;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_image_view, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
        String path = imagePath.get(position);
        holder.imageView.setTag(path);
        if (path != null) {
            Bitmap bitmap = BitmapFactory.decodeFile(SewaConstants.getDirectoryPath(holder.imageView.getContext(), SewaConstants.DIR_IMAGE) + path);
            holder.imageView.setImageBitmap(bitmap);
            holder.imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            holder.closeImageView.setVisibility(View.VISIBLE);
        } else {
            holder.imageView.setImageResource(R.drawable.camera);
            holder.imageView.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
            holder.closeImageView.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return imagePath.size();
    }

    public void addImage(String uniqueId,String path) {
        uniqueIdList.add(uniqueId);
        imagePath.add(getItemCount() - 1, path);
        if (imagePath.size() > imageLength) {
            imagePath.remove(null);
        }
        notifyDataSetChanged();
    }

    public String getUniqueIdList(){
        return TextUtils.join(",", uniqueIdList);
    }

    public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener {
        ImageView imageView, closeImageView;

        public ViewHolder(@NonNull View itemView) {
            super(itemView);
            imageView = itemView.findViewById(R.id.imageView);
            closeImageView = itemView.findViewById(R.id.closeImageView);
            imageView.setOnClickListener(this);
            closeImageView.setOnClickListener(this);
        }

        @Override
        public void onClick(View v) {
            if (v.getId() == R.id.imageView) {
                String path = (String) v.getTag();
                if (path == null && imagePath.size() <= imageLength) {
                    onClickListener.onClick(v);
                }
            } else if (v.getId() == R.id.closeImageView) {
                FileUtils.getInstance().removeFile(imagePath.get(getAdapterPosition()));
                imagePath.remove(getAdapterPosition());
                uniqueIdList.remove(getAdapterPosition());
                if (imagePath.size() <= imageLength) {
                    if (imagePath.get(imagePath.size() - 1) != null) {
                        imagePath.add(null);
                    }
                }
                v.setTag(getUniqueIdList());
                onClickListener.onClick(v);
                notifyDataSetChanged();
            }
        }
    }
}
