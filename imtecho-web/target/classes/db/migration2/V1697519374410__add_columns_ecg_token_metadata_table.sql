alter table ecg_token_metadata
add column if not exists test_failure_point integer,
add column if not exists generated_data_points text,
add column if not exists ecg_position text;