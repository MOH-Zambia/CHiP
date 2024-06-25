DELETE FROM QUERY_MASTER WHERE CODE='translation_mobile_label_retrival_after_date';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9b6fb25c-b70a-4d8a-9041-0fd6724e5011', 97071,  current_date , 97071,  current_date , 'translation_mobile_label_retrival_after_date',
'givenLanguage,preferedLanguage,createdOn',
'with language_det as (
	select id, language_key
	from language_master where language_key ilike ''#preferedLanguage#''
)
SELECT tm.key as key, tm.created_by,
CASE
        WHEN ''#givenLanguage#'' != ''null'' THEN ''#givenLanguage#''
        ELSE ld.language_key
    END AS language,
cast(cast(extract(epoch from tm.modified_on) * 1000 - 19800000 as bigint) as text)
as created_on, true as custom3b, tm.value as text
FROM translation_master tm inner join language_det ld on tm."language" = ld.id
where tm.modified_on >= ''#createdOn#''
and tm.is_active is true and app = (select id from app_master am where app_key = ''TECHO_MOBILE_APP'')
order by created_on',
null,
true, 'ACTIVE');