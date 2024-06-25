-- update queary created to modify internationalization label

update internationalization_label_master
set "text" = 'Do you have fever with chills and sweating, daily or on alternate days?', modified_on = now()
where "key" = 'Doyouhavefeverwithchillsandsweating,dailyoronalternatedays?' and "language" = 'EN';
