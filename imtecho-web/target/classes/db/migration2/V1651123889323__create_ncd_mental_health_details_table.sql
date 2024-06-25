DROP TABLE IF EXISTS public.ncd_member_mental_health_detail;
CREATE TABLE public.ncd_member_mental_health_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    family_id integer,
    location_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    suffering_earlier boolean,
    diagnosis character varying(200),
    currently_under_treatement boolean,
    current_treatment_place character varying(20),
    is_continue_treatment_from_current_place boolean,
    observation character varying(30),
    today_result character varying(20),
    is_suffering boolean,
    flag boolean,
    done_by character varying (200),
    done_on timestamp without time zone
);
