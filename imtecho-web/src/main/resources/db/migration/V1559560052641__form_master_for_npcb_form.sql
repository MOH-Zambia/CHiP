DELETE FROM query_master WHERE code='move_to_production_npcb_form';
INSERT INTO query_master(created_by, created_on, code,params, query, returns_result_set, state)
values(1, current_date, 'move_to_production_npcb_form', 'userId',
'
select cast(''NPCB'' as text) as form_code, 
false as result
', true, 'ACTIVE');

INSERT into listvalue_form_master 
VALUES ('NPCB', 'NPCB Screening Form', true, true, 'move_to_production_npcb_form');
