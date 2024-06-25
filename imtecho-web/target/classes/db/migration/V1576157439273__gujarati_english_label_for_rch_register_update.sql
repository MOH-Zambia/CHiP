
-- Inserting new keys
insert into internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES
-- English Language
('US', 'Dose_web', 'EN', 'Administrator', now(), false, 'Dose', false),
-- Gujarati Language
('IN', 'Dose_web', 'GU', 'Administrator', now(), false, 'માત્રા', false)
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;
