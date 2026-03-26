package com.argusoft.sewa.android.app.component;

import android.annotation.SuppressLint;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

import com.argusoft.sewa.android.app.datastructure.QueFormBean;
import com.argusoft.sewa.android.app.model.InsightBean;
import com.google.android.material.textview.MaterialTextView;

import java.util.List;

public class AiTextcomponent extends LinearLayout {

    private ProgressBar loader;
    private LinearLayout container;

    public AiTextcomponent(Context context, QueFormBean queFormBean) {
        super(context);

        setOrientation(VERTICAL);
        setLayoutParams(new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        ));
        setPadding(16, 16, 16, 16);

        initLoader(context);
        initContainer(context);

        showLoader();
    }

    private void initLoader(Context context) {
        loader = new ProgressBar(context);

        LayoutParams params = new LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT
        );
        params.gravity = Gravity.CENTER;

        loader.setLayoutParams(params);
        addView(loader);
    }

    private void initContainer(Context context) {
        container = new LinearLayout(context);
        container.setOrientation(VERTICAL);
        container.setVisibility(GONE);

        LayoutParams params = new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        );
        container.setLayoutParams(params);

        addView(container);
    }

    public void showLoader() {
        if (loader != null)
            loader.setVisibility(VISIBLE);
        if (container != null)
            container.setVisibility(GONE);
    }

    public void showError(String msg) {
        if (loader != null)
            loader.setVisibility(GONE);
        if (container != null) {
            container.setVisibility(VISIBLE);
            container.removeAllViews();

            MaterialTextView tv = new MaterialTextView(getContext());
            tv.setText(msg != null ? msg : "Something went wrong");
            tv.setTextColor(Color.RED);
            tv.setPadding(8, 8, 8, 8);

            container.addView(tv);
        }
    }

    public void setInsights(List<InsightBean> insights) {
        if (loader != null) loader.setVisibility(GONE);

        if (container == null) return;

        container.setVisibility(VISIBLE);
        container.removeAllViews();

        if (insights == null || insights.isEmpty()) {
            showError("No insights available");
            return;
        }

        for (InsightBean insight : insights) {
            View card = createInsightCard(insight);
            if (card != null) {
                container.addView(card);
            }
        }
    }

    @SuppressLint("SetTextI18n")
    private View createInsightCard(InsightBean insight) {

        if (insight == null) return null;

        LinearLayout card = new LinearLayout(getContext());
        card.setOrientation(VERTICAL);
        card.setPadding(24, 24, 24, 24);

        LayoutParams params = new LayoutParams(
                LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT
        );
        params.setMargins(0, 0, 0, 20);
        card.setLayoutParams(params);

        card.setBackgroundColor(Color.parseColor("#F5F5F5"));

        MaterialTextView title = new MaterialTextView(getContext());
        title.setText(safe(insight.getTitle()));
        title.setTypeface(null, Typeface.BOLD);
        title.setTextSize(16);
        title.setTextColor(Color.BLACK);

        MaterialTextView desc = new MaterialTextView(getContext());
        desc.setText(safe(insight.getDescription()));
        desc.setTextSize(14);
        desc.setPadding(0, 8, 0, 8);

        MaterialTextView meta = new MaterialTextView(getContext());
        meta.setText("Severity: " + safe(insight.getSeverity()) + " | Program: " + safe(insight.getHealthProgram()));
        meta.setTextSize(12);
        meta.setTextColor(getSeverityColor(insight.getSeverity()));

        card.addView(title);
        card.addView(desc);
        card.addView(meta);

        return card;
    }

    private String safe(String value) {
        return value == null || value.trim().isEmpty() ? "N/A" : value;
    }

    private int getSeverityColor(String severity) {
        if (severity == null) return Color.GRAY;

        switch (severity.toLowerCase()) {
            case "high":
                return Color.RED;
            case "medium":
                return Color.parseColor("#FFA500");
            case "low":
                return Color.parseColor("#2E7D32");
            default:
                return Color.GRAY;
        }
    }

    public void streamOfflineInsight(String text) {
        post(() -> {
            if (loader != null) loader.setVisibility(GONE);
            if (container == null) return;
            container.setVisibility(VISIBLE);

            if (container.getChildCount() == 0) {
                InsightBean dummy = new InsightBean();
                dummy.setTitle("Local AI Insight (Offline)");
                dummy.setDescription(text);
                dummy.setSeverity("Info");
                dummy.setHealthProgram("Local Device");
                container.addView(createInsightCard(dummy));
            } else {
                View card = container.getChildAt(0);
                if (card instanceof LinearLayout) {
                    View desc = ((LinearLayout) card).getChildAt(1);
                    if (desc instanceof MaterialTextView) {
                        ((MaterialTextView) desc).setText(safe(text));
                    }
                }
            }
        });
    }
}