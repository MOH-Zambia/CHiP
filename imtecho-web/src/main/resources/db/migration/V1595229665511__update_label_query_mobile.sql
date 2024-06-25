update query_master set query = '
SELECT country, key, language, created_by,
case when modified_on is null then cast(cast(extract(epoch from created_on) * 1000 - 19800000 as bigint) as text)
when modified_on is not null then cast(cast(extract(epoch from modified_on) * 1000 - 19800000 as bigint) as text) end
as created_on, true as custom3b, text, translation_pending
FROM public.internationalization_label_master
where (created_on >= ''#createdOn#'' or modified_on >= ''#createdOn#'')
and language = ''#preferedLanguage#'' and app_name = ''TECHO_MOBILE_APP'' order by created_on
'
where code = 'translation_mobile_label_retrival_after_date';
