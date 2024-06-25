CREATE TABLE IF NOT EXISTS public.system_configuration
(
  system_key character varying(100) NOT NULL,
  is_active boolean,
  key_value character varying(200) NOT NULL,
  CONSTRAINT system_configuration_pkey PRIMARY KEY (system_key)
)