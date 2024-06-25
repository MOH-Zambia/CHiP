UPDATE public.query_master
   SET query='INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) 
VALUES (''IN'', REPLACE(''#label#'','' '',''), ''#language#'', #createdBy# , now(), #isMobileLabel# , ''#text#'' ,false );'
 WHERE code='translation_label_add';
