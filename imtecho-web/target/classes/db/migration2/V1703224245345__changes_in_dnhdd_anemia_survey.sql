    ALTER TABLE if exists member_anemia_survey_details
    ADD COLUMN if not exists medicine_given BOOLEAN,
    ADD COLUMN if not exists reason_for_no_medicine text,
    ADD COLUMN if not exists other_reason text;