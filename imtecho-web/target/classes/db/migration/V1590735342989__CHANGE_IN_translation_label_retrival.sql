DELETE FROM QUERY_MASTER WHERE CODE='translation_label_retrival';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'578b67fd-94cb-44f0-9e86-ff8ed9536f50', 1027,  current_date , 1027,  current_date , 'translation_label_retrival', 
'searchText,offset, LIMIT,startsWith', 
'SELECT labelMaster1.key AS KEY, labelMaster1.language AS LANGUAGE ,labelMaster2.text AS label ,labelMaster1.text ,CASE WHEN labelMaster1.language = ''EN'' THEN ''English'' ELSE ''Gujarati'' END AS languageToDisplay, labelMaster1.translation_pending AS "isTranslationPending",labelMaster1.custom3b AS "isMobileLabel" FROM internationalization_label_master AS labelMaster1 JOIN internationalization_label_master AS labelMaster2 ON labelMaster2.key = labelMaster1.key WHERE labelMaster2.language = ''EN'' AND (#startsWith# = ''null'' OR labelMaster2.text ilike CONCAT(#startsWith# , ''%'')) AND (#searchText# = ''null'' OR labelMaster2.text ilike CONCAT(''%'',#searchText# , ''%'')) ORDER BY labelMaster1.key LIMIT # LIMIT# offset #offset#', 
null, 
true, 'ACTIVE');