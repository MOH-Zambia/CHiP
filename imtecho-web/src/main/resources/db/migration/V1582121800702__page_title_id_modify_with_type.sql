-- alter table request_response_page_wise_time_details rename column if exists page_title TO page_title_id;

-- ALTER TABLE request_response_page_wise_time_details ALTER COLUMN page_title_id TYPE INT USING (page_title_id::integer);