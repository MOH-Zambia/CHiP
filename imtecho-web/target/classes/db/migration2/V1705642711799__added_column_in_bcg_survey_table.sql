alter table bcg_vaccination_survey_details
add column if not exists filled_from text,
add column if not exists other_reason text,
add column if not exists bcg_eligible_filled boolean;