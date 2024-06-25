UPDATE menu_config
SET feature_json = '{"canDrillDown":true}'
WHERE is_dynamic_report = true;