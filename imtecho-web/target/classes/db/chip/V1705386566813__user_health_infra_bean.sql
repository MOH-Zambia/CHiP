insert into mobile_beans_master(bean, depends_on_last_sync)
select bean, depends_on_last_sync
from
(
	values
		('UserHealthInfraBean', true)
) as feature(bean, depends_on_last_sync);


insert into mobile_beans_feature_rel(bean, feature)
select bean, feature
from (
    values
        ('CBV_MY_PEOPLE', 'UserHealthInfraBean'),
        ('HOUSE_HOLD_LINE_LIST', 'UserHealthInfraBean')
) as f(feature, bean);
