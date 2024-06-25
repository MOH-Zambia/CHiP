UPDATE public.query_master
   SET query='INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES (''IN'', REPLACE(''#text#'','' '',''''), ''EN'',#createdBy#, ''#createdOn#'', #isMobileLabel#,''#text#'',false );
INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES (''IN'', REPLACE(''#text#'','' '',''''), ''GU'',#createdBy#, ''#createdOn#'', #isMobileLabel#,''#text#'',true );'
 WHERE code='translation_label_add';

UPDATE public.query_master
   SET query='UPDATE public.internationalization_label_master SET custom3b=#isMobileLabel#, text =''#text#'', translation_pending=#isTranslationPending# WHERE key = ''#oldKey#'' and language=''#language#'';',
 params='isMobileLabel,text,isTranslationPending,oldKey,language'
WHERE code='translation_label_update';

