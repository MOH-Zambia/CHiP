
-- Inserting new keys
insert into internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES
-- English Language
('US', 'ReproductiveChildHealthCareRegister_web', 'EN', 'Administrator', now(), false, 'Reproductive Child Health Care Register', false),
('US', 'MotherService_web', 'EN', 'Administrator', now(), false, 'Mother Service', false),
('US', 'ChildService_web', 'EN', 'Administrator', now(), false, 'Child Service', false),
('US', 'EligibleCoupleService_web', 'EN', 'Administrator', now(), false, 'Eligible Couple Service', false),
('US', 'SEARCHPARAMETERS_web', 'EN', 'Administrator', now(), false, 'SEARCH PARAMETERS', false),
('US', 'DateRange_web', 'EN', 'Administrator', now(), false, 'Date Range', false),
('US', 'Location_web', 'EN', 'Administrator', now(), false, 'Location', false),
-- Gujarati Language
('IN', 'ReproductiveChildHealthCareRegister_web', 'GU', 'Administrator', now(), false, 'પ્રજનનકારી બાળ આરોગ્ય સંભાળ રજિસ્ટર', false),
('IN', 'MotherService_web', 'GU', 'Administrator', now(), false, 'માતાની સેવા', false),
('IN', 'ChildService_web', 'GU', 'Administrator', now(), false, 'બાળ સેવા', false),
('IN', 'EligibleCoupleService_web', 'GU', 'Administrator', now(), false, 'પાત્ર દંપતી સેવા', false),
('IN', 'SEARCHPARAMETERS_web', 'GU', 'Administrator', now(), false, 'શોધ પરિમાણો', false),
('IN', 'DateRange_web', 'GU', 'Administrator', now(), false, 'તારીખ રેંજ', false),
('IN', 'Location_web', 'GU', 'Administrator', now(), false, 'સ્થાન', false)
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;
