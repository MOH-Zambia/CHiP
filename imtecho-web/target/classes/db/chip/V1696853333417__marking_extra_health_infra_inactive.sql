UPDATE listvalue_field_value_detail
SET is_active = false
WHERE value NOT IN ('District hospital', 'Facility') AND field_key = 'infra_type';
