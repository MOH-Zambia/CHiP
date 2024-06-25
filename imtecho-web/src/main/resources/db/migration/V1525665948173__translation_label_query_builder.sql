INSERT INTO public.query_master(
             created_by, created_on, code, params, 
            query, returns_result_set, state)
    VALUES ( 1, localtimestamp,'translation_label_add', 'text,language,createdBy,createdOn,isMobileLabel,text,isTranslationPending', 
            'INSERT INTO public.internationalization_label_master(country, key, language, created_by, created_on, custom3b, text, translation_pending) VALUES (''IN'', REPLACE(''#text#'','' '',''''), ''#language#'',#createdBy#, ''#createdOn#'', #isMobileLabel#,''#text#'',#isTranslationPending# );', false,'ACTIVE');


INSERT INTO public.query_master(
             created_by, created_on, code, params, 
            query, returns_result_set, state)
    VALUES ( 1, localtimestamp,'translation_label_retrival', 'onlyMobile,onlyMobile,isPending,isPending,language,language,startsWith,startsWith,searchText,searchText,limit,offset', 
            'select labelMaster1.key as key, labelMaster1.language as language ,labelMaster2.text as label ,labelMaster1.text ,case when labelMaster1.language=''EN'' then ''English'' else ''Gujarati'' end as languageToDisplay,labelMaster1.translation_pending as "isTranslationPending", labelMaster1.custom3b as "isMobileLabel" from internationalization_label_master as labelMaster1 join internationalization_label_master as labelMaster2 on labelMaster2.key = labelMaster1.key where labelMaster2.language=''EN'' and (#onlyMobile# is null or labelMaster1.custom3b=#onlyMobile#) and (#isPending# is null or labelMaster1.translation_pending=#isPending#) and (''#language#'' = ''null'' or labelMaster1.language=''#language#'' ) and (''#startsWith#'' = ''null'' or labelMaster2.text ilike ''#startsWith#%'') and (''#searchText#'' = ''null'' or labelMaster2.text ilike ''%#searchText#%'') limit #limit# offset #offset#', true,'ACTIVE');

INSERT INTO public.query_master(
             created_by, created_on, code, params, 
            query, returns_result_set, state)
    VALUES ( 1, localtimestamp,'translation_label_update', 'isMobileLabel,text,isTranslationPending,oldKey', 
            'UPDATE public.internationalization_label_master SET custom3b=#isMobileLabel#, text =''#text#'', translation_pending=#isTranslationPending# WHERE key = ''#oldKey#'';', true,'ACTIVE');


