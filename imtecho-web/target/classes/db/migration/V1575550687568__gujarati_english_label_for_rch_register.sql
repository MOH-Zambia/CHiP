
-- English lang labels

insert into internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES
('US', 'Child_web', 'EN', 'Administrator', now(), false, 'Child', false)
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;

-- Gujarati lang labels

insert into internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES
('IN', 'Child_web', 'GU', 'Administrator', now(), false, 'બાળક', false)
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;
