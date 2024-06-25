ALTER TABLE listvalue_field_value_detail
ADD COLUMN IF NOT EXISTS constant VARCHAR(100) UNIQUE;