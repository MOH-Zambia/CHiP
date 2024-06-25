ALTER TABLE IF EXISTS conversation_response
DROP COLUMN IF EXISTS differential_diagnosis_token_metadata;

ALTER TABLE IF EXISTS conversation_response
DROP COLUMN IF EXISTS soap_notes_token_metadata;

ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS differential_diagnosis_prompt_tokens int;

ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS differential_diagnosis_completion_tokens int;

ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS soap_notes_prompt_tokens int;

ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS soap_notes_completion_tokens int;
