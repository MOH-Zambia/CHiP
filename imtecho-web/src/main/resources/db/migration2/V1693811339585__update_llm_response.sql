ALTER TABLE llm_responses
    ALTER COLUMN temperature TYPE DOUBLE PRECISION USING temperature::double precision,
    ALTER COLUMN top_p TYPE DOUBLE PRECISION USING temperature::double precision;