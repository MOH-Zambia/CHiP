DELETE FROM query_master where code='mytecho_cards_conf_retrieval_by_id';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_cards_conf_retrieval_by_id', 'cardId', 'select mt_config.id as "id" , 
mt_language_config.tittle as "title", 
mt_language_config.button_text as "buttonText",
mt_config.category_id as "category_id",
mt_config.component_type as "componentType",
mt_language_config.description as "description",
mt_language_config.language as "language",
mt_language_config.url as "mediaUrl",
CAST(''thumbnail.jpg'' as text) as "thumbnail",
case when (mt_language_config.url is null or mt_language_config.url = ''null'')
		then ''SYSTEM'' else ''URL'' end as "mediaType",
cast(lv.code as int) as "catagory_order"
from mytecho_timeline_language_wise_config_det mt_language_config 
inner join mytecho_timeline_config_det mt_config on mt_config.id = mt_language_config.mt_timeline_config_id 
left join listvalue_field_value_detail lv on lv.id = mt_config.category_id
where mt_config.id = #cardId#;', true, 'ACTIVE', NULL);
