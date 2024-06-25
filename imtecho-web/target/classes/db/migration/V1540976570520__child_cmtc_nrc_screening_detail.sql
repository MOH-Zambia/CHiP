DROP TABLE IF EXISTS public.child_cmtc_nrc_screening_detail;

CREATE TABLE public.child_cmtc_nrc_screening_detail
(
    id bigserial,
    child_id bigint,
    screened_on timestamp without time zone,
    location_id bigint,
    location_hierarchy_id bigint,
    state text,
    created_on timestamp without time zone,
    created_by bigint,
    modified_on timestamp without time zone,
    modified_by bigint
);

ALTER TABLE public.child_cmtc_nrc_admission_detail
DROP COLUMN IF EXISTS created_on,
ADD COLUMN created_on timestamp without time zone,
DROP COLUMN IF EXISTS created_by,
ADD COLUMN created_by bigint,
DROP COLUMN IF EXISTS modified_on,
ADD COLUMN modified_on timestamp without time zone,
DROP COLUMN IF EXISTS modified_by,
ADD COLUMN modified_by bigint,
DROP COLUMN IF EXISTS state,
ADD COLUMN state text;