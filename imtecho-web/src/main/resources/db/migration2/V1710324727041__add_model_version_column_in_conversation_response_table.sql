ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS model_version varchar(20);