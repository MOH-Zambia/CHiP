-- DROP TABLE IF EXISTS document_index;
 
CREATE TABLE document_index
(
  id bigserial NOT NULL PRIMARY KEY,
  json text NOT NULL,
  type text NOT NULL,
  is_index boolean DEFAULT false,
  created_on timestamp without time zone NOT NULL,
  created_by bigint NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone 
);

INSERT INTO system_configuration(system_key, is_active, key_value) VALUES ('FAQ_ELASTIC_PORT', true, 9200);

INSERT INTO system_configuration(system_key, is_active, key_value) VALUES ('FAQ_ELASTIC_HOST', true, 'localhost');

INSERT INTO system_configuration(system_key, is_active, key_value) VALUES ('IS_FAQ_ELASTIC_SEARCH_ENABLE', true, true);

