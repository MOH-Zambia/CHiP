CREATE TABLE IF NOT EXISTS document_module_master
(
  id bigserial PRIMARY KEY  ,
  module_name text NOT NULL UNIQUE,
  base_path text NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);

CREATE TABLE IF NOT EXISTS document_master
(
  id bigserial PRIMARY KEY,
  file_name text NOT NULL UNIQUE,
  file_name_th text NOT NULL UNIQUE,
  extension character varying(255) NOT NULL,
  actual_file_name text NOT NULL,
  is_temporary boolean DEFAULT false,
  module_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);

INSERT INTO document_module_master(
            module_name, base_path, created_by, created_on)
    VALUES ('MYTECHO', 'my_techo',-1 , now());

