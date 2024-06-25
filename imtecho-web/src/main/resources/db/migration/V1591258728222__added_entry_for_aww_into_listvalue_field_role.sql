-- added list values of religions and caste for AWW role

INSERT INTO listvalue_field_role (role_id, field_key)
(
	SELECT urm.id AS role_id, q.field_key AS field_key
		FROM um_role_master urm,
		(VALUES
		    (1000),
		    (1001),
		    (1002),
		    (1006),
		    (1007),
		    (1008),
		    (1009),
		    (1010)
		) q(field_key)
	WHERE urm."name" = 'AWW'
);