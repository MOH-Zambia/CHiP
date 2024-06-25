CREATE TABLE IF NOT EXISTS drtecho_user_documents
(
  id bigserial PRIMARY KEY,
  user_id bigint,
  document_id bigint,
  document_type_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone
);

INSERT INTO document_module_master(module_name, base_path, created_by, created_on, modified_by, modified_on)
    SELECT 'DRTECHO', 'dr_techo', -1, NOW(), -1, NOW()
    WHERE NOT EXISTS (SELECT 1 FROM document_module_master WHERE module_name='DRTECHO');


