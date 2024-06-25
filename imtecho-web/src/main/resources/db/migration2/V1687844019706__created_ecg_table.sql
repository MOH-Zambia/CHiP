Drop table if exists public.ncd_member_ecg_detail;
CREATE TABLE IF NOT EXISTS public.ncd_member_ecg_detail
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	family_id integer,
	location_id integer,
    service_date timestamp without time zone NOT NULL,
    symptom text,
    other_symptom text,
    detection text,
    ecg_type text,
    recommendation text,
    risk text,
    anomalies text,
    heart_rate integer,
    pr integer,
    qrs integer,
    qt integer,
    qtc float,
    graph_detail_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

Drop table if exists public.ncd_ecg_graph_detail;
CREATE TABLE IF NOT EXISTS public.ncd_ecg_graph_detail
(
    id serial PRIMARY KEY NOT NULL,
    avf_data text,
    avl_data text,
    lead1_data text,
    lead2_data text,
    lead3_data text,
    v1_data text,
    v2_data text,
    v3_data text,
    v4_data text,
    v5_data text,
    v6_data text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);
