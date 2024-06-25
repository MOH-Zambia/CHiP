ALTER TABLE IF EXISTS conversation_response
ADD COLUMN IF NOT EXISTS transcript_rating int;

ALTER TABLE IF EXISTS conversation_response
ALTER COLUMN differential_diagnosis_rating
TYPE int
USING (differential_diagnosis_rating::integer);

ALTER TABLE IF EXISTS conversation_response
ALTER COLUMN subjective_rating
TYPE int
USING (subjective_rating::integer);

ALTER TABLE IF EXISTS conversation_response
ALTER COLUMN objective_rating
TYPE int
USING (objective_rating::integer);

ALTER TABLE IF EXISTS conversation_response
ALTER COLUMN assessment_rating
TYPE int
USING (assessment_rating::integer);

ALTER TABLE IF EXISTS conversation_response
ALTER COLUMN plan_rating
TYPE int
USING (plan_rating::integer);
