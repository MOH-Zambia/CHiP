update child_cmtc_nrc_admission_detail
set type_of_admission = 'NEW_ADMISSION'
where type_of_admission = 'New Admission';

update child_cmtc_nrc_admission_detail
set type_of_admission = 'RE_ADMISSION'
where type_of_admission = 'Re-admission';

update child_cmtc_nrc_admission_detail
set type_of_admission = 'RELAPSE'
where type_of_admission = 'Relapse';

update child_cmtc_nrc_admission_detail
set sd_score = 'SD4'
where sd_score = 'Less than -4';

update child_cmtc_nrc_admission_detail
set sd_score = 'SD3'
where sd_score = '-4 to -3';

update child_cmtc_nrc_admission_detail
set sd_score = 'SD2'
where sd_score = '-3 to -2';

update child_cmtc_nrc_admission_detail
set sd_score = 'SD1'
where sd_score = '-2 to -1';

update child_cmtc_nrc_admission_detail
set apetite_test = 'NOT_CONDUCTED'
where apetite_test = 'NOTCONDUCTED';

update child_cmtc_nrc_discharge_detail
set sd_score = 'SD4'
where sd_score = 'Less than -4';

update child_cmtc_nrc_discharge_detail
set sd_score = 'SD3'
where sd_score = '-4 to -3';

update child_cmtc_nrc_discharge_detail
set sd_score = 'SD2'
where sd_score = '-3 to -2';

update child_cmtc_nrc_discharge_detail
set sd_score = 'SD1'
where sd_score = '-2 to -1';

update child_cmtc_nrc_discharge_detail
set discharge_status = 'SAM_TO_NORMAL'
where discharge_status = 'SAM TO NORMAL';

update child_cmtc_nrc_discharge_detail
set discharge_status = 'SAM_TO_MAM'
where discharge_status = 'SAM TO MAM';

update child_cmtc_nrc_discharge_detail
set discharge_status = 'SAM_TO_SAM'
where discharge_status = 'SAM TO SAM';

update child_cmtc_nrc_follow_up
set sd_score = 'SD4'
where sd_score = 'Less than -4';

update child_cmtc_nrc_follow_up
set sd_score = 'SD3'
where sd_score = '-4 to -3';

update child_cmtc_nrc_follow_up
set sd_score = 'SD2'
where sd_score = '-3 to -2';

update child_cmtc_nrc_follow_up
set sd_score = 'SD1'
where sd_score = '-2 to -1';

update child_cmtc_nrc_follow_up
set program_output = 'NON_RESPONDANT'
where program_output = 'NONRESPONDANT';

update child_cmtc_nrc_follow_up
set program_output = 'MEDICAL_TRANSFER'
where program_output = 'MEDICAL TRANSFER';

update child_cmtc_nrc_follow_up
set program_output = 'DEFAULTER_LAMA'
where program_output = 'DEFAULTER';

update child_cmtc_nrc_laboratory_detail
set urine_albumin = 'NOT_PRESENT'
where urine_albumin = 'NOT PRESENT';

update child_cmtc_nrc_laboratory_detail
set hiv = 'REACTIVE'
where hiv = 'reactive';

update child_cmtc_nrc_laboratory_detail
set hiv = 'NON_REACTIVE'
where hiv = 'nonreactive';

update child_cmtc_nrc_laboratory_detail
set sickle = 'POSITIVE'
where sickle = 'positive';

update child_cmtc_nrc_laboratory_detail
set sickle = 'NEGATIVE'
where sickle = 'negative';

update child_cmtc_nrc_laboratory_detail
set ps_for_mp = 'POSITIVE'
where ps_for_mp = 'positive';

update child_cmtc_nrc_laboratory_detail
set ps_for_mp = 'NEGATIVE'
where ps_for_mp = 'negative';

update child_cmtc_nrc_laboratory_detail
set monotoux_test = 'POSITIVE'
where monotoux_test = 'positive';

update child_cmtc_nrc_laboratory_detail
set monotoux_test = 'NEGATIVE'
where monotoux_test = 'negative';

update child_cmtc_nrc_laboratory_detail
set blood_group = 'NOT_AVAILABLE'
where blood_group = 'NOT AVAILABLE';

delete from child_cmtc_nrc_admission_illness_detail where illness = 'NONE';
delete from child_cmtc_nrc_discharge_illness_detail where illness = 'NONE';
delete from child_cmtc_nrc_follow_up_illness_detail where illness = 'NONE';

update child_cmtc_nrc_admission_illness_detail
set illness = 'ANEMIA'
where illness = 'Anemia';

update child_cmtc_nrc_admission_illness_detail
set illness = 'RESPIRATORY_ILLNESS'
where illness = 'Respiratory';

update child_cmtc_nrc_admission_illness_detail
set illness = 'EYE_INFECTION'
where illness = 'Eye';

update child_cmtc_nrc_admission_illness_detail
set illness = 'MEASLES_RUBELLA'
where illness = 'Measles';

update child_cmtc_nrc_admission_illness_detail
set illness = 'BACTERIAL_INFECTION'
where illness = 'Bacterial';

update child_cmtc_nrc_admission_illness_detail
set illness = 'JAUNDICE'
where illness = 'Jaundice';

update child_cmtc_nrc_admission_illness_detail
set illness = 'DIARRHOEA'
where illness = 'Diarrhoea';

update child_cmtc_nrc_admission_illness_detail
set illness = 'DEHYDRATION'
where illness = 'Dehydration';

update child_cmtc_nrc_admission_illness_detail
set illness = 'DYSENTRY'
where illness = 'Dysentry';

update child_cmtc_nrc_admission_illness_detail
set illness = 'MALARIA'
where illness = 'Malaria';

update child_cmtc_nrc_admission_illness_detail
set illness = 'FEVER'
where illness = 'Fever';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'ANEMIA'
where illness = 'Anemia';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'RESPIRATORY_ILLNESS'
where illness = 'Respiratory';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'EYE_INFECTION'
where illness = 'Eye';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'MEASLES_RUBELLA'
where illness = 'Measles';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'BACTERIAL_INFECTION'
where illness = 'Bacterial';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'JAUNDICE'
where illness = 'Jaundice';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'DIARRHOEA'
where illness = 'Diarrhoea';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'DEHYDRATION'
where illness = 'Dehydration';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'DYSENTRY'
where illness = 'Dysentry';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'MALARIA'
where illness = 'Malaria';

update child_cmtc_nrc_discharge_illness_detail
set illness = 'FEVER'
where illness = 'Fever';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'ANEMIA'
where illness = 'Anemia';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'RESPIRATORY_ILLNESS'
where illness = 'Respiratory';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'EYE_INFECTION'
where illness = 'Eye';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'MEASLES_RUBELLA'
where illness = 'Measles';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'BACTERIAL_INFECTION'
where illness = 'Bacterial';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'JAUNDICE'
where illness = 'Jaundice';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'DIARRHOEA'
where illness = 'Diarrhoea';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'DEHYDRATION'
where illness = 'Dehydration';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'DYSENTRY'
where illness = 'Dysentry';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'MALARIA'
where illness = 'Malaria';

update child_cmtc_nrc_follow_up_illness_detail
set illness = 'FEVER'
where illness = 'Fever';