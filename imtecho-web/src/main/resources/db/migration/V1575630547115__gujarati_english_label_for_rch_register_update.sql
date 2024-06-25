-- English
update internationalization_label_master SET key = 'BloodPressure(mmHg)_web', text = 'Blood Pressure (mmHg)' where country='US' and key ='BloodPressure(High/LowmmHg)_web' and language='EN';
update internationalization_label_master SET key = 'IsMotherAlive_web', text = 'Is Mother Alive' where country='US' and key ='IsMotherDead_web' and language='EN';
update internationalization_label_master SET key = 'DeliveryConductedBy_web', text = 'Delivery Conducted By' where country='US' and key ='DeliveryDoneBy_web' and language='EN';

-- Gujarati
update internationalization_label_master SET key = 'BloodPressure(mmHg)_web', text = 'Blood Pressure (mmHg)' where country='IN' and key ='BloodPressure(High/LowmmHg)_web' and language='GU';
update internationalization_label_master SET key = 'IsMotherAlive_web', text = 'મધર હયાત છે' where country='IN' and key ='IsMotherDead_web' and language='GU';
update internationalization_label_master SET key = 'DeliveryConductedBy_web' where country='IN' and key ='DeliveryDoneBy_web' and language='GU';

-- Inserting new keys
insert into internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES
-- English Language
('US', 'Measles1/MeaslesRubella1_web', 'EN', 'Administrator', now(), false, 'Measles 1/Measles Rubella 1', false),
('US', 'Measles2/MeaslesRubella2_web', 'EN', 'Administrator', now(), false, 'Measles 2/Measles Rubella 2', false),
('US', 'PlaceNameofDelivery_web', 'EN', 'Administrator', now(), false, 'Place Name of Delivery', false),
('US', 'PlaceTypeofDelivery_web', 'EN', 'Administrator', now(), false, 'Place Type of Delivery', false),
('US', 'PregnancyWeekNumberatTimeofRegistration_web', 'EN', 'Administrator', now(), false, 'Pregnancy Week Number at Time of Registration', false),
('US', 'Registeredwithin12WeekofPregnancy_web', 'EN', 'Administrator', now(), false, 'Registered within 12 Week of Pregnancy', false),
('US', 'PlaceName_web', 'EN', 'Administrator', now(), false, 'Place Name', false),
('US', 'PlaceType_web', 'EN', 'Administrator', now(), false, 'Place Type', false),
('US', 'DPTbooster2_web', 'EN', 'Administrator', now(), false, 'DPT booster 2', false),
('US', 'RotaVirus1_web', 'EN', 'Administrator', now(), false, 'Rota Virus 1', false),
('US', 'RotaVirus2_web', 'EN', 'Administrator', now(), false, 'Rota Virus 2', false),
('US', 'RotaVirus3_web', 'EN', 'Administrator', now(), false, 'Rota Virus 3', false),
('US', 'DPTbooster2(5yrs)_web', 'EN', 'Administrator', now(), false, 'DPT booster 2 (5 yrs)', false),
('US', 'TD(10yrs)_web', 'EN', 'Administrator', now(), false, 'TD (10 yrs)', false),
('US', 'TD(16yrs)_web', 'EN', 'Administrator', now(), false, 'TD (16 yrs)', false),
-- Gujarati Language
('IN', 'Measles1/MeaslesRubella1_web', 'GU', 'Administrator', now(), false, 'ઓરી 1/ઓરી રૂબેલા 1', false),
('IN', 'Measles2/MeaslesRubella2_web', 'GU', 'Administrator', now(), false, 'ઓરી 2/ઓરી રૂબેલા 2', false),
('US', 'PlaceNameofDelivery_web', 'GU', 'Administrator', now(), false, 'ડિલિવરીનું સ્થળ નામ', false),
('IN', 'PlaceTypeofDelivery_web', 'GU', 'Administrator', now(), false, 'ડિલિવરીનો સ્થળ પ્રકાર', false),
('IN', 'PregnancyWeekNumberatTimeofRegistration_web', 'GU', 'Administrator', now(), false, 'નોંધણી સમયે ગર્ભાવસ્થા સપ્તાહ નંબર', false),
('IN', 'Registeredwithin12WeekofPregnancy_web', 'GU', 'Administrator', now(), false, 'ગર્ભાવસ્થાના 12 અઠવાડિયાની અંદર નોંધાયેલ', false),
('IN', 'PlaceName_web', 'GU', 'Administrator', now(), false, 'સ્થળ નામ', false),
('IN', 'PlaceType_web', 'GU', 'Administrator', now(), false, 'સ્થળનો પ્રકાર', false),
('IN', 'DPTbooster2_web', 'GU', 'Administrator', now(), false, 'ડીપીટી બૂસ્ટર 2', false),
('IN', 'RotaVirus1_web', 'GU', 'Administrator', now(), false, 'રોટા વાયરસ 1', false),
('IN', 'RotaVirus2_web', 'GU', 'Administrator', now(), false, 'રોટા વાયરસ 2', false),
('IN', 'RotaVirus3_web', 'GU', 'Administrator', now(), false, 'રોટા વાયરસ 3', false),
('IN', 'DPTbooster2(5yrs)_web', 'GU', 'Administrator', now(), false, 'ડીપીટી બૂસ્ટર 2 (5 વર્ષ)', false),
('IN', 'TD(10yrs)_web', 'GU', 'Administrator', now(), false, 'ટી.ડી. (10 વર્ષ)', false),
('IN', 'TD(16yrs)_web', 'GU', 'Administrator', now(), false, 'ટી.ડી. (16 વર્ષ)', false)
ON conflict on constraint internationalization_label_master_pkey
DO NOTHING;
