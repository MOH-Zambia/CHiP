drop table if exists ndhm_hpr_user_token;
create table ndhm_hpr_user_token (
	id serial,
	user_id Integer NOT NULL,
    token text,
	created_by Integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by Integer,
    modified_on timestamp without time zone,
    CONSTRAINT nndhm_hpr_user_token_pkey PRIMARY KEY(id)
);

comment ON TABLE ndhm_hpr_user_token IS 'This table is to store user token details';
comment on column ndhm_hpr_user_token.user_id is 'Id from um_user';
comment on column ndhm_hpr_user_token.token is 'User token';
comment on column ndhm_hpr_user_token.created_by is 'Id from um_user';
comment on column ndhm_hpr_user_token.created_on is 'Created on timestamp';
comment on column ndhm_hpr_user_token.modified_by is 'Id from um_user';
comment on column ndhm_hpr_user_token.modified_on is 'Modified on timestamp';