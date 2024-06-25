create table if not exists user_basket_preference
(
	id bigserial primary key,
        user_id bigint not null,
	preference text not null
)