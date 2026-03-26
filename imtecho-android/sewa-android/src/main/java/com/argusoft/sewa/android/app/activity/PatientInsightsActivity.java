//package com.argusoft.sewa.android.app.activity;
//
//import android.content.Intent;
//import android.graphics.Color;
//import android.os.Bundle;
//import android.view.LayoutInflater;
//import android.view.View;
//import android.view.ViewGroup;
//import android.widget.Button;
//import android.widget.ProgressBar;
//import android.widget.TextView;
//
//import androidx.annotation.NonNull;
//import androidx.appcompat.app.AppCompatActivity;
//import androidx.appcompat.widget.Toolbar;
//import androidx.recyclerview.widget.LinearLayoutManager;
//import androidx.recyclerview.widget.RecyclerView;
//
//import com.argusoft.sewa.android.app.R;
//import com.argusoft.sewa.android.app.core.impl.SewaServiceRestClientImpl;
//import com.argusoft.sewa.android.app.model.InsightBean;
//
//import org.androidannotations.annotations.Background;
//import org.androidannotations.annotations.Bean;
//import org.androidannotations.annotations.EActivity;
//import org.androidannotations.annotations.UiThread;
//
//import java.util.List;
//
//@EActivity
//public class PatientInsightsActivity extends AppCompatActivity {
//
//    ProgressBar progressBar;
//    TextView tvError;
//    RecyclerView rvInsights;
//    Button btnProceed;
//    Toolbar toolbar;
//
//    @Bean
//    SewaServiceRestClientImpl restClient;
//
//    private String memberId;
//    private String formType;
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_patient_insights);
//
//        progressBar = findViewById(R.id.progressBar);
//        tvError = findViewById(R.id.tvError);
//        rvInsights = findViewById(R.id.rvInsights);
//        btnProceed = findViewById(R.id.btnProceed);
//        toolbar = findViewById(R.id.toolbar);
//
//        setSupportActionBar(toolbar);
//        if (getSupportActionBar() != null) {
//            getSupportActionBar().setDisplayHomeAsUpEnabled(true);
//            getSupportActionBar().setDisplayShowHomeEnabled(true);
//        }
//        toolbar.setNavigationOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                onBackPressed();
//            }
//        });
//
//        // Intent params
//        memberId = getIntent().getStringExtra("memberId");
//        formType = getIntent().getStringExtra("formType");
//
//        rvInsights.setLayoutManager(new LinearLayoutManager(this));
//
//        btnProceed.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                setResult(RESULT_OK, new Intent());
//                finish();
//            }
//        });
//
//        loadInsights();
//    }
//
//    @Background
//    protected void loadInsights() {
//        try {
//            List<InsightBean> insights = restClient.getPatientInsights(memberId, formType);
//            onInsightsLoaded(insights);
//        } catch (Exception e) {
//            onInsightsFailed();
//        }
//    }
//
//    @UiThread
//    protected void onInsightsLoaded(List<InsightBean> insights) {
//        progressBar.setVisibility(View.GONE);
//        if (insights == null || insights.isEmpty()) {
//            tvError.setVisibility(View.VISIBLE);
//            tvError.setText("No insights available for this patient.");
//        } else {
//            rvInsights.setAdapter(new InsightsAdapter(insights));
//        }
//    }
//
//    @UiThread
//    protected void onInsightsFailed() {
//        progressBar.setVisibility(View.GONE);
//        tvError.setVisibility(View.VISIBLE);
//        tvError.setText("Failed to load clinical insights. Please try again.");
//    }
//
//    // Inner Adapter Class
//    private static class InsightsAdapter extends RecyclerView.Adapter<InsightsAdapter.ViewHolder> {
//        private final List<InsightBean> insights;
//
//        public InsightsAdapter(List<InsightBean> insights) {
//            this.insights = insights;
//        }
//
//        @NonNull
//        @Override
//        public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
//            View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_insight_card, parent, false);
//            return new ViewHolder(view);
//        }
//
//        @Override
//        public void onBindViewHolder(@NonNull ViewHolder holder, int position) {
//            InsightBean insight = insights.get(position);
//            holder.tvTitle.setText(insight.getTitle() != null ? insight.getTitle() : "Insight");
//            holder.tvDesc.setText(insight.getDescription() != null ? insight.getDescription() : "");
//            holder.tvProgram.setText(insight.getHealthProgram() != null ? insight.getHealthProgram() : "");
//            holder.tvProgram.setText(insight.getActionLabel() != null ? insight.getActionLabel() : "");
//
//            String severity = insight.getSeverity() != null ? insight.getSeverity().toLowerCase() : "low";
//            holder.tvSeverity.setText(severity.toUpperCase());
//
//            switch (severity) {
//                case "high":
//                    holder.tvSeverity.setBackgroundColor(Color.parseColor("#E53935")); // Red
//                    break;
//                case "medium":
//                    holder.tvSeverity.setBackgroundColor(Color.parseColor("#FB8C00")); // Orange
//                    break;
//                case "low":
//                default:
//                    holder.tvSeverity.setBackgroundColor(Color.parseColor("#43A047")); // Green
//                    break;
//            }
//        }
//
//        @Override
//        public int getItemCount() {
//            return insights == null ? 0 : insights.size();
//        }
//
//        static class ViewHolder extends RecyclerView.ViewHolder {
//            TextView tvTitle, tvDesc, tvSeverity, tvProgram;
//
//            public ViewHolder(@NonNull View itemView) {
//                super(itemView);
//                tvTitle = itemView.findViewById(R.id.tvInsightTitle);
//                tvDesc = itemView.findViewById(R.id.tvInsightDescription);
//                tvSeverity = itemView.findViewById(R.id.tvSeverity);
//                tvProgram = itemView.findViewById(R.id.tvProgram);
//            }
//        }
//    }
//}
