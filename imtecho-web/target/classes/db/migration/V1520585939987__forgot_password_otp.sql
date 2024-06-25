CREATE TABLE if not exists forgot_password_otp
(
  user_id bigint NOT NULL ,
  forgot_password_otp character varying(4) NOT NULL,
  modified_on timestamp without time zone,
  CONSTRAINT forgot_password_otp_pkey PRIMARY KEY (user_id)
);
