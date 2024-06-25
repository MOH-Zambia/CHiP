
INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Manage Translator','admin',TRUE,'techo.manage.translator-label','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Manage Values And Multimedia','admin',TRUE,'techo.manage.valuesnmultimedia','{}');


update query_master set query = 'UPDATE public.internationalization_label_master SET custom3b=#isMobileLabel#, text =''#text#'', translation_pending=#isTranslationPending#,modified_on=now()
 WHERE key = ''#oldKey#'' and language=''#language#'';' where code = 'translation_label_update';



update query_master set params = 'createdBy,isMobileLabel,text',query = 'INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
VALUES (''IN'', REPLACE(''#text#'','' '',''''), ''EN'', #createdBy# , now(), #isMobileLabel# , ''#text#'' ,false );

INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
VALUES (''IN'', REPLACE(''#text#'','' '',''''), ''GU'', #createdBy# , now(), #isMobileLabel#, ''#text#'',true );' where code = 'translation_label_add';
