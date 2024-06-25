CREATE TABLE IF NOT EXISTS drtecho_health_infrastructure_documents
(
  id bigserial PRIMARY KEY,
  health_infrastructure_id bigint,
  document_id bigint,
  document_type_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);