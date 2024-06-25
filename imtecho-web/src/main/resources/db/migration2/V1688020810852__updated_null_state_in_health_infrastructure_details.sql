update
    health_infrastructure_details
set
    state = 'ACTIVE',
    modified_on = now()
where
    state is null
