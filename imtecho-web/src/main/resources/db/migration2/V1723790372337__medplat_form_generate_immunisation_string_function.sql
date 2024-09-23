CREATE OR REPLACE FUNCTION generate_immunisations_for_form_configurator(immunisations text)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
        BEGIN
		return (
				SELECT string_agg((value->>'immunisation') || '#' || to_char((value->>'givenOn')::timestamp AT TIME ZONE 'UTC', 'DD/MM/YYYY') , ',') AS immunization_string
				FROM jsonb_array_elements(immunisations::jsonb) AS elem(value)
			);
        END;
$function$
;