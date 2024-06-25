UPDATE public.query_master
   SET query='UPDATE public.internationalization_label_master SET custom3b=#isMobileLabel#, text =''#text#'', translation_pending=#isTranslationPending#, created_on=current_date,modified_on=current_date
 WHERE key = ''#oldKey#'' and language=''#language#'';',
 params='isMobileLabel,text,isTranslationPending,oldKey,language'
WHERE code='translation_label_update';

INSERT INTO public.query_master(
             created_by, created_on, code, params, 
            query, returns_result_set, state)
    VALUES ( 1, localtimestamp,'translation_mobile_label_retrival_after_date', 'createdOn,preferedLanguage', 
            'SELECT country, key, language, created_by, created_on, custom3b, text, translation_pending
  FROM public.internationalization_label_master
  where created_on >=''#createdOn#''  and language =''#preferedLanguage#'' and custom3b =true
  order by created_on', true,'ACTIVE');


ALTER TABLE public.internationalization_label_master
  ADD COLUMN modified_on timestamp without time zone;

-- migration for modified on data
UPDATE public.internationalization_label_master
   SET modified_on=created_on;


