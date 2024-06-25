update menu_config
set feature_json = cast(feature_json as jsonb) || jsonb '{"canLinkHfrFacility":false}'
where navigation_state  = 'techo.manage.healthinfrastructures';