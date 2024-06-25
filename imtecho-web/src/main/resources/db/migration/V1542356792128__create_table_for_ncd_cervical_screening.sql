DROP TABLE IF EXISTS public.ncd_member_cervical_detail;
CREATE TABLE public.ncd_member_cervical_detail
(
    id bigserial PRIMARY KEY,
    member_id bigint,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    cervical_related_symptoms boolean,
    excessive_bleeding_during_periods boolean,
    bleeding_between_periods boolean,
    bleeding_after_intercourse boolean,
    excessive_smelling_vaginal_discharge boolean,
    postmenopausal_bleeding boolean,
    refferal_done boolean,
    refferal_place text,
    remarks text
);

ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS cervical_screening_done,
ADD COLUMN cervical_screening_done boolean;