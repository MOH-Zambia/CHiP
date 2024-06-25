alter table ncd_member_ecg_detail
add column if not exists report_pdf_doc_id bigint,
add column if not exists report_image_doc_id bigint,
add column if not exists report_pdf_doc_uuid text,
add column if not exists report_image_doc_uuid text;