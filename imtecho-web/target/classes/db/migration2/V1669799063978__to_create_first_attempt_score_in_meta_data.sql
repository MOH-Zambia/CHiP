with first_attempt_scores as (
    select distinct on (
        tr_question_set_configuration.ref_id,
        tr_question_set_configuration.ref_type,
        tr_question_set_configuration.question_set_type,
        tr_question_set_answer.user_id
    )
    tr_question_set_configuration.ref_id,
    tr_question_set_configuration.ref_type,
    tr_question_set_configuration.question_set_type,
    tr_question_set_answer.user_id,
    tr_question_set_answer.marks_scored,
    tr_question_set_configuration.course_id
    from tr_question_set_answer
    inner join tr_question_set_configuration on tr_question_set_answer.question_set_id = tr_question_set_configuration.id
    order by tr_question_set_configuration.ref_id,
    tr_question_set_configuration.ref_type,
    tr_question_set_configuration.question_set_type,
    tr_question_set_answer.user_id,
    tr_question_set_answer.created_on
),json_data as (
    select tr_user_meta_data.user_id,
    tr_user_meta_data.course_id,
    cast(quiz_meta_data as jsonb) as quiz_meta_data
    from tr_user_meta_data
),quiz_details as (
    select user_id,
    course_id,
    jsonb_array_elements(quiz_meta_data) as quiz_json,
    cast(jsonb_array_elements(quiz_meta_data) ->> 'quizRefId' as integer) as reference_id,
    jsonb_array_elements(quiz_meta_data) ->> 'quizRefType' as reference_type,
    cast(jsonb_array_elements(quiz_meta_data) ->> 'quizTypeId' as integer) as set_type,
    cast(jsonb_array_elements(quiz_meta_data) ->> 'scoreInFirstAttempt' as integer) as first_score
    from json_data
),details as (
    select quiz_details.*,
    first_attempt_scores.marks_scored
    from quiz_details
    inner join first_attempt_scores on quiz_details.user_id = first_attempt_scores.user_id
    and quiz_details.course_id = first_attempt_scores.course_id
    and quiz_details.reference_id = first_attempt_scores.ref_id
    and quiz_details.reference_type = first_attempt_scores.ref_type
    and quiz_details.set_type = first_attempt_scores.question_set_type
),records as (
    select user_id,course_id,
    cast(jsonb_agg(quiz_json || jsonb_build_object('scoreInFirstAttempt',details.marks_scored)) as text) as new_json
    from details
    group by user_id,course_id
)update tr_user_meta_data
set quiz_meta_data = records.new_json
from records
where tr_user_meta_data.user_id = records.user_id
and tr_user_meta_data.course_id = records.course_id