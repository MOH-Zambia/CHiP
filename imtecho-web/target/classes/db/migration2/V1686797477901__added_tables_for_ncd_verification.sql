CREATE TABLE IF NOT EXISTS gvk_ncd_screening_verification_info
(
    id serial NOT NULL,
    family_id text NOT NULL,
    schedule_date timestamp without time zone NOT NULL,
    call_attempt integer NOT NULL,
    gvk_call_status text NOT NULL,
    created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer NOT NULL,
    modified_on timestamp without time zone NOT NULL,
    CONSTRAINT gvk_ncd_screening_verification_info_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS gvk_ncd_screening_verification_response
(
    id serial NOT NULL,
    manage_call_master_id integer NOT NULL,
    request_id integer NOT NULL,
    gvk_call_response_status text NOT NULL,
    created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer NOT NULL,
    modified_on timestamp without time zone NOT NULL,
	is_family_screened boolean,
    member_json text,
    CONSTRAINT gvk_ncd_screening_verification_response_pkey PRIMARY KEY (id)
);
