CREATE TABLE if not exists field_constant_master (
    id bigint,
    field_name varchar(255),
    created_on timestamp without time zone,
    created_by bigint,
    modified_on timestamp without time zone,
    modified_by bigint,
    CONSTRAINT field_constant_master_pkey PRIMARY KEY (id)
);

CREATE TABLE if not exists field_value_master (
    id bigint,
    field_name varchar(255),
    field_value varchar(255),
    created_on timestamp without time zone,
    created_by bigint,
    modified_on timestamp without time zone,
    modified_by bigint,
    CONSTRAINT field_value_master_pkey PRIMARY KEY (id)
);